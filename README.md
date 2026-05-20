# Prolog Music Recommendation System

A logic-based, modular music recommendation engine designed as a group project representing 5 distinct engineering roles. The system parses pseudo-natural language queries, filters recommendations via safety and rating bounds, and sorts findings using custom algorithms without built-in Prolog list predicates.

## Modular Architecture

The project is split into 5 core modules corresponding to the team roles:

1. **[knowledge_base.pl](file:///d:/Projects/music-recommendation/knowledge_base.pl) (The Knowledge Architect — Harikesh)**
   - Defines the data schema: `song(SongID, Title, Artist, Genre, Mood, ReleaseYear, Rating)`.
   - Includes 80 formatted facts spanning rock, pop, classical, rap, and blues, with ratings represented as floats for realistic filtering.
2. **[custom_utilities.pl](file:///d:/Projects/music-recommendation/custom_utilities.pl) (Custom Utilities Engineer — Abhijeet)**
   - Re-implements base list operations to ensure compliance with the minimal built-in predicates requirement: `my_member/2`, `my_append/3`, `my_length/2`, and `my_take/3`.
   - Contains custom recursive algorithms: `my_max_rating/2` and `my_min_rating/2`.
   - Features `my_insertion_sort/3` supporting Rating and ReleaseYear descending sorting.
3. **[core_rules.pl](file:///d:/Projects/music-recommendation/core_rules.pl) (The Core Rules Developer — Srinjal)**
   - Implements core database traversal algorithms (`all_songs/1`) recursively without built-ins.
   - Provides filtering predicates `recommend_by_mood/2` and `recommend_by_genre/2`.
   - Formulates the hybrid filtering cascade (`recommend_hybrid/3`).
4. **[optimization.pl](file:///d:/Projects/music-recommendation/optimization.pl) (Optimization & Edge-Case Manager — Rajan)**
   - Orchestrates cut (`!`) operations to prevent redundant backtracking.
   - Defines exclusion bounds using negation (`\+`) and rating thresholds.
5. **[integrator.pl](file:///d:/Projects/music-recommendation/integrator.pl) (Integrator & Interface Lead — Raj)**
   - Integrates all components using Prolog's module import systems.
   - Implements a natural language query parser to extract mood, genre, exclusions, recency, and rating criteria from query strings.
   - Coordinates the 3-level fallback recommendation cascade (Strict search, Relaxed Hybrid, Top Hits).
   - Exposes an interactive advisor CLI loop (`start/0`).

Additionally, testing logic is separated into **[testing.pl](file:///d:/Projects/music-recommendation/testing.pl)** (QA Test Module — Raj), which runs a comprehensive self-verifying test suite (`test_all/0`).

---

## How to Run

### 1. Interactive CLI Advisor

Start the interactive advisory command-line session:

```powershell
swipl -s integrator.pl -g start -t halt
```

### 2. Manual Prolog Query Shell

Load the integrator module inside the SWI-Prolog interpreter shell to run queries manually:

```powershell
swipl -s integrator.pl
```

Once inside the interpreter prompt, you can run custom query goals:

```prolog
% Query Bollywood songs released after 2015
?- suggest_music("suggest me a bollywood song after 2015", Recommendations).

% Query energetic rock music excluding Queen
?- suggest_music("I want energetic rock but not by Queen", Recommendations).
```

### 3. Automated QA Tests

Execute the self-verifying test suite directly from your terminal:

```powershell
swipl -s testing.pl -g test_all -t halt
```
