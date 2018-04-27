#!/bin/bash

for i in $(git ls-files | grep .md | grep -v README.md); do
  f=${i%%.md}
  f=${f##docs/}
  echo $f
  cat <<EOF > $i

# The documentation for PaaS Team Manual has moved!
This page can now be found at [https://alphagov.github.io/paas-team-manual/$f/](https://alphagov.github.io/paas-team-manual/$f/).
EOF
done
