-- 5. OTAZKA:
-- Ma vyska HDP vliv na zmeny ve mzdach a cenach potravin? Neboli, pokud HDP vzroste vyrazneji v jednom roce, projevi se to na cenach potravin 
-- ci mzdach ve stejnem nebo nasdujícím roce vyraznějším rustem?

-- Vyuziji sekundarni tabulky t_martin_kucirek_project_sql_secondary_final a vytvorim si view, ktery upravuji 
-- Pridam podminku pro Czech Republic.
-- Vyuziju vypoctu pomoci lag - OVER. Klauzule pouzije udaje z predchoziho radku srovnano podle YEAR a vypocita se change_of_gdp.

CREATE OR REPLACE VIEW v_martin_kucirek_project_sql_secondary_final AS 
SELECT *, round(((gdp - (lag(gdp) OVER (ORDER BY `YEAR`))) / (lag(gdp) OVER (ORDER BY `YEAR`)) * 100), 2) AS change_of_gdp
FROM t_martin_kucirek_project_sql_secondary_final
WHERE country_countries = 'Czech Republic';

-- Zobrazeni nového view ze sekundarni tabulky!
SELECT *
FROM v_martin_kucirek_project_sql_secondary_final;

-- Tabulka ze 4.ukolu:
SELECT *
FROM t_differences_in_salary_and_prices;


-- Tabulka ze 4.ukolu t_difference_salary_food_price obohacena o dalsi vypocet
CREATE OR REPLACE TABLE t_difference_salary_food_price AS 
SELECT *,
	price_growth - salary_growth AS difference_price_and_salary
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

-- Spojeni tabulek t_difference_salary_food_price a t_difference_salary_food_price
-- pres: t_differences_in_salary_and_prices.year = t_difference_salary_food_price.year_of_measurement.
SELECT *
FROM t_difference_salary_food_price
JOIN t_differences_in_salary_and_prices
	ON t_differences_in_salary_and_prices.year = t_difference_salary_food_price.year_of_measurement;

-- Filtrovani zobrazovacich dat:
SELECT year_of_measurement, country_countries, food_name,  
	change_of_gdp, price_growth, salary_growth, difference_price_and_salary
FROM t_difference_salary_food_price
JOIN t_differences_in_salary_and_prices
	ON t_differences_in_salary_and_prices.year = t_difference_salary_food_price.year_of_measurement;

-- ODPOVED (5/5):
-- Podle vysledku z tabulky nema primy vliv na cenu veskereho zbozi rust mezd jednotlivych odvetvi anebo narust gdp.
