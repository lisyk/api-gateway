set -e # exit on error

echo 'BEGIN'
echo "-------------------"
echo "CIRCLE_PROJECT_REPONAME: $CIRCLE_PROJECT_REPONAME"
echo "CIRCLE_USERNAME: $CIRCLE_USERNAME"
echo "CIRCLE_BRANCH: $CIRCLE_BRANCH"
echo "-------------------"

echo '--- configure git user'
git config user.email "it@vippetcare.com"
git config user.name "IT-VIP"

echo '--- copy schema'
cp db/schema.rb db/base_schema.rb

# echo '--- add test file'
# date > test.txt

echo '--- commit changes'
git status
git add .
git status
git diff-index --quiet HEAD || git commit -m '[AUTO-COMMIT] update db/base_schema.rb' -m '[skip ci]'
git status
# git show

echo '--- push changes'
git remote get-url --all origin
git push origin $CIRCLE_BRANCH

echo 'END'
