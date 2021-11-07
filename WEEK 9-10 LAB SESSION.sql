create database E_Commerce;
USE E_Commerce;
create table Supplier(SUPP_ID INT NOT NULL PRIMARY KEY,SUPP_NAME VARCHAR(50),SUPP_CITY VARCHAR(50),SUPP_PHONE BIGINT);
create table Customer(CUS_ID INT NOT NULL PRIMARY KEY ,CUS_NAME VARCHAR(50),CUS_PHONE BIGINT,CUS_CITY VARCHAR(20),CUS_GENDER VARCHAR(10));
create table Category(CAT_ID INT NOT NULL PRIMARY KEY,CAT_NAME VARCHAR(20));
create table Product(PRO_ID INT NOT NULL PRIMARY KEY ,PRO_NAME VARCHAR(20),PRO_DESC VARCHAR(100),CAT_ID INT ,FOREIGN KEY(CAT_ID) REFERENCES Category(CAT_ID));
create table ProductDetails(PROD_ID INT NOT NULL PRIMARY KEY,PRO_ID INT,SUPP_ID INT ,PROD_PRICE INT ,FOREIGN KEY (PRO_ID) REFERENCES Product(PRO_ID),FOREIGN KEY (SUPP_ID) REFERENCES Supplier (SUPP_ID));
create table Orders(ORD_ID INT NOT NULL PRIMARY KEY ,ORD_AMOUNT INT,ORD_DATE DATE,CUS_ID INT,PROD_ID INT ,FOREIGN KEY(CUS_ID) REFERENCES Customer(CUS_ID), FOREIGN KEY (PROD_ID) REFERENCES ProductDetails(PROD_ID));
create table Rating(RAT_ID INT NOT NULL PRIMARY KEY,CUS_ID INT,SUPP_ID INT,RAT_RATSTARS INT,FOREIGN KEY (CUS_ID) REFERENCES Customer(CUS_ID),FOREIGN KEY (SUPP_ID) REFERENCES Supplier(SUPP_ID));

insert into Supplier values(1,'Rajesh Retails','Delhi',1234567890);
insert into Supplier values(2,'Appario Ltd ','Mumbai',2589631470);
insert into Supplier values(3,'Knome products ','Banglore',9785462315);
insert into Supplier values(4,'Bansal Retails','Kochi',8975463285);
insert into Supplier values(5,'Mittal Ltd.','Lucknow',7898456532);

insert into Customer values(1,'AAKASH',9999999999,'DELHI','M');
insert into Customer values(2,'AMAN',9785463215,'NOIDA','M');
insert into Customer values(3,'NEHA',9999999999,'MUMBAI','F');
insert into Customer values(4,'MEGHA',9994562399,'KOLKATA','F');
insert into Customer values(5,'PULKIT',7895999999,'LUCKNOW','M');

insert into Category values(1,'BOOKS');
insert into Category values(2,'GAMES');
insert into Category values(3,'GROCERIES');
insert into Category values(4,'ELECTRONICS');
insert into Category values(5,'CLOTHES'); 

insert into Product values(1,'GTA V','DFJDJFDJFDJFDJFJF',2);
insert into Product values(2,'TSHIRT','DFDFJDFJDKFD',5);
insert into Product values(3,'ROG LAPTOP','DFNTTNTNTERND',4);
insert into Product values(4,'OATS','REURENTBTOTH',3);
insert into Product values(5,'HARRY POTTER','NBEMCTHTJTH',1);

insert into ProductDetails values(1,1,2,1500);
insert into ProductDetails values(2,3,5,30000);
insert into ProductDetails values(3,5,1,3000);
insert into ProductDetails values(4,2,3,2500);
insert into ProductDetails values(5,4,1,1000);

insert into Orders values(20,1500,'2021-10-12',5,3);
insert into Orders values(25,30500,'2021-09-16',5,2);
insert into Orders values(26,2000,'2021-10-05',1,1);
insert into Orders values(30,3500,'2021-08-16',4,3);
insert into Orders values(50,2000,'2021-10-06',2,1);

