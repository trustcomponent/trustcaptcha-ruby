require 'net/http'
require 'uri'
require 'json'
require_relative 'model/verification_token'
require_relative 'model/verification_result'

class CaptchaManager

  class SecretKeyInvalidException < StandardError; end
  class VerificationTokenInvalidException < StandardError; end
  class VerificationNotFoundException < StandardError; end
  class VerificationNotFinishedException < StandardError; end

  def self.get_verification_result(secret_key, base64_verification_token)
    verification_token = get_verification_token(base64_verification_token)
    fetch_verification_result(verification_token, secret_key)
  end

  private

  def self.get_verification_token(base64_verification_token)
    VerificationToken.from_base64(base64_verification_token)
  rescue StandardError => e
    raise VerificationTokenInvalidException, "Invalid verification token: #{e.message}"
  end

  def self.fetch_verification_result(verification_token, access_token)
    url = URI("#{verification_token.api_endpoint}/verifications/#{verification_token.verification_id}/assessments")
    headers = {
      "tc-authorization" => access_token,
      "tc-library-language" => "ruby",
      "tc-library-version" => "2.0"
    }
    response = Net::HTTP.get_response(url, headers)

    case response.code.to_i
    when 403
      raise SecretKeyInvalidException, "Secret key is invalid"
    when 404
      raise VerificationNotFoundException, "Verification not found"
    when 423
      raise VerificationNotFinishedException, "Verification not finished"
    else
      raise "Failed to retrieve verification result: HTTP #{response.code}" unless response.is_a?(Net::HTTPSuccess)
    end

    VerificationResult.from_json(response.body)
  end
end
