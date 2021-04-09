#!/bin/bash

yc_gitlab=($(yc compute instance list | grep gitlab-* | awk '{print $4, $10}'))

if [[ "$1" == "--list" ]]; then
#heredoc
cat<<EOF
{
    "_meta": {
        "hostvars": {
            "${yc_gitlab[0]}": {
                "ansible_host": "${yc_gitlab[1]}"
            }
        }
    },
    "all": {
        "children": [
            "gitlab",
            "ungrouped"
        ]
    },
    "gitlab": {
        "hosts": [
            "${yc_gitlab[0]}"
        ]
    }
}
EOF

else
  echo "re-run with arguments"
fi
