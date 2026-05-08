% ============================================
% MUSIC RECOMMENDATION SYSTEM - CORE RULES
% File: music_recommender_fixed.pl
% Developer: Core Rules Developer (Filtering Logic)
% Version: 2.0 - Production Ready
% ============================================

% ============================================
% SECTION 1: DATABASE FACTS
% ============================================

% song(song_id, title, artist, language, year)
% English Songs
song(1, 'Blinding Lights', 'The Weeknd', english, 2019).
song(2, 'Levitating', 'Dua Lipa', english, 2020).
song(3, 'Shape of You', 'Ed Sheeran', english, 2017).
song(4, 'Happier Than Ever', 'Billie Eilish', english, 2021).
song(5, 'As It Was', 'Harry Styles', english, 2022).
song(6, 'Flowers', 'Miley Cyrus', english, 2023).
song(7, 'Dance Monkey', 'Tones and I', english, 2019).
song(8, 'Bad Guy', 'Billie Eilish', english, 2019).
song(9, 'Uptown Funk', 'Mark Ronson ft. Bruno Mars', english, 2014).
song(10, 'Shake It Off', 'Taylor Swift', english, 2014).
song(11, 'Bohemian Rhapsody', 'Queen', english, 1975).
song(12, 'Stairway to Heaven', 'Led Zeppelin', english, 1971).
song(13, 'Smells Like Teen Spirit', 'Nirvana', english, 1991).
song(14, 'Hotel California', 'Eagles', english, 1977).
song(15, 'Back in Black', 'AC/DC', english, 1980).
song(16, 'Imagine', 'John Lennon', english, 1971).
song(17, 'Hey Jude', 'The Beatles', english, 1968).
song(18, 'Wonderwall', 'Oasis', english, 1995).
song(19, 'Rolling in the Deep', 'Adele', english, 2010).
song(20, 'Someone Like You', 'Adele', english, 2011).
song(21, 'Lose Yourself', 'Eminem', english, 2002).
song(22, 'God\'s Plan', 'Drake', english, 2018).
song(23, 'Sicko Mode', 'Travis Scott', english, 2018).
song(24, 'Old Town Road', 'Lil Nas X', english, 2019).
song(25, 'HUMBLE', 'Kendrick Lamar', english, 2017).
song(26, 'Juice', 'Lizzo', english, 2019).
song(27, 'Hotline Bling', 'Drake', english, 2015).
song(28, 'Rockstar', 'Post Malone', english, 2017).
song(29, 'The Box', 'Roddy Ricch', english, 2019).
song(30, 'Savage', 'Megan Thee Stallion', english, 2020).

