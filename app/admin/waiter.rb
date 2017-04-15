ActiveAdmin.register Waiter do
  config.batch_actions = false
  config.filters = false

  actions :all

  config.sort_order = 'id_asc'

  index do
    column :name
    column :rank
    column :phone
    column :estimate_date
    actions
  end

  show do |waiter|
    attributes_table_for waiter do
      row :name
      row :rank
      row :phone
      row :estimate_date
    end

  end

  member_action :check_period_stats do
    render "admin/waiters/check_period_stats"
  end
  action_item :check_period_stats, only: :show do
    link_to('Посмотреть статистику', check_period_stats_admin_waiter_path(waiter))
  end
  member_action :period_stats, method: :post do
  	@waiter = Waiter.find(params[:id])
  	@start_date = params[:dump][:start_date]
    @finish_date = params[:dump][:finish_date]
  	shifts = Shift.where(waiter_id: @waiter.id).where("date >= ?", @start_date).where("date <= ?", @finish_date)
    @hours_count = shifts.pluck(:length).sum
    @main = shifts.where(is_main: true).count
    @coordinator = shifts.where(is_coordinator: true).count
    @reserve = shifts.where(is_reserve: true).count
    @waste = shifts.pluck(:selfrate).sum
    render "admin/waiters/period_stats"
  end

  controller do
    def permitted_params
      params.permit!
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs do
	    f.input :name
	    f.input :rank, as: :select, collection: Waiter::RANKS
	    f.input :phone
	    f.input :estimate_date, as: :datepicker
	end
	f.actions
  end

end
