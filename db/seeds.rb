require 'open-uri'
require 'faraday'
require 'json'

Like.destroy_all
Comment.destroy_all
Post.destroy_all
User.destroy_all

DEFAULT_MALE_IMAGE_URL = 'https://randomuser.me/api/portraits/men/43.jpg'
DEFAULT_FEMALE_IMAGE_URL = 'https://randomuser.me/api/portraits/women/49.jpg'
MAX_MALES = 7
MAX_FEMALES = 8
POST_CATEGORY =  %w(Crime
                    Detective fiction
                    Science fiction
                    Post-apocalyptic
                    Distopia
                    Cyberpunk
                    Fantasy
                    Romantic novel
                    Western
                    Horror
                    Classic
                    Fairy tale
                    Fan fiction
                    Folklore
                    Historical fiction
                    Humor
                    Mystery
                    Picture book
                    Thriller
                    Erotic
                  )
STUPID_COMMENTS = %w(Cool Nice Best Sh1t Thanks)

puts ''
print '=' * 39 + ' Please wait while get seed data! ' + '=' * 39
admin = User.where(email: 'admin@mail.com', first_name: 'Aleksey', last_name: 'Reznov').first_or_initialize
admin.update(password: 'password') if admin.new_record?
User.create!(email: 'a.p.ruban@gmail.com', first_name: 'Aleksander', last_name: 'Ruban', password: 'password')

# Star Wars heroes
response = Faraday.get('https://akabab.github.io/starwars-api/api/all.json')
data = JSON.parse(response.body)
males, females = data.partition { |hero| hero['gender'] == 'male' }
# limit users => 15
males = males.sample(MAX_MALES)
females = females.sample(MAX_FEMALES)

def set_email(hero)
  "#{hero['name'].parameterize.underscore}@starwars.com"
end

def set_url(gender)
  gender == 'male' ? DEFAULT_MALE_IMAGE_URL : DEFAULT_FEMALE_IMAGE_URL
end

def create_avatar(user, gender, url = nil)
  url = set_url(gender) if url.nil?
  downloaded_image = URI.parse(url).open rescue nil # check bad image URL: "corde@starwars.com" - 404
  if downloaded_image.nil?
    downloaded_image = URI.parse(set_url(gender)).open rescue nil
  end
  return if downloaded_image.nil?

  user.avatar.attach(io: downloaded_image, filename: "#{SecureRandom.uuid}_image")
end

def create_reply(comment, commentable, max, counter)
  return if counter > (max - 1)

  body = rand(1..3).odd? ? Faker::TvShows::Community.quotes : STUPID_COMMENTS.sample
  reply = comment.comments.new(commentable: commentable,
                                   user_id: User.all.sample.id,
                                   body: body)
  # set max depth
  if comment&.nesting.blank? || comment&.nesting < Comment.max_nesting
    reply.parent_id = comment&.id
    reply.nesting = reply.set_nesting
  else
    reply.parent_id = comment&.parent_id
    reply.nesting = reply.set_nesting
  end
  reply.save
  faker_date = Faker::Date.between(from: commentable.created_at, to: Time.zone.now)
  reply.update!(created_at: faker_date,
                updated_at: faker_date + rand(1..12).hours + rand(1..59).minutes)
  print('.')
  counter += 1
  create_reply(reply, commentable, max, counter)
end

def create_user(hero)
  hero_email = set_email(hero)
  first_name_hero, *last_name_hero = hero['name'].split(' ')
  last_name_hero = last_name_hero.join(' ') if last_name_hero.is_a?(Array)
  user = User.create!(email: hero_email,
                      first_name: first_name_hero,
                      last_name: last_name_hero,
                      password: 'password')
  create_avatar(user, hero['gender'], hero['image'])
  print('.')
end

def prev_year_to_last_year
  prev_year               = Date.today.beginning_of_year - 1.days
  Faker::Date.between(from: prev_year.beginning_of_year, to: prev_year)
end

def last_year_to_last_month
  Faker::Date.between(from: Date.today.beginning_of_year, to: Date.today.beginning_of_month)
end

def last_month_to_last_week
  Faker::Date.between(from: Date.today.beginning_of_month, to: Date.today.beginning_of_week)
end

def last_week_to_last_day
  Faker::Date.between(from: Date.today.beginning_of_week, to: 1.days.ago)
end

def last_day
  Faker::Date.between(from: 1.days.ago, to: Time.zone.now)
end

def update_date(list, method_name_with_suffix)
  list.each do |post|
    period = self.send(method_name_with_suffix.delete_suffix("_posts").to_sym)
    post.update!(
      created_at: period,
      updated_at: period
    )
    print('.')
  end
end

def add_comments(posts, with_reply = nil)
  posts.each do |post|
    rand(1..3).times do
      parent_comment = post.comments.create!(user_id: User.all.sample.id,
                                             body: Faker::TvShows::Community.quotes)

      faker_parent_date = Faker::Date.between(from: post.created_at, to: Time.zone.now)
      parent_comment.update(nesting: 1,
                            created_at: faker_parent_date,
                            updated_at: faker_parent_date)
      unless with_reply.nil?
        max = rand(0..4)
        create_reply(parent_comment, post, max, 0)
      end
    end
  end
end

puts ''
# Create object!
print "Create users"
males.each   { |hero| create_user(hero) }
females.each { |hero| create_user(hero) }

puts ''
print "Create posts"
while Post.count < 100 do
  faker_title = Faker::Book.title
  next if Post.where(title: faker_title).any?

  Post.create!(title: faker_title,
               category: POST_CATEGORY.sample,
               content: Faker::Movies::StarWars.quote,
               status: Post.statuses.keys.sample,
               user: User.all.sample)
  print('.')
end

puts ''
print('Adding a fake date to posts')
posts = Post.all

prev_year_to_last_year_posts = posts.take(5)
update_date(prev_year_to_last_year_posts, 'prev_year_to_last_year_posts')

last_year_to_last_month_posts = (posts - prev_year_to_last_year_posts).take(60)
update_date(last_year_to_last_month_posts, 'last_year_to_last_month_posts')

last_month_to_last_week_posts = (posts - (prev_year_to_last_year_posts + last_year_to_last_month_posts)).take(25)
update_date(last_month_to_last_week_posts, 'last_month_to_last_week_posts')

last_week_to_last_day_posts = (posts - (prev_year_to_last_year_posts + last_year_to_last_month_posts + last_month_to_last_week_posts)).take(7)
update_date(last_week_to_last_day_posts, 'last_week_to_last_day_posts')

last_day_posts = (posts - (prev_year_to_last_year_posts + last_year_to_last_month_posts + last_month_to_last_week_posts + last_week_to_last_day_posts))
update_date(last_day_posts, 'last_day_posts')

puts ''
print "Create comments"
posts = Post.all
# comments with reply
posts_with_reply = posts.sample(40) # Post.take(20)
add_comments(posts_with_reply, 'with_reply')
# comments without reply
posts_with_comments = (posts - posts_with_reply).sample(50)
add_comments(posts_with_comments)

puts ''
print "Create likes"
while Like.count < 70 do
  user = User.all.sample
  post = Post.all.sample
  next if Like.where(user: user, post: post).any?

  Like.create!(user_id: user.id,
               post_id: post.id)
  print('.')
end

puts ''
puts '=' * 51 + '  All Ok! ' + '=' * 51
puts "Created #{User.count} users!"
puts "Created #{Post.count} posts!"
puts "Created #{Comment.count} comments (#{Comment.where(parent_id: nil).count} - parent)!"
puts "Created #{Like.count} likes!"
