module SwaggerSchemas
  PAGINATION_DATA_PROPERTIES = {
    currentPage: {type: :number},
    nextPage: {type: :number, nullable: true},
    prevPage: {type: :number, nullable: true},
    totalPages: {type: :number},
    totalCount: {type: :number},
    perPageCount: {type: :number}
  }

  TRANSACTION_TYPE = {
    type: :string,
    enum: [:income, :expense, :transfer]
  }

  CATEGORY_TYPE = {
    type: :string,
    enum: [:income, :expense]
  }

  RESOURCE_CREATION_ERROR_PROPERTIES = {
    errors: {
      type: :object,
      additionalProperties: {
        type: :array,
        items: {type: :string}
      }
    }
  }

  RESOURCE_NOT_FOUND_ERROR_PROPERTIES = {
    error: {type: :string}
  }

  USER_PROPERTIES = {
    id: {type: :number},
    email: {type: :string},
    status: {type: :string, enum: [:verified, :unverified, :closed]}
  }

  FINANCIAL_ACCOUNT_PROPERTIES = {
    name: {type: :string},
    initialAmount: {type: :number, format: :double},
    description: {type: :string, nullable: true}
  }

  CATEGORY_PROPERTIES = {
    categoryType: SwaggerSchemas::CATEGORY_TYPE,
    name: {type: :string}
  }

  EXPENSE_TRANSACTION_PROPERTIES = {
    date: {type: :string},
    amount: {type: :number, format: :double},
    description: {type: :string, nullable: true},
    transactionType: {type: :string},
    financialAccount: {"$ref": "#/components/schemas/FinancialAccount"},
    category: {"$ref": "#/components/schemas/Category"}
  }

  CREATE_EXPENSE_PROPERTIES = {
    date: {type: :string},
    amount: {type: :number, format: :double},
    description: {type: :string, nullable: true},
    financialAccountId: {type: :integer},
    categoryId: {type: :integer}
  }

  TRANSFER_TRANSACTION_PROPERTIES = {
    date: {type: :string},
    amount: {type: :number, format: :double},
    description: {type: :string, nullable: true},
    transactionType: {type: :string},
    fromFinancialAccount: {"$ref": "#/components/schemas/FinancialAccount"},
    toFinancialAccount: {"$ref": "#/components/schemas/FinancialAccount"}
  }

  CREATE_TRANSFER_PROPERTIES = {
    date: {type: :string},
    amount: {type: :number, format: :double},
    description: {type: :string, nullable: true},
    fromFinancialAccountId: {type: :integer},
    toFinancialAccountId: {type: :integer}
  }
end
