require "application_system_test_case"

class NavigationsTest < ApplicationSystemTestCase
  test 'search term is displayed' do
    visit root_path
    assert page.has_content?('Books Review')
    fill_in('q', with: 'Florencia').send_keys(:enter)
    assert has_content?('Florencia')
    assert current_url.include?('q=Florencia')
  end

  test 'visitor navigation' do 
    visit root_path
    assert page.has_content?('Books Review')
    click_on('About')
    assert page.has_content?('About')
    click_on('Home')
    assert_equal page.current_path, root_path
  end

  test 'Users routes' do 
    visit new_user_path
    fill_in('Email', with: 'test@admin.ch')
    click_on('Log in')

    visit root_path
    click_on('My Account')
    click_on('My Bookmarks')
    assert page.has_content?('Your list is empty!')

    click_on('My Account')
    click_on('My Reviews')
    assert page.has_content?('Your reviews list is empty!')

    click_on('Log out')
    assert_equal page.current_path, root_path
  end

  test 'that user routes do not show for visitors' do 
    user = User.new email: 'test@admin.ch'
    user.save
    review = Review.new book_title: 'Book title',
                        book_author:'Jose Ingenieros',
                        user: user
    review.save

    visit new_review_path
    assert_equal page.current_path, root_path

    visit edit_review_path(review)
    assert_equal page.current_path, root_path
  end
end
