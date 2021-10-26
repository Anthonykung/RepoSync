# Repo Sync

GitHub Action to sync repositories (push to another repo when push detected on current repo)

## Usage

### GitHub Way

1. Create Personal Access Token (PAT) with `public_repo` scope (if your target repo is a private repo, you need a private scope use `repo` instead)
2. Save PAT as secret named `RS_PAT` by going to `GitHub -> Repo -> Settings -> Secrets -> New reposirory secret`
3. Create a secret named `RS_TARGET` with your target repo name in `org/repo` format e.g. `Anthonykung/RepoSync`
4. Create a new GitHub action Workflow by `GitHub -> Repo -> Actions -> New workflow -> set up a workflow yourself`
5. Copy and paste the following to the text area
6. Rename the file to `RepoSync.yml`
7. Hit save and be done!

```
name: AnthRepoSync
on: 
  push:
    # Remove the `#` below if you only want a specific branch, leave it for all pushes
    # branches:
    # - main
  workflow_dispatch:

jobs:
  RepoSync:
    runs-on: ubuntu-latest
    steps:
      - name: AnthRepoSync
        uses: Anthonykung/RepoSync@v1.4.0
        with:
          RS_TARGET: ${{ secrets.RS_TARGET }}
          RS_PAT: ${{ secrets.RS_PAT }}
```

### Workflow Way

1. Create Personal Access Token (PAT) with `public_repo` scope (if your target repo is a private repo, you need a private scope use `repo` instead)
2. Save PAT as secret named `RS_PAT` by going to `GitHub -> Repo -> Settings -> Secrets -> New reposirory secret`
3. If you use a branch that is not `main`, you will need to update `RepoSync.yml` with your branch name e.g. `master` (sorry they don't let me use secrets 😭)
4. Create a secret named `RS_TARGET` with your target repo name in `org/repo` format e.g. `Anthonykung/RepoSync`
5. Sit back and relex, check if the action successfully completes, otherwise you can grab that cup of coffee (or tea) now 😉.

## Use Case

Of course, why is something boring like this useful? Well, imagine you have a GitHub profile say `Anthonykung/Anthonykung` but you also publish it on a GitHub.io page for no reason at `Anthonykung/Anthonykung.github.io`. And you are too lazy to pull the repo and add a new upstream, then this action is very useful in that case. All the pushes to `Anthonykung/Anthonykung` will by sync automatically to `Anthonykung/Anthonykung.github.io` and you don't have to do a thing.

Sure, you can create a GitHub page directly in the directory and skip this (pretty sure I'll eventually do that 😶) but say if you have a project that requires you to sync two or more repo and since the repos would basically be the same so there is no point to use a submodule and you work with random people that may or may not remember to add a upstream then this should help. Whenever people push, no matter they remember to add upstream or not, it will sync your other repo.

## Customization

You can add multiple target repo if you would like just add more of theses:

```yml
      - name: Get target repo
        uses: actions/checkout@v2
        with:
          repository: ${{ secrets.RS_TARGET }}
          token: ${{ secrets.RS_PAT }}
          path: target
```

Under the line `# You can add more targets if you want` like so:

```yml
      - name: Get target repo
        uses: actions/checkout@v2
        with:
          repository: ${{ secrets.RS_TARGET }}  # Create a secret with your GitHub repo in org/repo format e.g. Anthonykung/RepoSync
          token: ${{ secrets.RS_PAT }}  # Create a PAT with public repo access and put it as a secret named PUBLIC_GITHUB_REPO
          path: target                              # (GitHub -> Repo -> Settings -> Secrets -> New repository secret)
          
      # You can add more targets if you want
      
      - name: Get target repo
        uses: actions/checkout@v2
        with:
          repository: ${{ secrets.RS_TARGET }}
          token: ${{ secrets.RS_PAT }}
          path: target2
          
      - name: Get target repo
        uses: actions/checkout@v2
        with:
          repository: ${{ secrets.RS_TARGET }}
          token: ${{ secrets.RS_PAT }}
          path: target3
```

And don't forget to update the script to include the other targets like this:

```yml
      - name: Copy source to target and push
        run: |
          git config user.name github-actions
          git config user.email github-actions@github.com
          rsync -r --exclude '.git' $GITHUB_WORKSPACE/source/* $GITHUB_WORKSPACE/target
          rsync -r --exclude '.git' $GITHUB_WORKSPACE/source/* $GITHUB_WORKSPACE/target2
          rsync -r --exclude '.git' $GITHUB_WORKSPACE/source/* $GITHUB_WORKSPACE/target3
          cd $GITHUB_WORKSPACE/target && git add -A && git commit -am "Generated update from RepoSync GitHub Action" && git push
          cd $GITHUB_WORKSPACE/target2 && git add -A && git commit -am "Generated update from RepoSync GitHub Action" && git push
          cd $GITHUB_WORKSPACE/target3 && git add -A && git commit -am "Generated update from RepoSync GitHub Action" && git push
```

Of course, you can use your imagination and have something else that does the same thing, I'll leave that up to you 😉.
