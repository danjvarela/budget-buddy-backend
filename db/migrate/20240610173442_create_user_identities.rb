class CreateUserIdentities < ActiveRecord::Migration[7.1]
  def change
    create_table :user_identities do |t|
      t.references :user, foreign_key: {on_delete: :cascade}
      t.string :provider, null: false
      t.string :uid, null: false
      t.index [:provider, :uid], unique: true
    end
  end
end
