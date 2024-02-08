class RemoveUserAgreementAcceptedFromUsers < ActiveRecord::Migration[7.1]
  def change
      remove_column :users, :user_agreement_accepted, :boolean, default: false
  end
end
