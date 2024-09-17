# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Place.create(name: "Mahatma Cafe&Restoran", longitude: 29.02888969999999, latitude: 40.9970429, address: "Prof.Dr, MahatmaCafe&Restoran, Macit Erbudak Sokak, Kadıköy/İstanbul, Türkiye", vegan: 1, instagram_handle: "https://www.instagram.com/mahatmaacafe/", facebook_handle: "https://www.facebook.com/MahatmaCafe", x_handle: "", web_url: "", email: "", phone: "5356083280")
# Place.create(name: "Ethique Plant Based", longitude: 29.0555725, latitude: 40.9898886, address: "Göztepe, Ethique Plant-Based, Volkan Sokak, Kadıköy/İstanbul, Türkiye", vegan: 1, instagram_handle: "https://www.instagram.com/ethiqueplantbased/", facebook_handle: "https://www.facebook.com/ethiqueplantbased", x_handle: "https://x.com/ETHIQUE_PB", web_url: "ethiqueplantbased.com", email: "merhaba@ethiqueplantbased.com", phone: "5354459566")
# Place.create(name: "Vegan a la Turca", longitude: 27.4369168, latitude: 37.0396094, address: "Umurça, Veganalaturca, Cevat Şakir Caddesi, Bodrum/Muğla, Türkiye", vegan: 1, instagram_handle: "https://www.instagram.com/veganalaturca/", facebook_handle: "https://www.facebook.com/profile.php?id=100063635350631", x_handle: "", web_url: "", email: "", phone: "5303543909")
# Place.create(name: "Bodrum Botanicals Health Shop and Cafe", longitude: 27.3853935, latitude: 37.0478096, address: "Konacık, Bodrum Botanicals Health Shop and Cafe, Mithat Paşa Sk., Bodrum/Muğla, Türkiye", vegan: 1, instagram_handle: "https://www.instagram.com/bodrumbotanicals", facebook_handle: "https://www.facebook.com/people/Bodrum-Botanicals/100027308873734/?paipv=0&eav=AfZcusNn0KTWFgNtJcc3GypMbf-zU9t9E-LLi8Mg2_o2msKhabYdptyeuRZOpvjwOD4&_rdr", x_handle: "", web_url: "", email: "", phone: "5320506188")
# Place.create(name: "gibi vegan", longitude: 27.10095, latitude: 38.4599024, address: "Bostanlı, gibi vegan, Şehitler Bulvarı, Karşıyaka/İzmir, Türkiye", vegan: 1, instagram_handle: "https://www.instagram.com/gibivegan/", facebook_handle: "", x_handle: "", web_url: "", email: "", phone: "")
# Place.create(name: "Tahin Moda", longitude: 29.02597479999999, latitude: 40.9856966, address: "Caferağa, Tahin Restoran Moda, Dalga Sokak, Kadıköy/İstanbul, Türkiye", vegan: 0, instagram_handle: "https://www.instagram.com/tahintr/", facebook_handle: "https://www.facebook.com/tahinrestoran/", x_handle: "", web_url: "tahin.com.tr", email: "", phone: "2163458382")

Shop.find_or_create_by(name: "Migros")
Shop.find_or_create_by(name: "Carrefour")
Shop.find_or_create_by(name: "Şok")
Shop.find_or_create_by(name: "Bim")
Shop.find_or_create_by(name: "A101")
Shop.find_or_create_by(name: "Metro")
Shop.find_or_create_by(name: "Macro Center")

Brand.find_or_create_by(name: "Vappy")
Brand.find_or_create_by(name: "Veggy")
Brand.find_or_create_by(name: "Alpro")
Brand.find_or_create_by(name: "Trakya Çiftliği")

food = ProductCategory.create!(name_en: "Food", name_tr: "Yiyecek")
drink = ProductCategory.create!(name_en: "Drink", name_tr: "İçecek")
personal_care = ProductCategory.create!(name_en: "Personal Care", name_tr: "Kişisel Bakım")
home_care = ProductCategory.create!(name_en: "Home Care", name_tr: "Ev Bakım")
cloth = ProductCategory.create!(name_en: "Cloth", name_tr: "Kıyafet")

milk = ProductSubCategory.create!(name_en: "Milk", name_tr: "Süt", product_category: drink)
cheese = ProductSubCategory.create!(name_en: "Cheese", name_tr: "Peynir", product_category: food)
yogurt = ProductSubCategory.create!(name_en: "Yogurt", name_tr: "Yoğurt", product_category: food)
ice_cream = ProductSubCategory.create!(name_en: "Ice Cream", name_tr: "Dondurma", product_category: food)
shampoo = ProductSubCategory.create!(name_en: "Shampoo", name_tr: "Şampuan", product_category: personal_care)
toothpaste = ProductSubCategory.create!(name_en: "Toothpaste", name_tr: "Diş Macunu", product_category: personal_care)
detergent = ProductSubCategory.create!(name_en: "Detergent", name_tr: "Deterjan", product_category: home_care)
dish_soap = ProductSubCategory.create!(name_en: "Dish Soap", name_tr: "Bulaşık Deterjanı", product_category: home_care)
shoe = ProductSubCategory.create!(name_en: "Shoe", name_tr: "Ayakkabı", product_category: cloth)

puts "Seeds created successfully!"
