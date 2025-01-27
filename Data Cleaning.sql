
-- Data Cleaning Project
SELECT * FROM world_layoffs.layoffs_staging2;

-- Select records where the row_num us greater than 1
SELECT * 
FROM layoffs_staging2
WHERE row_num >1;

-- Explanation: Identifies duplicate rows by checking if the `row_num` column is greater than 1.
-- Insert data into layoffs_staging2 with deduplication logic

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, 'date', stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Temporarily disable safe updates mode
SET SQL_SAFE_UPDATES = 0;


-- Delete duplicate rows from layoffs_staging2
DELETE 
FROM layoffs_staging2
WHERE row_num > 1;



SELECT * 
FROM layoffs_staging2;

-- Standardize company names by trimming spaces

SELECT company, TRIM(company)
FROM layoffs_staging2;

-- Select records where the industry starts with "Crypto"
SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';


-- Standardize the industry column for crypto-related entries
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry
FROM layoffs_staging2;

-- Standardize company names by trimming spaces
UPDATE layoffs_staging2
SET company = TRIM(company);

-- Display distinct country names with trailing periods removed
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

-- Update the country column to remove trailing periods
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';


-- Convert `date` values from string to DATE format
SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

-- Modify the `date` column to explicitly use the DATE data type

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE; 


-- Replace empty industry values with NULL
UPDATE layoffs_staging2
SET industry = NULL 
WHERE industry = '';

-- Select records with NULL or empty industry values
SELECT *
FROM layoffs_staging2
WHERE industry is NULL 
OR industry = '';

-- Select records where the company name starts with "Bally"
SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

-- Identify inconsistent industry data for companies at the same location
SELECT  t1.industry, t2.industry
FROM layoffs_staging2 t1 
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL or t1.industry ='')
AND t2.industry IS NOT NULL;

-- Update missing industries by copying data from matching records
UPDATE layoffs_staging2 t1  
JOIN layoffs_staging2 t2
	ON  t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- View the final table after cleaning
SELECT *
FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Delete rows where both total_laid_off and percentage_laid_off are NULL
DELETE

FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_staging2;

-- Drop the `row_num` column
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT * 
FROM layoffs_staging2;

-- Re-enable safe update mode
SET SQL_SAFE_UPDATES = 1;