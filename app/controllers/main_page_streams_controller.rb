class MainPageStreamsController < ApplicationController
  before_filter :load_main_page_stream, only: [:show, :edit, :update, :destroy]

  # GET /main_page_streams
  # GET /main_page_streams.json
  def index
    @main_page_streams = MainPageStream.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @main_page_streams }
    end
  end

  # GET /main_page_streams/1
  # GET /main_page_streams/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @main_page_stream }
    end
  end

  # GET /main_page_streams/new
  # GET /main_page_streams/new.json
  def new
    @main_page_stream = MainPageStream.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @main_page_stream }
    end
  end

  # GET /main_page_streams/1/edit
  def edit
  end

  # POST /main_page_streams
  # POST /main_page_streams.json
  def create
    @main_page_stream = MainPageStream.new(params[:main_page_stream])

    respond_to do |format|
      if @main_page_stream.save
        format.html { redirect_to @main_page_stream, notice: 'Main page stream was successfully created.' }
        format.json { render json: @main_page_stream, status: :created, location: @main_page_stream }
      else
        format.html { render :new }
        format.json { render json: @main_page_stream.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /main_page_streams/1
  # PUT /main_page_streams/1.json
  def update
    respond_to do |format|
      if @main_page_stream.update_attributes(params[:main_page_stream])
        format.html { redirect_to @main_page_stream, notice: 'Main page stream was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: @main_page_stream.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /main_page_streams/1
  # DELETE /main_page_streams/1.json
  def destroy
    @main_page_stream.destroy

    respond_to do |format|
      format.html { redirect_to main_page_streams_url }
      format.json { head :no_content }
    end
  end

  private
  def load_main_page_stream
    @main_page_stream = MainPageStream.find(params[:id])
  end
end
