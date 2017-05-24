########################################################################################################################
#!!
#! @description: This flow is used to create a channel in Slack.
#!
#! @input token: The token generated for Slack API access
#! @input channel_name: The name of the new channel. By default is set to "test-name".
#!
#! @output response_json: The response returned by the post request in JSON format.
#! @output channel_id: ID of the new created channel retrieved from the JSON response body.
#!!#
########################################################################################################################
namespace: flows
flow:
  name: create_channel
  inputs:
    - token: xoxp-183679876005-185602893429-186107982896-a95e99871bc1412c253a7bbe03e8197c
    - channel_name: test-name
  workflow:
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${'https://slack.com/api/channels.create?token=' + token +'&name=' + channel_name + '&pretty=1'}"
        publish:
          - status_code
          - response_json: '${return_result}'
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '200'
        publish: []
        navigate:
          - SUCCESS: get_validation
          - FAILURE: on_failure
    - get_channel_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${response_json}'
            - json_path: $.channel.id
        publish:
          - channel_id: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - get_validation:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${response_json}'
            - json_path: $.ok
        publish:
          - validation: '${return_result}'
        navigate:
          - SUCCESS: is_true
          - FAILURE: on_failure
    - is_true:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${validation}'
        navigate:
          - 'TRUE': get_channel_id
          - 'FALSE': FAILURE
  outputs:
    - response_json: '${response_json}'
    - channel_id: '${channel_id}'
  results:
    - SUCCESS
    - FAILURE