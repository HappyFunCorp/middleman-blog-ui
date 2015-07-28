# encoding: UTF-8

require 'middleman-core'

::Middleman::Extensions.register(:blog_ui) do
  module Middleman::Blog::Ui
    SOURCE_DIR = File.expand_path(File.join('..', '..', 'source'), __FILE__)
  end

  require 'middleman/blog/ui/extension'
  ::Middleman::Blog::Ui::Extension
end