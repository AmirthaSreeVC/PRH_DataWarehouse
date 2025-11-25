-- EXEC silver.load_silver_layer

CREATE OR ALTER PROCEDURE silver.load_silver_layer AS 
BEGIN
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
BEGIN TRY
SET @batch_start_time = GETDATE();
PRINT '===============================================================';
PRINT 'Loading Silver Layer';
PRINT '===============================================================';

PRINT '---------------------------------------------------------------';
PRINT 'Loading catSets Tables';
PRINT '---------------------------------------------------------------';


-- --------------------------- catSets -----------------------------------
--------------------------------------------------------------------------
SET @start_time = GETDATE();
PRINT '>> Truncating Table : silver.catSets';
TRUNCATE TABLE silver.catSets;

PRINT '>> Inserting Data[AUDIO] Into : silver.catSets';
INSERT INTO silver.catSets(catSetId,catSetDesc,domain)
SELECT UPPER(TRIM(catSetId)), 
CASE WHEN TRIM(catSetDesc) IS NOT NULL THEN TRIM(catSetDesc)
     ELSE 'Missing'
	 END AS catSetDesc,
'AUDIO'
FROM dbo.catSets_AUDIO


PRINT '>> Inserting Data[DK.COM] Into : silver.catSets';
INSERT INTO silver.catSets(catSetId,catSetDesc,domain)
SELECT UPPER(TRIM(catSetId)), 
CASE WHEN TRIM(catSetDesc) IS NOT NULL THEN TRIM(catSetDesc)
     ELSE 'Missing'
	 END AS catSetDesc,
'DK.COM'
FROM dbo.[catSets_DK.COM];


PRINT '>> Inserting Data[PRH.CA] Into : silver.catSets';
INSERT INTO silver.catSets(catSetId,catSetDesc,domain)
SELECT UPPER(TRIM(catSetId)), 
CASE WHEN TRIM(catSetDesc) IS NOT NULL THEN TRIM(catSetDesc)
     ELSE 'Missing'
	 END AS catSetDesc,
'PRH.CA'
FROM dbo.[catSets_PRH.CA];


PRINT '>> Inserting Data[PRH.US] Into : silver.catSets';
INSERT INTO silver.catSets(catSetId,catSetDesc,domain)
SELECT UPPER(TRIM(catSetId)), 
CASE WHEN TRIM(catSetDesc) IS NOT NULL THEN TRIM(catSetDesc)
     ELSE 'Missing'
	 END AS catSetDesc,
'PRH.US'
FROM dbo.[catSets_PRH.US];


PRINT '>> Inserting Data[SALESINTERNATIONAL] Into : silver.catSets';
INSERT INTO silver.catSets(catSetId,catSetDesc,domain)
SELECT UPPER(TRIM(catSetId)), 
CASE WHEN TRIM(catSetDesc) IS NOT NULL THEN TRIM(catSetDesc)
     ELSE 'Missing'
	 END AS catSetDesc,
'SALESINTERNATIONAL'
FROM dbo.catSets_SALESINTERNATIONAL;

SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';

-- ---------------------------------------- categories ---------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
PRINT '---------------------------------------------------------------';
PRINT 'Loading categories Tables';
PRINT '---------------------------------------------------------------';

SET @start_time = GETDATE();

TRUNCATE TABLE silver.categories;
PRINT '>> Inserting Data[AUDIO] Into : silver.categories';
INSERT INTO silver.categories(catId,description,catSetId,catUri,menuText,hasChildren,seq,weight,domain)
SELECT catId,
TRIM(description),
UPPER(TRIM(catSetId)),
CASE WHEN catUri LIKE '/%' THEN LOWER(TRIM(REPLACE(catUri,'/','')))
     WHEN catUri IS NULL OR ISNUMERIC(catUri)=1 THEN LOWER(description)
	 ELSE LOWER(TRIM(catUri))
	 END AS caturi,
CASE WHEN menuText IS NULL OR ISNUMERIC(menuText)=1 THEN description
     ELSE menuText
	 END AS menuText,
hasChildren,
CASE WHEN seq IS NULL THEN 0
     ELSE seq
	 END AS seq,
CASE WHEN weight IS NULL THEN 0
     ELSE weight
	 END AS weight,
'AUDIO'
FROM (SELECT *,
ROW_NUMBER() OVER(PARTITION BY description ORDER BY catSetId) as row_num
FROM dbo.categories_AUDIO) audio
WHERE row_num=1;

PRINT '>> Inserting Data[DK.COM] Into : silver.categories';
INSERT INTO silver.categories(catId,description,catSetId,catUri,menuText,hasChildren,seq,weight,domain)
SELECT catId,
TRIM(description),
UPPER(TRIM(catSetId)),
CASE WHEN catUri LIKE '/%' THEN LOWER(TRIM(REPLACE(catUri,'/','')))
     WHEN catUri IS NULL OR ISNUMERIC(catUri)=1 THEN LOWER(description)
	 ELSE LOWER(TRIM(catUri))
	 END AS caturi,
CASE WHEN menuText IS NULL OR ISNUMERIC(menuText)=1 THEN description
     ELSE menuText
	 END AS menuText,
hasChildren,
CASE WHEN seq IS NULL THEN 0
     ELSE seq
	 END AS seq,
CASE WHEN weight IS NULL THEN 0
     ELSE weight
	 END AS weight,
'DK.COM'
FROM (SELECT *,
ROW_NUMBER() OVER(PARTITION BY description ORDER BY catSetId) as row_num
FROM dbo.[categories_DK.COM]) dk_com
WHERE row_num=1;

PRINT '>> Inserting Data[PRH.CA] Into : silver.categories';
INSERT INTO silver.categories(catId,description,catSetId,catUri,menuText,hasChildren,seq,weight,domain)
SELECT catId,
TRIM(description),
UPPER(TRIM(catSetId)),
CASE WHEN catUri LIKE '/%' THEN LOWER(TRIM(REPLACE(catUri,'/','')))
     WHEN catUri IS NULL OR ISNUMERIC(catUri)=1 THEN LOWER(description)
	 ELSE LOWER(TRIM(catUri))
	 END AS caturi,
CASE WHEN menuText IS NULL OR ISNUMERIC(menuText)=1 THEN description
     ELSE menuText
	 END AS menuText,
hasChildren,
CASE WHEN seq IS NULL THEN 0
     ELSE seq
	 END AS seq,
CASE WHEN weight IS NULL THEN 0
     ELSE weight
	 END AS weight,
'PRH.CA'
FROM (SELECT *,
ROW_NUMBER() OVER(PARTITION BY description ORDER BY catSetId) as row_num
FROM dbo.[categories_PRH.CA]) prh_ca
WHERE row_num=1;

PRINT '>> Inserting Data[PRH.US] Into : silver.categories';
INSERT INTO silver.categories(catId,description,catSetId,catUri,menuText,hasChildren,seq,weight,domain)
SELECT catId,
TRIM(description),
UPPER(TRIM(catSetId)),
CASE WHEN catUri LIKE '/%' THEN LOWER(TRIM(REPLACE(catUri,'/','')))
     WHEN catUri IS NULL OR ISNUMERIC(catUri)=1 THEN LOWER(description)
	 ELSE LOWER(TRIM(catUri))
	 END AS caturi,
CASE WHEN menuText IS NULL OR ISNUMERIC(menuText)=1 THEN description
     ELSE menuText
	 END AS menuText,
hasChildren,
CASE WHEN seq IS NULL THEN 0
     ELSE seq
	 END AS seq,
CASE WHEN weight IS NULL THEN 0
     ELSE weight
	 END AS weight,
'PRH.US'
FROM (SELECT *,
ROW_NUMBER() OVER(PARTITION BY description ORDER BY catSetId) as row_num
FROM dbo.[categories_PRH.US]) prh_us
WHERE row_num=1;

PRINT '>> Inserting Data[SALESINTERNATIONAL] Into : silver.categories';
INSERT INTO silver.categories(catId,description,catSetId,catUri,menuText,hasChildren,seq,weight,domain)
SELECT catId,
TRIM(description),
UPPER(TRIM(catSetId)),
CASE WHEN catUri LIKE '/%' THEN LOWER(TRIM(REPLACE(catUri,'/','')))
     WHEN catUri IS NULL OR ISNUMERIC(catUri)=1 THEN LOWER(description)
	 ELSE LOWER(TRIM(catUri))
	 END AS caturi,
CASE WHEN menuText IS NULL OR ISNUMERIC(menuText)=1 THEN description
     ELSE menuText
	 END AS menuText,
hasChildren,
CASE WHEN seq IS NULL THEN 0
     ELSE seq
	 END AS seq,
CASE WHEN weight IS NULL THEN 0
     ELSE weight
	 END AS weight,
'SALESINTERNATIONAL'
FROM (SELECT *,
ROW_NUMBER() OVER(PARTITION BY description ORDER BY catSetId) as row_num
FROM dbo.[categories_SALESINTERNATIONAL]) sales_int
WHERE row_num=1;

SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';

-- ---------------------------------- authors ------------------------------------------------
----------------------------------------------------------------------------------------------
PRINT '---------------------------------------------------------------';
PRINT 'Loading authors Tables';
PRINT '---------------------------------------------------------------';

SET @start_time = GETDATE();

TRUNCATE TABLE silver.authors;
PRINT '>> Inserting Data[AUDIO] Into : silver.authors';
INSERT INTO silver.authors(authorId,authorName,ontour, --spotlight,
                           hasAuthorPhoto,photoCredit,photoDate,
                           firstInitial,lastInitial,events,seoFriendlyUrl,first,last,contribRoles,
						   authorOf_workId,authorOf_title,authorOf_ISBN,authorOf_seoFriendlyUrl,
						   authorOf_subtitle,authorOf_publisher_code,authorOf_publisher_description,
						   authorOf_onsale,domain)
SELECT 
authorId,
REPLACE(REPLACE(TRIM(display),'"',''),'@',''),
CASE WHEN ontour='1' THEN 'Yes'
     ELSE 'No'
	 END AS ontour,
/*CASE WHEN spotlight IS NULL THEN 'Not Available'
     ELSE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(spotlight,'<b>',''),'</b>',''),'<i>',''),'</i>',''),'<u>','')
	 END AS spotlight,*/
CASE WHEN hasAuthorPhoto='1' THEN 'Yes'
     ELSE 'No'
	 END AS hasAuthorPhoto,
CASE WHEN photocredit IS NULL AND hasAuthorPhoto='1' THEN 'Courtesy of author'
     WHEN photocredit IS NULL AND hasAuthorPhoto='0' THEN 'No Photo'
	 ELSE photocredit
	 END AS photocredit,
CASE WHEN photoDate IS NULL THEN TRY_CAST(YEAR([authorOf.onsale]) AS INT)
     WHEN photoDate='5/16' THEN 2016
     ELSE photoDate
	 END AS photoDate,
CASE WHEN firstInitial IS NULL THEN 'Nil'
     ELSE firstInitial
	 END AS firstInitial,
TRIM(lastInitial),
CASE WHEN events IS NULL THEN 'Nil'
     ELSE events
	 END AS events,
TRIM(seofriendlyUrl),
CASE WHEN first IS NULL THEN 'Nil'
     ELSE first
	 END AS first,
