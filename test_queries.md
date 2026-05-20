# Music Recommendation System - Edge Case Test Suite

Use these queries in the CLI advisor (`swipl -s integrator.pl -g start -t halt`) to test specific boundaries, logic cascades, negation constraints, and sorting correctness:

---

### Test Case 1: Bollywood Isolation (Inclusion Edge Case)
*   **Query**: `suggest me a bollywood song after 2015`
*   **Logical Goal**: Verifies that the Bollywood parser flag is resolved as `yes`. Checks that all international songs matching the year threshold (like "Blinding Lights") are excluded.
*   **Expected Output**: Contains only Indian/Bollywood songs (e.g. ID 73, 63, 61, 79) with release year > 2015.

### Test Case 2: Bollywood Exclusion (Exclusion Edge Case)
*   **Query**: `highly rated pop music but not bollywood`
*   **Logical Goal**: Tests the parser's negative keyword detection (`but not bollywood` -> `Bollywood = no`).
*   **Expected Output**: Contains only Western pop tracks (e.g. "Blinding Lights", "Perfect") and filters out Bollywood hits like "Tum Hi Ho".

### Test Case 3: Negation & Artist Exclusion
*   **Query**: `energetic rock songs but not by Queen`
*   **Logical Goal**: Verifies negation-as-failure (`\+ Artist = ExcludedArtist`).
*   **Expected Output**: Returns energetic rock songs like "In The End" by Linkin Park, but successfully excludes "Bohemian Rhapsody" (by Queen).

### Test Case 4: Release Year Strict Inequality (Recency Bound)
*   **Query**: `pop music released after 2020`
*   **Logical Goal**: Tests strict inequality `Year > 2020`.
*   **Expected Output**: Returns pop songs released in 2021 and 2022 (e.g. "Kesariya" and "Raatan Lambiyan"). Hits from 2020 (like "Blinding Lights") are excluded.

### Test Case 5: Quality Rating Boundary Check (Rating Bound)
*   **Query**: `pop music rating > 4.7`
*   **Logical Goal**: Tests the comparison check `Rating >= 4.7`.
*   **Expected Output**: Recommends pop songs with rating 4.8 or 4.9 (e.g. "Tum Hi Ho", "Kesariya", "Perfect"). Recommends nothing below 4.7.

### Test Case 6: Fallback Cascade Trigger
*   **Query**: `blues music released after 2025`
*   **Logical Goal**: Tests that when Level 1 query matches 0 candidates, it cascades to the General Top Hits fallback.
*   **Expected Output**: Resolves to Level 3 cascade and displays highest-rated songs in the database.

### Test Case 7: Case Insensitivity & Space Parsing
*   **Query**: `  RoCk   mUsIc   bUt   NoT   qUeEn  `
*   **Logical Goal**: Tests that leading/trailing whitespaces and case variations are parsed correctly by case-insensitive checks.
*   **Expected Output**: Matches Rock genre, Queen exclusion, and returns matching rock tracks successfully.
