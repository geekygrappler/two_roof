class Api::V1::DocumentsApiController < ApplicationController
    before_action :find_document, only: [:show, :update]

    def show
        render json: @document, include: 'line_items', status: :ok
    end

    def create
        @document = Document.new(document_params)

        if @document.save
            render json: @document, status: :created
        else
            render json: {
                title: "Unable to persist record",
                details: @document.errors.messages
            },
            status: :unprocessable_entity
        end
    end

    def update
        @document.assign_attributes(document_params)

        if @document.save
            render json: @document, status: :ok
        else
            render json: {
                title: "Unable to persist record",
                details: @document.errors.messages
            },
            status: :unprocessable_entity
        end
    end

    private

    def document_params
        params.require(:document).permit(:title)
    end

    def find_document
        @document = Document.find(params[:id])
    end
end