insert into Rating values(1,2,2,4);
insert into Rating values(2,3,4,3);
insert into Rating values(3,5,1,5);
insert into Rating values(4,1,3,2);
insert into Rating values(5,4,5,4);



#3 Display the number of the customer group by their genders who have placed
 #any order of amount greater than or equal to Rs.3000.
 
SELECT c.CUS_GENDER,COUNT(c.CUS_GENDER) AS COUNT 
FROM CUSTOMER c 
JOIN ORDERS o ON c.CUS_ID = o.CUS_ID
WHERE o.ORD_AMOUNT>=3000 GROUP BY c.CUS_GENDER;

#4) Display all the orders along with the product name
# ordered by a customer having Customer_Id=2.


SELECT o.ORD_ID,o.ORD_AMOUNT,o.ORD_DATE,pd.PROD_ID,pr.PRO_NAME 
FROM Orders o
JOIN ProductDetails pd ON o.PROD_ID=pd.PROD_ID
JOIN Product pr ON pd.PRO_ID =pr.PRO_ID
WHERE o.CUS_ID=2; 


#5)Display the Supplier details 
#who can supply more than one product.

SELECT sp.* FROM Supplier sp JOIN ProductDetails pd
ON sp.SUPP_ID=pd.SUPP_ID
GROUP BY sp.SUPP_ID HAVING COUNT(sp.SUPP_ID)>1;

#6) Find the category of the product whose order amount is minimum.


SELECT c.* from Category c INNER JOIN Product pr ON c.CAT_ID = pr.CAT_ID 
INNER JOIN ProductDetails pd ON pr.PRO_ID = pd.PRO_ID 
INNER JOIN Orders o ON pd.PROD_ID = o.PROD_ID 
HAVING min(O.ORD_AMOUNT);

#7)Display the Id and Name of the Product ordered after “2021-10-05”.

SELECT P.PRO_ID,PRO_NAME FROM Product P 
JOIN ProductDetails PD ON P.PRO_ID=PD.PRO_ID
JOIN Orders O ON PD.PROD_ID=O.PROD_ID WHERE ORD_DATE>'2021-10-05';


#8) Print the top 3 supplier name and id and their rating on
#the basis of their rating along with the customer name who has given the rating.

SELECT s. SUPP_ID ,SUPP_NAME ,CUS_NAME,RAT_RATSTARS FROM Supplier s 
JOIN Rating r ON s.SUPP_ID=r.SUPP_ID
JOIN Customer c ON r.CUS_ID=c.CUS_ID 
ORDER BY RAT_RATSTARS DESC LIMIT 3;

#9) Display customer name and gender whose names start or end with character 'A'.

SELECT CUS_NAME ,CUS_GENDER FROM Customer 
WHERE CUS_NAME LIKE 'A%' OR CUS_NAME LIKE '%A';

										  
#10) Display the total order amount of the male customers.

SELECT sum(ORD_AMOUNT) AS TOTAL_ORDER_AMOUNT 
FROM Orders o JOIN Customer c 
ON o.CUS_ID = c.CUS_ID AND CUS_GENDER = "M";


#11) Display all the Customers left outer join with the orders.

SELECT * FROM Customer c LEFT JOIN Orders o ON c.CUS_ID = o.CUS_ID;

#12) Create a stored procedure to display the Rating for a Supplier if any along with the
#Verdict on that rating if any like if rating >4 then “Genuine Supplier” 
#if rating >2 “Average Supplier” else “Supplier should not be considered”.

delimiter &&
CREATE PROCEDURE displayRating()
BEGIN
SELECT s.SUPP_ID, SUPP_NAME, RAT_RATSTARS, 
CASE
WHEN RAT_RATSTARS > 4 THEN 'Genuine Suuplier'
WHEN RAT_RATSTARS > 2 THEN 'Average Supplier'
ELSE 'Supplier should not be considered'
END AS Verdict
FROM Supplier s JOIN Rating r ON s.SUPP_ID = r.SUPP_ID;
END &&

call displayRating();












