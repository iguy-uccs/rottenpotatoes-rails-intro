class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  
    # Configure @all_ratings
    @all_ratings = Movie.possible_ratings
    
    # Get ratings from session if unspecified
    if params[:ratings].nil?
      #If no params or session, show all ratings
      session[:ratings] = session[:ratings].nil? ? Movie.possible_ratings : session[:ratings]
    else
      session[:ratings] = params[:ratings]
    end
    
    #Get sort order from session if unspecified
    if !params[:sortby].nil?
      session[:sortby] = params[:sortby]
    end
      
    # Configure sort order
    if session[:sortby] == 'title'
      sort_order = 'title ASC'
    elsif session[:sortby] == 'date'
      sort_order = 'release_date ASC'
    else
      sort_order = ''
    end
    
    # Movie Rating filter
    @movies = Movie.where(rating: session[:ratings].keys).order(sort_order)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
