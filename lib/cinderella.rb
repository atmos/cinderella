require "etc"
require "json"
require "tmpdir"
require "rest_client"

module Cider
  VERSION = "0.2.7"

  class Runner
    RECOMMENDED_LLVM   = 2206
    MACOS_FULL_VERSION = `/usr/bin/sw_vers -productVersion`.chomp
    MACOS_VERSION      = /(10\.\d+)(\.\d+)?/.match(MACOS_FULL_VERSION).captures.first.to_f

    def self.run
      new.run
    end

    def self.uninstall
      new.uninstall
    end

    def self.version
      puts "Cinderella Version: #{Cider::VERSION}"
    end

    def uninstall
      print "Stopping Service: "
      services = %w/memcached mysql redis mongodb postgresql/
      services.each do |service|
        print "#{service} "
        sleep 0.5
        system("lunchy stop #{service}")
      end
      puts ""
      puts "Removing ~/Developer"
      system("rm -rf ~/.cinderella.profile ~/Developer")
      puts "Cinderella successfully uninstalled"
    end

    def run
      if root?
        warn "#{$0} should not be run as root, try again as a normal user"
        exit 1
      end

      unless sane_os_version?
        warn "You should really upgrade to snow leopard"
        warn "Make sure you have xcode installed and cross your fingers"
        warn "I've seen it work on leopard though..."
      end

      unless sane_xcode_version?
        $stderr.puts "You need xcode for this to work :\\"
        exit(1)
      end

      if sketchy_ruby?
        warn "You have a pre-existing ruby install that might mess with installation"
        warn "I'm going to continue anyway, *fingers crossed* ;)"
      end

      system("rm -rf ~/.cinderella")
      system("chef-solo -c #{config}")
      exit($?.to_i)
    end

    def config
      download_solo_rb
      filename
    end

    private

    def sketchy_ruby?
      case `which ruby`.chomp
      when '/usr/bin/ruby', /#{ENV['HOME']}\/Developer/
        false
      else
        true
      end
    end

    def root?
      Etc.getpwuid.uid == 0
    end

    def sane_os_version?
      MACOS_VERSION >= 10.6
    end

    def sane_xcode_version?
      xcode_path = `/usr/bin/xcode-select -print-path`.chomp
      if xcode_path.empty?
        false
      elsif `#{xcode_path}/usr/bin/llvm-gcc-4.2 -v 2>&1` =~ /LLVM build (\d{4,})/
        if $1.to_i < RECOMMENDED_LLVM
          warn "You should really upgrade your xcode install"
        end
        true
      end
    end

    def warn(msg)
      $stderr.puts msg
    end

    def download_solo_rb
      response = RestClient.get("http://ciderapp.org/solo.rb")
      if response.code == 200
        File.open(filename, "w") do |fp|
          fp.write(response.body)
        end
      end
    end

    def filename
      @filename ||= File.expand_path(File.join(Dir.tmpdir, "cinderella.rb"))
    end
  end
end
