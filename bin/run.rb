require_relative '../config/environment'

 CLI.new.run

# class API_test
#     response_string = RestClient.get('http://www.omdbapi.com/?apikey=cb986e0d&s=lion+king') 
#     response_hash = JSON.parse(response_string)
#     binding.pry
# end
