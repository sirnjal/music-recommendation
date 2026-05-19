% ============================================================
% MUSIC RECOMMENDATION SYSTEM
% Role 4: Optimization & Edge-Case Manager
% Focus: Cut (!), Negation (\+), Arithmetic Comparisons
% ============================================================
%
% DEPENDENCIES (provided by other team members):
%   - song/7  facts from Role 1 (Knowledge Architect)
%     Format: song(SongID, Title, Artist, Genre, Mood, ReleaseYear, Rating)
%   - user_preference/3 facts from Role 1
%     Format: user_preference(UserID, LikedGenres, PreferredMoods)
%   - recommend_by_mood/2, recommend_by_genre/2 from Role 2 (Core Rules Developer)
%   - my_member/2, my_insertion_sort/3 from Role 3 (Custom Utilities Engineer)
%
% ============================================================
% SAMPLE FACTS (for standalone testing — remove when integrating)
% ============================================================

song(s001, 'Blinding Lights',     'The Weeknd',   pop,       energetic,  2019, 4.8).
song(s002, 'Shape of You',        'Ed Sheeran',   pop,       happy,      2017, 4.7).
song(s003, 'Hotel California',    'Eagles',        rock,      melancholy, 1977, 4.9).
song(s004, 'Bohemian Rhapsody',   'Queen',         rock,      melancholy, 1975, 5.0).
song(s005, 'Smells Like Teen Spirit','Nirvana',    rock,      energetic,  1991, 4.8).
song(s006, 'Thunderstruck',       'AC/DC',         rock,      energetic,  1990, 4.7).
song(s007, 'Watermelon Sugar',    'Harry Styles',  pop,       happy,      2019, 4.5).
song(s008, 'Levitating',          'Dua Lipa',      pop,       happy,      2020, 4.6).
song(s009, 'Moonlight Sonata',    'Beethoven',     classical, relaxed,    1801, 4.9).
song(s010, 'Four Seasons',        'Vivaldi',       classical, relaxed,    1723, 4.8).
song(s011, 'Yesterday',           'Beatles',       pop,       melancholy, 1965, 4.9).
song(s012, 'Stairway to Heaven',  'Led Zeppelin',  rock,      relaxed,    1971, 5.0).
song(s013, 'Dynamite',            'BTS',           pop,       energetic,  2020, 4.6).
song(s014, 'Stay',                'Justin Bieber', pop,       relaxed,    2021, 4.3).
song(s015, 'Shivers',             'Ed Sheeran',    pop,       energetic,  2021, 4.4).

user_preference(user1, [pop, rock],       [happy, energetic]).
user_preference(user2, [classical, rock], [relaxed, melancholy]).
user_preference(user3, [pop],             [happy]).

% ============================================================
% SECTION A: CUT (!) — Prevent redundant backtracking
% ============================================================

% Rule A1: recommend_best_mood/3
% Find the FIRST (highest-priority) matching song for a mood, then CUT.
% Once a suitable song is found, do not backtrack to find alternatives.
% This is "green cut" — it does not change correctness, only performance.
%
% Usage: recommend_best_mood(happy, BestSong, BestTitle)

recommend_best_mood(Mood, SongID, Title) :-
    song(SongID, Title, _, _, Mood, _, Rating),
    Rating >= 4.5,
    !.   % CUT: stop after finding first high-rated match for this mood


% Rule A2: recommend_top_genre/3
% Find the first song of a given genre with rating above threshold.
% CUT prevents exploring lower-rated alternatives once a good one is found.
%
% Usage: recommend_top_genre(rock, SongID, Title)

recommend_top_genre(Genre, SongID, Title) :-
    song(SongID, Title, _, Genre, _, _, Rating),
    Rating >= 4.7,
    !.   % CUT: commit to this recommendation, skip rest


% Rule A3: classify_mood_intensity/2
% Classify a numerical "energy level" into a mood atom.
% Uses CUT after each branch to enforce mutual exclusion — only the FIRST
% matching branch fires, preventing spurious multiple answers.
%
% Usage: classify_mood_intensity(90, Mood)  --> Mood = energetic

classify_mood_intensity(Level, energetic) :-
    Level >= 80,
    !.
classify_mood_intensity(Level, happy) :-
    Level >= 60,
    !.
classify_mood_intensity(Level, relaxed) :-
    Level >= 40,
    !.
classify_mood_intensity(_, melancholy).   % default: no cut needed at last clause


