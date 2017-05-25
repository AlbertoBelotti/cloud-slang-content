########################################################################################################################
#!!
#! @description: Build distinctive messages referencing images, external websites, and highlight relevant pieces of data. Then simplify team workflows by attaching interactive buttons.
#!               Attachments let you add more context to a message, making them more useful and effective. For more information check slack api website: https://api.slack.com/docs/message-attachments
#!
#! @input title: The title is displayed as larger, bold text near the top of a message attachment.
#! @input title_link: By passing a valid URL in the title_link parameter (optional), the title text will be hyperlinked.
#! @input text: This is the main text in a message attachment, and can contain standard message markup. The content will automatically collapse if it contains 700+ characters or 5+ linebreaks, and will display a "Show more..." link to expand the content. Links posted in the text field will not unfurl.
#! @input pretext: This is optional text that appears above the message attachment block.
#! @input color: Like traffic signals, color-coding messages can quickly communicate intent and help separate them from the flow of other messages in the timeline.  An optional value that can either be one of good, warning, danger, or any hex color code (eg. #439FE0). This value is used to color the border along the left side of the message attachment.
#! @input fallback: A plain-text summary of the attachment. This text will be used in clients that don't show formatted text (eg. IRC, mobile notifications) and should not contain any markup.
#! @input author_name: The author parameters will display a small section at the top of a message attachment that can contain the athor_name: Small text used to display the author's name.
#! @input author_link: The author parameters will display a small section at the top of a message attachment that can contain the athor_link:  valid URL that will hyperlink the author_name text mentioned above. Will only work if author_name is present.
#! @input author_icon: The author parameters will display a small section at the top of a message attachment that can contain the athor_icon: The author parameters will display a small section at the top of a message attachment that can contain the athor_link:  valid URL that will hyperlink the author_name text mentioned above. Will only work if author_name is present.
#! @input fields: Fields are defined as an array, and hashes contained within it will be displayed in a table inside the message attachment. This input should be provided as a JSON array having the following format: [{"title":"This is title", "value":"This is value", "short":true},{...},...] Title - Shown as a bold heading above the value text. It cannot contain markup and will be escaped for you. Value - The text value of the field. It may contain standard message markup and must be escaped as normal. May be multi-line. Short - An optional flag indicating whether the value is short enough to be displayed side-by-side with other values.
#! @input image_url: A valid URL to an image file that will be displayed inside a message attachment. We currently support the following formats: GIF, JPEG, PNG, and BMP.  Large images will be resized to a maximum width of 400px or a maximum height of 500px, while still maintaining the original aspect ratio.
#! @input thumb_url: A valid URL to an image file that will be displayed as a thumbnail on the right side of a message attachment. We currently support the following formats: GIF, JPEG, PNG, and BMP.  The thumbnail's longest dimension will be scaled down to 75px while maintaining the aspect ratio of the image. The filesize of the image must also be less than 500 KB.  For best results, please use images that are already 75px by 75px.
#! @input footer_icon: To render a small icon beside your footer text, provide a publicly accessible URL string in the footer_icon field. You must also provide a footer for the field to be recognized.  We'll render what you provide at 16px by 16px. It's best to use an image that is similarly sized.  Example: "https://platform.slack-edge.com/img/default_application_icon.png"
#! @input footer_timestamp: Does your attachment relate to something happening at a specific time?  By providing the ts field with an integer value in "epoch time", the attachment will display an additional timestamp value as part of the attachment's footer.  Use ts when referencing articles or happenings. Your message will have its own timestamp when published.  Example: Providing 123456789 would result in a rendered timestamp of Nov 29th, 1973.
#!!#
########################################################################################################################
namespace: io.cloudslang.slack.utilities
flow:
  name: format_slack_attachment
  inputs:
    - title:
        required: false
    - title_link:
        required: false
    - text: This text was sent from OO
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
    - footer_icon:
        required: false
    - footer_timestamp:
        required: false
  workflow:
    - initialize_if_null:
        do:
          io.cloudslang.base.utils.initialize_if_null:
            - list_of_variables: 'fallback,color,pretext,author_name,author_link,author_icon,title,title_link,text,fields,image_url,thumb_url,footer,footer_icon,footer_timestamp'
        navigate:
          - SUCCESS: print_test
    - print_test:
        do:
          io.cloudslang.base.print.print_text:
            - text: ${globals()[title]}
        navigate:
          - SUCCESS: append
    - append:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: ''
            - text: "${'{ \"fallback\": ' + fallback + ', \"color\":' + color + ', \"pretext\":' + pretext + ', \"author_name\":' + author_name + ', \"author_link\":' + author_link + ', \"author_icon\":' + author_icon + ', \"title\":' + title + ', \"title_link\":' + title_link + ', \"text\":' + text + ', \"fields\":' + fields + ', \"image_url\":' + image_url + ', \"thumb_url\":' + thumb_url + ', \"footer\":' + footer + ', \"footer_icon\":' + footer_icon + ', \"ts\":' + footer_timestamp + '}'}"
        publish:
          - attachment: '${new_string}'
        navigate:
          - SUCCESS: print
    - print:
        do:
          io.cloudslang.base.print.print_text:
            - text: '${attachment}'
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - attachment: '${attachment}'
  results:
    - SUCCESS
