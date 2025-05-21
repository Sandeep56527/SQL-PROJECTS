CREATE DATABASE hospital_data;

SELECT * FROM appointment;

SET SQL_SAFE_UPDATES = 0;

UPDATE appointment
SET `Time` = STR_TO_DATE(REPLACE(SUBSTRING_INDEX(`Time`, 'Z', 1), 'T', ' '), '%Y-%m-%d %H:%i:%s.%f');

ALTER TABLE appointment
MODIFY COLUMN `Time` DATETIME(3);

ALTER TABLE appointment
MODIFY COLUMN `Date` DATE;

DESCRIBE appointment;

SELECT * FROM billing LIMIT 100;

DESCRIBE billing;

SELECT * FROM doctor LIMIT 100;

SELECT
	DoctorName,
    DoctorContact,
    LOWER(CONCAT(DoctorName,SUBSTRING(DoctorContact,2,12)))
FROM doctor;

# fix email_id in doctor table

UPDATE doctor
SET DoctorContact = LOWER(CONCAT(DoctorName,SUBSTRING(DoctorContact,2,12)));

SELECT * FROM `medical procedure` LIMIT 100; 

SELECT * FROM patient LIMIT 100; # fix email in patient table

UPDATE patient
SET email = LOWER(email);

SELECT * FROM patient;

## Questions to solve

/*
 1) Retrieve the total number of appointments made by each doctor, sorted in descending order of 
 appointment count.
*/
SELECT d.DoctorID,
		COUNT(AppointmentID) AS Total_Appointments 
FROM appointment a
LEFT JOIN doctor d
ON a.DoctorID = d.DoctorID
GROUP BY d.DoctorID
ORDER BY Total_Appointments DESC;

/*
 2) Find the top 3 doctors with the highest number of appointments.
*/
SELECT d.DoctorID,
		COUNT(AppointmentID) AS Total_Appointments 
FROM appointment a
JOIN doctor d
ON a.DoctorID = d.DoctorID
GROUP BY d.DoctorID
ORDER BY Total_Appointments DESC
LIMIT 3; # doctors with doctorId 117,956 and 534

/*
 3) List the patients who have been billed for a procedure but do not have any appointments 
 in the appointment table.
*/
	SELECT DISTINCT b.patientId
    FROM billing b
    LEFT JOIN appointment a 
    ON b.PatientID = a.PatientID
    WHERE a.PatientID IS NULL;
    
/*
 4) Calculate the total revenue generated for each item in the billing table.
*/
SELECT Items,
	   SUM(Amount) AS TotalRevenue
 FROM billing
 GROUP BY Items
 ORDER BY TotalRevenue DESC;
 
 /*
 5) Find all doctors who have not been assigned to any appointments.
*/
SELECT DISTINCT d.DoctorID
FROM doctor d
LEFT JOIN appointment a
ON a.DoctorID = d.DoctorID
WHERE a.DoctorID IS NULL;

 /*
 6) Retrieve the details of patients who have undergone a medical procedure but are not listed in the 
 billing table.
*/
SELECT DISTINCT a.PatientID
FROM appointment a
LEFT JOIN billing b ON a.PatientID = b.PatientID
WHERE b.PatientID IS NULL;

 /*
 7) Identify the most common specialization among doctors based on the number of appointments they handle.
*/
SELECT Specialization,
	   COUNT(*) AS SpecializationCount
FROM doctor
GROUP BY Specialization
ORDER BY SpecializationCount DESC; # The most being the Oncologist, followed by Otolaryngologists

/*
 8) Determine the average amount billed for each patient across all their invoices.
*/
SELECT PatientID, 
	   ROUND(AVG(Amount),2) AS Avg_Amount
FROM billing
GROUP BY PatientID
ORDER BY Avg_Amount DESC;

/*
 9) Find the patient who has paid the highest total amount across all invoices.
*/
SELECT PatientID, 
	   SUM(Amount) AS Total_Amount
FROM billing
GROUP BY PatientID
ORDER BY Total_Amount DESC
LIMIT 1; # Patient with ID 733 has paid the maximum amount of 4,035,149

/*
 10) Retrieve the appointment details for the doctor who has performed the maximum number of appointments.
*/
SELECT *
FROM appointment
WHERE DoctorID = (
    SELECT DoctorID
    FROM appointment
    GROUP BY DoctorID
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

/*
 11) Calculate the percentage of appointments each doctor has handled compared to the total number 
 of appointments.
*/
SELECT 
    DoctorID, 
    COUNT(*) AS TotalAppointments, 
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM appointment), 2) AS PercentageOfAppointments
FROM appointment
GROUP BY DoctorID;

/*
 12) Identify patients who have had appointments in more than one year.
*/
SELECT PatientID
FROM appointment
GROUP BY PatientID
HAVING COUNT(DISTINCT YEAR(`Date`)) >1;

