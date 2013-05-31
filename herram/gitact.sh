#!/bin/sh

b=`git branch | grep "^*" | sed -e  "s/^* //g"`
git fetch origin
git merge origin/${b}

