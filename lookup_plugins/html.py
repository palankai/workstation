# python 3 headers, required if submitting to Ansible
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = """
    lookup: html
    author: Csaba Palankai <csaba.palankai(at)gmail.com>
    short_description: fetch webpage
    description:
        - Fetches the content of a webpage
    options:
      _terms:
        description: Webpage URL
        required: True
    requirements:
     - requests
"""
import re

from ansible.errors import AnsibleError, AnsibleParserError
from ansible.plugins.lookup import LookupBase
from ansible.utils.display import Display

import requests

display = Display()


class LookupModule(LookupBase):

    def run(self, terms, variables=None, **kwargs):
        display.vv(requests.__file__)
        webpage = terms[0]
        display.debug("Fetching HTML content of %s" % webpage)
        resp = requests.get(webpage)
        if resp.status_code != 200:
            raise AnsibleError("could not fetch webpage: %s" % webpage)
        return [resp.content]
