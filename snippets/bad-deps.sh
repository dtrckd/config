SEARCH_DIRS=("/home/dtrckd/main/missions/")

wget https://gist.githubusercontent.com/alexgreenland/3a7aa666a37a9e71b4abf06b274278d9/raw/ca97e521df6f14906698c49542ddff1d95393d3f/bad-deps.txt

#
# Search bad deps in node projects
#

CWD=$(pwd)
BAD_DEPS=$(cat ./bad-deps.txt)

PROJECTS=()
for search_dir in ${SEARCH_DIRS[@]}; do
    while IFS= read -r -d '' project; do
        PROJECTS+=("$(dirname "$project")")
    done < <(find "$search_dir" -path "*/node_modules" -prune -o -name "package.json" -type f -print0)
done

for project in "${PROJECTS[@]}"; do
    cd "$project"
    echo "Checking $project..."
    FULL_LIST=$(npm list --all --silent)

    for dep in ${BAD_DEPS[@]}; do
        if [ $(echo $FULL_LIST | grep "$dep" | wc -l) != 0 ]; then
        echo bad repo: $project
            npm list $dep
        fi
    done

    cd "$CWD"
done