% Rule A4: unique_genre_recommendation/3
% Given a list of already-recommended SongIDs, recommend the next song of
% a genre that is NOT already in the list. CUT prevents backtracking once
% a unique candidate is found.
%
% Usage: unique_genre_recommendation(pop, [s001, s002], SongID, Title)

unique_genre_recommendation(Genre, AlreadySeen, SongID, Title) :-
    song(SongID, Title, _, Genre, _, _, _),
    \+ my_member(SongID, AlreadySeen),   % negation guard (see Section B)
    !.   % CUT: first unseen song is good enough


% ============================================================
% SECTION B: NEGATION (\+) — Exclusion Rules
% ============================================================
% Negation in Prolog is "negation-as-failure":
% \+ Goal succeeds if Goal CANNOT be proven.
% Use only when the excluded fact is fully ground (known).

% Rule B1: recommend_excluding_artist/4
% Recommend a song of a genre, but NOT by a specific artist.
% Example: "I want rock, but not by Nirvana."
%
% Usage: recommend_excluding_artist(rock, energetic, 'Nirvana', SongID)

recommend_excluding_artist(Genre, Mood, ExcludedArtist, SongID) :-
    song(SongID, _, Artist, Genre, Mood, _, _),
    \+ Artist = ExcludedArtist.   % exclude this specific artist


% Rule B2: recommend_not_old/3
% Recommend a song that is NOT considered "old" (i.e., not before 1990).
% Shows safe use of \+ with a sub-goal that uses arithmetic.
%
% Usage: recommend_not_old(pop, happy, SongID)

recommend_not_old(Genre, Mood, SongID) :-
    song(SongID, _, _, Genre, Mood, Year, _),
    \+ Year < 1990.   % equivalent to: Year >= 1990


% Rule B3: recommend_unheard/3
% Recommend a song the user has NOT already heard.
% user_heard/2 is asserted dynamically during a session by Role 5.
% The dynamic declaration below prevents Prolog from throwing an
% "undefined predicate" error when no user_heard facts exist yet.
%
% Usage: recommend_unheard(user1, pop, SongID)

:- dynamic user_heard/2.   % SAFETY GUARD: allows user_heard to be undefined at load time

recommend_unheard(UserID, Genre, SongID) :-
    song(SongID, _, _, Genre, _, _, _),
    \+ user_heard(UserID, SongID).   % skip songs user already knows

% Placeholder — in the integrated system, Role 5 will assert these:
% user_heard(user1, s001).
% user_heard(user1, s002).


% Rule B4: recommend_mood_genre_not_artist/5
% Combined exclusion: match mood AND genre, exclude a specific artist.
% Demonstrates chaining \+ with multiple conditions.
%
% Usage: recommend_mood_genre_not_artist(energetic, rock, 'AC/DC', SongID, Title)

recommend_mood_genre_not_artist(Mood, Genre, ExcludedArtist, SongID, Title) :-
    song(SongID, Title, Artist, Genre, Mood, _, _),
    \+ Artist = ExcludedArtist.


% ============================================================
% SECTION C: ARITHMETIC COMPARISONS — Safe & Precise Filtering
% ============================================================
% Prolog arithmetic uses =:= (equality), > (greater), < (less), etc.
% Both sides must be fully instantiated before evaluation — always check!

% Rule C1: recommend_recent/3
% Recommend songs released strictly AFTER a given year.
% "Strictly after 2015" means Year > 2015.
%
% Usage: recommend_recent(pop, 2015, SongID)

recommend_recent(Genre, AfterYear, SongID) :-
    song(SongID, _, _, Genre, _, Year, _),
    Year > AfterYear.


% Rule C2: recommend_high_rated/3
% Recommend songs with a rating strictly ABOVE a threshold.
% E.g., rating > 4.5 for "top-tier" songs.
%
% Usage: recommend_high_rated(rock, 4.5, SongID)

recommend_high_rated(Genre, MinRating, SongID) :-
    song(SongID, _, _, Genre, _, _, Rating),
    Rating > MinRating.


% Rule C3: recommend_in_rating_range/4
% Recommend songs with rating between Low and High (inclusive).
% Safe because we check both bounds before unifying.
%
% Usage: recommend_in_rating_range(pop, 4.0, 4.6, SongID)

recommend_in_rating_range(Genre, Low, High, SongID) :-
    song(SongID, _, _, Genre, _, _, Rating),
    Rating >= Low,
    Rating =< High.


