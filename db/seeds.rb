# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Load the FactoryBot factories
require 'factory_bot'
# Dir[Rails.root.join('spec/factories/**/*.rb')].each { |f| require f }

# Create some users using the FactoryBot factories
user1 = FactoryBot.create(:user, name: 'John Doe', email: 'john@example.com', password: 'password')
user2 = FactoryBot.create(:user, name: 'Jane Smith', email: 'user@example.com', password: '123456')

# Create accounts using the FactoryBot factories
FactoryBot.create(:account, name: 'Bank', kind: 'savings', user: user1)
account1 = FactoryBot.create(:account, name: 'Bank', kind: 'savings', user: user2)
account2 = FactoryBot.create(:account, name: 'Broker', kind: 'broker', user: user2)
account3 = FactoryBot.create(:account, name: 'Card', kind: 'card', user: user2)

# Create some categories
FactoryBot.create_list(:category, 5, user: user2)

# Create some current account reports using the FactoryBot factories
FactoryBot.create(:account_report, account: account1)
FactoryBot.create(:account_report, account: account2)
FactoryBot.create(:account_report, account: account3)

# Create some past account reports using the FactoryBot factories
FactoryBot.create(:account_report, account: account1, date: Time.zone.today - 1.month)
FactoryBot.create(:account_report, account: account2, date: Time.zone.today - 1.month)
FactoryBot.create(:account_report, account: account3, date: Time.zone.today - 1.month)
FactoryBot.create(:account_report, account: account1, date: Time.zone.today - 2.months)
FactoryBot.create(:account_report, account: account2, date: Time.zone.today - 2.months)
FactoryBot.create(:account_report, account: account3, date: Time.zone.today - 2.months)
FactoryBot.create(:account_report, account: account1, date: Time.zone.today - 3.months)
FactoryBot.create(:account_report, account: account2, date: Time.zone.today - 3.months)
FactoryBot.create(:account_report, account: account3, date: Time.zone.today - 3.months)

# Create some future account reports using the FactoryBot factories
FactoryBot.create(:account_report, account: account1, date: Time.zone.today + 1.month)
FactoryBot.create(:account_report, account: account2, date: Time.zone.today + 1.month)
FactoryBot.create(:account_report, account: account3, date: Time.zone.today + 1.month)
FactoryBot.create(:account_report, account: account1, date: Time.zone.today + 2.months)
FactoryBot.create(:account_report, account: account2, date: Time.zone.today + 2.months)
FactoryBot.create(:account_report, account: account3, date: Time.zone.today + 2.months)
FactoryBot.create(:account_report, account: account1, date: Time.zone.today + 3.months)
FactoryBot.create(:account_report, account: account2, date: Time.zone.today + 3.months)
FactoryBot.create(:account_report, account: account3, date: Time.zone.today + 3.months)

# Create some transferences
FactoryBot.create(:transference, sender: account1, receiver: account2, user: user2)
FactoryBot.create(:transference, sender: account2, receiver: account3, user: user2)
FactoryBot.create(:transference, sender: account1, receiver: account2, user: user2, date: Time.zone.today + 1.month)
FactoryBot.create(:transference, sender: account2, receiver: account3, user: user2, date: Time.zone.today + 1.month)

# Create some stocks using the FactoryBot factories
stock1 = FactoryBot.create(:stock, account: account2)
stock2 = FactoryBot.create(:stock, account: account2)

# Create some negotiations using the FactoryBot factories
FactoryBot.create(:negotiation, negotiable_type: stock1.class, negotiable_id: stock1.id, date: Time.zone.today)
FactoryBot.create(:negotiation, negotiable_type: stock1.class, negotiable_id: stock1.id, date: Time.zone.today - 1.month)
FactoryBot.create(:negotiation, negotiable_type: stock1.class, negotiable_id: stock1.id, date: Time.zone.today - 2.months)
FactoryBot.create(:negotiation, negotiable_type: stock2.class, negotiable_id: stock2.id, date: Time.zone.today)
FactoryBot.create(:negotiation, negotiable_type: stock2.class, negotiable_id: stock2.id, date: Time.zone.today - 1.month)
FactoryBot.create(:negotiation, negotiable_type: stock2.class, negotiable_id: stock2.id, date: Time.zone.today - 2.months)

