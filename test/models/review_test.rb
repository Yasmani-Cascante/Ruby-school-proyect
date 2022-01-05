require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  
  # Validation Test 

  test 'presence of book title' do
    user = User.new email: 'test@admin.ch'
    user.save!

    review = Review.new user: user                   
    refute review.valid?
  end

  test 'max length of book author' do
    user = User.new email: 'test@admin.ch'
    user.save!

    review = Review.new book_title: 'Book title',
                        book_author:'This is the name of the author of the book, it is really very long to be able to perform tests for the validations of the review model in my Books review application',
                        user: user

    refute review.valid?
  end

  # Most recents Test

  test 'most_recent with two reviews' do 
    user = User.new email: 'test@admin.ch'
    user.save!

    review_1 = Review.new book_title: 'El hombre mediocre',
                          user: user
    review_1.save

    review_2 = Review.new book_title: 'El hombre invisible', 
                          user: user
    review_2.save

    # assert_equal Review.most_recent.length, 2
    assert_equal Review.most_recent.first, review_2
  end 

  test 'most_recent with eight reviews' do 
    user = User.new email: 'test@admin.ch'
    user.save!

    8.times do |i|
      review = Review.new 
      review.book_title = "Title of book #{i+1}"
      review.user = user
      review.save
    end

    assert_equal Review.most_recent.length, 6
    assert_equal Review.most_recent.first.book_title, "Title of book 8"
  end 

  # Search Filter Tests

  test 'one matching result' do 

    user = User.new email: 'test@admin.ch'
    user.save!

    review = Review.new book_title: 'El hombre mediocre',
                        user: user
    review.save!
    assert_equal(Review.search('El hombre').length, 1)
  end 

  test 'two matching result' do 

    user = User.new email: 'test@admin.ch'
    user.save!

    review_1 = Review.new book_title: 'El hombre mediocre',
                        user: user
    review_1.save!

    review_2 = Review.new book_title: 'El hombre invisible', 
                              user: user
    review_2.save!

    assert_equal(Review.search('hombre').length, 2)
  end 

  test 'that no matching result' do 
    user = User.new email: 'test@admin.ch'
    user.save!

    review = Review.new book_title: 'El hombre mediocre',
                        user: user
    review.save!
    assert_empty Review.search('Veronica')
  end 

  test 'search by book author' do 
    user = User.new email: 'test@admin.ch'
    user.save!

    review = Review.new book_title: 'El hombre mediocre',
                        book_author:'Jose Ingenieros',
                        user: user
    review.save!

    assert_equal(Review.search('Jose').length, 1)
  end 

  test 'search by author and title' do 
    user = User.new email: 'test@admin.ch'
    user.save!

    review_1 = Review.new book_title: 'Book title',
                        book_author:'Jose Ingenieros',
                        user: user
    review_1.save!

    review_2 = Review.new book_title: 'Another title',
                          book_author:'Book author',
                          user: user
    review_2.save!

    assert_equal(Review.search('book').length, 2)
  end 

  # Update review Tests
  
  test 'updated_at is changed after updating the book title' do

    user = User.new email: 'test@admin.ch'
    user.save!

    review = Review.new book_title: 'El hombre mediocre',
                        user: user
    review.save!

    first_updated_at = review.updated_at
    review.book_title = 'Veronica decide morir'
    review.user = user
    review.save!
    refute_equal(review.updated_at, first_updated_at)
  end

  test 'updated_at is changed after updating the book author' do
    user = User.new email: 'test@admin.ch'
    user.save!

    review = Review.new book_title: 'El hombre mediocre',
                        book_author:'Jose Ingenieros',
                        user: user
    review.save!

    first_updated_at = review.updated_at
    review.book_author = 'Another author name'
    review.user = user
    review.save!
    refute_equal(review.updated_at, first_updated_at)
  end

  test 'updated_at is changed after updating the book image' do
    user = User.new email: 'test@admin.ch'
    user.save!

    review = Review.new book_title: 'El hombre mediocre',
                        image_url: 'http://fpoimg.com/300x360',
                        user: user
    review.save!

    first_updated_at = review.updated_at
    review.image_url = 'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1180674000l/1064310._SY475_.jpg'
    review.user = user
    review.save!
    refute_equal(review.updated_at, first_updated_at)
  end

end
