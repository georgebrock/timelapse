module Timelapse::Helpers

  def urls
    Timelapse::Images.urls
  end

  def images
    Timelapse::Images.images
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

end
