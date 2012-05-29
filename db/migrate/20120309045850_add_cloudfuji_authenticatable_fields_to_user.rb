class AddCloudfujiAuthenticatableFieldsToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      begin
        t.cloudfuji_authenticatable
      rescue
        puts "Already added Cloudfuji columns to user!"
      end
    end
  end
end
