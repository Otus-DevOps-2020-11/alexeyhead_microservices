#!/bin/bash

yc_app=($(yc compute instance list | grep docker-* | awk '{print $4, $10}'))

if [[ "$1" == "--list" ]]; then
#heredoc
cat<<EOF
{
    "_meta": {
        "hostvars": {
            "${yc_app[0]}": {
                "ansible_host": "${yc_app[1]}"
            }
        }
    },
    "all": {
        "children": [
            "app",
            "ungrouped"
        ]
    },
    "app": {
        "hosts": [
            "${yc_app[0]}"
        ]
    }
}
EOF

else
  echo "re-run with arguments"
fi