TRIM(last),
'Author',
[authorOf.workId],
[authorOf.title],
[authorOf.isbn],
[authorOf.seoFriendlyUrl],
CASE WHEN [authorOf.subtitle] IS NULL THEN 'Nil'
     ELSE [authorOf.subtitle]
	 END AS [authorOf.subtitle],
[authorOf.publisher.code],
CASE WHEN [authorOf.publisher.description] IS NULL THEN 'Nil'
     ELSE [authorOf.publisher.description]
	 END AS [authorOf.publisher.description],
[authorOf.onsale],
'AUDIO'
FROM dbo.authors_AUDIO;


PRINT '>> Inserting Data[DK.COM] Into : silver.authors';
INSERT INTO silver.authors(authorId,authorName,ontour, --spotlight,
                           hasAuthorPhoto,photoCredit,photoDate,
                           firstInitial,lastInitial,events,seoFriendlyUrl,first,last,contribRoles,
						   authorOf_workId,authorOf_title,authorOf_ISBN,authorOf_seoFriendlyUrl,
						   authorOf_subtitle,authorOf_publisher_code,authorOf_publisher_description,
						   authorOf_onsale,domain)
SELECT 
authorId,
REPLACE(REPLACE(TRIM(display),'"',''),'@',''),
CASE WHEN ontour='1' THEN 'Yes'
     ELSE 'No'
	 END AS ontour,
/*CASE WHEN spotlight IS NULL THEN 'Not Available'
     ELSE REGEXP_REPLACE( 
	            REGEXP_REPLACE(spotlight,'%&%;%',''),
				'%<%>',
				'')
	 END AS spotlight,*/
CASE WHEN hasAuthorPhoto='1' THEN 'Yes'
     ELSE 'No'
	 END AS hasAuthorPhoto,
CASE WHEN photocredit IS NULL AND hasAuthorPhoto='1' THEN 'Courtesy of author'
     WHEN photocredit IS NULL AND hasAuthorPhoto='0' THEN 'No Photo'
	 ELSE photocredit
	 END AS photocredit,
CASE WHEN photoDate IS NULL THEN TRY_CAST(YEAR([authorOf.onsale]) AS INT)
	 WHEN photoDate='5/16' THEN 2016
     ELSE photoDate
	 END AS photoDate,
CASE WHEN firstInitial IS NULL THEN 'Nil'
     ELSE firstInitial
	 END AS firstInitial,
TRIM(lastInitial),
CASE WHEN events IS NULL THEN 'Nil'
     ELSE events
	 END AS events,
TRIM(seofriendlyUrl),
CASE WHEN first IS NULL THEN 'Nil'
     ELSE first
	 END AS first,
TRIM(last),
'Author',
[authorOf.workId],
[authorOf.title],
[authorOf.isbn],
[authorOf.seoFriendlyUrl],
CASE WHEN [authorOf.subtitle] IS NULL THEN 'Nil'
     ELSE [authorOf.subtitle]
	 END AS [authorOf.subtitle],
[authorOf.publisher.code],
CASE WHEN [authorOf.publisher.description] IS NULL THEN 'Nil'
     ELSE [authorOf.publisher.description]
	 END AS [authorOf.publisher.description],
[authorOf.onsale],
'DK.COM'
FROM dbo.[authors_DK.COM];


PRINT '>> Inserting Data[PRH.CA] Into : silver.authors';
INSERT INTO silver.authors(authorId,authorName,ontour, --spotlight,
						   hasAuthorPhoto,photoCredit,photoDate,
                           firstInitial,lastInitial,events,seoFriendlyUrl,first,last,contribRoles,
						   authorOf_workId,authorOf_title,authorOf_ISBN,authorOf_seoFriendlyUrl,
						   authorOf_subtitle,authorOf_publisher_code,authorOf_publisher_description,
						   authorOf_onsale,domain)
SELECT 
authorId,
REPLACE(REPLACE(TRIM(display),'"',''),'@',''),
CASE WHEN ontour='1' THEN 'Yes'
     ELSE 'No'
	 END AS ontour,
/*CASE WHEN spotlight IS NULL THEN 'Not Available'
     ELSE REGEXP_REPLACE( 
	            REGEXP_REPLACE(spotlight,'%&%;%',''),
				'%<%>',
				'')
	 END AS spotlight,*/
CASE WHEN hasAuthorPhoto='1' THEN 'Yes'
     ELSE 'No'
	 END AS hasAuthorPhoto,
CASE WHEN photocredit IS NULL AND hasAuthorPhoto='1' THEN 'Courtesy of author'
     WHEN photocredit IS NULL AND hasAuthorPhoto='0' THEN 'No Photo'
	 ELSE photocredit
	 END AS photocredit,
CASE WHEN photoDate IS NULL THEN TRY_CAST(YEAR([authorOf.onsale]) AS INT)
     WHEN photoDate='5/16' THEN 2016
	 ELSE photoDate
	 END AS photoDate,
CASE WHEN firstInitial IS NULL THEN 'Nil'
     ELSE firstInitial
	 END AS firstInitial,
TRIM(lastInitial),
CASE WHEN events IS NULL THEN 'Nil'
     ELSE events
	 END AS events,
TRIM(seofriendlyUrl),
CASE WHEN first IS NULL THEN 'Nil'
     ELSE first
	 END AS first,
TRIM(last),
'Author',
[authorOf.workId],
[authorOf.title],
[authorOf.isbn],
[authorOf.seoFriendlyUrl],
CASE WHEN [authorOf.subtitle] IS NULL THEN 'Nil'
     ELSE [authorOf.subtitle]
	 END AS [authorOf.subtitle],
[authorOf.publisher.code],
CASE WHEN [authorOf.publisher.description] IS NULL THEN 'Nil'
     ELSE [authorOf.publisher.description]
	 END AS [authorOf.publisher.description],
[authorOf.onsale],
'PRH.CA'
FROM dbo.[authors_PRH.CA];


PRINT '>> Inserting Data[PRH.US] Into : silver.authors';
INSERT INTO silver.authors(authorId,authorName,ontour, --spotlight,
						   hasAuthorPhoto,photoCredit,photoDate,
                           firstInitial,lastInitial,events,seoFriendlyUrl,first,last,contribRoles,
						   authorOf_workId,authorOf_title,authorOf_ISBN,authorOf_seoFriendlyUrl,
						   authorOf_subtitle,authorOf_publisher_code,authorOf_publisher_description,
						   authorOf_onsale,domain)
SELECT 
authorId,
REPLACE(REPLACE(TRIM(display),'"',''),'@',''),
CASE WHEN ontour='1' THEN 'Yes'
     ELSE 'No'
	 END AS ontour,
/*CASE WHEN spotlight IS NULL THEN 'Not Available'
     ELSE REGEXP_REPLACE( 
	            REGEXP_REPLACE(spotlight,'%&%;%',''),
				'%<%>',
				'')
	 END AS spotlight,*/
CASE WHEN hasAuthorPhoto='1' THEN 'Yes'
     ELSE 'No'
	 END AS hasAuthorPhoto,
CASE WHEN photocredit IS NULL AND hasAuthorPhoto='1' THEN 'Courtesy of author'
     WHEN photocredit IS NULL AND hasAuthorPhoto='0' THEN 'No Photo'
	 ELSE photocredit
	 END AS photocredit,
CASE WHEN photoDate IS NULL THEN TRY_CAST(YEAR([authorOf.onsale]) AS INT)
     WHEN photoDate='5/16' THEN 2016
	 ELSE photoDate
	 END AS photoDate,
CASE WHEN firstInitial IS NULL THEN 'Nil'
     ELSE firstInitial
	 END AS firstInitial,
TRIM(lastInitial),
CASE WHEN events IS NULL THEN 'Nil'
     ELSE events
	 END AS events,
TRIM(seofriendlyUrl),
CASE WHEN first IS NULL THEN 'Nil'
     ELSE first
	 END AS first,
TRIM(last),
'Author',
[authorOf.workId],
[authorOf.title],
[authorOf.isbn],
[authorOf.seoFriendlyUrl],
CASE WHEN [authorOf.subtitle] IS NULL THEN 'Nil'
     ELSE [authorOf.subtitle]
	 END AS [authorOf.subtitle],
[authorOf.publisher.code],
CASE WHEN [authorOf.publisher.description] IS NULL THEN 'Nil'
     ELSE [authorOf.publisher.description]
	 END AS [authorOf.publisher.description],
[authorOf.onsale],
'PRH.US'
FROM dbo.[authors_PRH.US];


PRINT '>> Inserting Data[SALESINTERNATIONAL] Into : silver.authors';
INSERT INTO silver.authors(authorId,authorName,ontour, --spotlight,
						   hasAuthorPhoto,photoCredit,photoDate,
                           firstInitial,lastInitial,events,seoFriendlyUrl,first,last,contribRoles,
						   authorOf_workId,authorOf_title,authorOf_ISBN,authorOf_seoFriendlyUrl,
						   authorOf_subtitle,authorOf_publisher_code,authorOf_publisher_description,
						   authorOf_onsale,domain)
SELECT 
authorId,
REPLACE(REPLACE(TRIM(display),'"',''),'@',''),
CASE WHEN ontour='1' THEN 'Yes'
     ELSE 'No'
	 END AS ontour,
/*CASE WHEN spotlight IS NULL THEN 'Not Available'
     ELSE REGEXP_REPLACE( 
	            REGEXP_REPLACE(spotlight,'%&%;%',''),
				'%<%>',
				'')
	 END AS spotlight,*/
CASE WHEN hasAuthorPhoto='1' THEN 'Yes'
     ELSE 'No'
	 END AS hasAuthorPhoto,
CASE WHEN photocredit IS NULL AND hasAuthorPhoto='1' THEN 'Courtesy of author'
     WHEN photocredit IS NULL AND hasAuthorPhoto='0' THEN 'No Photo'
	 ELSE photocredit
	 END AS photocredit,
CASE WHEN photoDate IS NULL THEN TRY_CAST(YEAR([authorOf.onsale]) AS INT)
     WHEN photoDate='5/16' THEN 2016
	 ELSE photoDate
	 END AS photoDate,
CASE WHEN firstInitial IS NULL THEN 'Nil'
     ELSE firstInitial
	 END AS firstInitial,
TRIM(lastInitial),
CASE WHEN events IS NULL THEN 'Nil'
     ELSE events
	 END AS events,
TRIM(seofriendlyUrl),
CASE WHEN first IS NULL THEN 'Nil'
     ELSE first
	 END AS first,
TRIM(last),
'Author',
[authorOf.workId],
[authorOf.title],
[authorOf.isbn],
[authorOf.seoFriendlyUrl],
CASE WHEN [authorOf.subtitle] IS NULL THEN 'Nil'
     ELSE [authorOf.subtitle]
	 END AS [authorOf.subtitle],
[authorOf.publisher.code],
CASE WHEN [authorOf.publisher.description] IS NULL THEN 'Nil'
     ELSE [authorOf.publisher.description]
	 END AS [authorOf.publisher.description],
[authorOf.onsale],
'SALESINTERNATIONAL'
FROM dbo.authors_SALESINTERNATIONAL;

SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';

-------------------------------------------- Events ---------------------------------------------
-------------------------------------------------------------------------------------------------
PRINT '---------------------------------------------------------------';
PRINT 'Loading events Tables';
PRINT '---------------------------------------------------------------';

