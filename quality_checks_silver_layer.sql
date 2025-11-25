-- ------------------------Quality Checks for catSets-------------------------------------
SELECT * FROM silver.catSets
WHERE catSetDesc IS NULL OR catSetId IS NULL;

SELECT * FROM silver.catSets
WHERE TRIM(catSetDesc)!= catSetDesc OR UPPER(TRIM(catSetId))!=catSetId;

SELECT * FROM silver.catSets
WHERE domain NOT IN ('AUDIO','DK.COM','PRH.CA','PRH.US','SALESINTERNATIONAL');

-- ------------------------Quality Checks for categories-------------------------------------
SELECT catSetId, COUNT(catSetId) FROM silver.categories
WHERE catUri IS NULL
GROUP BY catSetId;

SELECT domain,COUNT(DISTINCT description) AS count_of_distinct,
COUNT(description) AS total
FROM silver.categories
GROUP BY domain;

SELECT * FROM silver.categories
WHERE catUri LIKE '/%';

SELECT * FROM silver.categories
WHERE hasChildren IS NULL OR
seq IS NULL OR
weight IS NULL;

SELECT * FROM silver.categories
WHERE ISNUMERIC(catUri)=1 OR ISNUMERIC(menuText)=1;

-- ------------------------Quality Checks for authors-------------------------------------
SELECT * FROM silver.authors
WHERE events IS NULL OR photocredit IS NULL OR photoDate IS NULL;

SELECT authorId,authorName,domain
FROM silver.authors 
GROUP BY authorId,authorName,domain
HAVING COUNT(*)>1;

SELECT * FROM silver.authors
WHERE authorId IS NULL OR authorName IS NULL;

SELECT DISTINCT hasAuthorPhoto 
FROM silver.authors;

SELECT DISTINCT ontour 
FROM silver.authors;

SELECT * FROM silver.authors
WHERE lastInitial IS NULL or firstInitial IS NULL;

SELECT * FROM silver.authors
WHERE seofriendlyUrl IS NULL OR last IS NULL or first IS NULL;

SELECT * FROM silver.authors
WHERE authorOf_workId IS NULL or authorOf_title IS NULL;

SELECT * FROM silver.authors
WHERE authorOf_publisher_description!=TRIM(authorOf_publisher_description);

SELECT * FROM silver.authors
WHERE authorOf_ISBN IS NULL OR authorOf_seoFriendlyUrl IS NULL
OR authorOf_subtitle IS NULL OR authorOf_publisher_code IS NULL
OR authorOf_publisher_code IS NULL OR authorOf_publisher_description IS NULL
OR authorOf_onsale IS NULL;

-- ------------------------Quality Checks for events-------------------------------------
-----------------------------------------------------------------------------------------

SELECT COUNT(*) FROM silver.events;

SELECT * FROM silver.events
WHERE eventId IS NULL OR eventDate IS NULL OR location IS NULL;

SELECT DISTINCT domain FROM silver.events;

SELECT * FROM silver.events
WHERE city IS NULL OR zip IS NULL
OR state IS NULL OR status IS NULL;

SELECT * FROM silver.events
WHERE state != UPPER(TRIM(state));

SELECT * FROM silver.events
WHERE status != TRIM(status);

SELECT * FROM silver.events
WHERE descriptions IS NULL OR comments IS NULL;

SELECT * FROM silver.events
WHERE referenceUrl IS NULL;

-- ------------------------Quality Checks for roles-------------------------------------
-----------------------------------------------------------------------------------------
SELECT * FROM silver.roles
WHERE code is NULL;

SELECT * FROM silver.roles
WHERE description is NULL;

SELECT * FROM silver.roles
WHERE TRIM(description)!=description OR TRIM(code)!=code;

SELECT COUNT(*) FROM silver.roles
GROUP BY code,description,domain
HAVING COUNT(*)>1;

-- ------------------------Quality Checks for series-------------------------------------
-----------------------------------------------------------------------------------------
SELECT * FROM silver.series
WHERE seriesCode IS NULL OR seriesName IS NULL;

SELECT DISTINCT isNumbered FROM silver.series;
SELECT DISTINCT isKids FROM silver.series;

SELECT * FROM silver.series
WHERE seriesCount IS NULL;

SELECT * FROM silver.series
WHERE seoFriendlyUrl IS NULL

SELECT COUNT(*) FROM silver.series
GROUP BY seriesCode,seriesName,domain
HAVING COUNT(*)>1;

-- ------------------------Quality Checks for titles-------------------------------------
-----------------------------------------------------------------------------------------
SELECT * FROM silver.titles
WHERE isbn IS NULL OR isbnHyphenated IS NULL
OR title IS NULL OR onsale IS NULL

SELECT isbn,title FROM silver.titles
GROUP BY isbn,title
HAVING COUNT(*)>1;

SELECT * FROM silver.titles
WHERE author IS NULL OR author!=TRIM(author);

SELECT * FROM silver.titles
WHERE pages IS NULL OR trim IS NULL OR
formatFamily IS NULL OR consumerFormat IS NULL

SELECT * FROM silver.titles
WHERE consumerImprintUri IS NULL OR consumerImprint IS NULL OR
boxComponentCt IS NULL OR originalIsbn IS NULL

SELECT * FROM silver.titles
WHERE seoFriendlyUrl IS NULL OR
subseries IS NULL

SELECT DISTINCT productType FROM silver.titles
SELECT * FROM silver.titles
WHERE productLine IS NULL

SELECT * FROM silver.titles
WHERE isbn NOT IN
(SELECT isbn FROM dbo.works_AUDIO)

-- ------------------------Quality Checks for works-------------------------------------
-----------------------------------------------------------------------------------------
SELECT * FROM silver.works
WHERE workId IS NULL OR title IS NULL;

SELECT * FROM silver.works
WHERE coverUrl IS NULL OR 
earliestOnSaleDate IS NULL OR
genre IS NULL;

SELECT COUNT(*) FROM silver.works
GROUP BY workId,title,domain
HAVING COUNT(*)>1;

--EXEC silver.create_silver_layer;

--EXEC silver.load_silver_layer;