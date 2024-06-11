-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;


-- Max number of laid off in a day
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;


-- where all company workers were fired in one day
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


-- what company laid off the most employee
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


-- date of layoffs happening
SELECT MIN(date), MAX(date)
FROM layoffs_staging2;


-- what industry got hit the most during layoffs
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


-- what country's people lost the most jobs
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;


-- Year wise laid off
SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 1 DESC;


-- what stage was the companies in while laying off
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;



SELECT *
FROM layoffs_staging2;


-- total layoffs in each month
SELECT substring(date, 1, 7) as month, sum(total_laid_off)
FROM layoffs_staging2
WHERE substring(date, 1, 7)
GROUP BY month
ORDER BY month ;

-- month by month laying off total  (rolling total layoff)
WITH Rolling_total AS
(
SELECT substring(date, 1, 7) as month, sum(total_laid_off) as total_off
FROM layoffs_staging2
WHERE substring(date, 1, 7)
GROUP BY month
ORDER BY month 
)
SELECT month,
total_off,
SUM(total_off) OVER(ORDER BY month) as rolling_total
FROM Rolling_total;


-- company laying off per year
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


SELECT company, YEAR(date), SUM(total_laid_off) as total_off
FROM layoffs_staging2 
WHERE total_laid_off IS NOT NULL
GROUP BY company, date
ORDER BY 3 DESC;


WITH company_year (company, years, total_laid_off) AS
(
SELECT company, YEAR(date), SUM(total_laid_off)
FROM layoffs_staging2 
WHERE total_laid_off IS NOT NULL
GROUP BY company, date
ORDER BY 3 DESC
), company_year_rank as 
(
SELECT *, 
dense_rank() over (partition by years order by total_laid_off DESC) as ranking
FROM company_year
WHERE years IS NOT NULL
ORDER BY ranking ASC
)
SELECT *
FROM company_year_rank
WHERE ranking <= 5;  -- top 5 in each year




-- total number of layoffs by country in each year
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

WITH country_year_total AS
(
SELECT country, YEAR(date) as year, SUM(total_laid_off) as total_laid_off
FROM layoffs_staging2
WHERE total_laid_off IS NOT NULL
GROUP BY country, year
) 
SELECT *
FROM country_year_total
ORDER BY total_laid_off DESC;