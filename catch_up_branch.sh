branch_name="$(git symbolic-ref HEAD 2>/dev/null)" ||
branch_name="(unnamed branch)" # detached HEAD
branch_name=${branch_name##refs/heads/}
git fetch upstream
git checkout master
git merge upstream/master
git push
git checkout $branch_name
git merge master