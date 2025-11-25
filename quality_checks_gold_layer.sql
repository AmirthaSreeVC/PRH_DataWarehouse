select count(*) from silver.works as w
join silver.authors as a 
on w.workId=a.authorOf_workId
where w.workId not in (select workId from silver.works);

WITH AAA AS (SELECT *,
      ROW_NUMBER() OVER(PARTITION BY workId ORDER BY dwhCreateDate DESC) AS rn
	  FROM silver.works)
SELECT COUNT(*) AS w,COUNT(DISTINCT workId)
FROM AAA
WHERE rn=1;

select * from mapping_authors;

select count(*),count(distinct authorName)
from silver.authors

select count(*),count(distinct isbn)
from silver.titles

SELECT workId,COUNT(*)
FROM gold.dim_work
GROUP BY workId
HAVING COUNT(*) > 1

SELECT DISTINCT authorName,
STRING_AGG(domain,',')
FROM (SELECT DISTINCT authorName,domain FROM silver.authors
GROUP BY domain,authorName) AS A
GROUP BY authorName
HAVING LEN(STRING_AGG(domain,',')) > LEN('AUDIO,DK.COM,SALESINTERNATIONAL,PRH.US,PRH.CA')

select COUNT(DISTINCT workId) from silver.works

select count(distinct w.workId) from silver.categories c
join silver.works w on c.description=w.genre

select * from mapping_authors
where LEN(domainAgg) > LEN('AUDIO,DK.COM,SALESINTERNATIONAL,PRH.US,PRH.CA')

SELECT COUNT(*),COUNT(DISTINCT workId)
FROM gold.dim_work;

SELECT COUNT(*),COUNT(DISTINCT commonAuthorId)
FROM gold.dim_authors;

SELECT COUNT(*),COUNT(DISTINCT catId)
FROM gold.dim_category;

SELECT COUNT(*),COUNT(DISTINCT isbn)
FROM gold.dim_books;

SELECT COUNT(*),COUNT(DISTINCT isbn)
FROM gold.fact_bookLifeCycle;


WITH temp AS(
SELECT DISTINCT workId,genre FROM (SELECT *,
      ROW_NUMBER() OVER(PARTITION BY workId ORDER BY dwhCreateDate DESC) AS rn
	  FROM silver.works) AS q 
WHERE rn=1
)
SELECT COUNT(*),COUNT(DISTINCT bk.isbn) FROM 
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
--JOIN temp AS w
--ON w.workId=da.workId 
--JOIN gold.dim_category AS ca
--ON w.genre=ca.catDescription
