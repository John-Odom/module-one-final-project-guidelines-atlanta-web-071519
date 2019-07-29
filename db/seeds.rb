User.destroy_all
Review.destroy_all
Movie.destroy_all

pretty_woman = Movie.create(title: "Pretty Woman")
king_kong = Movie.create(title: "King Kong")
casablanca = Movie.create(title: "Casablanca")
lion_king = Movie.create(title: "Lion King")
jaws = Movie.create(title: "Jaws")


courtney = User.create(name: "Courtney")
john = User.create(name: "John")
curtis = User.create(name: "Curtis")
raza = User.create(name: "Raza")
brit = User.create(name: "Brit")

courtney_review = Review.create(user_id: courtney.id, movie_id: pretty_woman.id, rating: 5, notes: "This is Courtney's favorite movie.")
john_review = Review.create(user_id: john.id, movie_id: casablanca.id, rating: 3, notes: "John hasn't seen it, but Courtney has...")
curtis_review = Review.create(user_id: curtis.id, movie_id: jaws.id, rating: 5, notes: "Curtis loves sharks!!!")
raza_review = Review.create(user_id: raza.id, movie_id: king_kong.id, rating: 4, notes: "Raza enjoyed the movie.")
brit_review = Review.create(user_id: brit.id, movie_id: lion_king.id, rating: 2, notes: "Brit didn't like the part Simba defeats Scar. he was pulling for scar the whole time!")