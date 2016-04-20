#!/bin/bash

BASEDIR=$(dirname $(readlink -f ${BASH_SOURCE[0]}))
CACHE_DIR=~/.hr/cache
SOLR_DIR=~/.hr/solr
if [[ ! -d $CACHE_DIR ]]; then
    mkdir -p $CACHE_DIR
fi

if [[ ! -f $CACHE_DIR/solr-5.5.0.zip ]]; then
    wget http://www.motorlogy.com/apache/lucene/solr/5.5.0/solr-5.5.0.zip -O $CACHE_DIR/solr-5.5.0.zip
fi

if [[ ! -f $SOLR_DIR/solr-5.5.0/bin/solr ]]; then
    unzip -n $CACHE_DIR/solr-5.5.0.zip -d $SOLR_DIR
fi

$SOLR_DIR/solr-5.5.0/bin/solr start
$SOLR_DIR/solr-5.5.0/bin/solr delete -c aiml
$SOLR_DIR/solr-5.5.0/bin/solr create -c aiml

for i in $BASEDIR/../public_ws/src/chatbot/character_aiml/sophia.*.aiml; do python3 load_solr.py "$i"; done
$SOLR_DIR/solr-5.5.0/bin/solr stop
$SOLR_DIR/solr-5.5.0/bin/solr start
