require 'rails_helper'

RSpec.describe LineItem, type: :model do
    it "is not valid without an item_name" do
        line_item = build(:line_item, item_name: nil)
        expect(line_item).to_not be_valid
    end

    it "is not valid without a document" do
        line_item = build(:line_item, document: nil)
        expect(line_item).to_not be_valid
    end
end
