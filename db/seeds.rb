# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Creating prompts..."

# 今日のお題
Prompt.find_or_create_by(date: Date.today) do |p|
  p.content = "Blue" # お題: 青
end

# 明日のお題
Prompt.find_or_create_by(date: Date.tomorrow) do |p|
  p.content = "Silence" # お題: 静寂
end

# 昨日のお題
Prompt.find_or_create_by(date: Date.yesterday) do |p|
  p.content = "Reflection" # お題: 反射
end

puts "Prompts created!"