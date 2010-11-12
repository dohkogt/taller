class CitasController < ApplicationController
  
  # GET http://localhost:3000/nuevacita/122brw/31-12-2010/15.xml
  # placa = 122brw
  # fecha = 31-12-2010
  # hora = 15 ~= 3PM
  def create

    c_placa = params[:placa].upcase
    c_fecha = params[:fecha]
    c_hora = params[:hora]
    
    # buscar si vehiculo existe
    @vehiculo = Vehiculo.find_by_placa(c_placa)

    if @vehiculo.nil?
      #crear nuevo vehiculo
      @vehiculo = Vehiculo.new(:placa => c_placa)
      unless @vehiculo.save
        @error_code = 500
        @error_description = "Error al crear vehiculo. #{@vehiculo.errors}"
      end            
    end

    @cita = Cita.new(:fecha => Date.parse(c_fecha),
                     :hora => c_hora.to_i,
                     :cliente_id => @vehiculo.id,
                     :estados_id => 1)

    unless @cita.save
      @error_code = 500
      @error_description = "Error al crear cita. #{@cita.errors}"
    end

    respond_to do |format|
      format.xml
    end
    
  end

  # GET http://locahost:3000/consultarfechahora/31-12-2010/15.xml
  # GET http://locahost:3000/consultafecha/31-12-2010.xml
  # fecha = 31-12-2010
  # hora = 15 ~= 3PM
  def find
    d_fecha = Date.parse(params[:fecha])

    unless params[:hora].nil?      
      i_hora = params[:hora].to_i
      citas = Cita.where("fecha = ? and hora = ?", d_fecha, i_hora).count
      # 1 : ocupado
      # 0 : libre
      @disponible = citas > 0 ? 1 : 0
    else
      citas = Cita.select('hora').where("fecha = ?", d_fecha)

      @horaslibres = ["8", "9", "10", "11", "12", "13", "14", "15", "16", "17"]
      for cita in citas
        @horaslibres.delete(cita.hora.to_s)
      end
    end
    

    respond_to do |format|
      format.xml
    end
  end


  

end
