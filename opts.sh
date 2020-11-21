#!/usr/bin/env bash
num="[-+]?[0-9]*\.?[0-9]+"
STACK=()

function show_usage() {
  printf "Usage: $0 [options [parameters]]\n"
  printf "\n"
  printf "Options:\n"
  printf "   bin [number]          Translate [number] to binary\n"
  printf "   fac [number]          Calculate factorial of [number]\n"
  printf "   dupl [number]         Duplicate [number] \n"
  printf "   pi [number]           Get pi to [number] decimal places \n"
  printf "   -h|--help             Print help\n"

  return 0
}

function is_number() {
  echo "start of is_number"
  # Trim leading and extranneous 0s
  strip="${1#"${1%%[!0]*}"}"
  if [[ "${strip}" =~ "0" ]]; then
    shift
  fi &&
    if [[ "${strip}" =~ $num ]]; then
      echo "num check"
      # DONE Strip special characters, preserve floats
      strip=$(echo $strip 2>/dev/null | tr -dc "0-9.")
      STACK+=("${strip}") || STACK+=("${1}")
      # STACK=($strip "${STACK[@]}")
    fi
}

function bin() {
  local num=$1
  echo "obase=2;$num" | bc
}

function fac() {
  local num=$1
  factorial=1
  for ((i = 1; i <= $num; i++)); do
    factorial=$(($factorial * $i))
  done
  echo "${factorial}"
}

function dupl() {
  local num=$1
  echo "${num}" "${num}"
}

function pi() {
  local scale=$1
  export BC_LINE_LENGTH=0
  pi=$(bc -lq <<<"scale=${scale};4*a(1)")
  echo "${pi}"
}

if [[ $# -eq 0 ]]; then
  show_usage
  exit 0
fi

while [ "$#" -gt 0 ]; do
  # while ! [[ "$1" =~ ^[0-9]+$ ]]; do
  for i in $@; do
    echo "start of for $1"
    case "$1" in
    "bin")
      # shift
      # is_number "$1"
      # bin "$1"
      # shift
      echo "bin"
      shift
      ;;
    "bin":"boon")
      # shift
      # is_number "$1"
      # bin "$1"
      # shift
      echo "bin boon"
      shift
      ;;
    "fac")
      shift
      is_number "$1"
      fac "$1"
      ;;
    "dupl")
      shift
      is_number "$1"
      dupl "$1"
      ;;
    "pi")
      shift
      is_number "$1"
      pi "$1"
      ;;
    *)
      echo "start of default check"
      is_number "$1"
      shift
      ;;
    esac
  done
  echo -n "STACK ${STACK[@]}" "> "
done
read

# while [[ "$1" =~ ^[0-9]+$ ]]; do
#   for i in $@; do
#     is_number "$i"
#     echo ${STACK}
#   done
#   shift $#
# done
