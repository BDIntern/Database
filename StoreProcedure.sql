/** Insert into Hall Table **/
CREATE PROCEDURE insertHall (
	@name varchar(50),
	@capacity int,
	@addedBy varchar(50)
)
AS
BEGIN
	INSERT INTO Hall (Name, Capacity, AddedBy) VALUES (@name, @capacity, @addedBy)
END

/** Insert into User Table **/
CREATE PROCEDURE insertUser (
	@firstName varchar(50),
	@lastName varchar(50),
	@email varchar(50),
	@address varchar(50)
)
AS
BEGIN
	INSERT INTO Users VALUES(@firstName, @lastName, @email, @address)
END

CREATE PROCEDURE insertBook (
	@hallId int,
	@userId int,
	@bookedFor date,
	@startTime time(7),
	@endTime time(7)
	)
	
	AS
	BEGIN
	DECLARE @maxDate date
	SET @maxDate =  DATEADD(dd,7,getdate())
	DECLARE @bookedDuration DECIMAL
	SET @bookedDuration = DATEDIFF(ms,@startTime,@endTime)
	IF @bookedFor >= GETDATE() AND @bookedFor <= @maxDate
	BEGIN
		INSERT INTO Booking(HallId, UserId, BookedFor, BookedForTime, BookedToTime, BookedDuration) VALUES(@hallId, @userId, @bookedFor, @startTime, @endTime, @bookedDuration)
	END
	ELSE
	BEGIN
		PRINT 'Invalid booked date'
	END 
END

CREATE PROCEDURE selectFromBook
	AS
	BEGIN
 		select * from Book
END

CREATE PROCEDURE selectFromHall
	AS
	BEGIN
 		select * from Hall
END

CREATE PROCEDURE selectFromUsers
	AS
	BEGIN
 		select * from Users
END

CREATE PROCEDURE deleteBook (
	@bookId int
	)
	AS 
	BEGIN
		delete from Book where Id = @bookId
END

CREATE PROCEDURE deleteHall (
	@hallId int
	)
	AS
	BEGIN
		DELETE FROM Hall WHERE Id = @hallId
END

CREATE PROCEDURE deleteUsers (
	@userId int
	)
	AS
	BEGIN
		DELETE FROM Users WHERE Id = @userId
END

CREATE PROCEDURE selectHallHistory(
	@hallId int
	)
	AS
	BEGIN
		SELECT Hall.Name, Hall.Capacity, Booking.BookedFor, Booking.BookedOn, Booking.StartTime, Booking.EndTime, Users.FirstName, Users.LastName
		FROM ((Booking
		INNER JOIN Hall ON Booking.HallId = Hall.Id )
		INNER JOIN Users ON Booking.UserId = Users.Id ) where HallId=@hallId
END

CREATE PROCEDURE selectAllHistory
	AS
	BEGIN
		SELECT Hall.Name AS 'Hall Name', Booking.BookedFor As 'Booked For', Booking.BookedOn AS 'Booked On', Booking.BookedForTime AS 'Start Time', Booking.BookedToTime AS 'End Time', Users.FirstName AS 'First Name', Users.LastName AS 'Last Name'
		FROM ((Booking
		INNER JOIN Hall ON Booking.HallId = Hall.Id )
		INNER JOIN Users ON Booking.UserId = Users.Id )
	END

CREATE PROCEDURE updateHall(
	@name varchar(50),
	@capacity int,
	@updatedBy int,
	@Id int
	)
	AS
	BEGIN
		UPDATE Hall SET Name = @name, Capacity = @capacity, UpdatedOn = GETDATE(), updatedBy = @updatedBy WHERE Id = @Id
END

CREATE PROCEDURE updateUser(
	@id int,
	@firstName varchar(50),
	@lastName varchar(50),
	@email varchar(50),
	@address varchar(50)
	)
	AS
	BEGIN
		UPDATE Users SET FirstName = @firstName, LastName = @lastName, Email = @email, Address = @address where Id = @id
END

