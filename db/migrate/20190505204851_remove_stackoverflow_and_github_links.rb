class RemoveStackoverflowAndGithubLinks < ActiveRecord::Migration[5.0]
  def change
    remove_column :profiles, :github_profile_link
    remove_column :profiles, :stackoverflow_profile_link
  end
end
