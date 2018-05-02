#!/bin/bash

for i in $(git ls-files | grep .md | grep -v README.md); do
  f=${i%%.md}
  f=${f##docs/}
  echo $f
  if [ $f = "index" ]; then
    cat <<EOF > $i

# The documentation for PaaS Team Manual has moved!
This page can now be found at [https://team-manual.cloud.service.gov.uk/](https://team-manual.cloud.service.gov.uk/).
EOF
  else
    cat <<EOF > $i

# The documentation for PaaS Team Manual has moved!
This page can now be found at [https://team-manual.cloud.service.gov.uk/$f/](https://team-manual.cloud.service.gov.uk/$f/).
EOF
  fi
done
