require "application_system_test_case"

class ShowReviewsTest < ApplicationSystemTestCase
  test "show display review" do

    user = User.new email: 'test@admin.ch'
    user.save

    review = Review.new book_title: 'Veronica decide morir',
                        book_author:'Paulo Coelho',
                        body: 'Brief description'
    review.user = user
    review.save

    visit review_path(review)
    assert_selector "h1", text: "Veronica decide morir"
    assert page.has_content?('Brief description')
    assert page.has_content?('Paulo Coelho')
    assert page.has_content?(review.created_at.strftime("%d %b %y"))

  end

  test "that the users'options are showing" do
    
    visit new_user_path
    fill_in('Email', with: 'test@admin.ch')
    click_on('Log in')

    review = Review.new book_title: 'Veronica decide morir',
                        book_author:'Paulo Coelho',
                        body: 'Brief description'
    review.user = User.first
    review.save

    visit review_path(review)
    assert page.has_selector?(:link, text: 'EDIT')
    assert page.has_selector?('input.btn')

  end

end
