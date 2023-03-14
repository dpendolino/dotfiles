#!/bin/bash
set -o pipefail

if [ $(sysctl -n sysctl.proc_translated) -eq 1 ];then
  echo "true"
  exit 1
else
  echo "false"
  exit 0
fi
