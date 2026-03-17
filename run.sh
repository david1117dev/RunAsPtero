#!/usr/bin/env bash
# shellcheck disable=SC2034

b="\033[38;5;38m"
y="\x1b[33m"
g="\x1b[32m"
w="\x1b[37m"
r="\x1b[31m"
reset="\x1b[0m"

if [[ "${1:-}" == "" || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  echo -e "Usage: $0 <image> [command]"
  if [[ "${1:-}" == "" ]]; then
    exit 1
  fi
  exit 0
fi

if [[ "${3:-}" != "" ]]; then
  echo -e " ${r}●${w} Too many arguments."
  echo -e " ${w}  Usage: $0 <image> [command]"
  exit 1
fi

image="$1"

if [[ ! -d "./.runasptero-data" ]]; then
  mkdir -p -m 0777 ./.runasptero-data
fi

sudo chown -R 999:999 ./.runasptero-data

if [[ "$image" =~ ^[^/]+\.[^/]+(:[0-9]+)?/ ]] || \
   ! docker image inspect "$image" >/dev/null 2>&1; then
  docker pull "$image" || exit 1
fi

if [[ -f "./.runasptero" ]]; then
  sed -e 's/^[[:space:]]*export[[:space:]]\+//' \
      -e 's/^[[:space:]]*//' \
      -e 's/[[:space:]]*$//' "./.runasptero" \
    | grep -v -E '^(#|$)' > "/tmp/runasptero"
else
  cat <<EOF > "/tmp/runasptero"
TZ=UTC
SERVER_MEMORY=10240
SERVER_PORT=1117
SERVER_IP=10.17.1.1
P_SERVER_LOCATION=DevLand
P_SERVER_UUID=87d2b0e0-3c25-424e-b403-ea787d562fd1
P_SERVER_ALLOCATION_LIMIT=10
STARTUP="bash"
HOME=/home/container
EOF
fi

docker run --rm -it \
  --read-only \
  --workdir /home/container \
  --tmpfs /tmp:rw,exec,nosuid,size=100M \
  -v "$(pwd)/.runasptero-data":/home/container:rw \
  --env-file /tmp/runasptero \
  --cap-drop ALL \
  --security-opt no-new-privileges \
  --pids-limit 512 \
  --user 999:999 \
  "${image}" "${@:2}"
