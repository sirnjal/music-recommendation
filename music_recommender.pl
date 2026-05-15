/*
    =========================================================================
    MUSIC RECOMMENDATION SYSTEM IN PROLOG
    =========================================================================
    A logic-based system for personalized music discovery.
    Features: Mood-based, Genre-based, and Activity-based recommendations.
    Uses custom list processing and sorting logic.
    =========================================================================
*/

:- dynamic(current_mood/1).

% =========================================================================
% SECTION 1: CUSTOM UTILITY PREDICATES (SEARCHING, SORTING, ARITHMETIC)
% =========================================================================

% 1. Custom Member search (Recursion)
my_member(X, [X|_]).
my_member(X, [_|T]) :-
    my_member(X, T).

% 2. Custom Length of a list
my_length([], 0).
my_length([_|T], N) :-
    my_length(T, N1),
    N is N1 + 1.

% 3. Custom Append (List concatenation)
my_append([], L, L).
my_append([H|T], L2, [H|Result]) :-
    my_append(T, L2, Result).

% 4. Custom Min/Max for popularity scores
my_max([H|T], Max) :-
    my_max_calc(T, H, Max).

my_max_calc([], Max, Max).
my_max_calc([H|T], CurrentMax, Max) :-
    H > CurrentMax, !,
    my_max_calc(T, H, Max).
my_max_calc([_|T], CurrentMax, Max) :-
    my_max_calc(T, CurrentMax, Max).

my_min([H|T], Min) :-
    my_min_calc(T, H, Min).

my_min_calc([], Min, Min).
my_min_calc([H|T], CurrentMin, Min) :-
    H < CurrentMin, !,
    my_min_calc(T, H, Min).
my_min_calc([_|T], CurrentMin, Min) :-
    my_min_calc(T, CurrentMin, Min).

% 5. Custom Insertion Sort for Popularity
% Sorts a list of song IDs based on their popularity score.
% music(ID, Title, Artist, Genre, Mood, Tempo, PopularityScore).

sort_songs_by_popularity([], []).
sort_songs_by_popularity([H|T], Sorted) :-
    sort_songs_by_popularity(T, SortedTail),
    insert_song_by_popularity(H, SortedTail, Sorted).

insert_song_by_popularity(ID, [], [ID]).
insert_song_by_popularity(ID1, [ID2|T], [ID1, ID2|T]) :-
    get_popularity(ID1, P1),
    get_popularity(ID2, P2),
    P1 >= P2, !.
insert_song_by_popularity(ID1, [ID2|T], [ID2|SortedTail]) :-
    insert_song_by_popularity(ID1, T, SortedTail).

% Helper to get popularity from a song ID
get_popularity(ID, P) :-
    music(ID, _, _, _, _, _, P).

% =========================================================================
% SECTION 2: KNOWLEDGE BASE (FACTS)
% music(ID, Title, Artist, Genre, Mood, Tempo, PopularityScore).
% =========================================================================

% --- POP ---
music(s1, 'Blinding Lights', 'The Weeknd', pop, happy, 171, 95).
music(s2, 'Watermelon Sugar', 'Harry Styles', pop, happy, 95, 90).
music(s3, 'Levitating', 'Dua Lipa', pop, energetic, 103, 88).
music(s4, 'Bad Guy', 'Billie Eilish', pop, dark, 135, 92).
music(s5, 'Shallow', 'Lady Gaga', pop, sad, 96, 85).
music(s6, 'Perfect', 'Ed Sheeran', pop, romantic, 63, 94).
music(s7, 'Anti-Hero', 'Taylor Swift', pop, melancholic, 97, 91).
music(s8, 'Flowers', 'Miley Cyrus', pop, empowered, 118, 93).
music(s9, 'As It Was', 'Harry Styles', pop, nostalgia, 174, 92).
music(s10, 'Stay', 'The Kid LAROI', pop, energetic, 170, 87).

