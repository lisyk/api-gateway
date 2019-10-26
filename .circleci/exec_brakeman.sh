gem install brakeman
brakeman -v
mkdir ./tmp
brakeman --index-libs --format html --output ./tmp/brakeman.html $*
