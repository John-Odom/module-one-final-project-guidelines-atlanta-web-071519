class CLI
    attr_reader :user
    def run
        @prompt = TTY::Prompt.new
        @font = TTY::Font.new(:standard)
        @pastel = Pastel.new
        puts "\n\n==============="
        puts @pastel.yellow.on_blue(@font.write("Movies  on  Command"))
        puts "==============="
        `afplay ~/Downloads/welcome.mp3`
        puts "Welcome to Movies on Command, where we can read and write reviews of our favorite movies!"
        puts "==============="
        while true
            main_menu
        end
    end
    def main_menu
        choices = ["Login/SignUp", "Read a Review", "Write a Review", "Update or Delete a Review", "Delete Account", "Exit"]
        #prompt user to choose an option.  choice is then equal to their selection
        choice = @prompt.enum_select("Please select one of the following:", choices)
        if choice == "Login/SignUp"
            login
        elsif choice == "Read a Review"
            read_review
        elsif choice == "Write a Review"
            write_review
        elsif choice == "Update or Delete a Review"
            update_review
        elsif choice == "Delete Account"
            delete_account
        elsif choice == "Exit"
            puts @pastel.yellow.on_blue(@font.write("Goodbye!!"))
            `afplay ~/Downloads/tadaah.mp3`
            exit
        end
    end
    def login
        choice = @prompt.enum_select("Please select one of the following:", ["Login", "Sign-Up"])
            if choice == "Login"
                puts @pastel.yellow.bold("What's Your Name?")
                name = gets.chomp
                if User.find_by(name: name)
                @user = User.find_by(name: name)
                puts @pastel.yellow.bold("Welcome Back, #{name}! \n")
                else puts @pastel.yellow.bold "You're not yet a member of Movies on Command! Please Sign-Up."
                    sleep 2
                end
            elsif choice == "Sign-Up"
                name = nil
                puts @pastel.yellow.bold "Welcome to Movies on Command! Please enter a name:"
                #While the name is not in the user table, run the following loop:
                until User.find_by(name: name)
                    name = gets.chomp
                    #If name entered is equal to name in user table, reject the name.
                    if User.find_by(name: name)
                        puts "That name is already taken.  Please select a new login name."
                        name = nil
                    #If name is not in our user table, create a new instance.
                    else
                        puts @pastel.yellow.bold "Hi, #{name}! You are now logged in!" 
                        @user = User.find_or_create_by(name: name)
                        sleep 2
                    end
                end         
            end
    end
    def read_review
        choices = []
        Review.all.each do |review|
            # set movie = to id equal to review id in the movie table.
            movie = Movie.find_by(id: review.movie_id)
            # set user = to id of review's user id in the User table.
            user = User.find_by(id: review.user_id)
            #append the movie's title into our choices array.
            #binding.pry
            choices << "#{movie.title}"
        end
        #choice is eqaul to the decision of the user to the prompt's question. display the choices in abc order and limit 1
        choice = @prompt.enum_select(@pastel.yellow.bold("Please select a movie to read its reviews:"), choices.uniq.sort)
        # movie_selected = the movie instance where title is equal to our chosen movie
        movie_selected = Movie.find_by(title: choice)
        # review instance is equal to going into our review table and finding the movie_id thats equal to our movie selected's id.
        review = Review.where(movie_id: movie_selected.id)
        # loop over the reviews and return information of all reviews on the selected movie.
        review.each do |r|
            person = User.find_by(id: r.user_id)
            puts @pastel.yellow.bold.on_blue("\n#{person.name}'s review:")
            puts @pastel.yellow.bold.on_blue("Rating: #{r.rating}/5")
            puts @pastel.yellow.bold.on_blue("Notes: #{r.notes}")   
            puts
        end
        #Prompt users if they would like to view the movie trailer of the review they read.
        to_youtube = @prompt.enum_select(@pastel.yellow.bold("Would you like to watch a trailer?"), ["Yes", "No"])
        #If they select yes, open youtube with query.
        if to_youtube == "Yes"
            parsed_movie_selected = movie_selected.title.split.join("+")
            `open 'https://www.youtube.com/results?search_query=#{parsed_movie_selected}'`
            return
        else
            return
        end
        return
    end
    def write_review
        if @user
            puts @pastel.yellow.bold "What's the name of the movie that you would like to write a review about?"
            movie_title = gets.chomp
            x = Movie.find_or_create_by(title: movie_title)
            if Review.find_by(movie_id: x.id, user_id: self.user.id)
                puts "You have already reviewed this movie; you can update the review instead."
                sleep 2
                return
            else
                choices = ["Hated it!!", "Wouldn't Recommend", "It was Mediocre", "Pretty Good", "Loved it!", "Cancel to Main Menu"]
                choice = @prompt.enum_select("On a scale of 1 to 5, what would you rate #{movie_title}?", choices)
                if choice == "Hated it!!"
                    movie_rating = 1
                elsif choice == "Wouldn't Recommend"
                    movie_rating = 2
                elsif choice == "It was Mediocre"
                    movie_rating = 3
                elsif choice == "Pretty Good"
                    movie_rating = 4
                elsif choice == "Loved it!"
                    movie_rating = 5
                elsif choice == "Cancel to Main Menu"
                    puts "Returning to main menu"
                    sleep 2
                    return
                end
                puts @pastel.yellow.bold "What notes do you have about #{movie_title}?"
                movie_notes = gets.chomp
                movie = Movie.find_or_create_by(title: movie_title)
                review = Review.create(user_id: self.user.id, movie_id: movie.id, rating: movie_rating, notes: movie_notes)
            end    
        else 
            puts @pastel.yellow.bold "\n\nYou must be logged in to write a review. Please log in or sign up."
            `afplay ~/Downloads/Denied.mp3`
            sleep 1
        end
    end
    def update_review
        choices = []
        if @user
            if Review.find_by(user_id: self.user.id)
                users_reviews = Review.where(user_id: self.user.id)
                users_reviews.each do |review|
                    user_movie = Movie.find_by(id: review.movie_id)
                    choices << "#{user_movie.title}"
                end
                choice = @prompt.enum_select(@pastel.yellow.bold("Here's a list of movies that you have reviewed. Which one would you like to update/delete?"), choices.sort)
                chosen_movie = Movie.find_by(title: choice)
                next_choice = @prompt.enum_select("Would you like to update or delete?", ["Update", "Delete", "Cancel"])
                if next_choice == "Update"
                    chosen_review = Review.where(movie_id: chosen_movie.id, user_id: self.user.id)
                    chosen_review = chosen_review[0]
                    puts @pastel.yellow.bold.on_blue "You originally rated this movie a #{chosen_review.rating}/5. What is your updated rating?"
                    puts "note - you can rate it the same if you just want to update your notes."
                    new_rating = gets.chomp
                    puts "\nbelow are the notes:\n"
                    puts "#{chosen_review.notes}"
                    selection = @prompt.enum_select("Would you like to overwrite or append to your notes?", ["Overwrite", "Append to", "Cancel"])
                    if selection == "Overwrite"
                        puts "What are your new notes for #{chosen_movie.title}"
                        new_notes = gets.chomp
                        chosen_review.update(notes: new_notes, rating: new_rating)
                    elsif selection == "Append to"
                        puts "What would you like to add to your notes?"
                        appended_notes = "... " + gets.chomp
                        final_notes = chosen_review.notes << appended_notes
                        chosen_review.update(notes: final_notes, rating: new_rating)
                    elsif selection == "Cancel"
                        puts "Returning to main menu"
                        sleep 2
                        main_menu
                    end
                elsif next_choice == "Delete"
                    delete_review = Review.where(movie_id: chosen_movie.id, user_id: self.user.id)[0]
                    delete_review.destroy
                    puts "Your review has been deleted"
                    sleep 2
                elsif next_choice == "Cancel"
                    puts "Returning to main menu"
                    sleep 2
                    return
                end
            else
                puts "\nYou do not have any reviews yet. You can create a review by selecting it from the main menu\n\n"
                sleep 2
                return
            end
        else 
            puts @pastel.yellow.bold "\n\nYou must be logged in to update your reviews. Please log in or sign up."
            `afplay ~/Downloads/Denied.mp3`
            sleep 1
        end
    end
    def delete_account
        if @user
            #`afplay ~/Downloads/give.mp4`
            choice = @prompt.enum_select("Are you sure you want to delete your account?", ["Yes", "No"])
            if choice == "Yes"
                deletion = User.find_by(id: self.user.id)
                deletion.destroy
                delete_reviews = Review.where(user_id: self.user.id)[0]
                if delete_reviews
                delete_reviews.destroy
                #`afplay ~/Downloads/bye_felicia.mp4`
                exit
                else
                    #`afplay ~/Downloads/bye_felicia.mp4`
                    exit
                end
            elsif choice == "No"
                return
            end
        else
        puts @pastel.yellow ("You are not currently logged in.  To delete your account, please log in.")
        sleep 2
        return
        end
    end
end



