-- TABULKA 1 = t_Martin_Kucirek_project_SQL_primary_final
/* V tabulce t_Martin_Kucirek_project_SQL_primary_final potrebujeme sloucit:
* czechia_price, czechia_price_category, czechia_payroll, czechia_payroll_industry_branch
* Konkretne by slo o kategorie v tabulkach:
* czechia_price = cpr.value (AS average_food_price), cpr.date_from (AS year_of_measurement, join 3), cpr.category_code (join1)
* czechia_price_category = cpc.code (join1), cpc.name (food_name) 
* czechia_payroll = cp.value (AS average_salary), cp.payroll_year (join 3), cp.industry_branch_code (join2), cp.unit_code (200 v Kc), 
* cp.calculation_code (100 fyzicky), cp.value_type_code (5958 prumerna hruba mzda na zamestance) 
* czechia_payroll_industry_branch = cpib.name, cpib_code (join2)
*/


SELECT *
FROM czechia_price cpr;

SELECT *
FROM czechia_price_category cpc;

SELECT *
FROM czechia_payroll cp;

SELECT *
FROM czechia_payroll_industry_branch cpib;


-- Spojeni dvou tabulek czechia_price (cpr) a czechia_price_category (cpc) pres "code" a vytvořeni prvni tabulky t1.
CREATE OR REPLACE TABLE t_martin_kucirek_project_SQL_primary_final AS
SELECT year_of_measurement, food_name, average_food_price
FROM (
	SELECT cpc.name AS food_name, round(avg(cpr.value),2) AS average_food_price, YEAR(cpr.date_from) AS year_of_measurement
	FROM czechia_price cpr
	LEFT JOIN czechia_price_category cpc
	ON cpr.category_code = cpc.code
	GROUP BY food_name, year_of_measurement
	ORDER BY year_of_measurement, average_food_price ASC ) t1;


SELECT *
FROM t_martin_kucirek_project_sql_primary_final tmkpspf;

-- Spojeni dvou tabulek czechia_payroll (cpay) a czechia_payroll_industry_branch (cpib) pres "code" a vytvoreni tabulky t2.
CREATE OR REPLACE TABLE t_Martin_kucirek_project_SQL_primary_final AS
SELECT payroll_year, industry_name, average_salary
FROM (
	SELECT cpib.name AS industry_name, avg(cpay.value) AS average_salary, cpay.payroll_year
	FROM czechia_payroll cpay
	LEFT JOIN czechia_payroll_industry_branch cpib
	ON cpay.industry_branch_code = cpib.code
	WHERE cpay.value_type_code = 5958
		AND cpay.calculation_code = 100	
		AND cpay.unit_code = 200
		AND cpay.industry_branch_code IS NOT NULL
	GROUP BY cpib.name, cpay.payroll_year
	ORDER BY cpay.payroll_year) t2;

SELECT *
FROM t_martin_kucirek_project_sql_primary_final tmkpspf;


-- Spojeni tabulek t1 a t2 pres year_of_measurement = payroll_year.
CREATE OR REPLACE TABLE t_Martin_kucirek_project_SQL_primary_final AS
SELECT year_of_measurement, payroll_year, food_name, average_food_price, industry_name, average_salary
FROM (
	SELECT cpc.name AS food_name, round(avg(cpr.value),2) AS average_food_price, YEAR(cpr.date_from) AS year_of_measurement
	FROM czechia_price cpr
	LEFT JOIN czechia_price_category cpc
	ON cpr.category_code = cpc.code
	GROUP BY food_name, year_of_measurement
	ORDER BY year_of_measurement, average_food_price ASC ) t1
LEFT JOIN (
	SELECT cpib.name AS industry_name, avg(cpay.value) AS average_salary, cpay.payroll_year
	FROM czechia_payroll cpay
	LEFT JOIN czechia_payroll_industry_branch cpib
	ON cpay.industry_branch_code = cpib.code
	WHERE cpay.value_type_code = 5958
		AND cpay.calculation_code = 100	
		AND cpay.unit_code = 200
		AND cpay.industry_branch_code IS NOT NULL
	GROUP BY cpib.name, cpay.payroll_year
	ORDER BY cpay.payroll_year) t2
ON year_of_measurement = payroll_year
ORDER BY year_of_measurement DESC, average_food_price ASC, average_salary ASC;

SELECT *
FROM t_martin_kucirek_project_sql_primary_final tmkpspf;

-- TABULKA 2 = t_Martin_Kucirek_project_SQL_secondary_final
-- Zadani: Vytvorte tabulku pro dodatečná data o dalších evropských státech.

SELECT *
FROM countries c;

-- Omezeni tabulky pouze na evropske zeme.
SELECT *
FROM countries c 
WHERE continent = 'Europe'
AND country IS NOT NULL;


SELECT *
FROM economies e;

-- Z tabulky nas zajimaji jen nektere udaje: zeme, populace, gdp, gini, rok (od roku 2000, dal do historie jsou ty udaje nekompletni).
SELECT 
	e.country, e.population, e.YEAR, e.gdp, e.gini
	FROM economies e
	WHERE YEAR >= 2000;


-- Vytvoreni tabulky t_martin_kucirek_project_sql_secondary_final.
-- Spojeni tabulek pres zeme (country_countries = country_economy)
CREATE OR REPLACE TABLE t_martin_kucirek_project_sql_secondary_final AS 
SELECT t1.continent, country_countries, country_economy, t2.YEAR, t2.gdp, t2.gini, t2.population
FROM (	
	SELECT c.country AS country_countries, c.continent
	FROM countries c 
	WHERE continent = 'Europe'
	AND c.country IS NOT NULL) t1
LEFT JOIN (
	SELECT e.country AS country_economy, e.population, e.YEAR, e.gdp, e.gini
	FROM economies e
	WHERE YEAR >= 2000 ) t2 
ON country_countries = country_economy;

SELECT *
FROM t_martin_kucirek_project_sql_secondary_final;

