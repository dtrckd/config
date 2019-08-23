#!/bin/bash
# Clone all github.com repositories for a specified user.


if [ $# -eq 0 ]
  then
    echo "Usage: $0 <user_name> "
    exit;
fi

USER=$1
ISFORKED=false

# clone all repositories for user specifed
while read -r REPO; do
    URL=$(echo "$REPO" | jq '.git_url')
    FORK=$(echo "$REPO" | jq '.fork')
    if [ $FORK == "$ISFORKED" ]; then
        echo $URL
        #git clone $repo;
    fi
done <<<$(curl -s "https://api.github.com/users/$USER/repos?per_page=1000" | jq -c ".[]")
