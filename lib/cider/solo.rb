#
# Chef Solo Config File
#
require 'tmpdir'

root           = "#{Dir.tmpdir}/cider"

log_level       :info
log_location    STDOUT

recipe_url      "http://ciderapp.org/cider.tgz"
json_attribs    "http://ciderapp.org/latest"

cookbook_path   [ "#{root}/smeagol/cookbooks" ]

file_cache_path "#{root}/cookbooks"
cache_options   ({ :path => "#{root}/cache/checksums", :skip_expires => true })
