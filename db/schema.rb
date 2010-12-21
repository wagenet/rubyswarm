# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101221171439) do

  create_table "client_runs", :force => true do |t|
    t.integer  "run_id"
    t.integer  "client_id"
    t.integer  "status"
    t.integer  "fail"
    t.integer  "error"
    t.integer  "total"
    t.text     "results"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_runs", ["client_id"], :name => "index_client_runs_on_client_id"
  add_index "client_runs", ["run_id"], :name => "index_client_runs_on_run_id"

  create_table "clients", :force => true do |t|
    t.integer  "user_id"
    t.integer  "useragent_id"
    t.string   "os"
    t.text     "useragentstr"
    t.string   "ip"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clients", ["user_id"], :name => "index_clients_on_user_id"
  add_index "clients", ["useragent_id"], :name => "index_clients_on_useragent_id"

  create_table "jobs", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "browsers"
    t.text     "suites"
  end

  add_index "jobs", ["user_id"], :name => "index_jobs_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "runs", :force => true do |t|
    t.integer  "job_id"
    t.string   "name"
    t.text     "url"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "browsers"
  end

  add_index "runs", ["job_id"], :name => "index_runs_on_job_id"

  create_table "useragent_runs", :force => true do |t|
    t.integer  "run_id"
    t.integer  "useragent_id"
    t.integer  "runs"
    t.integer  "max"
    t.integer  "completed"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "useragent_runs", ["run_id"], :name => "index_useragent_runs_on_run_id"
  add_index "useragent_runs", ["useragent_id"], :name => "index_useragent_runs_on_useragent_id"

  create_table "useragents", :force => true do |t|
    t.string   "name"
    t.string   "engine"
    t.string   "version"
    t.boolean  "active"
    t.boolean  "current"
    t.boolean  "popular"
    t.boolean  "gbs"
    t.boolean  "beta"
    t.boolean  "mobile"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "authentication_token"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
