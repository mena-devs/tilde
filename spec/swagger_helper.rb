# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      components: {
        schemas: {
          errors_object: {
            type: 'object',
            properties: {
              errors: { '$ref' => '#/components/schemas/errors_map' }
            }
          },
          errors_map: {
            type: 'object',
            additionalProperties: {
              type: 'array',
              items: { type: 'string' }
            }
          },
          jobs: {
            type: 'object',
            properties: {
              data: { type: 'array',
                items: { type: 'object',
                  properties: {
                    id: { type: 'string'},
                    attributes: { type: 'object',
                      properties: {
                                  title: { type: 'string' },
                                  currency: { type: 'string' },
                                  salary: { type: 'string' },
                                  creator_name: { type: 'string' },
                                  description: { type: 'string' },
                                  last_updated: { type: 'string'}
                                },
                              },
                  },
                },
              },
              meta: { type: 'object',
                properties: {
                  total: { type: 'integer' }
                }
              },
              pagination: {
                properties: {
                  current_page: { type: 'integer' },
                  last_page: { type: 'integer', nullable: true },
                  next_page_url: { type: 'string', nullable: true },
                  prev_page_url: { type: 'string', nullable: true },
                }
              }
            },
          },
        },
        securitySchemes: {
          Bearer: {
            description: "Authorization in the header",
            type: :apiKey,
            name: 'Authorization',
            in: :header
          }
        },
      },
      servers: [
        {
          url: 'https://menadevs.com/api/v1/',
          variables: {
            defaultHost: {
              default: 'www.menadevs.com/api/v1/'
            }
          }
        },
        {
          url: 'http://localhost:3000/api/v1/',
          variables: {
            defaultHost: {
              default: 'localhost:3000/api/v1/'
            }
          }
        }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end
