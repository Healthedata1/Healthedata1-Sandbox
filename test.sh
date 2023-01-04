#!/bin/bash
# exit when any command fails
set -e
tmp=$(mktemp -d -d ./input/_examples) || tmp=./input/_examples
function finish {
  # Your cleanup code here
  echo '=== clean up - rename the input/_fsh folder to input/fsh  ==='
  mv input/_fsh input/fsh && echo 'done!'
  echo '====clean up - copy tmp files to examples folder to restore meta elements ===='
  cp -f $tmp/*.json ./input/examples && echo 'done!'
  echo "====clean up - remove $tmp ===="
  rm -rf $tmp && echo 'removed $tmp from docs directory'
}
trap finish EXIT
trap finsh ERR

simple() {
  badcommand  
  echo "Hi from simple()!"

}

simple


