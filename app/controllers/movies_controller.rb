class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort = params[:sort] ? params[:sort] : session[:prev_sort]
    session[:prev_sort] = @sort

    @all_ratings = Movie.all_ratings
    @filter_ratings = params[:ratings] ? params[:ratings].keys : prev_ratings_nil
    session[:prev_ratings] = @filter_ratings

    if ! @sort.nil?
	@movies = Movie.find(:all, :conditions => {"rating" => @filter_ratings}, :order => "#{@sort} ASC")
    else
        @movies = Movie.find(:all, :conditions => {"rating" => @filter_ratings})
    end
    
  end

  def prev_ratings_nil
    if session[:prev_ratings].nil?
	session[:prev_ratings] = @all_ratings
    end
    session[:prev_ratings]
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
