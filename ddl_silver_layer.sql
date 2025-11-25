-- EXEC silver.create_silver_layer

CREATE OR ALTER PROCEDURE silver.create_silver_layer AS 
BEGIN
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
BEGIN TRY
SET @batch_start_time = GETDATE();
PRINT '===============================================================';
PRINT 'Create Silver Layer';
PRINT '===============================================================';

---------------------------------- authors -----------------------------------------------

PRINT '---------------------------------------------------------------';
PRINT 'Creating authors Table';
PRINT '---------------------------------------------------------------';

SET @start_time = GETDATE();
PRINT '>> Dropping Table : silver.authors';
IF OBJECT_ID('silver.authors', 'U') IS NOT NULL
  DROP TABLE silver.authors;

PRINT '>> Creating Table : silver.authors';
CREATE TABLE silver.authors (
 authorId NVARCHAR(20),
 authorName NVARCHAR(50),
 ontour NVARCHAR(10),
 --spotlight NVARCHAR(MAX),
 hasAuthorPhoto NVARCHAR(10),
 photoCredit NVARCHAR(500),
 photoDate INT,
 firstInitial NVARCHAR(10),
 lastInitial NVARCHAR(10),
 events NVARCHAR(50),
 seoFriendlyUrl NVARCHAR(500),
 first NVARCHAR(50),
 last NVARCHAR(50),
 contribRoles NVARCHAR(50),
 authorOf_workId NVARCHAR(10),
 authorOf_title NVARCHAR(500),
 authorOf_ISBN NVARCHAR(20),
 authorOf_seoFriendlyUrl NVARCHAR(500),
 authorOf_subtitle NVARCHAR(500),
 authorOf_publisher_code NVARCHAR(20),
 authorOf_publisher_description NVARCHAR(120),
 authorOf_onsale DATE,
 domain NVARCHAR(30),
 dwhCreateDate DATETIME2 DEFAULT GETDATE()
);
SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';

---------------------------------- categories ----------------------------------------------
PRINT '---------------------------------------------------------------';
PRINT 'Creating categories Table';
PRINT '---------------------------------------------------------------';

SET @start_time = GETDATE();
PRINT '>> Dropping Table : silver.categories';
IF OBJECT_ID('silver.categories', 'U') IS NOT NULL
  DROP TABLE silver.categories;

PRINT '>> Creating Table : silver.categories';
CREATE TABLE silver.categories (
 catId NVARCHAR(20),
 description NVARCHAR(150),
 catSetId NVARCHAR(10),
 catUri NVARCHAR(150),
 menuText NVARCHAR(150),
 hasChildren INT,
 seq INT,
 weight INT,
 domain NVARCHAR(30),
 dwhCreateDate DATETIME2 DEFAULT GETDATE()
);

SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';

---------------------------------------- catSets -------------------------------------------
PRINT '---------------------------------------------------------------';
PRINT 'Creating catSets Table';
PRINT '---------------------------------------------------------------';

SET @start_time = GETDATE();
PRINT '>> Dropping Table : silver.catSets';
IF OBJECT_ID('silver.catSets', 'U') IS NOT NULL
  DROP TABLE silver.catSets;

PRINT '>> Creating Table : silver.catSets';
CREATE TABLE silver.catSets (
 catSetId NVARCHAR(2),
 catSetDesc NVARCHAR(50),
 domain NVARCHAR(30),
 dwhCreateDate DATETIME2 DEFAULT GETDATE()
);
SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';

--------------------------------------- events -------------------------------------------------
PRINT '---------------------------------------------------------------';
PRINT 'Creating events Table';
PRINT '---------------------------------------------------------------';

SET @start_time = GETDATE();
PRINT '>> Dropping Table : silver.events';
IF OBJECT_ID('silver.events', 'U') IS NOT NULL
  DROP TABLE silver.events;

PRINT '>> Creating Table : silver.events';
CREATE TABLE silver.events (
 eventId NVARCHAR(10),
 eventDate DATE,
 location NVARCHAR(MAX),
 eventTime NVARCHAR(7),
 address1 NVARCHAR(MAX),
 city NVARCHAR(100),
 state NVARCHAR(100),
 zip NVARCHAR(10),
 status NVARCHAR(30),
 eventDateEnd DATE,
 descriptions NVARCHAR(MAX),
 comments NVARCHAR(MAX),
 referenceUrl NVARCHAR(MAX),
 domain NVARCHAR(30),
 dwhCreateDate DATETIME2 DEFAULT GETDATE()
);
SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';

---------------------------------------- roles -------------------------------------------------
PRINT '---------------------------------------------------------------';
PRINT 'Creating roles Table';
PRINT '---------------------------------------------------------------';

SET @start_time = GETDATE();
PRINT '>> Dropping Table : silver.roles';
IF OBJECT_ID('silver.roles', 'U') IS NOT NULL
  DROP TABLE silver.roles;

PRINT '>> Creating Table : silver.roles';
CREATE TABLE silver.roles (
 code NVARCHAR(10),
 description NVARCHAR(MAX),
 domain NVARCHAR(30),
 dwhCreateDate DATETIME2 DEFAULT GETDATE()
);
SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';

------------------------------------- series ------------------------------------------------------
PRINT '---------------------------------------------------------------';
PRINT 'Creating series Table';
PRINT '---------------------------------------------------------------';

SET @start_time = GETDATE();
PRINT '>> Dropping Table : silver.series';
IF OBJECT_ID('silver.series', 'U') IS NOT NULL
  DROP TABLE silver.series;

