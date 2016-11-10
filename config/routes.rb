Rails.application.routes.draw do
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    # All API controllers live under '/api' route & folder and the API module.
    namespace '/api', module: 'api', defaults: {format: 'json'} do
        scope '/v1', module: 'v1' do
            # documents route
            scope '/documents' do
                scope '/:id' do
                    get '/' => 'documents_api#show'
                end
            end
        end
    end
end
