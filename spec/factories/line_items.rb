FactoryGirl.define do
    factory :line_item do
        item_name "MyString"
        notes "MyText"
        quantity 1
        rate 1

        # Relationships
        document
    end
end
