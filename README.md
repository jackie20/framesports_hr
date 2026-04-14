# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

*   1 RAILS_ENV=development
       2 SECRET_KEY_BASE=dev_secret_key_base_change_this_in_production_32chars_minimum
       3
       4 # Database (SQL Server)
       5 DB_HOST=localhost
       6 DB_PORT=1433
       7 DB_NAME=eoms_development
       8 DB_USERNAME=sa
       9 DB_PASSWORD=YourStrongPassword123!
      10 AZURE_SQL=false
    


  Default Seed Accounts

  ┌───────────────────┬────────────────┬─────────────────────────────────┐
  │       Email       │    Password    │              Role               │
  ├───────────────────┼────────────────┼─────────────────────────────────┤
  │ admin@company.com │ Admin@12345!   │ Administrator (all permissions) │
  ├───────────────────┼────────────────┼─────────────────────────────────┤
  │ hr@company.com    │ HRManager@123! │ HR Manager                      │
  └───────────────────┴────────────────┴─────────────────────────────────┘

