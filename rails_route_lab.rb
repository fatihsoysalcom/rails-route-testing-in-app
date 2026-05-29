require 'rails' # Simulating Rails environment for demonstration

# Define a simple controller and action
class HomeController < ActionController::Base
  def index
    render plain: "Hello from Home Controller!"
  end

  def about
    render plain: "About Page"
  end
end

# Simulate Rails routing configuration
module ActionDispatch
  module Routing
    class RouteSet
      def initialize
        @routes = []
      end

      def draw(&block)
        mapper = Mapper.new(self)
        mapper.instance_eval(&block)
      end

      def add_route(path, controller, action)
        @routes << { path: path, controller: controller, action: action }
      end

      def recognize_path(path)
        @routes.find { |route| route[:path] == path }
      end

      class Mapper < BasicObject
        def initialize(route_set)
          @route_set = route_set
        end

        def get(path, to:)
          controller, action = to.split('#')
          @route_set.add_route(path, controller.camelize, action)
        end

        # Add other HTTP methods if needed (post, put, delete, etc.)
      end
    end
  end
end

# --- Rails HTTP Lab Simulation ---

# This is where you'd typically have your config/routes.rb content
# We're simulating it here for a single-file example.

# Initialize the router
$routes = ActionDispatch::Routing::RouteSet.new

# Define routes
$routes.draw do
  get '/', to: 'home#index'
  get '/about', to: 'home#about'
end

# --- Testing the routes directly ---

puts "--- Testing Routes ---"

# Test Case 1: Root path
path_to_test = '/'
puts "Testing path: #{path_to_test}"
route_info = $routes.recognize_path(path_to_test)

if route_info
  puts "  Matched Route: Controller=#{route_info[:controller]}, Action=#{route_info[:action]}"
  # In a real Rails app, you'd instantiate the controller and call the action
  # For this simulation, we just confirm the match.
  puts "  -> Success: Route recognized."
else
  puts "  -> Failure: Route not found."
end

puts "\n"

# Test Case 2: About path
path_to_test = '/about'
puts "Testing path: #{path_to_test}"
route_info = $routes.recognize_path(path_to_test)

if route_info
  puts "  Matched Route: Controller=#{route_info[:controller]}, Action=#{route_info[:action]}"
  puts "  -> Success: Route recognized."
else
  puts "  -> Failure: Route not found."
end

puts "\n"

# Test Case 3: Non-existent path
path_to_test = '/contact'
puts "Testing path: #{path_to_test}"
route_info = $routes.recognize_path(path_to_test)

if route_info
  puts "  Matched Route: Controller=#{route_info[:controller]}, Action=#{route_info[:action]}"
  puts "  -> Success: Route recognized."
else
  puts "  -> Failure: Route not found."
end

puts "\n--- End of Route Testing ---"
