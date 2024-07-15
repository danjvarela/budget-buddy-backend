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
          TransactionType: {
            type: :string,
            enum: [:income, :expense, :transfer]
          },
          CategoryType: {
            type: :string,
            enum: [:income, :expense]
          },
          ResourceCreationError: {
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
          ResourceNotFoundError: {
            type: :object,
            properties: {
              error: {type: :string}
            }
          },
          CreateFinancialAccountParams: {
            type: :object,
            properties: {
              name: {type: :string},
              initialAmount: {type: :number, format: :double},
              description: {type: :string, nullable: true}
            },
            required: ["name", "initialAmount"]
          },
          UpdateFinancialAccountParams: {
            type: :object,
            properties: {
              name: {type: :string},
              initialAmount: {type: :number, format: :double},
              description: {type: :string}
            }
          },
          FinancialAccount: {
            type: :object,
            properties: {
              name: {type: :string},
              initialAmount: {type: :number, format: :double},
              currentBalance: {type: :number, format: :double},
              description: {type: :string, nullable: true},
              id: {type: :integer}
            }
          },
          CreateCategoryParams: {
            type: :object,
            properties: {
              categoryType: {"$ref": "#/components/schemas/CategoryType"},
              name: {type: :string}
            },
            required: ["name", "categoryType"]
          },
          UpdateCategoryParams: {
            type: :object,
            properties: {
              categoryType: {"$ref": "#/components/schemas/CategoryType"},
              name: {type: :string}
            }
          },
          Category: {
            type: :object,
            properties: {
              categoryType: {"$ref": "#/components/schemas/CategoryType"},
              name: {type: :string},
              id: {type: :integer}
            }
          },
          ExpenseTransaction: {
            type: :object,
            properties: {
              date: {type: :string},
              amount: {type: :number, format: :double},
              description: {type: :string, nullable: true},
              transactionType: {type: :string},
              financialAccount: {"$ref": "#/components/schemas/FinancialAccount"},
              category: {"$ref": "#/components/schemas/Category"},
              id: {type: :integer}
            }
          },
          IncomeTransaction: {
            type: :object,
            properties: {
              date: {type: :string},
              amount: {type: :number, format: :double},
              description: {type: :string, nullable: true},
              transactionType: {type: :string},
              financialAccount: {"$ref": "#/components/schemas/FinancialAccount"},
              category: {"$ref": "#/components/schemas/Category"},
              id: {type: :integer}
            }
          },
          TransferTransaction: {
            type: :object,
            properties: {
              date: {type: :string},
              amount: {type: :number, format: :double},
              description: {type: :string, nullable: true},
              transactionType: {type: :string},
              fromFinancialAccount: {"$ref": "#/components/schemas/FinancialAccount"},
              toFinancialAccount: {"$ref": "#/components/schemas/FinancialAccount"},
              id: {type: :integer}
            }
          },
          Transaction: {
            oneOf: [
              {"$ref": "#/components/schemas/ExpenseTransaction"},
              {"$ref": "#/components/schemas/IncomeTransaction"},
              {"$ref": "#/components/schemas/TransferTransaction"}
            ],
            discriminator: {
              propertyName: :transactionType,
              mapping: {
                expense: "#/components/schemas/ExpenseTransaction",
                income: "#/components/schemas/IncomeTransaction",
                transfer: "#/components/schemas/TransferTransaction"
              }
            }
          },
          CreateExpenseParams: {
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
          UpdateExpenseParams: {
            type: :object,
            properties: {
              date: {type: :string},
              amount: {type: :number, format: :double},
              description: {type: :string, nullable: true},
              financialAccountId: {type: :integer},
              categoryId: {type: :integer}
            }
          },
          CreateIncomeParams: {
            allOf: [{"$ref": "#/components/schemas/CreateExpenseParams"}]
          },
          UpdateIncomeParams: {
            allOf: [{"$ref": "#/components/schemas/UpdateExpenseParams"}]
          },
          CreateTransferParams: {
            type: :object,
            properties: {
              date: {type: :string},
              amount: {type: :number, format: :double},
              description: {type: :string, nullable: true},
              fromFinancialAccountId: {type: :integer},
              toFinancialAccountId: {type: :integer}
            },
            required: ["fromFinancialAccountId", "toFinancialAccountId", "categoryId", "amount", "date"]
          },
          UpdateTransferParams: {
            type: :object,
            properties: {
              date: {type: :string},
              amount: {type: :number, format: :double},
              description: {type: :string, nullable: true},
              fromFinancialAccountId: {type: :integer},
              toFinancialAccountId: {type: :integer}
            }
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
