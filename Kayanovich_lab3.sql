USE master;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'BikeRental')
BEGIN
    ALTER DATABASE BikeRental SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BikeRental;
END;
GO

CREATE DATABASE BikeRental;
GO

USE BikeRental;
GO

-- пункт 1

CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    FullName NVARCHAR(100),
    Rating FLOAT
) AS NODE;

CREATE TABLE Bikes (
    BikeID INT PRIMARY KEY,
    Model NVARCHAR(100),
    Condition NVARCHAR(50)
) AS NODE;

CREATE TABLE Stations (
    StationID INT PRIMARY KEY,
    StationName NVARCHAR(100),
    Capacity INT
) AS NODE;

-- пункт 2

CREATE TABLE Rented (
    RentalDate DATE,
    DurationMinutes INT,
    CONSTRAINT EC_Rented CONNECTION (Users TO Bikes)
) AS EDGE;

CREATE TABLE ParkedAt (
    ParkDate DATE,
    Status NVARCHAR(50),
    CONSTRAINT EC_ParkedAt CONNECTION (Bikes TO Stations)
) AS EDGE;

CREATE TABLE RouteTo (
    DistanceKm FLOAT,
    EstimatedTimeMinutes INT,
    CONSTRAINT EC_RouteTo CONNECTION (Stations TO Stations)
) AS EDGE;

-- пункт 3

INSERT INTO Users (UserID, FullName, Rating) VALUES
(1, 'Иван Иванов', 4.8), (2, 'Анна Смирнова', 5.0), (3, 'Петр Петров', 4.2),
(4, 'Елена Соколова', 4.9), (5, 'Дмитрий Волков', 3.5), (6, 'Ольга Новикова', 4.7),
(7, 'Сергей Морозов', 4.1), (8, 'Мария Лебедева', 5.0), (9, 'Алексей Козлов', 4.4),
(10, 'Наталья Ильина', 4.6);

INSERT INTO Bikes (BikeID, Model, Condition) VALUES
(1, 'City Cruiser', 'Good'), (2, 'Mountain Explorer', 'Excellent'), (3, 'City Cruiser', 'Fair'),
(4, 'Speedster Pro', 'Good'), (5, 'Mountain Explorer', 'Good'), (6, 'City Cruiser', 'Excellent'),
(7, 'EcoBike', 'Fair'), (8, 'Speedster Pro', 'Good'), (9, 'EcoBike', 'Excellent'),
(10, 'Mountain Explorer', 'Needs Maintenance');

INSERT INTO Stations (StationID, StationName, Capacity) VALUES
(1, 'Центральная площадь', 20), (2, 'Парк Горького', 50), (3, 'Метро Университет', 15),
(4, 'ТЦ Галерея', 30), (5, 'Набережная', 40), (6, 'Спортивный комплекс', 25),
(7, 'Библиотека', 10), (8, 'Бизнес-центр', 35), (9, 'Северный вокзал', 45),
(10, 'Южный парк', 20);

-- пункт 4

INSERT INTO Rented ($from_id, $to_id, RentalDate, DurationMinutes)
SELECT u.$node_id, b.$node_id, '2023-10-01', 45 FROM Users u, Bikes b WHERE u.UserID = 1 AND b.BikeID = 1;
INSERT INTO Rented ($from_id, $to_id, RentalDate, DurationMinutes)
SELECT u.$node_id, b.$node_id, '2023-10-02', 120 FROM Users u, Bikes b WHERE u.UserID = 2 AND b.BikeID = 2;
INSERT INTO Rented ($from_id, $to_id, RentalDate, DurationMinutes)
SELECT u.$node_id, b.$node_id, '2023-10-03', 30 FROM Users u, Bikes b WHERE u.UserID = 3 AND b.BikeID = 3;
INSERT INTO Rented ($from_id, $to_id, RentalDate, DurationMinutes)
SELECT u.$node_id, b.$node_id, '2023-10-04', 60 FROM Users u, Bikes b WHERE u.UserID = 4 AND b.BikeID = 4;
INSERT INTO Rented ($from_id, $to_id, RentalDate, DurationMinutes)
SELECT u.$node_id, b.$node_id, '2023-10-05', 90 FROM Users u, Bikes b WHERE u.UserID = 5 AND b.BikeID = 5;
INSERT INTO Rented ($from_id, $to_id, RentalDate, DurationMinutes)
SELECT u.$node_id, b.$node_id, '2023-10-06', 20 FROM Users u, Bikes b WHERE u.UserID = 6 AND b.BikeID = 6;
INSERT INTO Rented ($from_id, $to_id, RentalDate, DurationMinutes)
SELECT u.$node_id, b.$node_id, '2023-10-07', 45 FROM Users u, Bikes b WHERE u.UserID = 7 AND b.BikeID = 7;
INSERT INTO Rented ($from_id, $to_id, RentalDate, DurationMinutes)
SELECT u.$node_id, b.$node_id, '2023-10-08', 150 FROM Users u, Bikes b WHERE u.UserID = 8 AND b.BikeID = 8;
INSERT INTO Rented ($from_id, $to_id, RentalDate, DurationMinutes)
SELECT u.$node_id, b.$node_id, '2023-10-09', 10 FROM Users u, Bikes b WHERE u.UserID = 1 AND b.BikeID = 9; 
INSERT INTO Rented ($from_id, $to_id, RentalDate, DurationMinutes)
SELECT u.$node_id, b.$node_id, '2023-10-10', 55 FROM Users u, Bikes b WHERE u.UserID = 10 AND b.BikeID = 10;

