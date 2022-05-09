# python 3 headers, required if submitting to Ansible
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = """
    lookup: csslink
    author: Csaba Palankai <csaba.palankai(at)gmail.com>
    version_added: "0.1"
    short_description: fetches webpage and search for an a tag
    description:
        - Allows you to find links dynamically on webpage
    options:
      webpage:
        description: URL of webpage
        required: True
      webpage:
        description: CSS selector for the given a tag
        required: True
    requirements:
     - requests
     - beautifulsoup4
"""
import re

from ansible.errors import AnsibleError, AnsibleParserError
from ansible.plugins.lookup import LookupBase
from ansible.utils.display import Display

import requests
from bs4 import BeautifulSoup

display = Display()


class LookupModule(LookupBase):

    def run(self, terms, variables=None, **kwargs):
        display.vv(requests.__file__)
        webpage = terms[0]
        selector = terms[1]
        display.debug("Fetching HTML content of %s" % webpage)
        resp = requests.get(webpage)
        if resp.status_code != 200:
            raise AnsibleError("could not fetch webpage: %s" % webpage)
        soup = BeautifulSoup(resp.content, 'html.parser')
        href = soup.select_one(selector)['href']
        return [href]
