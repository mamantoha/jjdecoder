require 'test_helper'

class JJDecoderTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::JJDecoder::VERSION
  end
end

describe JJDecoder do
  describe 'encoded string' do
    let(:encoded_string) { File.open(File.expand_path '../fixtures/test1.txt', __FILE__).read }

    it 'should be encoded' do
      decoded_string = JJDecoder.new(encoded_string).decode
      decoded_string.must_equal 'alert("Hello, JavaScript" )'
    end
  end

  describe 'encoded string with palindrome' do
    let(:encoded_string) { File.open(File.expand_path '../fixtures/test2.txt', __FILE__).read }

    it 'should be encoded' do
      decoded_string = JJDecoder.new(encoded_string).decode
      decoded_string.must_equal 'alert("Hello, JavaScript" )'
    end
  end

  describe 'encoded string with palindrome and global variable $@#' do
    let(:encoded_string) { File.open(File.expand_path '../fixtures/test3.txt', __FILE__).read }

    it 'should be encoded' do
      decoded_string = JJDecoder.new(encoded_string).decode
      decoded_string.must_equal 'alert("Hello, JavaScript" )'
    end
  end
end

