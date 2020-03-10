ENV['SINATRA_ENV'] ||= "development"
require 'capybara/dsl'
require 'bundler/setup'
require 'ostruct'
require 'date'

Bundler.require(:default, ENV['SINATRA_ENV'])

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
)

require 'shotgun'
require 'sinatra'
require 'pry'
require 'nokogiri'
require 'httparty'
require 'geocoder'
require_relative '../controller/tesla_controller.rb'
require_relative '../models/geo.rb'
require_relative '../models/location.rb'
require_relative '../models/route_planner.rb'