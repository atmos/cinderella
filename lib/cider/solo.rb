#
# Chef Solo Config File
#

cider_root      = File.expand_path("~/.cider")

log_level       :info
log_location    STDOUT

recipe_url      "http://ciderapp.org/cider.tgz"
json_attribs    "http://ciderapp.org/latest"

file_cache_path "#{cider_root}"
cookbook_path   "#{cider_root}/smeagol/cookbooks"
recipe_path     "#{cider_root}/smeagol/cookbooks"
cache_options   ({ :path => "#{cider_root}/cache/checksums", :skip_expires => true })