% Hindi Songs
song(101, 'Apna Bana Le', 'Arijit Singh', hindi, 2023).
song(102, 'Kesariya', 'Arijit Singh', hindi, 2022).
song(103, 'Pasoori', 'Shae Gill, Ali Sethi', hindi, 2022).
song(104, 'Rasiya', 'Shreya Ghoshal', hindi, 2023).
song(105, 'Maan Meri Jaan', 'King', hindi, 2022).
song(106, 'Brown Rang', 'Yo Yo Honey Singh', hindi, 2012).
song(107, 'Lungi Dance', 'Yo Yo Honey Singh', hindi, 2013).
song(108, 'The Punjaabban', 'Gippy Grewal', hindi, 2011).
song(109, 'Channa Mereya', 'Arijit Singh', hindi, 2016).
song(110, 'Ae Dil Hai Mushkil', 'Arijit Singh', hindi, 2016).
song(111, 'Tum Hi Ho', 'Arijit Singh', hindi, 2013).
song(112, 'Kabira', 'Arijit Singh, Harshdeep Kaur', hindi, 2013).
song(113, 'Gerua', 'Arijit Singh, Antara Mitra', hindi, 2015).
song(114, 'Sanam Re', 'Mithoon, Arijit Singh', hindi, 2016).
song(115, 'Hawayein', 'Arijit Singh', hindi, 2017).
song(116, 'Tera Ban Jaunga', 'Akhil Sachdeva, Tulsi Kumar', hindi, 2019).
song(117, 'Dil Diyan Gallan', 'Atif Aslam', hindi, 2017).
song(118, 'Kaun Tujhe', 'Palak Muchhal', hindi, 2015).
song(119, 'Main Dhadkan', 'Arijit Singh', hindi, 2021).
song(120, 'Muskurane', 'Arijit Singh', hindi, 2014).
song(121, 'Badtameez Dil', 'Benny Dayal', hindi, 2013).
song(122, 'Kala Chashma', 'Badshah, Neha Kakkar', hindi, 2016).
song(123, 'The Hook Up Song', 'Neha Kakkar', hindi, 2019).
song(124, 'Ghungroo', 'Arijit Singh', hindi, 2019).
song(125, 'Morni Banke', 'Badshah, Neha Kakkar', hindi, 2019).
song(126, 'Naach Meri Jaan', 'Benny Dayal', hindi, 2023).
song(127, 'What Jhumka?', 'Arijit Singh, Jonita Gandhi', hindi, 2023).
song(128, 'Show Me The Thumka', 'Sunidhi Chauhan', hindi, 2023).
song(129, 'Milegi Milegi', 'Mika Singh', hindi, 2012).
song(130, 'Subha Hone Na De', 'Mika Singh', hindi, 2013).
song(131, 'Jab Tak', 'Arijit Singh', hindi, 2017).
song(132, 'Agar Tum Saath Ho', 'Arijit Singh', hindi, 2016).
song(133, 'Kalank', 'Arijit Singh', hindi, 2019).
song(134, 'Shayad', 'Arijit Singh', hindi, 2021).
song(135, 'Mere Liye Tum Kaafi Ho', 'Shayad', hindi, 2019).
song(136, 'Ranjha', 'Jasleen Royal', hindi, 2021).
song(137, 'Tujhe Kitna Chahne Lage', 'Arijit Singh', hindi, 2020).
song(138, 'Phir Na Aisi Raat', 'Arijit Singh', hindi, 2019).
song(139, 'Naina Da Kya Kasoor', 'Arijit Singh', hindi, 2018).
song(140, 'Bolna', 'Arijit Singh', hindi, 2017).

% Punjabi Songs
song(201, 'Brown Munde', 'AP Dhillon', punjabi, 2020).
song(202, 'G.O.A.T.', 'Diljit Dosanjh', punjabi, 2020).
song(203, 'Excuses', 'AP Dhillon', punjabi, 2021).
song(204, 'Insane', 'AP Dhillon', punjabi, 2021).
song(205, 'Ma Belle', 'AP Dhillon', punjabi, 2021).
song(206, 'Summer High', 'AP Dhillon', punjabi, 2022).
song(207, 'With You', 'AP Dhillon', punjabi, 2022).
song(208, 'Dil Galti Kar Baitha', 'Jass Manak', punjabi, 2021).
song(209, 'P.O.V.', 'Diljit Dosanjh', punjabi, 2020).
song(210, 'Lemonade', 'Diljit Dosanjh', punjabi, 2020).
song(211, 'Proper Patola', 'Diljit Dosanjh', punjabi, 2013).
song(212, 'Laembadgini', 'Diljit Dosanjh', punjabi, 2014).
song(213, 'Jind Mahi', 'Diljit Dosanjh', punjabi, 2014).
song(214, '5 Taara', 'Diljit Dosanjh', punjabi, 2017).
song(215, 'Clash', 'Diljit Dosanjh', punjabi, 2017).
song(216, 'Ikk Kudi', 'Diljit Dosanjh', punjabi, 2016).
song(217, 'Do You Know', 'Diljit Dosanjh', punjabi, 2016).
song(218, 'High Rated Gabru', 'Guru Randhawa', punjabi, 2015).
song(219, 'Patola', 'Guru Randhawa', punjabi, 2016).
song(220, 'Suit Suit', 'Guru Randhawa', punjabi, 2017).
song(221, 'Pehle Lalkare Naal', 'Ammy Virk', punjabi, 2017).
song(222, 'Soch', 'Diljit Dosanjh', punjabi, 2014).
song(223, 'Photograph', 'Ammy Virk', punjabi, 2018).
song(224, 'Naina', 'Ammy Virk', punjabi, 2020).
song(225, 'Viah', 'Ammy Virk', punjabi, 2019).
song(226, 'Titliyan', 'Gurlej Akhtar', punjabi, 2019).
song(227, 'Bheega Mann', 'Ammy Virk', punjabi, 2021).
song(228, 'Mera Deewanapan', 'Ammy Virk', punjabi, 2020).
song(229, 'Waalian', 'Ammy Virk', punjabi, 2019).
song(230, 'Pagal Nahi Hona', 'Sunanda Sharma', punjabi, 2020).

