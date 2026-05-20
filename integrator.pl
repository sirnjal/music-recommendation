:- module(integrator, [
    suggest_music/2,
    show_recommendations/1,
    start/0
]).

:- use_module(knowledge_base).
:- use_module(custom_utilities).
:- use_module(core_rules).
:- use_module(optimization).

/*
    =========================================================================
    MODULE: integrator
    ROLE: Integrator & Interface Lead (Front-End Logic)
    AUTHOR: Raj
    
    This module ties the entire Music Recommendation System together.
    It provides:
    1. A natural language query parser that extracts mood, genre, exclusions,
       year limits, and rating limits from a text string.
    2. The main entry point: suggest_music/3 with a fallback recommendation cascade.
    3. An explanation facility detailing the reasons behind each recommendation.
    4. An interactive CLI environment (start/0) for manual test execution.
    =========================================================================
*/

% --- NATURAL LANGUAGE QUERY PARSER ---

% parse_query/7: Scans a string for keywords to isolate recommendable criteria.
parse_query(QueryString, Mood, Genre, ExcludedArtist, AfterYear, MinRating, Bollywood) :-
    extract_mood(QueryString, Mood),
    extract_genre(QueryString, Genre),
    extract_excluded_artist(QueryString, ExcludedArtist),
    extract_year(QueryString, AfterYear),
    extract_rating(QueryString, MinRating),
    extract_bollywood(QueryString, Bollywood).

extract_bollywood(Query, Bollywood) :-
    ( (contains_keyword(Query, "not bollywood") ; contains_keyword(Query, "except bollywood") ; contains_keyword(Query, "but not bollywood")) ->
        Bollywood = no
    ; (contains_keyword(Query, "bollywood") ; contains_keyword(Query, "indian")) ->
        Bollywood = yes
    ; Bollywood = none ), !.

% Helper: Case-insensitive substring match
contains_keyword(String, Keyword) :-
    string_lower(String, Lower),
    string_lower(Keyword, LowerKey),
    sub_string(Lower, _, _, _, LowerKey).

% Mood keyword matching
extract_mood(Query, Mood) :-
    (contains_keyword(Query, "happy") -> Mood = happy
    ;contains_keyword(Query, "relaxed") -> Mood = relaxed
    ;contains_keyword(Query, "energetic") -> Mood = energetic
    ;contains_keyword(Query, "melancholy") -> Mood = melancholy
    ;contains_keyword(Query, "sad") -> Mood = sad
    ;contains_keyword(Query, "romantic") -> Mood = romantic
    ;Mood = none), !.

% Genre keyword matching
extract_genre(Query, Genre) :-
    (contains_keyword(Query, "pop") -> Genre = pop
    ;contains_keyword(Query, "rock") -> Genre = rock
    ;contains_keyword(Query, "classical") -> Genre = classical
    ;contains_keyword(Query, "rap") -> Genre = rap
    ;contains_keyword(Query, "blues") -> Genre = blues
    ;Genre = none), !.

% Excluded Artist matching
% Searches the query for exclusion prefixes ("not by", "except") and unifies
% with any matching artist name present in our database.
extract_excluded_artist(Query, ExcludedArtist) :-
    ( (contains_keyword(Query, "not by") ; contains_keyword(Query, "excluding") ; contains_keyword(Query, "except") ; contains_keyword(Query, "not")) ->
        ( knowledge_base:song(_, _, Artist, _, _, _, _),
          contains_keyword(Query, Artist) ->
            ExcludedArtist = Artist
        ; ExcludedArtist = none )
    ; ExcludedArtist = none ), !.

% Year limit extraction (looks for any 4 consecutive digits)
extract_year(Query, Year) :-
    string_chars(Query, Chars),
    (find_year_chars(Chars, YearChars) ->
        number_chars(Year, YearChars)
    ; Year = none), !.

find_year_chars([C1, C2, C3, C4 | _], [C1, C2, C3, C4]) :-
    char_type(C1, digit),
    char_type(C2, digit),
    char_type(C3, digit),
    char_type(C4, digit),
    !.
find_year_chars([_ | T], YearChars) :-
    find_year_chars(T, YearChars).

% Rating limit extraction (looks for digit.digit pattern)
extract_rating(Query, Rating) :-
    string_chars(Query, Chars),
    (find_rating_chars(Chars, RatingChars) ->
        number_chars(Rating, RatingChars)
    ; Rating = none), !.

find_rating_chars([C1, '.', C2 | _], [C1, '.', C2]) :-
    char_type(C1, digit),
    char_type(C2, digit),
    !.
find_rating_chars([_ | T], RatingChars) :-
    find_rating_chars(T, RatingChars).


% --- RECURSIVE FILTER HELPERS ---

% filter_all_songs/7: Gathers candidates that satisfy all parsed query filters.
filter_all_songs(Mood, Genre, ExcludedArtist, AfterYear, MinRating, Bollywood, Candidates) :-
    core_rules:all_songs(All),
    filter_songs_rec(All, Mood, Genre, ExcludedArtist, AfterYear, MinRating, Bollywood, Candidates).

