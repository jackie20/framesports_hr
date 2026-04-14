class CreateJwtDenylists < ActiveRecord::Migration[7.1]
  def change
    create_table :jwt_denylists do |t|
      t.string  :jti,        limit: 255, null: false
      t.datetime :exp,       precision: 7, null: false
      t.datetime :created_at, precision: 7, null: false
    end

    add_index :jwt_denylists, :jti, unique: true, name: "idx_jwt_denylist_jti"
    add_index :jwt_denylists, :exp,               name: "idx_jwt_denylist_exp"
  end
end
