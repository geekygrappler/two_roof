require 'rails_helper'

RSpec.describe Document, type: :model do
    it "is not valid without a title" do
        document = build(:document, title: nil)
        expect(document).to_not be_valid
    end
end
