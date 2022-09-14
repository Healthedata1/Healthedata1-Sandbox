#!/bin/bash
# exit when any command fails
set -e

while getopts bf option
do
 case "${option}"
 in
 b) BRANCH=1;;
 f) FORK=1;;
 esac
done

echo "================================================================="
echo "=== catchup to remote master no options ==="
echo "-b parameter for catching up to upstream branch for forked repo = $BRANCH"
echo "-f parameter for catching up to upstream master for forked repo = $FORK"
echo "================================================================="

if [[ $BRANCH ]]
then
    branch_name="$(git symbolic-ref HEAD 2>/dev/null)" ||
    branch_name="(unnamed branch)" # detached HEAD
    branch_name=${branch_name##refs/heads/}
    git fetch upstream
    git checkout master
    git merge upstream/master
    git push
    git checkout $branch_name
    git merge master
elif [[ $FORK ]]
then
    git fetch upstream
    git checkout master
    git merge upstream/master
    git push
else
    git checkout master
    git pull
fi


