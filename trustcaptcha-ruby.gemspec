Gem::Specification.new do |spec|
  spec.name          = "trustcaptcha-ruby"
  spec.version       = "0.1.0" # will be set in the pieline
  spec.authors       = ["TrustComponent"]
  spec.email         = ["mail@trustcomponent.com"]

  spec.summary       = %q{TrustCaptcha - CAPTCHA for Ruby}
  spec.description   = %q{TrustCaptcha – Privacy-first CAPTCHA solution for Ruby. GDPR-compliant, bot protection made in Europe.}
  spec.homepage      = "https://www.trustcomponent.com/en/products/captcha/integrations/ruby-captcha"
  spec.license       = "Apache-2.0"

  spec.files         = Dir["lib/**/*"]

  spec.add_dependency "json"
  spec.add_dependency "net-http"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
end