CREATE PROCEDURE updateBooking(
	@hallId int,
	@userId int,
	@bookedFor date,
	@startTime time(7),
	@endTime time(7),
	@updatedBy varchar(50)
)
	AS
	BEGIN
		UPDATE Booking SET HallId = @hallId, UserId = @userId, BookedFor = @bookedFor, BookedForTime = @startTime, BookedToTime = @endTime
	END

/** Adding constraint for booked date */
ALTER TABLE Booking
ADD CONSTRAINT CHK_Date CHECK (BookedFor>=GETDATE() AND BookedFor<=dateadd(dd,7,getdate()));

CREATE PROCEDURE selectBookingOnDay(
	@selectDate varchar(50)
)
AS
BEGIN
	SELECT Hall.Name AS 'Hall Name', Users.FirstName AS 'First Name', Users.LastName AS 'Last Name', Booking.BookedFor AS 'Booked For', Booking.BookedOn AS 'Booked On', convert(varchar, Booking.BookedForTime, 108) AS 'Start Time', convert(varchar, Booking.BookedToTime, 108) AS 'End Time'
	FROM ((Booking
		INNER JOIN Hall ON Booking.HallId = Hall.Id )
		INNER JOIN Users ON Booking.UserId = Users.Id ) WHERE CONVERT(VARCHAR,BookedOn,120) Like @selectDate+'%'
END

CREATE PROCEDURE selectByDateRance(
@fromDate date,
@toDate date
)
AS
BEGIN
	SELECT Hall.Name AS 'Hall Name', Users.FirstName AS 'First Name', Users.LastName AS 'Last Name', Booking.BookedFor AS 'Booked For', Booking.BookedOn AS 'Booked On', convert(varchar, Booking.BookedForTime, 108) AS 'Start Time', convert(varchar, Booking.BookedToTime, 108) AS 'End Time'
	FROM ((Booking
		INNER JOIN Hall ON Booking.HallId = Hall.Id )
		INNER JOIN Users ON Booking.UserId = Users.Id ) WHERE CONVERT(date,BookedOn) BETWEEN @fromDate AND @toDate
END

/** Create function **/

CREATE FUNCTION getLastMonth()
RETURNS varchar(50)
AS
BEGIN
DECLARE @thisYear varchar(50)
SET @thisYear = DATEPART(yyyy,GETDATE())
DECLARE @lastMonth varchar(50)
SET @lastMonth = DATEPART(mm,GETDATE())-1
DECLARE @yearMonth varchar(50)
IF @lastMonth < 10
	BEGIN
		SET @yearMonth = @thisYear+'-0'+@lastMonth
	END
ELSE
	BEGIN
		SET @yearMonth = @thisYear+'-'+@lastMonth
	END
	RETURN @yearMonth
END

/** Total Booked duration **/
SELECT Hall.Name,( SELECT SUM(Booking.BookedDuration) from Booking WHERE Booking.HallId = Hall.Id) FROM Hall

/** Total hall booking time for each hall **/
CREATE PROCEDURE totalHallBookTimeLastMonth
AS
BEGIN
	SELECT Hall.Name AS 'Hall Name',( 
	SELECT dbo.toHours(SUM(BookedDuration)) AS 'Total Booking' from Booking WHERE Booking.HallId = Hall.Id AND CONVERT(VARCHAR,BookedOn,120) Like dbo.getLastMonth()+'%') FROM Hall
END

/** Total Hall Booking Time Daily**/
CREATE PROCEDURE totalHallBookingTimeDaily
@hallName varchar(50),
@fromDate DATE,
@toDate DATE
AS
BEGIN
	SELECT dbo.toHours(SUM(BookedDuration)), Booking.BookedFor FROM Booking 
	JOIN Hall ON Hall.Id = Booking.HallId 
	WHERE Hall.Name = @hallName AND BookedFor BETWEEN @fromDate AND @toDate
	GROUP BY BookedFor
END

SELECT Hall.Name AS 'Hall Name',( 
	SELECT dbo.toHours(SUM(BookedDuration)) AS 'Total Booking' from Booking WHERE Booking.HallId = Hall.Id AND CONVERT(VARCHAR,BookedOn,120) Like dbo.getLastMonth()+'%') FROM Hall