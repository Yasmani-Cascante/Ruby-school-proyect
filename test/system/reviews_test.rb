require "application_system_test_case"

class ReviewsTest < ApplicationSystemTestCase
  
  test "create new review" do

    visit new_user_path
    fill_in('Email', with: 'test@admin.ch')
    click_on('Log in')

    visit new_review_path
    fill_in('Title', with: 'Veronica decide morir')
    fill_in('Image of the book', with: 'https://imagessl9.casadellibro.com/a/l/t7/79/9788408026679.jpg')
    click_on('Create Review')
    assert page.has_content?('Veronica decide morir')
  end

  test 'new review with no book title' do 
    user = User.new email: 'test@admin.ch'
    user.save

    visit new_user_path
    fill_in('Email', with: user.email)
    click_on('Log in')

    visit new_review_path
    fill_in('Author', with: 'Paulo Coelho')
    fill_in('Image of the book', with: 'https://imagessl9.casadellibro.com/a/l/t7/79/9788408026679.jpg')
    click_on('Create Review')

    assert page.has_content?("Book title can't be blank")
  end 

  test 'reviews are loaded in the index' do

    user = User.new email: 'test@admin.ch'
    user.save

    review_1 = Review.new book_title: 'Veronica decide morir',
                          user: user
    review_1.save

    review_2 = Review.new book_title: 'El hombre mediocre',
                          user: user
    review_2.save

    visit reviews_path
    assert page.has_content?('Veronica decide morir')
    assert page.has_content?('El hombre mediocre')
    
  end

  test 'homepage highlights' do 
    user = User.new email: 'test@admin.ch'
    user.save

    8.times do |i|
      review = Review.new 
      review.book_title = "Title of book #{i+1}"
      review.user = user
      review.save
    end

    visit root_path
    assert page.has_content?('Title of book 8')
    assert page.has_content?('Title of book 7')
    assert page.has_content?('Title of book 6')
    assert page.has_content?('Title of book 5')
    assert page.has_content?('Title of book 4')
    assert page.has_content?('Title of book 3')
    refute page.has_content?('Title of book 2')
    refute page.has_content?('Title of book 1')
  end 

  # Search filter Test

  test 'search by title' do 
    user = User.new email: 'test@admin.ch'
    user.save

    review_1 = Review.new book_title: 'El hombre mediocre',
                          user: user
    review_1.save

    review_2 = Review.new book_title: 'Veronica decide morir',
                          user: user
    review_2.save

    visit root_path
    sleep(2.seconds)
    fill_in('q', with: 'El hombre')
    click_on('Search', match: :first)
    
    assert page.current_path.include?(reviews_path)
    assert page.has_content?('El hombre mediocre')
    refute page.has_content?('Veronica decide morir')
  end 

  test 'no search results' do
    visit(reviews_path)
    assert page.has_content?("No result for!")
  end

  test 'search by book author and title' do 
    user = User.new email: 'test@admin.ch'
    user.save

    review_1 = Review.new book_title: 'Book title',
                        book_author:'Jose Ingenieros',
                        user: user
    review_1.save

    review_2 = Review.new book_title: 'Another title',
                          book_author:'Book author',
                          user: user
    review_2.save

    review_3 = Review.new book_title: 'The last run',
                          book_author:'Somebody',
                          user: user
    review_3.save

    visit root_path
    fill_in('q', with: 'Book').send_keys(:enter)

    assert page.has_content?('Book title')
    assert page.has_content?('Another title')
    refute page.has_content?('The last run')

  end 

  test "existing review updated with no book title" do
    user = User.new email: 'test@admin.ch'
    user.save
    visit new_user_path
    fill_in('Email', with: user.email)
    click_on('Log in')
    
    review = Review.new book_title: 'Veronica decide morir',
                        book_author:'Paulo Coelho',
                        user: user
    review.save
    
    visit edit_review_path(review)
    fill_in('Title', with: '')
    click_on('Update Review')
    assert page.has_content?("Book title can't be blank")
  end

  test 'editing a review' do

    user = User.new email: 'test@admin.ch'
    user.save

    visit new_user_path
    fill_in('Email', with: user.email)
    click_on('Log in')

    review = Review.new book_title: 'El hombre',
                        book_author:'Paulo Coelho',
                        body: 'Brief description',
                        user: user
    review.save

    visit edit_review_path(review)
    assert page.has_selector?('form input')

    fill_in('Title', with: 'El hombre mediocre')
    fill_in('Author', with: 'Jose Ingenieros')
    fill_in('Description', with: 'An other brief description.')
    click_on('Update Review')

    click_on('El hombre mediocre')
    assert page.has_content?('El hombre mediocre')
    assert page.has_content?('Jose Ingenieros')
    assert page.has_content?('An other brief description.')

  end
  
end
