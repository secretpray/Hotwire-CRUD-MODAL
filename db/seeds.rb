require 'open-uri'
require 'faraday'
require 'json'

Post.destroy_all
User.destroy_all

# https://randomuser.me/api/portraits/women/49.jpg
# https://randomuser.me/api/portraits/men/43.jpg
# <div class="posts-index-img d-inline">
#   <img class="avatar-index rounded-circle mx-auto" src="<%= "/images/default_user.png " %>" alt="Userimage">

# Star Wars
# response = Faraday.get('https://swapi.dev/api/people')
# or
# response = Faraday.get('https://akabab.github.io/starwars-api/api/all.json')
# data = JSON.parse(response.body)
# results = data['results']
# results.each {|hero| p hero['name'] }
# short, tall= results.partition { |hero| hero['height'].to_i < 160 }
# puts short.map { |hero| hero['name']}
# names = data.each {|hero| p hero['name'] }
# images = data.each {|hero| p hero['image'] }

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

puts 'Please wait while get seed data!'
admin = User.where(email: 'admin@mail.com', first_name: 'Aleksey', last_name: 'Reznov').first_or_initialize
admin.update(password: 'password') if admin.new_record?

# Star Wars heroes
response = Faraday.get('https://akabab.github.io/starwars-api/api/all.json')
data = JSON.parse(response.body)
# sleep 1
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

  user.avatar.attach(io: downloaded_image, filename: user.email)
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

print "Create posts."
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

puts "All Ok!"
puts "Created #{User.count} users!"
puts "Created #{Post.count} posts!"