# Create some prices using the FactoryBot factories
FactoryBot.create(:price, priceable_type: stock1.class, priceable_id: stock1.id, date: Time.zone.today)
FactoryBot.create(:price, priceable_type: stock1.class, priceable_id: stock1.id, date: Time.zone.today - 1.month)
FactoryBot.create(:price, priceable_type: stock1.class, priceable_id: stock1.id, date: Time.zone.today - 2.months)
FactoryBot.create(:price, priceable_type: stock2.class, priceable_id: stock2.id, date: Time.zone.today)
FactoryBot.create(:price, priceable_type: stock2.class, priceable_id: stock2.id, date: Time.zone.today - 1.month)
FactoryBot.create(:price, priceable_type: stock2.class, priceable_id: stock2.id, date: Time.zone.today - 2.months)

# Create some dividends using the FactoryBot factories
FactoryBot.create(:dividend, stock: stock1, date: Time.zone.today)
FactoryBot.create(:dividend, stock: stock1, date: Time.zone.today - 1.month)
FactoryBot.create(:dividend, stock: stock1, date: Time.zone.today - 2.months)
FactoryBot.create(:dividend, stock: stock1, date: Time.zone.today - 3.months)
FactoryBot.create(:dividend, stock: stock2, date: Time.zone.today)
FactoryBot.create(:dividend, stock: stock2, date: Time.zone.today - 1.month)
FactoryBot.create(:dividend, stock: stock2, date: Time.zone.today - 2.months)
FactoryBot.create(:dividend, stock: stock2, date: Time.zone.today - 3.months)

# Create some treasuries using the FactoryBot factories
treasury1 = FactoryBot.create(:treasury, account: account2)
treasury2 = FactoryBot.create(:treasury, account: account2)

# Create some negotiations using the FactoryBot factories
FactoryBot.create(:negotiation, negotiable_type: treasury1.class, negotiable_id: treasury1.id, date: Time.zone.today)
FactoryBot.create(:negotiation, negotiable_type: treasury1.class, negotiable_id: treasury1.id, date: Time.zone.today - 1.month)
FactoryBot.create(:negotiation, negotiable_type: treasury1.class, negotiable_id: treasury1.id, date: Time.zone.today - 2.months)
FactoryBot.create(:negotiation, negotiable_type: treasury2.class, negotiable_id: treasury2.id, date: Time.zone.today)
FactoryBot.create(:negotiation, negotiable_type: treasury2.class, negotiable_id: treasury2.id, date: Time.zone.today - 1.month)
FactoryBot.create(:negotiation, negotiable_type: treasury2.class, negotiable_id: treasury2.id, date: Time.zone.today - 2.months)

# Create some prices using the FactoryBot factories
FactoryBot.create(:price, priceable_type: treasury1.class, priceable_id: treasury1.id, date: Time.zone.today)
FactoryBot.create(:price, priceable_type: treasury1.class, priceable_id: treasury1.id, date: Time.zone.today - 1.month)
FactoryBot.create(:price, priceable_type: treasury1.class, priceable_id: treasury1.id, date: Time.zone.today - 2.months)
FactoryBot.create(:price, priceable_type: treasury2.class, priceable_id: treasury2.id, date: Time.zone.today)
FactoryBot.create(:price, priceable_type: treasury2.class, priceable_id: treasury2.id, date: Time.zone.today - 1.month)
FactoryBot.create(:price, priceable_type: treasury2.class, priceable_id: treasury2.id, date: Time.zone.today - 2.months)

# Create 5 transactions in the past and 5 in the future for every account
5.times do |i|
  FactoryBot.create(:transaction, account: account1, date: Time.zone.today - (i + 1).months)
  FactoryBot.create(:transaction, account: account1, date: Time.zone.today + (i + 1).months)

  FactoryBot.create(:transaction, account: account2, date: Time.zone.today - (i + 1).months)
  FactoryBot.create(:transaction, account: account2, date: Time.zone.today + (i + 1).months)

  FactoryBot.create(:transaction, account: account3, date: Time.zone.today - (i + 1).months)
  FactoryBot.create(:transaction, account: account3, date: Time.zone.today + (i + 1).months)
end

# Create financings for every user
financing1 = FactoryBot.create(:financing, user: user1)
financing2 = FactoryBot.create(:financing, user: user2)

# Create 5 ordinary payments for every financing
5.times do |i|
  FactoryBot.create(:payment, financing: financing1, payment_date: Time.zone.today - (i + 1).months)

  FactoryBot.create(:payment, financing: financing2, payment_date: Time.zone.today + (i + 1).months)
end

  # Create 5 non-ordinary payments for each financing
5.times do |i|
  FactoryBot.create(:payment, :non_ordinary, financing: financing1, payment_date: Time.zone.today - (i + 1).months)
  FactoryBot.create(:payment, :non_ordinary, financing: financing2, payment_date: Time.zone.today - (i + 1).months)
end
