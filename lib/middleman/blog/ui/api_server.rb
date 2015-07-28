require 'sinatra/base'
require 'sinatra/json'
require 'fileutils'

module Middleman
  module Blog
    module Ui
      class ApiServer < Sinatra::Base
        get '/' do
          "This is the api server"
        end

        get '/post' do
          app = load_app

          logger.info "Looking up #{params[:path]}"

          file = app.sitemap.find_resource_by_path params[:path] if params[:path]

          if !file
            status 404
            json error: "Unknown path #{params[:path]}"
          else
            raw = File.read file.source_file
            body = raw.gsub( /^---\n.*?---\n*/m, "" ) # Remove the preyaml

            json meta: file.data, content: body
          end
        end

        post '/post' do
          payload = params 
          payload = JSON.parse(request.body.read).symbolize_keys unless params[:path]

          logger.info "Saving #{payload[:path]} with #{payload[:meta]}"

          file = load_app.sitemap.find_resource_by_path payload[:path]

          if !file
            logger.info "Unknown path: #{payload[:path]}"
            status 404
            json error: "Unknown path #{payload[:path]}"
          else
            File.open( file.source_file, "w" ) do |out|
              out.puts YAML.dump( payload[:meta] )
              out.puts "---"
              out.puts payload[:body]
            end
          end

          json message: "Post saved"
        end

        post '/images' do

          File.open('/tmp/' + params['file'][:filename], "wb") do |f|
            f.write(params['file'][:tempfile].read)
          end

          json message: "Image uploaded"
        end

        post '/build' do
          `bundle exec middleman build 2>&1`
        end

        post '/update' do
          `git pull origin master 2>&1`
        end

        post '/status' do
          `git status 2>&1`
        end

        post '/drafts' do
          if !params[:title]
            status 404
            json error: "Bad Parameters"
          else
            logger.info "Created draft for #{params[:title]}"

            slug = params[:title].downcase.gsub( /[^a-z]/, "-" )

            draft_dir = File.expand_path( "source/drafts", Dir.pwd )
            FileUtils.mkdir_p draft_dir

            outfile = File.expand_path( "source/drafts/#{slug}.html.markdown", Dir.pwd )

            File.open( outfile, "w" ) do |out|
              out.puts YAML.dump( params )
              out.puts "---\n\n# #{params[:title]}\nHere we go!"
            end

            json created: "drafts/#{slug}.html"
          end
        end

        post '/diff' do
          payload = params 
          payload = JSON.parse(request.body.read).symbolize_keys unless params[:path]

          file = load_app.sitemap.find_resource_by_path payload[:path]

          if !file
            logger.info "Unknown path: #{payload[:path]}"
            status 404
            "Unknown path #{payload[:path]}"
          else
            `git diff #{file.source_file} 2>&1`
          end
        end


        post '/publish' do
          payload = params 
          payload = JSON.parse(request.body.read).symbolize_keys unless params[:path]

          file = load_app.sitemap.find_resource_by_path payload[:path]

          if !file
            logger.info "Unknown path: #{payload[:path]}"
            status 404
            "Unknown path #{payload[:path]}"
          else
            `bundle exec middleman publish #{file.source_file} 2>&1`
          end
        end


        post '/deploy' do
          content_type :txt
          stream do |out|
            5.times do
              out << "Hi there\n"
              puts "Hi there"
              sleep 1
            end
          end
          # IO.popen( '/Users/wschenk/src/willschenk.com/longrunning.sh' ) do |io|
          #   stream do |out|
          #     io.each do |s|
          #       puts s
          #       out << s
          #     end
          #   end
          # end
        end

        private
        def load_app
          opts = {}

          app = ::Middleman::Application.server.inst do
            set :environment, opts[:environment].to_sym if opts[:environment]

            # ::Middleman::Logger.singleton(opts[:debug] ? 0 : 1, opts[:instrumenting] || false)
            logger
          end

          app
        end

        def logger
          ::Middleman::Logger.singleton( 1 )
        end
      end
    end
  end
end