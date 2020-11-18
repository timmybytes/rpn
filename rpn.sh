#!/usr/bin/env bash
# title          :rpn.sh
# description    :A Reverse Polish Notation calculator
# author         :Timothy Merritt
# date           :2020-11-17
# version        :0.1.0
# usage          :./rpn.sh
# bash_version   :5.0.18(1)-release
#============================================================================
# goals          :
#                * Design and build a small product
#                * Show awareness of unix command line culture,
#                  convention, and user expectations
#                * Support interactive use cases as well as
#                  programmatic use cases involving pipelines and redirection
#                * Think through human-computer-interface concerns
#                  and make a tool that is pleasant, intuitive, and flexible
#                * Deliver something at a reasonably high degree of polish
#                * Have some fun, and learn some new things
#============================================================================
# requirements   :
#                * An command line tool called rpn written in the
#                  programming language of your choice
#                * The command line tool should operate like other
#                  unix command line tools.
#                * Package it so it can be easily built/run on common
#                  unix systems (linux, mac os x)
#                * Feel free to use the internet as a resource, but write
#                  your own code, do not consult others, do not share code
#                  with other candidates, do not plagiarize.
#                * Do not publish your work on the internet.
#============================================================================

quit="q"
num="^[0-9]+$"
STACK=()

function help() {
  printf "rpn v${VERSION}"
}

function is_number() {
  if [[ "${1}" =~ $num ]]; then
    # Trim leading 0s before adding to STACK
    strip="${1#"${1%%[!0]*}"}"
    STACK+=("${strip}") || STACK+=("${1}")
    shift
  fi
}

function calc() {
  op=$1
  if [ "$op" = "^" ]; then
    op="*"
  fi
  int_1=${STACK[0]}
  int_2=${STACK[1]}
  result=$(echo "${int_1} $op ${int_2}" | bc -l 2>/dev/null | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
  STACK=("${STACK[@]:2}")
  STACK=($result "${STACK[@]}")
}

function check_stack() {
  if [ "${#STACK[@]}" -lt "2" ]; then
    echo "Enter more numbers to calculate"
  else
    calc "$key"
  fi
}

function parse_input() {
  while [[ $# -gt 0 ]]; do
    is_number "$1"
    key="$1"
    case $key in
    "$quit")
      echo "Quitting..."
      exit
      ;;
    "+")
      check_stack
      shift
      ;;
    "-")
      check_stack
      shift
      ;;
    "^")
      check_stack
      shift
      ;;
    "/")
      check_stack
      shift
      ;;
    *)
      shift
      ;;
    esac
  done
  echo -n "${STACK[@]}" "> "
}

echo -n "> "
while read INPUT; do
  parse_input $INPUT
done
