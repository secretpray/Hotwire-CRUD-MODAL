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

puts 'Please wait while get seed data!'
admin = User.where(email: 'admin@mail.com', first_name: 'Aleksey', last_name: 'Reznov').first_or_initialize
admin.update(password: 'password') if admin.new_record?
# User.create!(email: 'a.p.ruban@gmail.com', first_name: 'Aleksander', last_name: 'Ruban', password: 'password')

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

print "Create users."
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
print "Create comments."
posts = Post.all.sample(20) # Post.take(20)

posts.each do |post|
  rand(2..4).times do
    parent_comment = post.comments.create!(user_id: User.all.sample.id,
                                           body: Faker::TvShows::Community.quotes)
    parent_comment.update(nesting: 1)
    max = rand(0..5)
    create_reply(parent_comment, post, max, 0)
  end
end

puts ''
print "Create likes"
while Like.count < 30 do
  user = User.all.sample
  post = Post.all.sample
  next if Like.where(user: user, post: post).any?

  Like.create!(user_id: user.id,
               post_id: post.id)
  print('.')
end

puts '----------------------------------------------------------------------------'
puts "All Ok!"
puts "Created #{User.count} users!"
puts "Created #{Post.count} posts!"
puts "Created #{Comment.count} comments (#{Comment.where(parent_id: nil).count} - parent)!"
puts "Created #{Like.count} likes!"
