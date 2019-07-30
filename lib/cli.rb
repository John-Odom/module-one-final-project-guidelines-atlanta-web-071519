class CLI
    def run
        puts "==============="
        puts "Welcome to Movies on Command! Discover and rate any movies you watch.  Then you can reference this app to refresh your memory about the movie."
        puts "==============="
        username_to_screen
    end
    def username_to_screen
        puts "Enter your username.  If you don't have a username yet, type 0"
        @answer = gets.chomp
        if answer != 0
            User.find_by(username: @answer)
        else 
            puts " Please create a unique username.  If you aren't unique, we will make one for you... you can update this later"
        end
    end
#     def welcome
#         puts "Welcome, user's name, what would you like to do? just type the single letter"
#         puts "C - Create a new rating"
#         puts "R - Read through my ratings"
#         puts "U - Update any of my ratings"
#         puts "D - Destroy a rating"
#         puts "Y - See any other methods available"
#     end
#     def welcome_action
#         response = gets.chomp
#     end
# end

#     greet


    puts "HELLO WORLD"
end