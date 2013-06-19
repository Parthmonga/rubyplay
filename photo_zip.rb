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
require 'archive/zip'


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
  attr_accessor :path, :url, :text, :file, :created_at
end

def get_suffix(file)
  a_parts = file.split(".")
  suffix = a_parts[a_parts.count-1]
  suffix
end

def newfilename(caption,photo)

  if caption =~ /[^\/?*:;{}\\]+/
    caption = caption.gsub('/','')
    caption = caption.gsub('?','')
    caption = caption.gsub('*','')
    caption = caption.gsub(':','')
    caption = caption.gsub(';','')
    caption = caption.gsub('{','')
    caption = caption.gsub('}','')
    caption = caption.gsub('\\','')
  end
  a_suffix = photo.file.split('.')

  unless a_suffix[a_suffix.count-1].nil?
    suffix = a_suffix[a_suffix.count-1] 
    new_file_name = photo.created_at.strftime("%Y_%m_%d")  + caption + "." + suffix
  else
    new_file_name = photo.created_at.strftime("%Y_%m_%d")  + caption
  end

  new_file_name
  
end

def newcaption(photo,i)
  begin
    unless photo.text[0..20].nil?
      if photo.text.length == 0
        caption = photo.file[(photo.file.length-15)..(photo.file.length-5)]
      else
        caption = photo.text[0..20]
      end
      caption = caption.gsub(" ","_")
      caption = "_" + URI::encode(caption) + "_#{i}"
    end
  rescue => error
    caption = "_media_#{i}"
  end
  caption
end

