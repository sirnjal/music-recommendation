:- module(core_rules, [
    all_songs/1,
    recommend_by_mood/2,
    recommend_by_genre/2,
    collect_songs_by_criteria/3,
    recommend_hybrid/3
]).

:- use_module(knowledge_base).
:- use_module(custom_utilities).

/*
    =========================================================================
    MODULE: core_rules
    ROLE: The Core Rules Developer (Filtering Logic)
    AUTHOR: Srinjal
    
    This module implements the core filtering logic connecting users to songs.
    It compiles recommendation lists by traversing the database using recursion
    and custom utilities, completely avoiding built-in list predicates.
    
    Rule ordering is designed to match from most-specific to generic.
    =========================================================================
*/

% --- DATABASE TRAVERSAL ---

% all_songs/1: Recursively gathers all unique SongIDs from the database
% via backtracking and accumulators.
all_songs(SongIDs) :-
    all_songs_acc([], SongIDs).

all_songs_acc(Acc, SongIDs) :-
    knowledge_base:song(ID, _, _, _, _, _, _),
    \+ custom_utilities:my_member(ID, Acc),
    !, % Cut: committed to this new ID, recurse
    all_songs_acc([ID|Acc], SongIDs).
all_songs_acc(Acc, Acc). % Base case: no more new IDs found, return accumulator


% --- BASE FILTERING RULES ---

% recommend_by_mood/2: Recommends songs matching a specific mood.
recommend_by_mood(Mood, Songs) :-
    all_songs(All),
    filter_by_mood(All, Mood, Songs).

filter_by_mood([], _, []).
filter_by_mood([H|T], Mood, [H|Rest]) :-
    knowledge_base:song(H, _, _, _, Mood, _, _),
    !, % Cut: song matches the mood, keep it and proceed
    filter_by_mood(T, Mood, Rest).
filter_by_mood([_|T], Mood, Rest) :-
    filter_by_mood(T, Mood, Rest). % Skip if mood does not match


% recommend_by_genre/2: Recommends songs matching a specific genre.
recommend_by_genre(Genre, Songs) :-
    all_songs(All),
    filter_by_genre(All, Genre, Songs).

filter_by_genre([], _, []).
filter_by_genre([H|T], Genre, [H|Rest]) :-
    knowledge_base:song(H, _, _, Genre, _, _, _),
    !, % Cut: song matches the genre, keep it and proceed
    filter_by_genre(T, Genre, Rest).
filter_by_genre([_|T], Genre, Rest) :-
    filter_by_genre(T, Genre, Rest). % Skip if genre does not match





% --- COMPLEX & SPECIFIC FILTERS ---

% collect_songs_by_criteria/3: Filter songs dynamically by optional Genre and Mood.
collect_songs_by_criteria(Genre, Mood, Songs) :-
    all_songs(All),
    filter_by_criteria(All, Genre, Mood, Songs).

filter_by_criteria([], _, _, []).
filter_by_criteria([H|T], Genre, Mood, [H|Rest]) :-
    knowledge_base:song(H, _, _, G, M, _, _),
    match_criteria(Genre, Mood, G, M),
    !, % Cut: satisfies criteria, keep it
    filter_by_criteria(T, Genre, Mood, Rest).
filter_by_criteria([_|T], Genre, Mood, Rest) :-
    filter_by_criteria(T, Genre, Mood, Rest).

% Match criteria helpers (with cut for efficiency)
match_criteria(none, none, _, _) :- !, fail. % Empty criteria fails
match_criteria(Genre, none, G, _) :- !, Genre = G.
match_criteria(none, Mood, _, M) :- !, Mood = M.
match_criteria(Genre, Mood, G, M) :- !, Genre = G, Mood = M.


% recommend_hybrid/3: Main logic rule with logical ordering cascade.
% Triggers from most specific (Genre AND Mood) down to generic.
recommend_hybrid(Genre, Mood, Songs) :-
    Genre \= none, Mood \= none,
    collect_songs_by_criteria(Genre, Mood, Songs),
    custom_utilities:my_length(Songs, L), L > 0,
    !. % Specific exact match found
recommend_hybrid(Genre, _, Songs) :-
    Genre \= none,
    collect_songs_by_criteria(Genre, none, Songs),
    custom_utilities:my_length(Songs, L), L > 0,
    !. % Fallback: Genre match only
recommend_hybrid(_, Mood, Songs) :-
    Mood \= none,
    collect_songs_by_criteria(none, Mood, Songs),
    custom_utilities:my_length(Songs, L), L > 0,
    !. % Fallback: Mood match only
recommend_hybrid(_, _, []). % Fallback: No matches