/*
 13) Find the second highest billing amount in the billing table.
*/
SELECT MAX(Amount) AS SecondHighestAmount
FROM billing
WHERE Amount < (SELECT MAX(Amount) FROM billing);

/*
 14) Retrieve the top 5 procedures performed in terms of the number of appointments.
*/
SELECT ProcedureName, COUNT(*) AS totalNumber
FROM `medical procedure`
GROUP BY ProcedureName
ORDER BY totalNumber DESC
LIMIT 5;

/*
 15) List the names and contact information of doctors who have been assigned appointments for 
 procedures containing the word "therapy."
*/
SELECT 
	d.DoctorName,
    d.Specialization,
    d.DoctorContact
FROM doctor d
LEFT JOIN appointment a
ON d.DoctorID = a.DoctorID
LEFT JOIN `medical procedure` mp
ON a.AppointmentID = mp.AppointmentID
WHERE mp.ProcedureName REGEXP 'therapy';

/*
 16) Retrieve the details of all appointments that occurred in the last 6 months.
*/
SELECT MAX(`Date`) FROM appointment;

SELECT * FROM appointment
WHERE `Date` BETWEEN '2023-06-01' AND '2023-12-31'
ORDER BY `Date`;

/*
 17) Find all patients whose first or last name starts with the letter 'A' and who have 
 an appointment scheduled.
*/
SELECT DISTINCT p.firstname,
	   p.lastname
FROM patient p
LEFT JOIN appointment a
ON p.PatientID = a.PatientID
WHERE a.PatientID IS NOT NULL
AND firstname REGEXP '^A' 
AND lastname REGEXP '^A' ;

/*
 18) Retrieve all appointments where the billing amount was higher than the average billing amount.
*/
SELECT a.* FROM appointment a 
LEFT JOIN billing b
ON a.PatientID = b.PatientID
WHERE b.Amount > (SELECT AVG(Amount) FROM billing)
ORDER BY AppointmentID;

/*
 19) Find the total number of unique patients who have visited doctors with the specialization "Cardiology."
*/
SELECT COUNT(DISTINCT a.PatientID) AS PatientCount
FROM patient p
LEFT JOIN appointment a
ON p.PatientID = a.PatientID
WHERE a.DoctorID IN (
					SELECT DoctorID FROM doctor
					WHERE Specialization REGEXP 'Cardiology');

/*
 20) Calculate the running total of amounts billed for each patient in the billing table.
*/
SELECT *,
SUM(Amount) OVER(PARTITION BY PatientID ORDER BY PatientID) AS RunningTotal
FROM billing ;

/*
 21) Find the rank of each patient based on their total billed amount.
*/
SELECT *,
RANK() OVER(ORDER BY RunningTotal DESC)
FROM
	(SELECT *,
	SUM(Amount) OVER(PARTITION BY PatientID ORDER BY PatientID) AS RunningTotal
	FROM billing) as sq;
    
/*
 22) Divide all patients into quartiles based on their total billing amount.
*/
SELECT *,
NTILE(4) OVER(ORDER BY RunningTotal) AS Quartiles
FROM
		(SELECT *,
	SUM(Amount) OVER(PARTITION BY PatientID ORDER BY PatientID) AS RunningTotal
	FROM billing) as sq;

/*
 23) Identify the first appointment for each doctor based on the Date and Time columns.
*/
SELECT DISTINCT
	DoctorID,
    FIRST_VALUE(`Date`) OVER(PARTITION BY DoctorID ORDER BY `Date`, `Time`) AS First_appointment_Date,
	FIRST_VALUE(`Time`) OVER(PARTITION BY DoctorID ORDER BY `Date`, `Time`) AS First_appointment_Time
 FROM appointment
 ORDER BY DoctorID;
 
/*
 24) Retrieve the last three appointments scheduled for any doctor.
*/
SELECT * FROM appointment
ORDER BY `Date` DESC
LIMIT 3;

/*
 24) Calculate the cumulative count of appointments over time.
*/
SELECT *,
SUM(CountOverTime) OVER(PARTITION BY `Date`, `Time` ORDER BY `Date`) AS CumulativeCountSum
FROM
	(SELECT *,
	COUNT(*) OVER(PARTITION BY `Date`, `Time`) AS CountOverTime
	 FROM appointment) AS Subquery;
     
/*
 25) Find the doctor with the longest gap between two consecutive appointments.
*/
WITH LongAppointmentGap AS
	(SELECT 
		DoctorID, 
		`Date`,
		LAG(`Date`,1, `Date`) OVER(ORDER BY `Date`) AS PrevDate
	FROM appointment
	ORDER BY `Date`)
SELECT *,
	DATEDIFF(`Date`,PrevDate) AS DateDifference
FROM LongAppointmentGap
ORDER BY DateDifference DESC
LIMIT 1;

