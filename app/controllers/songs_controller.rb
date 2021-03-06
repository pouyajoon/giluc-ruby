require 'logger'

logger = Logger.new(STDOUT)

class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy]

  # GET /songs
  # GET /songs.json
  def index
    @songs = Song.all
  end

  def analyseChords chords, modulo
    @ints = @chords.map {|c| c.to_i}

    @res = Array.new
    @ints.each_with_index do |value, index|

      nextIndex = (index + 1) % modulo
      diffWithNextIndex = (@ints[nextIndex] - @ints[index])
      logger.info ("i #{index} #{nextIndex} #{diffWithNextIndex}")

      if diffWithNextIndex == 0 
        @res << '='
      elsif diffWithNextIndex < 0 #negatif
        if (diffWithNextIndex % 2 == 0) #is even
          @res << 'vd'
        else
          @res << 'vs'
        end              
      else # positif
        if (diffWithNextIndex % 1 == 0) #is even
          @res << 'vd'
        else
          @res << 'vs'
        end              
      end
    end
    return @res
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
    @chords = @song.chords.split(',')

    @modulo = params[:modulo]
    @analyses = Array.new
    if (@modulo == nil)
      @analyses << {'m' => @chords.length, 'a' => (analyseChords @chords, @chords.length)}
    else      
      @modulo.split(',').map {|e| e.to_i}.each do |m|
        @analyses << {'m' => m, 'a' => (analyseChords @chords, m)}
      end
      
    end
  end

  # GET /songs/new
  def new
    @song = Song.new
  end

  # GET /songs/1/edit
  def edit
  end

  # POST /songs
  # POST /songs.json
  def create
    @song = Song.new(song_params)

    respond_to do |format|
      if @song.save
        format.html { redirect_to @song, notice: 'Song was successfully created.' }
        format.json { render action: 'show', status: :created, location: @song }
      else
        format.html { render action: 'new' }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to @song, notice: 'Song was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song.destroy
    respond_to do |format|
      format.html { redirect_to songs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def song_params
      params.require(:song).permit(:name, :chords)
    end
end
