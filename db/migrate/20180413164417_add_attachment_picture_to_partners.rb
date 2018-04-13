class AddAttachmentPictureToPartners < ActiveRecord::Migration
  def self.up
    change_table :partners do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :partners, :picture
  end
end
