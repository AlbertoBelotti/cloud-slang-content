#   (c) Copyright 2014-2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Generates a new uuid.
#!
#! @input list_of_variables: List of variables to initialize.
#!
#! @output return_result: Generated uuid.
#!
#! @result SUCCESS: Always.
#!!#
########################################################################################################################

namespace: io.cloudslang.slack.utilities

operation:
  name: format_slack_attachment_op

  inputs:
    - title:
        required: false
    - title_link:
        required: false
    - text:
        required: false
        default: This text was sent from OO
    - pretext:
        required: false
    - color:
        required: false
    - fallback:
        required: false
    - author_name:
        required: false
    - author_link:
        required: false
    - author_icon:
        required: false
    - fields:
        required: false
    - image_url:
        required: false
    - thumb_url:
        required: false
    - footer:
        required: false
    - footer_icon:
        required: false
    - footer_timestamp:
        required: false

  python_action:
    script: |
      list_of_var ='fallback,color,pretext,author_name,author_link,author_icon,title,title_link,text,fields,image_url,thumb_url,footer,footer_icon,footer_timestamp'
      for item in list_of_var.split(','):
        if not (item in globals()):
          if item == 'fields':
            globals()[item] = '""'
          else:
            globals()[item] = ''
        if globals()[item] is None:
          if item == 'fields':
            globals()[item] = '""'
          else:
            globals()[item] = ''

      attachment = '{ "fallback": "' + fallback + '", "color":"' + color + '", "pretext":"' + pretext + '", "author_name":"' + author_name + '", "author_link":"' + author_link + '", "author_icon":"' + author_icon + '", "title":"' + title + '", "title_link":"' + title_link + '", "text":"' + text + '", "fields":' + fields + ', "image_url":"' + image_url + '", "thumb_url":"' + thumb_url + '", "footer":"' + footer + '", "footer_icon":"' + footer_icon + '", "ts":"' + footer_timestamp + '"}'
      print attachment
  outputs:
    - attachment: ${attachment}
  results:
    - SUCCESS
