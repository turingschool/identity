# This is b/c it will render times like created_at into JSON using a format that only it can parse without copying/pasting Rails code
# https://github.com/rails/rails/blob/5adf6ca9719f3aa520b684c352da5f91ab17ec49/activesupport/lib/active_support/core_ext/object/json.rb#L186
# https://github.com/rails/rails/blob/5adf6ca9719f3aa520b684c352da5f91ab17ec49/activesupport/lib/active_support/values/time_zone.rb#L285-304
ActiveSupport::JSON::Encoding.use_standard_json_time_format = false