SET @start_time = GETDATE();

TRUNCATE TABLE silver.events;
PRINT '>> Inserting Data[AUDIO] Into : silver.events';
INSERT INTO silver.events(eventId,eventDate,location,eventTime,address1,
                          city,state,zip,status,eventDateEnd,descriptions,comments,referenceUrl,domain)
SELECT 
eventId,
eventDate,
TRIM(location),
CASE WHEN LOWER(eventTime) LIKE '%p%m%' OR LOWER(eventTime) LIKE '%a%m' 
     THEN (CASE WHEN LEFT(CONVERT(VARCHAR(8),TRY_CAST(REPLACE(LOWER(eventTime),'.','') AS TIME),108),5) IS NULL 
	       THEN '19:00'
		   ELSE LEFT(CONVERT(VARCHAR(8),TRY_CAST(REPLACE(LOWER(eventTime),'.','') AS TIME),108),5) 
		   END)
	 WHEN LOWER(eventTime) LIKE '%tk%' OR LOWER(eventTime) LIKE '%noon%' THEN '12:00'
	 WHEN LOWER(eventTime) LIKE '%t%' OR LOWER(eventTime) LIKE '%e%'
	 THEN (CASE WHEN 
	       LEFT(CONVERT(VARCHAR(8),TRY_CAST(TRANSLATE(LOWER(eventTime),'estcdik','       ')AS TIME),108),5) IS NULL
		   THEN '19:00'
		   ELSE LEFT(CONVERT(VARCHAR(8),TRY_CAST(TRANSLATE(LOWER(eventTime),'estcdik','       ')AS TIME),108),5)
		   END)
     ELSE '10:00' 
	 END AS eventTime,
CASE WHEN address1 IS NULL AND LOWER(location) LIKE '%virtual%event%'
     THEN 'virtual event'
     WHEN address1 IS NULL
     THEN TRIM(SUBSTRING(location,PATINDEX('%[0-9]%',location),LEN(location)-PATINDEX('[0-9]%',location)+1))
     ELSE TRIM(address1)
	 END AS address1,
CASE WHEN city IS NULL THEN 'Virtual'
     ELSE TRIM(city)
	 END AS city,
state,
CASE WHEN zip IS NULL AND LOWER(location) LIKE '%virtual%event%'
     THEN '00000'
	 WHEN zip IS NULL THEN 'Nil'
	 ELSE zip
	 END AS zip,
status,
CASE WHEN eventDateEnd IS NULL THEN eventDate
     ELSE eventDateEnd
	 END AS eventDateEnd,
CASE WHEN description IS NULL THEN 'Nil'
	 ELSE TRIM(description)
	 END AS description,
CASE WHEN comments IS NULL THEN 'No comment'
	 ELSE TRIM(comments)
	 END AS comments,
CASE WHEN referenceUrl IS NULL THEN 'Nil'
	 ELSE referenceUrl
	 END AS referenceUrl,
'AUDIO'
FROM dbo.events_AUDIO
WHERE location IS NOT NULL;


PRINT '>> Inserting Data[DK.COM] Into : silver.events';
INSERT INTO silver.events(eventId,eventDate,location,eventTime,address1,
                          city,state,zip,status,eventDateEnd,descriptions,comments,referenceUrl,domain)
SELECT 
eventId,
eventDate,
TRIM(location),
CASE WHEN LOWER(eventTime) LIKE '%p%m%' OR LOWER(eventTime) LIKE '%a%m' 
     THEN (CASE WHEN LEFT(CONVERT(VARCHAR(8),TRY_CAST(REPLACE(LOWER(eventTime),'.','') AS TIME),108),5) IS NULL 
	       THEN '19:00'
		   ELSE LEFT(CONVERT(VARCHAR(8),TRY_CAST(REPLACE(LOWER(eventTime),'.','') AS TIME),108),5) 
		   END)
	 WHEN LOWER(eventTime) LIKE '%tk%' OR LOWER(eventTime) LIKE '%noon%' THEN '12:00'
	 WHEN LOWER(eventTime) LIKE '%t%' OR LOWER(eventTime) LIKE '%e%'
	 THEN (CASE WHEN 
	       LEFT(CONVERT(VARCHAR(8),TRY_CAST(TRANSLATE(LOWER(eventTime),'estcdik','       ')AS TIME),108),5) IS NULL
		   THEN '19:00'
		   ELSE LEFT(CONVERT(VARCHAR(8),TRY_CAST(TRANSLATE(LOWER(eventTime),'estcdik','       ')AS TIME),108),5)
		   END)
     ELSE '10:00' 
	 END AS eventTime,
CASE WHEN address1 IS NULL AND LOWER(location) LIKE '%virtual%event%'
     THEN 'virtual event'
     WHEN address1 IS NULL
     THEN TRIM(SUBSTRING(location,PATINDEX('%[0-9]%',location),LEN(location)-PATINDEX('[0-9]%',location)+1))
     ELSE TRIM(address1)
	 END AS address1,
CASE WHEN city IS NULL THEN 'Virtual'
     ELSE TRIM(city)
	 END AS city,
state,
CASE WHEN zip IS NULL AND LOWER(location) LIKE '%virtual%event%'
     THEN '00000'
	 WHEN zip IS NULL THEN 'Nil'
	 ELSE zip
	 END AS zip,
status,
CASE WHEN eventDateEnd IS NULL THEN eventDate
     ELSE eventDateEnd
	 END AS eventDateEnd,
CASE WHEN description IS NULL THEN 'Nil'
	 ELSE TRIM(description)
	 END AS description,
CASE WHEN comments IS NULL THEN 'No comment'
	 ELSE TRIM(comments)
	 END AS comments,
CASE WHEN referenceUrl IS NULL THEN 'Nil'
	 ELSE referenceUrl
	 END AS referenceUrl,
'DK.COM'
FROM dbo.[events_DK.COM]
WHERE location IS NOT NULL;


PRINT '>> Inserting Data[PRH.CA] Into : silver.events';
INSERT INTO silver.events(eventId,eventDate,location,eventTime,address1,
                          city,state,zip,status,eventDateEnd,descriptions,comments,referenceUrl,domain)
SELECT 
eventId,
eventDate,
TRIM(location),
CASE WHEN LOWER(eventTime) LIKE '%p%m%' OR LOWER(eventTime) LIKE '%a%m' 
     THEN (CASE WHEN LEFT(CONVERT(VARCHAR(8),TRY_CAST(REPLACE(LOWER(eventTime),'.','') AS TIME),108),5) IS NULL 
	       THEN '19:00'
		   ELSE LEFT(CONVERT(VARCHAR(8),TRY_CAST(REPLACE(LOWER(eventTime),'.','') AS TIME),108),5) 
		   END)
	 WHEN LOWER(eventTime) LIKE '%tk%' OR LOWER(eventTime) LIKE '%noon%' THEN '12:00'
	 WHEN LOWER(eventTime) LIKE '%t%' OR LOWER(eventTime) LIKE '%e%'
	 THEN (CASE WHEN 
	       LEFT(CONVERT(VARCHAR(8),TRY_CAST(TRANSLATE(LOWER(eventTime),'estcdik','       ')AS TIME),108),5) IS NULL
		   THEN '19:00'
		   ELSE LEFT(CONVERT(VARCHAR(8),TRY_CAST(TRANSLATE(LOWER(eventTime),'estcdik','       ')AS TIME),108),5)
		   END)
     ELSE '10:00' 
	 END AS eventTime,
CASE WHEN address1 IS NULL AND LOWER(location) LIKE '%virtual%event%'
     THEN 'virtual event'
     WHEN address1 IS NULL
     THEN TRIM(SUBSTRING(location,PATINDEX('%[0-9]%',location),LEN(location)-PATINDEX('[0-9]%',location)+1))
     ELSE TRIM(address1)
	 END AS address1,
CASE WHEN city IS NULL THEN 'Virtual'
     ELSE TRIM(city)
	 END AS city,
state,
CASE WHEN zip IS NULL AND LOWER(location) LIKE '%virtual%event%'
     THEN '00000'
	 WHEN zip IS NULL THEN 'Nil'
	 ELSE zip
	 END AS zip,
status,
CASE WHEN eventDateEnd IS NULL THEN eventDate
     ELSE eventDateEnd
	 END AS eventDateEnd,
CASE WHEN description IS NULL THEN 'Nil'
	 ELSE TRIM(description)
	 END AS description,
CASE WHEN comments IS NULL THEN 'No comment'
	 ELSE TRIM(comments)
	 END AS comments,
CASE WHEN referenceUrl IS NULL THEN 'Nil'
	 ELSE referenceUrl
	 END AS referenceUrl,
'PRH.CA'
FROM dbo.[events_PRH.CA]
WHERE location IS NOT NULL;


PRINT '>> Inserting Data[PRH.US] Into : silver.events';
INSERT INTO silver.events(eventId,eventDate,location,eventTime,address1,
                          city,state,zip,status,eventDateEnd,descriptions,comments,referenceUrl,domain)
SELECT 
eventId,
eventDate,
TRIM(location),
CASE WHEN LOWER(eventTime) LIKE '%p%m%' OR LOWER(eventTime) LIKE '%a%m' 
     THEN (CASE WHEN LEFT(CONVERT(VARCHAR(8),TRY_CAST(REPLACE(LOWER(eventTime),'.','') AS TIME),108),5) IS NULL 
	       THEN '19:00'
		   ELSE LEFT(CONVERT(VARCHAR(8),TRY_CAST(REPLACE(LOWER(eventTime),'.','') AS TIME),108),5) 
		   END)
	 WHEN LOWER(eventTime) LIKE '%tk%' OR LOWER(eventTime) LIKE '%noon%' THEN '12:00'
	 WHEN LOWER(eventTime) LIKE '%t%' OR LOWER(eventTime) LIKE '%e%'
	 THEN (CASE WHEN 
	       LEFT(CONVERT(VARCHAR(8),TRY_CAST(TRANSLATE(LOWER(eventTime),'estcdik','       ')AS TIME),108),5) IS NULL
		   THEN '19:00'
		   ELSE LEFT(CONVERT(VARCHAR(8),TRY_CAST(TRANSLATE(LOWER(eventTime),'estcdik','       ')AS TIME),108),5)
		   END)
     ELSE '10:00' 
	 END AS eventTime,
CASE WHEN address1 IS NULL AND LOWER(location) LIKE '%virtual%event%'
     THEN 'virtual event'
     WHEN address1 IS NULL
     THEN TRIM(SUBSTRING(location,PATINDEX('%[0-9]%',location),LEN(location)-PATINDEX('[0-9]%',location)+1))
     ELSE TRIM(address1)
	 END AS address1,
CASE WHEN city IS NULL THEN 'Virtual'
     ELSE TRIM(city)
	 END AS city,
state,
CASE WHEN zip IS NULL AND LOWER(location) LIKE '%virtual%event%'
     THEN '00000'
	 WHEN zip IS NULL THEN 'Nil'
	 ELSE zip
	 END AS zip,
status,
CASE WHEN eventDateEnd IS NULL THEN eventDate
     ELSE eventDateEnd
	 END AS eventDateEnd,
CASE WHEN description IS NULL THEN 'Nil'
	 ELSE TRIM(description)
	 END AS description,
