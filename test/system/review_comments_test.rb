require "application_system_test_case"

class ReviewCommentsTest < ApplicationSystemTestCase
  test "adding a new comment to a review" do
    user = User.new email: 'test@admin.ch'
    user.save!

    visit new_user_path
    fill_in('Email', with: user.email)
    click_on('Log in')

    review = Review.new book_title: 'Veronica decide morir',
                        user: user
    review.save

    visit review_path(review)
    fill_in('Add a comment', with: 'This is a great book')
    click_on('Post', match: :first)

    assert_equal review_path(review), page.current_path
    assert page.has_content?('This is a great book')
  end

  test 'Show first five comments' do 
    user = User.new email: 'test@admin.ch'
    user.save
    review = Review.new book_title: 'Veronica decide morir',
                          user: user
    review.save

    8.times do |i|
      comment = Comment.new body: "Book comment #{i+1}",
                            review: review,
                            user: user
      comment.save
    end

    visit review_path(review)
    assert page.has_content?('Book comment 8')
    assert page.has_content?('Book comment 7')
    assert page.has_content?('Book comment 6')
    assert page.has_content?('Book comment 5')
    assert page.has_content?('Book comment 4')
    refute page.has_content?('Book comment 3')
    refute page.has_content?('Book comment 2')
    refute page.has_content?('Book comment 1')
  end
  
  test 'Show no comments' do 
    user = User.new email: 'test@admin.ch'
    user.save
    review = Review.new book_title: 'Veronica decide morir',
                          user: user
    review.save

    visit review_path(review)
    assert page.has_content?('Sorry, no comments!')
  end 

end
