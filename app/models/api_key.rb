# == Schema Information
#
# Table name: api_keys
#
#  access_token :string
#  created_at   :datetime         not null
#  enabled      :boolean          default(TRUE)
#  id           :integer          not null, primary key
#  updated_at   :datetime         not null
#  user_id      :integer
#
# Indexes
#
#  index_api_keys_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class ApiKey < ApplicationRecord
  belongs_to :user

  before_create :generate_access_token

  private

    def generate_access_token
      begin
        self.access_token = SecureRandom.hex
      end while self.class.exists?(access_token: access_token)
    end
end
