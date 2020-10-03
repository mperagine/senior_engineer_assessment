USE PERSONDATABASE

/*********************
Hello! 

Please use the test data provided in the file 'PersonDatabase' to answer the following
questions. Please also import the dbo.Contacts flat file to a table for use. 

All answers should be executable on a MS SQL Server 2012 instance. 

***********************



QUESTION 1

The table dbo.Risk contains calculated risk scores for the population in dbo.Person. Write a 
query or group of queries that return the patient name, and their most recent risk level(s). 
Any patients that dont have a risk level should also be included in the results. 

**********************/


select p.PersonName, z.RiskLevel
from Person p
left join 
(
	select r.PersonId, RiskLevel, RiskDateTime
	from Risk r
	join
		(select PersonId, max(RiskDateTime) LatestTime
		from Risk r
		group by PersonID
		) Latest on Latest.PersonID=r.PersonID and Latest.LatestTime=r.RiskDateTime

) z on z.PersonID=p.PersonID




/**********************

QUESTION 2


The table dbo.Person contains basic demographic information. The source system users 
input nicknames as strings inside parenthesis. Write a query or group of queries to 
return the full name and nickname of each person. The nickname should contain only letters 
or be blank if no nickname exists.

**********************/


--Assuming user error for Margot Steed, i.e. no nickname
select 
  case when LastParen>0 then rtrim(ltrim(replace(PersonName,substring(PersonName, FirstParen, LastParen-FirstParen+2),'') ) ) 
  else PersonName end as FullName
, case when LastParen>0 then substring(PersonName, FirstParen+1, LastParen-FirstParen-1) 
  else '' end as Nickname

from (
	select PersonName, len(PersonName) LengthPersonName ,charindex('(', PersonName) as FirstParen, charindex(')', PersonName) as LastParen
	from Person
) z


/**********************

QUESTION 6

Write a query to return risk data for all patients, all payers 
and a moving average of risk for that patient and payer in dbo.Risk. 

**********************/


select p.PersonName, r.AttributedPayer, avg(RiskScore) over (partition by p.personId, r.AttributedPayer order by RiskDateTime) MovingAverage, RiskDateTime
from Person p
left join Risk r on r.PersonID=p.PersonID
order by p.PersonID, RiskDateTime, AttributedPayer


--Matt Note:  I only see 3 questions though it says "Question 6"

