-- DATA CLEANING 

SELECT *
FROM layoffs;

-- REMOVE DUPLICATES
-- STANDARDIZE THE DATA
-- NULL VALUES 
-- REMOVE UNNEEDED COLUMNS

CREATE TABLE layoff_backup
LIKE layoffs;

INSERT layoff_backup
SELECT *
FROM layoffs;

-- REMOVING DUPLICATES

SELECT *
FROM layoff_backup; 
 
WITH duplicate_cte as 
(
SELECT *,
ROW_NUMBER()OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS ROW_NUM
FROM layoff_backup
)
 DELETE
 FROM duplicate_cte
 WHERE row_num>1;
 
 SELECT *
 FROM layoff_backup
 WHERE company="casper";
 
 
 CREATE TABLE `layoff_backup2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoff_backup2
SELECT *,
ROW_NUMBER()OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS ROW_NUM
FROM layoff_backup; 

 
 SELECT *
 FROM layoff_backup2
 WHERE row_num>1;

DELETE
FROM layoff_backup2
WHERE row_num>1; 

SET SQL_SAFE_UPDATES = 0;

-- STANDARDIZING DATA
SELECT company, TRIM(company)
FROM layoff_backup2;

UPDATE layoff_backup2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoff_backup2
ORDER BY 1;

SELECT*
FROM layoff_backup2
WHERE industry LIKE "Crypto%";

UPDATE layoff_backup2
SET industry="Crypto"
WHERE industry LIKE "Crypto%";

SELECT DISTINCT location
FROM layoff_backup2
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING'.' FROM country)
FROM layoff_backup2;

UPDATE layoff_backup2
SET country=TRIM(TRAILING'.' FROM country)
WHERE country LIKE "United States%";

-- CHANGING DATA TYPES 
SELECT `date`,
str_to_date(`date`, '%m/%d/%Y')
FROM layoff_backup2;

UPDATE layoff_backup2
SET `date`=str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoff_backup2
MODIFY COLUMN `date` DATE;

-- REMOVING NULL VALUES

SELECT*
FROM layoff_backup2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT*
FROM layoff_backup2
WHERE industry IS NULL
OR industry ='';

SELECT *
FROM layoff_backup2 t1
JOIN layoff_backup2 t2
ON t1.company=t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoff_backup2 t1
JOIN layoff_backup2 t2
ON t1.company=t2.company
SET t1.industry=t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

UPDATE layoff_backup2
SET industry= null
WHERE industry='';

SELECT *
FROM layoff_backup
WHERE company="Airbnb";

SELECT *
FROM layoff_backup2;

SELECT *
FROM layoff_backup2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoff_backup2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


ALTER TABLE layoff_backup2
DROP COLUMN row_num;






