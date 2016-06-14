from bs4 import BeautifulSoup
from sys import argv
import http.client, urllib.parse
import re, string
import hashlib
import unicodedata
import io

#pattern = re.compile('[\W_]+')

script, conv = argv

with io.open(conv, encoding='utf-8') as f:
    doc = f.read()
soup = BeautifulSoup(''.join(doc))

conn = http.client.HTTPConnection('localhost', 8983)

#conn.request('POST', '/solr/admin/cores?action=UNLOAD&core=aiml&deleteIndex=true&deleteDataDir=true')
#conn.request('POST', '/solr/admin/cores?action=CREATE&name=aiml&instanceDir=aiml')

for token in soup('category'):
    # skip SRAIs and * wildcard rules
    if ('*' not in token.pattern.text):
        pattern = token.pattern.text

        docId = hashlib.sha224(pattern.encode('ascii','ignore')).hexdigest()
        print('SOLR: %s %s' % (docId, pattern))
        BODY = """\
[
    {
        "id" : "DOC%s",
        "title" : "%s"
    }
]
""" % (docId, pattern)
        print('BODY ', BODY)

        headers = {'Content-type': 'application/json'}
        conn.request('POST', '/solr/aiml/update', BODY, headers)
        response = conn.getresponse()
        print(response.status, response.reason)
        data = response.read()
        print('DATA', data)

conn.request('POST', '/admin/cores?action=RELOAD&core=query')
