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

  post '/urls' do
    urls, paths = params['url'].reject{|u| u.empty? }, params['path'].reject!{|p| p.empty? }
    hash = Hash[*paths.zip(urls).flatten]
    Timelapse::Images.update_urls! hash
    erb :urls, :locals => {:message => 'URLs saved!'}
  end

  post '/take' do
    Timelapse::Images.take_new_screenshots!
    redirect '/'
  end

end
