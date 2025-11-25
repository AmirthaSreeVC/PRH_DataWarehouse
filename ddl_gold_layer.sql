-- EXEC gold.create_gold_layer

CREATE OR ALTER PROCEDURE gold.create_gold_layer AS 
BEGIN
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
BEGIN TRY 
SET @batch_start_time = GETDATE();
PRINT '===============================================================';
PRINT 'Create Gold Layer';
PRINT '===============================================================';

PRINT '---------------------------------------------------------------';
PRINT 'Creating dim_work Table';
PRINT '---------------------------------------------------------------';

---------------------------- dim_work ---------------------------------------------------

SET @start_time = GETDATE();
PRINT '>> Dropping Table : gold.dim_work';
IF OBJECT_ID('gold.dim_work', 'U') IS NOT NULL
  DROP TABLE gold.dim_work;

PRINT '>> Creating Table : gold.dim_work';
CREATE TABLE gold.dim_work (
 workId NVARCHAR(10),
 workTitle NVARCHAR(MAX),
 earliestOnSaleDate DATE,
 domainAgg NVARCHAR(100),
 dwhCreateDate DATETIME2 DEFAULT GETDATE()
 );
 
SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';

---------------------------- dim_authors ---------------------------------------------------
PRINT '---------------------------------------------------------------';
PRINT 'Creating dim_authors Table';
PRINT '---------------------------------------------------------------';

SET @start_time = GETDATE();
PRINT '>> Dropping Table : gold.dim_authors';
IF OBJECT_ID('gold.dim_authors', 'U') IS NOT NULL
  DROP TABLE gold.dim_authors;

PRINT '>> Creating Table : gold.dim_authors';
CREATE TABLE gold.dim_authors (
 commonAuthorId NVARCHAR(10),
 imprintBasedAuthorId NVARCHAR(MAX),
 authorName NVARCHAR(150),
 ontour NVARCHAR(10),
 hasAuthorPhoto NVARCHAR(10),
 photoCredit NVARCHAR(MAX),
 photoDate INT,
 firstName NVARCHAR(50),
 lastName NVARCHAR(50),
 domainAgg NVARCHAR(100),
 dwhCreateDate DATETIME2 DEFAULT GETDATE()
 );
 
SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';


-------------------------- dim_category-------------------------------------------------------
PRINT '---------------------------------------------------------------';
PRINT 'Creating dim_category Table';
PRINT '---------------------------------------------------------------';

 SET @start_time = GETDATE();
PRINT '>> Dropping Table : gold.dim_category';
IF OBJECT_ID('gold.dim_category', 'U') IS NOT NULL
  DROP TABLE gold.dim_category;

PRINT '>> Creating Table : gold.dim_category';
CREATE TABLE gold.dim_category (
 catId NVARCHAR(20),
 catDescription NVARCHAR(150),
 catWeight INT,
 catSetDesc NVARCHAR(50),
 domainAgg NVARCHAR(100),
 dwhCreateDate DATETIME2 DEFAULT GETDATE()
 );


SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';

---------------------------------------- dim_books ----------------------------------------------
SET @start_time = GETDATE();
PRINT '>> Dropping Table : gold.dim_books';
IF OBJECT_ID('gold.dim_books', 'U') IS NOT NULL
  DROP TABLE gold.dim_books;

PRINT '>> Creating Table : gold.dim_books';
CREATE TABLE gold.dim_books (
isbn NVARCHAR(15),
title NVARCHAR(MAX),
subtitle NVARCHAR(MAX),
pages INT,
sgmt_desc NVARCHAR(50),
trim NVARCHAR(50),
formatFamily NVARCHAR(50),
consumerFormat NVARCHAR(50),
consumerImprint NVARCHAR(50),
consumerImprintUri NVARCHAR(50),
language NVARCHAR(20),
seriesNumber INT,
editionType NVARCHAR(30),
propertyName NVARCHAR(30),
cartonQuantity INT,
version NVARCHAR(30),
productLine NVARCHAR(30),
productType NVARCHAR(30),
audioPackage NVARCHAR(50),
projectedMinutes NVARCHAR(40),
asin NVARCHAR(12),
coverUpdatedOn DATE,
mediaRatingDesc NVARCHAR(30),
graphicCategory NVARCHAR(20),
shortRunInd NVARCHAR(50),
format_description NVARCHAR(70),
subformat_description NVARCHAR(70),
division_description NVARCHAR(70),
imprint_description NVARCHAR(70),
publisher_description NVARCHAR(70),
age_description NVARCHAR(70),
grade_description NVARCHAR(50),
educationGrade_description NVARCHAR(50),
salesRestriction_description NVARCHAR(50),
domainAgg NVARCHAR(100),
dwhCreateDate DATETIME2 DEFAULT GETDATE()
);

SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';

-------------------------- factless fact table-------------------------------------------------------
PRINT '---------------------------------------------------------------';
PRINT 'Creating fact_bookLifeCycle Table';
PRINT '---------------------------------------------------------------';

 SET @start_time = GETDATE();
PRINT '>> Dropping Table : gold.fact_bookLifeCycle';
IF OBJECT_ID('gold.fact_bookLifeCycle', 'U') IS NOT NULL
  DROP TABLE gold.fact_bookLifeCycle;

PRINT '>> Creating Table : gold.fact_bookLifeCycle';
CREATE TABLE gold.fact_bookLifeCycle (
 isbn NVARCHAR(15),
 catId NVARCHAR(20),
 authorId NVARCHAR(10),
 workId NVARCHAR(10),
 saleStatus NVARCHAR(50),
 onSale DATE,
 focDate DATE,
 cataDate DATE,
 domainAgg NVARCHAR(100),
 dwhCreateDate DATETIME2 DEFAULT GETDATE()
 );

SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';


SET @batch_end_time = GETDATE();
PRINT '===============================================================';
PRINT 'Creation Of Gold Layer Completed';
PRINT ' Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time,@batch_end_time) AS NVARCHAR) + ' seconds';
PRINT '===============================================================';
END TRY
BEGIN CATCH
	PRINT '===============================================================';
	PRINT 'Error Ocurred while Loading Silver Layer';
	PRINT 'Error Message ' + ERROR_MESSAGE();
	PRINT 'Error Message ' + CAST(ERROR_NUMBER() AS NVARCHAR);
	PRINT 'Error Message ' + CAST(ERROR_STATE() AS NVARCHAR);
	PRINT '===============================================================';
END CATCH
END