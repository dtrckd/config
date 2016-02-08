git filter-branch --commit-filter 'if [ "$GIT_AUTHOR_NAME" = "Doe" ];
  then export GIT_AUTHOR_NAME="dTracked"; export GIT_AUTHOR_EMAIL=ddtracked@gmail.com;
  fi; git commit-tree "$@"'
