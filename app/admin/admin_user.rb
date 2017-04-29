ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, :name, :phone

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :phone
    actions dropdown: true
  end

  show do |waiter|
    attributes_table_for waiter do
      row :email
      row :name
      row :phone
    end
  end

  filter :email

  controller do
    def permitted_params
      params.permit!
    end
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :name
      f.input :phone
    end
    f.actions
  end

end
