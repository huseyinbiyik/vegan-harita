class AddUserAgreementAcceptedToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :user_agreement_accepted, :boolean, default: false
  end
end