def generate_zip(username, user_mail)
  user = User.find_by_slug(username)
  puts "username: #{username}"
  puts "user.id: #{user.id}"

  object = Post.where("user_id = ? and deleted = 'f'", user.id)
  temp_dir = Dir.mktmpdir
  puts temp_dir
  photos = Array.new
  folder  = "#{URI::encode(username)}_#{Date.today.to_s}"
  folder2 = "#{URI::encode(username)}_#{Date.today.to_s}_2"
  Dir.mkdir(File.join(temp_dir, folder), 0700)
  Dir.mkdir(File.join(temp_dir, folder2), 0700)
  i = 0
  object.each do |posts|
    puts "-----------[#{i}]-----------"
    puts posts.original_media_url
    unless posts.text.nil?
      puts posts.text
      puts URI::encode posts.text[0..20]
    end
    # get suffix
    unless posts.original_media_url.nil?
      # get file_name
      a_url_slashes = posts.original_media_url.split('/')
      file_name = a_url_slashes[a_url_slashes.count-1]
      file_name = file_name.gsub('(','\(').gsub(')','\)')
      puts "posts.id: #{posts.id}"
      puts "file_name: #{file_name}"
      file_name = "r600x600_#{i}.jpg" if file_name == 'r600x600.jpg'
      puts "modified file_name: #{file_name}"
      puts "temp_dir: #{temp_dir}"

      begin
        if file_name =~ /[\[\]]+/
          %x[wget -O "#{temp_dir}/#{folder}/#{file_name}" #{posts.original_media_url}]
        elsif file_name =~ /[^A-Za-z0-9_.:\/\-]+/
          %x[wget -O "#{temp_dir}/#{folder}/#{file_name}" #{posts.original_media_url}]
        else
          open("#{temp_dir}/#{folder}/#{file_name}", 'wb') do |file|
            file << open(posts.original_media_url).read
          end
        end
      rescue => error
        puts "could not read file"
      end

      puts "done reading remote file"

      puts "running conversion if necessary"
      # a file for zipping needs to have a prefix and a suffix dot-separated
      unless file_name =~ /\./
        # get file extension from FileMagic
        fm = FileMagic.new
        suffix = nil
        if fm.file("#{temp_dir}/#{folder}/#{file_name}") =~ /([A-Za-z]+)\s+/
          suffix = $1
          suffix = suffix.downcase
        end
        FileUtils::cp("#{temp_dir}/#{folder}/#{file_name}", "#{temp_dir}/#{folder}/#{file_name}.#{suffix}")
        file_name = "#{file_name}.#{suffix}"
        fm = nil
      end
      photo = Photo.new
      photo.path = "#{temp_dir}/#{folder}/#{file_name}" 
      photo.file = file_name
      photo.url =  posts.original_media_url
      unless posts.text.nil?
        photo.text = posts.text 
      else
        photo.text = "_media_#{i}"
      end
      photo.created_at = posts.created_at
      photos << photo
      photo = nil

    end # end unless
    puts "-----------[#{i}]-----------"
    i = i + 1
  end

  # copy files from folder to folder2 and rename them
  i = 0
  puts "photos.count: #{photos.count}"
  photos.each do |photo|
    puts "----[#{i}]----"
    puts "photo.text:"
    puts photo.text
    puts "photo.text.length:"
    puts photo.text.length

    caption = newcaption(photo,i)
    puts "caption:"
    puts caption    

    new_file_name = newfilename(caption,photo)
    
    puts "copying #{temp_dir}/#{folder}/#{photo.file} to #{temp_dir}/#{folder2}/#{new_file_name}"
    puts "FileUtils::cp(\"#{temp_dir}/#{folder}/#{photo.file}\", \"#{temp_dir}/#{folder2}/#{new_file_name}\")"
    FileUtils::cp("#{temp_dir}/#{folder}/#{photo.file}", "#{temp_dir}/#{folder2}/#{new_file_name}")
    puts "----[#{i}]----"
    i = i + 1
  end

  # add alt_file
  %x[wget -O "#{temp_dir}/#{folder2}/alt_file.png" http://pic.via.me.s3.amazonaws.com/alt_file.png]
  
  # add index
  fh = File.open("#{temp_dir}/index.html","wb")
  fh.write("<!DOCTYPE html>\n")
  
  fh.write "<head><title>Via.Me Archive</title>"
  fh.write "<style>"
  fh.write "body { font-family: Arial; }"
  fh.write "</style>"
  fh.write "</head>"
  fh.write "<body>"
  fh.write "<center><h1>Archived Media</h1></center>"
  fh.write "<table>"
  fh.write "<tr>"
  
  i=1
  photos.each do |photo|
    caption = newcaption(photo,i-1)
    file = newfilename(caption,photo)
    
    fh.write "<!-- #{i} -->"
    fh.write "<td>"
    suffix = get_suffix(file)
    if suffix =~ /(jpg|jpeg|tif|tiff|gif|png|bmp|name)/i
      fh.write "<a href=\"" + URI::encode(file) + "\"><img width='600' height='600' src=\"" + URI::encode(file) + "\" border=0></a>"
    else
      fh.write "<a href=\"" + URI::encode(file) + "\"><img width='600' height='600' src='alt_file.png' border=0></a>"
    end
    fh.write "<p>#{photo.text}</p>"
    fh.write "</td>"

    if i%2 == 0
      fh.write "</tr>"
      fh.write "<tr>"
    end


    i = i + 1    
    
  end
  
  fh.write "</tr>"
  fh.write "</table>"
  fh.write "</body>"
  fh.write("</html>\n")
  fh.close
  FileUtils::cp("#{temp_dir}/index.html", "#{temp_dir}/#{folder2}/index.html")
  # end add index section
  
  
  # base temp dir
  # path for zip we are about to create, I find that ruby zip needs to write to a real file
  zip_file = "#{URI::encode(username)}_#{Date.today.to_s}_2.zip"
  zip_path = File.join(temp_dir, zip_file)

  puts zip_path

  Dir.chdir(temp_dir) do
    Archive::Zip.archive(zip_file, folder2)
  end

  #    Zip::ZipOutputStream.open(zip_path) do |zos|
  #      photos.each do |photo|
  #        # path = photo.path
  #        zos.put_next_entry("#{folder}/#{photo.file}")
  #        zos.write open("#{temp_dir}/#{folder}/#{photo.file}").read
  #      end
  #    end



  # upload archive
  begin
    AWS::S3::Base.establish_connection!(
      :access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    )

    AWS::S3::S3Object.store(zip_file, open(zip_path), 'pic.via.me', :access => :public_read)
  rescue => error
    puts "upload failed to s3"
    puts error.inspect
    exit
  end
  puts "uploaded to http://pic.via.me.s3.amazonaws.com/#{zip_file}"

end

generate_zip('barce',MY_EMAIL)