% ============================================
% MOOD DATA
% ============================================
% English moods
mood(1, energetic). mood(2, happy). mood(3, romantic). mood(4, sad).
mood(5, happy). mood(6, romantic). mood(7, energetic). mood(8, intense).
mood(9, happy). mood(10, happy). mood(11, epic). mood(12, epic).
mood(13, intense). mood(14, calm). mood(15, energetic). mood(16, calm).
mood(17, happy). mood(18, romantic). mood(19, intense). mood(20, sad).
mood(21, intense). mood(22, calm). mood(23, intense). mood(24, happy).
mood(25, intense). mood(26, happy). mood(27, romantic). mood(28, intense).
mood(29, intense). mood(30, intense).

% Hindi moods
mood(101, romantic). mood(102, romantic). mood(103, sad). mood(104, romantic).
mood(105, romantic). mood(106, energetic). mood(107, energetic). mood(108, energetic).
mood(109, sad). mood(110, romantic). mood(111, romantic). mood(112, romantic).
mood(113, romantic). mood(114, romantic). mood(115, romantic). mood(116, romantic).
mood(117, romantic). mood(118, romantic). mood(119, romantic). mood(120, romantic).
mood(121, energetic). mood(122, energetic). mood(123, energetic). mood(124, energetic).
mood(125, energetic). mood(126, energetic). mood(127, energetic). mood(128, energetic).
mood(129, energetic). mood(130, energetic). mood(131, sad). mood(132, sad).
mood(133, sad). mood(134, sad). mood(135, romantic). mood(136, romantic).
mood(137, romantic). mood(138, sad). mood(139, romantic). mood(140, romantic).

% Punjabi moods
mood(201, energetic). mood(202, energetic). mood(203, romantic). mood(204, intense).
mood(205, romantic). mood(206, happy). mood(207, romantic). mood(208, sad).
mood(209, romantic). mood(210, happy). mood(211, energetic). mood(212, energetic).
mood(213, romantic). mood(214, energetic). mood(215, intense). mood(216, sad).
mood(217, romantic). mood(218, energetic). mood(219, happy). mood(220, happy).
mood(221, sad). mood(222, sad). mood(223, sad). mood(224, sad).
mood(225, romantic). mood(226, romantic). mood(227, sad). mood(228, sad).
mood(229, romantic). mood(230, sad).

% ============================================
% GENRE DATA
% ============================================
% English genres
genre(1, pop). genre(2, pop). genre(3, pop). genre(4, pop). genre(5, pop).
genre(6, pop). genre(7, pop). genre(8, pop). genre(9, funk). genre(10, pop).
genre(11, rock). genre(12, rock). genre(13, grunge). genre(14, classic_rock).
genre(15, hard_rock). genre(16, classic_rock). genre(17, classic_rock).
genre(18, britpop). genre(19, soul). genre(20, ballad).
genre(21, hiphop). genre(22, hiphop). genre(23, trap). genre(24, country_rap).
genre(25, hiphop). genre(26, hiphop). genre(27, rnb). genre(28, trap).
genre(29, trap). genre(30, hiphop).

% Hindi genres
genre(101, bollywood). genre(102, bollywood). genre(103, pop). genre(104, folk).
genre(105, pop). genre(106, pop). genre(107, dance). genre(108, bhangra).
genre(109, bollywood). genre(110, bollywood). genre(111, bollywood).
genre(112, bollywood). genre(113, bollywood). genre(114, bollywood).
genre(115, bollywood). genre(116, bollywood). genre(117, bollywood).
genre(118, bollywood). genre(119, bollywood). genre(120, bollywood).
genre(121, dance). genre(122, dance). genre(123, dance). genre(124, dance).
genre(125, dance). genre(126, dance). genre(127, dance). genre(128, dance).
genre(129, dance). genre(130, dance). genre(131, classical). genre(132, classical).
genre(133, classical). genre(134, classical). genre(135, classical).
genre(136, folk). genre(137, classical). genre(138, classical).
genre(139, classical). genre(140, classical).

% Punjabi genres
genre(201, pop). genre(202, hiphop). genre(203, pop). genre(204, trap).
genre(205, pop). genre(206, pop). genre(207, pop). genre(208, sad).
genre(209, hiphop). genre(210, trap). genre(211, bhangra). genre(212, bhangra).
genre(213, folk). genre(214, bhangra). genre(215, hiphop). genre(216, sad).
genre(217, pop). genre(218, pop). genre(219, pop). genre(220, pop).
genre(221, sad). genre(222, sad). genre(223, sad). genre(224, sad).
genre(225, romantic). genre(226, romantic). genre(227, sad). genre(228, sad).
genre(229, romantic). genre(230, sad).

