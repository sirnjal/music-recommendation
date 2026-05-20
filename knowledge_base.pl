:- module(knowledge_base, [
    song/7
]).

/*
    =========================================================================
    MODULE: knowledge_base
    ROLE: The Knowledge Architect (Data & Facts)
    AUTHOR: Harikesh
    
    This module defines the database of songs and user preferences.
    Schema:
    - song(SongID, Title, Artist, Genre, Mood, ReleaseYear, Rating).
    - user_preference(UserID, LikedGenres, PreferredMoods).
    
    Note: Ratings have been updated from integers to float values (1.0 to 5.0)
    to facilitate realistic and precise threshold filtering.
    =========================================================================
*/

% --- SONGS ---

% ROCK
song(1, 'Bohemian Rhapsody', 'Queen', rock, energetic, 1975, 4.9).
song(2, 'Stairway to Heaven', 'Led Zeppelin', rock, relaxed, 1971, 4.8).
song(3, 'Hotel California', 'Eagles', rock, melancholy, 1976, 4.7).
song(4, 'Smells Like Teen Spirit', 'Nirvana', rock, energetic, 1991, 4.6).
song(5, 'Sweet Child O Mine', 'Guns N Roses', rock, happy, 1987, 4.4).
song(6, 'Back in Black', 'AC/DC', rock, energetic, 1980, 4.7).
song(7, 'Wonderwall', 'Oasis', rock, relaxed, 1995, 4.1).
song(8, 'Creep', 'Radiohead', rock, melancholy, 1992, 4.2).
song(9, 'Fix You', 'Coldplay', rock, melancholy, 2005, 4.6).
song(10, 'Paradise', 'Coldplay', rock, happy, 2011, 4.3).

% POP
song(11, 'Shape of You', 'Ed Sheeran', pop, happy, 2017, 4.5).
song(12, 'Blinding Lights', 'The Weeknd', pop, energetic, 2020, 4.9).
song(13, 'Bad Guy', 'Billie Eilish', pop, energetic, 2019, 4.3).
song(14, 'Love Story', 'Taylor Swift', pop, happy, 2008, 4.6).
song(15, 'Someone Like You', 'Adele', pop, melancholy, 2011, 4.8).
song(16, 'Roar', 'Katy Perry', pop, energetic, 2013, 4.0).
song(17, 'Levitating', 'Dua Lipa', pop, happy, 2020, 4.2).
song(18, 'Senorita', 'Shawn Mendes', pop, relaxed, 2019, 4.1).
song(19, 'Peaches', 'Justin Bieber', pop, relaxed, 2021, 3.8).
song(20, 'Shake It Off', 'Taylor Swift', pop, happy, 2014, 4.3).

% CLASSICAL
song(21, 'Symphony No 5', 'Beethoven', classical, energetic, 1808, 4.9).
song(22, 'Canon in D', 'Pachelbel', classical, relaxed, 1680, 4.7).
song(23, 'The Four Seasons', 'Vivaldi', classical, happy, 1725, 4.8).
song(24, 'Clair de Lune', 'Debussy', classical, relaxed, 1905, 4.9).
song(25, 'Moonlight Sonata', 'Beethoven', classical, melancholy, 1801, 4.8).
song(26, 'Requiem', 'Mozart', classical, melancholy, 1791, 4.7).
song(27, 'Swan Lake', 'Tchaikovsky', classical, relaxed, 1876, 4.6).
song(28, 'Nocturne Op 9', 'Chopin', classical, relaxed, 1832, 4.8).
song(29, 'Hungarian Rhapsody', 'Liszt', classical, energetic, 1847, 4.4).
song(30, 'Bolero', 'Ravel', classical, energetic, 1928, 4.2).

% MORE MIXED SONGS
song(31, 'Believer', 'Imagine Dragons', rock, energetic, 2017, 4.6).
song(32, 'Radioactive', 'Imagine Dragons', rock, energetic, 2012, 4.5).
song(33, 'Counting Stars', 'OneRepublic', pop, happy, 2013, 4.1).
song(34, 'Stay', 'Rihanna', pop, melancholy, 2012, 4.2).
song(35, 'Happier', 'Marshmello', pop, melancholy, 2018, 4.0).
song(36, 'Perfect', 'Ed Sheeran', pop, relaxed, 2017, 4.8).
song(37, 'Thunder', 'Imagine Dragons', rock, energetic, 2017, 3.9).
song(38, 'Viva La Vida', 'Coldplay', rock, happy, 2008, 4.7).
song(39, 'Yellow', 'Coldplay', rock, relaxed, 2000, 4.7).
song(40, 'Let Her Go', 'Passenger', pop, melancholy, 2012, 4.3).

