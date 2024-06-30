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
      openapi: "3.1.0",
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
          create_financial_account_params: {
            type: :object,
            properties: {
              name: {type: :string},
              initialAmount: {type: :number, format: :double},
              description: {type: :string, nullable: true}
            },
            required: ["name", "initialAmount"]
          },
          update_financial_account_params: {
            type: :object,
            properties: {
              name: {type: :string},
              initialAmount: {type: :number, format: :double},
              description: {type: :string}
            }
          },
          financial_account: {
            type: :object,
            properties: {
              name: {type: :string},
              initialAmount: {type: :number, format: :double},
              description: {type: :string, nullable: true},
              id: {type: :integer}
            }
          },
          base_category: {
            type: :object,
            properties: {
              categoryType: {"$ref": "#/components/schemas/category_type"},
              name: {type: :string}
            }
          },
          create_category_params: {
            type: :object,
            properties: {
              categoryType: {"$ref": "#/components/schemas/category_type"},
              name: {type: :string}
            },
            required: ["name", "categoryType"]
          },
          update_category_params: {
            type: :object,
            properties: {
              categoryType: {"$ref": "#/components/schemas/category_type"},
              name: {type: :string}
            }
          },
          category: {
            type: :object,
            properties: {
              categoryType: {"$ref": "#/components/schemas/category_type"},
              name: {type: :string},
              id: {type: :integer}
            }
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
            type: :object,
            properties: {
              date: {type: :string},
              amount: {type: :number, format: :double},
              description: {type: :string, nullable: true},
              transactionType: {type: :string},
              financialAccount: {"$ref": "#/components/schemas/financial_account"},
              category: {"$ref": "#/components/schemas/category"},
              id: {type: :integer}
            }
          },
          income_transaction: {
            type: :object,
            properties: {
              date: {type: :string},
              amount: {type: :number, format: :double},
              description: {type: :string, nullable: true},
              transactionType: {type: :string},
              financialAccount: {"$ref": "#/components/schemas/financial_account"},
              category: {"$ref": "#/components/schemas/category"},
              id: {type: :integer}
            }
          },
          transfer_transaction: {
            type: :object,
            properties: {
              date: {type: :string},
              amount: {type: :number, format: :double},
              description: {type: :string, nullable: true},
              transactionType: {type: :string},
              fromFinancialAccount: {"$ref": "#/components/schemas/financial_account"},
              toFinancialAccount: {"$ref": "#/components/schemas/financial_account"},
              id: {type: :integer}
            }
          },
          transaction: {
            oneOf: [
              {"$ref": "#/components/schemas/expense_transaction"},
              {"$ref": "#/components/schemas/income_transaction"},
              {"$ref": "#/components/schemas/transfer_transaction"}
            ],
            discriminator: {
              propertyName: :transactionType,
              mapping: {
                expense: "#/components/schemas/expense_transaction",
                income: "#/components/schemas/income_transaction",
                transfer: "#/components/schemas/transfer_transaction"
              }
            }
          },
          create_expense_params: {
            type: :object,
            properties: {
              date: {type: :string},
              amount: {type: :number, format: :double},
              description: {type: :string, nullable: true},
              financialAccountId: {type: :integer},
              categoryId: {type: :integer}
            },
            required: ["financialAccountId", "categoryId", "amount", "date"]
          },
          update_expense_params: {
            type: :object,
            properties: {
              date: {type: :string},
              amount: {type: :number, format: :double},
              description: {type: :string, nullable: true},
              financialAccountId: {type: :integer},
              categoryId: {type: :integer}
            }
          },
          create_income_params: {
            allOf: [{"$ref": "#/components/schemas/create_expense_params"}]
          },
          update_income_params: {
            allOf: [{"$ref": "#/components/schemas/update_expense_params"}]
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

  config.openapi_strict_schema_validation = true
end
