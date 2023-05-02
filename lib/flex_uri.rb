# frozen_string_literal: true

require 'uri'
require 'pathname'

# FlexUriUtils contains utility methods used in the FlexUri class.
module FlexUriUtils
  def self.to_query(hash)
    URI.encode_www_form(hash)
  end

  def self.symbolize_keys!(hash)
    hash.transform_keys!(&:to_sym)
  end
end

# FlexUri is a class for flexible manipulation of URIs.
class FlexUri
  attr_reader :uri

  ENCODING_REGEXP = /([^a-zA-Z0-9_.-]+)/.freeze

  def self.create(url)
    new(URI.parse(url))
  end

  def initialize(uri)
    @uri = uri
  end

  def add_path(path)
    @uri.path = File.join(@uri.path, path)
    self
  end

  def insert_query(params)
    query_hash = parse_query(@uri.query)
    query_hash.merge!(params)
    @uri.query = FlexUriUtils.to_query(query_hash)
    self
  end

  def remove_query_key(key)
    query_hash = parse_query(@uri.query)
    query_hash.delete(key.to_sym)
    @uri.query = FlexUriUtils.to_query(query_hash)
    self
  end

  def update_query(params)
    query_hash = parse_query(@uri.query)
    query_hash.merge!(params)
    @uri.query = FlexUriUtils.to_query(query_hash)
    self
  end

  def scheme(scheme, default: nil)
    @uri.scheme = scheme || default
    self
  end

  def host(host, default: nil)
    @uri.host = host || default
    self
  end

  def port(port, default: nil)
    @uri.port = port || default
    self
  end

  def user(user)
    @uri.user = user
    self
  end

  def pass(pwd)
    raise URI::InvalidURIError, 'password component depends user component' unless @uri.user

    @uri.password = pwd
    self
  end

  def fragment(fragment)
    @uri.fragment = fragment
    self
  end

  def query_string(q_string)
    @uri.query = q_string
    self
  end

  def path(path)
    @uri.path = path.split('/').map { |part| URI.encode_www_form_component(part) }.join('/').gsub('+', '%20')
    self
  end

  def truncate_path(path)
    @uri.path = path
    @uri.query = nil
    @uri.fragment = nil
    self
  end

  def order_query_params
    query_hash = parse_query(@uri.query)
    sorted_query = query_hash.sort.to_h
    @uri.query = FlexUriUtils.to_query(sorted_query)
    self
  end

  def resolve_relative(relative_url)
    relative_uri = URI.parse(relative_url)
    @uri.path = Pathname.new(File.join(File.dirname(@uri.path), relative_uri.path)).cleanpath.to_s
    @uri.query = relative_uri.query if relative_uri.query
    self
  end

  def parse(url)
    @uri = URI.parse(url)
    self
  end

  def validate
    raise URI::InvalidURIError, 'URI is invalid' unless @uri.scheme && @uri.host

    self
  end

  def build
    @uri.to_s
  end

  private

  def parse_query(query_string)
    query_string ||= ''
    query_hash = URI.decode_www_form(query_string).to_h
    FlexUriUtils.symbolize_keys!(query_hash)
    query_hash
  end
end
