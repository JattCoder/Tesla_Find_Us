require 'capybara/dsl'
require 'bundler/setup'
require 'shotgun'
require 'sinatra'
require 'pry'
require 'nokogiri'
require 'httparty'
require 'geocoder'
require_relative '../controller/tesla_controller.rb'
require_relative '../models/geo.rb'
require_relative '../models/scrapper.rb'