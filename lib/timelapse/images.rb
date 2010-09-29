module Timelapse::Images

  URLS_PATH =  File.expand_path('config/urls.yml', Timelapse::ROOT_PATH)

  def self.urls
    if File.exists? URLS_PATH
      YAML.load(File.read(URLS_PATH)).sort
    else
      {}
    end
  end

  def self.update_urls!(hash)
    File.open(URLS_PATH, 'w'){|f| f << YAML.dump(hash) }
  end

  def self.images
    images = {}
    urls.map do |path, url|
      image_subset = images
      path_components = path.split('/')
      path_components.each do |p|
        if p == path_components.last
          image_subset[p] = {
            :url => url,
            :path => path,
            :images => Dir["#{Timelapse::ROOT_PATH}/public/images/#{path}/*-full.png"].sort,
            :thumbs => Dir["#{Timelapse::ROOT_PATH}/public/images/#{path}/*-thumb.png"].sort
          }
        else
          image_subset[p] ||= {}
          image_subset = image_subset[p]
        end
      end
    end
    images
  end

  def self.take_new_screenshots!
    webkit2png = File.expand_path('vendor/webkit2png', Timelapse::ROOT_PATH)
    urls.each do |folder, url|
      output_path = File.join(Timelapse::ROOT_PATH, 'public', 'images', folder)
      FileUtils.mkdir_p output_path

      output_filename = File.join(output_path, DateTime.now.strftime('%F%H%M%S'))
      system(webkit2png, '-F', '-W', '1024', '-o', output_filename, url)
      system(webkit2png, '-T', '-W', '320', '-o', output_filename, url)
    end
  end

end
