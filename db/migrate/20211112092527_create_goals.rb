class CreateGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :goals do |t|

      t.string :description,        default: ""
      t.float :amount,              default: 0.0
      t.datetime :goal_target_date
      t.references :user, index: true, foreign_key: true
      t.timestamps
    end
  end
end