filter_songs_rec([], _, _, _, _, _, _, []).
filter_songs_rec([H|T], Mood, Genre, ExcludedArtist, AfterYear, MinRating, Bollywood, [H|Rest]) :-
    knowledge_base:song(H, _, Artist, G, M, Year, Rating),
    (Mood == none -> true ; Mood = M),
    (Genre == none -> true ; Genre = G),
    (ExcludedArtist == none -> true ; \+ Artist = ExcludedArtist),
    (AfterYear == none -> true ; Year > AfterYear),
    (MinRating == none -> true ; Rating >= MinRating),
    (Bollywood == yes -> (H >= 61, H =< 80) ; (Bollywood == no -> \+ (H >= 61, H =< 80) ; true)),
    !, % Cut: song accepted, move to tail
    filter_songs_rec(T, Mood, Genre, ExcludedArtist, AfterYear, MinRating, Bollywood, Rest).
filter_songs_rec([_|T], Mood, Genre, ExcludedArtist, AfterYear, MinRating, Bollywood, Rest) :-
    filter_songs_rec(T, Mood, Genre, ExcludedArtist, AfterYear, MinRating, Bollywood, Rest).


% --- SUGGESTION MAIN LOGIC & CASCADE ---

% suggest_music/2: Entry point that parses string and coordinates fallback cascade.
suggest_music(QueryString, OutputSongs) :-
    % 1. Parse natural language query
    parse_query(QueryString, Mood, Genre, ExcludedArtist, AfterYear, MinRating, Bollywood),
    format('~n[Parser] Mood:~w | Genre:~w | Exclude:~w | Year>~w | Rating>=~w | Bollywood:~w~n',
           [Mood, Genre, ExcludedArtist, AfterYear, MinRating, Bollywood]),
    
    % 2. Fallback Recommendation Cascade
    (
        % Level 1: Strict query filters (only run if query contains criteria)
        (Mood \= none ; Genre \= none ; AfterYear \= none ; MinRating \= none ; Bollywood \= none),
        filter_all_songs(Mood, Genre, ExcludedArtist, AfterYear, MinRating, Bollywood, Candidates1),
        custom_utilities:my_length(Candidates1, L1), L1 > 0 ->
            format('[Cascade] Level 1 Match (Strict Query): ~w songs.~n', [L1]),
            RawSongs = Candidates1
        ;
        % Level 2: Relaxed hybrid query filters (only run if mood or genre criteria exist)
        (Mood \= none ; Genre \= none),
        core_rules:recommend_hybrid(Genre, Mood, HybridIDs),
        filter_songs_rec(HybridIDs, none, none, ExcludedArtist, none, none, Bollywood, Candidates2),
        custom_utilities:my_length(Candidates2, L2), L2 > 0 ->
            format('[Cascade] Level 2 Match (Relaxed Hybrid Query): ~w songs.~n', [L2]),
            RawSongs = Candidates2
        ;
        % Level 3: Overall Top Hits (General fallback)
        format('[Cascade] Level 3 Match (General Top Hits Fallback).~n', []),
        filter_all_songs(none, none, ExcludedArtist, none, 4.3, Bollywood, Candidates3),
        RawSongs = Candidates3
    ),
    
    % 3. Sort candidates by Rating descending (using custom insertion sort)
    custom_utilities:my_insertion_sort(rating, RawSongs, SortedSongs),
    
    % 4. Take the top 5 matches
    custom_utilities:my_take(5, SortedSongs, OutputSongs),
    !.


% --- FORMATTED PRINTERS ---

show_recommendations([]) :-
    write('  No matching recommendations found.'), nl, !.
show_recommendations(Songs) :-
    write('Recommendations (sorted by Rating descending):'), nl,
    show_rec_rec(Songs, 1), !.

show_rec_rec([], _) :- !.
show_rec_rec([H|T], N) :-
    knowledge_base:song(H, Title, Artist, Genre, Mood, Year, Rating),
    format('  ~w. ID: ~w | "~w" by ~w (~w) | Genre: ~w | Mood: ~w | Rating: ~w/5.0~n',
           [N, H, Title, Artist, Year, Genre, Mood, Rating]),
    N1 is N + 1,
    show_rec_rec(T, N1).


% --- INTERACTIVE CLI COMMAND LOOP ---

start :-
    write('===================================================='), nl,
    write('           MUSIC RECOMMENDATION CLI         '), nl,
    write('===================================================='), nl,
    query_loop.

query_loop :-
    nl, write('Enter search query (or "exit" to quit): '),
    read_line_to_string(user_input, Query),
    ( Query = "exit" ->
        write('Goodbye!'), nl
    ; Query = "" ->
        query_loop
    ;
        ( suggest_music(Query, Recommendations) ->
            show_recommendations(Recommendations)
        ;
            write('Unable to generate recommendations for query.'), nl
        ),
        query_loop
    ).
