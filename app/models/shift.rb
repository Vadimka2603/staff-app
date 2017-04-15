class Shift < ApplicationRecord
	belongs_to :waiter

	after_commit :set_correct_times, on: [:create, :update]

	RANKS = ['Шведская', 'Банкетная', 'По меню']

	def set_correct_times
		if self.finish_time < self.start_time
			self.update_column(:finish_time, self.finish_time + 24.hours)
			self.update_column(:length, hours_count)
		else
			self.update_column(:length, hours_count)
		end
		set_costs
	end

	def set_costs
	  waiter = self.waiter
	  case waiter.rank
	  when 'Новичок'
	  	self.update_column(:selfrate, 100*hours_count)
	  	self.update_column(:clientrate, 160*hours_count)
	  	additional_costs
	  when 'Официант шведской линии'
	  	self.update_column(:selfrate, 110*hours_count)
	  	if self.rank == 'Банкетная'
	  		self.update_column(:clientrate, 160*hours_count)
	  	else
	  		self.update_column(:clientrate, 200*hours_count)
	  	end
	  	additional_costs
	  when 'Официант банкетной области'
	  	self.update_column(:selfrate, 110*hours_count)
	  	if self.rank == 'Шведская'
	  		self.update_column(:clientrate, 160*hours_count)
	  	else
	  		self.update_column(:clientrate, 200*hours_count)
	  	end
	  	additional_costs
	  when 'Официант первой категории'
	  	self.update_column(:selfrate, 120*hours_count)
	  	self.update_column(:clientrate, 200*hours_count)
	  	additional_costs
	  end
	end

	def additional_costs
		if self.is_main?
			self.update_column(:selfrate, 140*hours_count)
	  		self.update_column(:clientrate, 200*hours_count)
	  	elsif self.is_coordinator?
			self.update_column(:selfrate, 150*hours_count)
	  		self.update_column(:clientrate, 0*hours_count)
	  	elsif self.is_reserve?
	  		self.update_column(:selfrate, ((self.selfrate/hours_count+20)*hours_count))
	  	else
		end
	end

	def hours_count
		TimeDifference.between(self.start_time, self.finish_time).in_hours
	end

end
