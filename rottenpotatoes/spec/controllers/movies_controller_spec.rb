require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  
  describe 'GET index' do
    it 'should render index template' do
      get :index
      expect(response).to render_template('index')
    end

    it 'should assign instance variable for title header (to flash)' do
      get :index, { sort: 'title'}
      expect(assigns(:title_header)).to eql('bg-warning hilite')
    end

    it 'should assign instance variable for release_date header (to flash)' do
      get :index, { sort: 'release_date'}
      expect(assigns(:date_header)).to eql('bg-warning hilite')
    end
  end
  let!(:movie1) { Movie.create({:title => 'temprate', :director => 'G', :release_date => '25-Nov-1192'}) }
  let!(:movie2) { Movie.create({:title => 'uhoh', :director => 'F', :release_date => '25-Nov-1922'}) }
  let!(:movie3) { Movie.create({:title => 'i am lost', :director => 'G', :release_date => '25-Nov-1392'}) }
  describe 'create' do
    it 'creates a new movie' do
      expect {post :create, movie: {:title => 'i am lost', :director => 'G', :release_date => '25-Nov-1392'}}.to change { Movie.count }.by(1)
    end
  end
  describe 'show' do
    before(:each) do
      get :show, id: movie1.id
    end

    it 'should find the movie' do
      expect(assigns(:movie)).to eql(movie1)
    end

    it 'should render show template' do
      expect(response).to render_template('show')
    end
  end
  
  describe 'edit' do
    before do
      get :edit, id: movie2.id
    end

    it 'should find movie' do
      expect(assigns(:movie)).to eql(movie2)
    end

    it 'should render edit template' do
      expect(response).to render_template('edit')
    end
  end
  describe 'update' do
    before(:each) do
      put :update, id: movie1.id, movie: {:title => 'changedtemp'}
    end

    it 'updates an existing movie' do
      movie1.reload
      expect(movie1.title).to eql('changedtemp')
      expect(movie1.title).not_to eql('temprate')
    end
    it 'do not change place that is not updated' do
      movie1.reload
      expect(movie1.director).to eql('G')
    end
    it 'redirects to the movie page' do
      expect(response).to redirect_to(movie_path(movie1))
    end
  end
  
  describe 'destroy' do

    it 'destroys a movie' do
      expect { delete :destroy, id: movie1.id }.to change(Movie, :count).by(-1)
    end
    it 'redirects to movies after destroy' do
      delete :destroy, id: movie1.id
      expect(response).to redirect_to(movies_path)
    end
  end
  
  describe 'Search movies by the same director' do
    it 'should call Movie.similar_movies' do
      expect(Movie).to receive(:same_director).with('uhoh')
      get :search, { title: 'uhoh' }
    end
  
    it 'should show movies with same director' do
      movies = ['wdnmd', 'eggplant','qiezi']
      Movie.stub(:same_director).with('wdnmd').and_return(movies)
      get :search, { title: 'wdnmd' }
      expect(assigns(:similar_movies)).to eql(movies)
    end

    it "should redirect to home page no director" do
      Movie.stub(:same_director).with('wasted').and_return(nil)
      get :search, { title: 'wasted' }
      expect(response).to redirect_to(root_url)
    end
  end
end
