-- 4. OTAZKA  
-- Existuje rok, ve kterem byl mezirocni narust cen potravin vyrazne vyssi nez rust mezd (vetsi nez 10%)?

-- Vytvoreni si nove tabulky pro ucely 4. ukolu - tabulka t_payroll_year_2 
CREATE OR REPLACE TABLE t_payroll_year_2 AS
SELECT payroll_year AS payroll_year_2, average_salary AS average_salary_2
FROM (
	SELECT cpib.name AS industry_name, avg(cpay.value) AS average_salary, cpay.payroll_year
	FROM czechia_payroll cpay
	LEFT JOIN czechia_payroll_industry_branch cpib
		ON cpay.industry_branch_code = cpib.code
	WHERE cpay.value_type_code = 5958
		AND cpay.calculation_code = 100	
		AND cpay.unit_code = 200
		AND cpay.industry_branch_code IS NOT NULL
	GROUP BY cpay.payroll_year
	ORDER BY cpay.payroll_year) t2;

SELECT *
FROM t_payroll_year_2;

-- Spojeni PRIMARNI tabulky t_Martin_kucirek_project_SQL_primary_final (ze které vycházím!) a t_payroll_year_2
-- Vytvoreni nove tabulky t_salary_growth
CREATE OR REPLACE TABLE t_salary_growth
SELECT payroll_year, payroll_year_2, average_salary, average_salary_2, 
	round((average_salary_2 - average_salary) / average_salary_2 * 100, 2 ) AS salary_growth
FROM t_Martin_kucirek_project_SQL_primary_final
LEFT JOIN t_payroll_year_2
	ON payroll_year = payroll_year_2 -1
ORDER BY payroll_year ASC;


SELECT *
FROM t_salary_growth;

-- Vpocet mezirocnimu rustu cen u potravin.
-- K vypoctu nam pomohla tabulka ze 3. ukolu: t_food_price_change
-- Tato tabulka generuje odpovedi z PRIMARNI! tabulky.
SELECT *,
	round((average_food_price_2 - average_food_price) / average_food_price_2 * 100, 2 ) AS price_growth
FROM t_food_price_change
GROUP BY year_of_measurement 
ORDER BY year_of_measurement ASC;
	
-- Spojeni dvou tabulek t_difference_salary_food_price a t_food_price_change pres (year_of_measurement = payroll_year).
CREATE OR REPLACE TABLE t_difference_salary_food_price AS 
SELECT *
FROM (
	SELECT food_name, year_of_measurement, 
		round((average_food_price_2 - average_food_price) / average_food_price_2 * 100, 2 ) AS price_growth
	FROM t_food_price_change) t1
LEFT JOIN (
	SELECT payroll_year, salary_growth
	FROM t_salary_growth) t2
	ON year_of_measurement = payroll_year;
	

-- Ukazat vse z nove tabulky t_difference_salary_food_price.
SELECT *
FROM t_difference_salary_food_price;
	

-- Filtrovani a urceni poradi dat v tabulce t_difference_salary_food_price.
SELECT year_of_measurement, food_name, price_growth, salary_growth,
	salary_growth - (price_growth)  AS rozdil
FROM t_difference_salary_food_price
ORDER BY rozdil DESC;

-- ODPOVED (4/5): 
-- Zadny takovy rok neni, kde by byl mezirocni narut cen potrvin vyrazne vyssi nez rust mezd. 
