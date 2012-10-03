#!/usr/bin/env ruby
require 'rubygems'
require 'sass'

sass_filename = "style.sass"
css = Sass::Engine.for_file(sass_filename, {}).render
File.open("style.css", "wb") {|f| f.write(css) }



