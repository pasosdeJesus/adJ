#!/bin/sh

branch=`git rev-parse --abbrev-ref HEAD`
echo "branch=$branch"
git remote remove origin
git remote add origin git@github.com:pasosdeJesus/adJ
git pull origin $branch
git remote remove origin
git remote add origin git@gitlab.com:pasosdeJesus/adJ
git push origin $branch
#git branch --set-upstream-to=origin/$branch $branch
