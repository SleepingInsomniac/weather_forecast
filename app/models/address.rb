class Address
  include ActiveModel::Model

  def self.states_hash
    @states ||= JSON.parse(Rails.root.join("db", "states.json").read).invert
  end

  attr_accessor :street, :city, :state, :zip, :country

  validates :street, length: { in: 3..99, allow_blank: true }
  validates :state, inclusion: { in: Address.states_hash.values, allow_blank: true }
  validates :zip, format: { with: /\A\d{5}\z/, allow_blank: true }
end
