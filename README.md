# hr-solr

This is a simple importer for loading AIML files into the Apache SOLR search system. SOLR helps provide
a higher likelyhood for matching a specific AIML phrase based on a user's recognized utterance.

On Debian based systems (including Ubuntu) you should be able to run ./install.sh to install SOLR and
the other necessary dependencies. The hr-solr directory should be checked out as a sibling to
public_ws.

Once those are installed you can start SOLR and run `./load.sh` to load the AIML data into SOLR.

Currently the scripts just load the AIML directly instead of interacting with the chatbot system
to get a feed of search keys.

# Status
As of 2016, this code is no longer in use by any of the robot platforms. The code in this repo
is archived, meaning that it is read-only: you can read it, and clone it, but you cannot create
new issues or new pull requests.

##### Copyright (c) 2016 Hanson Robotics
