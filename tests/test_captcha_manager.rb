require 'minitest/autorun'
require_relative '../lib/trustcaptcha/captcha_manager'

class CaptchaManagerTest < Minitest::Test

  VALID_TOKEN = 'eyJhcGlFbmRwb2ludCI6Imh0dHBzOi8vYXBpLnRydXN0Y29tcG9uZW50LmNvbSIsInZlcmlmaWNhdGlvbklkIjoiMDAwMDAwMDAtMDAwMC0wMDAwLTAwMDAtMDAwMDAwMDAwMDAwIiwiZW5jcnlwdGVkQWNjZXNzVG9rZW4iOiJ0b2tlbiJ9'
  NOT_FOUND_TOKEN = 'eyJhcGlFbmRwb2ludCI6Imh0dHBzOi8vYXBpLnRydXN0Y29tcG9uZW50LmNvbSIsInZlcmlmaWNhdGlvbklkIjoiMDAwMDAwMDAtMDAwMC0wMDAwLTAwMDAtMDAwMDAwMDAwMDAxIiwiZW5jcnlwdGVkQWNjZXNzVG9rZW4iOiJ0b2tlbiJ9'
  LOCKED_TOKEN = 'eyJhcGlFbmRwb2ludCI6Imh0dHBzOi8vYXBpLnRydXN0Y29tcG9uZW50LmNvbSIsInZlcmlmaWNhdGlvbklkIjoiMDAwMDAwMDAtMDAwMC0wMDAwLTAwMDAtMDAwMDAwMDAwMDAyIiwiZW5jcnlwdGVkQWNjZXNzVG9rZW4iOiJ0b2tlbiJ9'

  def test_successful_verification
    result = CaptchaManager.get_verification_result('secret-key', VALID_TOKEN)
    assert_instance_of VerificationResult, result
  end

  def test_verification_token_invalid
    assert_raises(CaptchaManager::VerificationTokenInvalidException) do
      CaptchaManager.get_verification_result('secret-key', 'invalid-base64')
    end
  end

  def test_verification_not_found
    assert_raises(CaptchaManager::VerificationNotFoundException) do
      CaptchaManager.get_verification_result('secret-key', NOT_FOUND_TOKEN)
    end
  end

  def test_secret_key_invalid
    assert_raises(CaptchaManager::SecretKeyInvalidException) do
      CaptchaManager.get_verification_result('invalid-key', VALID_TOKEN)
    end
  end

  def test_verification_not_finished
    assert_raises(CaptchaManager::VerificationNotFinishedException) do
      CaptchaManager.get_verification_result('secret-key', LOCKED_TOKEN)
    end
  end
end
