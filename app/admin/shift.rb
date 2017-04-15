ActiveAdmin.register Shift do
config.batch_actions = false
  filter :date

  actions :all

  

  index do
    column :date
    column :start_time do |shift|
      	shift.start_time.strftime('%H:%M')
      end
    column :finish_time do |shift|
      	shift.finish_time.strftime('%H:%M')
      end
    column :waiter
    actions
  end

  show do |shift|
    attributes_table_for shift do
      row :date
      row :start_time do |shift|
      	shift.start_time.strftime('%H:%M')
      end
      row :finish_time do |shift|
      	shift.finish_time.strftime('%H:%M')
      end
      row :length
      row :waiter
      row :is_main
      row :is_coordinator
      row :is_reserve
      row :selfrate
      row :clientrate
    end

  end

  controller do
    def permitted_params
      params.permit!
    end
  end

  action_item only: :index do
  	if current_admin_user.ability == true
    	link_to 'Статистика за период', action: 'check_period_stats'
    else
    end
  end

  collection_action :check_period_stats do
    render "admin/shifts/check_period_stats"
  end

  collection_action :period_stats, method: :post do
    @start_date = params[:dump][:start_date]
    @finish_date = params[:dump][:finish_date]
    @waste = Shift.where("date >= ?", @start_date).where("date <= ?", @finish_date).pluck(:selfrate).sum
    @profit = Shift.where("date >= ?", @start_date).where("date <= ?", @finish_date).pluck(:clientrate).sum
    @difference = @profit - @waste
    render "admin/shifts/period_stats"
  end

  form do |f|
    f.semantic_errors
    f.inputs do
	    f.input :date, as: :datepicker
	    f.input :start_time, as: :time_picker
	    f.input :finish_time, as: :time_picker
	    f.input :waiter, as: :select, collection: Waiter.all.map{|p| ["#{p.name}", p.id]}.sort,
	                     include_blank: false
	    f.input :rank, as: :select, collection: Shift::RANKS,
	                     include_blank: false
	    f.input :is_main
	    f.input :is_coordinator
	    f.input :is_reserve
	end
    f.actions
  end

end
