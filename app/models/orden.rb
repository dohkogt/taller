class Orden < ActiveRecord::Base
  ESTADO_RECIBIDO = 1
  
  belongs_to :cita
  belongs_to :estado
  has_many :ordendetalles
     validates :cita_id, :estado_id, :presence => true
end
