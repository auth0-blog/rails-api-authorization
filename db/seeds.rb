# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create!(email: "user1@example.com", auth0_id: "auth0|4jfbsdkjfdks")
User.create!(email: "user2@example.com", auth0_id: "auth0|4jfbsdkjfdksss")
User.create!(email: "approver@example.com", auth0_id: "auth0|678e303eb50bf06889c5ba6a")

OpenfgaService.update_relation("user:3", "manager", "user:1")
OpenfgaService.update_relation("user:3", "manager", "user:2")
User.find(1).update!(manager_id: 3)
User.find(2).update!(manager_id: 3)

Expense.create!(reason: "trip1", date: 1.days.ago.to_date, amount: 100, submitter_id: 1)
Expense.create!(reason: "trip1", date: 3.days.ago.to_date, amount: 55, submitter_id: 2)

OpenfgaService.update_relation("user:1", "submitter", "report:1")
OpenfgaService.update_relation("user:2", "submitter", "report:2")

Report.create!(approver_id: 3, expense_id: 1, status: "approved", submitter_id: 1)
Report.create!(approver_id: 3, expense_id: 2, status: "rejected", submitter_id: 2)