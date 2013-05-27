b=`git branch | grep "^*" | sed -e  "s/^* //g"`
git status -s
git commit -a
git push origin ${b}

