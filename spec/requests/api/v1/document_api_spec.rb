require "rails_helper"

# Simulates a request to the API for documents

RSpec.describe "Document API", type: :request do
    describe "GET single document" do
        it "Returns a single document successfully" do
            document = create(:document)
            line_items = create_list(:line_item, 5, document:document)
            get "/api/v1/documents/#{document.id}"

            expect(response).to have_http_status(:success)

            json = JSON.parse(response.body)
            expect(json).to match(get_single_document_json_api_response(document, line_items))
        end
    end

    private
    def get_single_document_json_api_response(document, line_items)
        JSON.parse({
            "data": {
                "id": "#{document.id}",
                "type": "documents",
                "attributes": {
                    "title": document.title
                },
                "relationships": {
                    "line-items": {
                        "data": line_items.map { |line_item| { "id": "#{line_item.id}", "type": "line-items" } }
                    }
                }
            },
            "included": line_items.map { |line_item| {
                    "id": "#{line_item.id}",
                    "type": "line-items",
                    "attributes": {
                        "item-name": line_item.item_name,
                        "notes": line_item.notes,
                        "quantity": line_item.quantity,
                        "rate": line_item.rate
                    }
                }
            }
        }.to_json)
    end
end