CASE WHEN comments IS NULL THEN 'No comment'
	 ELSE TRIM(comments)
	 END AS comments,
CASE WHEN referenceUrl IS NULL THEN 'Nil'
	 ELSE referenceUrl
	 END AS referenceUrl,
'PRH.US'
FROM dbo.[events_PRH.US]
WHERE location IS NOT NULL;


PRINT '>> Inserting Data[SALESINTERNATIONAL] Into : silver.events';
INSERT INTO silver.events(eventId,eventDate,location,eventTime,address1,
                          city,state,zip,status,eventDateEnd,descriptions,comments,referenceUrl,domain)
SELECT 
eventId,
eventDate,
TRIM(location),
CASE WHEN LOWER(eventTime) LIKE '%p%m%' OR LOWER(eventTime) LIKE '%a%m' 
     THEN (CASE WHEN LEFT(CONVERT(VARCHAR(8),TRY_CAST(REPLACE(LOWER(eventTime),'.','') AS TIME),108),5) IS NULL 
	       THEN '19:00'
		   ELSE LEFT(CONVERT(VARCHAR(8),TRY_CAST(REPLACE(LOWER(eventTime),'.','') AS TIME),108),5) 
		   END)
	 WHEN LOWER(eventTime) LIKE '%tk%' OR LOWER(eventTime) LIKE '%noon%' THEN '12:00'
	 WHEN LOWER(eventTime) LIKE '%t%' OR LOWER(eventTime) LIKE '%e%'
	 THEN (CASE WHEN 
	       LEFT(CONVERT(VARCHAR(8),TRY_CAST(TRANSLATE(LOWER(eventTime),'estcdik','       ')AS TIME),108),5) IS NULL
		   THEN '19:00'
		   ELSE LEFT(CONVERT(VARCHAR(8),TRY_CAST(TRANSLATE(LOWER(eventTime),'estcdik','       ')AS TIME),108),5)
		   END)
     ELSE '10:00' 
	 END AS eventTime,
CASE WHEN address1 IS NULL AND LOWER(location) LIKE '%virtual%event%'
     THEN 'virtual event'
     WHEN address1 IS NULL
     THEN TRIM(SUBSTRING(location,PATINDEX('%[0-9]%',location),LEN(location)-PATINDEX('[0-9]%',location)+1))
     ELSE TRIM(address1)
	 END AS address1,
CASE WHEN city IS NULL THEN 'Virtual'
     ELSE TRIM(city)
	 END AS city,
state,
CASE WHEN zip IS NULL AND LOWER(location) LIKE '%virtual%event%'
     THEN '00000'
	 WHEN zip IS NULL THEN 'Nil'
	 ELSE zip
	 END AS zip,
status,
CASE WHEN eventDateEnd IS NULL THEN eventDate
     ELSE eventDateEnd
	 END AS eventDateEnd,
CASE WHEN description IS NULL THEN 'Nil'
	 ELSE TRIM(description)
	 END AS description,
CASE WHEN comments IS NULL THEN 'No comment'
	 ELSE TRIM(comments)
	 END AS comments,
CASE WHEN referenceUrl IS NULL THEN 'Nil'
	 ELSE referenceUrl
	 END AS referenceUrl,
'SALESINTERNATIONAL'
FROM dbo.events_SALESINTERNATIONAL
WHERE location IS NOT NULL;

SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';

-- -------------------------------------------Roles--------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
PRINT '---------------------------------------------------------------';
PRINT 'Loading roles Tables';
PRINT '---------------------------------------------------------------';

SET @start_time = GETDATE();

TRUNCATE TABLE silver.roles;
PRINT '>> Inserting Data[AUDIO] Into : silver.roles';
INSERT INTO silver.roles(code,description,domain)
SELECT code, description, 'AUDIO'
FROM dbo.roles_AUDIO;


PRINT '>> Inserting Data[DK.COM] Into : silver.roles';
INSERT INTO silver.roles(code,description,domain)
SELECT code, description, 'DK.COM'
FROM dbo.[roles_DK.COM];


PRINT '>> Inserting Data[PRH.CA] Into : silver.roles';
INSERT INTO silver.roles(code,description,domain)
SELECT code, description, 'PRH.CA'
FROM dbo.[roles_PRH.CA]


PRINT '>> Inserting Data[PRH.US] Into : silver.roles';
INSERT INTO silver.roles(code,description,domain)
SELECT code, description, 'PRH.US'
FROM dbo.[roles_PRH.US];


PRINT '>> Inserting Data[SALESINTERNATIONAL] Into : silver.roles';
INSERT INTO silver.roles(code,description,domain)
SELECT code, description, 'SALESINTERNATIONAL'
FROM dbo.[roles_SALESINTERNATIONAL];

SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';

-- -------------------------------------------series-----------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
PRINT '---------------------------------------------------------------';
PRINT 'Loading series Tables';
PRINT '---------------------------------------------------------------';

SET @start_time = GETDATE();

TRUNCATE TABLE silver.series;
PRINT '>> Inserting Data[AUDIO] Into : silver.series';
INSERT INTO silver.series(seriesCode,seriesName, --description,
                          seriesCount,seriesDate,isNumbered,isKids,seoFriendlyUrl,domain)
SELECT 
TRIM(seriesCode),
TRIM(seriesName),
/*CASE WHEN description IS NULL THEN 'Nil'
     ELSE TRIM(description) -- clr regex_replace needed
	 END AS description,*/
seriesCount,
seriesDate,
CASE WHEN isNumbered=1 THEN 'True'
     ELSE 'False'
	 END AS isNumbered,
CASE WHEN isKids=1 THEN 'True'
     ELSE 'False'
	 END AS isKids,
seoFriendlyUrl,
'AUDIO'
FROM dbo.series_AUDIO


PRINT '>> Inserting Data[DK.COM] Into : silver.series';
INSERT INTO silver.series(seriesCode,seriesName, --description,
                          seriesCount,seriesDate,isNumbered,isKids,seoFriendlyUrl,domain)
SELECT 
TRIM(seriesCode),
TRIM(seriesName),
/*CASE WHEN description IS NULL THEN 'Nil'
     ELSE TRIM(description) -- clr regex_replace needed
	 END AS description,*/
seriesCount,
seriesDate,
CASE WHEN isNumbered=1 THEN 'True'
     ELSE 'False'
	 END AS isNumbered,
CASE WHEN isKids=1 THEN 'True'
     ELSE 'False'
	 END AS isKids,
seoFriendlyUrl,
'DK.COM'
FROM dbo.[series_DK.COM]


PRINT '>> Inserting Data[PRH.CA] Into : silver.series';
INSERT INTO silver.series(seriesCode,seriesName, --description,
                          seriesCount,seriesDate,isNumbered,isKids,seoFriendlyUrl,domain)
SELECT 
TRIM(seriesCode),
TRIM(seriesName),
/*CASE WHEN description IS NULL THEN 'Nil'
     ELSE TRIM(description) -- clr regex_replace needed
	 END AS description,*/
seriesCount,
seriesDate,
CASE WHEN isNumbered=1 THEN 'True'
     ELSE 'False'
	 END AS isNumbered,
CASE WHEN isKids=1 THEN 'True'
     ELSE 'False'
	 END AS isKids,
seoFriendlyUrl,
'PRH.CA'
FROM dbo.[series_PRH.CA]


PRINT '>> Inserting Data[PRH.US] Into : silver.series';
INSERT INTO silver.series(seriesCode,seriesName, --description,
                          seriesCount,seriesDate,isNumbered,isKids,seoFriendlyUrl,domain)
SELECT 
TRIM(seriesCode),
TRIM(seriesName),
/*CASE WHEN description IS NULL THEN 'Nil'
     ELSE TRIM(description) -- clr regex_replace needed
	 END AS description,*/
seriesCount,
seriesDate,
CASE WHEN isNumbered=1 THEN 'True'
     ELSE 'False'
	 END AS isNumbered,
CASE WHEN isKids=1 THEN 'True'
     ELSE 'False'
	 END AS isKids,
seoFriendlyUrl,
'PRH.US'
FROM dbo.[series_PRH.US]


PRINT '>> Inserting Data[SALESINTERNATIONAL] Into : silver.series';
INSERT INTO silver.series(seriesCode,seriesName, --description,
                          seriesCount,seriesDate,isNumbered,isKids,seoFriendlyUrl,domain)
SELECT 
TRIM(seriesCode),
TRIM(seriesName),
/*CASE WHEN description IS NULL THEN 'Nil'
     ELSE TRIM(description) -- clr regex_replace needed
	 END AS description,*/
seriesCount,
seriesDate,
CASE WHEN isNumbered=1 THEN 'True'
     ELSE 'False'
	 END AS isNumbered,
CASE WHEN isKids=1 THEN 'True'
     ELSE 'False'
	 END AS isKids,
seoFriendlyUrl,
'SALESINTERNATIONAL'
FROM dbo.series_SALESINTERNATIONAL

SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';


-- -------------------------------------------titles-----------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
PRINT '---------------------------------------------------------------';
PRINT 'Loading titles Tables';
PRINT '---------------------------------------------------------------';

SET @start_time = GETDATE();

TRUNCATE TABLE silver.titles;
PRINT '>> Inserting Data[AUDIO] Into : silver.titles';
INSERT INTO silver.titles(isbn,isbnHyphenated,title,subtitle,author,onsale,seoFriendlyUrl,pages,
						  sgmt_desc,trim,formatFamily,consumerFormat,consumerImprint,
						  consumerImprintUri,saleStatus,language,seriesNumber,subseries,
						  editionType,propertyName,cartonQuantity,version,productLine,
						  productType,workId,titleShort,audioPackage,
						  projectedMinutes,originalIsbn,
						  illustPhoto,childrensBookCategory,asin,customSubjectCategory,coverUpdatedOn,
						  isbn10,isbn10hyphenated,boxComponentCt,focDate,cataDate,itemTypeCode,
						  mediaRating,mediaRatingDesc,coverVariantDesc,
						  sortByAuthor,graphicCategory,shortRunInd,isbnStr,
						  format_code,format_description,subformat_code,subformat_description,
						  division_code,division_description,imprint_code,imprint_description,
						  publisher_code,publisher_description,age_code,age_description,grade_code,
						  grade_description,educationGrade_code,educationGrade_description,salesRestriction_code,
						  salesRestriction_description,
						  isbnCounts_variant,isbnCounts_format,domain)
SELECT isbn,
TRIM(isbnHyphenated),
title,
CASE WHEN subtitle IS NULL THEN 'Nil'
     ELSE subtitle
	 END AS subtitle,
author,
onsale,
seoFriendlyUrl,
CASE WHEN pages IS NULL THEN '0'
     ELSE pages
	 END AS pages,
CASE WHEN sgmt_desc IS NULL THEN 'Nil'
     ELSE sgmt_desc
	 END AS sgmt_desc,
CASE WHEN trim IS NULL THEN 'Nil'
     ELSE trim
	 END AS trim,
formatFamily,consumerFormat,
CASE WHEN consumerImprint IS NULL THEN 'Nil'
     ELSE consumerImprint
	 END AS consumerImprint,
CASE WHEN consumerImprintUri IS NULL THEN 'Nil'
     ELSE consumerImprintUri
	 END AS consumerImprintUri,
