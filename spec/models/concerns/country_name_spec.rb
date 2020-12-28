require 'rails_helper'

RSpec.describe CountryName do
  let(:job) { create(:job, remote: nil) }

  describe "#country_name" do
    it "returns the full country name when abbreviation is passed" do
      expect(job.country_name("NL")).to eq "Netherlands"
    end

    it "returns `Not set` if the country abbreviation does not match" do
      expect(job.country_name("")).to eq "Not set"
    end
  end
end