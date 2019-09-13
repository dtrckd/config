#!/usr/bin/env python3

import sys, os
import json
import requests
from bs4 import BeautifulSoup as Soup



if __name__ == "__main__":

    fn = None
    if len(sys.argv) == 2:
        fn = sys.argv[1]

    url = "https://dblp.org/search/publ/api?q=adrien+dulac&h=100&format=json"
    r = requests.get(url).json()

    papers = []
    _papers = r['result']['hits']['hit']
    for _p in _papers:
        p = _p['info']

        authors = p.get('authors').get('author')
        authors = authors if isinstance(authors, list) else [authors]
        title = str(Soup(p.get('title'), 'html.parser'))

        paper = dict(authors=authors, title=title,
                     venue=p.get('venue'), pages=p.get('pages'),
                     type=p.get('type'), year=p.get('year'),
                     url=p.get('url'),)

        papers.append(paper)

    if fn:
        with open(fn, 'w') as _f:
            json.dump(papers, _f, indent=2)
    else:
        print(json.dumps(papers, indent=2))
