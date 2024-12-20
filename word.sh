#!/usr/bin/env bash

sqlite3 wnjpn.db "SELECT synset,lemma FROM 'wnjpn-all' WHERE lemma like '$1'"
