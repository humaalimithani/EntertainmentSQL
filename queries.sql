-- Find the top 3 actors who have appeared in the most movies and TV shows combined, along with the total count:

SELECT ActorName, COUNT(*) AS TotalAppearances
FROM Actors
JOIN RoleCast ON Actors.ActorID = RoleCast.ActorID
GROUP BY ActorName
ORDER BY TotalAppearances DESC
LIMIT 3;

-- Retrieve the titles of movies and TV shows along with the number of cast members for each (sorted in descending order of cast count):

SELECT Title, SUM(CastCount) AS TotalCastCount
FROM (
    SELECT Movies.Title, COUNT(*) AS CastCount
    FROM Movies
    LEFT JOIN RoleCast ON Movies.MovieID = RoleCast.MovieID
    GROUP BY Movies.Title
    UNION ALL
    SELECT TVShows.Title, COUNT(*) AS CastCount
    FROM TVShows
    LEFT JOIN RoleCast ON TVShows.ShowID = RoleCast.ShowID
    GROUP BY TVShows.Title
) AS CombinedCast
GROUP BY Title
ORDER BY TotalCastCount DESC;

-- Identify actors who have appeared in both movies and TV shows released after the year 2000:

SELECT ActorName
FROM Actors
JOIN RoleCast ON Actors.ActorID = RoleCast.ActorID
JOIN Movies ON RoleCast.MovieID = Movies.MovieID AND Movies.ReleaseDate > '2000-01-01'
JOIN TVShows ON RoleCast.ShowID = TVShows.ShowID AND TVShows.ReleaseDate > '2000-01-01'
GROUP BY ActorName
HAVING COUNT(DISTINCT Movies.MovieID) > 0 AND COUNT(DISTINCT TVShows.ShowID) > 0;

-- Calculate the average number of cast members for movies and TV shows separately, rounded to two decimal places:

SELECT 'Movies' AS MediaType, ROUND(AVG(CAST(CastCount AS NUMERIC)), 2) AS AvgCastMembers
FROM (
    SELECT COUNT(RoleCast.ActorID) AS CastCount
    FROM Movies
    LEFT JOIN RoleCast ON Movies.MovieID = RoleCast.MovieID
    GROUP BY Movies.MovieID
) AS MovieCounts
UNION ALL
SELECT 'TV Shows' AS MediaType, ROUND(AVG(CAST(CastCount AS NUMERIC)), 2) AS AvgCastMembers
FROM (
    SELECT COUNT(RoleCast.ActorID) AS CastCount
    FROM TVShows
    LEFT JOIN RoleCast ON TVShows.ShowID = RoleCast.ShowID
    GROUP BY TVShows.ShowID
) AS TVShowCounts;

-- Retrieve the titles of movies that have at least two genres, and list those genres:

SELECT Movies.Title, STRING_AGG(Genres.GenreName, ', ') AS MovieGenres
FROM Movies
JOIN Genres ON Movies.GenreID = Genres.GenreID
GROUP BY Movies.Title
HAVING COUNT(DISTINCT Genres.GenreID) >= 2;
