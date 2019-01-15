#!/bin/bash
# Copyright (c) 2016 Hanson Robotics, Ltd. 

BASEDIR=$(dirname $(readlink -f ${BASH_SOURCE[0]}))
SOLR_DIR=~/.hr/solr
VERSION=5.5.2

$SOLR_DIR/solr-${VERSION}/bin/solr start
$SOLR_DIR/solr-${VERSION}/bin/solr delete -c aiml
$SOLR_DIR/solr-${VERSION}/bin/solr create -c aiml
$SOLR_DIR/solr-${VERSION}/bin/solr delete -c 3colpattern
$SOLR_DIR/solr-${VERSION}/bin/solr delete -c 3coltemplate
$SOLR_DIR/solr-${VERSION}/bin/solr create -c 3colpattern
$SOLR_DIR/solr-${VERSION}/bin/solr create -c 3coltemplate

for i in $BASEDIR/../character_dev/character_aiml/sophia.*.aiml; do python3 load_solr.py "$i"; done
for i in $BASEDIR/../character_dev/character_aiml/sophia.*.xml; do python3 load_solr.py "$i"; done
python3 $BASEDIR/three-column/load.py $BASEDIR/convoid_scrubbed.csv
$SOLR_DIR/solr-${VERSION}/bin/solr stop
$SOLR_DIR/solr-${VERSION}/bin/solr start
