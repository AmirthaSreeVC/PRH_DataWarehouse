 -- EXEC gold.load_gold_layer

CREATE OR ALTER PROCEDURE gold.load_gold_layer AS 
BEGIN
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
BEGIN TRY
SET @batch_start_time = GETDATE();
PRINT '===============================================================';
PRINT 'Loading Gold Layer';
PRINT '===============================================================';

PRINT '---------------------------------------------------------------';
PRINT 'Loading Mapping Tables for Data Modelling';
PRINT '---------------------------------------------------------------';

-------------------------- Mapping Tables to model the data ------------------------------------------
SET @start_time = GETDATE();
PRINT '>> Dropping Mapping Table : mapping_authors';
DROP TABLE mapping_authors

PRINT '>> Creating Mapping Table: mapping_authors';
CREATE TABLE mapping_authors(
author_id INT IDENTITY(1,1) PRIMARY KEY,
author_name NVARCHAR(MAX),
domainAgg NVARCHAR(MAX),
authorIdAgg NVARCHAR(MAX)
);

PRINT '>> Inserting Data Into Mapping Table: mapping_authors';
INSERT INTO mapping_authors
SELECT DISTINCT A.authorName,
STRING_AGG(A.domain,','),
STRING_AGG(authorIdAgg,',')
FROM (SELECT DISTINCT authorName,domain,STRING_AGG(authorId,',') AS authorIdAgg
FROM silver.authors
GROUP BY domain,authorName) AS A
GROUP BY A.authorName;

SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';

SET @start_time = GETDATE();
PRINT '>> Dropping Mapping Table : domainAggregate';
DROP TABLE domainAggregate;

PRINT '>> Creating Mapping Table: domainAggregate';
CREATE TABLE domainAggregate(
workId NVARCHAR(15),
isbn NVARCHAR(15),
domainAgg NVARCHAR(100));

PRINT '>> Inserting Data Into Mapping Table: domainAggregate';
INSERT INTO domainAggregate
SELECT distinct workId,isbn,STRING_AGG(domain,',') AS D
FROM silver.titles 
GROUP BY isbn,workId;

SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';
----------------------------------- dim_work --------------------------------------------------
PRINT '---------------------------------------------------------------';
PRINT 'Loading dim_work table';
PRINT '---------------------------------------------------------------';
SET @start_time = GETDATE();
PRINT '>> Truncating Table : gold.dim_work';
TRUNCATE TABLE gold.dim_work;

PRINT '>> Inserting Data Into : gold.dim_work';
INSERT INTO gold.dim_work(workId,workTitle,earliestOnSaleDate,domainAgg)
SELECT 
workId,
title,
earliestOnSaleDate,
STRING_AGG(domain,',')
FROM (SELECT *,
      ROW_NUMBER() OVER(PARTITION BY workId ORDER BY dwhCreateDate DESC) AS rn
	  FROM silver.works) AS w
WHERE rn=1
GROUP BY workId,title,earliestOnSaleDate;

PRINT '>> Inserting Data Into : gold.dim_work';
INSERT INTO gold.dim_work(workId,workTitle,earliestOnSaleDate,domainAgg)
SELECT 
DISTINCT workId,
title,
onsale,
STRING_AGG(domain,',')
FROM (SELECT *,
      ROW_NUMBER() OVER(PARTITION BY workId ORDER BY dwhCreateDate DESC) AS rn
	  FROM silver.titles) AS T
WHERE rn=1 AND workId NOT IN (SELECT DISTINCT workId FROM gold.dim_work)
GROUP BY workId,title,onsale;

SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';
--------------------------------------- dim_category -----------------------------------------------------
PRINT '---------------------------------------------------------------';
PRINT 'Loading dim_category table';
PRINT '---------------------------------------------------------------';
SET @start_time = GETDATE();
PRINT '>> Truncating Table : gold.dim_category';
TRUNCATE TABLE gold.dim_category;

PRINT '>> Inserting Data Into : gold.dim_category';
INSERT INTO gold.dim_category(catId,catDescription,catWeight,catSetDesc,domainAgg)
SELECT 
cat.catId,
cat.description,
cat.weight,
catSet.catSetDesc,
'AUDIO,DK.COM,PRH.CA,PRH.US,SALESINTERNATIONAL' AS domainAgg
FROM silver.categories AS cat
JOIN silver.catSets AS catSet
ON cat.catSetId=catSet.catSetId
GROUP BY cat.catId,cat.description,
cat.weight,catSet.catSetDesc;

SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';
----------------------------------- dim_authors ---------------------------------------------------
PRINT '---------------------------------------------------------------';
PRINT 'Loading dim_authors table';
PRINT '---------------------------------------------------------------';
SET @start_time = GETDATE();
PRINT '>> Truncating Table : gold.dim_authors';
TRUNCATE TABLE gold.dim_authors;

