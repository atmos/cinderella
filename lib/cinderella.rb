require "etc"
require "json"
require "tmpdir"
require "rest_client"
require "cinderella/version"

module Cinderella
  class Runner
    RECOMMENDED_LLVM   = 2206
    MACOS_FULL_VERSION = `/usr/bin/sw_vers -productVersion`.chomp
    MACOS_VERSION      = /(10\.\d+)(\.\d+)?/.match(MACOS_FULL_VERSION).captures.first.to_f

    def self.run
      new.run
    end

    def self.run_unstable
      ENV['CINDERELLA_RELEASE'] = 'origin/master'
      run
    end

    def self.uninstall
      new.uninstall
    end

    def self.binary_install
      new.binary_installer
    end

    def self.version
      puts "Cinderella Version: #{Cinderella::VERSION}"
    end

    def root_dir
      @root_dir ||=
        if ENV['SMEAGOL_ROOT_DIR']
          "#{ENV['SMEAGOL_ROOT_DIR']}/Developer"
        else
          "~/Developer"
        end
    end

    def uninstall
      services = %w/memcached mysql redis mongodb postgresql/
      services.each do |service|
        puts "Stopping Server: #{service} "
        sleep 0.5
        system("lunchy stop #{service}")
      end
      puts ""
      puts "Removing #{root_dir}/Developer"
      system("rm -rf ~/.cinderella.profile #{root_dir}/Developer")
      puts "Cinderella successfully uninstalled"
    end

    def binary_installer
      log_file   = "#{Dir.tmpdir}/cinderella.binary.output.txt"
      local_file = "#{Dir.tmpdir}/cinderella-0.3.2.tar.gz"
      local_user = `whoami`.chomp

      unless File.exists?("/opt")
        puts "You don't have an /opt directory, we need sudo access for this."
        puts "You'll only be prompted for your password once."
        `sudo mkdir -p /opt`
        `sudo chown #{local_user}:staff /opt`
      end
      unless File.exists?(local_file)
        puts `curl -o #{local_file} #{binary_url}`
      end
      if File.exists?(local_file)
        puts "Extracting #{local_file} to /opt"
        `tar zxvf #{local_file} -C /opt > #{log_file} 2>&1`
        if $?.success?
          post_install
          puts "\n\nCinderella successfully installed"
          puts "Open up a new terminal and you're ready to go!"
        else
          puts "Something went wrong installing cinderella, logs at #{log_file}"
          exit 1
        end
      else
        puts "Had issues downloading the binary installer. Sorry, bro."
        exit 1
      end
    end

    def post_install
      script_file = "#{Dir.tmpdir}/cinderella.post_install.sh"

      File.open(script_file, "w") do |fp|
        fp.puts "#!/bin/bash"
        fp.puts "source /opt/Developer/cinderella.profile"
        fp.puts "cinderella"
      end
      `bash #{script_file}`
    end

    def binary_url
      "http://cinderella.s3.amazonaws.com/cinderella-0.3.2.tar.bz2"
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
      when '/usr/bin/ruby', /#{root_dir}/
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

    def warn(msg)
      $stderr.puts msg
    end

    def download_solo_rb
      response = RestClient.get(ENV['SOLO_URL'])
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
