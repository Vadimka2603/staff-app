ActiveAdmin.register Shift do

  filter :date

  actions :all

  

  index do
    selectable_column
    column :date
    column :start_time do |shift|
    	shift.start_time.strftime('%H:%M')
    end
    column :finish_time do |shift|
    	shift.finish_time.strftime('%H:%M')
    end
    column :rank
    column 'Количество официантов' do |shift|
      shift.female_count+shift.male_count
    end
    column 'Заполнена?' do |shift|
      if shift.payments.where.not(waiter_id: nil).count == (shift.female_count+shift.male_count)
        "Да"
      else
        'Нет'
      end
    end
    # actions dropdown: true, defaults: false do |shift|
    #   shift.waiters.order(:name).each do |s|
    #     item "#{s.name}", '#'
    #   end
    # end
    # column 'Официанты' do |shift|
    #   shift.waiters.map{|w| w.name}.join('/n ')
    # end
    column '', class: "name" do |shift|
      div class: "name" do 
        table_for shift.payments.with_waiters, header: false do
          column 'Официанты' do |payment|
            "#{shift.payments.index(payment)+1}. #{payment.waiter.name}"
          end
        end
      end
    end
    actions dropdown: true, defaults: false do |shift|
      item "Просмотреть", admin_shift_path(shift)
      item "Изменить данные по официантам", edit_admin_shift_path(shift)
      item "Изменить основную информацию", fix_main_info_admin_shift_path(shift)
    end
    column "" do |shift|
      link_to('Дублировать на сегодня',  duplicate_admin_shift_path(shift))
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
      row :female_count
      row :male_count  
      row :comment
    end

    panel 'Координаторы' do
      table_for shift.payments.where(is_coordinator: true) do
        column 'Официант' do |payment|
          payment.waiter.name
        end
        column :self_rate if current_admin_user.ability == true
        column :client_rate if current_admin_user.ability == true
      end
    end if shift.payments.where(is_coordinator: true).any?

    panel 'Старшие официанты' do
      table_for shift.payments.where(is_main: true) do
        column 'Официант' do |payment|
          payment.waiter.name
        end
        column :self_rate if current_admin_user.ability == true
        column :client_rate if current_admin_user.ability == true
      end
    end if shift.payments.where(is_main: true).any?

    panel 'Резерв' do
      table_for shift.payments.where(is_reserve: true) do
        column 'Официант' do |payment|
          payment.waiter.name
        end
        column :self_rate if current_admin_user.ability == true
        column :client_rate if current_admin_user.ability == true
      end
    end if shift.payments.where(is_reserve: true).any?

    panel 'Официанты' do
      table_for shift.payments.normal.with_waiters do
        column 'Официант' do |payment|
          payment.waiter.name
        end
        column :self_rate if current_admin_user.ability == true
        column :client_rate if current_admin_user.ability == true
      end
    end if shift.payments.normal.with_waiters.any?
  end

  controller do
    def permitted_params
      params.permit!
    end
  end

  action_item only: :index do
    if current_admin_user.ability == true
      link_to 'Отчет за день', action: 'check_day_stats'
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

  batch_action 'Вывести список сотрудников' do |ids|
    @shifts = Shift.find(ids)
    render xlsx: 'admin/shifts/waiters.xlsx.axlsx'
  end

  member_action :download_xlsx do
    @shift = Shift.find(params[:id])
    render xlsx: 'admin/shifts/shift.xlsx.axlsx'
  end

  member_action :fix_main_info do
    @shift = Shift.find(params[:id])
    render '_form_new', layout: 'active_admin'
  end

  action_item :fix_main_info, only: :show do
    link_to('Изменить основную информацию', fix_main_info_admin_shift_path(shift))
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
    @length = 0
    Shift.where("date >= ?", @start_date).where("date <= ?", @finish_date).each do |s|
      @length += s.payments.count*s.length
    end
    render "admin/shifts/period_stats"
  end

  form partial: 'form'

end
