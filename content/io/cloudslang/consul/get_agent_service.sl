#   (c) Copyright 2014-2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Gets a list of services the agent is managing.
#!
#! @input host: Consul agent host.
#! @input consul_port: Optional - Consul agent port.
#!                     Default: '8500'
#!
#! @output return_result: Response of the operation.
#! @output error_message: Return_result if return_code is equal to ': 1' or status_code different than '200'.
#! @output return_code: If return_code is equal to '-1' then there was an error
#! @output status_code: Normal status code is '200'
#!
#! @result SUCCESS: Operation succeeded (return_code != '-1' and status_code == '200')
#! @result FAILURE: Otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.consul

operation:
  name: get_agent_service

  inputs:
    - host
    - consul_port:
        default: '8500'
        required: false
    - url:
        default: ${'http://' + host + ':' + consul_port + '/v1/agent/services'}
        private: true
    - method:
        default: 'GET'
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-http-client:0.1.71'
    class_name: io.cloudslang.content.httpclient.HttpClientAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - error_message: ${returnResult if returnCode == '-1' or statusCode != '200' else ''}
    - return_code: ${returnCode}
    - status_code: ${statusCode}

  results:
    - SUCCESS: ${returnCode != '-1' and statusCode == '200'}
    - FAILURE
