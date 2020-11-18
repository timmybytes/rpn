#!/bin/bash -
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

# echo -n "> "
# read -a STACK

# while [[ $STACK ]]; do
#   for i in "${STACK[*]}"; do
#     echo "${STACK[$i]}"
#   done
#   echo "${STACK[*]}"
#   echo -n "${STACK[@]} > "
#   read -a MORE
#   STACK+=("$MORE")
# done

echo "Enter one or more numbers separated by a space"
echo -n "> "
while read line; do
  if [ "$line" == "+" ]; then
    for i in "${STACK[@]}"; do
      ((a += i))
      STACK=("$a")
    done
    echo -n "${STACK[@]}" "> "
  elif ! [[ "$line" =~ ^[0-9]+$ ]]; then
    echo -en "Sorry, integers only!\n> "
    continue
  else
    STACK=("${STACK[@]}" $line)
    echo -n "${STACK[@]}" "> "
  fi
done

echo ${STACK[@]}
