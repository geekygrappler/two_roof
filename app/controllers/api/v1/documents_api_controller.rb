class Api::V1::DocumentsApiController < ApplicationController
    def show
        @document = Document.find(params[:id])
        respond_to do |format|
            format.json do
                render json: @document, include: 'line_items', status: :ok
            end
        end
    end
end