INSERT INTO ParkedAt ($from_id, $to_id, ParkDate, Status)
SELECT b.$node_id, s.$node_id, '2023-10-01', 'Locked' FROM Bikes b, Stations s WHERE b.BikeID = 1 AND s.StationID = 2;
INSERT INTO ParkedAt ($from_id, $to_id, ParkDate, Status)
SELECT b.$node_id, s.$node_id, '2023-10-02', 'Locked' FROM Bikes b, Stations s WHERE b.BikeID = 2 AND s.StationID = 3;
INSERT INTO ParkedAt ($from_id, $to_id, ParkDate, Status)
SELECT b.$node_id, s.$node_id, '2023-10-03', 'Locked' FROM Bikes b, Stations s WHERE b.BikeID = 3 AND s.StationID = 4;
INSERT INTO ParkedAt ($from_id, $to_id, ParkDate, Status)
SELECT b.$node_id, s.$node_id, '2023-10-04', 'Locked' FROM Bikes b, Stations s WHERE b.BikeID = 4 AND s.StationID = 5;
INSERT INTO ParkedAt ($from_id, $to_id, ParkDate, Status)
SELECT b.$node_id, s.$node_id, '2023-10-05', 'Charging' FROM Bikes b, Stations s WHERE b.BikeID = 5 AND s.StationID = 6;
INSERT INTO ParkedAt ($from_id, $to_id, ParkDate, Status)
SELECT b.$node_id, s.$node_id, '2023-10-06', 'Locked' FROM Bikes b, Stations s WHERE b.BikeID = 6 AND s.StationID = 7;
INSERT INTO ParkedAt ($from_id, $to_id, ParkDate, Status)
SELECT b.$node_id, s.$node_id, '2023-10-07', 'Locked' FROM Bikes b, Stations s WHERE b.BikeID = 7 AND s.StationID = 8;
INSERT INTO ParkedAt ($from_id, $to_id, ParkDate, Status)
SELECT b.$node_id, s.$node_id, '2023-10-08', 'Locked' FROM Bikes b, Stations s WHERE b.BikeID = 8 AND s.StationID = 9;
INSERT INTO ParkedAt ($from_id, $to_id, ParkDate, Status)
SELECT b.$node_id, s.$node_id, '2023-10-09', 'Locked' FROM Bikes b, Stations s WHERE b.BikeID = 9 AND s.StationID = 10;
INSERT INTO ParkedAt ($from_id, $to_id, ParkDate, Status)
SELECT b.$node_id, s.$node_id, '2023-10-10', 'Broken' FROM Bikes b, Stations s WHERE b.BikeID = 10 AND s.StationID = 1;


INSERT INTO RouteTo ($from_id, $to_id, DistanceKm, EstimatedTimeMinutes)
SELECT s1.$node_id, s2.$node_id, 2.5, 10 FROM Stations s1, Stations s2 WHERE s1.StationID = 1 AND s2.StationID = 2;
INSERT INTO RouteTo ($from_id, $to_id, DistanceKm, EstimatedTimeMinutes)
SELECT s1.$node_id, s2.$node_id, 2.5, 10 FROM Stations s1, Stations s2 WHERE s1.StationID = 2 AND s2.StationID = 1;

INSERT INTO RouteTo ($from_id, $to_id, DistanceKm, EstimatedTimeMinutes)
SELECT s1.$node_id, s2.$node_id, 3.0, 15 FROM Stations s1, Stations s2 WHERE s1.StationID = 2 AND s2.StationID = 3;
INSERT INTO RouteTo ($from_id, $to_id, DistanceKm, EstimatedTimeMinutes)
SELECT s1.$node_id, s2.$node_id, 3.0, 15 FROM Stations s1, Stations s2 WHERE s1.StationID = 3 AND s2.StationID = 2;

