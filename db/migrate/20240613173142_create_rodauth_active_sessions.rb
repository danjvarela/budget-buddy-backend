class CreateRodauthActiveSessions < ActiveRecord::Migration[7.1]
  def change
    # Used by the active sessions feature
    create_table :user_active_session_keys, primary_key: [:user_id, :session_id] do |t|
      t.references :user, foreign_key: true
      t.string :session_id
      t.datetime :created_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :last_use, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
