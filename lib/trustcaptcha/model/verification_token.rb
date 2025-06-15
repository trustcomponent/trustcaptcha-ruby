require 'json'
require 'securerandom'
require 'base64'

class VerificationToken
  attr_reader :api_endpoint, :verification_id

  def initialize(api_endpoint, verification_id)
    @api_endpoint = api_endpoint
    @verification_id = verification_id
  end

  def self.from_base64(base64_string)
    json_string = Base64.decode64(base64_string)
    data = JSON.parse(json_string)
    new(data['apiEndpoint'], data['verificationId'])
  end
end