PRINT '>> Creating Table : silver.series';
CREATE TABLE silver.series (
 seriesCode NVARCHAR(10),
 seriesName NVARCHAR(700),
 --description NVARCHAR(MAX),
 seriesCount INT,
 seriesDate DATE,
 isNumbered NVARCHAR(10),
 isKids NVARCHAR(10),
 seoFriendlyUrl NVARCHAR(MAX),
 domain NVARCHAR(30),
 dwhCreateDate DATETIME2 DEFAULT GETDATE()
);
SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';

------------------------------------ titles ---------------------------------------------------

PRINT '---------------------------------------------------------------';
PRINT 'Creating titles Table';
PRINT '---------------------------------------------------------------';

SET @start_time = GETDATE();
PRINT '>> Dropping Table : silver.titles';
IF OBJECT_ID('silver.titles', 'U') IS NOT NULL
  DROP TABLE silver.titles;

PRINT '>> Creating Table : silver.titles';
CREATE TABLE silver.titles (
 isbn NVARCHAR(15),
 isbnHyphenated NVARCHAR(30),
 title NVARCHAR(MAX),
 subtitle NVARCHAR(MAX),
 author NVARCHAR(MAX),
 onsale DATE,
 --price INT,
 seoFriendlyUrl NVARCHAR(MAX),
 pages INT,
 sgmt_desc NVARCHAR(50),
 --subjects NVARCHAR(30),
 trim NVARCHAR(50),
 formatFamily NVARCHAR(50),
 consumerFormat NVARCHAR(50),
 consumerImprint NVARCHAR(50),
 consumerImprintUri NVARCHAR(50),
 saleStatus NVARCHAR(20),
 language NVARCHAR(20),
 seriesNumber INT,
 subseries NVARCHAR(50),
 editionType NVARCHAR(30),
 propertyName NVARCHAR(30),
 cartonQuantity INT,
 version NVARCHAR(30),
 productLine NVARCHAR(30),
 productType NVARCHAR(30),
-- flags NVARCHAR(10),
 workId NVARCHAR(10),
 --frontlistiestSeq NVARCHAR(30),
 --contribRoleCode NVARCHAR(50),
 --contribRoleDesc NVARCHAR(50),
 --titleBlock  NVARCHAR(50),
 titleShort NVARCHAR(50),
 audioPackage NVARCHAR(50),
 projectedMinutes NVARCHAR(40),
 --editionId INT,
 originalIsbn NVARCHAR(20),
 illustPhoto NVARCHAR(250),
 childrensBookCategory NVARCHAR(20),
 asin NVARCHAR(12),
 customSubjectCategory NVARCHAR(250),
 coverUpdatedOn DATE,
 isbn10 NVARCHAR(20),
 isbn10hyphenated NVARCHAR(20),
 boxComponentCt INT,
 focDate DATE,
 cataDate DATE,
 itemTypeCode NVARCHAR(20),
 --rcatDate DATE,
 --reisFocDate DATE,
 --reisCataDate DATE,
 --orderReq INT,
 --overUpc NVARCHAR(20),
 --additionalSeriesInfo NVARCHAR(20),
 mediaRating NVARCHAR(20),
 mediaRatingDesc NVARCHAR(30),
 coverVariantDesc NVARCHAR(20),
 --catalogs NVARCHAR(20),
 --familyCoverVariantFlag INT,
 sortByAuthor NVARCHAR(MAX),
 --alerts NVARCHAR(20),
 --cbRtnDate DATE,
 graphicCategory NVARCHAR(20),
 shortRunInd NVARCHAR(50),
 isbnStr NVARCHAR(20),
 format_code NVARCHAR(20),
 format_description NVARCHAR(70),
 subformat_code NVARCHAR(20),
 subformat_description NVARCHAR(70),
 division_code NVARCHAR(10),
 division_description NVARCHAR(70),
 imprint_code NVARCHAR(10),
 imprint_description NVARCHAR(70),
 publisher_code NVARCHAR(10),
 publisher_description NVARCHAR(70),
 age_code NVARCHAR(10),
 age_description NVARCHAR(70),
 grade_code NVARCHAR(10),
 grade_description NVARCHAR(50),
 educationGrade_code NVARCHAR(10),
 educationGrade_description NVARCHAR(50),
 salesRestriction_code NVARCHAR(10),
 salesRestriction_description NVARCHAR(50),
 --binding_code  NVARCHAR(10),
 --binding_description  NVARCHAR(50),
 --editionTarget_code  NVARCHAR(10),
 --editionTarget_description  NVARCHAR(50),
 isbnCounts_variant INT,
 isbnCounts_format INT,
 domain NVARCHAR(30),
 dwhCreateDate DATETIME2 DEFAULT GETDATE()
);
SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';

---------------------------------------- works -------------------------------------------------------

PRINT '---------------------------------------------------------------';
PRINT 'Creating works Table';
PRINT '---------------------------------------------------------------';

SET @start_time = GETDATE();
PRINT '>> Dropping Table : silver.works';
IF OBJECT_ID('silver.works', 'U') IS NOT NULL
  DROP TABLE silver.works;

PRINT '>> Creating Table : silver.works';
CREATE TABLE silver.works (
 workId NVARCHAR(10),
 title NVARCHAR(MAX),
 coverUrl NVARCHAR(500),
 earliestOnSaleDate DATE,
 genre NVARCHAR(100),
 domain NVARCHAR(30),
 dwhCreateDate DATETIME2 DEFAULT GETDATE()
);
SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';
SET @batch_end_time = GETDATE();
PRINT '===============================================================';
PRINT 'Creation Of Silver Layer Completed';
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
