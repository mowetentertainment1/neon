#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")/.."

function find_apis() {
    path="$1"
    grep -r "$path" --include "*\.dart" -e "client\.[^.]*.[^(]*(" -oh | sed "s/^client\.//" | sed "s/($//" | sed "s/Raw$//" | sort | uniq
}

used_apis=("$(find_apis "packages/neon")")
tested_apis=("$(find_apis "packages/nextcloud")")

untested_apis=()

for used_api in ${used_apis[*]}; do
  tested=0

  for tested_api in ${tested_apis[*]}; do
    if [[ "$tested_api" == "$used_api" ]]; then
      tested=1
      break
    fi
  done

  if [[ "$tested" == 0 ]]; then
    untested_apis+=("$used_api")
  fi
done

if [[ -n "${untested_apis[*]}" ]]; then
  printf "%s\n" "${untested_apis[@]}"
  exit 1
fi