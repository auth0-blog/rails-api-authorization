# Expense Report Managing API in Ruby Rails

This repository contains an Expense Report Managing API in Ruby on Rails. 

To get context about the use cases of this API you can read more in the blog post: [What is the Right Authorization Model for my Application?](https://auth0.com/blog/whats-the-right-authorization-model-for-my-application/#Using-Roles)

You can use this repository as a starting point before following the instructions in the following blog posts:

- branch: [`add-rbac`](https://github.com/auth0-blog/rails-api-authorization/tree/add-rbac) has the code for the implementation explained in the blog post [What is Role-Based Access Control and How to Implement it in my Rails API?](https://auth0.com/blog/what-is-rbac-and-how-to-implement-it-rails-api). 


# Requirements

- [Ruby Version Manager (RVM)](https://rvm.io/)  
- Ruby 3.1.2 
- Rails 7.0.6

# To run this application

1. Clone the repo with the following command:

  ```bash
  git clone git@github.com:auth0-blog/rails-api-authorization.git
  ```

2. Setup the database 

  ```
  rails db:setup
  ```

3. Run the Expense Management API:

  ```bash
  rails s
  ```
