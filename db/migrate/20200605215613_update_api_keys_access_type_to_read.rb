class UpdateApiKeysAccessTypeToRead < ActiveRecord::Migration[5.2]
  def change
    ActiveRecord::Base.record_timestamps = false
    ApiKey.all.each { |api_key| api_key.update(access_type: :read) }
    ActiveRecord::Base.record_timestamps = true
  end
end
