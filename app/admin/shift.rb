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
    column :rank
    actions
    column "" do |shift|
      link_to('Дублировать на сегодня',  duplicate_admin_shift_path(shift))
    end
    column "" do |shift|
      link_to('Скачать информацию по сотрудникам',  download_xlsx_admin_shift_path(shift))
    end

  end

  show do |shift|
    attributes_table_for shift do
      row :date
      row :rank
      row :start_time do |shift|
      	shift.start_time.strftime('%H:%M')
      end
      row :finish_time do |shift|
      	shift.finish_time.strftime('%H:%M')
      end
      row :length  
      row :comment
    end

    panel 'Официанты' do
      table_for shift.payments do
        column 'Официант' do |payment|
          payment.waiter.name
        end
        column :is_main
        column :is_coordinator
        column :is_reserve
        column :self_rate if current_admin_user.ability == true
        column :client_rate if current_admin_user.ability == true
      end
    end if shift.payments.any?
  end

  controller do
    def permitted_params
      params.permit!
    end
  end

  action_item only: :index do
    if current_admin_user.ability == true
      link_to 'Статистика за день', action: 'check_day_stats'
    else
    end
  end

  collection_action :check_day_stats do
    render "admin/shifts/check_day_stats"
  end

  action_item only: :index do
  	if current_admin_user.ability == true
    	link_to 'Статистика за период', action: 'check_period_stats'
    else
    end
  end

  collection_action :day_stats, method: :post do
    @shifts = Shift.where(date: params[:dump][:date])
    render xlsx: 'admin/shifts/day_stats.xlsx.axlsx'
  end

  member_action :download_xlsx do
    @shift = Shift.find(params[:id])
    render xlsx: 'admin/shifts/shift.xlsx.axlsx'
  end

  member_action :duplicate do
    shift = Shift.find(params[:id])
    new_shift = shift.dup
    new_shift.update(date: Date.today)
    shift.payments.each do |p|
      new_p = p.dup
      new_p.update(shift_id: new_shift.id)
    end
    redirect_to admin_shift_path(new_shift)
  end

  collection_action :check_period_stats do
    render "admin/shifts/check_period_stats"
  end

  collection_action :period_stats, method: :post do
    @start_date = params[:dump][:start_date]
    @finish_date = params[:dump][:finish_date]
    @waste = 0
    Shift.where("date >= ?", @start_date).where("date <= ?", @finish_date).each do |s|
      @waste += s.payments.pluck(:self_rate).sum
    end
    @profit = 0
    Shift.where("date >= ?", @start_date).where("date <= ?", @finish_date).each do |s|
      @profit += s.payments.pluck(:client_rate).sum
    end
    @difference = @profit - @waste
    render "admin/shifts/period_stats"
  end

  form partial: 'form'

end
