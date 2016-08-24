# Change name and email of all previous commits
git filter-branch -f --commit-filter  'if [ "$GIT_AUTHOR_NAME" = "smith" ];
  then export GIT_AUTHOR_NAME="dtrckd"; export GIT_AUTHOR_EMAIL=ddtracked@gmail.com;
  fi; git commit-tree "$@"'

  # Remove Backup
  #git update-ref -d refs/original/refs/heads/master