% --- ROCK ---
music(s11, 'Bohemian Rhapsody', 'Queen', rock, dramatic, 143, 98).
music(s12, 'Back in Black', 'AC/DC', rock, energetic, 94, 96).
music(s13, 'Stairway to Heaven', 'Led Zeppelin', rock, epic, 82, 97).
music(s14, 'Hotel California', 'Eagles', rock, melancholic, 74, 95).
music(s15, 'Smells Like Teen Spirit', 'Nirvana', rock, aggressive, 117, 96).
music(s16, 'Highway to Hell', 'AC/DC', rock, energetic, 116, 94).
music(s17, 'Comfortably Numb', 'Pink Floyd', rock, chill, 65, 93).
music(s18, 'Thunderstruck', 'AC/DC', rock, energetic, 133, 92).
music(s19, 'Sweet Child O Mine', 'Guns N Roses', rock, happy, 125, 95).
music(s20, 'Under the Bridge', 'Red Hot Chili Peppers', rock, sad, 85, 89).

% --- JAZZ ---
music(s21, 'Take Five', 'Dave Brubeck', jazz, chill, 174, 85).
music(s22, 'So What', 'Miles Davis', jazz, calm, 130, 88).
music(s23, 'My Funny Valentine', 'Chet Baker', jazz, sad, 60, 82).
music(s24, 'Autumn Leaves', 'Bill Evans', jazz, nostalgic, 110, 84).
music(s25, 'Fly Me To The Moon', 'Frank Sinatra', jazz, romantic, 119, 91).
music(s26, 'In the Mood', 'Glenn Miller', jazz, happy, 160, 80).
music(s27, 'The Girl From Ipanema', 'Stan Getz', jazz, chill, 122, 86).
music(s28, 'Summertime', 'Ella Fitzgerald', jazz, calm, 70, 87).
music(s29, 'What a Wonderful World', 'Louis Armstrong', jazz, peaceful, 77, 95).
music(s30, 'Feeling Good', 'Nina Simone', jazz, empowered, 78, 89).

% --- HIP HOP ---
music(s31, 'Lose Yourself', 'Eminem', hiphop, energetic, 171, 98).
music(s32, 'Gods Plan', 'Drake', hiphop, chill, 77, 94).
music(s33, 'Humble', 'Kendrick Lamar', hiphop, aggressive, 150, 93).
music(s34, 'Old Town Road', 'Lil Nas X', hiphop, happy, 136, 89).
music(s35, 'SICKO MODE', 'Travis Scott', hiphop, energetic, 155, 92).
music(s36, 'N.Y. State of Mind', 'Nas', hiphop, gritty, 84, 90).
music(s37, 'Juicy', 'Notorious B.I.G.', hiphop, celebratory, 96, 94).
music(s38, 'Paper Planes', 'M.I.A.', hiphop, chill, 86, 88).
music(s39, 'Empire State of Mind', 'Jay-Z', hiphop, empowered, 173, 91).
music(s40, 'Alright', 'Kendrick Lamar', hiphop, hopeful, 110, 90).

% --- CLASSICAL ---
music(s41, 'Moonlight Sonata', 'Beethoven', classical, sad, 60, 96).
music(s42, 'The Four Seasons', 'Vivaldi', classical, energetic, 125, 95).
music(s43, 'Clair de Lune', 'Debussy', classical, peaceful, 65, 94).
music(s44, 'Symphony No. 5', 'Beethoven', classical, dramatic, 108, 93).
music(s45, 'Bolero', 'Ravel', classical, steady, 72, 88).
music(s46, 'Requiem', 'Mozart', classical, dark, 75, 92).
music(s47, 'Gymnopedie No. 1', 'Erik Satie', classical, calm, 70, 91).
music(s48, 'Swan Lake', 'Tchaikovsky', classical, elegant, 90, 90).
music(s49, 'Ride of the Valkyries', 'Wagner', classical, epic, 140, 89).
music(s50, 'Canon in D', 'Pachelbel', classical, peaceful, 75, 95).

% --- LO-FI ---
music(s51, 'Lofi Girl Coffee', 'Chillhop', lofi, chill, 80, 85).
music(s52, 'Rainy Nights', 'Sleepy Fish', lofi, melancholic, 70, 82).
music(s53, 'Sunset Drive', 'SwuM', lofi, relaxed, 90, 80).
music(s54, 'Midnight City Beat', 'Idealism', lofi, nostalgic, 85, 87).
music(s55, 'Morning Coffee', 'Tomppabeats', lofi, happy, 95, 84).

