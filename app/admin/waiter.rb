ActiveAdmin.register Waiter do
  filter :manager
  filter :name
  filter :health_book
  filter :rank

  actions :all

  config.sort_order = 'id_asc'

  index do
    selectable_column
    column :name
    column :phone
    column :rank

    actions dropdown: true
  end

  show do |waiter|
    attributes_table_for waiter do
      row :name
      row :rank
      row :phone
      row :second_phone
      row :birthday
      row :passport_number
      row :address
      row :health_book
      row :health_book_estimate
      row 'Менеджеp' do
        waiter.manager.name
      end
      row :gender
      row :estimate_date
    end

  end

  member_action :check_period_stats do
    render "admin/waiters/check_period_stats"
  end
  action_item :check_period_stats, only: :show do
    link_to('Посмотреть статистику', check_period_stats_admin_waiter_path(waiter))
  end

  member_action :upload_payent do
    waiter = Waiter.find(params[:id])
    payments = Payment.where(waiter_id: waiter.id)
    payments.each do |p|
      if p.shift.date <= params[:date].to_date
        p.update(paid: true)
      end
    end
    waiter.update(estimate_date: params[:date])
    redirect_to admin_shifts_path
  end

  batch_action 'Расчитать сегодня' do |ids|
    Waiter.find(ids).each do |waiter|
      waiter.update(estimate_date: Date.today)
    end
    redirect_to collection_path
  end

  member_action :period_stats, method: :post do
  	@waiter = Waiter.find(params[:id])
  	@start_date = params[:dump][:start_date]
    @finish_date = params[:dump][:finish_date]
  	@shifts = @waiter.shifts.where("date >= ?", @start_date).where("date <= ?", @finish_date)
    @hours_count = @shifts.pluck(:length).sum
    @main = 0
    @shifts.each do |s| 
      @main += s.payments.where(waiter_id: @waiter.id, is_main: true).count
    end
    @coordinator = 0
    @shifts.each do |s|
      @coordinator += s.payments.where(waiter_id: @waiter.id, is_coordinator: true).count
    end
    @reserve = 0
    @shifts.each do |s|
      @reserve += s.payments.where(waiter_id: @waiter.id, is_reserve: true).count
    end
    @waste = 0
    @shifts.each do |s| 
      @waste += s.payments.pluck(:self_rate).sum
    end
    @payments = []
    @shifts.order(:date).each do |s|
      s.payments.where(waiter_id: @waiter.id).each do |p|
        @payments << p
      end
    end

    render "admin/waiters/period_stats"
  end

  member_action :paid, method: :get do
    @waiter = Waiter.find(params[:id])

    @start_date = @waiter.estimate_date
    @finish_date = params[:finish_date]
    


    @shifts = @waiter.shifts.where("date >= ?", @start_date).where("date <= ?", @finish_date)
    @hours_count = @shifts.pluck(:length).sum
    @main = 0
    @shifts.each do |s| 
      @main += s.payments.where(waiter_id: @waiter.id, is_main: true).count
    end
    @coordinator = 0
    @shifts.each do |s|
      @coordinator += s.payments.where(waiter_id: @waiter.id, is_coordinator: true).count
    end
    @reserve = 0
    @shifts.each do |s|
      @reserve += s.payments.where(waiter_id: @waiter.id, is_reserve: true).count
    end
    @waste = 0
    @shifts.each do |s| 
      @waste += s.payments.pluck(:self_rate).sum
    end
    @payments = []
    @shifts.order(:date).each do |s|
      s.payments.where(waiter_id: @waiter.id).each do |p|
        @payments << p
      end
    end

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
	    f.input :rank, as: :select, collection: Waiter::RANKS, include_blank: false
	    f.input :phone
      f.input :birthday, as: :datepicker
      f.input :passport_number, label: 'Паспортные данные'
      f.input :address
      f.input :second_phone
      f.input :health_book
      f.input :health_book_estimate, as: :datepicker
      f.input :gender, as: :radio,
              collection: ['Мужской', 'Женский']
	    f.input :estimate_date, as: :datepicker
      f.input :manager, as: :select, collection: AdminUser.where(ability: false).map{|manager| ["#{manager.name}", manager.id]},
                         include_blank: false
	end
	f.actions
  end

end
