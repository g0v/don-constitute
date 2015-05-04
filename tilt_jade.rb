# encoding: utf-8

require 'tilt'
require 'open3'
if defined? Serve
  if !Serve::DynamicHandler.extensions.include?('jade')
    App.alert('Jade Template engine is not loaded, restart Fire.app and watch this project first')
  end
end

module Tilt
  class JadeTemplate < Template
    self.default_mime_type = "text/html"

    def prepare
    end

    def evaluate(scope, locals, &block)

      if File.exists?('/usr/local/bin/jade')
        jade_cmd = '/usr/local/bin/jade --path . -O "{require: require}" -P'
      else
        jade_cmd = 'jade --path . -O "{require: require}" -P'
      end

      pwd = Dir.pwd
      begin
      Dir.chdir( File.dirname(__FILE__)+ '/views')
      body = Open3.popen3(jade_cmd) do |stdin, stdout, stderr|
      stdin.write data
      stdin.close

      stdout.read + stderr.read.gsub(/\n/, '<br>')
      end
	ensure
Dir.chdir(pwd)
	end
      body
    end
  end

  register JadeTemplate, 'jade'
end
