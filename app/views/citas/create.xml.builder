xml.instruct!
unless @error_code.nil?
  xml.error do    
    xml.code @error_code
    xml.descripcion @error_description
 end
else
  xml.cita do
    xml.id @cita.id
    xml.hora @cita.hora
    xml.cliente_id @cita.cliente_id
    xml.estados_id @cita.estados_id
  end
end
