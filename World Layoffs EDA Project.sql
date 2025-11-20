-- EXPLORATORY DATA ANALYSIS

SELECT *
FROM layoff_backup2; 

-- Looking at Percentages what the largest layoffs were
SELECT MAX(total_laid_off), MAX (percentage_laid_off)
FROM layoff_backup2;

SELECT *
FROM layoff_backup2
WHERE percentage_laid_off=1;
-- these are mostly startups it looks like who all went out of business during this time

-- if we order by funcs_raised_millions we can see how big some of these companies were
SELECT *
FROM layoff_backup2
WHERE percentage_laid_off=1
ORDER BY funds_raised_millions DESC;
-- BritishVolt looks like an EV company, Quibi! I recognize that company - wow raised like 2 billion dollars and went under - ouch

-- Companies with the most Layoffs
SELECT company, SUM(total_laid_off)
FROM layoff_backup2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

-- Time range of layoffs
SELECT MIN(`date`), MAX(`date`)
FROM layoff_backup2;

-- by industry
SELECT industry, SUM(total_laid_off)
FROM layoff_backup2
GROUP BY industry
ORDER BY 2 DESC;

-- by country
SELECT country, SUM(total_laid_off)
FROM layoff_backup2
GROUP BY country
ORDER BY 2 DESC;

SELECT `date`, SUM(total_laid_off)
FROM layoff_backup2
GROUP BY `date`
ORDER BY 1 DESC;

-- by year
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoff_backup2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoff_backup2
GROUP BY stage
ORDER BY 1 DESC;

-- rolling total of layoffs per month
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoff_backup2
WHERE SUBSTRING(`date`,1,7)   IS NOT NULL
GROUP BY MONTH
ORDER BY 1 ASC;

WITH ROLLING_TOTAL AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off )AS total_off
FROM layoff_backup2
WHERE SUBSTRING(`date`,1,7)   IS NOT NULL
GROUP BY MONTH
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM ROLLING_TOTAL;

SELECT company, SUM(total_laid_off)
FROM layoff_backup2
GROUP BY company
ORDER BY 2 DESC;

SELECT company, YEAR(`date`),SUM(total_laid_off)
FROM layoff_backup2
GROUP BY company, YEAR(`date`)
ORDER BY 1 ASC;
 
 --  Companies with the most Layoffs per year. 
 
WITH Company_Year(company,years,total_laid_off) AS
(
SELECT company, YEAR(`date`),SUM(total_laid_off)
FROM layoff_backup2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS(
SELECT *, DENSE_RANK()OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY Ranking ASC
)
SELECT *
FROM Company_Year_Rank
WHERE RANKING<=5
; 