% ============================================
% TEMPO DATA
% ============================================
tempo(1, fast). tempo(2, fast). tempo(3, medium). tempo(4, slow).
tempo(5, medium). tempo(6, medium). tempo(7, fast). tempo(8, medium).
tempo(9, fast). tempo(10, fast). tempo(11, medium). tempo(12, slow).
tempo(13, fast). tempo(14, slow). tempo(15, fast). tempo(16, slow).
tempo(17, medium). tempo(18, medium). tempo(19, medium). tempo(20, slow).
tempo(21, fast). tempo(22, medium). tempo(23, fast). tempo(24, fast).
tempo(25, fast). tempo(26, fast). tempo(27, medium). tempo(28, fast).
tempo(29, medium). tempo(30, fast).
tempo(101, slow). tempo(102, medium). tempo(103, medium). tempo(104, slow).
tempo(105, medium). tempo(106, fast). tempo(107, fast). tempo(108, fast).
tempo(109, slow). tempo(110, slow). tempo(111, slow). tempo(112, slow).
tempo(113, slow). tempo(114, slow). tempo(115, slow). tempo(116, slow).
tempo(117, slow). tempo(118, slow). tempo(119, slow). tempo(120, slow).
tempo(121, fast). tempo(122, fast). tempo(123, fast). tempo(124, fast).
tempo(125, fast). tempo(126, fast). tempo(127, fast). tempo(128, fast).
tempo(129, fast). tempo(130, fast). tempo(131, slow). tempo(132, slow).
tempo(133, slow). tempo(134, slow). tempo(135, slow). tempo(136, slow).
tempo(137, slow). tempo(138, slow). tempo(139, slow). tempo(140, slow).
tempo(201, fast). tempo(202, fast). tempo(203, medium). tempo(204, fast).
tempo(205, medium). tempo(206, fast). tempo(207, medium). tempo(208, slow).
tempo(209, medium). tempo(210, fast). tempo(211, fast). tempo(212, fast).
tempo(213, slow). tempo(214, fast). tempo(215, fast). tempo(216, slow).
tempo(217, medium). tempo(218, fast). tempo(219, fast). tempo(220, fast).
tempo(221, slow). tempo(222, slow). tempo(223, slow). tempo(224, slow).
tempo(225, slow). tempo(226, medium). tempo(227, slow). tempo(228, slow).
tempo(229, slow). tempo(230, slow).

% ============================================
% ENERGY DATA
% ============================================
energy(1, high). energy(2, high). energy(3, medium). energy(4, low).
energy(5, medium). energy(6, medium). energy(7, high). energy(8, high).
energy(9, high). energy(10, high). energy(11, medium). energy(12, low).
energy(13, high). energy(14, low). energy(15, high). energy(16, low).
energy(17, medium). energy(18, medium). energy(19, high). energy(20, low).
energy(21, high). energy(22, medium). energy(23, high). energy(24, high).
energy(25, high). energy(26, high). energy(27, medium). energy(28, high).
energy(29, high). energy(30, high).
energy(101, low). energy(102, medium). energy(103, medium). energy(104, low).
energy(105, medium). energy(106, high). energy(107, high). energy(108, high).
energy(109, low). energy(110, low). energy(111, low). energy(112, low).
energy(113, low). energy(114, low). energy(115, low). energy(116, low).
energy(117, low). energy(118, low). energy(119, low). energy(120, low).
energy(121, high). energy(122, high). energy(123, high). energy(124, high).
energy(125, high). energy(126, high). energy(127, high). energy(128, high).
energy(129, high). energy(130, high). energy(131, low). energy(132, low).
energy(133, low). energy(134, low). energy(135, low). energy(136, low).
energy(137, low). energy(138, low). energy(139, low). energy(140, low).
energy(201, high). energy(202, high). energy(203, medium). energy(204, high).
energy(205, medium). energy(206, high). energy(207, medium). energy(208, low).
energy(209, medium). energy(210, high). energy(211, high). energy(212, high).
energy(213, low). energy(214, high). energy(215, high). energy(216, low).
energy(217, medium). energy(218, high). energy(219, high). energy(220, high).
energy(221, low). energy(222, low). energy(223, low). energy(224, low).
energy(225, low). energy(226, medium). energy(227, low). energy(228, low).
energy(229, low). energy(230, low).

