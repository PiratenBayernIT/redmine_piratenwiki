require 'redmine'
require 'uri'

Redmine::Plugin.register :redmine_piratenwiki do
  name 'Redmine Piratenwiki plugin'
  author 'Tobias Stenzel'
  description 'Embed Pages from the Piratenwiki in Redmine text fields.'
  version '0.0.1'
  url 'https://github.com/PiratenBayernIT/redmine_piratenwiki'
  author_url 'https://github.com/PiratenBayernIT'

  Redmine::WikiFormatting::Macros.register do
    desc "Embed Piratenwiki Page"
    macro :piratenwiki do |obj, args|
      # Defaults from configuration.
      conf = Redmine::Configuration['piratenwiki']
      host = conf.fetch('host')
      scheme = conf.fetch('scheme')
      options = {
        'width' => conf.fetch('width', '100%'),
        'height' => conf.fetch('height', '400px'),
      }
        
      # Override default control settings with given arguments.
      page, *params = args
      for param in params
        key, val = param.strip().split("=")
        unless options.has_key?(key)
          raise "#{key} not a recognized parameter."
        else
          options[key] = val
        end
      end
      return CGI::unescapeHTML("<iframe src='#{scheme}://#{host}/#{URI.encode(page)}' width='#{options["width"]}' height='#{options["height"]}'></iframe>").html_safe
    end
  end
end

# vim: set sw=2 ts=2 sts=2 expandtab: #
