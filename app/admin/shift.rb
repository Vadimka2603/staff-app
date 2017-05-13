ActiveAdmin.register Shift do

  filter :date

  actions :all

  config.sort_order = 'date_desc'

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
    column 'Кол-во официантов' do |shift|
      shift.female_count+shift.male_count
    end
    # actions dropdown: true, defaults: false do |shift|
    #   shift.waiters.order(:name).each do |s|
    #     item "#{s.name}", '#'
    #   end
    # end
    # column 'Официанты' do |shift|
    #   shift.waiters.map{|w| w.name}.join('/n ')
    # end
    column 'Официанты' do |shift|
      div class: "name" do 
        table_for shift.payments do
          column '' do |payment|
            if payment.waiter.try(:gender) == 'Мужской' && !payment.is_coordinator? && !payment.is_reserve?
              div :class => 'male' do
                if payment.paid?
                  div :class => 'green' do 
                    text = "#{shift.payments.index(payment)+1}. #{payment.waiter.try(:name)}"
                    text = "Kоорд. #{payment.waiter.try(:name)}" if payment.is_coordinator
                    text = "Pезерв #{payment.waiter.try(:name)}" if payment.is_reserve
                    text = "Pезерв #{payment.waiter.try(:name)} в смене" if payment.is_reserve && payment.active
                    text
                  end
                else
                 text = "#{shift.payments.index(payment)+1}. #{payment.waiter.try(:name)}"
                    text = "Kоорд. #{payment.waiter.try(:name)}" if payment.is_coordinator
                    text = "Pезерв #{payment.waiter.try(:name)}" if payment.is_reserve
                    text = "Pезерв #{payment.waiter.try(:name)} в смене" if payment.is_reserve && payment.active
                    text
                end
              end
            else
              if payment.paid?
                div :class => 'green' do 
                 text = "#{shift.payments.index(payment)+1}. #{payment.waiter.try(:name)}"
                    text = "Kоорд. #{payment.waiter.try(:name)}" if payment.is_coordinator
                    text = "Pезерв #{payment.waiter.try(:name)}" if payment.is_reserve
                    text = "Pезерв #{payment.waiter.try(:name)} в смене" if payment.is_reserve && payment.active
                    text
                end
              else
                text = "#{shift.payments.index(payment)+1}. #{payment.waiter.try(:name)}"
                    text = "Kоорд. #{payment.waiter.try(:name)}" if payment.is_coordinator
                    text = "Pезерв #{payment.waiter.try(:name)}" if payment.is_reserve
                    text = "Pезерв #{payment.waiter.try(:name)} в смене" if payment.is_reserve && payment.active
                    text
              end
            end
          end
          column '' do |payment|
            
            shift_datetime = (shift.date.to_s + " " + shift.finish_time.strftime('%H:%M')).to_datetime
            if payment.is_reserve && !payment.active
              link_to('Добавить в смену', activate_admin_shift_path(payment.shift, payment_id: payment.id))
            elsif shift_datetime < Time.now && !payment.paid? && payment.waiter.present?
              link_to('Расчитать',  paid_admin_waiter_path(payment.waiter, finish_date: payment.shift.date))
            end
          end
        end
      end
    end
    actions dropdown: true, defaults: false do |shift|
      item "Просмотреть", admin_shift_path(shift)
      item "Изменить", edit_admin_shift_path(shift)
      item "Добавить координатора", coordinator_form_admin_shift_path(shift)
      item "Добавить резервного официанта", reserve_form_admin_shift_path(shift)
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
    link_to 'Отчет за день', action: 'check_day_stats'
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

  member_action :reserve_form do
    shift = Shift.find(params[:id])
    @waiters = Waiter.all.to_a - shift.waiters.to_a
    @waiters = @waiters.map{|waiter| ["#{waiter.name}", waiter.id]}
    render "admin/shifts/_form_reserve"
  end

  member_action :reserve, method: :post do
    shift = Shift.find(params[:id])
    waiter = Waiter.find(params[:dump][:waiter])
    Payment.create(shift_id: shift.id, waiter_id: waiter.id, is_reserve: true)
    redirect_to admin_shift_path(shift)
  end

  member_action :coordinator_form do
    shift = Shift.find(params[:id])
    @waiters = Waiter.all.to_a - shift.waiters.to_a
    @waiters = @waiters.map{|waiter| ["#{waiter.name}", waiter.id]}
    render "admin/shifts/_form_coordinator"
  end

  member_action :activate do
    payment = Payment.find(payment_id)
    payment.update(actice: true)
    redirect_to admin_shifts_path
  end

  member_action :coordinator, method: :post do
    shift = Shift.find(params[:id])
    waiter = Waiter.find(params[:dump][:waiter])
    Payment.create(shift_id: shift.id, waiter_id: waiter.id, is_coordinator: true)
    redirect_to admin_shift_path(shift)
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
