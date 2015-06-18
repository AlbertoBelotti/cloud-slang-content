#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Builds a list of app names from the response of the get_app_list operation.
#
# Inputs:
#   - operation_response - response of get_app_list operation
# Outputs:
#   - app_list - list of app names
#   - return_result - was parsing was successful or not
#   - return_code - 0 if parsing was successful, -1 otherwise
#   - error_message - return_result if there was an error
# Results:
#   - SUCCESS - parsing was successful (return_code == '0')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.marathon

operation:
  name: parse_get_app_list
  inputs:
    - operation_response
  action:
    python_script: |
      try:
        import sys
        import json
        decoded = json.loads(operation_response)
        app_list_Json = decoded['apps']
        nr_apps = len(app_list_Json)

        app_list = ''
        for index in range(nr_apps):
          app_name = app_list_Json[index]['id']

          app_list = app_list + app_name[1:] + ','
        app_list = app_list[:-1]

        return_code = '0'
        return_result = 'Parsing successful.'
      except:
        return_code = '-1'
        print "Unexpected error:", sys.exc_info()[0]
        return_result = 'Parsing error.'
  outputs:
    - app_list
    - return_result
    - return_code
    - error_message: return_result if return_code == '-1' else ''
  results:
    - SUCCESS: return_code == '0'
    - FAILURE