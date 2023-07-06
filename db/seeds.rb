# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.create!(email: "user1@example.com")
User.create!(email: "user2@example.com")
User.create!(email: "approver@example.com")

Expense.create!(reason: "trip1", date: 1.days.ago.to_date, amount: 100, submitter_id: 1)
Expense.create!(reason: "trip1", date: 3.days.ago.to_date, amount: 55, submitter_id: 2)

Report.create!(approver_id: 3, expense_id: 1, status: "approved", submitter_id: 1)
Report.create!(approver_id: 3, expense_id: 2, status: "rejected", submitter_id: 2)