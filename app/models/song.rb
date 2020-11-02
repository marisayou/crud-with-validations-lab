class Song < ApplicationRecord
    validates :title, presence: true
    validate :unique_titles_by_same_artist
    validates :released, inclusion: { in: [true, false] }
    validate :release_year_is_valid
    validates :artist_name, presence: true


    def unique_titles_by_same_artist
        non_unique_songs = self.class.all.select {|song| song.artist_name == self.artist_name && song.release_year == self.release_year && song.title == self.title}
        if non_unique_songs.length != 0
            errors.add(:title, "same song title by same artists realeased in the same year already exists")
        end
    end

    def release_year_is_valid
        if self.released 
            if !self.release_year
                errors.add(:release_year, "must have a release year")
            elsif !self.release_year.is_a?(Integer)
                errors.add(:release_year, "release year must be an integer")
            elsif self.release_year > Time.now.year
                errors.add(:release_year, "release year must be less than or equal to current year")
            end
        end
    end

end