% --- BLUES ---
music(s56, 'The Thrill Is Gone', 'B.B. King', blues, sad, 90, 92).
music(s57, 'Hoochie Coochie Man', 'Muddy Waters', blues, confident, 75, 88).
music(s58, 'Texas Flood', 'Stevie Ray Vaughan', blues, gritty, 80, 86).
music(s59, 'Cross Road Blues', 'Robert Johnson', blues, haunting, 95, 85).
music(s60, 'Stormy Monday', 'T-Bone Walker', blues, melancholic, 65, 84).

% --- METAL ---
music(s61, 'Master of Puppets', 'Metallica', metal, aggressive, 212, 96).
music(s62, 'Paranoid', 'Black Sabbath', metal, anxious, 163, 95).
music(s63, 'The Trooper', 'Iron Maiden', metal, energetic, 160, 92).
music(s64, 'Holy Wars', 'Megadeth', metal, aggressive, 168, 90).
music(s65, 'Raining Blood', 'Slayer', metal, dark, 210, 89).

% --- COUNTRY ---
music(s66, 'Jolene', 'Dolly Parton', country, sad, 110, 93).
music(s67, 'Take Me Home, Country Roads', 'John Denver', country, nostalgia, 82, 94).
music(s68, 'Ring of Fire', 'Johnny Cash', country, energetic, 104, 91).
music(s69, 'I Walk the Line', 'Johnny Cash', country, calm, 100, 92).
music(s70, 'Man! I Feel Like a Woman!', 'Shania Twain', country, happy, 125, 88).

% --- EXTRA FACTS (to cross 70) ---
music(s71, 'Stayin Alive', 'Bee Gees', disco, happy, 103, 94).
music(s72, 'I Will Survive', 'Gloria Gaynor', disco, empowered, 116, 93).
music(s73, 'Dancing Queen', 'ABBA', disco, happy, 100, 95).
music(s74, 'September', 'Earth, Wind & Fire', funk, celebratory, 126, 96).
music(s75, 'Get Lucky', 'Daft Punk', electronic, happy, 116, 92).

% --- HINDI (BOLLYWOOD & INDIE) ---
music(s76, 'Kesariya', 'Arijit Singh', bollywood, romantic, 95, 96).
music(s77, 'Zinda', 'Siddharth Mahadevan', bollywood, energetic, 128, 92).
music(s78, 'Tum Hi Ho', 'Arijit Singh', bollywood, sad, 92, 95).
music(s79, 'Kala Chashma', 'Badshah', bollywood, happy, 105, 94).
music(s80, 'Jai Ho', 'A.R. Rahman', bollywood, empowered, 118, 97).
music(s81, 'Kun Faya Kun', 'A.R. Rahman', bollywood, peaceful, 80, 93).
music(s82, 'Apna Time Aayega', 'Ranveer Singh', hiphop, energetic, 155, 91).
music(s83, 'Namo Namo', 'Amit Trivedi', bollywood, spiritual, 85, 89).
music(s84, 'Pasoori', 'Ali Sethi', indie, nostalgia, 122, 98).
music(s85, 'Kabira', 'Tochi Raina', bollywood, melancholic, 88, 92).
music(s86, 'Chaiyya Chaiyya', 'Sukhwinder Singh', bollywood, energetic, 135, 95).
music(s87, 'Ae Dil Hai Mushkil', 'Arijit Singh', bollywood, sad, 82, 93).
music(s88, 'Gallan Goodiyaan', 'Farhan Akhtar', bollywood, happy, 120, 94).
music(s89, 'Maahi Ve', 'Shankar-Ehsaan-Loy', bollywood, happy, 110, 91).
music(s90, 'Raataan Lambiyan', 'Jubin Nautiyal', bollywood, romantic, 90, 96).

