class Waiter < ApplicationRecord
	has_many :shifts, class_name: '::Shift', through: :payments, source: :shift
  	has_many :payments
  	accepts_nested_attributes_for :payments, allow_destroy: true

  	belongs_to :manager, class_name: '::AdminUser'
  	
	RANKS = ['Новичок', 'Официант шведской линии', 'Официант банкетной области', 'Официант первой категории', 'Официант второй категории']
end
