# frozen_string_literal: true

class OmniAuth::Adapters::Base
  def initialize(auth_raw)
    @auth = auth_raw
  end

  def name
    @auth[:extra][:raw_info][:name]
  end

  def first_name
    name.split(' ').first
  end

  def last_name
    name.split(' ').last
  end

  def uid
    @auth[:uid]
  end

  def provider
    @auth[:provider]
  end

  def nikname
    @auth[:info][:nickname]
  end

  def email
    email_is_verified? ? @auth[:info][:email] : temp_email
  end

  def temporary_email?(email)
    email == temp_email
  end

  private

  def temp_email
    "#{nikname}.#{uid}@#{provider}".downcase
  end
end