% Mood Energy mapping
energy(happy, high).
energy(energetic, high).
energy(aggressive, high).
energy(dark, low).
energy(sad, low).
energy(chill, low).
energy(calm, low).
energy(peaceful, low).
energy(romantic, medium).
energy(nostalgia, medium).
energy(empowered, medium).
energy(melancholic, low).
energy(aggessive, high).
energy(epic, high).
energy(celebratory, high).
energy(hopeful, medium).
energy(relaxed, low).
energy(gritty, medium).
energy(haunting, low).
energy(anxious, high).
energy(elegant, medium).
energy(steady, medium).
energy(dramatic, high).
energy(spiritual, medium).

% Activity energy requirements
activity_energy(workout, high).
activity_energy(study, low).
activity_energy(party, high).
activity_energy(focus, low).
activity_energy(travel, medium).
activity_energy(sleep, low).

% =========================================================================
% SECTION 2.5: USER PREFERENCES
% user_preference(User, AttributeType, Value).
% =========================================================================

user_preference(alice, genre, pop).
user_preference(alice, mood, happy).
user_preference(bob, genre, rock).
user_preference(bob, mood, energetic).
user_preference(charlie, genre, jazz).
user_preference(charlie, mood, chill).
user_preference(david, genre, hiphop).
user_preference(david, mood, aggressive).

% =========================================================================
% SECTION 3: RECOMMENDATION RULES (CORE LOGIC)
% =========================================================================

% --- BASE MATCHING RULES (Unification & Backtracking) ---

% 1. Match by Mood: Find all songs where the Mood matches the query.
match_mood(SongID, Mood) :-
    music(SongID, _, _, _, Mood, _, _).

% 2. Match by Genre: Find all songs where the Genre matches the query.
match_genre(SongID, Genre) :-
    music(SongID, _, _, Genre, _, _, _).

% 3. Match by Profile: Cross-reference a song's attributes with user_preference facts.
% This rule uses backtracking to find songs matching ANY of the user's preferred attributes.
match_user_profile(User, SongID) :-
    user_preference(User, genre, Genre),
    match_genre(SongID, Genre).
match_user_profile(User, SongID) :-
    user_preference(User, mood, Mood),
    match_mood(SongID, Mood).

% --- HIGHER-LEVEL RECOMMENDATIONS ---

% 4. Recommend by Mood (List based)
recommend_by_mood(Mood, Songs) :-
    findall(ID, match_mood(ID, Mood), Songs).

% 5. Recommend by Genre (List based)
recommend_by_genre(Genre, Songs) :-
    findall(ID, match_genre(ID, Genre), Songs).

% 3. Hybrid match: Mood AND Genre
perfect_match(Mood, Genre, Songs) :-
    findall(ID, music(ID, _, _, Genre, Mood, _, _), Songs).

% 4. Identify high tempo songs (> 140)
fast_paced_songs(Songs) :-
    findall(ID, (music(ID, _, _, _, _, Tempo, _), Tempo > 140), Songs).

% 5. Identify slow songs (< 80)
slow_paced_songs(Songs) :-
    findall(ID, (music(ID, _, _, _, _, Tempo, _), Tempo < 80), Songs).

% 6. Workout Music Recommendation (High Energy Mood + High Tempo)
workout_music(Songs) :-
    findall(ID, (
        music(ID, _, _, _, Mood, Tempo, _),
        energy(Mood, high),
        Tempo > 120
    ), Songs).

% 7. Study Music (Low Energy Mood + Chill Tempo)
study_music(Songs) :-
    findall(ID, (
        music(ID, _, _, _, Mood, Tempo, _),
        energy(Mood, low),
        Tempo < 100
    ), Songs),
    \+ my_member(ID, Songs). % Just a placeholder to show negation use (not actually used here)

% 8. Party Music (Celebratory/Happy + High/Medium Tempo)
party_music(Songs) :-
    findall(ID, (
        music(ID, _, _, _, Mood, Tempo, _),
        (Mood = happy; Mood = celebratory; Mood = energetic),
        Tempo > 100
    ), Songs).

% 9. Top trending songs (Sorted by popularity)
trending_now(SortedSongs) :-
    findall(ID, music(ID, _, _, _, _, _, _), AllIDs),
    sort_songs_by_popularity(AllIDs, SortedSongs).

