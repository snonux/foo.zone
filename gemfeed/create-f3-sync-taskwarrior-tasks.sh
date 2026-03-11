#!/usr/bin/env bash
set -euo pipefail

project_name() {
  basename -s .git "$(git remote get-url origin 2>/dev/null)" 2>/dev/null || \
    basename "$(git rev-parse --show-toplevel)"
}

PROJECT="$(project_name)"
PLAN_PATH="/home/paul/git/foo.zone-content/gemtext/gemfeed/f3-sync-plan.md"
TASK_FILTER="project:${PROJECT} +agent +f3sync"
COMMON_TAGS=(project:"${PROJECT}" +agent +f3sync +ops)
AGENT_ANNOTATION="Agent: be aware of taskwarrior-task-management skill. When working on this task, also load and apply: (1) the best-practices skill for the programming language used in the project, (2) solid-principles, and (3) beyond-solid-principles. When all tests and sub-agent reviews pass, automatically progress to the next task in the list."
PLAN_ANNOTATION="Plan: ${PLAN_PATH}"
REFS_ANNOTATION="Refs: ${PLAN_PATH}; 2024-12-03-f3s-kubernetes-with-freebsd-part-2.gmi.tpl; 2025-02-01-f3s-kubernetes-with-freebsd-part-3.gmi.tpl; 2025-04-05-f3s-kubernetes-with-freebsd-part-4.gmi.tpl; 2025-05-11-f3s-kubernetes-with-freebsd-part-5.gmi.tpl; 2025-07-14-f3s-kubernetes-with-freebsd-part-6.gmi.tpl; 2025-10-02-f3s-kubernetes-with-freebsd-part-7.gmi.tpl; 2025-12-07-f3s-kubernetes-with-freebsd-part-8.gmi.tpl"

if ! command -v task >/dev/null 2>&1; then
  echo "task command not found" >&2
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  echo "git command not found" >&2
  exit 1
fi

if [[ ! -f "${PLAN_PATH}" ]]; then
  echo "plan file not found: ${PLAN_PATH}" >&2
  exit 1
fi

existing_count="$(task ${TASK_FILTER} count 2>/dev/null | tr -dc '0-9')"
if [[ -n "${existing_count}" && "${existing_count}" != "0" && "${FORCE:-0}" != "1" ]]; then
  echo "Existing f3 sync tasks already present for project ${PROJECT}." >&2
  echo "Filter: ${TASK_FILTER}" >&2
  echo "Re-run with FORCE=1 to create another set." >&2
  exit 1
fi

extract_id() {
  sed -n 's/Created task \([0-9][0-9]*\).*/\1/p'
}

add_task() {
  local description="$1"
  local depends_arg="${2:-}"
  local output
  local id

  if [[ -n "${depends_arg}" ]]; then
    output="$(task "${COMMON_TAGS[@]}" add "${description}" "depends:${depends_arg}")"
  else
    output="$(task "${COMMON_TAGS[@]}" add "${description}")"
  fi

  id="$(printf '%s\n' "${output}" | extract_id)"
  if [[ -z "${id}" ]]; then
    echo "failed to parse task id from output:" >&2
    printf '%s\n' "${output}" >&2
    exit 1
  fi

  task project:"${PROJECT}" +agent "${id}" annotate "${AGENT_ANNOTATION}" >/dev/null
  task project:"${PROJECT}" +agent "${id}" annotate "${PLAN_ANNOTATION}" >/dev/null
  task project:"${PROJECT}" +agent "${id}" annotate "${REFS_ANNOTATION}" >/dev/null
  task project:"${PROJECT}" +agent "${id}" annotate "UUID: $(task project:"${PROJECT}" +agent "${id}" _uuid)" >/dev/null

  printf '%s\n' "${id}"
}

echo "Creating Taskwarrior tasks for project ${PROJECT}"
echo "Using plan ${PLAN_PATH}"

id1="$(add_task "f3 sync: install FreeBSD on f3 and obtain initial access" "")"
id2="$(add_task "f3 sync: convert f3 from DHCP to static LAN networking in rc.conf" "${id1}")"
id3="$(add_task "f3 sync: apply the common FreeBSD baseline on f3" "${id2}")"
id4="$(add_task "f3 sync: update /etc/hosts on FreeBSD, Rocky, OpenBSD, and admin systems for f3" "${id3}")"
id5="$(add_task "f3 sync: configure apcupsd on f3 like f2 using f0 as UPS master" "${id4}")"
id6="$(add_task "f3 sync: add f3 to the WireGuard mesh and assign 192.168.2.133 and fd42:beef:cafe:2::133" "${id4},${id5}")"
id7="$(add_task "f3 sync: mirror the real local storage layout of f2 on f3 without introducing zrepl" "${id6}")"
id8="$(add_task "f3 sync: configure vm-bhyve and the optional host-local Rocky VM on f3 if f2 has it" "${id3},${id6},${id7}")"
id9="$(add_task "f3 sync: install node_exporter on f3 and add Prometheus scrape config" "${id6}")"
id10="$(add_task "f3 sync: mirror required local FreeBSD service users from f2 onto f3" "${id3},${id7}")"
id11="$(add_task "f3 sync: run final end-to-end validation for f3 rollout" "${id2},${id3},${id4},${id5},${id6},${id7},${id8},${id9},${id10}")"

cat <<EOF
Created tasks:
  ${id1}  install FreeBSD on f3 and obtain initial access
  ${id2}  convert f3 from DHCP to static LAN networking in rc.conf
  ${id3}  apply the common FreeBSD baseline on f3
  ${id4}  update /etc/hosts on all involved systems
  ${id5}  configure apcupsd on f3
  ${id6}  add f3 to the WireGuard mesh
  ${id7}  mirror the real local storage layout of f2 on f3
  ${id8}  configure vm-bhyve and optional host-local Rocky VM on f3
  ${id9}  install node_exporter on f3 and update Prometheus
  ${id10} mirror required local FreeBSD service users onto f3
  ${id11} final end-to-end validation

List them with:
  task ${TASK_FILTER} list
EOF
