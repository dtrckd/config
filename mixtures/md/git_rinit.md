@git
@recipe

##  Make the current commit the only (initial) commit in a Git repository

```bash
git branch new_branch_name $(echo "init message" | git commit-tree HEAD^{tree}) 
git checkout new_branch_name # swith to new branch mirror just created
git branch -D master # delete master
git branch -m master # rename new_branch to master
%git push -f origin master # eventually push the reseted repository
```

## Ammend author name and email

```bash
git config user... 'new_name..'
git commit --amend --reset-author
```