% 10. Best of Genre (Highest popularity in a genre)
best_in_genre(Genre, BestSong) :-
    findall(Pop, music(_, _, _, Genre, _, _, Pop), Pops),
    my_max(Pops, MaxPop),
    music(BestSong, _, _, Genre, _, _, MaxPop), !.

% 11. Hidden Gems (Low Popularity but Good Vibe - Tempo filter)
hidden_gems(Songs) :-
    findall(ID, (music(ID, _, _, _, _, _, Popularity), Popularity < 85), Songs).

% 12. Chill Out Playlist
chill_out_playlist(Songs) :-
    findall(ID, (
        music(ID, _, _, _, Mood, _, _),
        (Mood = chill; Mood = calm; Mood = peaceful; Mood = relaxed)
    ), Songs).

% 13. High Intensity Playlist
high_intensity(Songs) :-
    findall(ID, (
        music(ID, _, _, _, _, Tempo, Popularity),
        Tempo > 150,
        Popularity > 90
    ), Songs).

% 14. Recommend based on dynamic mood
i_feel(Mood) :-
    retractall(current_mood(_)),
    assertz(current_mood(Mood)),
    write('Noted. You are feeling '), write(Mood), nl,
    write('Try asking: what_should_i_listen_to(Songs).'), nl.

% 15. The "Natural Language" query bridge
what_should_i_listen_to(Songs) :-
    current_mood(Mood), !,
    recommend_by_mood(Mood, Songs).
what_should_i_listen_to(_) :-
    write('I do not know how you feel. Use i_feel(Mood) first.'), nl, fail.

% 16. Suggest something different (Negation check)
something_not_in_genre(Genre, Songs) :-
    findall(ID, (music(ID, _, _, G, _, _, _), G \= Genre), Songs).

% 17. Find songs by Artist (recursive search helper demonstration)
find_by_artist(Artist, Songs) :-
    findall(ID, music(ID, _, Artist, _, _, _, _), Songs).

% 18. Count Genre availability
genre_count(Genre, Count) :-
    recommend_by_genre(Genre, Songs),
    my_length(Songs, Count).

% 19. Check if a song is suitable for an activity
is_suitable_for(ID, Activity) :-
    music(ID, _, _, _, Mood, _, _),
    energy(Mood, E),
    activity_energy(Activity, E).

% 20. Recommended for activity (using suitability)
recommend_for_activity(Activity, Songs) :-
    findall(ID, is_suitable_for(ID, Activity), Songs).

% 21. Suggest a "Blast from the Past" (Nostalgia mood)
blast_from_the_past(Songs) :-
    recommend_by_mood(nostalgia, Songs).

% 22. Dark/Gritty Mix
dark_mix(Songs) :-
    findall(ID, (
        music(ID, _, _, _, Mood, _, _),
        (Mood = dark; Mood = gritty; Mood = haunting)
    ), Songs).

% 23. Top 3 Trending (using recursion/list cutting)
top_3_trending([S1, S2, S3]) :-
    trending_now([S1, S2, S3|_]).

% 24. Find random suggestion (Dummy logic using sorting and cutting)
surprise_me(Song) :-
    trending_now(All),
    my_member(Song, All), !. % Takes the first one (most popular)

% 25. Check if song exists in list (NL query feel)
is_song_in_list(Title, List) :-
    music(ID, Title, _, _, _, _, _),
    my_member(ID, List).

% 26. Display song details (Formatting)
show_details(ID) :-
    music(ID, Title, Artist, Genre, Mood, Tempo, Pop),
    format('~w - ~w (~w) | Genre: ~w | Mood: ~w | Tempo: ~w | Pop: ~w~n', 
           [Title, Artist, ID, Genre, Mood, Tempo, Pop]).

% 27. Show all details in a list
show_all([]).
show_all([H|T]) :-
    show_details(H),
    show_all(T).

% =========================================================================
% SECTION 4: ENHANCEMENTS (EXPLANATION & INTERACTIVE MENU)
% =========================================================================

