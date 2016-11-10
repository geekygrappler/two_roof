module Requests
    module JsonHelpers
        def json
            JSON.parse(response.body)
        end
    end

    module JsonApiHelpers
        # Returns a JSON:API response for a resource & related resources
        #
        # @param [ApplicationRecord] main_resource the main resource we are requesting
        # @param [Array<ApplicationRecord>] related_resources list of related resources we also want in the response
        # @return [String] A string representing a JSON object
        def get_single_resource_response(main_resource, related_resources = [])
            relationships = related_resources.map do |related_resource|
                resource_name = resource_name(related_resource.first)
                {
                    "#{resource_name}": {
                        "data": related_resource.map { |resource| {"id": "#{resource.id}", "type": "#{resource_name}"} }
                    }
                }
            end
            relationships = relationships.reduce Hash.new, :merge

            included = []
            related_resources.each do |related_resource|
                resource_name = resource_name(related_resource.first)
                related_resource.each do |resource|
                    included.push({
                            "id": "#{resource.id}",
                            "type": "#{resource_name}",
                            "attributes": resource.attributes.except("id", "updated_at", "created_at", "#{main_resource.class.name.underscore}_id").transform_keys { |key| key.dasherize }
                        }
                    )
                end
            end

            JSON.parse({
                "data": {
                    "id": "#{main_resource.id}",
                    "type": "#{resource_name(main_resource)}",
                    "attributes": main_resource.attributes.except("id", "updated_at", "created_at"),
                    "relationships": JSON.parse(relationships.to_json)
                },
                "included": included
            }.to_json)
        end

        private

        def resource_name(resource)
            resource.class.name.underscore.dasherize.pluralize
        end
    end
end
