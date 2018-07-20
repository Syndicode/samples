# frozen_string_literal: true

class OmniAuth::Adapters::Google < OmniAuth::Adapters::Base
  def nikname
    name.gsub(/[^0-9A-Za-z]/, '')
  end

  def first_name
    @auth[:info][:first_name]
  end

  def last_name
    @auth[:info][:last_name]
  end

  private

  def email_is_verified?
    @auth[:info][:email].present? && @auth[:extra][:raw_info][:email_verified]
  end
end
