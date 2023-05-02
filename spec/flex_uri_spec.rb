# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/flex_uri'

# rubocop:disable Metrics/BlockLength
RSpec.describe FlexUri do
  let(:flex_uri) { FlexUri.create('https://example.com') }

  describe '#add_path' do
    it 'adds a path to the URI' do
      flex_uri.add_path('/test/path')
      expect(flex_uri.uri.path).to eq('/test/path')
    end
  end

  describe '#insert_query' do
    it 'inserts new query parameters' do
      flex_uri.insert_query(param1: 'value1', param2: 'value2', param3: 'value3')
      expect(flex_uri.uri.query).to include('param1=value1', 'param2=value2', 'param3=value3')
    end
  end

  describe '#remove_query_key' do
    it 'removes the specified query parameter' do
      flex_uri.insert_query(param1: 'value1', param2: 'value2')
      flex_uri.remove_query_key(:param1)
      expect(flex_uri.uri.query).not_to include('param1=value1')
    end
  end

  describe '#update_query' do
    it 'updates existing query parameters' do
      flex_uri.insert_query(param1: 'value1', param2: 'value2')
      flex_uri.update_query(param1: 'updated_value1', param3: 'value3')
      expect(flex_uri.uri.query).to include('param1=updated_value1', 'param2=value2', 'param3=value3')
    end
  end

  describe '#scheme' do
    it 'updates the URI scheme' do
      flex_uri.scheme('http')
      expect(flex_uri.uri.scheme).to eq('http')
    end
  end

  describe '#host' do
    it 'updates the URI host' do
      flex_uri.host('example.org')
      expect(flex_uri.uri.host).to eq('example.org')
    end
  end

  describe '#port' do
    it 'updates the URI port' do
      flex_uri.port(8080)
      expect(flex_uri.uri.port).to eq(8080)
    end
  end

  describe '#user' do
    it 'sets the URI user' do
      flex_uri.user('username')
      expect(flex_uri.uri.user).to eq('username')
    end
  end

  describe '#pass' do
    it 'raises an error if user component is missing' do
      expect { flex_uri.pass('password') }.to raise_error(URI::InvalidURIError,
                                                          'password component depends user component')
    end

    it 'sets the URI password' do
      flex_uri.user('username')
      flex_uri.pass('password')
      expect(flex_uri.uri.password).to eq('password')
    end
  end

  describe '#fragment' do
    it 'sets the URI fragment' do
      flex_uri.fragment('section1')
      expect(flex_uri.uri.fragment).to eq('section1')
    end
  end

  describe '#query_string' do
    it 'sets the query string' do
      flex_uri.query_string('param1=value1&param2=value2')
      expect(flex_uri.uri.query).to eq('param1=value1&param2=value2')
    end
  end

  describe '#path' do
    it 'sets the URI path with proper encoding' do
      flex_uri.path('/test path/with spaces')
      expect(flex_uri.uri.path).to eq('/test%20path/with%20spaces')
    end
  end

  describe '#truncate_path' do
    it 'truncates the URI path and removes query and fragment' do
      flex_uri.add_path('/test/path').insert_query(param1: 'value1', param2: 'value2').fragment('section1')
      flex_uri.truncate_path('/new/path')
      expect(flex_uri.uri.path).to eq('/new/path')
      expect(flex_uri.uri.query).to be_nil
      expect(flex_uri.uri.fragment).to be_nil
    end
  end

  describe '#order_query_params' do
    it 'orders the query parameters alphabetically' do
      flex_uri.insert_query(param3: 'value3', param1: 'value1', param2: 'value2')
      flex_uri.order_query_params
      expect(flex_uri.uri.query).to eq('param1=value1&param2=value2&param3=value3')
    end
  end

  describe '#resolve_relative' do
    it 'resolves a relative URL against the current URI' do
      flex_uri.path('/current/path').insert_query(param1: 'value1', param2: 'value2')
      flex_uri.resolve_relative('../another/path')
      expect(flex_uri.uri.to_s).to eq('https://example.com/another/path?param1=value1&param2=value2')
    end
  end

  describe '#parse' do
    it 'parses a new URL and updates the URI object' do
      flex_uri.parse('https://new.example.com/path?param=value')
      expect(flex_uri.uri.to_s).to eq('https://new.example.com/path?param=value')
    end
  end

  describe '#validate' do
    it 'raises an error if the URI object is invalid' do
      invalid_uri = FlexUri.create('https://')
      expect { invalid_uri.validate }.to raise_error(URI::InvalidURIError, 'URI is invalid')
    end

    it 'returns self if the URI object is valid' do
      valid_uri = FlexUri.create('https://example.com')
      expect(valid_uri.validate).to eq(valid_uri)
    end
  end

  describe '#build' do
    it 'returns the URI as a string' do
      flex_uri.path('/path').insert_query(param1: 'value1', param2: 'value2')
      expect(flex_uri.build).to eq('https://example.com/path?param1=value1&param2=value2')
    end
  end
end
# rubocop:enable Metrics/BlockLength
