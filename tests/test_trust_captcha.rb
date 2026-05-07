require 'minitest/autorun'
require_relative '../lib/trustcaptcha/trust_captcha'

class TrustCaptchaTest < Minitest::Test

  VALID_TOKEN = 'eyJ2ZXJpZmljYXRpb25JZCI6IjAwMDAwMDAwLTAwMDAtMDAwMC0wMDAwLTAwMDAwMDAwMDAwMCJ9'
  NOT_FOUND_TOKEN = 'eyJ2ZXJpZmljYXRpb25JZCI6IjAwMDAwMDAwLTAwMDAtMDAwMC0wMDAwLTAwMDAwMDAwMDAwMSJ9'
  LOCKED_TOKEN = 'eyJ2ZXJpZmljYXRpb25JZCI6IjAwMDAwMDAwLTAwMDAtMDAwMC0wMDAwLTAwMDAwMDAwMDAwMiJ9'
  EXPIRED_TOKEN = 'eyJ2ZXJpZmljYXRpb25JZCI6IjAwMDAwMDAwLTAwMDAtMDAwMC0wMDAwLTAwMDAwMDAwMDAwMyJ9'
  LIMIT_REACHED_TOKEN = 'eyJ2ZXJpZmljYXRpb25JZCI6IjAwMDAwMDAwLTAwMDAtMDAwMC0wMDAwLTAwMDAwMDAwMDAwNCJ9'
  TOKEN_WITH_UNKNOWN_FIELDS = 'eyJ2ZXJpZmljYXRpb25JZCI6IjAwMDAwMDAwLTAwMDAtMDAwMC0wMDAwLTAwMDAwMDAwMDAwMCIsInVua25vd25GaWVsZCI6ImZvbyIsImFub3RoZXJKdW5rIjo0MiwibmVzdGVkIjp7IngiOjF9fQ=='

  VALID_API_KEY = 'ak_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'.freeze

  def setup
    @tc = TrustCaptcha.new(VALID_API_KEY)
  end

  def test_successful_verification
    result = @tc.get_verification_result(VALID_TOKEN)
    assert_instance_of VerificationResult, result
    assert_equal '00000000-0000-0000-0000-000000000000', result.verification_id
  end

  def test_verification_token_invalid
    assert_raises(TrustCaptcha::VerificationTokenInvalidException) do
      @tc.get_verification_result('invalid-base64')
    end
  end

  def test_verification_token_invalid_when_base64_but_not_json
    # base64("not-a-json")
    assert_raises(TrustCaptcha::VerificationTokenInvalidException) do
      @tc.get_verification_result('bm90LWEtanNvbg==')
    end
  end

  def test_verification_token_invalid_when_json_missing_verification_id
    # base64('{"foo":"bar"}')
    assert_raises(TrustCaptcha::VerificationTokenInvalidException) do
      @tc.get_verification_result('eyJmb28iOiJiYXIifQ==')
    end
  end

  def test_verification_not_found
    assert_raises(TrustCaptcha::VerificationNotFoundException) do
      @tc.get_verification_result(NOT_FOUND_TOKEN)
    end
  end

  def test_api_key_invalid
    tc = TrustCaptcha.new('invalid-key')
    assert_raises(TrustCaptcha::ApiKeyInvalidException) do
      tc.get_verification_result(VALID_TOKEN)
    end
  end

  def test_verification_not_finished
    assert_raises(TrustCaptcha::VerificationNotFinishedException) do
      @tc.get_verification_result(LOCKED_TOKEN)
    end
  end

  def test_verification_result_expired
    assert_raises(TrustCaptcha::VerificationResultExpiredException) do
      @tc.get_verification_result(EXPIRED_TOKEN)
    end
  end

  def test_verification_result_retrieval_limit_reached
    assert_raises(TrustCaptcha::VerificationResultRetrievalLimitReachedException) do
      @tc.get_verification_result(LIMIT_REACHED_TOKEN)
    end
  end

  def test_tolerates_unknown_fields_in_verification_token
    result = @tc.get_verification_result(TOKEN_WITH_UNKNOWN_FIELDS)
    assert_instance_of VerificationResult, result
    assert_equal '00000000-0000-0000-0000-000000000000', result.verification_id
  end

  def test_throws_server_unreachable_exception
    tc = TrustCaptcha.new(VALID_API_KEY, api_host: 'http://localhost:1', connect_timeout_s: 0.5, read_timeout_s: 0.5)
    assert_raises(TrustCaptcha::ServerUnreachableException) do
      tc.get_verification_result(VALID_TOKEN)
    end
  end

  def test_user_agent_format
    ua = TrustCaptcha.send(:build_user_agent)
    assert ua.start_with?('Trustcaptcha/')
    decoded = JSON.parse(Base64.strict_decode64(ua.split('/', 2)[1]))
    assert_equal 'ruby', decoded['language']
    assert_equal '3.0.0', decoded['version']
  end
end