INSERT INTO RouteTo ($from_id, $to_id, DistanceKm, EstimatedTimeMinutes)
SELECT s1.$node_id, s2.$node_id, 1.5, 7 FROM Stations s1, Stations s2 WHERE s1.StationID = 3 AND s2.StationID = 4;
INSERT INTO RouteTo ($from_id, $to_id, DistanceKm, EstimatedTimeMinutes)
SELECT s1.$node_id, s2.$node_id, 1.5, 7 FROM Stations s1, Stations s2 WHERE s1.StationID = 4 AND s2.StationID = 3;

INSERT INTO RouteTo ($from_id, $to_id, DistanceKm, EstimatedTimeMinutes)
SELECT s1.$node_id, s2.$node_id, 4.0, 20 FROM Stations s1, Stations s2 WHERE s1.StationID = 4 AND s2.StationID = 5;
INSERT INTO RouteTo ($from_id, $to_id, DistanceKm, EstimatedTimeMinutes)
SELECT s1.$node_id, s2.$node_id, 4.0, 20 FROM Stations s1, Stations s2 WHERE s1.StationID = 5 AND s2.StationID = 4;

INSERT INTO RouteTo ($from_id, $to_id, DistanceKm, EstimatedTimeMinutes)
SELECT s1.$node_id, s2.$node_id, 3.5, 15 FROM Stations s1, Stations s2 WHERE s1.StationID = 1 AND s2.StationID = 6;
INSERT INTO RouteTo ($from_id, $to_id, DistanceKm, EstimatedTimeMinutes)
SELECT s1.$node_id, s2.$node_id, 3.5, 15 FROM Stations s1, Stations s2 WHERE s1.StationID = 6 AND s2.StationID = 1;

INSERT INTO RouteTo ($from_id, $to_id, DistanceKm, EstimatedTimeMinutes)
SELECT s1.$node_id, s2.$node_id, 2.0, 10 FROM Stations s1, Stations s2 WHERE s1.StationID = 6 AND s2.StationID = 5;
INSERT INTO RouteTo ($from_id, $to_id, DistanceKm, EstimatedTimeMinutes)
SELECT s1.$node_id, s2.$node_id, 2.0, 10 FROM Stations s1, Stations s2 WHERE s1.StationID = 5 AND s2.StationID = 6;

INSERT INTO RouteTo ($from_id, $to_id, DistanceKm, EstimatedTimeMinutes)
SELECT s1.$node_id, s2.$node_id, 5.0, 25 FROM Stations s1, Stations s2 WHERE s1.StationID = 2 AND s2.StationID = 8;
INSERT INTO RouteTo ($from_id, $to_id, DistanceKm, EstimatedTimeMinutes)
SELECT s1.$node_id, s2.$node_id, 5.0, 25 FROM Stations s1, Stations s2 WHERE s1.StationID = 8 AND s2.StationID = 2;

INSERT INTO RouteTo ($from_id, $to_id, DistanceKm, EstimatedTimeMinutes)
SELECT s1.$node_id, s2.$node_id, 1.0, 5 FROM Stations s1, Stations s2 WHERE s1.StationID = 8 AND s2.StationID = 9;
INSERT INTO RouteTo ($from_id, $to_id, DistanceKm, EstimatedTimeMinutes)
SELECT s1.$node_id, s2.$node_id, 1.0, 5 FROM Stations s1, Stations s2 WHERE s1.StationID = 9 AND s2.StationID = 8;

INSERT INTO RouteTo ($from_id, $to_id, DistanceKm, EstimatedTimeMinutes)
SELECT s1.$node_id, s2.$node_id, 2.5, 12 FROM Stations s1, Stations s2 WHERE s1.StationID = 9 AND s2.StationID = 10;
INSERT INTO RouteTo ($from_id, $to_id, DistanceKm, EstimatedTimeMinutes)
SELECT s1.$node_id, s2.$node_id, 2.5, 12 FROM Stations s1, Stations s2 WHERE s1.StationID = 10 AND s2.StationID = 9;

-- пункт 5

-- Найти, на каких станциях сейчас припаркованы велосипеды, которые арендовал "Иван Иванов" 
-- Цепочка: User -> Rented -> Bike -> ParkedAt -> Station
SELECT u.FullName, b.Model, s.StationName, p.ParkDate
FROM Users u, Rented r, Bikes b, ParkedAt p, Stations s
WHERE MATCH(u-(r)->b-(p)->s)
  AND u.FullName = 'Иван Иванов';

-- Найти всех пользователей, чьи арендованные велосипеды припаркованы на станции "Набережная"
-- Цепочка: User -> Rented -> Bike -> ParkedAt -> Station
SELECT u.FullName, b.Model, r.RentalDate
FROM Users u, Rented r, Bikes b, ParkedAt p, Stations s
WHERE MATCH(u-(r)->b-(p)->s)
  AND s.StationName = 'Набережная';

