#!/usr/bin/env python

import sys
import urllib2
import json

def do_gist_json(s):
    """ Use json to post to github. """
    gist_public = False
    gist_url = 'https://api.github.com/gists'

    data = {'description': None,
            'public': None,
            'files' : {
                'sample': { 'content': None }
            }}
    data['description'] = 'Gist from BPython'
    data['public'] = gist_public
    data['files']['sample']['content'] = s

    req = urllib2.Request(gist_url, json.dumps(data), {'Content-Type': 'application/json'})
    try:
        res = urllib2.urlopen(req)
    except HTTPError as e:
        return e

    try:
        json_res = json.loads(res.read())
        return json_res['html_url']
    except HTTPError as e:
        return e

if __name__ == "__main__":
  s = sys.stdin.read()
  print(do_gist_json(s))

