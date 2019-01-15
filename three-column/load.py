# Copyright (c) 2016 Hanson Robotics, Ltd. 
from sys import argv
import csv
import http.client, urllib.parse
import re, string
import hashlib
import unicodedata
import io

#pattern = re.compile('[\W_]+')

script, conv = argv

conn = http.client.HTTPConnection('localhost', 8983)

# Utility function to update SOLR
def updateSolr(core, docId, title, body):

    BODY = """\
[
    {
        "id" : "DOC%s",
        "title" : "%s",
        "body" : "%s"
    }
]
""" % (docId, title, body)

    headers = {'Content-type': 'application/json'}

    conn.request('POST', '/solr/%s/update' % (core), BODY, headers)
    response = conn.getresponse()
    data = response.read()
    print(title, body, response.status, response.reason, data)

def cleanString(string):
    cleanedString = string.encode('ascii', 'ignore').decode('ascii', 'ignore')
    cleanedString = cleanedString.replace('"', '\\"')
    return cleanedString

# Read and process CSV
meanings = {}        

with io.open(conv, encoding='utf-8') as csvfile:
    convread = csv.reader(csvfile, delimiter=',', quotechar='"')
    for row in convread:
        pattern = row[0]
        meaning = row[1]
        template = row[2]

        if (meaning not in meanings):
            meanings[meaning] = {
                        'patterns': [],
                        'templates': []
                    }

        if (pattern != '' and pattern not in meanings[meaning]['patterns']):
            meanings[meaning]['patterns'].append(pattern)

        if (template != '' and template not in meanings[meaning]['templates']):
            meanings[meaning]['templates'].append(template)

csvMeanings = sorted(meanings.keys())
for meaning in csvMeanings:
    for template in meanings[meaning]['templates']:
        docId = hashlib.sha224(template.encode('ascii', 'ignore')).hexdigest()
        updateSolr('3coltemplate', docId, cleanString(template), meaning)

    for pattern in meanings[meaning]['patterns']:
        docId = hashlib.sha224(pattern.encode('ascii', 'ignore')).hexdigest()
        updateSolr('3colpattern', docId, cleanString(pattern), meaning)

# Update SOLR cores
conn.request('POST', '/admin/cores?action=RELOAD')
