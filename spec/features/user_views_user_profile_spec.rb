require 'spec_helper'

feature 'User profile' do
  before do
    setup_defaults
    log_me_in
  end

  scenario 'viewed by another user' do
    user = other_user
    user.create_topic('this is my thread')
    user.load_page

    expect(user).to be_displaying_the_profile
    expect(user).to have_topic('this is my thread')
  end

  scenario 'can only see viewable threads' do
    user = other_user
    user.create_private_topic('secret')
    user.create_unreadable_topic_in_private_messageboard('unreadable')
    user.load_page

    expect(user).not_to have_topic('secret')
    expect(user).not_to have_topic('unreadable')
  end

  scenario 'redirects if it does not exist' do
    user = anonymous_user
    user.load_page

    expect(user).to have_redirected_with_error
  end

  def setup_defaults
    create(:app_config)
    create(:messageboard)
  end

  def anonymous_user
    PageObject::Visitor.new
  end

  def log_me_in
    PageObject::User.new.log_in
  end

  def other_user
    PageObject::User.new.user('john', 'john@example.com')
  end
end
