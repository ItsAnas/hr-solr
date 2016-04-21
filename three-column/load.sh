#!/bin/bash
./solr-5.5.0/bin/solr delete -c 3colpattern
./solr-5.5.0/bin/solr delete -c 3coltemplate
./solr-5.5.0/bin/solr create -c 3colpattern
./solr-5.5.0/bin/solr create -c 3coltemplate

python3 three-column/load.py ../character_dev/character_aiml/convoid419.csv

./solr-5.5.0/bin/solr stop
./solr-5.5.0/bin/solr start
