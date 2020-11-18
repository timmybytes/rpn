#!/usr/bin/env bash

# Exit on error
# set -e
# set -o pipefail

# Piped Input
#============================================================================
# if [ -p /dev/stdin ]; then
# read -s piped
# echo $piped
# STACK=("${STACK[@]}" $piped)
# echo -n "${STACK[@]}"
# if [ "$piped" == "+" ]; then
#   for i in "${STACK[@]}"; do
#     ((a += i))
#     STACK=("$a")
#   done
#   echo -n "${STACK[@]}" "> "
# elif ! [[ "$piped" =~ ^[0-9]+$ ]]; then
#   echo -en "Sorry, integers only!\n> "
#   continue
# else
#   STACK=("${STACK[@]}" $piped)
#   echo -n "${STACK[@]}" "> "
# fi
# fi

# Regular Usage
#============================================================================
# echo "Enter one or more numbers separated by a space"

# First Draft of RPN
# echo -n "> "
# while read line; do
#   # Strip leading 0s
#   line="${line#"${line%%[!0]*}"}"
#   # case $line in
#   # +)
#   #   for i in "${STACK[@]}"; do
#   #     ((a += i))
#   #     STACK=("$a")
#   #   done
#   #   echo -n "${STACK[@]}" "> "
#   #   ;;
#   # esac
#   if [ -p /dev/stdin ]; then
#     read -s piped
#     STACK=("${STACK[@]}" $piped)
#     # echo -n ""
#   elif [ "$line" == "+" ]; then
#     for i in "${STACK[@]}"; do
#       ((a += i))
#       STACK=("$a")
#     done
#   elif [ "$line" == "-" ]; then
#     # difference=$(${STACK[-1]} - ${STACK[-2]})
#     let "diff=${STACK[-1]} - ${STACK[-2]}"

#     STACK=("${STACK[@]}" $diff)
#     # ${STACK[-1] - ${STACK[-2]
#     # for i in "${STACK[@]}"; do
#     #   ((a -= i))
#     #   STACK=("$a")
#     # done
#     echo -n "${STACK[@]}" "> "
#   elif ! [[ "$line" =~ ^[0-9]+$ ]]; then
#     echo -en "Sorry, integers only!\n> "
#     continue
#   else
#     STACK=("${STACK[@]}" $line)
#     echo -n "${STACK[@]}" "> "
#   fi
# done

# echo ${STACK[@]}

QUIT="q"
NUM="^[0-9]+$"
OPERATOR="^[-+*\/]+$"
STACK=()

function help() {
  printf "REPONO v${VERSION}"
}

function is_number() {
  if [[ "${1}" =~ $NUM ]]; then
    # Trim leading 0s before adding to STACK
    strip="${1#"${1%%[!0]*}"}"
    STACK+=("${strip}") || STACK+=("${1}")
    shift
  fi
}

function parse_input() {
  while [[ $# -gt 0 ]]; do
    is_number "$1"
    key="$1"
    case $key in
    "$QUIT")
      echo "Quitting..."
      exit
      ;;
    "+")
      ADD=$(("${STACK[0]}" + "${STACK[1]}"))
      STACK=("${STACK[@]:2}")
      STACK=($ADD "${STACK[@]}")
      shift
      ;;
    "-")
      SUB=$(("${STACK[0]}" - "${STACK[1]}"))
      STACK=("${STACK[@]:2}")
      STACK=($SUB "${STACK[@]}")
      shift
      ;;
    "^")
      MLP=$(("${STACK[0]}" * "${STACK[1]}"))
      STACK=("${STACK[@]:2}")
      STACK=($MLP "${STACK[@]}")
      shift
      ;;
    "/")
      DIV=$(("${STACK[0]}" / "${STACK[1]}"))
      STACK=("${STACK[@]:2}")
      STACK=($DIV "${STACK[@]}")
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

# Add an element to the stack
# $ 1 stack variable name
# $ 2 added to the element stack
function stack_push() {
  # Define the array as an indirect reference variable
  declare -n array=$1
  array=(${array[@]} "$2")
}
# Pops an element from the stack
# $ 1 stack variable name
# Stack_pop_return returned in the pop-up element, if the stack is empty then return empty
function stack_pop() {
  stack_pop_return=
  # Define the array as an indirect reference variable
  declare -n array=$1
  local size=${#array[@]}
  [ $size -gt 0 ] &&
    stack_pop_return=${array[$size - 1]} &&
    array=(${array[@]:0:$(($size - 1))})
}

################ call sample ##################
# Here the name of an array variable names to save the stack data
# stack_push names tom
# stack_push names jerry
# echo names=${names[@]}

# stack_pop names
# echo stack_pop_return=$stack_pop_return
# stack_pop names
# echo stack_pop_return=$stack_pop_return
# echo names=${names[@]}

# stack_pop names
# echo The stack is empty pop return empty
# echo stack_pop_return=$stack_pop_return
# echo names=${names[@]}
# read -s piped
# stack_push entry "$piped"
# echo $entry
