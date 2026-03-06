# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "Iniciando o semeio do banco de dados..."

# Cria o usuário Admin primordial do sistema
admin = User.find_or_create_by!(email: "admin@taskmaster.com") do |user|
  user.name = "Administrador Geral"
  user.password = "Admin@123456"
  user.password_confirmation = "Admin@123456"
  user.is_admin = true
end

puts "Usuário Admin garantido no banco de dados!"
puts "-------------------------------------------"
puts "Email: #{admin.email}"
puts "Senha: Admin@123456"
puts "-------------------------------------------"
