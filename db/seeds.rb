# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Load the FactoryBot factories
require 'factory_bot'
# Dir[Rails.root.join('spec/factories/**/*.rb')].each { |f| require f }

# Create some users using the FactoryBot factories
user1 = FactoryBot.create(:user, name: 'John Doe', email: 'john@example.com', password: 'password')
user2 = FactoryBot.create(:user, name: 'Jane Smith', email: 'user2@test.com', password: 123456)

# Create accounts using the FactoryBot factories
FactoryBot.create(:account, name: 'Bank', kind: 'savings', user: user1)
account1 = FactoryBot.create(:account, name: 'Bank', kind: 'savings', user: user2)
account2 = FactoryBot.create(:account, name: 'Broker', kind: 'broker', user: user2)
account3 = FactoryBot.create(:account, name: 'Card', kind: 'card', user: user2)

#Create some categories
FactoryBot.create_list(:category, 5, user: user2)

# Create some current account reports using the FactoryBot factories
FactoryBot.create(:account_report, account: account1)
FactoryBot.create(:account_report, account: account2)
FactoryBot.create(:account_report, account: account3)

# Create some past account reports using the FactoryBot factories
FactoryBot.create(:account_report, account: account1, date: Date.today - 1.month)
FactoryBot.create(:account_report, account: account2, date: Date.today - 1.month)
FactoryBot.create(:account_report, account: account3, date: Date.today - 1.month)
FactoryBot.create(:account_report, account: account1, date: Date.today - 2.month)
FactoryBot.create(:account_report, account: account2, date: Date.today - 2.month)
FactoryBot.create(:account_report, account: account3, date: Date.today - 2.month)
FactoryBot.create(:account_report, account: account1, date: Date.today - 3.month)
FactoryBot.create(:account_report, account: account2, date: Date.today - 3.month)
FactoryBot.create(:account_report, account: account3, date: Date.today - 3.month)

# Create some future account reports using the FactoryBot factories
FactoryBot.create(:account_report, account: account1, date: Date.today + 1.month)
FactoryBot.create(:account_report, account: account2, date: Date.today + 1.month)
FactoryBot.create(:account_report, account: account3, date: Date.today + 1.month)
FactoryBot.create(:account_report, account: account1, date: Date.today + 2.month)
FactoryBot.create(:account_report, account: account2, date: Date.today + 2.month)
FactoryBot.create(:account_report, account: account3, date: Date.today + 2.month)
FactoryBot.create(:account_report, account: account1, date: Date.today + 3.month)
FactoryBot.create(:account_report, account: account2, date: Date.today + 3.month)
FactoryBot.create(:account_report, account: account3, date: Date.today + 3.month)

# Create some transferences
FactoryBot.create(:transference, sender: account1, receiver: account2, user: user2)
FactoryBot.create(:transference, sender: account2, receiver: account3, user: user2)

# Create some stocks using the FactoryBot factories
stock1 = FactoryBot.create(:stock, account: account2)
stock2 = FactoryBot.create(:stock, account: account2)

# Create some negotiations using the FactoryBot factories
FactoryBot.create(:negotiation, negotiable_type: "Investments::Stock::Stock", negotiable_id: stock1.id, date: Date.today)
FactoryBot.create(:negotiation, negotiable_type: "Investments::Stock::Stock", negotiable_id: stock1.id, date: Date.today - 1.month)
FactoryBot.create(:negotiation, negotiable_type: "Investments::Stock::Stock", negotiable_id: stock1.id, date: Date.today - 2.month)
FactoryBot.create(:negotiation, negotiable_type: "Investments::Stock::Stock", negotiable_id: stock2.id, date: Date.today)
FactoryBot.create(:negotiation, negotiable_type: "Investments::Stock::Stock", negotiable_id: stock2.id, date: Date.today - 1.month)
FactoryBot.create(:negotiation, negotiable_type: "Investments::Stock::Stock", negotiable_id: stock2.id, date: Date.today - 2.month)

# Create some prices using the FactoryBot factories
FactoryBot.create(:price, priceable_type: "Investments::Stock::Stock", priceable_id: stock1.id, date: Date.today)
FactoryBot.create(:price, priceable_type: "Investments::Stock::Stock", priceable_id: stock1.id, date: Date.today - 1.month)
FactoryBot.create(:price, priceable_type: "Investments::Stock::Stock", priceable_id: stock1.id, date: Date.today - 2.months)
FactoryBot.create(:price, priceable_type: "Investments::Stock::Stock", priceable_id: stock2.id, date: Date.today)
FactoryBot.create(:price, priceable_type: "Investments::Stock::Stock", priceable_id: stock2.id, date: Date.today - 1.month)
FactoryBot.create(:price, priceable_type: "Investments::Stock::Stock", priceable_id: stock2.id, date: Date.today - 2.months)

# Create some dividends using the FactoryBot factories
FactoryBot.create(:dividend, stock: stock1, date: Date.today)
FactoryBot.create(:dividend, stock: stock1, date: Date.today - 1.month)
FactoryBot.create(:dividend, stock: stock1, date: Date.today - 2.month)
FactoryBot.create(:dividend, stock: stock1, date: Date.today - 3.month)
FactoryBot.create(:dividend, stock: stock2, date: Date.today)
FactoryBot.create(:dividend, stock: stock2, date: Date.today - 1.month)
FactoryBot.create(:dividend, stock: stock2, date: Date.today - 2.month)
FactoryBot.create(:dividend, stock: stock2, date: Date.today - 3.month)
