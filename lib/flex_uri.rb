require 'uri'

module FlexUriUtils
  def self.to_query(hash)
    hash.map { |k, v| "#{URI.encode_www_form_component(k.to_s)}=#{URI.encode_www_form_component(v.to_s)}" }.join('&')
  end

  def self.symbolize_keys!(hash)
    hash.transform_keys!(&:to_sym)
  end
end

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
    @uri.query = query_hash.to_query
    self
  end

  def remove_query_key(key)
    query_hash = parse_query(@uri.query)
    query_hash.delete(key.to_s)
    @uri.query = query_hash.to_query
    self
  end

  def update_query(params)
    query_hash = parse_query(@uri.query)
    query_hash.merge!(params)
    @uri.query = query_hash.to_query
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

  def pass(pass)
    @uri.password = pass
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
    @uri.path = path
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
    @uri.query = sorted_query.to_query
    self
  end

  def encode_uri
    encoded_uri = @uri.to_s.gsub(ENCODING_REGEXP) { |m| URI.encode_www_form_component(m) }
    @uri = URI.parse(encoded_uri)
    self
  end

  def resolve_relative(relative_url)
    @uri = @uri.merge(relative_url)
    self
  end

  def parse(url)
    @uri = URI.parse(url)
    self
  end

  def validate
    raise URI::InvalidURIError unless @uri.scheme && @uri.host

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