CASE WHEN saleStatus='IP' THEN 'In Print'
     WHEN saleStatus='PP' THEN 'Pre Publication'
	 WHEN saleStatus='EL' THEN 'Electronic Only'
	 WHEN saleStatus='NR' THEN 'Not Yet Released'
     ELSE 'In Stock'
	 END AS saleStatus,
CASE WHEN language='SP' THEN 'Spanish'
     ELSE 'English'
	 END AS language,
CASE WHEN seriesNumber IS NULL THEN '0'
     ELSE seriesNumber
	 END AS seriesNumber,
CASE WHEN subseries IS NULL THEN 'Nil'
     ELSE subseries
	 END AS subseries,
CASE WHEN editionType IS NULL THEN TRIM([format.description])
     ELSE editionType
	 END AS editionType,
CASE WHEN propertyName IS NULL THEN 'Nil'
     ELSE propertyName
	 END AS propertyName,
cartonQuantity,
version, 
productLine, productType,
workId, titleShort,
CASE WHEN audioPackage IS NULL THEN 'Nil'
     ELSE TRIM(audioPackage)
	 END AS audioPackage,
CASE WHEN projectedMinutes IS NULL THEN 'Not Applicable/Nil'
     ELSE projectedMinutes
	 END AS projectedMinutes,
CASE WHEN originalIsbn IS NULL THEN CAST(isbn AS nvarchar)
     ELSE originalIsbn
	 END AS orginalIsbn,
CASE WHEN illustPhoto IS NULL THEN 'Nil'
     ELSE illustPhoto
	 END AS illustPhoto,
childrensBookCategory,
CASE WHEN asin IS NULL THEN 'Nil'
     ELSE asin
	 END AS asin,
CASE WHEN customSubjectCategory IS NULL THEN 'Nil'
     ELSE LOWER(customSubjectCategory)
	 END AS customSubjectCategory,
CASE WHEN coverUpdatedOn IS NULL THEN onsale
     ELSE coverUpdatedOn
	 END AS coverUpdatedOn,
CASE WHEN isbn10 IS NULL AND SUBSTRING(CAST(isbn AS varchar),1,3)=979 THEN 'Not Applicable'
     WHEN isbn10 IS NULL THEN 'Nil'
	 ELSE isbn10
	 END AS isbn10,
CASE WHEN isbn10 IS NULL AND SUBSTRING(CAST(isbn AS varchar),1,3)=979 THEN 'Not Applicable'
     WHEN isbn10 IS NULL THEN 'Nil'
	 ELSE SUBSTRING(CAST(isbn10 AS varchar),1,1)+'-'+SUBSTRING(CAST(isbn10 AS varchar),2,6)+'-'+
	      SUBSTRING(CAST(isbn10 AS varchar),8,2)+'-'+SUBSTRING(CAST(isbn10 AS varchar),9,1)
	 END AS isbnHyphenated,
boxComponentCt,
CASE WHEN focDate IS NULL THEN DATEADD(month,-1,onsale)
     ELSE focDate
	 END AS focDate,
CASE WHEN cataDate IS NULL THEN DATEADD(month,-5,onsale)
     ELSE cataDate
	 END AS cataDate,
CASE WHEN itemTypeCode IS NULL THEN 'Nil'
     ELSE itemTypeCode
	 END AS itemTypeCode,
CASE WHEN mediaRating IS NULL THEN 'Nil'
     ELSE mediaRating
	 END AS mediaRating,
CASE WHEN mediaRatingDesc IS NULL THEN 'Nil'
     ELSE mediaRatingDesc
	 END AS mediaRatingDesc,
CASE WHEN coverVariantDesc IS NULL THEN 'Nil'
     ELSE coverVariantDesc
	 END AS coverVariantDesc,
CASE WHEN sortByAuthor IS NULL THEN 'Nil'
     ELSE sortByAuthor
	 END AS sortByAuthor,
CASE WHEN graphicCategory IS NULL THEN 'Nil'
     ELSE graphicCategory
	 END AS graphicCategory,
CASE WHEN shortRunInd='1' THEN 'Standard Small Trim'
	 WHEN shortRunInd='5' THEN 'Medium Trade Paperbook'
	 WHEN shortRunInd='8' THEN 'Picture Book'
	 WHEN shortRunInd='9' THEN 'Oversize/Premium Trim'
	 WHEN shortRunInd='A' THEN 'Standard Adult Trade Paperback'
	 WHEN shortRunInd='H' THEN 'Hardcover Variant'
	 WHEN shortRunInd='R' THEN 'Reader Edition/Reduced Trim'
	 WHEN shortRunInd='G' THEN 'Gift/Premium Edition'
	 WHEN shortRunInd='J' THEN 'Trade Paperback'
	 WHEN shortRunInd='M' THEN 'Digest'
	 WHEN shortRunInd='Z' THEN 'Oversize/Speciality'
	 WHEN shortRunInd='K' THEN 'Large Trim'
	 WHEN shortRunInd='N' THEN 'Pocket/Mass Market Trim'
     ELSE 'Nil'
	 END AS shortRunInd,
isbnStr,
[format.code], [format.description],
CASE WHEN [subformat.code] IS NULL THEN 'Nil'
     ELSE [subformat.code]
	 END AS subformat_code,
CASE WHEN [subformat.description] IS NULL THEN 'Nil'
     ELSE [subformat.description]
	 END AS subformat_description,
[division.code],[division.description],
[imprint.code], [imprint.description],
[publisher.code],[publisher.description],
CASE WHEN [age.code] IS NULL THEN 'Nil'
     ELSE SUBSTRING([age.code],1,2)+'-'+SUBSTRING([age.code],3,2)
	 END AS age_code,
CASE WHEN [age.description] IS NULL THEN 'Nil'
     ELSE [age.description]
	 END AS age_description,
CASE WHEN [grade.code] IS NULL THEN 'Nil'
     ELSE SUBSTRING([grade.code],1,2)+'-'+SUBSTRING([grade.code],3,2)
	 END AS grade_code,
CASE WHEN [grade.description] IS NULL THEN 'Nil'
     ELSE [grade.description]
	 END AS grade_description,
CASE WHEN [educationGrade.code] IS NULL THEN 'Nil'
	 WHEN LEN([educationGrade.code])=4 THEN SUBSTRING([educationGrade.code],1,2)+'-'+SUBSTRING([educationGrade.code],3,2)
     ELSE [educationGrade.code]
	 END AS educationGrade_code,
CASE WHEN [educationGrade.description] IS NULL THEN 'Nil'
     ELSE [educationGrade.description]
	 END AS educationGrade_description,
[salesRestriction.code], [salesRestriction.description],
[isbnCounts.variant],[isbnCounts.format],
'AUDIO'
FROM dbo.titles_AUDIO


PRINT '>> Inserting Data[DK.COM] Into : silver.titles';
INSERT INTO silver.titles(isbn,isbnHyphenated,title,subtitle,author,onsale,seoFriendlyUrl,pages,
						  sgmt_desc,trim,formatFamily,consumerFormat,consumerImprint,
						  consumerImprintUri,saleStatus,language,seriesNumber,subseries,
						  editionType,propertyName,cartonQuantity,version,productLine,
						  productType,workId,titleShort,audioPackage,
						  projectedMinutes,originalIsbn,
						  illustPhoto,childrensBookCategory,asin,customSubjectCategory,coverUpdatedOn,
						  isbn10,isbn10hyphenated,boxComponentCt,focDate,cataDate,itemTypeCode,
						  mediaRating,mediaRatingDesc,coverVariantDesc,
						  sortByAuthor,graphicCategory,shortRunInd,isbnStr,
						  format_code,format_description,subformat_code,subformat_description,
						  division_code,division_description,imprint_code,imprint_description,
						  publisher_code,publisher_description,age_code,age_description,grade_code,
						  grade_description,educationGrade_code,educationGrade_description,salesRestriction_code,
						  salesRestriction_description,
						  isbnCounts_variant,isbnCounts_format,domain)
SELECT isbn,
TRIM(isbnHyphenated),
title,
CASE WHEN subtitle IS NULL THEN 'Nil'
     ELSE subtitle
	 END AS subtitle,
author,
onsale,
seoFriendlyUrl,
CASE WHEN pages IS NULL THEN '0'
     ELSE pages
	 END AS pages,
CASE WHEN sgmt_desc IS NULL THEN 'Nil'
     ELSE sgmt_desc
	 END AS sgmt_desc,
CASE WHEN trim IS NULL THEN 'Nil'
     ELSE trim
	 END AS trim,
formatFamily,consumerFormat,
CASE WHEN consumerImprint IS NULL THEN 'Nil'
     ELSE consumerImprint
	 END AS consumerImprint,
CASE WHEN consumerImprintUri IS NULL THEN 'Nil'
     ELSE consumerImprintUri
	 END AS consumerImprintUri,
CASE WHEN saleStatus='IP' THEN 'In Print'
     WHEN saleStatus='PP' THEN 'Pre Publication'
	 WHEN saleStatus='EL' THEN 'Electronic Only'
	 WHEN saleStatus='NR' THEN 'Not Yet Released'
     ELSE 'In Stock'
	 END AS saleStatus,
CASE WHEN language='SP' THEN 'Spanish'
     ELSE 'English'
	 END AS language,
CASE WHEN seriesNumber IS NULL THEN '0'
     ELSE seriesNumber
	 END AS seriesNumber,
CASE WHEN subseries IS NULL THEN 'Nil'
     ELSE subseries
	 END AS subseries,
CASE WHEN editionType IS NULL THEN TRIM([format.description])
     ELSE editionType
	 END AS editionType,
CASE WHEN propertyName IS NULL THEN 'Nil'
     ELSE propertyName
	 END AS propertyName,
cartonQuantity,
version, 
productLine, productType,
workId, titleShort,
CASE WHEN audioPackage IS NULL THEN 'Nil'
     ELSE TRIM(audioPackage)
	 END AS audioPackage,
CASE WHEN projectedMinutes IS NULL THEN 'Not Applicable/Nil'
     ELSE projectedMinutes
	 END AS projectedMinutes,
CASE WHEN originalIsbn IS NULL THEN CAST(isbn AS nvarchar)
     ELSE originalIsbn
	 END AS orginalIsbn,
CASE WHEN illustPhoto IS NULL THEN 'Nil'
     ELSE illustPhoto
	 END AS illustPhoto,
childrensBookCategory,
CASE WHEN asin IS NULL THEN 'Nil'
     ELSE asin
	 END AS asin,
CASE WHEN customSubjectCategory IS NULL THEN 'Nil'
     ELSE LOWER(customSubjectCategory)
	 END AS customSubjectCategory,
CASE WHEN coverUpdatedOn IS NULL THEN onsale
     ELSE coverUpdatedOn
	 END AS coverUpdatedOn,
CASE WHEN isbn10 IS NULL AND SUBSTRING(CAST(isbn AS varchar),1,3)=979 THEN 'Not Applicable'
     WHEN isbn10 IS NULL THEN 'Nil'
	 ELSE isbn10
	 END AS isbn10,
