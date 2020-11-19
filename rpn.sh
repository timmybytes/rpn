#!/usr/bin/env bash
# title          :rpn.sh
# description    :A Reverse Polish Notation calculator
# author         :Timothy Merritt
# date           :2020-11-17
# version        :0.1.0
# usage          :./rpn.sh
# bash_version   :5.0.18(1)-release
#============================================================================

source ./info.sh

function is_number() {
  # Trim leading and extranneous 0s
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
  # ++ & -- should not replace first two digits, only first
  # case $op in

  if [ "$op" = "^" ]; then
    op="*"
  elif [ "$op" = "++" ]; then
    op="+"
    int_2="1"
  elif [ "$op" = "--" ]; then
    op="-"
    int_2="1"
  fi
  result=$(echo "${int_1} $op ${int_2}" | bc -l 2>/dev/null | sed '/\./ s/\.\{0,1\}0\{1,\}$//')
  STACK=("${STACK[@]:2}")
  STACK=($result "${STACK[@]}")
}

function check_stack() {
  if [ "${#STACK[@]}" -lt "2" ] && [ "$1" != "++" ] && [ "$1" != "--" ]; then
    echo -e "${RED}𐄂 ERROR${BASE}: The ${key} operation cannot be performed on a single number."
    echo "  Enter more numbers to calculate, or use a valid unary operator. "
    echo "  Type 'help' or 'usage' for more information."
    echo
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
    "v" | "-v" | "--version" | "version")
      version
      shift
      ;;
    "clr")
      clear_stack
      shift
      ;;
    "+" | "-" | "^" | "/" | "%")
      check_stack
      shift
      ;;
    "++" | "--")
      check_stack "$key"
      shift
      ;;
    *)
      shift
      ;;
    esac
  done
}

function rpn() {
  # For piped input
  if [ -p /dev/stdin ]; then
    while read piped; do
      parse_input $piped && echo -e "${BOLD}${STACK[@]}${BASE}"
    done
  else
    # For arguments
    for i in $@; do
      parse_input $i
    done
    # For regular usage
    echo -en "${BOLD}${STACK[@]}${BASE}" "> "
    while read INPUT; do
      parse_input $INPUT && echo -en "${BOLD}${STACK[@]}${BASE}" "> "
    done
  fi
}

rpn $@
