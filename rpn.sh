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

# * README
# * round
# * factorial
# * factorial
# * while getopts u:d:p:f: option
#   do
#   case "${option}"
#   in
#   u) USER=${OPTARG};;
#   d) DATE=${OPTARG};;
#   p) PRODUCT=${OPTARG};;
#   f) FORMAT=${OPTARG};;
#   esac
#   done

VERSION=0.1.0

num="[-+]?[0-9]*\.?[0-9]+"
STACK=()

function help() {
  printf "rpn v${VERSION}"
}

function usage() {
  local txt=(
    "┌──────────────────────────────────────────────────────────────┐"
    "│                                                              │"
    "│         rpn - Reverse Polih Notation Calculator v${VERSION}       │"
    "│                                                              │"
    "│ USAGE:                                                       │"
    "│                                                              │"
    "│  rpn                          Launch in interactive mode     │"
    "│  rpn [expression]             Evaluate a one-line expression │"
    "│                                                              │"
    "│ RC FILE                                                      │"
    "│                                                              │"
    "│  rpn will execute the contents of ~/.rpnrc at startup if it  │"
    "│  exists.                                                     │"
    "│                                                              │"
    "│ EXAMPLES                                                     │"
    "│                                                              │"
    "│  rpn 1 2 + 3 + 4 + 5 +              => 15                    │"
    "│  rpn pi cos                         => -1.0                  │"
    "│  rpn                                => interactive mode      │"
    "│                                                              │"
    "└──────────────────────────────────────────────────────────────┘"
  )

  printf "%s\n" "${txt[@]}"
}

function is_number() {
  # Trim leading 0s
  strip="${1#"${1%%[!0]*}"}"
  if [[ "${strip}" =~ "0" ]]; then
    shift
  fi &&
    if [[ "${strip}" =~ $num ]]; then
      STACK+=("${strip}") || STACK+=("${1}")
      shift
    fi
}

function calc() {
  op=$1
  int_1=${STACK[0]}
  int_2=${STACK[1]}
  if [ "$op" = "^" ]; then
    op="*"
  elif [ "$op" = "++" ]; then
    op="+"
    int_2=$int_1
  elif [ "$op" = "--" ]; then
    op="-"
    int_2=$int_1
  fi
  result=$(echo "${int_1} $op ${int_2}" | bc -l 2>/dev/null | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
  STACK=("${STACK[@]:2}")
  # Prevent 0s from being added to STACK
  if [ "$result" = "0" ]; then
    :
  else
    STACK=($result "${STACK[@]}")
  fi
}

function check_stack() {
  if [ "${#STACK[@]}" -lt "2" ] && [ "$1" != "++" ] && [ "$1" != "--" ]; then
    echo "Enter more numbers to calculate, or use"
    echo "a valid unary operator. Type 'help' for"
    echo "more information."
  else
    calc "$key"
  fi
}

function clear_stack() {
  unset STACK
}

function parse_input() {
  while [[ $# -gt 0 ]]; do
    is_number "$1"
    key="$1"
    case $key in
    "q" | "Q" | "quit" | "exit")
      exit
      ;;
    "usage")
      usage
      shift
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
    "%")
      check_stack
      shift
      ;;
    "++")
      check_stack "$key"
      shift
      ;;
    "--")
      check_stack "$key"
      shift
      ;;
    "clr")
      clear_stack
      shift
      ;;
    *)
      shift
      ;;
    esac
  done
  echo -n "${STACK[@]}" "> "
}

function parse_args() {
  while [[ $# -gt 0 ]]; do
    is_number "$1"
    key="$1"
    case $key in
    "q" | "Q" | "quit" | "exit")
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
    "%")
      check_stack
      shift
      ;;
    "++")
      check_stack "$key"
      shift
      ;;
    "--")
      check_stack "$key"
      shift
      ;;
    "clr")
      clear_stack
      shift
      ;;
    *)
      shift
      ;;
    esac
  done
}

function rpn() {
  for var in "$@"; do
    parse_args $var
  done
  echo -n "${STACK[@]}" "> "
  while read INPUT; do
    parse_input $INPUT
  done
}

rpn $@
