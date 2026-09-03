#!/usr/bin/env bash
#
# Batch entrypoint for RUNBOOK.md: one `claude -p` session per (persona, prompt)
# pair. RUNBOOK.md fixes exactly one pair per invocation, and README.md's
# "Rules that keep results meaningful" requires each to run in its own cold
# session — so this loops over *processes*, never inside one session. Anything
# that batches pairs into a single session breaks the comparability the fixed
# pairs exist to protect.
#
#   ./scripts/run-all-personas.sh                 # all 36 pairs
#   ./scripts/run-all-personas.sh 07              # persona 07, prompts A/B/C
#   ./scripts/run-all-personas.sh 07 B            # one pair
#   ./scripts/run-all-personas.sh '' '' stable    # all pairs, non-default version
#   DRY_RUN=1 ./scripts/run-all-personas.sh       # print the invocations, run nothing
#
# A non-default version is a deliberate, separate audit — see RUNBOOK.md's
# cadence note before mixing one into a regular series.
#
# Each run writes its own report under answers/<NN>-<slug>/, appends a row to
# answers/index.md and the persona's README.md, and commits in this repo. None
# of them push: that stays an explicit decision, per RUNBOOK.md step 7.

set -uo pipefail
# An unmatched glob must expand to nothing, so the persona-folder check below
# can count matches instead of testing a literal leftover pattern.
shopt -s nullglob

cd "$(dirname "$0")/.."

persona_arg=${1:-}
prompt_arg=${2:-}
version=${3:-}

if [ -n "$persona_arg" ]; then
	personas=("$persona_arg")
else
	personas=()
	for d in personas/[0-9][0-9]-*/; do
		personas+=("$(basename "$d" | cut -d- -f1)")
	done
fi

if [ -n "$prompt_arg" ]; then
	prompts=("$prompt_arg")
else
	prompts=(A B C)
fi

failed=()
for p in "${personas[@]}"; do
	for x in "${prompts[@]}"; do
		# RUNBOOK.md step 2: exactly one persona folder must match the prefix.
		matches=(personas/"$p"-*/)
		if [ ${#matches[@]} -ne 1 ]; then
			echo "expected exactly one personas/$p-*/ folder, found ${#matches[@]}" >&2
			exit 1
		fi
		if [ ! -f "${matches[0]}prompt$x.md" ]; then
			echo "no prompt$x.md in ${matches[0]}" >&2
			exit 1
		fi

		task="Follow RUNBOOK.md in the docs-eval repo. persona=$p prompt=$x"
		[ -n "$version" ] && task="$task version=$version"

		if [ -n "${DRY_RUN:-}" ]; then
			echo "claude -p --permission-mode acceptEdits \"$task\""
			continue
		fi

		echo "=== $task ==="
		# Keep going on failure: one bad pair shouldn't cost the whole pass.
		claude -p --permission-mode acceptEdits "$task" || failed+=("persona=$p prompt=$x")
	done
done

if [ ${#failed[@]} -gt 0 ]; then
	printf 'failed: %s\n' "${failed[@]}" >&2
	exit 1
fi
