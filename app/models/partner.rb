# == Schema Information
#
# Table name: partners
#
#  id                   :bigint           not null, primary key
#  name                 :string
#  description          :string
#  external_link        :string
#  email                :string
#  active               :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#

class Partner < ApplicationRecord
  has_attached_file :picture, styles: { medium: "300x300>", thumb: "100x100>" }#, default_url: "profile_picture_default.png"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/
  validates_with AttachmentSizeValidator, attributes: :picture, less_than: 1.megabytes
end
