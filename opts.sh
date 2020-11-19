#!/usr/bin/env bash

while getopts 'lha:' OPTION; do
  case "$OPTION" in
  l)
    echo "linuxconfig"
    ;;

  h)
    echo "h stands for h"
    ;;

  a)
    avalue="$OPTARG"
    echo "The value provided is $OPTARG"
    ;;
  ?)
    echo "script usage: $(basename $0) [-l] [-h] [-a somevalue]" >&2
    exit 1
    ;;
  esac
done
shift "$(($OPTIND - 1))"
