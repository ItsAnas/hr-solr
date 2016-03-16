#!/bin/bash
./solr-5.5.0/bin/solr delete -c aiml
./solr-5.5.0/bin/solr create -c aiml
for i in ../public_ws/src/chatbot/character_aiml/sophia.*.aiml; do python3 load_solr.py "$i"; done
for i in ../public_ws/src/chatbot/character_aiml/sophia_body.*.xml; do python3 load_solr.py "$i"; done
./solr-5.5.0/bin/solr stop
./solr-5.5.0/bin/solr start
