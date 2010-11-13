require 'rubygems'
require 'nokogiri'
require 'open-uri'

class MainController < ApplicationController

  # GET http://localhost:3000/agregarservicio/123/456.xml
  def create_servicio
    i_orden_id = params[:orden_id]
    i_servicio_id = params[:servicio_id]

    #revisar que orden exista    
    if (@orden = Orden.find(i_orden_id))

      #pedir description del servicio
      url_servicio = "http://localhost:3001/servicio_nombre/#{i_servicio_id}.xml"
      puts url_servicio
      servicio = Nokogiri::XML(open(url_servicio))

      if servicio.at_css('error').nil?
        nombre = servicio.at_css('nombre').text
       
        @ordendetalle = Ordendetalle.new(:orden_id => @orden.id,
                                         :servicio_id => i_servicio_id,
                                         :descripcion => nombre)
        unless @ordendetalle.save
          @error_code = 500
          @error_description = "Error al agregar servicio. #{@ordendetalle.errors}"
          logger.debug { "Error: #{@ordendetalle.errors}" }
        end
      else
        @error_code = 500
        @error_description = "Error al obtener servicio."
      end
    else
      @error_code = 500
      @error_description = "Numero de orden invalido."
    end

    respond_to do |format|
      format.xml
    end
    
  end
  
  # GET http://localhost:3000/recibirvehiculo/123.xml
  # cita_id = 123
  def create_orden
    i_cita_id = params[:cita_id]

    @cita = Cita.where("id = ?", i_cita_id)
    if @cita.empty?
      @error_code = 500
      @error_description = "Numero de cita invalido"
    else
      #buscar si ya existe
      @orden = Orden.where(:cita_id => @cita[0].id)
      
      if @orden.empty?
        #crear orden
        @orden = Orden.new(:cita_id => @cita[0].id,
                           :estado_id => Orden::ESTADO_RECIBIDO)

        unless @orden.save
          @error_code = 500
          @error_description = "Error al crear orden. #{@orden.errors}"       
        end
        
      else
        @error_code = 500
        @error_description = "Cita ya ha sido ingresada."
      end
      
    end

    respond_to do |format|
      format.xml
    end
    
  end


  # GET http://localhost:3000/nuevacita/122brw/31-12-2010/15.xml
  # placa = 122brw
  # fecha = 31-12-2010
  # hora = 15 ~= 3PM
  def create_cita

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
  # GET http://locahost:3000/consultafecha/31-12-2010list.xml
  # fecha = 31-12-2010
  # hora = 15 ~= 3PM
  def find_cita
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
