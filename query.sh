#!/bin/bash
wget -O- "http://localhost:8983/solr/aiml/select?indent=true&wt=json&fl=*,score&rows=20&q=$1"
