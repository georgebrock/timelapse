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

    context 'when updating the URLs with invalid data' do
      should 'reject invalid URLs' do
        assert_raises(ArgumentError) do
          Timelapse::Images.update_urls! 'invalid/url' => 'invalid!'
        end
      end

      should 'reject absolute paths' do
        assert_raises(ArgumentError) do
          Timelapse::Images.update_urls! '/var' => 'http://www.example.com'
        end
      end

      should 'reject paths that resolve to a parent directory' do
        assert_raises(ArgumentError) do
          Timelapse::Images.update_urls! '../../' => 'http://www.example.com'
        end
      end
    end
  end

end
