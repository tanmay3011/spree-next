module Spree
  module UserApiAuthentication
    def generate_spree_api_key!
      self.spree_api_key = generate_spree_api_key
      save!
    end

    def clear_spree_api_key!
      self.spree_api_key = nil
      save!
    end

    private

    def generate_spree_api_key
      loop do
        random_token = SecureRandom.urlsafe_base64
        break random_token unless self.class.exists?(spree_api_key: random_token)
      end
    end
  end
end
