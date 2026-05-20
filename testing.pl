:- module(testing, [
    test_all/0
]).

:- use_module(integrator).
:- use_module(optimization).

/*
    =========================================================================
    MODULE: testing
    ROLE: Quality Assurance & Test Runner
    AUTHOR: Raj
    
    This module contains the automated QA test suite for the Music 
    Recommendation System. It validates boundaries, keyword exclusions,
    arithmetic rating/year comparisons, and cascade fallbacks.
    =========================================================================
*/

test_all :-
    write('===================================================='), nl,
    write('      QA RUNNING MUSIC RECOMMENDATION SYSTEM        '), nl,
    write('===================================================='), nl,
    
    % Test 1: Bollywood Isolation (Inclusion Edge Case)
    write('[Test 1] Query: "suggest me a bollywood song after 2015"'), nl,
    integrator:suggest_music("suggest me a bollywood song after 2015", R1),
    integrator:show_recommendations(R1),
    
    % Test 2: Bollywood Exclusion (Exclusion Edge Case)
    write('[Test 2] Query: "highly rated pop music but not bollywood"'), nl,
    integrator:suggest_music("highly rated pop music but not bollywood", R2),
    integrator:show_recommendations(R2),
    
    % Test 3: Negation & Artist Exclusion
    write('[Test 3] Query: "energetic rock songs but not by Queen"'), nl,
    integrator:suggest_music("energetic rock songs but not by Queen", R3),
    integrator:show_recommendations(R3),
    
    % Test 4: Release Year Strict Inequality (Recency Bound)
    write('[Test 4] Query: "pop music released after 2020"'), nl,
    integrator:suggest_music("pop music released after 2020", R4),
    integrator:show_recommendations(R4),
    
    % Test 5: Quality Rating Boundary Check
    write('[Test 5] Query: "pop music rating > 4.7"'), nl,
    integrator:suggest_music("pop music rating > 4.7", R5),
    integrator:show_recommendations(R5),
    
    % Test 6: Non-Existent Criteria (Empty Candidates Fallback)
    write('[Test 6] Query: "blues music released after 2025"'), nl,
    integrator:suggest_music("blues music released after 2025", R6),
    integrator:show_recommendations(R6),
    
    % Test 7: Space Parsing and Case-Insensitivity
    write('[Test 7] Query: "  RoCk   mUsIc   bUt   NoT   qUeEn  "'), nl,
    integrator:suggest_music("  RoCk   mUsIc   bUt   NoT   qUeEn  ", R7),
    integrator:show_recommendations(R7),
    
    % Test 8: Unknown Genre/Mood Query (Graceful Fallback)
    write('[Test 8] Query: "suggest electronic happy song"'), nl,
    integrator:suggest_music("suggest electronic happy song", R8),
    integrator:show_recommendations(R8),

    % Test 9: Extremely High Rating Edge Check (rating >= 4.9)
    write('[Test 9] Query: "classical music rating > 4.8"'), nl,
    integrator:suggest_music("classical music rating > 4.8", R9),
    integrator:show_recommendations(R9),
    
    write('===================================================='), nl,
    write('                 TEST RUN COMPLETE                  '), nl,
    write('===================================================='), nl.
