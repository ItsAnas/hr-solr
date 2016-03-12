#!/bin/bash
sudo apt-get update 
sudo apt-get install unzip openjdk-7-jdk
wget http://www.motorlogy.com/apache/lucene/solr/5.5.0/solr-5.5.0.zip
unzip solr-5.5.0.zip
cd solr-5.5.0
./bin/solr start
./bin/solr create -c aiml