/*
 26) Retrieve the details of all patients who have had more than one appointment with the same doctor.
*/
WITH appointmentCount AS
	(SELECT 
		*,
		FIRST_VALUE(DoctorID) OVER(PARTITION BY PatientID) AS Consulted_Doctor
	FROM appointment) 
,PatientDetails AS
	(SELECT PatientID
	FROM appointmentCount
	GROUP BY PatientID
	HAVING COUNT(Consulted_Doctor) > 1)
SELECT p.* 
FROM patient p
JOIN PatientDetails pd
ON p.PatientID = pd.PatientID;

/*
 27) Identify the doctor who has performed the most distinct procedures.
*/
WITH doctCount AS
	(SELECT
			DoctorID,
			ProcedureName,
		COUNT(*) OVER(PARTITION BY DoctorID) AS ProcedureCount
		FROM `medical procedure` mp
		JOIN appointment a
		ON mp.AppointmentID = a.AppointmentID
		ORDER BY DoctorID)
SELECT DISTINCT
	DoctorID,
	ProcedureCount
FROM doctCount
ORDER BY ProcedureCount DESC
LIMIT 1;

/*
 28) Retrieve the total revenue generated for each doctor by joining the appointment and billing tables.
*/
SELECT 
	d.DoctorID,
	d.DoctorName,
    SUM(b.Amount) AS Total_Revenue_earned
FROM doctor d
LEFT JOIN appointment a
ON d.DoctorID=a.DoctorID
LEFT JOIN billing b
ON b.PatientID=a.PatientID
GROUP BY d.DoctorID,d.DoctorName
ORDER BY Total_Revenue_earned DESC;

/*
 29) Find patients who have never been billed for a procedure.
*/
SELECT DISTINCT
	p.PatientID,
    CONCAT(p.firstname,' ',p.lastname) AS Patient_Name
FROM patient p 
LEFT JOIN billing b
ON p.PatientID=b.PatientID
WHERE b.PatientID IS NULL
ORDER BY p.PatientID;

/*
 30) Calculate the percentage contribution of each procedure to the total revenue generated.
*/
SELECT 
	mp.ProcedureName,
    SUM(b.Amount) AS RevenueGenerated,
	CONCAT(ROUND((SUM(b.Amount) * 100.0) / (SELECT SUM(Amount) FROM billing),2), ' %') AS PercentageContribution
FROM `medical procedure` mp
LEFT JOIN appointment a
ON mp.AppointmentID=a.AppointmentID
LEFT JOIN billing b 
ON b.PatientID=a.PatientID
GROUP BY mp.ProcedureName
ORDER BY PercentageContribution DESC;

/*
 31) Calculate the average billing amount per patient, partitioned by the year of the invoice.
*/
SELECT 
	a.PatientID,
    b.Amount,
    a.`Date`,
    AVG(b.Amount) OVER(PARTITION BY YEAR(a.`Date`)) AS AvgAmountPerYear
FROM billing b
JOIN appointment a
ON b.PatientID=a.PatientID
ORDER BY a.`Date`;

/*
 32) Retrieve the details of appointments where the same patient was billed for multiple procedures on the 
 same day.
*/
SELECT 
	a.PatientID,
    a.`Date`,
    COUNT(mp.ProcedureName) AS ProcedureCount
FROM appointment a
JOIN `medical procedure` mp
ON a.AppointmentID=mp.AppointmentID
GROUP BY a.PatientID,a.`Date`
HAVING(COUNT(mp.ProcedureName) > 1)
ORDER BY a.PatientID, a.`Date`;

/*
 33) Calculate the difference in billing amount between a patient’s current and previous invoice.
*/
SELECT *,
LAG(Amount) OVER(ORDER BY InvoiceID) AS PreviousAmount,
(Amount - LAG(Amount) OVER(ORDER BY InvoiceID)) AS DiffAmount
FROM billing;

/*
 34) Retrieve the details of patients who have been treated by more than 3 doctors.
*/
SELECT 
	p.PatientID,
    CONCAT(p.firstname,' ',p.lastname) AS Patient_name
FROM patient p
LEFT JOIN appointment a
ON p.PatientID = a.PatientID
LEFT JOIN doctor d 
ON d.DoctorID=a.DoctorID
GROUP BY p.PatientID,
CONCAT(p.firstname,' ',p.lastname)
HAVING (COUNT(d.DoctorID) > 3)
ORDER BY p.PatientID;

/*
 35) Find the doctor who has treated the fewest number of patients.
*/
SELECT 
	d.DoctorID,
    d.DoctorName,
    COUNT(*) AS TotalCases
FROM appointment a
LEFT JOIN doctor d 
ON d.DoctorID=a.DoctorID
WHERE d.DoctorID IS NOT NULL
GROUP BY d.DoctorID, d.DoctorName
ORDER BY TotalCases
LIMIT 1;