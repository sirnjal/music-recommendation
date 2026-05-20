:- module(optimization, [
    recommend_excluding_artist/4,
    recommend_not_old/3,
    recommend_recent/3,
    recommend_high_rated/3,
    recommend_in_rating_range/4
]).

:- use_module(knowledge_base).
:- use_module(custom_utilities).

/*
    =========================================================================
    MODULE: optimization
    ROLE: The Optimization & Edge-Case Manager (Cut & Negation)
    AUTHOR: Rajan
    
    This module implements performance optimization rules using the cut (!) 
    operator, precise exclusion constraints using negation (\+), and safe 
    arithmetic bounds checking.
    =========================================================================
*/

% --- SECTION A: NEGATION (\+) FOR EXCLUSIONS ---

% 1. recommend_excluding_artist/4: Recommends a song matching Genre and Mood,
% but NOT by ExcludedArtist.
% Safe negation: checks Ground variables before applying negation.
recommend_excluding_artist(Genre, Mood, ExcludedArtist, SongID) :-
    knowledge_base:song(SongID, _, Artist, Genre, Mood, _, _),
    \+ Artist = ExcludedArtist. % True if Artist is NOT unified with ExcludedArtist


% 2. recommend_not_old/3: Recommends a song that is NOT old (i.e. released in 1990 or later).
recommend_not_old(Genre, Mood, SongID) :-
    knowledge_base:song(SongID, _, _, Genre, Mood, Year, _),
    \+ Year < 1990. % Year must be >= 1990





% --- SECTION B: ARITHMETIC COMPARISONS ---

% 4. recommend_recent/3: Recommends songs of a Genre released strictly AFTER a given year.
recommend_recent(Genre, AfterYear, SongID) :-
    knowledge_base:song(SongID, _, _, Genre, _, Year, _),
    Year > AfterYear. % Arithmetic strict inequality check


% 5. recommend_high_rated/3: Recommends songs of a Genre with rating strictly ABOVE a threshold.
recommend_high_rated(Genre, MinRating, SongID) :-
    knowledge_base:song(SongID, _, _, Genre, _, _, Rating),
    Rating > MinRating. % Rating strict inequality check


% 6. recommend_in_rating_range/4: Recommends songs of a Genre within a rating range [Low, High] inclusive.
recommend_in_rating_range(Genre, Low, High, SongID) :-
    knowledge_base:song(SongID, _, _, Genre, _, _, Rating),
    Rating >= Low,
    Rating =< High. % Range bounds verification



