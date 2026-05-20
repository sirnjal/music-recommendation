:- module(custom_utilities, [
    my_member/2,
    my_append/3,
    my_length/2,
    my_take/3,
    my_max_rating/2,
    my_min_rating/2,
    my_insertion_sort/3
]).

:- use_module(knowledge_base).

/*
    =========================================================================
    MODULE: custom_utilities
    ROLE: Custom Utilities Engineer (Algorithms)
    AUTHOR: Abhijeet
    
    This module implements custom list processing, arithmetic min/max
    finders, and a custom insertion sort algorithm. Built-in Prolog list
    predicates are avoided to comply with the minimal built-in rules.
    =========================================================================
*/

% 1. my_member/2: Check if X is a member of the list.
% Base case: X is the head of the list.
my_member(X, [X|_]).
% Recursive case: X is in the tail of the list.
my_member(X, [_|T]) :-
    my_member(X, T).


% 2. my_append/3: Append two lists L1 and L2 to form Result.
% Base case: Appending empty list to L returns L.
my_append([], L, L).
% Recursive case: Keep head H of first list and append its tail T to L2.
my_append([H|T], L2, [H|Result]) :-
    my_append(T, L2, Result).


% 3. my_length/2: Find the length of a list.
% Base case: Empty list has length 0.
my_length([], 0).
% Recursive case: Walk down tail, increment length count by 1 on backtrack.
my_length([_|T], Len) :-
    my_length(T, Len1),
    Len is Len1 + 1.


% 4. my_take/3: Extract the first N elements of a list.
% Base case 1: Taking 0 elements yields empty list (cut prevents further tries).
my_take(0, _, []) :- !.
% Base case 2: Taking from an empty list yields empty list.
my_take(_, [], []) :- !.
% Recursive case: Keep head H and take N-1 elements from tail T.
my_take(N, [H|T], [H|Rest]) :-
    N > 0,
    N1 is N - 1,
    my_take(N1, T, Rest).


% 5. my_max_rating/2: Find the SongID with the maximum rating in a list of SongIDs.
% Public interface: uses accumulator max_rating_acc/4.
my_max_rating([H|T], MaxID) :-
    knowledge_base:song(H, _, _, _, _, _, R),
    max_rating_acc(T, H, R, MaxID).

% Base case: no more elements to compare.
max_rating_acc([], CurrentMaxID, _, CurrentMaxID).
% Recursive case: if current head H rating R is greater than CurrentMaxVal, update accumulator.
max_rating_acc([H|T], _, CurrentMaxVal, MaxID) :-
    knowledge_base:song(H, _, _, _, _, _, R),
    R > CurrentMaxVal,
    !, % Cut: committed to this new maximum rating
    max_rating_acc(T, H, R, MaxID).
% Recursive case: otherwise, retain current accumulator.
max_rating_acc([_|T], CurrentMaxID, CurrentMaxVal, MaxID) :-
    max_rating_acc(T, CurrentMaxID, CurrentMaxVal, MaxID).


% 6. my_min_rating/2: Find the SongID with the minimum rating in a list of SongIDs.
% Public interface: uses accumulator min_rating_acc/4.
my_min_rating([H|T], MinID) :-
    knowledge_base:song(H, _, _, _, _, _, R),
    min_rating_acc(T, H, R, MinID).

% Base case: no more elements to compare.
min_rating_acc([], CurrentMinID, _, CurrentMinID).
% Recursive case: if current head H rating R is less than CurrentMinVal, update accumulator.
min_rating_acc([H|T], _, CurrentMinVal, MinID) :-
    knowledge_base:song(H, _, _, _, _, _, R),
    R < CurrentMinVal,
    !, % Cut: committed to this new minimum rating
    min_rating_acc(T, H, R, MinID).
% Recursive case: otherwise, retain current accumulator.
min_rating_acc([_|T], CurrentMinID, CurrentMinVal, MinID) :-
    min_rating_acc(T, CurrentMinID, CurrentMinVal, MinID).


% 7. my_insertion_sort/3: Sort a list of SongIDs descending based on Criteria (rating | year).
% Base case: Empty list is sorted.
my_insertion_sort(_, [], []).
% Recursive case: Sort the tail, then insert the head in its correct place.
my_insertion_sort(Criteria, [H|T], Sorted) :-
    my_insertion_sort(Criteria, T, SortedTail),
    insert_by_criteria(Criteria, H, SortedTail, Sorted).

% Base case: Inserting X into empty list is [X].
insert_by_criteria(_, X, [], [X]) :- !.
% Recursive case: If X is greater/newer than the head H of the sorted list, insert X in front.
insert_by_criteria(Criteria, X, [H|T], [X, H|T]) :-
    compare_songs(Criteria, X, H, Result),
    Result >= 0,
    !. % Cut: committed to inserting at the front
% Recursive case: otherwise, keep H in front and insert X into the tail.
insert_by_criteria(Criteria, X, [H|T], [H|SortedTail]) :-
    insert_by_criteria(Criteria, X, T, SortedTail).

% Helper: Compare two SongIDs based on Rating or ReleaseYear.
% Returns Result > 0 if ID1 > ID2, 0 if equal, < 0 if ID1 < ID2.
compare_songs(rating, ID1, ID2, Result) :-
    knowledge_base:song(ID1, _, _, _, _, _, R1),
    knowledge_base:song(ID2, _, _, _, _, _, R2),
    Result is R1 - R2.
compare_songs(year, ID1, ID2, Result) :-
    knowledge_base:song(ID1, _, _, _, _, Y1, _),
    knowledge_base:song(ID2, _, _, _, _, Y2, _),
    Result is Y1 - Y2.
