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
    # gets the ratings to be displayed
    @all_ratings = Movie.get_ratings
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
    
    # filter movies by rating
    # if no ratings are provided, choose all movies
    movies = []
    if params[:ratings]
      movies = Movie.where(rating: params[:ratings].keys)
    else
      movies = Movie.all
    end 
    
    # display movies, sorting by some parameter
    puts "Displaying movies . . ."
    @sort = params[:sort_by]
    if @sort == 'title'
      @movies = movies.order(:title)
    elsif @sort == 'release_date'
      @movies = movies.order(:release_date)
    else
      @movies = movies
    end
  end
end
