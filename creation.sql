-- Create a table for genres
CREATE TABLE Genres (
    GenreID SERIAL PRIMARY KEY,
    GenreName VARCHAR(50) NOT NULL
);

-- Create a table for studios
CREATE TABLE Studios (
    StudioID SERIAL PRIMARY KEY,
    StudioName VARCHAR(50) NOT NULL
);

-- Create a table for directors
CREATE TABLE Directors (
    DirectorID SERIAL PRIMARY KEY,
    DirectorName VARCHAR(50) NOT NULL
);

-- Create a table for actors/actresses
CREATE TABLE Actors (
    ActorID SERIAL PRIMARY KEY,
    ActorName VARCHAR(50) NOT NULL
);

-- Create a table for movies
CREATE TABLE Movies (
    MovieID SERIAL PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    ReleaseDate DATE,
    GenreID INT REFERENCES Genres(GenreID),
    StudioID INT REFERENCES Studios(StudioID),
    DirectorID INT REFERENCES Directors(DirectorID)
);

-- Create a table for TV shows
CREATE TABLE TVShows (
    ShowID SERIAL PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    ReleaseDate DATE,
    GenreID INT REFERENCES Genres(GenreID),
    StudioID INT REFERENCES Studios(StudioID),
    DirectorID INT REFERENCES Directors(DirectorID)
);

-- Create a table for cast members
CREATE TABLE RoleCast (
    CastID SERIAL PRIMARY KEY,
    MovieID INT REFERENCES Movies(MovieID),
    ShowID INT REFERENCES TVShows(ShowID),
    ActorID INT REFERENCES Actors(ActorID),
    Role VARCHAR(50) NOT NULL
);

-- Insert sample data into Genres table
INSERT INTO Genres (GenreName) VALUES
('Action'),
('Drama'),
('Comedy'),
('Science Fiction'),
('Thriller');

-- Insert sample data into Studios table
INSERT INTO Studios (StudioName) VALUES
('Paramount Pictures'),
('Warner Bros. Pictures'),
('Universal Pictures'),
('20th Century Studios');

-- Insert sample data into Directors table
INSERT INTO Directors (DirectorName) VALUES
('Christopher Nolan'),
('Steven Spielberg'),
('Quentin Tarantino'),
('Greta Gerwig');

-- Insert sample data into Actors table
INSERT INTO Actors (ActorName) VALUES
('Tom Hanks'),
('Scarlett Johansson'),
('Leonardo DiCaprio'),
('Jennifer Lawrence');

-- Insert sample data into Movies table
INSERT INTO Movies (Title, ReleaseDate, GenreID, StudioID, DirectorID) VALUES
('Inception', '2010-07-16', 4, 1, 1),
('The Shawshank Redemption', '1994-09-23', 2, 2, 2),
('Pulp Fiction', '1994-10-14', 3, 3, 3);

-- Insert sample data into TVShows table
INSERT INTO TVShows (Title, ReleaseDate, GenreID, StudioID, DirectorID) VALUES
('Stranger Things', '2016-07-15', 4, 4, 4),
('Breaking Bad', '2008-01-20', 1, 1, 1),
('Friends', '1994-09-22', 3, 2, 2);

-- Insert sample data into RoleCast table
INSERT INTO RoleCast (MovieID, ShowID, ActorID, Role) VALUES
(1, NULL, 1, 'Cobb'),
(2, NULL, 2, 'Andy Dufresne'),
(3, NULL, 3, 'Vincent Vega'),
(NULL, 1, 4, 'Eleven'),
(NULL, 2, 1, 'Walter White'),
(NULL, 3, 2, 'Rachel Green');