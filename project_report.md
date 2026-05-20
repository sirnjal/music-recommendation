# Prolog Music Recommendation System

## 1. Objectives

The primary objective of this project is to construct a modular, rule-based recommendation advisor in PROLOG that demonstrates:

- **Declarative Knowledge Modeling**: Representing domain facts (songs) as a logic database.
- **Backward Reasoning**: Applying PROLOG's backward chaining, resolution, and unification processes to satisfy multi-criteria recommendation goals.
- **Custom Algorithm Design**: Avoiding standard library list processing utilities to build sorting, searching, slicing, and comparison procedures recursively from scratch.
- **Search Tree Optimization**: Employing cuts (`!`) and negation-as-failure (`\+`) to optimize query execution and prevent infinite backtracking.
- **Natural Language Parsing**: Converting query strings to match criteria attributes.

---

## 2. Type of Recommendation System and criteria for recommendation

This system is classified as a **Rule-Based Knowledge-Directed Recommendation System**. It leverages logic rules to match users with items based on:

- **Genre Constraints**: Rock, Pop, Classical, Rap, Blues.
- **Mood Constraints**: Happy, Relaxed, Energetic, Melancholy, Romantic.
- **Recency Thresholds**: Filtering songs released before or after a given year.
- **Quality Metrics**: Comparing rating values (decimal floats from 1.0 to 5.0).
- **Session Exclusions**: Filtering out songs by excluded artists.
- **Special Keyword Filters**: Isolating `bollywood` (Indian) tracks, or excluding them.

---

## 3. Sample Questions that can be answered / What type of recommendations can be done.

The advisor handles various natural language inquiries by parsing them into structured PROLOG queries:

- **Query**: "Recommend energetic rock songs but not by Queen."

  * *Prolog Translation*: `suggest_music("I want energetic rock but not by Queen", Recs).`
  * *Answer*: Top-rated rock tracks marked as `energetic` where the artist is not unified with `'Queen'`, sorted in descending order of rating.
- **Query**: "Recommend highly rated pop songs released after 2015."

  * *Prolog Translation*: `suggest_music("pop music rating > 4.5 released after 2015", Recs).`
  * *Answer*: Pop songs released after 2015 with a rating of 4.5 or higher, sorted by rating.
- **Query**: "suggest me a bollywood song after 2015"

  * *Prolog Translation*: `suggest_music("suggest me a bollywood song after 2015", Recs).`
  * *Answer*: The parser detects the keyword `bollywood` and restricts matches to Indian Bollywood songs (`SongID` 61-80) released after 2015, sorted by rating.
- **Query**: "" (Empty Query)

  * *Prolog Translation*: `suggest_music("", Recs).`
  * *Answer*: The parser detects no explicit query terms and cascades to General Top Hits fallback (highest-rated songs).

---

## 4. Semantic Network indicating classes, objects, instances, hierarchy, properties, procedures with object-oriented interpretation

| Concept             | Prolog Equivalent  |
| :------------------ | :----------------- |
| **Class**     | Predicate group    |
| **Object**    | Fact instance      |
| **Method**    | Rule               |
| **Attribute** | Predicate argument |

### Object-Oriented Interpretation & Semantic Network

Prolog represents data declaratively. The conceptual structure maps to an object-oriented design as follows:

```
+------------------------------------+
|         Recommender Class          |
+------------------------------------+
| - suggest_music/2                  |
| - filter_all_songs/7               |
+-----------------+------------------+
                  |
                  | query/requests
                  v
+-----------------+------------------+
|             Song Class             |
+------------------------------------+
| - SongID (Integer)                 |
| - Title (String)                   |
| - Artist (Atom)                    |
| - Genre (Atom)                     |
| - Mood (Atom)                      |
| - ReleaseYear (Integer)            |
| - Rating (Float)                   |
+------------------------------------+
```

