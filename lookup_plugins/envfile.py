from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = """
    lookup: envfile
    author: Csaba Palankai <csaba.palankai(at)gmail.com>
    version_added: "0.1"
    short_description: read the value of environment file
    description:
        - Allows you to query the environment variables available on the controller when you invoked Ansible.
    options:
      _terms:
        description: Environment variable or list of them to lookup the values for
        required: True
"""

EXAMPLES = """
- debug: msg="{{ lookup('envfile', 'localenv', 'HOME') }} is an environment variable"
"""

RETURN = """
  _list:
    description:
      - values from the environment variable file.
    type: list
"""
import os

from ansible.errors import AnsibleError, AnsibleParserError
from ansible.plugins.lookup import LookupBase
from ansible.module_utils._text import to_text
from ansible.utils.display import Display

display = Display()


class LookupModule(LookupBase):

    def run(self, terms, variables, **kwargs):
        ret = []
        filename, var = terms
        display.debug("File lookup term: %s" % filename)

        # Find the file in the expected search path
        lookupfile = self.find_file_in_search_path(variables, 'files', filename)
        display.vvvv(u"File lookup using %s as file" % lookupfile)
        try:
            if lookupfile:
                b_contents, show_data = self._loader._get_file_contents(lookupfile)
                contents = to_text(b_contents, errors='surrogate_or_strict')
                for line in contents.split('\n'):
                    if line.startswith(var + '='):
                        ret.append(line[len(var) + 1:])
            else:
                raise AnsibleParserError()
        except AnsibleParserError:
            raise AnsibleError("could not locate file in lookup: %s" % filename)
        if not ret:
            raise AnsibleError("could not locate file in env var %s in %s" % (var, filename))
        return ret