-- Найти все станции, доступные напрямую (1 переезд) от станции, где припаркован велосипед "Mountain Explorer", арендованный Анной Смирновой
-- Цепочка: User -> Rented -> Bike -> ParkedAt -> Station -> RouteTo -> Station
SELECT u.FullName, b.Model, StartStation.StationName AS ParkedAt, EndStation.StationName AS ReachableStation
FROM Users u, Rented r, Bikes b, ParkedAt p, Stations StartStation, RouteTo rt, Stations EndStation
WHERE MATCH(u-(r)->b-(p)->StartStation-(rt)->EndStation)
  AND u.FullName = 'Анна Смирнова' 
  AND b.Model = 'Mountain Explorer';

-- Найти пары пользователей, которые арендовали разные велосипеды, но припарковали их на одной и той же станции
-- Цепочка: User1 -> Rented -> Bike1 -> ParkedAt -> Station <- ParkedAt <- Bike2 <- Rented <- User2
SELECT 
    u1.FullName AS User1, 
    b1.Model AS Bike1, 
    s.StationName AS SharedStation, 
    b2.Model AS Bike2, 
    u2.FullName AS User2
FROM 
    Users u1, Rented r1, Bikes b1, ParkedAt p1, Stations s,
    ParkedAt p2, Bikes b2, Rented r2, Users u2
WHERE 
    MATCH(u1-(r1)->b1-(p1)->s<-(p2)-b2<-(r2)-u2)
    AND u1.UserID < u2.UserID; 

-- Найти пользователей, чьи велосипеды стоят на станциях, от которых есть маршруты длиннее 3 км
-- Цепочка: User -> Rented -> Bike -> ParkedAt -> Station -> RouteTo -> Station
SELECT DISTINCT u.FullName, s1.StationName AS CurrentStation, rt.DistanceKm, s2.StationName AS NextStation
FROM Users u, Rented r, Bikes b, ParkedAt p, Stations s1, RouteTo rt, Stations s2
WHERE MATCH(u-(r)->b-(p)->s1-(rt)->s2)
  AND rt.DistanceKm > 3.0;

  -- пункт 6

  -- Поиск любого кратчайшего пути от 'Центральная площадь' до 'Набережная' с использованием шаблона '+' (1 и более шагов)

-- Запрос 1: шаблон + (через CTE для фильтрации конечного узла)

WITH PathCTE AS (
    SELECT
        S1.StationName AS StartStation,
        STRING_AGG(S2.StationName, ' -> ')
            WITHIN GROUP (GRAPH PATH)       AS RoutePath,
        LAST_VALUE(S2.StationName)
            WITHIN GROUP (GRAPH PATH)       AS EndStation,
        COUNT(S2.StationName)
            WITHIN GROUP (GRAPH PATH)       AS NumberOfHops,
        SUM(rt.DistanceKm)
            WITHIN GROUP (GRAPH PATH)       AS TotalDistanceKm
    FROM
        Stations AS S1,
        RouteTo FOR PATH AS rt,
        Stations FOR PATH AS S2
    WHERE
        MATCH(SHORTEST_PATH(S1(-(rt)->S2)+))
        AND S1.StationName = 'Центральная площадь'
)
SELECT
    StartStation,
    StartStation + ' -> ' + RoutePath   AS FullPath,
    EndStation,
    NumberOfHops,
    TotalDistanceKm
FROM PathCTE
WHERE EndStation = 'Набережная';

-- Запрос 2: шаблон {1,5} — пути длиной от 1 до 5 шагов от любой станции
WITH PathCTE AS (
    SELECT
        S1.StationName                          AS StartStation,
        STRING_AGG(S2.StationName, ' -> ')
            WITHIN GROUP (GRAPH PATH)           AS IntermediateNodes,
        LAST_VALUE(S2.StationName)
            WITHIN GROUP (GRAPH PATH)           AS EndStation,
        COUNT(S2.StationName)
            WITHIN GROUP (GRAPH PATH)           AS NumberOfHops,
        SUM(rt.EstimatedTimeMinutes)
            WITHIN GROUP (GRAPH PATH)           AS TotalTimeMinutes
    FROM
        Stations AS S1,
        RouteTo FOR PATH AS rt,
        Stations FOR PATH AS S2
    WHERE
        MATCH(SHORTEST_PATH(S1(-(rt)->S2){1,5}))
)
SELECT
    StartStation,
    StartStation + ' -> ' + IntermediateNodes  AS FullPath,
    EndStation,
    NumberOfHops,
    TotalTimeMinutes
FROM PathCTE
ORDER BY
    StartStation,
    NumberOfHops;
