require_relative '../config/environment'

CLI.new.run

# class API_test
#     response_string = RestClient.get('http://www.omdbapi.com/?apikey=cb986e0d&s=star+wars')
    
#     response_hash = JSON.parse(response_string)
#     response_hash.each do |key, value|
        
#         binding.pry
#     end
# end