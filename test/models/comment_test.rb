require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  test 'presence of comment body' do
    user = User.new email: 'test@admin.ch'
    user.save

    review = Review.new book_title: 'El hombre mediocre',
                        user: user
    review.save

    comment = Comment.new review: review,
                          user: user

    refute comment.valid?
  end

  test "changing the associated Review for a Comment" do

    user = User.new email: 'test@admin.ch'
    user.save

    review_1 = Review.new book_title: 'Veronica decide morir',
                          user: user
    review_1.save

    comment = Comment.new body: 'This is a great book!', 
                          review: review_1,
                          user: user
    comment.save

    review_2 = Review.new book_title: 'Veronica decide morir',
                         user: user
    review_2.save

    comment.review = review_2
    comment.save

    assert_equal Comment.first.review, review_2

  end

  test 'cascade save' do
    
    user = User.new email: 'test@admin.ch'
    user.save

    review = Review.new book_title: 'Veronica decide morir',
                          user: user
    review.save

    comment = Comment.new body: 'This is a great book!',
                          user: user
    review.comments << comment
    review.save

    assert_equal comment, Comment.first
  end

  test 'comments are ordered correctly' do
    user_1 = User.new email: 'test@admin.ch'
    user_1.save
    user_2 = User.new email: 'test_2@admin.ch'
    user_2.save

    review = Review.new book_title: 'Veronica decide morir',
                        user: user_1
    review.save

    comment_1 = Comment.new body: 'This is a great book!',
                            user: user_1

    comment_2 = Comment.new body: 'I totally agree!',
                            user: user_2

    review.comments << comment_1
    review.comments << comment_2
    review.save

    assert_equal review.comments.first, comment_1
    assert_equal review.comments.length, 2
  end

  test 'most_recent with two reviews' do 
    user = User.new email: 'test@admin.ch'
    user.save

    review = Review.new book_title: 'El hombre mediocre',
                        user: user
    review.save

    comment_1 = Comment.new body: 'This is a great book!',
                            review: review,
                            user: user
    comment_1.save
    
    comment_2 = Comment.new body: 'I totally agree!',
                            review: review,
                            user: user
    comment_2.save

    assert_equal Comment.most_recent.length, 2
    assert_equal Comment.most_recent.first, comment_2
  end 

end
