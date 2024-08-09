DROP DATABASE IF EXISTS coursework;

CREATE DATABASE coursework;

USE coursework;

-- This is the Course table

DROP TABLE IF EXISTS Course;

CREATE TABLE Course (
Crs_Code 	INT UNSIGNED NOT NULL,
Crs_Title 	VARCHAR(255) NOT NULL,
Crs_Enrollment INT UNSIGNED,
PRIMARY KEY (Crs_code));


INSERT INTO Course VALUES 
(100,'BSc Computer Science', 150),
(101,'BSc Computer Information Technology', 20),
(200, 'MSc Data Science', 100),
(201, 'MSc Security', 30),
(210, 'MSc Electrical Engineering', 70),
(211, 'BSc Physics', 100);


-- This is the student table definition


DROP TABLE IF EXISTS Student;

CREATE TABLE Student (
URN INT UNSIGNED NOT NULL,
Stu_FName 	VARCHAR(255) NOT NULL,
Stu_LName 	VARCHAR(255) NOT NULL,
Stu_DOB 	DATE,
Stu_Phone 	VARCHAR(12),
Stu_Course	INT UNSIGNED NOT NULL,
Stu_Email   VARCHAR(255) UNIQUE NOT NULL,
Stu_Type 	ENUM('UG', 'PG'),
PRIMARY KEY (URN),
FOREIGN KEY (Stu_Course) REFERENCES Course (Crs_Code)
ON DELETE RESTRICT);


INSERT INTO Student VALUES
(612345, 'Sara', 'Khan', '2002-06-20', '01483112233', 100, 'sk47851@surrey.ac.uk', 'UG'),
(612346, 'Pierre', 'Gervais', '2002-03-12', '01483223344', 100, 'pg21416@surrey.ac.uk', 'UG'),
(612347, 'Patrick', 'O-Hara', '2001-05-03', '01483334455', 100, 'po75979@surrey.ac.uk', 'UG'),
(612348, 'Iyabo', 'Ogunsola', '2002-04-21', '01483445566', 100, 'io37719@surrey.ac.uk', 'UG'),
(612349, 'Omar', 'Sharif', '2001-12-29', '01483778899', 100, 'os83742@surrey.ac.uk', 'UG'),
(612350, 'Yunli', 'Guo', '2002-06-07', '01483123456', 100, 'yg12301@surrey.ac.uk', 'UG'),
(612351, 'Costas', 'Spiliotis', '2002-07-02', '01483234567', 100, 'cs56715@surrey.ac.uk', 'UG'),
(612352, 'Tom', 'Jones', '2001-10-24',  '01483456789', 101, 'tj89235@surrey.ac.uk', 'UG'),
(612353, 'Simon', 'Larson', '2002-08-23', '01483998877', 101, 'sl62125@surrey.ac.uk', 'UG'),
(612354, 'Sue', 'Smith', '2002-05-16', '01483776655', 101, 'ss98718@surrey.ac.uk', 'UG');

DROP TABLE IF EXISTS Undergraduate;

CREATE TABLE Undergraduate (
UG_URN 	INT UNSIGNED NOT NULL,
UG_Credits   INT NOT NULL,
CHECK (60 <= UG_Credits <= 150),
PRIMARY KEY (UG_URN),
FOREIGN KEY (UG_URN) REFERENCES Student(URN)
ON DELETE CASCADE);

INSERT INTO Undergraduate VALUES
(612345, 120),
(612346, 90),
(612347, 150),
(612348, 120),
(612349, 120),
(612350, 60),
(612351, 60),
(612352, 90),
(612353, 120),
(612354, 90);

DROP TABLE IF EXISTS Postgraduate;

CREATE TABLE Postgraduate (
PG_URN 	INT UNSIGNED NOT NULL,
Thesis  VARCHAR(512) NOT NULL,
PRIMARY KEY (PG_URN),
FOREIGN KEY (PG_URN) REFERENCES Student(URN)
ON DELETE CASCADE);


-- Please add your table definitions below this line.......


-- Hobby table definition

DROP TABLE IF EXISTS Hobby;

CREATE TABLE Hobby (
Hby_Id  INT AUTO_INCREMENT,
Hby_Name    VARCHAR(255) NOT NULL,
PRIMARY KEY (Hby_Id));


INSERT INTO Hobby (Hby_Name) VALUES
('Reading'),
('Hiking'),
('Chess'),
('Taichi'),
('Ballroom Dancing'),
('Football'),
('Tennis'),
('Rugby'),
('Climbing'),
('Rowing');


-- StudentHobby Bridge table definition

DROP TABLE IF EXISTS StudentHobby;

CREATE TABLE StudentHobby (
URN INT UNSIGNED NOT NULL,
Hby_Id  INT,
PRIMARY KEY (URN, Hby_Id),
FOREIGN KEY (URN) REFERENCES Student(URN),
FOREIGN KEY (Hby_Id) REFERENCES Hobby(Hby_Id)
ON DELETE CASCADE);


INSERT INTO StudentHobby VALUES
(612345, 1),
(612345, 7),
(612345, 2),
(612346, 5),
(612346, 9),
(612346, 2),
(612346, 8),
(612347, 3),
(612348, 4),
(612348, 1),
(612348, 3),
(612349, 5),
(612349, 10),
(612350, 6),
(612351, 7),
(612351, 9),
(612352, 8),
(612352, 1),
(612352, 2),
(612353, 9),
(612354, 10);


