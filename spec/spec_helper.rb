require 'lib/warnr'

ActiveRecord::Base.establish_connection('adapter' => 'sqlite3', 'database' => ':memory:')

ActiveRecord::Schema.define do
  create_table :users do |table|
    table.column :email, :string
  end

  create_table :clients do |table|
    table.column :manager_id, :integer
    table.column :abn, :string
  end
end

class User < ActiveRecord::Base; end;
class Client < ActiveRecord::Base
  # Notify the client manager that the ABN has not been set
  belongs_to :manager, :foreign_key => "manager_id", :class_name => "User"
  validates_presence_of :abn, :manager
  
  treat_validation_errors_as_warnings_on :abn
  
  on_save_with_warnings :handle_warnings
  
  def handle_warnings
    # Stub, just here for the specs
  end
  
end

