require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  test "that invalid new user error is showing" do
    visit new_user_path
    fill_in('Email', with: '')
    click_on('Log in')
    assert page.has_content?('Email is invalid')
  end

  test "that owner badge is showing in the cards" do
    visit new_user_path
    fill_in('Email', with: 'test@admin.ch')
    click_on('Log in')

    visit new_review_path
    fill_in('Title', with: 'Veronica decide morir')
    fill_in('Image of the book', with: 'https://imagessl9.casadellibro.com/a/l/t7/79/9788408026679.jpg')
    click_on('Create Review')

    visit account_reviews_path
    sleep(3.seconds)
    assert page.has_content?('Owner')
  end
end
