require 'rails/generators'

module Gretel
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    class_option :from_routes, type: :boolean, default: false, aliases: '-R', desc: 'Generate from config/routes.rb'
    class_option :link_text_attr_name, type: :string, default: 'name', desc: 'Attribute name to use for link text when generate from config/routes.rb'

    desc 'Creates a sample configuration file in config/breadcrumbs.rb'
    def create_config_file
      copy_file 'breadcrumbs.rb', 'config/breadcrumbs.rb' do |content|
        if options[:from_routes]
          Gretel::RouteCrumbsGenerator.generate(link_text_attr_name: options[:link_text_attr_name])
        else
          content
        end
      end
    end
  end
end
