class Partner < ApplicationRecord
  has_attached_file :picture, styles: { medium: "300x300>", thumb: "100x100>" }#, default_url: "profile_picture_default.png"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/
  validates_with AttachmentSizeValidator, attributes: :picture, less_than: 1.megabytes
end
