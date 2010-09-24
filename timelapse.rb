require 'sinatra/base'
require 'fileutils'
require 'erb'

def urls
  YAML.load(File.read('config/urls.yml'))
end

def images
  images = {}
  urls.map do |path, url|
    image_subset = images
    path_components = path.split('/')
    path_components.each do |p|
      if p == path_components.last
        image_subset[p] = {
          :url => url,
          :path => path,
          :images => Dir["public/images/#{path}/*-full.png"].sort,
          :thumbs => Dir["public/images/#{path}/*-thumb.png"].sort
        }
      else
        image_subset[p] ||= {}
        image_subset = image_subset[p]
      end
    end
  end
  images
end

def render_images(images = images, heading_level = 2)
  images.inject('') do |html, (title, data)|
    heading = "<h#{heading_level}>#{title.gsub('_', ' ').capitalize}</h#{heading_level}>"

    if data.keys.include?(:thumbs) and data[:thumbs].any?
      image_url = data[:thumbs].last.sub(/^.*public/, '')
      html + <<-HTML
        <div class='shot'>
          #{heading}
          <a href='#{image_url.sub('thumb', 'full')}'>
            <img src='#{image_url}' alt='' />
          </a>
        </div>
      HTML
    elsif data.keys.include?(:thumbs)
      html + <<-HTML
        <div class='shot'>
          #{heading}
          <span class='missing'>No images yet.</span>
        </div>
      HTML
    else
      html + <<-HTML
        <div class='shot'>
          #{heading}
          #{render_images(data, heading_level+1)}
        </div>
      HTML
    end
  end
end


class Timelapse < Sinatra::Base
  get '/' do
    erb :index
  end

  post '/take' do
    urls.each do |folder, url|
      output_path = File.join(File.dirname(__FILE__), 'public/images', folder)
      FileUtils.mkdir_p output_path

      output_filename = File.join(output_path, DateTime.now.strftime('%F%H%M%S'))
      system('webkit2png', '-F', '-W', '1024', '-o', output_filename, url)
      system('webkit2png', '-T', '-W', '320', '-o', output_filename, url)
    end

    redirect '/'
  end
end
