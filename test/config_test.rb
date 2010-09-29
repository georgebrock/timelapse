require File.expand_path('../test_helper', __FILE__)

class ConfigTest < Test::Unit::TestCase

  context 'The URL configuration' do
    setup do
      File.unlink Timelapse::Images::URLS_PATH if File.exists? Timelapse::Images::URLS_PATH
    end

    should 'load and save URLs' do
      new_data = {'example.com/home_page' => 'http://www.example.com'}
      assert_equal Hash.new, Timelapse::Images.urls
      Timelapse::Images.update_urls! new_data
      assert_equal new_data.sort, Timelapse::Images.urls
    end
  end

end
