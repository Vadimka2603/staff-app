class AddCommentToShifts < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :comment, :text
  end
end
