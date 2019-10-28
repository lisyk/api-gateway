gem install brakeman
brakeman -v
mkdir ./tmp
brakeman \
  --add-engines-path components/wellness \
  --index-libs \
  --format html \
  --output ./tmp/brakeman.html $*
