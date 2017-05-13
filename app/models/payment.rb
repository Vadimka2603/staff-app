class Payment < ApplicationRecord
  belongs_to :waiter
  belongs_to :shift
  validates :waiter_id, :uniqueness => { :scope => :shift_id, message: "Дубликат" }
  delegate :gender, to: :waiter, prefix: false, allow_nil: true

  after_commit :set_costs, on: [:create, :update]

  scope :normal, -> { where(is_coordinator: false, is_reserve: false, is_main: false) }
  scope :with_waiters, -> { where.not(waiter_id: nil) }

  
  def set_costs 
  	if is_main || is_coordinator
  		additional_costs
  	else
  		classic_costs
  	end
  end

  def additional_costs
	if is_main?
		update_column(:self_rate, 140*shift.hours_count)
  		update_column(:client_rate, 200*shift.hours_count)
  		update_column(:cost, 200)
  	elsif is_coordinator?
		update_column(:self_rate, 150*shift.hours_count)
  		update_column(:client_rate, 0*shift.hours_count)
  		update_column(:cost, 0)
  	end
  end

    def classic_costs
	  case waiter.try(:rank) || 'Отсутствует'
	  when 'Стажер'
	  	update_column(:self_rate, 100*shift.hours_count)
	  	update_column(:client_rate, 160*shift.hours_count)
	  	update_column(:cost, 160)
	  when 'Официант шведской линии'
	  	update_column(:self_rate, 110*shift.hours_count)
	  	if shift.rank == 'Банкетная'
	  		update_column(:client_rate, 160*shift.hours_count)
	  		update_column(:cost, 160)
	  	else
	  		update_column(:client_rate, 200*shift.hours_count)
	  		update_column(:cost, 200)
	  	end
	  when 'Официант банкетной области'
	  	update_column(:self_rate, 110*shift.hours_count)
	  	if shift.rank == 'Шведская'
	  		update_column(:client_rate, 160*shift.hours_count)
	  		update_column(:cost, 160)
	  	else
	  		update_column(:client_rate, 200*shift.hours_count)
	  		update_column(:cost, 200)
	  	end

	  when 'Официант второй категории'
	  	update_column(:self_rate, 120*shift.hours_count)
	  	update_column(:client_rate, 200*shift.hours_count)
	  	update_column(:cost, 200)

	  when 'Официант первой категории'
	  	update_column(:self_rate, 130*shift.hours_count)
	  	update_column(:client_rate, 200*shift.hours_count)
	  	update_column(:cost, 200)
	  end

	  if is_reserve?
	  	update_column(:self_rate, ((self_rate/shift.hours_count+20)*shift.hours_count))
	  end
	end
end
