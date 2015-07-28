require 'middleman/blog/ui/api_server'
require 'react/source'
require 'sprockets/coffee-react'

module Middleman
  module Blog
    module Ui
      # Middleman extension entry point
      class Extension < Middleman::Extension
        def initialize(app, options_hash = {}, &block)
          super

          puts "== Starting API Server on /api"
          app.map "/api" do
            run ApiServer
          end

          ::Sprockets.register_preprocessor 'application/javascript', ::Sprockets::CoffeeReact
        end

        def after_configuration
          # p "after_configuration"
          register_extension_templates
          Dir.glob( "#{SOURCE_DIR}/javascripts/**/*" ).each do |f|
            # p "Adding #{f}"
            app.sprockets.append_path File.dirname(f)
          end
          Dir.glob( "#{SOURCE_DIR}/stylesheets/*" ).each do |f|
            # p "Adding #{f}"
            app.sprockets.append_path File.dirname(f)
          end
          app.sprockets.append_path File.dirname(::React::Source.bundled_path_for('react.js'))
        end

        def manipulate_resource_list(resources)
          # p "manipulate_resource_list"
          Dir.glob( "#{SOURCE_DIR}/**/*" ).each do |path|
            unless File.directory? path
              resources << make_template( path, path.gsub( /#{SOURCE_DIR}\//, "" ) )
            end
          end
          # resources << make_template( "#{SOURCE_DIR}/stylesheets/admin.css.scss", "stylesheets/admin.css" )
          resources
        end

        private
        def register_extension_templates
          # We call reload_path to register the templates directory with Middleman.
          # The path given to app.files must be relative to the Middleman site's root.
          templates_dir_relative_from_root = Pathname(SOURCE_DIR).relative_path_from(Pathname(app.root))
          app.files.reload_path(templates_dir_relative_from_root)
        end

        def make_template( file, name )
          name = name.gsub( /.erb/, "" ).gsub( /.haml/, "" ).gsub( /.coffee/, "" ).gsub( /.scss/, "" )
          # puts "Adding #{name}"
          Middleman::Sitemap::Resource.new(app.sitemap, name, file).tap do |resource|
            resource.add_metadata(options: { layout: false }, locals: {})
          end
        end
      end
    end
  end
end
