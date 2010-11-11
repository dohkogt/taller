class CitasController < ApplicationController
  # GET /citas
  # GET /citas.xml
  def index
    @citas = Cita.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @citas }
    end
  end

  # GET /citas/1
  # GET /citas/1.xml
  def show
    @cita = Cita.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cita }
    end
  end

  # GET /citas/new
  # GET /citas/new.xml
  def new
    @cita = Cita.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cita }
    end
  end

  # GET /citas/1/edit
  def edit
    @cita = Cita.find(params[:id])
  end

  # POST /citas
  # POST /citas.xml
  def create
    @cita = Cita.new(params[:cita])

    respond_to do |format|
      if @cita.save
        format.html { redirect_to(@cita, :notice => 'Cita was successfully created.') }
        format.xml  { render :xml => @cita, :status => :created, :location => @cita }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cita.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /citas/1
  # PUT /citas/1.xml
  def update
    @cita = Cita.find(params[:id])

    respond_to do |format|
      if @cita.update_attributes(params[:cita])
        format.html { redirect_to(@cita, :notice => 'Cita was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cita.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /citas/1
  # DELETE /citas/1.xml
  def destroy
    @cita = Cita.find(params[:id])
    @cita.destroy

    respond_to do |format|
      format.html { redirect_to(citas_url) }
      format.xml  { head :ok }
    end
  end
end
