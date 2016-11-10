require 'rails_helper'

RSpec.describe "LineItems", type: :request do
    describe "PATCH line item" do
        describe "updates a line item" do
            it "returns the updated resource and correct status code" do
                line_item = create(:line_item)
                new_attrs = { item_name: "new name", quantity: 10}
                patch "/api/v1/line_items/#{line_item.id}", params: {
                    line_item: new_attrs
                }

                expect(response).to have_http_status(:ok)

                json = JSON.parse(response.body)
                expect(json).to match(updated_line_item_json_api_response(document, new_attrs))
            end
        end
    end
end
