#!/usr/bin/env bash

num="[-+]?[0-9]*\.?[0-9]+"
STACK=()
RED='\033[0;31m'
BOLD='\033[0;1m'
UNDER='\033[0;4m'
BASE='\033[0m'

VERSION=0.1.0

function version() {
  echo "rpn v${VERSION}"
}

function usage() {
  local txt=(
    ""
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
    "│  rpn 1 2 + 3 + 4 + 5 +         => 15                         │"
    "│  rpn pi cos                    => -1.0                       │"
    "│  rpn                           => interactive mode           │"
    "│                                                              │"
    "└──────────────────────────────────────────────────────────────┘"
    ""
  )

  printf "%s\n" "${txt[@]}"
}

# * README
# * round
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
