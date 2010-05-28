require "json"
require "tmpdir"
require "rest_client"

module Cider
  class Runner
    def self.run
      new.run
    end

    def run
      system("rm -rf ~/.cider")
      system("chef-solo -c #{config}")
      exit($?)
    end

    def config
      @config ||= File.expand_path(File.join(File.dirname(__FILE__), "cider", "solo.rb"))
    end
  end
end
