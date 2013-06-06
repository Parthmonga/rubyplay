#!/usr/bin/env ruby

require "rubygems"
require "yaml"
require "net/http"
require "uri"
require "twitter_oauth"
require 'digest/md5'
require "json"
require "active_record"
require "pg"
require 'zip/zip'
require 'zip/zipfilesystem'
require 'open-uri'
require 'aws/s3'


yamlstring = ''
File.open("./auth.yaml", "r") { |f|
  yamlstring = f.read
}

@settings = YAML::load(yamlstring)

AWS::S3::Base.establish_connection!(
    :access_key_id     => @settings['access_key_id'],
    :secret_access_key => @settings['secret_access_key']
)

ActiveRecord::Base.establish_connection(
    :adapter => "postgresql",
    :database => "#{@settings['database']}",
    :username => "#{@settings['username']}",
    :password => "",
    :host => "#{@settings['host']}",
    :port => @settings['port'],
    :pool => 8
)

class User < ActiveRecord::Base
end

class Post < ActiveRecord::Base
end


class Photo
  attr_accessor :path, :url, :text, :file
end

def generate_zip(username, user_mail)
  folder = "#{URI::encode(username)}_#{Date.today.to_s}"

  user = User.find_by_slug(username)
  object = Post.where("user_id = ? and deleted = 'f'", user.id)
  temp_dir = Dir.mktmpdir
  puts temp_dir
  Dir.mkdir(File.join(temp_dir, folder), 0744)
  photos = Array.new
  i = 0
  object.each do |posts|
    puts "-----------[#{i}]-----------"
    puts posts.original_media_url
    puts posts.text
    puts URI::encode posts.text[0..20]
    # get suffix
    unless posts.original_media_url.nil?
      # get file_name
      
      a_url_slashes = posts.original_media_url.split('/')
      file_name = a_url_slashes[a_url_slashes.count-1]
      

      open("#{temp_dir}/#{folder}/#{file_name}", 'wb') do |file|
        file << open(posts.original_media_url).read
      end
      photo = Photo.new
      photo.path = "#{temp_dir}/#{folder}/#{file_name}" 
      puts photo.path
      photo.file = file_name
      photo.url =  posts.original_media_url
      photo.text = posts.text
      photos << photo
      photo = nil
    end
    puts "-----------[#{i}]-----------"
    i = i + 1
  end
  
  # base temp dir
  # path for zip we are about to create, I find that ruby zip needs to write to a real file
  # This assumes the ObjectWithImages object has an attribute title which is a string.
  zip_path = File.join(temp_dir, "#{URI::encode(username)}_#{Date.today.to_s}.zip")

  puts zip_path
  Zip::ZipOutputStream.open(zip_path) do |zos|
    photos.each do |photo|
      # path = photo.path
      zos.put_next_entry("#{folder}/#{photo.file}")
      # zos.write open("#{temp_dir}/#{folder}/#{photo.file}").read
      zos.print IO.read("#{temp_dir}/#{folder}/#{photo.file}")
    end
  end

  exit
  # bucket = 'upload.via.me/photos'
  bucket = 'pic.via.me'
  begin
    puts 'uploading...'
    AWS::S3::S3Object.store("#{URI::encode(username)}_#{Date.today.to_s}.zip", open(zip_path), bucket, :access => :public_read)
  rescue => error
    puts "S3 Upload failed"
    puts error.inspect
    exit
  end

  puts "http://#{bucket}.s3.amazonaws.com/#{URI::encode(username)}_#{Date.today.to_s}.zip"
  # ensure 
  #   FileUtils.rm_rf temp_dir if temp_dir

end

generate_zip('barce',MY_EMAIL)
