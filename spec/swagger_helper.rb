# frozen_string_literal: true

require "rails_helper"

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join("swagger").to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    "v1/swagger.yaml" => {
      openapi: "3.0.1",
      info: {
        title: "Budget Buddy API",
        version: "v1"
      },
      paths: {},
      components: {
        securitySchemes: {
          bearer_auth: {
            type: :http,
            scheme: :bearer
          }
        },
        schemas: {
          transaction_type: {
            type: :string,
            enum: [:income, :expense, :transfer]
          },
          category_type: {
            type: :string,
            enum: [:income, :expense, :transfer]
          },
          resource_creation_error: {
            type: :object,
            properties: {
              errors: {
                type: :object,
                additionalProperties: {
                  type: :array,
                  items: {type: :string}
                }
              }
            },
            required: ["errors"]
          },
          resource_not_found_error: {
            type: :object,
            properties: {
              error: {type: :string}
            }
          },
          base_financial_account: {
            type: :object,
            properties: {
              name: {type: :string},
              amount: {type: :number, format: :double},
              description: {type: :string, nullable: true}
            }
          },
          create_financial_account_params: {
            allOf: [{"$ref": "#/components/schemas/base_financial_account"}],
            required: ["name", "amount"]
          },
          financial_account: {
            allOf: [{"$ref": "#/components/schemas/base_financial_account"}, {type: :object, properties: {id: {type: :integer}}}]
          },
          base_category: {
            type: :object,
            properties: {
              categoryType: {"$ref": "#/components/schemas/category_type"},
              name: {type: :string}
            }
          },
          create_category_params: {
            allOf: [{"$ref": "#/components/schemas/base_category"}],
            required: ["name", "categoryType"]
          },
          category: {
            allOf: [
              {"$ref": "#/components/schemas/base_category"},
              {type: :object, properties: {id: {type: :integer}}}
            ]
          },
          base_transaction: {
            type: :object,
            properties: {
              date: {type: :string},
              amount: {type: :number, format: :double},
              description: {type: :string, nullable: true}
            }
          },
          expense_transaction: {
            allOf: [
              {"$ref": "#/components/schemas/base_transaction"},
              {type: :object, properties: {
                type: {type: :string, enum: [:expense]},
                financialAccount: {"$ref": "#/components/schemas/financial_account"}
              }}
            ]
          },
          income_transaction: {
            allOf: [
              {"$ref": "#/components/schemas/base_transaction"},
              {type: :object, properties: {
                type: {type: :string, enum: [:income]},
                financialAccount: {"$ref": "#/components/schemas/financial_account"}
              }}
            ]
          },
          transfer_transaction: {
            allOf: [
              {"$ref": "#/components/schemas/base_transaction"},
              {type: :object, properties: {
                type: {type: :string, enum: [:transfer]},
                fromFinancialAccount: {"$ref": "#/components/schemas/financial_account"},
                toFinancialAccount: {"$ref": "#/components/schemas/financial_account"}
              }}
            ]
          },
          transaction: {
            anyOf: [
              {"$ref": "#/components/schemas/expense_transaction"},
              {"$ref": "#/components/schemas/income_transaction"},
              {"$ref": "#/components/schemas/transfer_transaction"}
            ],
            discriminator: :type
          }
        }
      },
      servers: [
        {
          url: "{url}",
          variables: {
            url: {
              default: "https://budget-buddy-backend.fly.dev"
            }
          }
        }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
