#!/usr/bin/env bash

QUIT="q"
NUM="^[0-9]+$"
OPERATOR="^[-+*\/]+$"
STACK=()

function is_number() {
  if [[ "${1}" =~ $NUM ]]; then
    stripped="${1#"${1%%[!0]*}"}"
    STACK+=("${stripped}") || STACK+=("${1}")
    echo -n "${STACK[@]}" "> "
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
      OPERATOR="+"
      ADDED=$(("${STACK[0]}" + "${STACK[1]}"))
      STACK=("${STACK[@]:1}")
      STACK=("${STACK[@]:2}")
      STACK=($ADDED "${STACK[@]}")
      echo -n "${STACK[@]}" "> "
      shift
      ;;
    "-")
      OPERATOR="-"
      echo "Subtraction: $OPERATOR"
      echo -n "${STACK[@]}" "> "
      shift
      ;;
    "*")
      OPERATOR="*"
      echo "Multiplication: $OPERATOR"
      echo -n "${STACK[@]}" "> "
      shift
      ;;
    "/")
      OPERATOR="/"
      echo "Division: $OPERATOR"
      echo -n "${STACK[@]}" "> "
      shift
      ;;
    *)
      shift
      ;;
    esac
  done
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
