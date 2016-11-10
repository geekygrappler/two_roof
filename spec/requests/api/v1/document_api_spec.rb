require "rails_helper"

# Test a request to the API for documents

RSpec.describe "Document API", type: :request do
    describe "responds with" do
        it "only json" do
            document = create(:document)
            get "/api/v1/documents/#{document.id}", as: :html

            expect(response.content_type).to eq "application/json"

            document_attrs = { title: nil }
            post "/api/v1/documents", params: {
                document: document_attrs
            }, as: :xml

            expect(response.content_type).to eq "application/json"
        end
    end

    describe "GET single document" do
        it "returns a single document successfully" do
            document = create(:document)
            line_items = create_list(:line_item, 5, document:document)
            get "/api/v1/documents/#{document.id}"

            expect(response).to have_http_status(:ok)

            expect(json).to match(get_single_resource_response(document, [line_items]))
        end
    end

    describe "POST document" do
        describe "creates a new document" do
            it "returns a the newly created document and correct status code" do
                document_attrs = { title: "A new document" }
                post "/api/v1/documents", params: {
                    document: document_attrs
                }

                expect(response).to have_http_status(:created)

                expect(json["data"]["attributes"]).to match(create_document_json_api_response(document_attrs))
            end
        end

        describe "client submits invalid request" do
            it "responds with errors & correct status code" do
                document_attrs = { title: nil }
                post "/api/v1/documents", params: {
                    document: document_attrs
                }

                expect(response).to have_http_status(:unprocessable_entity)

                expect(json).to match(document_error_json_api_response)
            end
        end
    end

    describe "PATCH document" do
        describe "updates a document" do
            it "returns the updated resource and correct status code" do
                document = create(:document)
                new_attrs = { title: "A new title" }
                patch "/api/v1/documents/#{document.id}", params: {
                    document: new_attrs
                }

                expect(response).to have_http_status(:ok)

                expect(json).to match(updated_document_json_api_response(document, new_attrs))
            end
        end

        describe "client submits invalid request" do
            it "responds with errors & correct status code" do
                document = create(:document)
                new_attrs = { title: nil }
                patch "/api/v1/documents/#{document.id}", params: {
                    document: new_attrs
                }

                expect(response).to have_http_status(:unprocessable_entity)


                expect(json).to match(document_error_json_api_response)
            end
        end
    end

    private

    def create_document_json_api_response(document_attrs)
        JSON.parse({
            "title": document_attrs[:title]
        }.to_json)
    end

    def document_error_json_api_response
        JSON.parse({
            "title": "Unable to persist record",
            "details": {
                "title": ["can't be blank"]
            }
        }.to_json)
    end

    def updated_document_json_api_response(document, new_attrs)
        JSON.parse({
            "data": {
                "id": "#{document.id}",
                "type": "documents",
                "attributes": {
                    "title": new_attrs[:title]
                },
                "relationships": {
                    "line-items": {
                        "data": []
                    }
                }
            },
        }.to_json)
    end
end