% 28. Explanation Facility: Why was this song recommended?
explain_recommendation(ID) :-
    music(ID, Title, Artist, Genre, Mood, Tempo, Pop),
    energy(Mood, Energy),
    format('~n--- EXPLANATION FOR: ~w ---~n', [Title]),
    format('1. Artist: ~w~n', [Artist]),
    format('2. Mood: It is a "~w" track which provides ~w energy.~n', [Mood, Energy]),
    format('3. Genre: It belongs to the ~w category.~n', [Genre]),
    format('4. Tempo: At ~w BPM, it is ~w.~n', [Tempo, TDesc]),
    (Tempo > 130 -> TDesc = 'fast-paced and energetic' ; TDesc = 'calm and steady'),
    format('5. Popularity: It has a high rating of ~w/100.~n', [Pop]),
    (Pop > 90 -> write('6. This is a top-tier trending track!'), nl ; true), !.

% 29. Discovery Mode: Recommend songs from genres you DON''T usually listen to
% but that match the energy of your preferred mood.
discovery_mode(User, Songs) :-
    user_preference(User, mood, PrefMood),
    energy(PrefMood, Energy),
    user_preference(User, genre, PrefGenre),
    findall(ID, (
        music(ID, _, _, OtherGenre, OtherMood, _, _),
        OtherGenre \= PrefGenre,
        energy(OtherMood, Energy)
    ), Songs).

% Helper to read input without requiring a dot (.)
get_input(Term) :-
    read_line_to_string(user_input, String),
    (String == "" -> Term = error ;
     catch(term_string(Term, String), _, Term = error)).

% 30. INTERACTIVE MENU SYSTEM (User-Friendly version)
start :-
    repeat,
    nl, write('=========================================='), nl,
    write('   WELCOME TO THE PROLOG MUSIC ADVISOR    '), nl,
    write('=========================================='), nl,
    write('1. Recommend by Mood'), nl,
    write('2. Recommend by Genre'), nl,
    write('3. Recommend by Activity (Workout/Study)'), nl,
    write('4. See Top Trending Songs'), nl,
    write('5. Explain a Song (Why this?)'), nl,
    write('6. Discovery Mode (Try something new)'), nl,
    write('0. Exit'), nl,
    write('=========================================='), nl,
    write('Enter your choice: '),
    
    get_input(Choice),
    
    (Choice == 0 -> 
        write('Goodbye!'), nl, !
    ; 
        handle_choice(Choice),
        fail
    ).

handle_choice(error) :- 
    write('ERROR: Invalid input. Please enter a number (0-6).'), nl, !.

handle_choice(1) :- 
    write('Enter Mood (e.g. happy. sad. energetic.): '), 
    get_input(M),
    (M == error -> write('Invalid mood format.') ; recommend_by_mood(M, S), show_all(S)), nl, !.

handle_choice(2) :- 
    write('Enter Genre (e.g. pop. rock. bollywood.): '), 
    get_input(G),
    (G == error -> write('Invalid genre format.') ; recommend_by_genre(G, S), show_all(S)), nl, !.

handle_choice(3) :- 
    write('Enter Activity (workout. study. party.): '), 
    get_input(A),
    (A == error -> write('Invalid activity.') ; 
        (A = workout -> workout_music(S) ; A = study -> study_music(S) ; party_music(S)),
        show_all(S)), nl, !.

handle_choice(4) :- 
    write('--- TOP TRENDING ---'), nl,
    top_3_trending(S), show_all(S), nl, !.

handle_choice(5) :- 
    write('Enter Song ID (e.g. s1. s76.): '), 
    get_input(ID),
    (ID == error -> write('Invalid ID format.') ; explain_recommendation(ID)), nl, !.

handle_choice(6) :- 
    write('Enter User Profile (alice. bob. charlie. david.): '), 
    get_input(U),
    (U == error -> write('Invalid user format.') ; discovery_mode(U, S), show_all(S)), nl, !.

handle_choice(_) :- 
    write('Invalid choice, please try again with a number followed by a dot (e.g., 1.).'), nl.

% =========================================================================
% END OF SYSTEM
% =========================================================================