% Rule C4: recommend_by_era/4
% Recommend songs from a specific decade range.
% E.g., decade 1990-1999 for "90s rock".
%
% Usage: recommend_by_era(rock, 1990, 1999, SongID)

recommend_by_era(Genre, StartYear, EndYear, SongID) :-
    song(SongID, _, _, Genre, _, Year, _),
    Year >= StartYear,
    Year =< EndYear.


% Rule C5: recommend_recent_and_popular/4
% Combines recency and rating — a common real-world filter.
% "Recent top hits": released after AfterYear AND rating above MinRating.
%
% Usage: recommend_recent_and_popular(pop, 2018, 4.5, SongID)

recommend_recent_and_popular(Genre, AfterYear, MinRating, SongID) :-
    song(SongID, _, _, Genre, _, Year, Rating),
    Year > AfterYear,
    Rating > MinRating.


% ============================================================
% SECTION D: COMBINED RULES (Cut + Negation + Arithmetic)
% ============================================================

% Rule D1: best_match_for_user/3
% Given a UserID, find the BEST matching song based on their preferences,
% excluding artists they dislike, and only recent high-rated songs.
% Uses CUT to commit once a perfect match is found.
%
% Assumes: user_preference(UserID, LikedGenres, PreferredMoods)
%          user_dislikes_artist(UserID, Artist)  [asserted by Role 5]
%
% Usage: best_match_for_user(user1, SongID, Title)

best_match_for_user(UserID, SongID, Title) :-
    user_preference(UserID, LikedGenres, PreferredMoods),
    my_member(Genre, LikedGenres),
    my_member(Mood,  PreferredMoods),
    song(SongID, Title, Artist, Genre, Mood, Year, Rating),
    Year > 2010,             % recency filter
    Rating > 4.4,            % quality filter
    \+ user_dislikes_artist(UserID, Artist),  % exclusion
    !.   % CUT: first perfect match is sufficient

% Placeholder facts for testing — Role 5 will manage these:
user_dislikes_artist(user1, 'Nirvana').
user_dislikes_artist(user2, 'BTS').


% Rule D2: safe_recommend_with_fallback/3
% Try to find a high-rated recent song; if none found, fall back to
% any song of that genre. Demonstrates ordered clause selection with CUT.
%
% Usage: safe_recommend_with_fallback(pop, happy, SongID)

safe_recommend_with_fallback(Genre, Mood, SongID) :-
    song(SongID, _, _, Genre, Mood, Year, Rating),
    Year > 2015,
    Rating > 4.5,
    !.   % CUT: high-quality recent match found — stop here

safe_recommend_with_fallback(Genre, Mood, SongID) :-
    song(SongID, _, _, Genre, Mood, _, _).
    % No CUT: fallback — return any match, allow backtracking for all options


% Rule D3: collect_optimized_recommendations/5
% Collect all songs matching genre+mood that pass quality and recency checks.
% Returns a list. No built-in findall — uses a custom recursive accumulator
% to comply with the "minimal built-in predicates" requirement.
% No CUT here — we want ALL matches for Role 3 to sort.
%
% Usage: collect_optimized_recommendations(pop, happy, 2015, 4.0, List)
%
% Public entry point — initialises the accumulator to empty:

collect_optimized_recommendations(Genre, Mood, AfterYear, MinRating, List) :-
    collect_optimized_acc(Genre, Mood, AfterYear, MinRating, [], List).

% Worker predicate using an accumulator (Acc).
% We use song/7 with a "current candidate" approach:
% iterate over all song IDs by backtracking, test each, build the list.
%
% Strategy: assert a helper to enumerate songs, filter inline, accumulate.
% Since Prolog does not have a "for-each" loop, we simulate it via recursion
% over a list of all SongIDs gathered by collect_all_song_ids/1 (see below).

collect_optimized_acc(Genre, Mood, AfterYear, MinRating, Acc, List) :-
    collect_all_song_ids(AllIDs),
    filter_songs(AllIDs, Genre, Mood, AfterYear, MinRating, Acc, List).

% filter_songs/7 — recursively walk AllIDs, keep those that pass all filters.

filter_songs([], _, _, _, _, Acc, Acc).          % base case: reverse not needed here
                                                  % (Role 3 sort will reorder anyway)

