class Waiter < ApplicationRecord
	has_many :shifts, class_name: '::Shift', through: :payments, source: :shift
  	has_many :payments
  	accepts_nested_attributes_for :payments, allow_destroy: true

  	validates :gender, presence: true

  	scope :female, -> { where(gender: 'Женский') }
 	scope :male, -> { where(gender: 'Мужской') }

  	belongs_to :manager, class_name: '::AdminUser'
  	
	RANKS = ['Стажер', 'Официант шведской линии', 'Официант банкетной области', 'Официант первой категории', 'Официант второй категории']

	after_commit :set_prepayment, on: [:update]

	def set_prepayment
		if prepayment_limit <= 0
			self.update_column(:prepayment, 0)
			self.update_column(:prepayment_limit, 0)
		end
	end
end
