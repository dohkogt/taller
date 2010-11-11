class Ordendetalle < ActiveRecord::Base
  belongs_to :orden
  has_many :serviciorepuestos
     validates :orden_id, :servicio_id, :presence => true
end