CASE WHEN isbn10 IS NULL AND SUBSTRING(CAST(isbn AS varchar),1,3)=979 THEN 'Not Applicable'
     WHEN isbn10 IS NULL THEN 'Nil'
	 ELSE SUBSTRING(CAST(isbn10 AS varchar),1,1)+'-'+SUBSTRING(CAST(isbn10 AS varchar),2,6)+'-'+
	      SUBSTRING(CAST(isbn10 AS varchar),8,2)+'-'+SUBSTRING(CAST(isbn10 AS varchar),9,1)
	 END AS isbnHyphenated,
boxComponentCt,
CASE WHEN focDate IS NULL THEN DATEADD(month,-1,onsale)
     ELSE focDate
	 END AS focDate,
CASE WHEN cataDate IS NULL THEN DATEADD(month,-5,onsale)
     ELSE cataDate
	 END AS cataDate,
CASE WHEN itemTypeCode IS NULL THEN 'Nil'
     ELSE itemTypeCode
	 END AS itemTypeCode,
CASE WHEN mediaRating IS NULL THEN 'Nil'
     ELSE mediaRating
	 END AS mediaRating,
CASE WHEN mediaRatingDesc IS NULL THEN 'Nil'
     ELSE mediaRatingDesc
	 END AS mediaRatingDesc,
CASE WHEN coverVariantDesc IS NULL THEN 'Nil'
     ELSE coverVariantDesc
	 END AS coverVariantDesc,
CASE WHEN sortByAuthor IS NULL THEN 'Nil'
     ELSE sortByAuthor
	 END AS sortByAuthor,
CASE WHEN graphicCategory IS NULL THEN 'Nil'
     ELSE graphicCategory
	 END AS graphicCategory,
CASE WHEN shortRunInd='1' THEN 'Standard Small Trim'
	 WHEN shortRunInd='5' THEN 'Medium Trade Paperbook'
	 WHEN shortRunInd='8' THEN 'Picture Book'
	 WHEN shortRunInd='9' THEN 'Oversize/Premium Trim'
	 WHEN shortRunInd='A' THEN 'Standard Adult Trade Paperback'
	 WHEN shortRunInd='H' THEN 'Hardcover Variant'
	 WHEN shortRunInd='R' THEN 'Reader Edition/Reduced Trim'
	 WHEN shortRunInd='G' THEN 'Gift/Premium Edition'
	 WHEN shortRunInd='J' THEN 'Trade Paperback'
	 WHEN shortRunInd='M' THEN 'Digest'
	 WHEN shortRunInd='Z' THEN 'Oversize/Speciality'
	 WHEN shortRunInd='K' THEN 'Large Trim'
	 WHEN shortRunInd='N' THEN 'Pocket/Mass Market Trim'
     ELSE 'Nil'
	 END AS shortRunInd,
isbnStr,
[format.code], [format.description],
CASE WHEN [subformat.code] IS NULL THEN 'Nil'
     ELSE [subformat.code]
	 END AS subformat_code,
CASE WHEN [subformat.description] IS NULL THEN 'Nil'
     ELSE [subformat.description]
	 END AS subformat_description,
[division.code],[division.description],
[imprint.code], [imprint.description],
[publisher.code],[publisher.description],
CASE WHEN [age.code] IS NULL THEN 'Nil'
     ELSE SUBSTRING([age.code],1,2)+'-'+SUBSTRING([age.code],3,2)
	 END AS age_code,
CASE WHEN [age.description] IS NULL THEN 'Nil'
     ELSE [age.description]
	 END AS age_description,
CASE WHEN [grade.code] IS NULL THEN 'Nil'
     ELSE SUBSTRING([grade.code],1,2)+'-'+SUBSTRING([grade.code],3,2)
	 END AS grade_code,
CASE WHEN [grade.description] IS NULL THEN 'Nil'
     ELSE [grade.description]
	 END AS grade_description,
CASE WHEN [educationGrade.code] IS NULL THEN 'Nil'
	 WHEN LEN([educationGrade.code])=4 THEN SUBSTRING([educationGrade.code],1,2)+'-'+SUBSTRING([educationGrade.code],3,2)
     ELSE [educationGrade.code]
	 END AS educationGrade_code,
CASE WHEN [educationGrade.description] IS NULL THEN 'Nil'
     ELSE [educationGrade.description]
	 END AS educationGrade_description,
[salesRestriction.code], [salesRestriction.description],
[isbnCounts.variant],[isbnCounts.format],
'DK.COM'
FROM dbo.[titles_DK.COM]


PRINT '>> Inserting Data[PRH.CA] Into : silver.titles';
INSERT INTO silver.titles(isbn,isbnHyphenated,title,subtitle,author,onsale,seoFriendlyUrl,pages,
						  sgmt_desc,trim,formatFamily,consumerFormat,consumerImprint,
						  consumerImprintUri,saleStatus,language,seriesNumber,subseries,
						  editionType,propertyName,cartonQuantity,version,productLine,
						  productType,workId,titleShort,audioPackage,
						  projectedMinutes,originalIsbn,
						  illustPhoto,childrensBookCategory,asin,customSubjectCategory,coverUpdatedOn,
						  isbn10,isbn10hyphenated,boxComponentCt,focDate,cataDate,itemTypeCode,
						  mediaRating,mediaRatingDesc,coverVariantDesc,
						  sortByAuthor,graphicCategory,shortRunInd,isbnStr,
						  format_code,format_description,subformat_code,subformat_description,
						  division_code,division_description,imprint_code,imprint_description,
						  publisher_code,publisher_description,age_code,age_description,grade_code,
						  grade_description,educationGrade_code,educationGrade_description,salesRestriction_code,
						  salesRestriction_description,
						  isbnCounts_variant,isbnCounts_format,domain)
SELECT isbn,
TRIM(isbnHyphenated),
title,
CASE WHEN subtitle IS NULL THEN 'Nil'
     ELSE subtitle
	 END AS subtitle,
author,
onsale,
seoFriendlyUrl,
CASE WHEN pages IS NULL THEN '0'
     ELSE pages
	 END AS pages,
CASE WHEN sgmt_desc IS NULL THEN 'Nil'
     ELSE sgmt_desc
	 END AS sgmt_desc,
CASE WHEN trim IS NULL THEN 'Nil'
     ELSE trim
	 END AS trim,
formatFamily,consumerFormat,
CASE WHEN consumerImprint IS NULL THEN 'Nil'
     ELSE consumerImprint
	 END AS consumerImprint,
CASE WHEN consumerImprintUri IS NULL THEN 'Nil'
     ELSE consumerImprintUri
	 END AS consumerImprintUri,
CASE WHEN saleStatus='IP' THEN 'In Print'
     WHEN saleStatus='PP' THEN 'Pre Publication'
	 WHEN saleStatus='EL' THEN 'Electronic Only'
	 WHEN saleStatus='NR' THEN 'Not Yet Released'
     ELSE 'In Stock'
	 END AS saleStatus,
CASE WHEN language='SP' THEN 'Spanish'
     ELSE 'English'
	 END AS language,
CASE WHEN seriesNumber IS NULL THEN '0'
     ELSE seriesNumber
	 END AS seriesNumber,
CASE WHEN subseries IS NULL THEN 'Nil'
     ELSE subseries
	 END AS subseries,
CASE WHEN editionType IS NULL THEN TRIM([format.description])
     ELSE editionType
	 END AS editionType,
CASE WHEN propertyName IS NULL THEN 'Nil'
     ELSE propertyName
	 END AS propertyName,
cartonQuantity,
version, 
productLine, productType,
workId, titleShort,
CASE WHEN audioPackage IS NULL THEN 'Nil'
     ELSE TRIM(audioPackage)
	 END AS audioPackage,
CASE WHEN projectedMinutes IS NULL THEN 'Not Applicable/Nil'
     ELSE projectedMinutes
	 END AS projectedMinutes,
CASE WHEN originalIsbn IS NULL THEN CAST(isbn AS nvarchar)
     ELSE originalIsbn
	 END AS orginalIsbn,
CASE WHEN illustPhoto IS NULL THEN 'Nil'
     ELSE illustPhoto
	 END AS illustPhoto,
childrensBookCategory,
CASE WHEN asin IS NULL THEN 'Nil'
     ELSE asin
	 END AS asin,
CASE WHEN customSubjectCategory IS NULL THEN 'Nil'
     ELSE LOWER(customSubjectCategory)
	 END AS customSubjectCategory,
CASE WHEN coverUpdatedOn IS NULL THEN onsale
     ELSE coverUpdatedOn
	 END AS coverUpdatedOn,
CASE WHEN isbn10 IS NULL AND SUBSTRING(CAST(isbn AS varchar),1,3)=979 THEN 'Not Applicable'
     WHEN isbn10 IS NULL THEN 'Nil'
	 ELSE isbn10
	 END AS isbn10,
CASE WHEN isbn10 IS NULL AND SUBSTRING(CAST(isbn AS varchar),1,3)=979 THEN 'Not Applicable'
     WHEN isbn10 IS NULL THEN 'Nil'
	 ELSE SUBSTRING(CAST(isbn10 AS varchar),1,1)+'-'+SUBSTRING(CAST(isbn10 AS varchar),2,6)+'-'+
	      SUBSTRING(CAST(isbn10 AS varchar),8,2)+'-'+SUBSTRING(CAST(isbn10 AS varchar),9,1)
	 END AS isbnHyphenated,
boxComponentCt,
CASE WHEN focDate IS NULL THEN DATEADD(month,-1,onsale)
     ELSE focDate
	 END AS focDate,
CASE WHEN cataDate IS NULL THEN DATEADD(month,-5,onsale)
     ELSE cataDate
	 END AS cataDate,
CASE WHEN itemTypeCode IS NULL THEN 'Nil'
     ELSE itemTypeCode
	 END AS itemTypeCode,
CASE WHEN mediaRating IS NULL THEN 'Nil'
     ELSE mediaRating
	 END AS mediaRating,
CASE WHEN mediaRatingDesc IS NULL THEN 'Nil'
     ELSE mediaRatingDesc
	 END AS mediaRatingDesc,
CASE WHEN coverVariantDesc IS NULL THEN 'Nil'
     ELSE coverVariantDesc
	 END AS coverVariantDesc,
CASE WHEN sortByAuthor IS NULL THEN 'Nil'
     ELSE sortByAuthor
	 END AS sortByAuthor,
CASE WHEN graphicCategory IS NULL THEN 'Nil'
     ELSE graphicCategory
	 END AS graphicCategory,
CASE WHEN shortRunInd='1' THEN 'Standard Small Trim'
	 WHEN shortRunInd='5' THEN 'Medium Trade Paperbook'
	 WHEN shortRunInd='8' THEN 'Picture Book'
	 WHEN shortRunInd='9' THEN 'Oversize/Premium Trim'
	 WHEN shortRunInd='A' THEN 'Standard Adult Trade Paperback'
	 WHEN shortRunInd='H' THEN 'Hardcover Variant'
	 WHEN shortRunInd='R' THEN 'Reader Edition/Reduced Trim'
	 WHEN shortRunInd='G' THEN 'Gift/Premium Edition'
	 WHEN shortRunInd='J' THEN 'Trade Paperback'
	 WHEN shortRunInd='M' THEN 'Digest'
	 WHEN shortRunInd='Z' THEN 'Oversize/Speciality'
	 WHEN shortRunInd='K' THEN 'Large Trim'
	 WHEN shortRunInd='N' THEN 'Pocket/Mass Market Trim'
     ELSE 'Nil'
	 END AS shortRunInd,
