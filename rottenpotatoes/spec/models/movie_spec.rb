require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe '.same_director' do
  #it 'should be defined' do
   #   expect { self.same_director("Aladdin") }.not_to raise_error
    #end
  let!(:movie1) { Movie.create({:title => 'temprate', :director => 'G', :release_date => '25-Nov-1192'}) }
  let!(:movie2) { Movie.create({:title => 'uhoh', :director => 'F', :release_date => '25-Nov-1922'}) }
  let!(:movie3) { Movie.create({:title => 'i am lost', :director => 'G', :release_date => '25-Nov-1392'}) }
  let!(:movie4) { Movie.create({:title => 'unauthored film', :release_date => '25-Nov-1492'}) }
  context 'director exists' do
      it 'finds similar movies correctly' do
        expect(Movie.same_director(movie1.title)).to eql(['temprate', "i am lost"])
        expect(Movie.same_director(movie1.title)).to_not include(['uhoh'])
      end
      it 'have only one movie' do
          expect(Movie.same_director(movie2.title)).to eql(['uhoh'])
          expect(Movie.same_director(movie2.title)).to_not include(['unauthored film','temprate'])
      end
    end
  context 'director not exist' do
      it 'return nil' do
          expect(Movie.same_director(movie4.title)).to eql(nil)
      end
      
    end
  end
end
