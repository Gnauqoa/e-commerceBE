# TODO: fix children
module Referable
  extend ActiveSupport::Concern

  MAX_DEPTH = 3

  def direct_referees
    referral.children.joins(:user)
  end

  def nested_referees
    derived_referees_data(formalized_nested_referees)
  end

  def formalized_nested_referees(depth = MAX_DEPTH, current_level = 1)
    return [] if direct_referees.blank?
    direct_referees.map do |referral|
      result = {
        user_id: referral.user.id,
        username: referral.user.username,
        wallet_address: referral.user.wallet_address,
        email: referral.user.email,
        level: current_level,
        referral_code: referral&.referral_code,
        referral_code_of_referrer: referral.up&.referral_code,
        created_at: referral.user&.created_at&.to_s,
      }
      if depth > 1
        referees = referral.user.formalized_nested_referees(depth - 1, current_level + 1)
        result.merge!(derived_referees_data(referees))
      end
      result
    end
  end

  private

  def derived_referees_data(referees)
    total_referees = referees.count + referees.inject(0) { |count, r| count + r[:total_referees].to_i }
    referee_addresses = referees.map { |r| [r[:wallet_address]] + r[:referee_addresses].to_a }.flatten.compact
    {
      total_referees: total_referees,
      referee_addresses: referee_addresses,
      referees: referees
    }
  end
end
