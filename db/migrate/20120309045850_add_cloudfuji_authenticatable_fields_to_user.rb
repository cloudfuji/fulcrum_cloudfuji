class AddCloudfujiAuthenticatableFieldsToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      begin
        t.cloudfuji_authenticatable
      rescue
        puts "Already added Cloudfuji columns to user!"
      end
    end
    begin
      remove_column :users, :reset_password_sent_at
    rescue
      puts "reset_password_sent_at column doesn't exist on :users table."
    end
  end
end
