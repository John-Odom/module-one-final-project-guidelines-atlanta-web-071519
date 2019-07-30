class CLI
    def run
        @prompt = TTY::Prompt.new
        puts "\n\n==============="
        puts "Welcome to Movies on Command! Discover and rate any movies you watch or are interested in."
        puts "==============="
        # sleep 3
        while true
            main_menu
        end
    end

    def main_menu
        choices = ["Login/signup", "Read a Review", "Write a Review", "Update a Review", "Exit"]
        choice = @prompt.enum_select("Please select one of the following:", choices)
        if choice == "Login/signup"
            login
        elsif choice == "Read a Review"
            read_review
        elsif choice == "Write a Review"
            write_review
        elsif choice == "Update a Review"
            update_review
        elsif choice == "Exit"
            exit
        end
    end




    def login
        puts "What's your name?"
        name = gets.chomp
        @user = User.find_or_create_by(name: name)
    end

    def read_review
        choices = []
        Review.all.each do |review|
            movie = Movie.find_by(id: review.movie_id)
            choices << "#{movie.title}"
        end
        choice = @prompt.enum_select("Please select a movie to read its reviews:", choices)
        # selection = gets.chomp
        movie_selected = Movie.find_by(title: choice)
        review = Review.find_by(movie_id: movie_selected.id)
            puts "rating: #{review.rating}/5"
            puts "notes: #{review.notes}"
            sleep 5
    end
end