filter_songs([H|T], Genre, Mood, AfterYear, MinRating, Acc, List) :-
    song(H, _, _, Genre, Mood, Year, Rating),     % must match genre AND mood
    Year > AfterYear,                             % recency check
    Rating >= MinRating,                          % quality check
    !,                                            % CUT: H passes — don't try next clause
    filter_songs(T, Genre, Mood, AfterYear, MinRating, [H|Acc], List).

filter_songs([_|T], Genre, Mood, AfterYear, MinRating, Acc, List) :-
    % current head failed one or more filters — skip it
    filter_songs(T, Genre, Mood, AfterYear, MinRating, Acc, List).

% collect_all_song_ids/1
% Gathers every SongID present in the database into a list.
% Written without findall — uses the same accumulator pattern.

collect_all_song_ids(IDs) :-
    collect_ids_acc([], IDs).

collect_ids_acc(Acc, Final) :-
    song(ID, _, _, _, _, _, _),          % backtrack over every song fact
    \+ my_member(ID, Acc),               % not yet collected
    !,                                   % CUT: found a new one — add and recurse
    collect_ids_acc([ID|Acc], Final).

collect_ids_acc(Acc, Acc).               % no more new IDs — done


% Rule D4: exclude_genre_from_list/3
% Given a list of SongIDs, remove all songs of a particular genre.
% Uses \+ with recursion — shows negation inside list traversal.
%
% Base case: empty list
exclude_genre_from_list(_, [], []).

% Recursive case: if song IS the excluded genre, skip it
exclude_genre_from_list(ExcludedGenre, [H|T], Result) :-
    song(H, _, _, ExcludedGenre, _, _, _),
    !,   % CUT: confirmed it's excluded genre — don't explore other clauses
    exclude_genre_from_list(ExcludedGenre, T, Result).

% Recursive case: song is NOT the excluded genre — keep it
exclude_genre_from_list(ExcludedGenre, [H|T], [H|Result]) :-
    exclude_genre_from_list(ExcludedGenre, T, Result).


% ============================================================
% HELPER: my_member/2 (local copy for standalone testing)
% Role 3 (Custom Utilities) provides the authoritative version.
% Remove this when integrating into the full system.
% ============================================================

my_member(X, [X|_]).
my_member(X, [_|T]) :- my_member(X, T).


% ============================================================
% TEST QUERIES (run these in SWI-Prolog to verify)
% ============================================================
%
% ?- recommend_best_mood(happy, ID, Title).
%    Expected: ID = s002, Title = 'Shape of You'  (or another high-rated happy song)
%
% ?- recommend_top_genre(rock, ID, Title).
%    Expected: ID = s004, Title = 'Bohemian Rhapsody'  (first rock song with rating >= 4.7)
%
% ?- classify_mood_intensity(85, Mood).
%    Expected: Mood = energetic
%
% ?- classify_mood_intensity(55, Mood).
%    Expected: Mood = happy
%
% ?- recommend_excluding_artist(rock, energetic, 'Nirvana', ID).
%    Expected: ID = s006 (Thunderstruck by AC/DC — Nirvana excluded)
%
% ?- recommend_recent(pop, 2015, ID).
%    Expected: s007, s008, s013, s014, s015  (all pop songs after 2015)
%
% ?- recommend_high_rated(rock, 4.5, ID).
%    Expected: s003, s004, s005, s006, s012
%
% ?- recommend_in_rating_range(pop, 4.0, 4.6, ID).
%    Expected: s007, s008, s013, s014, s015
%
% ?- recommend_by_era(rock, 1990, 1999, ID).
%    Expected: s005 (Smells Like Teen Spirit, 1991)
%
% ?- recommend_recent_and_popular(pop, 2018, 4.5, ID).
%    Expected: s001 (2019, 4.8), s008 (2020, 4.6), s013 (2020, 4.6)
%
% ?- best_match_for_user(user1, ID, Title).
%    Expected: a pop/rock energetic/happy song after 2010, rating > 4.4, not Nirvana
%
% ?- safe_recommend_with_fallback(pop, happy, ID).
%    Expected: s008 or similar (recent + high-rated) via first clause
%
% ?- collect_optimized_recommendations(pop, happy, 2015, 4.4, List).
%    Expected: List contains s007, s008, s013 (order may vary — Role 3 will sort)
%
% ?- exclude_genre_from_list(rock, [s001,s005,s007,s006,s008], Result).
%    Expected: Result = [s001, s007, s008]

