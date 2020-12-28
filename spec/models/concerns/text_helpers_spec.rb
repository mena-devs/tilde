require 'rails_helper'

RSpec.describe TextHelpers do
  let(:job) { create(:job, remote: nil) }

  describe "#boolean_to_string" do
    describe "returning No" do
      it "returns No if value is not set" do
        expect(job.boolean_to_string(nil)).to eq "No"
      end

      it "returns No if value is false" do
        expect(job.boolean_to_string(false)).to eq "No"
      end

      it "returns No if value is 0" do
        expect(job.boolean_to_string(0)).to eq "No"
      end

      it "returns No if value is a text of value 0" do
        expect(job.boolean_to_string("0")).to eq "No"
      end
    end

    describe "returning Yes" do
      it "returns Yes if value is set to true" do
        expect(job.boolean_to_string(true)).to eq "Yes"
      end

      it "returns Yes if value is 1" do
        expect(job.boolean_to_string(1)).to eq "Yes"
      end

      it "returns Yes if value is a text of value 1" do
        expect(job.boolean_to_string("1")).to eq "Yes"
      end
    end
  end
end