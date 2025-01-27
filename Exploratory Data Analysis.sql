-- Exploratory Data Analysis  

SELECT *
FROM layoffs_staging2;

-- 1. Retrieve the maximum number of employees laid off and the maximum percentage laid off.

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- 2. Identify companies with 100% layoffs and sort them by the amount of funds raised (in millions) in descending order.

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1 
ORDER BY funds_raised_millions DESC;

-- 3. Summarize the total layoffs per company and sort the results by the total layoffs in descending order.
SELECT company, SUM(total_laid_off)
FROM  layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- 4. Find the earliest and latest dates in the dataset to determine the date range of layoffs.
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- 5. Aggregate the total layoffs per year and sort by year in descending order to observe trends over time.
SELECT year(`date`), SUM(total_laid_off)
FROM  layoffs_staging2
GROUP BY  year(`date`)
ORDER BY 1 DESC;

-- 6. Summarize the total layoffs by the stage of the company and sort by total layoffs in descending order.
SELECT stage, SUM(total_laid_off)
FROM  layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- 7. Calculate the average percentage of employees laid off per company and sort by the average percentage in descending order.
SELECT company, AVG(percentage_laid_off)
FROM  layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- 8. Summarize total layoffs by month (YYYY-MM format) and sort in ascending order of the month.
SELECT substring(`date`, 1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE substring(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

-- 9. Create a rolling total of layoffs by month.
WITH Rolling_Total AS

(
SELECT substring(`date`, 1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE substring(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off
,SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- 10. Summarize the total layoffs per company and sort the results by total layoffs in descending order.
SELECT company, SUM(total_laid_off)
FROM  layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- 11. Aggregate total layoffs per company and year, sorted alphabetically by company name.
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM  layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY company ASC;

-- 12. Aggregate total layoffs per company and year, sorted by total layoffs in descending order.

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM  layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- 13. Rank the top 5 companies with the most layoffs per year using a common table expression (CTE).
WITH Company_Year (company,years,total_laid_off)AS 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM  layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_YEar_RAnk AS 

(SELECT*, DENSE_RANK () OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;









