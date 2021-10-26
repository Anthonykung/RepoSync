#!/bin/bash

rsync -r --exclude '.git' $GITHUB_WORKSPACE/source/* $GITHUB_WORKSPACE/target
cd $GITHUB_WORKSPACE/target
git config user.name github-actions
git config user.email github-actions@github.com
git add -A
git commit -am "Generated update from RepoSync GitHub Action"
git push
