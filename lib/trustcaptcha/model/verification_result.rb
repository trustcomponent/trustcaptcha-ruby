require 'json'

class VerificationResult
  attr_reader :captcha_id, :verification_id, :verification_passed, :score,
              :decision_type, :decision_action, :gateway_failover_active,
              :risk_scoring_enabled, :minimal_data_mode_enabled,
              :origin, :ip_address, :country_code,
              :device_family, :operating_system, :browser,
              :verification_started_at, :verification_finished_at,
              :result_expires_at, :result_first_fetched_at, :result_last_fetched_at

  def initialize(data)
    @captcha_id = data['captchaId']
    @verification_id = data['verificationId']
    @verification_passed = data['verificationPassed']
    @score = data['score']
    @decision_type = data['decisionType']
    @decision_action = data['decisionAction']
    @gateway_failover_active = data['gatewayFailoverActive']
    @risk_scoring_enabled = data['riskScoringEnabled']
    @minimal_data_mode_enabled = data['minimalDataModeEnabled']
    @origin = data['origin']
    @ip_address = data['ipAddress']
    @country_code = data['countryCode']
    @device_family = data['deviceFamily']
    @operating_system = data['operatingSystem']
    @browser = data['browser']
    @verification_started_at = data['verificationStartedAt']
    @verification_finished_at = data['verificationFinishedAt']
    @result_expires_at = data['resultExpiresAt']
    @result_first_fetched_at = data['resultFirstFetchedAt']
    @result_last_fetched_at = data['resultLastFetchedAt']
  end

  def self.from_json(json_data)
    data = JSON.parse(json_data)
    new(data)
  end

  def to_json(*_args)
    {
      captchaId: @captcha_id,
      verificationId: @verification_id,
      verificationPassed: @verification_passed,
      score: @score,
      decisionType: @decision_type,
      decisionAction: @decision_action,
      gatewayFailoverActive: @gateway_failover_active,
      riskScoringEnabled: @risk_scoring_enabled,
      minimalDataModeEnabled: @minimal_data_mode_enabled,
      origin: @origin,
      ipAddress: @ip_address,
      countryCode: @country_code,
      deviceFamily: @device_family,
      operatingSystem: @operating_system,
      browser: @browser,
      verificationStartedAt: @verification_started_at,
      verificationFinishedAt: @verification_finished_at,
      resultExpiresAt: @result_expires_at,
      resultFirstFetchedAt: @result_first_fetched_at,
      resultLastFetchedAt: @result_last_fetched_at
    }.to_json
  end
end
