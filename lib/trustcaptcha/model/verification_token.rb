require 'json'
require 'base64'

class VerificationToken
  attr_reader :verification_id, :client_failover

  def initialize(verification_id, client_failover = false)
    @verification_id = verification_id
    @client_failover = client_failover
  end

  def self.from_base64(base64_string)
    json_string = Base64.decode64(base64_string)
    data = JSON.parse(json_string)
    raise StandardError, 'Missing verificationId' if data['verificationId'].nil?
    new(data['verificationId'], data['clientFailover'] == true)
  rescue StandardError => e
    raise e
  end
end