song(41, 'Counting Blue Cars', 'Dishwalla', rock, relaxed, 1996, 3.5).
song(42, 'Numb', 'Linkin Park', rock, melancholy, 2003, 4.8).
song(43, 'In The End', 'Linkin Park', rock, energetic, 2000, 4.9).
song(44, 'Faded', 'Alan Walker', pop, melancholy, 2015, 4.4).
song(45, 'Alone', 'Alan Walker', pop, energetic, 2016, 4.2).
song(46, 'Darkside', 'Alan Walker', pop, energetic, 2018, 4.1).
song(47, 'Memories', 'Maroon 5', pop, melancholy, 2019, 4.0).
song(48, 'Sugar', 'Maroon 5', pop, happy, 2015, 4.3).
song(49, 'Girls Like You', 'Maroon 5', pop, relaxed, 2018, 4.2).
song(50, 'Animals', 'Maroon 5', pop, energetic, 2014, 4.1).

% RAP & HIP HOP
song(51, 'Lose Yourself', 'Eminem', rap, energetic, 2002, 4.9).
song(52, 'Gods Plan', 'Drake', rap, relaxed, 2018, 4.5).
song(53, 'Humble', 'Kendrick Lamar', rap, energetic, 2017, 4.7).
song(54, 'Sicko Mode', 'Travis Scott', rap, energetic, 2018, 4.4).
song(55, 'Juicy', 'Notorious B.I.G.', rap, happy, 1994, 4.8).

% BLUES
song(56, 'The Thrill Is Gone', 'B.B. King', blues, melancholy, 1969, 4.7).
song(57, 'Hoochie Coochie Man', 'Muddy Waters', blues, energetic, 1954, 4.5).
song(58, 'Texas Flood', 'Stevie Ray Vaughan', blues, energetic, 1983, 4.6).
song(59, 'Cross Road Blues', 'Robert Johnson', blues, melancholy, 1936, 4.4).
song(60, 'Stormy Monday', 'T-Bone Walker', blues, melancholy, 1947, 4.3).

% INDIAN POP & BOLLYWOOD
song(61, 'Kesariya', 'Arijit Singh', pop, romantic, 2022, 4.8).
song(62, 'Tum Hi Ho', 'Arijit Singh', pop, melancholy, 2013, 4.9).
song(63, 'Channa Mereya', 'Arijit Singh', pop, melancholy, 2016, 4.8).
song(64, 'Raabta', 'Arijit Singh', pop, romantic, 2012, 4.2).
song(65, 'Agar Tum Saath Ho', 'Alka Yagnik', pop, melancholy, 2015, 4.7).

song(66, 'Jai Ho', 'A.R. Rahman', pop, energetic, 2008, 4.6).
song(67, 'Kun Faya Kun', 'A.R. Rahman', classical, relaxed, 2011, 4.9).
song(68, 'Luka Chuppi', 'A.R. Rahman', classical, melancholy, 2006, 4.8).

song(69, 'Galliyan', 'Ankit Tiwari', rock, melancholy, 2014, 4.3).
song(70, 'Bulleya', 'Amit Mishra', rock, energetic, 2016, 4.4).

song(71, 'Ilahi', 'Arijit Singh', pop, happy, 2013, 4.2).
song(72, 'Zinda', 'Siddharth Mahadevan', rock, energetic, 2013, 4.7).
song(73, 'Kar Har Maidan Fateh', 'Sukhwinder Singh', rock, energetic, 2018, 4.8).

song(74, 'Kabira', 'Tochi Raina', classical, relaxed, 2013, 4.6).
song(75, 'Mohe Rang Do Laal', 'Shreya Ghoshal', classical, relaxed, 2015, 4.5).

song(76, 'Apna Time Aayega', 'Ranveer Singh', rap, energetic, 2019, 4.5).
song(77, 'Mere Gully Mein', 'DIVINE', rap, energetic, 2019, 4.4).

song(78, 'Tera Ban Jaunga', 'Akhil Sachdeva', pop, romantic, 2019, 4.1).
song(79, 'Raatan Lambiyan', 'Jubin Nautiyal', pop, romantic, 2021, 4.6).
song(80, 'Shayad', 'Arijit Singh', pop, melancholy, 2020, 4.3).



