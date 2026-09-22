CREATE DATABASE DayRace;
USE DayRace;

CREATE TABLE Users(
UserID INT IDENTITY PRIMARY KEY,
FullName VARCHAR(100) NOT NULL, 
LastName VARCHAR(100) NOT NULL,
Email VARCHAR(150) NOT NULL UNIQUE,
Password VARCHAR(255) NOT NULL,
Role VARCHAR(20) NOT NULL CHECK (Role IN('Organiser','Participant')),
Phone VARCHAR(20),
DateCreated DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Events(
EventID INT IDENTITY PRIMARY KEY,
UserID INT NOT NULL,
EventDate DATE NOT NULL,
Description VARCHAR(255),
Location VARCHAR(150),
EventType VARCHAR(20) CHECK (EventType IN ('Walking','Running','Cycling'))
CONSTRAINT fk_Events_User
	FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Categories (
CategoriesID INT IDENTITY PRIMARY KEY,
EventID INT NOT NULL,
UserID INT NOT NULL,
CategoryName VARCHAR(100) NOT NULL,
Gender VARCHAR(10) CHECK (Gender IN ('Male','Female')),
MinAge INT,
MaxAge INT,
Distance DECIMAL(6,2),
EntryFee DECIMAL(8,2),
CONSTRAINT fk_Categories_User
	FOREIGN KEY (UserID) REFERENCES Users(UserID),
CONSTRAINT fk_Categories_Event
	FOREIGN KEY (EventID) REFERENCES Events(EventID)
);

CREATE TABLE Participants (
ParticipantID INT IDENTITY PRIMARY KEY,
UserID INT NOT NULL UNIQUE, 
FirstName VARCHAR(100) NOT NULL,
LastName VARCHAR(100) NOT NULL,
Email VARCHAR(150) NOT NULL UNIQUE,
Phone VARCHAR(20),
DateCreated DATETIME DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_Participants_User
	FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Routes (
RouteID INT IDENTITY PRIMARY KEY,
EventID INT NOT NULL,
RouteName VARCHAR(100) NOT NULL,
Distance DECIMAL(6,2),
ElevationGain DECIMAL(6,2),
Description VARCHAR(255),
MapURL VARCHAR(255),
CONSTRAINT fk_Routes_Event
	FOREIGN KEY (EventID) REFERENCES Events(EventID)
);

CREATE TABLE Event_Enrolment(
EnrolmentID INT IDENTITY PRIMARY KEY,
ParticipantID INT NOT NULL,
EventID INT NOT NULL,
CategoryID INT NOT NULL,
EnrolmentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
Status VARCHAR(20) NOT NULL DEFAULT 'Pending' 
	CHECK (Status IN('Pending','Confirmed')),
PaymentStatus VARCHAR(20) NOT NULL DEFAULT 'Pending',
	CHECK (PaymentStatus IN('Pending','Paid')),
CONSTRAINT fk_Enrolment_Participant
	FOREIGN KEY (ParticipantID) REFERENCES Participants(ParticipantID),
CONSTRAINT fk_Enrolment_Event
	FOREIGN KEY (EventID) REFERENCES Events(EventID),
CONSTRAINT fk_Enrolment_Category
	FOREIGN KEY (CategoryID) REFERENCES Categories(CategoriesID)
	);

CREATE TABLE Results (
	ResultsID INT IDENTITY PRIMARY KEY,
	EnrolmentID INT NOT NULL,
	FinishTime TIME,
	OverallPosition INT,
	CategoryPosition INT,
	PaceMinPerKm DECIMAL(6,2),
	CONSTRAINT fk_Results_Enrolment
		FOREIGN KEY (EnrolmentID) REFERENCES Event_Enrolment(EnrolmentID)
	);