% ============================================
% LANGUAGE DATA
% ============================================
language(1, english). language(2, english). language(3, english).
language(4, english). language(5, english). language(6, english).
language(7, english). language(8, english). language(9, english).
language(10, english). language(11, english). language(12, english).
language(13, english). language(14, english). language(15, english).
language(16, english). language(17, english). language(18, english).
language(19, english). language(20, english). language(21, english).
language(22, english). language(23, english). language(24, english).
language(25, english). language(26, english). language(27, english).
language(28, english). language(29, english). language(30, english).
language(101, hindi). language(102, hindi). language(103, hindi).
language(104, hindi). language(105, hindi). language(106, hindi).
language(107, hindi). language(108, hindi). language(109, hindi).
language(110, hindi). language(111, hindi). language(112, hindi).
language(113, hindi). language(114, hindi). language(115, hindi).
language(116, hindi). language(117, hindi). language(118, hindi).
language(119, hindi). language(120, hindi). language(121, hindi).
language(122, hindi). language(123, hindi). language(124, hindi).
language(125, hindi). language(126, hindi). language(127, hindi).
language(128, hindi). language(129, hindi). language(130, hindi).
language(131, hindi). language(132, hindi). language(133, hindi).
language(134, hindi). language(135, hindi). language(136, hindi).
language(137, hindi). language(138, hindi). language(139, hindi).
language(140, hindi).
language(201, punjabi). language(202, punjabi). language(203, punjabi).
language(204, punjabi). language(205, punjabi). language(206, punjabi).
language(207, punjabi). language(208, punjabi). language(209, punjabi).
language(210, punjabi). language(211, punjabi). language(212, punjabi).
language(213, punjabi). language(214, punjabi). language(215, punjabi).
language(216, punjabi). language(217, punjabi). language(218, punjabi).
language(219, punjabi). language(220, punjabi). language(221, punjabi).
language(222, punjabi). language(223, punjabi). language(224, punjabi).
language(225, punjabi). language(226, punjabi). language(227, punjabi).
language(228, punjabi). language(229, punjabi). language(230, punjabi).

% ============================================
% DISPLAY UTILITIES
% ============================================

% Simple display without special characters
display_recommendations([]).
display_recommendations([[Title, Artist]|Rest]) :-
    write('  - '), write(Title), write(' by '), write(Artist), nl,
    display_recommendations(Rest).

% Numbered display
display_numbered([]).
display_numbered([[Title, Artist]|Rest]) :-
    display_numbered(Rest, 1).

display_numbered([], _).
display_numbered([[Title, Artist]|Rest], N) :-
    write(N), write('. '), write(Title), write(' by '), write(Artist), nl,
    N1 is N + 1,
    display_numbered(Rest, N1).

% ============================================
% BASIC RECOMMENDATIONS
% ============================================

% Recommend by mood
recommend_by_mood(Mood) :-
    findall([Title, Artist], (
        song(SongID, Title, Artist, _, _),
        mood(SongID, Mood)
    ), Songs),
    Songs \= [],
    format('~n=== ~w SONGS (~w songs) ===~n', [Mood, length(Songs)]),
    display_numbered(Songs).
recommend_by_mood(Mood) :-
    format('~nNo songs found with mood: ~w~n', [Mood]).

% Recommend by genre
recommend_by_genre(Genre) :-
    findall([Title, Artist], (
        song(SongID, Title, Artist, _, _),
        genre(SongID, Genre)
    ), Songs),
    Songs \= [],
    format('~n=== ~w GENRE (~w songs) ===~n', [Genre, length(Songs)]),
    display_numbered(Songs).
recommend_by_genre(Genre) :-
    format('~nNo songs found with genre: ~w~n', [Genre]).

% ============================================
% MULTI-ATTRIBUTE RECOMMENDATIONS (Most Specific to Generic)
% ============================================

% Most specific: Mood + Genre + Energy
recommend(Mood, Genre, Energy, Recommendations) :-
    findall([Title, Artist], (
        song(SongID, Title, Artist, _, _),
        mood(SongID, Mood),
        genre(SongID, Genre),
        energy(SongID, Energy)
    ), Recommendations),
    Recommendations \= [],
    format('~n[Level 1] Found ~w songs: ~w + ~w + ~w~n', 
           [length(Recommendations), Mood, Genre, Energy]).