isbnStr,
[format.code], [format.description],
CASE WHEN [subformat.code] IS NULL THEN 'Nil'
     ELSE [subformat.code]
	 END AS subformat_code,
CASE WHEN [subformat.description] IS NULL THEN 'Nil'
     ELSE [subformat.description]
	 END AS subformat_description,
[division.code],[division.description],
[imprint.code], [imprint.description],
[publisher.code],[publisher.description],
CASE WHEN [age.code] IS NULL THEN 'Nil'
     ELSE SUBSTRING([age.code],1,2)+'-'+SUBSTRING([age.code],3,2)
	 END AS age_code,
CASE WHEN [age.description] IS NULL THEN 'Nil'
     ELSE [age.description]
	 END AS age_description,
CASE WHEN [grade.code] IS NULL THEN 'Nil'
     ELSE SUBSTRING([grade.code],1,2)+'-'+SUBSTRING([grade.code],3,2)
	 END AS grade_code,
CASE WHEN [grade.description] IS NULL THEN 'Nil'
     ELSE [grade.description]
	 END AS grade_description,
CASE WHEN [educationGrade.code] IS NULL THEN 'Nil'
	 WHEN LEN([educationGrade.code])=4 THEN SUBSTRING([educationGrade.code],1,2)+'-'+SUBSTRING([educationGrade.code],3,2)
     ELSE [educationGrade.code]
	 END AS educationGrade_code,
CASE WHEN [educationGrade.description] IS NULL THEN 'Nil'
     ELSE [educationGrade.description]
	 END AS educationGrade_description,
[salesRestriction.code], [salesRestriction.description],
[isbnCounts.variant],[isbnCounts.format],
'PRH.CA'
FROM dbo.[titles_PRH.CA]


PRINT '>> Inserting Data[PRH.US] Into : silver.titles';
INSERT INTO silver.titles(isbn,isbnHyphenated,title,subtitle,author,onsale,seoFriendlyUrl,pages,
						  sgmt_desc,trim,formatFamily,consumerFormat,consumerImprint,
						  consumerImprintUri,saleStatus,language,seriesNumber,subseries,
						  editionType,propertyName,cartonQuantity,version,productLine,
						  productType,workId,titleShort,audioPackage,
						  projectedMinutes,originalIsbn,
						  illustPhoto,childrensBookCategory,asin,customSubjectCategory,coverUpdatedOn,
						  isbn10,isbn10hyphenated,boxComponentCt,focDate,cataDate,itemTypeCode,
						  mediaRating,mediaRatingDesc,coverVariantDesc,
						  sortByAuthor,graphicCategory,shortRunInd,isbnStr,
						  format_code,format_description,subformat_code,subformat_description,
						  division_code,division_description,imprint_code,imprint_description,
						  publisher_code,publisher_description,age_code,age_description,grade_code,
						  grade_description,educationGrade_code,educationGrade_description,salesRestriction_code,
						  salesRestriction_description,
						  isbnCounts_variant,isbnCounts_format,domain)
SELECT isbn,
TRIM(isbnHyphenated),
title,
CASE WHEN subtitle IS NULL THEN 'Nil'
     ELSE subtitle
	 END AS subtitle,
author,
onsale,
seoFriendlyUrl,
CASE WHEN pages IS NULL THEN '0'
     ELSE pages
	 END AS pages,
CASE WHEN sgmt_desc IS NULL THEN 'Nil'
     ELSE sgmt_desc
	 END AS sgmt_desc,
CASE WHEN trim IS NULL THEN 'Nil'
     ELSE trim
	 END AS trim,
formatFamily,consumerFormat,
CASE WHEN consumerImprint IS NULL THEN 'Nil'
     ELSE consumerImprint
	 END AS consumerImprint,
CASE WHEN consumerImprintUri IS NULL THEN 'Nil'
     ELSE consumerImprintUri
	 END AS consumerImprintUri,
CASE WHEN saleStatus='IP' THEN 'In Print'
     WHEN saleStatus='PP' THEN 'Pre Publication'
	 WHEN saleStatus='EL' THEN 'Electronic Only'
	 WHEN saleStatus='NR' THEN 'Not Yet Released'
     ELSE 'In Stock'
	 END AS saleStatus,
CASE WHEN language='SP' THEN 'Spanish'
     ELSE 'English'
	 END AS language,
CASE WHEN seriesNumber IS NULL THEN '0'
     ELSE seriesNumber
	 END AS seriesNumber,
CASE WHEN subseries IS NULL THEN 'Nil'
     ELSE subseries
	 END AS subseries,
CASE WHEN editionType IS NULL THEN TRIM([format.description])
     ELSE editionType
	 END AS editionType,
CASE WHEN propertyName IS NULL THEN 'Nil'
     ELSE propertyName
	 END AS propertyName,
cartonQuantity,
version, 
productLine, productType,
workId, titleShort,
CASE WHEN audioPackage IS NULL THEN 'Nil'
     ELSE TRIM(audioPackage)
	 END AS audioPackage,
CASE WHEN projectedMinutes IS NULL THEN 'Not Applicable/Nil'
     ELSE projectedMinutes
	 END AS projectedMinutes,
CASE WHEN originalIsbn IS NULL THEN CAST(isbn AS nvarchar)
     ELSE originalIsbn
	 END AS orginalIsbn,
CASE WHEN illustPhoto IS NULL THEN 'Nil'
     ELSE illustPhoto
	 END AS illustPhoto,
childrensBookCategory,
CASE WHEN asin IS NULL THEN 'Nil'
     ELSE asin
	 END AS asin,
CASE WHEN customSubjectCategory IS NULL THEN 'Nil'
     ELSE LOWER(customSubjectCategory)
	 END AS customSubjectCategory,
CASE WHEN coverUpdatedOn IS NULL THEN onsale
     ELSE coverUpdatedOn
	 END AS coverUpdatedOn,
CASE WHEN isbn10 IS NULL AND SUBSTRING(CAST(isbn AS varchar),1,3)=979 THEN 'Not Applicable'
     WHEN isbn10 IS NULL THEN 'Nil'
	 ELSE isbn10
	 END AS isbn10,
CASE WHEN isbn10 IS NULL AND SUBSTRING(CAST(isbn AS varchar),1,3)=979 THEN 'Not Applicable'
     WHEN isbn10 IS NULL THEN 'Nil'
	 ELSE SUBSTRING(CAST(isbn10 AS varchar),1,1)+'-'+SUBSTRING(CAST(isbn10 AS varchar),2,6)+'-'+
	      SUBSTRING(CAST(isbn10 AS varchar),8,2)+'-'+SUBSTRING(CAST(isbn10 AS varchar),9,1)
	 END AS isbnHyphenated,
boxComponentCt,
CASE WHEN focDate IS NULL THEN DATEADD(month,-1,onsale)
     ELSE focDate
	 END AS focDate,
CASE WHEN cataDate IS NULL THEN DATEADD(month,-5,onsale)
     ELSE cataDate
	 END AS cataDate,
CASE WHEN itemTypeCode IS NULL THEN 'Nil'
     ELSE itemTypeCode
	 END AS itemTypeCode,
CASE WHEN mediaRating IS NULL THEN 'Nil'
     ELSE mediaRating
	 END AS mediaRating,
CASE WHEN mediaRatingDesc IS NULL THEN 'Nil'
     ELSE mediaRatingDesc
	 END AS mediaRatingDesc,
CASE WHEN coverVariantDesc IS NULL THEN 'Nil'
     ELSE coverVariantDesc
	 END AS coverVariantDesc,
CASE WHEN sortByAuthor IS NULL THEN 'Nil'
     ELSE sortByAuthor
	 END AS sortByAuthor,
CASE WHEN graphicCategory IS NULL THEN 'Nil'
     ELSE graphicCategory
	 END AS graphicCategory,
CASE WHEN shortRunInd='1' THEN 'Standard Small Trim'
	 WHEN shortRunInd='5' THEN 'Medium Trade Paperbook'
	 WHEN shortRunInd='8' THEN 'Picture Book'
	 WHEN shortRunInd='9' THEN 'Oversize/Premium Trim'
	 WHEN shortRunInd='A' THEN 'Standard Adult Trade Paperback'
	 WHEN shortRunInd='H' THEN 'Hardcover Variant'
	 WHEN shortRunInd='R' THEN 'Reader Edition/Reduced Trim'
	 WHEN shortRunInd='G' THEN 'Gift/Premium Edition'
	 WHEN shortRunInd='J' THEN 'Trade Paperback'
	 WHEN shortRunInd='M' THEN 'Digest'
	 WHEN shortRunInd='Z' THEN 'Oversize/Speciality'
	 WHEN shortRunInd='K' THEN 'Large Trim'
	 WHEN shortRunInd='N' THEN 'Pocket/Mass Market Trim'
     ELSE 'Nil'
	 END AS shortRunInd,
isbnStr,
[format.code], [format.description],
CASE WHEN [subformat.code] IS NULL THEN 'Nil'
     ELSE [subformat.code]
	 END AS subformat_code,
CASE WHEN [subformat.description] IS NULL THEN 'Nil'
     ELSE [subformat.description]
	 END AS subformat_description,
[division.code],[division.description],
[imprint.code], [imprint.description],
[publisher.code],[publisher.description],
CASE WHEN [age.code] IS NULL THEN 'Nil'
     ELSE SUBSTRING([age.code],1,2)+'-'+SUBSTRING([age.code],3,2)
	 END AS age_code,
CASE WHEN [age.description] IS NULL THEN 'Nil'
     ELSE [age.description]
	 END AS age_description,
CASE WHEN [grade.code] IS NULL THEN 'Nil'
     ELSE SUBSTRING([grade.code],1,2)+'-'+SUBSTRING([grade.code],3,2)
	 END AS grade_code,
CASE WHEN [grade.description] IS NULL THEN 'Nil'
     ELSE [grade.description]
	 END AS grade_description,
CASE WHEN [educationGrade.code] IS NULL THEN 'Nil'
	 WHEN LEN([educationGrade.code])=4 THEN SUBSTRING([educationGrade.code],1,2)+'-'+SUBSTRING([educationGrade.code],3,2)
     ELSE [educationGrade.code]
	 END AS educationGrade_code,
CASE WHEN [educationGrade.description] IS NULL THEN 'Nil'
     ELSE [educationGrade.description]
	 END AS educationGrade_description,
[salesRestriction.code], [salesRestriction.description],
[isbnCounts.variant],[isbnCounts.format],
'PRH.US'
FROM dbo.[titles_PRH.US]


PRINT '>> Inserting Data[SALESINTERNATIONAL] Into : silver.titles';
INSERT INTO silver.titles(isbn,isbnHyphenated,title,subtitle,author,onsale,seoFriendlyUrl,pages,
						  sgmt_desc,trim,formatFamily,consumerFormat,consumerImprint,
						  consumerImprintUri,saleStatus,language,seriesNumber,subseries,
						  editionType,propertyName,cartonQuantity,version,productLine,
						  productType,workId,titleShort,audioPackage,
						  projectedMinutes,originalIsbn,
						  illustPhoto,childrensBookCategory,asin,customSubjectCategory,coverUpdatedOn,
						  isbn10,isbn10hyphenated,boxComponentCt,focDate,cataDate,itemTypeCode,
						  mediaRating,mediaRatingDesc,coverVariantDesc,
						  sortByAuthor,graphicCategory,shortRunInd,isbnStr,
						  format_code,format_description,subformat_code,subformat_description,
						  division_code,division_description,imprint_code,imprint_description,
						  publisher_code,publisher_description,age_code,age_description,grade_code,
						  grade_description,educationGrade_code,educationGrade_description,salesRestriction_code,
						  salesRestriction_description,
						  isbnCounts_variant,isbnCounts_format,domain)
