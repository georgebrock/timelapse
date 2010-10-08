class Timelapse::App < Sinatra::Base
  include Timelapse::Helpers

  get '/' do
    if urls.any?
      erb :index
    else
      erb :urls, :locals => {:message => 'Set up some URLs first'}
    end
  end

  get '/urls' do
    erb :urls
  end

  get '/shots/*' do
    path = params[:splat].first
    title = path.split('/').map{|s| s.gsub('_', ' ').capitalize }.join(' ▸ ')
    images = Timelapse::Images.images_for_path(path, :full).map{|path| {:url => path.sub(/^.*public/, ''), :date => File.mtime(path)} }
    erb :shots, :locals => {:title => title, :images => images}
  end

  post '/urls' do
    urls, paths = params['url'].reject{|u| u.empty? }, params['path'].reject!{|p| p.empty? }
    hash = Hash[*paths.zip(urls).flatten]
    begin
      Timelapse::Images.update_urls! hash
      erb :urls, :locals => {:message => 'URLs saved!'}
    rescue ArgumentError => e
      erb :urls, :locals => {:message => "Oh noes! Something went wrong: #{e.message}"}
    end
  end

  post '/take' do
    Timelapse::Images.take_new_screenshots!
    redirect '/'
  end

end