% Less specific: Mood + Genre
recommend(Mood, Genre, Recommendations) :-
    findall([Title, Artist], (
        song(SongID, Title, Artist, _, _),
        mood(SongID, Mood),
        genre(SongID, Genre)
    ), Recommendations),
    Recommendations \= [],
    format('~n[Level 2] Found ~w songs: ~w + ~w~n', 
           [length(Recommendations), Mood, Genre]).

% Less specific: Genre + Energy
recommend(Genre, Energy, Recommendations) :-
    findall([Title, Artist], (
        song(SongID, Title, Artist, _, _),
        genre(SongID, Genre),
        energy(SongID, Energy)
    ), Recommendations),
    Recommendations \= [],
    format('~n[Level 3] Found ~w songs: ~w + ~w~n', 
           [length(Recommendations), Genre, Energy]).

% Generic: Mood only
recommend(Mood, Recommendations) :-
    findall([Title, Artist], (
        song(SongID, Title, Artist, _, _),
        mood(SongID, Mood)
    ), Recommendations),
    Recommendations \= [],
    format('~n[Level 4] Found ~w songs with mood: ~w~n', 
           [length(Recommendations), Mood]).

% Fallback: All songs
recommend(Recommendations) :-
    findall([Title, Artist], song(_, Title, Artist, _, _), Recommendations),
    format('~n[Level 5] Showing all ~w songs~n', [length(Recommendations)]).

% ============================================
% CONVENIENCE WRAPPERS
% ============================================

% Show recommendations with auto-display
show(Mood, Genre, Energy) :-
    recommend(Mood, Genre, Energy, Results),
    display_numbered(Results).
show(Mood, Genre) :-
    recommend(Mood, Genre, Results),
    display_numbered(Results).
show(Mood) :-
    recommend(Mood, Results),
    display_numbered(Results).

% Smart recommendation that tries multiple levels
smart_recommend(Mood, Genre, Energy) :-
    ( recommend(Mood, Genre, Energy, Results) ->
        display_numbered(Results)
    ; recommend(Mood, Genre, Results) ->
        display_numbered(Results)
    ; recommend(Genre, Energy, Results) ->
        display_numbered(Results)
    ; recommend(Mood, Results) ->
        display_numbered(Results)
    ; recommend(Results) ->
        display_numbered(Results)
    ).

% ============================================
% RECURSIVE RULES
% ============================================

% Collect songs from multiple moods
collect_moods([], []).
collect_moods([Mood|Rest], AllSongs) :-
    findall([Title, Artist], (
        song(SongID, Title, Artist, _, _),
        mood(SongID, Mood)
    ), SongsForMood),
    collect_moods(Rest, RemainingSongs),
    append(SongsForMood, RemainingSongs, AllSongs).

% Show collected moods
show_moods(MoodList) :-
    collect_moods(MoodList, AllSongs),
    format('~n=== Songs from moods: ~w ===~n', [MoodList]),
    display_numbered(AllSongs).

% ============================================
% LANGUAGE SPECIFIC
% ============================================

% Recommend by language
recommend_by_language(Language) :-
    findall([Title, Artist], song(_, Title, Artist, Language, _), Songs),
    format('~n=== ~w SONGS (~w songs) ===~n', [Language, length(Songs)]),
    display_numbered(Songs).

% Recommend by language and mood
recommend_by_language_mood(Language, Mood) :-
    findall([Title, Artist], (
        song(SongID, Title, Artist, Language, _),
        mood(SongID, Mood)
    ), Songs),
    format('~n=== ~w ~w SONGS (~w songs) ===~n', [Language, Mood, length(Songs)]),
    display_numbered(Songs).

% ============================================
% TEST QUERIES
% ============================================

% Quick test function
test_all :-
    format('~n========== TESTING MUSIC RECOMMENDER ==========~n', []),
    recommend_by_mood(romantic),
    recommend_by_genre(pop),
    show(energetic, pop, high),
    show_moods([happy, energetic]),
    recommend_by_language(hindi),
    format('~n========== TEST COMPLETE ==========~n', []).

% End of file
:- write('========================================'), nl.
:- write('Music Recommender System Loaded Successfully!'), nl.
:- write('Total Songs: 230'), nl.
:- write('Languages: English, Hindi, Punjabi'), nl.
:- write('========================================'), nl.
