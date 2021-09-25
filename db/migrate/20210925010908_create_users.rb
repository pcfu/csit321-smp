class CreateUsers < ActiveRecord::Migration[6.1]
  def up
    create_enum :user_role, %w(regular admin banned)

    create_table :users do |t|
      t.string  :first_name,                  null: false
      t.string  :last_name,                   null: false
      t.string  :email,                       null: false
      t.string  :password_digest,             null: false
      t.enum    :role, enum_name: :user_role, null: false

      t.timestamps
    end
  end

  def down
    drop_table :users

    drop_enum :user_role
  end
end