SELECT isbn,
TRIM(isbnHyphenated),
title,
CASE WHEN subtitle IS NULL THEN 'Nil'
     ELSE subtitle
	 END AS subtitle,
author,
onsale,
seoFriendlyUrl,
CASE WHEN pages IS NULL THEN '0'
     ELSE pages
	 END AS pages,
CASE WHEN sgmt_desc IS NULL THEN 'Nil'
     ELSE sgmt_desc
	 END AS sgmt_desc,
CASE WHEN trim IS NULL THEN 'Nil'
     ELSE trim
	 END AS trim,
formatFamily,consumerFormat,
CASE WHEN consumerImprint IS NULL THEN 'Nil'
     ELSE consumerImprint
	 END AS consumerImprint,
CASE WHEN consumerImprintUri IS NULL THEN 'Nil'
     ELSE consumerImprintUri
	 END AS consumerImprintUri,
CASE WHEN saleStatus='IP' THEN 'In Print'
     WHEN saleStatus='PP' THEN 'Pre Publication'
	 WHEN saleStatus='EL' THEN 'Electronic Only'
	 WHEN saleStatus='NR' THEN 'Not Yet Released'
     ELSE 'In Stock'
	 END AS saleStatus,
CASE WHEN language='SP' THEN 'Spanish'
     ELSE 'English'
	 END AS language,
CASE WHEN seriesNumber IS NULL THEN '0'
     ELSE seriesNumber
	 END AS seriesNumber,
CASE WHEN subseries IS NULL THEN 'Nil'
     ELSE subseries
	 END AS subseries,
CASE WHEN editionType IS NULL THEN TRIM([format.description])
     ELSE editionType
	 END AS editionType,
CASE WHEN propertyName IS NULL THEN 'Nil'
     ELSE propertyName
	 END AS propertyName,
cartonQuantity,
version, 
productLine, productType,
workId, titleShort,
CASE WHEN audioPackage IS NULL THEN 'Nil'
     ELSE TRIM(audioPackage)
	 END AS audioPackage,
CASE WHEN projectedMinutes IS NULL THEN 'Not Applicable/Nil'
     ELSE projectedMinutes
	 END AS projectedMinutes,
CASE WHEN originalIsbn IS NULL THEN CAST(isbn AS nvarchar)
     ELSE originalIsbn
	 END AS orginalIsbn,
CASE WHEN illustPhoto IS NULL THEN 'Nil'
     ELSE illustPhoto
	 END AS illustPhoto,
childrensBookCategory,
CASE WHEN asin IS NULL THEN 'Nil'
     ELSE asin
	 END AS asin,
CASE WHEN customSubjectCategory IS NULL THEN 'Nil'
     ELSE LOWER(customSubjectCategory)
	 END AS customSubjectCategory,
CASE WHEN coverUpdatedOn IS NULL THEN onsale
     ELSE coverUpdatedOn
	 END AS coverUpdatedOn,
CASE WHEN isbn10 IS NULL AND SUBSTRING(CAST(isbn AS varchar),1,3)=979 THEN 'Not Applicable'
     WHEN isbn10 IS NULL THEN 'Nil'
	 ELSE isbn10
	 END AS isbn10,
CASE WHEN isbn10 IS NULL AND SUBSTRING(CAST(isbn AS varchar),1,3)=979 THEN 'Not Applicable'
     WHEN isbn10 IS NULL THEN 'Nil'
	 ELSE SUBSTRING(CAST(isbn10 AS varchar),1,1)+'-'+SUBSTRING(CAST(isbn10 AS varchar),2,6)+'-'+
	      SUBSTRING(CAST(isbn10 AS varchar),8,2)+'-'+SUBSTRING(CAST(isbn10 AS varchar),9,1)
	 END AS isbnHyphenated,
boxComponentCt,
CASE WHEN focDate IS NULL THEN DATEADD(month,-1,onsale)
     ELSE focDate
	 END AS focDate,
CASE WHEN cataDate IS NULL THEN DATEADD(month,-5,onsale)
     ELSE cataDate
	 END AS cataDate,
CASE WHEN itemTypeCode IS NULL THEN 'Nil'
     ELSE itemTypeCode
	 END AS itemTypeCode,
CASE WHEN mediaRating IS NULL THEN 'Nil'
     ELSE mediaRating
	 END AS mediaRating,
CASE WHEN mediaRatingDesc IS NULL THEN 'Nil'
     ELSE mediaRatingDesc
	 END AS mediaRatingDesc,
CASE WHEN coverVariantDesc IS NULL THEN 'Nil'
     ELSE coverVariantDesc
	 END AS coverVariantDesc,
CASE WHEN sortByAuthor IS NULL THEN 'Nil'
     ELSE sortByAuthor
	 END AS sortByAuthor,
CASE WHEN graphicCategory IS NULL THEN 'Nil'
     ELSE graphicCategory
	 END AS graphicCategory,
CASE WHEN shortRunInd='1' THEN 'Standard Small Trim'
	 WHEN shortRunInd='5' THEN 'Medium Trade Paperbook'
	 WHEN shortRunInd='8' THEN 'Picture Book'
	 WHEN shortRunInd='9' THEN 'Oversize/Premium Trim'
	 WHEN shortRunInd='A' THEN 'Standard Adult Trade Paperback'
	 WHEN shortRunInd='H' THEN 'Hardcover Variant'
	 WHEN shortRunInd='R' THEN 'Reader Edition/Reduced Trim'
	 WHEN shortRunInd='G' THEN 'Gift/Premium Edition'
	 WHEN shortRunInd='J' THEN 'Trade Paperback'
	 WHEN shortRunInd='M' THEN 'Digest'
	 WHEN shortRunInd='Z' THEN 'Oversize/Speciality'
	 WHEN shortRunInd='K' THEN 'Large Trim'
	 WHEN shortRunInd='N' THEN 'Pocket/Mass Market Trim'
     ELSE 'Nil'
	 END AS shortRunInd,
isbnStr,
[format.code], [format.description],
CASE WHEN [subformat.code] IS NULL THEN 'Nil'
     ELSE [subformat.code]
	 END AS subformat_code,
CASE WHEN [subformat.description] IS NULL THEN 'Nil'
     ELSE [subformat.description]
	 END AS subformat_description,
[division.code],[division.description],
[imprint.code], [imprint.description],
[publisher.code],[publisher.description],
CASE WHEN [age.code] IS NULL THEN 'Nil'
     ELSE SUBSTRING([age.code],1,2)+'-'+SUBSTRING([age.code],3,2)
	 END AS age_code,
CASE WHEN [age.description] IS NULL THEN 'Nil'
     ELSE [age.description]
	 END AS age_description,
CASE WHEN [grade.code] IS NULL THEN 'Nil'
     ELSE SUBSTRING([grade.code],1,2)+'-'+SUBSTRING([grade.code],3,2)
	 END AS grade_code,
CASE WHEN [grade.description] IS NULL THEN 'Nil'
     ELSE [grade.description]
	 END AS grade_description,
CASE WHEN [educationGrade.code] IS NULL THEN 'Nil'
	 WHEN LEN([educationGrade.code])=4 THEN SUBSTRING([educationGrade.code],1,2)+'-'+SUBSTRING([educationGrade.code],3,2)
     ELSE [educationGrade.code]
	 END AS educationGrade_code,
CASE WHEN [educationGrade.description] IS NULL THEN 'Nil'
     ELSE [educationGrade.description]
	 END AS educationGrade_description,
[salesRestriction.code], [salesRestriction.description],
[isbnCounts.variant],[isbnCounts.format],
'SALESINTERNATIONAL'
FROM dbo.titles_SALESINTERNATIONAL

SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';

-- -------------------------------------------works-----------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
PRINT '---------------------------------------------------------------';
PRINT 'Loading works Tables';
PRINT '---------------------------------------------------------------';

SET @start_time = GETDATE();

TRUNCATE TABLE silver.works;
PRINT '>> Inserting Data[AUDIO] Into : silver.works';
INSERT INTO silver.works(workId,title,coverUrl,earliestOnSaleDate,genre,domain)
SELECT workId,
title,
CASE WHEN coverUrl IS NULL THEN 'Nil'
     ELSE coverUrl
	 END AS coverUrl,
earliestOnSaleDate,
CASE WHEN genre IS NULL THEN 'Nil'
     ELSE genre
	 END AS genre,
'AUDIO'
FROM dbo.works_AUDIO


PRINT '>> Inserting Data[DK.COM] Into : silver.works';
INSERT INTO silver.works(workId,title,coverUrl,earliestOnSaleDate,genre,domain)
SELECT workId,
title,
CASE WHEN coverUrl IS NULL THEN 'Nil'
     ELSE coverUrl
	 END AS coverUrl,
earliestOnSaleDate,
CASE WHEN genre IS NULL THEN 'Nil'
     ELSE genre
	 END AS genre,
'DK.COM'
FROM dbo.[works_DK.COM]


PRINT '>> Inserting Data[PRH.CA] Into : silver.works';
INSERT INTO silver.works(workId,title,coverUrl,earliestOnSaleDate,genre,domain)
SELECT workId,
title,
CASE WHEN coverUrl IS NULL THEN 'Nil'
     ELSE coverUrl
	 END AS coverUrl,
earliestOnSaleDate,
CASE WHEN genre IS NULL THEN 'Nil'
     ELSE genre
	 END AS genre,
'PRH.CA'
FROM dbo.[works_PRH.CA]



PRINT '>> Inserting Data[PRH.US] Into : silver.works';
INSERT INTO silver.works(workId,title,coverUrl,earliestOnSaleDate,genre,domain)
SELECT workId,
title,
CASE WHEN coverUrl IS NULL THEN 'Nil'
     ELSE coverUrl
	 END AS coverUrl,
earliestOnSaleDate,
CASE WHEN genre IS NULL THEN 'Nil'
     ELSE genre
	 END AS genre,
'PRH.US'
FROM dbo.[works_PRH.US]


PRINT '>> Inserting Data[SALESINTERNATIONAL] Into : silver.works';
INSERT INTO silver.works(workId,title,coverUrl,earliestOnSaleDate,genre,domain)
SELECT workId,
title,
CASE WHEN coverUrl IS NULL THEN 'Nil'
     ELSE coverUrl
	 END AS coverUrl,
earliestOnSaleDate,
CASE WHEN genre IS NULL THEN 'Nil'
     ELSE genre
	 END AS genre,
'SALESINTERNATIONAL'
FROM dbo.[works_SALESINTERNATIONAL]

SET @end_time = GETDATE();
PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
PRINT '-------------------------------';

SET @batch_end_time = GETDATE();
PRINT '===============================================================';
PRINT 'Loading Silver Layer Completed';
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