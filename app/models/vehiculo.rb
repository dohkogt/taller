class Vehiculo < ActiveRecord::Base
has_many :citas
  validates :placa, :presence => true
end
