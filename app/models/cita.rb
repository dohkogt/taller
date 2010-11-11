class Cita < ActiveRecord::Base
  belongs_to :vehiculo
  belongs_to :orden
  has_many :citas  
      validates :fecha, :hora, :cliente_id, :estados_id, :presence => true
  
end