- **Class (Predicate Group)**: `song/7` represents the class definition schema.
- **Object Instance (Fact Instance)**: `song(1, 'Bohemian Rhapsody', 'Queen', rock, energetic, 1975, 4.9)` represents an instance of the class `song`.
- **Attribute (Predicate Argument)**: `SongID`, `Title`, `Artist`, `Genre`, `Mood`, `Year`, and `Rating` represent attributes of the object.
- **Method (Rule)**: `suggest_music/2` and `filter_all_songs/7` act as methods that manipulate and filter object instances.

---

## 5. Facts and Rules for criteria recommendation, Reasoning , Rule matches, how  does it work – Explained in systematic order, ordering of rules – how does it effect, use of recursion- if used, cut fail usage

### Facts and Rules Representation

The base database (`knowledge_base.pl`) stores facts describing songs:

```prolog
song(1, 'Bohemian Rhapsody', 'Queen', rock, energetic, 1975, 4.9).
```

### Unification and Resolution Logic (How does it work)

When the system receives a recommendation query, PROLOG uses backward chaining to prove the goals:

1. **Unification**: When resolving `suggest_music(Query, Output)`, PROLOG unifies the variables. `Query` is passed to the parser, generating ground or unground values for `Mood`, `Genre`, `ExcludedArtist`, `AfterYear`, `MinRating`, and `Bollywood`.
2. **Resolution Chaining**: PROLOG resolves `filter_all_songs/7` by recursively matching facts from the database. For each fact, it unifies the song arguments with the variables and checks constraints such as `Year > AfterYear`. If the condition fails, PROLOG backtracks, discards the bindings, and evaluates the next song fact.

### Rule Ordering Effects

In PROLOG, rule order determines selection priority. The system's recommendation cascade is ordered from specific to generic:

* **Priority 1**: Strict Query filter matching all parsed criteria (Genre, Mood, Year, Rating, Bollywood).
* **Priority 2**: Relaxed Query filter calling `core_rules:recommend_hybrid/3` which cascades from both (Genre AND Mood) down to individual Genre or Mood attributes if matches are scarce.
* **Priority 3**: General Top Hits fallback. Recommends overall highest-rated songs.

By ordering these clauses sequentially, the recommender attempts to satisfy the user's specific request first before falling back to generic rules.

### Use of Recursion

Recursion is used for list processing and database traversal:

- **Traversal**: Gathers all unique song IDs without using built-in aggregation:
  ```prolog
  all_songs(SongIDs) :- all_songs_acc([], SongIDs).
  all_songs_acc(Acc, SongIDs) :-
      song(ID, _, _, _, _, _, _),
      \+ my_member(ID, Acc), !,
      all_songs_acc([ID|Acc], SongIDs).
  all_songs_acc(Acc, Acc).
  ```
- **Custom Sorting**: `my_insertion_sort/3` sorts the list in descending order by rating:
  ```prolog
  my_insertion_sort(_, [], []).
  my_insertion_sort(Criteria, [H|T], Sorted) :-
      my_insertion_sort(Criteria, T, SortedTail),
      insert_by_criteria(Criteria, H, SortedTail, Sorted).
  ```

### Cut (`!`) and Fail (`fail`) Usage

- **The Cut (`!`)**: Commits PROLOG to all choices made since the parent goal was unified, pruning other backtracking branches. It is used in:
  - `recommend_hybrid/3` to stop searching fallbacks once a higher-priority match group is resolved.
  - Sorting and list traversal helpers to commit to insertions and accumulator paths.
- **The Fail (`fail`)**: Triggers immediate backtracking. Combined with the cut, it creates negation-as-failure or blocks unwanted selections.

---

## 6. Possible Enhancements

1. **Weighted Matching**: Score candidate songs by assigning weights (e.g. +2.0 for matching genre, +1.5 for matching mood) rather than applying strict boolean filters.
2. **Persistent Storage Connectors**: Connect the Prolog runtime with SQLite or JSON databases to support large dynamic datasets.
3. **Advanced Natural Language Processing**: Implement a parser using Definite Clause Grammars (DCGs) to parse complex query grammar structures.
