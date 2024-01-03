# Entertainment Database

The Entertainment database is designed to manage information about movies, TV shows, genres, studios, directors, actors, and cast members. It provides a structured schema to organize and query data related to the entertainment industry.

## Database Schema:

- **Genres**: Contains information about different genres.
- **Studios**: Stores details about production studios.
- **Directors**: Manages information about directors.
- **Actors**: Holds data about actors and actresses.
- **Movies**: Stores details about movies, including title, release date, genre, studio, and director.
- **TVShows**: Contains information about TV shows, similar to the Movies table.
- **RoleCast**: Represents the cast members and their roles in movies and TV shows.

## Sample Queries:

### 1. Top 3 Actors with Most Appearances:

```sql
SELECT ActorName, COUNT(*) AS TotalAppearances
FROM Actors
JOIN RoleCast ON Actors.ActorID = RoleCast.ActorID
GROUP BY ActorName
ORDER BY TotalAppearances DESC
LIMIT 3;
```

### 2. Titles with Cast Member Counts:

```sql
SELECT Title, COALESCE(MovieCastCount, 0) + COALESCE(TVShowCastCount, 0) AS TotalCastCount
FROM (
   SELECT Movies.Title, COUNT(*) AS MovieCastCount
   FROM Movies
   LEFT JOIN RoleCast ON Movies.MovieID = RoleCast.MovieID
   GROUP BY Movies.Title
) AS MovieCast
FULL JOIN (
   SELECT TVShows.Title, COUNT(*) AS TVShowCastCount
   FROM TVShows
   LEFT JOIN RoleCast ON TVShows.ShowID = RoleCast.ShowID
   GROUP BY TVShows.Title
) AS TVShowCast ON MovieCast.Title = TVShowCast.Title
ORDER BY TotalCastCount DESC;
```

### 3. Actors in Both Movies and TV Shows After 2000:

```sql
SELECT ActorName
FROM Actors
JOIN RoleCast ON Actors.ActorID = RoleCast.ActorID
JOIN Movies ON RoleCast.MovieID = Movies.MovieID AND Movies.ReleaseDate > '2000-01-01'
JOIN TVShows ON RoleCast.ShowID = TVShows.ShowID AND TVShows.ReleaseDate > '2000-01-01'
GROUP BY ActorName
HAVING COUNT(DISTINCT Movies.MovieID) > 0 AND COUNT(DISTINCT TVShows.ShowID) > 0;
```

### 4. Average Cast Members for Movies and TV Shows:

```sql
WITH MovieAvg AS (
   SELECT AVG(CAST(CastCount AS NUMERIC)) AS AvgCastMembers
   FROM (
      SELECT COUNT(RoleCast.ActorID) AS CastCount
      FROM Movies
      LEFT JOIN RoleCast ON Movies.MovieID = RoleCast.MovieID
      GROUP BY Movies.MovieID
   ) AS MovieCounts
),
TVShowAvg AS (
   SELECT AVG(CAST(CastCount AS NUMERIC)) AS AvgCastMembers
   FROM (
      SELECT COUNT(RoleCast.ActorID) AS CastCount
      FROM TVShows
      LEFT JOIN RoleCast ON TVShows.ShowID = RoleCast.ShowID
      GROUP BY TVShows.ShowID
   ) AS TVShowCounts
)
SELECT 'Movies' AS MediaType, ROUND(AvgCastMembers, 2) AS AvgCastMembers
FROM MovieAvg
UNION ALL
SELECT 'TV Shows' AS MediaType, ROUND(AvgCastMembers, 2) AS AvgCastMembers
FROM TVShowAvg;
```

### 5. Movies with at Least Two Genres:

```sql
SELECT Movies.Title, STRING_AGG(Genres.GenreName, ', ') AS MovieGenres
FROM Movies
JOIN Genres ON Movies.GenreID = Genres.GenreID
GROUP BY Movies.Title
HAVING COUNT(DISTINCT Genres.GenreID) >= 2;
```
