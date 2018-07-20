# frozen_string_literal: true

class OmniAuth::Adapters::Facebook < OmniAuth::Adapters::Base
  def nikname
    name.gsub(/[^0-9A-Za-z]/, '')
  end

  private

  def email_is_verified?
    @auth[:info][:email].present?
  end
end
