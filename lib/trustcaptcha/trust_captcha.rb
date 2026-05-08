require 'net/http'
require 'uri'
require 'json'
require 'base64'
require_relative 'model/verification_token'
require_relative 'model/verification_result'

class TrustCaptcha

  LIBRARY_VERSION = '3.0.0'.freeze
  LIBRARY_LANGUAGE = 'ruby'.freeze
  DEFAULT_API_HOST = 'https://api.trustcomponent.com'.freeze
  DEFAULT_CONNECT_TIMEOUT_S = 3
  DEFAULT_READ_TIMEOUT_S = 5

  class ApiKeyInvalidException < StandardError; end
  class VerificationTokenInvalidException < StandardError; end
  class VerificationNotFoundException < StandardError; end
  class VerificationNotFinishedException < StandardError; end
  class VerificationResultExpiredException < StandardError; end
  class VerificationResultRetrievalLimitReachedException < StandardError; end
  class FailoverException < StandardError; end
  class ServerUnreachableException < FailoverException; end
  class ClientReportedServerUnreachableException < FailoverException; end

  def initialize(api_key,
                 api_host: DEFAULT_API_HOST,
                 connect_timeout_s: DEFAULT_CONNECT_TIMEOUT_S,
                 read_timeout_s: DEFAULT_READ_TIMEOUT_S,
                 proxy: nil)
    raise ArgumentError, 'api_key must not be empty' if api_key.nil? || api_key.empty?
    @api_key = api_key.strip
    @api_host = api_host
    @connect_timeout_s = connect_timeout_s
    @read_timeout_s = read_timeout_s
    @proxy = proxy  # Either a URI string ("http://host:port[/]") or nil.
  end

  def get_verification_result(base64_verification_token)
    verification_token = parse_verification_token(base64_verification_token)
    query = verification_token.client_failover ? '?clientFailover=true' : ''
    url = URI("#{@api_host}/v2/verifications/#{verification_token.verification_id}/results#{query}")
    headers = {
      'Authorization' => "Bearer #{@api_key}",
      'User-Agent' => self.class.build_user_agent,
    }

    http = if @proxy
             p = URI.parse(@proxy)
             Net::HTTP.new(url.host, url.port, p.host, p.port, p.user, p.password)
           else
             Net::HTTP.new(url.host, url.port)
           end
    http.use_ssl = url.scheme == 'https'
    http.open_timeout = @connect_timeout_s
    http.read_timeout = @read_timeout_s

    response = begin
      request = Net::HTTP::Get.new(url.request_uri, headers)
      http.request(request)
    rescue SocketError, Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ENETUNREACH, Net::OpenTimeout, Net::ReadTimeout, Errno::ETIMEDOUT
      raise ServerUnreachableException, 'Could not reach the TrustCaptcha server. Please check your network connection and consider implementing a failover mechanism.'
    end

    case response.code.to_i
    when 403
      raise ApiKeyInvalidException, 'The provided api key is invalid. Please verify the api key from your captcha settings.'
    when 404
      raise VerificationNotFoundException, 'No verification could be found for the given verification token.'
    when 423
      raise VerificationNotFinishedException, 'The verification is not yet completed. Please wait until the user has finished solving the captcha before requesting the result.'
    when 410
      raise VerificationResultExpiredException, 'The verification result has expired and can no longer be retrieved.'
    when 412
      raise ClientReportedServerUnreachableException, 'The client reported it could not reach the TrustCaptcha server, but the gateway has no record of a recent outage.'
    when 429
      raise VerificationResultRetrievalLimitReachedException, 'The verification result has reached its maximum retrieval count and can no longer be retrieved.'
    else
      raise "Failed to retrieve verification result: HTTP #{response.code}" unless response.is_a?(Net::HTTPSuccess)
    end

    VerificationResult.from_json(response.body)
  end

  private

  def parse_verification_token(base64_verification_token)
    VerificationToken.from_base64(base64_verification_token)
  rescue StandardError => e
    raise VerificationTokenInvalidException, "The verification token is malformed or could not be parsed: #{e.message}"
  end

  def self.build_user_agent
    payload = { 'language' => LIBRARY_LANGUAGE, 'version' => LIBRARY_VERSION }
    encoded = Base64.strict_encode64(JSON.generate(payload))
    "Trustcaptcha/#{encoded}"
  end
end
