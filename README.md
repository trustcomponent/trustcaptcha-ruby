![RubyGems](https://img.shields.io/gem/v/trustcaptcha)

# TrustCaptcha for Ruby — GDPR-compliant, privacy-first CAPTCHA

Protect websites and apps against bots and spam with a privacy-first, EU-hosted CAPTCHA solution.


## What is TrustCaptcha?

TrustCaptcha combines proof-of-work, an AI bot-score and custom security rules to stop automated bot abuse — without image marking or puzzles

Key perks:
- **Privacy-friendly & GDPR-compliant** – data processed exclusively in Europe
- **No visual challenges** – users never label images or solve quizzes
- **Fully themable widget** – matches any brand and design and improves your user flow
- **Conversion-safe** – near-zero user drop-off compared to legacy CAPTCHAs

Read the full [TrustCaptcha product overview](https://www.trustcomponent.com/en/products/captcha) for technical details and the security concept.


## Get started

1. **Create an account:** [sign up / sign in](https://id.trustcomponent.com/en/signup).
2. **Choose a CAPTCHA:** pick an existing one or create a new one.
3. **Embed the widget:** implement the TrustCaptcha widget into your website or app.
4. **Validate result:** validate the CAPTCHA verification result in your backend.

Need a walkthrough? See the [Ruby integration guide](https://www.trustcomponent.com/en/products/captcha/integrations/ruby-captcha).


## Basic Ruby integration

1. Install the dependency
```bash
gem install trustcaptcha-ruby
```

2. Retrieve the verification result
```ruby
# Retrieving the verification result
begin 
  verification_result = CaptchaManager.get_verification_result('<your_secret_key>', '<verification_token_from_your_client>')
rescue StandardError => e
  # Fetch verification result failed - handle error
  puts "Failed to fetch verification result: #{e.class} - #{e.message}"
  status 500
  return { error: 'Captcha verification failed', message: e.message }.to_json
end
```

3. Act on the result
```ruby
# Act on the verification result
if !verification_result.verification_passed || verification_result.score > 0.5
  puts 'Verification failed or bot score > 0.5 – possible automated request.'
end
```

Congratulations — you have successfully validated the result of the CAPTCHA!

**For detailed implementation instructions, [read the Ruby integration guide](https://www.trustcomponent.com/en/products/captcha/integrations/ruby-captcha).**


## Other pre-built integrations

TrustCaptcha ships ready-made integrations for popular stacks:
- Platforms like WordPress, Joomla, CraftCMS or Keycloak
- Frontends like JavaScript, Angular, React or Vue.js
- Backends like Node.js, PHP, Python, Java, Ruby, Rust, Go or DotNet
- Mobile Applications like iOS, Android, React Native or Flutter

[Discover all our pre-built Integrations](https://www.trustcomponent.com/en/products/captcha/integrations) on our website.


## Get support

Questions? We will be happy to help!
- Email: [mail@trustcomponent.com](mailto:mail@trustcomponent.com)
- Contact form: [reach the support team](https://www.trustcomponent.com/en/contact-us)
