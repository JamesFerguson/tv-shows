class TvShowsController < ApplicationController
  # GET /tv_shows
  # GET /tv_shows.xml
  def index
    @tv_shows = TvShow.all

    respond_to do |format|
      format.html # index.html.erb
      format.atom do # index.atom.builder
        render :layout => false
      end
      format.rss do # redirect rss to atom
        redirect_to tv_shows_path(:format => :atom), :status => :moved_permanently
      end
    end
  end

  # GET /tv_shows/1
  # GET /tv_shows/1.xml
  def show
    @tv_show = TvShow.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.atom do # show.atom.builder
        render :layout => false
      end
      format.rss do # redirect rss to atom
        redirect_to tv_show_path(@tv_show, :format => :atom), :status => :moved_permanently
      end
    end
  end

  # GET /tv_shows/new
  # GET /tv_shows/new.xml
  def new
    @tv_show = TvShow.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tv_show }
    end
  end

  # GET /tv_shows/1/edit
  def edit
    @tv_show = TvShow.find(params[:id])
  end

  # POST /tv_shows
  # POST /tv_shows.xml
  def create
    @tv_show = TvShow.new(params[:tv_show])

    respond_to do |format|
      if @tv_show.save
        format.html { redirect_to(@tv_show, :notice => 'Tv show was successfully created.') }
        format.xml  { render :xml => @tv_show, :status => :created, :location => @tv_show }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tv_show.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tv_shows/1
  # PUT /tv_shows/1.xml
  def update
    @tv_show = TvShow.find(params[:id])

    respond_to do |format|
      if @tv_show.update_attributes(params[:tv_show])
        format.html { redirect_to(@tv_show, :notice => 'Tv show was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tv_show.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tv_shows/1
  # DELETE /tv_shows/1.xml
  def destroy
    @tv_show = TvShow.find(params[:id])
    @tv_show.destroy

    respond_to do |format|
      format.html { redirect_to(tv_shows_url) }
      format.xml  { head :ok }
    end
  end
end
