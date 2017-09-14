class MoviesController < ApplicationController

  # defines movie parameters
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  # shows a specific movie 
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  # main function that runs the view
  def index
    # displays the movies based on what we are sorting by 
    display_movies
  end

  # ? 
  def new
    # default: render 'new' template
  end
  
  # creates a movie and inserts in database
  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  # edits a movie
  def edit
    @movie = Movie.find params[:id]
  end

  # updates a movie in the database 
  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  # deletes a movie from the database 
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  # displays movies based on sorting parameters
  def display_movies

    # get all info from params[] and session[]
    @sort = params[:sort_by] || session[:sort_by]
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}
      
    # filter movies by rating
    movies = []
    if params[:ratings]
      movies = Movie.where(rating: @selected_ratings.keys)
    else
      movies = Movie.all
    end 
    
    # display movies, sorting by some parameter
    puts "Displaying movies . . ."
    if @sort == 'title'
      @movies = movies.order(:title)
    elsif @sort == 'release_date'
      @movies = movies.order(:release_date)
    else
      @movies = movies
    end
    
    # if we detect a change in settings, store it. 
    if session[:sort] != params[:sort] or session[:ratings] != params[:ratings]
      session[:sort_by] = @sort
      session[:ratings] = @selected_ratings
      redirect_to :sort_by => @sort, :ratings => @selected_ratings 
    end 
  end
end
