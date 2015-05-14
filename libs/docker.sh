#!/bin/bash

# Purpose: Docker utils
# Author : Anh K. Huynh
# Date   : 2015 May 04th
# Ref.   : Feature request at https://github.com/docker/docker/issues/12791

# Return IP address of a docker container
# Input : $1: Docker container ID / name
# Output: The IP address
docker_to_ip() {
  docker inspect --format='{{.NetworkSettings.IPAddress}}' $1
}

# Return iptables (NAT) rules for a running container
# Input : Container ID/Name
# Output: iptables commands
docker_container_to_nat() {
  local _ip=
  local _id="${1:-xxx}"

  _ip="$(docker_to_ip $_id)"
  [[ $? -eq 0 ]] || return $?

  docker inspect \
    --format='{{range $p, $conf := .NetworkSettings.Ports}} {{if $conf}} {{printf "%s/%s\n" (index $conf 0).HostPort $p}} {{end}} {{end}}' \
    $_id \
  | grep /\
  | awk \
      -F/\
      -vIP=$_ip \
      -vCONTAINER_ID=$_id \
      '{
        printf("iptables -t nat -C POSTROUTING -s %s/32 -d %s/32 -p tcp -m tcp --dport %s -j MASQUERADE 2>/dev/null \\\n", IP, IP, $2);
        printf("|| iptables -t nat -A POSTROUTING -s %s/32 -d %s/32 -p tcp -m tcp --dport %s -j MASQUERADE\n", IP, IP, $2);

        printf("iptables -t nat -C DOCKER ! -i docker0 -p tcp -m tcp --dport %s -j DNAT --to-destination %s:%s 2>/dev/null \\\n", $1, IP, $2);
        printf("|| iptables -t nat -A DOCKER ! -i docker0 -p tcp -m tcp --dport %s -j DNAT --to-destination %s:%s\n", $1, IP, $2);

        printf("iptables -C DOCKER -d %s/32 ! -i docker0 -o docker0 -p tcp -m tcp --dport %s -j ACCEPT 2>/dev/null \\\n", IP, $2);
        printf("|| iptables -A DOCKER -d %s/32 ! -i docker0 -o docker0 -p tcp -m tcp --dport %s -j ACCEPT\n", IP, $2);
      }'
}

# Return iptables (NAT) rules for all running containers
# Input : NONE
# Output: all iptables rules for running container
docker_containers_to_nat() {
  while read CONTAINER_ID; do
    echo >&2 ":: docker/firewall: Generating rule for $CONTAINER_ID..."
    docker_container_to_nat $CONTAINER_ID
  done < <(docker ps -q)
}

docker_images_clean() {
  docker rmi -f \
    $(docker images \
    | grep '^<none' \
    | awk '{print $3}')
}

# Return uptime of a container in minutes
# $1: container id
# If `$1` is missing, return system uptime
# NOTE: accessing to /proc/ is required.
docker_uptime() {
  local _pid="1"

  if [[ -n "${1:-}" ]]; then
    _pid="$(docker inspect --format='{{.State.Pid}}' "$1" 2>/dev/null)"
  fi
  if [[ -z "$_pid" || "$_pid" == 0 ]]; then
    echo 0
    return
  fi

  ps h -oetime "$_pid" \
  | awk '{ match($0, /([0-9]+-)?(([0-9]+):)?([0-9]+):([0-9]+)/, m); printf("%d\n", (m[1]*24 + m[3])*60 + m[4] + m[5]/60); }'
}