-- Club table definition

DROP TABLE IF EXISTS Club;

CREATE TABLE Club (
Clb_Id  INT AUTO_INCREMENT,
Clb_Name    VARCHAR(255) NOT NULL,
Clb_Email   VARCHAR(255) UNIQUE NOT NULL,
Clb_enrolment   INT UNSIGNED,
PRIMARY KEY (Clb_Id)); 


INSERT INTO Club (Clb_Name, Clb_Email, Clb_enrolment) VALUES
('Badminton Club', 'ussu.badminton@surrey.ac.uk', 45),
('Basketball Club', 'ussu.basketball@surrey.ac.uk', 150),
('Archery Club', 'ussu.archery@surrey.ac.uk', 35),
('Boxing Club', 'ussu.boxing@surrey.ac.uk', 50),
('Fencing Club', 'ussu.fencing@surrey.ac.uk', 15),
('Swimming Club', 'ussu.swimming@surrey.ac.uk', 100),
('Tennis Club', 'ussu.tennis@surrey.ac.uk', 40);


-- StudentClub Bridge table definition

DROP TABLE IF EXISTS StudentClub;

CREATE TABLE StudentClub (
URN INT UNSIGNED NOT NULL,
Clb_Id  INT,
PRIMARY KEY (URN, Clb_Id),
FOREIGN KEY (URN) REFERENCES Student(URN),
FOREIGN KEY (Clb_Id) REFERENCES Club(Clb_Id)
ON DELETE CASCADE);


INSERT INTO StudentClub VALUES
(612345, 1),
(612346, 2),
(612347, 3),
(612348, 4),
(612349, 5),
(612349, 3),
(612350, 6),
(612351, 7),
(612352, 1),
(612352, 4),
(612353, 2),
(612354, 3);


-- Commitee table definition

DROP TABLE IF EXISTS Committee;

CREATE TABLE Committee (
Com_Id  INT AUTO_INCREMENT,
Clb_Id  INT NOT NULL,
Com_FName   VARCHAR(255) NOT NULL,
Com_LName   VARCHAR(255) NOT NULL,
Com_Position    VARCHAR(255) NOT NULL,
PRIMARY KEY (Com_Id),
FOREIGN KEY (Clb_Id) REFERENCES Club(Clb_Id)
ON DELETE RESTRICT);


INSERT INTO Committee (Clb_Id, Com_FName, Com_LName, Com_Position) VALUES
(1, 'Sophie', 'Johnson', 'Event Coordinator'),
(1, 'Daniel', 'Wilson', 'President'),
(1, 'Olivia', 'Harris', 'Public Relations Officer'),
(1, 'Henry', 'Lee', 'Sports Coordinator'),
(2, 'Liam', 'Thompson', 'Treasurer'),
(2, 'Emma', 'Davis', 'Event Planner'),
(2, 'Carter', 'Moore', 'President'),
(5, 'Aiden', 'Turner', 'President'),
(5, 'Chloe', 'Baker', 'Treasurer'),
(5, 'Ella', 'Wright', 'Secretary'),
(5, 'Logan', 'Fisher', 'Event Coordinator');


-- Session table defition

DROP TABLE IF EXISTS Session;

CREATE TABLE Session (
Ses_Id  INT AUTO_INCREMENT,
Clb_Id  INT NOT NULL,
Ses_Name    VARCHAR(255) NOT NULL,
Ses_Date    DATE NOT NULL,
Ses_StartTime   TIME NOT NULL,
Ses_EndTime     TIME NOT NULL,
PRIMARY KEY (Ses_Id),
FOREIGN KEY (Clb_Id) REFERENCES Club(Clb_Id)
ON DELETE CASCADE);


INSERT INTO Session (Clb_Id, Ses_Name, Ses_Date, Ses_StartTime, Ses_EndTime) VALUES
(1, 'Fitness Thursdays', '2024-01-11', '15:00:00', '16:00:00'),
(1, 'Social Sundays', '2024-01-14', '10:00:00', '12:00:00'),
(3, 'Training Session', '2024-01-05', '13:00:00', '15:00:00'),
(4, 'Beginner Session', '2024-01-06', '19:00:00', '20:30:00'),
(5, 'Fencing Session', '2024-01-09', '18:00:00', '19:45:00'),
(2, 'Bar Crawl', '2024-01-12', '20:00:00', '23:00:00'),
(7, 'Matchplay Fridays', '2024-01-12', '16:30:00', '18:30:00'),
(7, 'Movie Night', '2024-01-16', '20:00:00', '23:00:00');


-- Session Location (Multivalued) definition

DROP TABLE IF EXISTS Ses_Location;

CREATE TABLE Ses_Location (
Ses_Id  INT NOT NULL,
S_Location    VARCHAR(255) NOT NULL,
PRIMARY KEY (Ses_Id, S_Location),
FOREIGN KEY (Ses_Id) REFERENCES Session(Ses_Id)
ON DELETE CASCADE);


INSERT INTO Ses_Location (Ses_Id, S_Location) VALUES
(1, 'SSP Arena A'),
(1, 'SSP Arena B'),
(2, 'SSP Arena A'),
(2, 'SSP Arena B'),
(3, 'SSP Arena A'),
(4, 'SSP Arena B'),
(5, 'SSP Arena B'),
(6, 'Rubix'),
(7, 'SSP Arena A'),
(8, 'AP3');