PRINT '>> Inserting Data Into : gold.dim_authors';
INSERT INTO gold.dim_authors(commonAuthorId,imprintBasedAuthorId,authorName,ontour,hasAuthorPhoto,
							 photoCredit,photoDate,firstName,lastName,domainAgg)
SELECT 
B.author_id,
B.authorIdAgg,
B.author_name,
A.ontour,
A.hasAuthorPhoto,
A.photoCredit,
A.photoDate,
A.first,
A.last,
B.domainAgg
FROM (SELECT DISTINCT authorName,MIN(ontour) AS ontour,MIN(hasAuthorPhoto) AS hasAuthorPhoto,
	  MIN(photoCredit) AS photoCredit,MAX(photoDate) AS photoDate,
	  MIN(first) AS first,MIN(last) AS last
	  FROM silver.authors
	  GROUP BY authorName) AS A
JOIN mapping_authors AS B
ON A.authorName=B.author_name;

SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';
---------------------------------- dim_books ------------------------------------------------------
PRINT '---------------------------------------------------------------';
PRINT 'Loading dim_books table';
PRINT '---------------------------------------------------------------';
SET @start_time = GETDATE();
PRINT '>> Truncating Table : gold.dim_books';
TRUNCATE TABLE gold.dim_books;

PRINT '>> Inserting Data Into : gold.dim_books';
INSERT INTO gold.dim_books(isbn,title,subtitle,pages,sgmt_desc,trim,formatFamily,
							consumerFormat,consumerImprint,consumerImprintUri,language,
							seriesNumber,editionType,propertyName,cartonQuantity,version,productLine,
							productType,audioPackage,projectedMinutes,asin,coverUpdatedOn,
							mediaRatingDesc,graphicCategory,shortRunInd,format_description,
							subformat_description,division_description,imprint_description,publisher_description,
							age_description,grade_description,educationGrade_description,salesRestriction_description)
SELECT 
DISTINCT isbn,   
title,subtitle,
pages,
sgmt_desc,trim,
formatFamily,consumerFormat,
consumerImprint,consumerImprintUri,
language,seriesNumber,editionType,
propertyName,cartonQuantity,
version,productLine,
productType,audioPackage,
projectedMinutes,asin,coverUpdatedOn,
mediaRatingDesc,graphicCategory,
shortRunInd,format_description,
subformat_description,division_description,
imprint_description,publisher_description,
age_description,grade_description,
educationGrade_description,salesRestriction_description
FROM silver.titles;

SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';
-------------------------- factless fact table-------------------------------------------------------
PRINT '---------------------------------------------------------------';
PRINT 'Loading fact_bookLifeCycle table';
PRINT '---------------------------------------------------------------';
SET @start_time = GETDATE();
PRINT '>> Truncating Table : gold.fact_bookLifeCycle';
TRUNCATE TABLE gold.fact_bookLifeCycle;

PRINT '>> Inserting Data Into : gold.fact_bookLifeCycle';
WITH temp AS(
SELECT DISTINCT workId,genre FROM (SELECT *,
      ROW_NUMBER() OVER(PARTITION BY workId ORDER BY dwhCreateDate DESC) AS rn
	  FROM silver.works) AS q 
WHERE rn=1
)
INSERT INTO gold.fact_bookLifeCycle(isbn,catId,authorId,workId,
									saleStatus,onsale,focDate,cataDate,domainAgg)
SELECT 
DISTINCT bk.isbn,
MAX(ca.catId),
MAX(a.commonAuthorId),
MAX(da.workId),
MAX(bk.saleStatus),
MAX(bk.onsale),
MAX(bk.focDate),
MAX(bk.cataDate),
MAX(da.domainAgg)
FROM  
(SELECT *,ROW_NUMBER() OVER(PARTITION BY isbn ORDER BY dwhCreateDate) AS ranks 
FROM silver.titles) AS bk
JOIN domainAggregate AS da
ON bk.isbn=da.isbn
LEFT JOIN temp
ON temp.workId=da.workId
LEFT JOIN gold.dim_category AS ca
ON temp.genre=ca.catDescription
LEFT JOIN gold.dim_authors AS a
ON bk.author=a.authorName
GROUP BY bk.isbn;

SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';

SET @batch_end_time = GETDATE();
PRINT '===============================================================';
PRINT 'Loading Gold Layer Completed';
PRINT ' Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time,@batch_end_time) AS NVARCHAR) + ' seconds';
PRINT '===============================================================';
END TRY
BEGIN CATCH
	PRINT '===============================================================';
	PRINT 'Error Ocurred while Loading Gold Layer';
	PRINT 'Error Message ' + ERROR_MESSAGE();
	PRINT 'Error Message ' + CAST(ERROR_NUMBER() AS NVARCHAR);
	PRINT 'Error Message ' + CAST(ERROR_STATE() AS NVARCHAR);
	PRINT '===============================================================';
END CATCH
END