require "rails_helper"

# Simulates a request to the API for documents

RSpec.describe "Document API", type: :request do
    describe "GET single document" do
        it "Returns a single document successfully" do
            document = create(:document)
            get "/api/v1/documents/#{document.id}"

            expect(response).to have_http_status(:success)

            json = JSON.parse(response.body)
            expect(json).to match(get_single_document_json_api_response(document))
        end
    end

    private
    def get_single_document_json_api_response(document)
        JSON.parse({
            data: {
                id: "#{document.id}",
                type: "documents",
                attributes: {
                    title: document.title
                }
            }
        }.to_json)
    end
end
