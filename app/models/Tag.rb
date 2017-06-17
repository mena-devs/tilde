# == Schema Information
#
# Table name: tags
#
#  id             :integer          not null, primary key
#  is_approved    :boolean          default(FALSE)
#  name           :string
#  taggings_count :integer          default(0)
#
# Indexes
#
#  index_tags_on_name  (name) UNIQUE
#

# Table name: tags
class Tag < ApplicationRecord
end