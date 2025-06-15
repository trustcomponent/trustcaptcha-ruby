require 'json'

class VerificationResult
  attr_reader :captcha_id, :verification_id, :score, :reason, :mode, :origin, :ip_address,
              :device_family, :operating_system, :browser, :creation_timestamp,
              :release_timestamp, :retrieval_timestamp, :verification_passed

  def initialize(data)
    @captcha_id = data['captchaId']
    @verification_id = data['verificationId']
    @score = data['score']
    @reason = data['reason']
    @mode = data['mode']
    @origin = data['origin']
    @ip_address = data['ipAddress']
    @device_family = data['deviceFamily']
    @operating_system = data['operatingSystem']
    @browser = data['browser']
    @creation_timestamp = data['creationTimestamp']
    @release_timestamp = data['releaseTimestamp']
    @retrieval_timestamp = data['retrievalTimestamp']
    @verification_passed = data['verificationPassed']
  end

  def self.from_json(json_data)
    data = JSON.parse(json_data)
    new(data)
  end

  def to_json(*_args)
    {
      captchaId: @captcha_id,
      verificationId: @verification_id,
      score: @score,
      reason: @reason,
      mode: @mode,
      origin: @origin,
      ipAddress: @ip_address,
      deviceFamily: @device_family,
      operatingSystem: @operating_system,
      browser: @browser,
      creationTimestamp: @creation_timestamp,
      releaseTimestamp: @release_timestamp,
      retrievalTimestamp: @retrieval_timestamp,
      verificationPassed: @verification_passed
    }.to_json
  end
end
