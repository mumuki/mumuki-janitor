class MakeLoginMethodsAnArrayOnOrganization < ActiveRecord::Migration[5.0]
  def change
    change_table :organizations do |t|
      t.remove :login_methods
      t.string :login_methods, array: true, default: []
    end
  end
end
