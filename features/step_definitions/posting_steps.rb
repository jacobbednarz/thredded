Then /^I should not see the post reply form$/ do
  page.should_not have_selector('textarea#post_content')
end


Given /^"([^"]*)" posting permissions are constrained to those that are "([^"]*)"$/ do |messageboard, permission|
  @messageboard = Thredded::Messageboard.where(name: messageboard).first
  @messageboard.update_attributes(posting_permission: permission)
end

Given /^a messageboard named "([^"]*)" that I, "([^"]*)", am an? "([^"]*)" of$/ do |messageboard, name, role|
  if !user = User.where(name: name).first
    user = create :user,
      name: name,
      email: 'email@email.com',
      password: 'password',
      password_confirmation: 'password'
  end

  messageboard = create(:messageboard, name: messageboard)
  user.send "#{role}_of".to_sym, messageboard
end

Given /^My post filter preference is "([^"]*)"$/ do |filter|
  @current_user.update_attributes(post_filter: filter)
end

Then /^The filter at the reply form should default to "([^"]*)"$/ do |filter|
  field_labeled('post_filter').value.should == filter
end

When /^I enter a title "([^"]*)" with content "([^"]*)"$/ do |title, content|
  fill_in 'Title', with: title
  fill_in 'Content', with: content
end

When /^I submit the form$/ do
  find('.submit input').click
end

Given /^a thread already exists on "([^"]*)"$/ do |board|
  u = User.last
  m = Thredded::Messageboard.where(name: board).first
  t = m.topics.create(last_user: u, title: "thready thread", user: u, posts_count: 1)
  t.posts.create(content: "FIRST!", user: u, messageboard: m)
end

When /^I submit some drivel like "([^"]*)"$/ do |content|
  fill_in "post_content", with: content
  click_button "Submit"
end

Given /^I create the following new threads:$/ do |topics_table|
  user = User.last
  messageboard = Thredded::Messageboard.first

  topics_table.hashes.each_with_index do |topic, i|
    Timecop.travel(10.seconds.from_now) do
      new_topic = messageboard.topics.create(last_user: user,
        title: topic[:title], messageboard: messageboard, user: user)

      new_topic.posts.create(content: topic[:content],
        user: user, messageboard: messageboard)
    end
  end
end

Then /^the topic listing should look like the following:$/ do |topics_table|
  html = Capybara::Node::Simple.new(body)

  cells = html.
    all('#content article h1 a, #content article .post_count, #content article .started_by a, #content article .updated_by a, #content article div').
    map(&:text).
    collect_every(4)

  table = cells.insert(0, ['Posts','Topic Title','Started','Updated'])

  topics_table.diff!(table)
end

Given /^another member named "([^"]*)" exists$/ do |name|
  u = User.create(name: name, email: "#{name}@email.com",
    password: "password", password_confirmation: "password")
end

Given /^"([^"]*)" is a member of "([^"]*)"$/ do |name, board|
  user = User.find_by_name(name)
  messageboard = Thredded::Messageboard.find_by_name(board)
  messageboard.add_member user
end

Given /^I am a admin of "([^"]*)"$/ do |board|
  user = User.last
  board = Thredded::Messageboard.find_by_name board
  board.add_member user, 'admin'
end


When /^I enter a recipient named "([^"]*)", a title "([^"]*)" and content "([^"]*)"$/ do |username, title, content|
  select username, from: 'topic_user_id'
  step %{I enter a title "#{title}" with content "#{content}"}
end

Given /^a private thread exists between "([^"]*)" and "([^"]*)" titled "([^"]*)"$/ do |user1, user2, title|
  @user1 = create(:user, name: user1, email: "#{user1}@thredded.com")
  @user2 = create(:user, name: user2, email: "#{user2}@thredded.com")
  messageboard = Thredded::Messageboard.first
  post = build(:post, content: 'hi', topic: @topic)
  @topic = create(:private_topic, messageboard: messageboard, title: title,
    last_user: @user1, user: @user1, users: [@user1, @user2], posts: [post])
end
