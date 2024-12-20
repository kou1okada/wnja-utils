#!/usr/bin/env bash

function usage ()
{
  cat <<-EOD
	Usage: ${0#*/} <tag>
	  Get upstream release of Japanese Wordnet.
	Args:
	  <tag> : tag of upstream release
	Requires:
	  curl, xmlstarlet
	EOD
}

function get_urls () # <tag>
# Get file urls in the release.
{
  curl "https://github.com/bond-lab/wnja/releases/expanded_assets/$tag" \
  | xmlstarlet sel -T -t -m "//a" -v 'concat("https://github.com", @href)' -n
}

if (( $# <= 0 )); then
  usage
  exit
fi

for i in curl cmlstarlet; do
  type "$i" ?&/dev/null || {
    echo -e "\e[31;1mError:\e[0m Command not found: $i"
    exit 1
  }
done

tag="$1"
mkdir -p "upstream/$tag"
readarray -t urls < <(get_urls)
for url in "${urls[@]}"; do
  (
    cd "upstream/$tag"
    wget -c "$url"
  )
done

(
  cd upstream
  readarray -t stamp < <(find "$tag" -type f -exec date -r {} "+%F %T" ";" | sort)
  tar zcvf "${tag}.tgz" "$tag"
  touch -d "$stamp" "${tag}.tgz"
)
