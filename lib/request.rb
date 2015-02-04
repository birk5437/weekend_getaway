class Request
  class RequestFailed < RuntimeError; end

  attr_accessor :headers, :login, :params, :password, :type, :uri, :use_ssl
  attr_reader :http, :request

  GET    = 'GET'
  POST   = 'POST'
  PUT    = 'PUT'
  DELETE = 'DELETE'
  PATCH  = 'PATCH'

  HTTP_SUCCESS_RANGE = 200..299

  def initialize(uri, options = {})
    @uri          = uri
    @body         = options[:body]
    @params       = options.fetch(:params, {})
    @headers      = options.fetch(:headers, {})
    @type         = options.fetch(:type, GET)
    @use_ssl      = options.fetch(:use_ssl, true)
    @pem_file     = options.fetch(:pem_file, nil)
    @pfx_file     = options.fetch(:pfx_file, nil)
    @pfx_password = options.fetch(:pfx_password, nil)
    @timeout      = options.fetch(:timeout, 10)
    @ssl_version  = options.fetch(:ssl_version, nil)

    setup_request
    setup_http
  end

  def inspect
    "#<#{self.class.name}:#{self.object_id} type:#{@type}, uri:#{@uri}, params:#{@params}, use_ssl:#{@use_ssl}>"
  end

  def basic_auth(login, password)
    @request.basic_auth login, password
  end

  def perform
    response = Timeout::timeout(@timeout) do
      @http.request(@request)
    end

    if HTTP_SUCCESS_RANGE.include?(response.code.to_i)
      Rails.logger.debug response.body if Rails.env.development? || Rails.env.test?
      response
    else
      raise RequestFailed, "#{response.class.name} - #{response.body}"
    end
  end

  def set_headers(headers = {})
    @headers.merge!(headers)
    sync_headers!
  end

  protected #################################################################

  def setup_http
    @http = Net::HTTP.new(@uri.host, @uri.port)
    @http.read_timeout = @timeout

    if @use_ssl
      @http.use_ssl     = true
      @http.ssl_version = @ssl_version if @ssl_version
      if @pem_file.present?
        # http://serverfault.com/questions/9708/what-is-a-pem-file-and-how-does-it-differ-from-other-openssl-generated-key-file
        # http://www.rubyinside.com/nethttp-cheat-sheet-2940.html
        pem = File.read(@pem_file)
        @http.cert = OpenSSL::X509::Certificate.new(pem)
        @http.key = OpenSSL::PKey::RSA.new(pem)
        @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      elsif @pfx_file.present?
        pfx = File.read(@pfx_file)
        pkcs12_bundle = OpenSSL::PKCS12.new(pfx, @pfx_password)
        @http.cert = pkcs12_bundle.certificate
        @http.key = pkcs12_bundle.key
        @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      else
        @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
    end
  end

  def setup_request
    request_class = "Net::HTTP::#{@type.to_s.titleize}".constantize

    if @type == POST || @type == PATCH
      @request = request_class.new(@uri.request_uri, initheader = @headers)
      @request.body = @body
      @request.form_data = @params if @params.present? && @body.blank?
    else
      @uri.query = URI.encode_www_form(@params)
      @request   = request_class.new(@uri.request_uri, initheader = @headers)
    end
  end

  def sync_headers!
    @headers.each do |key, value|
      @request[key] = value
    end
  end

end
