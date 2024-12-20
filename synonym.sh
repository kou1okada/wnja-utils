#!/usr/bin/env bash

readarray -t synsets < <(sqlite3 wnjpn.db "SELECT synset,lemma FROM 'wnjpn-all' WHERE lemma like '$1'")

for synsetlemma in "${synsets[@]}"; do
  synset="${synsetlemma%%|*}"
  lemma="${synsetlemma#*|}"
  echo "$synset : $lemma"
  echo "意味"
  sqlite3 wnjpn.db "SELECT def_ja FROM 'wnjpn-def' WHERE synset='$synset'" | sed -E 's/^/\t/g'
  echo "例"
  sqlite3 wnjpn.db "SELECT def_ja FROM 'wnjpn-exe' WHERE synset='$synset'" | sed -E 's/^/\t/g'
  echo "類義語"
  sqlite3 wnjpn.db "SELECT lemma FROM 'wnjpn-all' WHERE synset='$synset'" | sed -E 's/^/\t/g'
  echo
done
