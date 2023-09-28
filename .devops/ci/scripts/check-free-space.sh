#!/usr/bin/env bash
spaceUsedPerc="$(df -Ph . | awk 'NR==2 {print $5}' | awk 'match($0, /[0-9]+/) { print substr( $0, RSTART, RLENGTH ) }')"

dockerImgCount="$(docker images -q | wc -l)"
danglingImgCount="$(docker images -f "dangling=true" -q | wc -l)"

echo "Space used $spaceUsedPerc% by $dockerImgCount docker images ($danglingImgCount dangling)"
if [ $spaceUsedPerc -ge 50 ] || [ $dockerImgCount -ge 30 ] || [ $danglingImgCount -ge 10 ]; then
    bash "./.devops/docker/scripts/soft-cleanup.sh"
fi

