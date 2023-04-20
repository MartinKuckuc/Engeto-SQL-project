-- 1. OTAZKA
-- Rostou v prubehu let mzdy ve vsech odvetvich anebo v nekterych klesaji? 
SELECT *
FROM czechia_payroll cp;

-- Vypiseme si z tabulky udaje, o ktere mame zajem. 
SELECT
	cp.industry_branch_code, 
	cp.value,
	cp.value_type_code,
	cp.payroll_year 
FROM czechia_payroll cp; 

-- Vyloucime z prikazu vsechny nullove hodnoty.
SELECT
	cp.industry_branch_code, 
	cp.value,
	cp.value_type_code,
	cp.payroll_year 
FROM czechia_payroll cp
WHERE cp.value_type_code = 5958 
	AND cp.industry_branch_code IS NOT NULL;

-- Secteme vsechny hodnoty jednotlivych odvetvi za dany rok a porovname rust mezd mezi sebou.
SELECT
	cp.industry_branch_code, 
	cp.value,
	cp.value_type_code,
	cp.payroll_year 
FROM czechia_payroll cp
WHERE cp.value_type_code = 5958 
	AND cp.industry_branch_code IS NOT NULL
GROUP BY industry_branch_code, payroll_year;

-- ODPOVED (1/5): 
-- Data v tabulce referuji celkem o 19 odvetvi. Vetsinove rostou prumerne mzdy zamestnancu. Ovsem jsou roky, kdy dojde k poklesu hrube mzdy zamestnancu.
-- Atak jsou pouze 2 odvetvi, ve kterych rostou mzdy po celou dobu. Odvetvi N (Administrativni a podpurne cinnosti) a J (Informacni a komunikacni oblasti). 

-- 2. OTAZKA
-- Kolik je mozne si koupit litru mleka a kilogramu chleba 
-- za prvni a posledni srovnatelne obdobi v dostupnych datech cen a mezd?

SELECT *
FROM czechia_price cp;

-- Zde si nalezneme, potraviny, ktere hledame - mleko a chleba.
-- Vysledek: Kod potravin je 114201 a 111301.
SELECT *
FROM czechia_price cp
GROUP BY category_code
ORDER BY value ASC;

-- Pomoci tohoto prikazu si najdeme, jake bylo prvni a posledni zuctovaci obdobi.
-- Vysledek:  Prvni a posledni srvnavaci obdobi je 2006 a 2018.
SELECT *
FROM czechia_price cp
GROUP BY category_code
ORDER BY date_from DESC;


-- Zde zjistime, kolik stalo mleko a chleba v prvnim srovnavacim obdobi. 
-- Vysledek: Chleb stal 14,11 Kc a mleko 14,13 Kc v roce 2006. 
SELECT
	category_code, 
	value,
	date_from,
	date_to 
FROM czechia_price cp 
WHERE 
	date_from >= '2006-01-02' AND date_to <= '2006-01-08'
	AND category_code IN ('114201', '111301')
GROUP BY category_code
ORDER BY value ASC;

-- A kolik produkty staly v poslednim srovnavacim obdobi.
-- Vysledek: Chleb stal 24,28 Kc a mleko 18,24 Kc. 
SELECT
	category_code, 
	value,
	date_from,
	date_to 
FROM czechia_price cp 
WHERE 
	date_from >= '2018-12-10' AND date_to <= '2018-12-16'
	AND category_code IN ('114201', '111301')
GROUP BY category_code
ORDER BY value ASC;

-- Kolik byla prumerna hruba mzda mzda (kod 5958) v prvnim a kolik v poslednim srovnatelnem obdobi (2006 a 2018)?
-- Vysledek: Prikaz nam ukazuje vysledek za jednotlive kategorie A-S v letech 2006 a 2018.
SELECT
	cp.industry_branch_code, 
	cp.value,
	cp.value_type_code,
	cp.payroll_year 
FROM czechia_payroll cp
WHERE cp.value_type_code = 5958 
	AND cp.industry_branch_code IS NOT NULL
	AND payroll_year IN (2006, 2018)
GROUP BY industry_branch_code, payroll_year;

-- Jaka byla prumerna hruba mzda za vsechny kategorie v roce 2006?
-- Vysledek: 19.218,875 Kc
SELECT
	avg(value),
	cp.industry_branch_code, 
	cp.value,
	cp.value_type_code,
	cp.payroll_year 
FROM czechia_payroll cp
WHERE payroll_year = 2006
	AND value_type_code = 5958
GROUP BY industry_branch_code , payroll_year;

-- Jaka byla prumerna hruba mzda za vsechny kategorie v roce 2018?
-- Vysledek: 31.520,5 Kc
SELECT
	avg(value),
	cp.industry_branch_code, 
	cp.value,
	cp.value_type_code,
	cp.payroll_year 
FROM czechia_payroll cp
WHERE payroll_year = 2018
	AND value_type_code = 5958
GROUP BY industry_branch_code , payroll_year;

-- ODPOVED (2/5):
-- Vypocet pro rok 2006. Vysledek: 1362 kilogramu chleba za rok 2006.
SELECT 19218.875/14.11;
-- Vypocet pro rok 2006. Vysledek: 1360 litru mleka za rok 2006.
SELECT 19218.875/14.13;

-- Vypocet pro rok 2018. Vysledek: 1298 kilogramu chleba za rok 2018.
SELECT 31520.5/24.28;
-- Vypocet pro rok 20018. Vysledek: 1728 litru mleka za rok 2018.
SELECT 31520.5/18.24;

-- 3. OTAZKA
-- Ktera kategorie potravin zdrazuje nejpomaleji (je u ni nejnizsi percentualni mezirocni narust)?
-- Vytvoreni tabulky t_food_price
CREATE OR REPLACE TABLE t_food_price
SELECT
	food_name AS food_name_2,
	average_price AS average_price_2,
	year_of_measurement AS year_of_measurement_2
FROM t_Martin_Kucirek_project_SQL_primary_final
WHERE average_price IS NOT NULL;

-- Zobrazeni tabulky t_food_price
SELECT *
FROM t_food_price;



-- Vytvoreni tabulky t_food_price_change
CREATE OR REPLACE TABLE t_food_price_change
SELECT 
	food_name,
	food_name_2,
	average_price,
	average_price_2,
	year_of_measurement, 
	year_of_measurement_2
FROM t_Martin_Kucirek_project_SQL_primary_final
LEFT JOIN t_food_price
	ON t_Martin_Kucirek_project_SQL_primary_final.year_of_measurement = t_food_price.year_of_measurement_2 - 1
WHERE food_name = food_name_2 
GROUP BY food_name, food_name_2, year_of_measurement;
	

-- Zobrazeni tabulky t_food_price_change
SELECT *
FROM t_food_price_change;

-- Vypocet mezirocniho narustu
SELECT *,
	round((average_price_2 - average_price) / average_price_2 * 100, 2 ) AS price_growth
FROM t_food_price_change
ORDER BY price_growth ASC;

-- ODPOVED (3/5): 
-- Mnoho potravin mezirocne zlevnilo. Jedna se celkem o 119 polozek ve srovnavacim obdobi mezi lety 2006-2018.
-- Nejvice zlevnily rajska jablka cervena kulata, která mezi lety 2006 a 2007 zlevnily o 43,43 % (z 57,83 Kč za kg na 40,32 Kč). 
-- Nejmensi narust prumernych cen byl pozorovan u rostlinneho roztiratelneho tuku, ktery mezi lety 2008 a 2009 zdrazil pouze o 0.01 % (z 84,4 Kč za litr a 84,41 Kč).

-- 4. OTAZKA  
-- Spojeni dvou tabulek czechia_payroll (cpay) a czechia_payroll_industry_branch (cpib) pres "code" a vytvoreni tabulky t2.
-- Vytvoreni tabulky t_payroll_1
CREATE OR REPLACE TABLE t_payroll_year_1 AS
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
FROM t_payroll_year_1;

-- Vytvoreni tabulky t_payroll_year_2
CREATE OR REPLACE TABLE t_payroll_year_2 AS
SELECT payroll_year AS payroll_year_2, industry_name AS industry_name_2, average_salary AS average_salary_2
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
FROM t_payroll_year_2;

-- Spojeni tabulek t_payroll_year_1 a t_payroll_year_2
-- Vytvoreni nove tabulky t_salary_growth
CREATE OR REPLACE TABLE t_salary_growth
SELECT payroll_year, payroll_year_2, industry_name, industry_name_2, average_salary, average_salary_2, 
	round((average_salary_2 - average_salary) / average_salary_2 * 100, 2 ) AS salary_growth
FROM t_payroll_year_1
LEFT JOIN t_payroll_year_2
	ON payroll_year = payroll_year_2 -1
WHERE
	industry_name = 'Těžba a dobývání' AND industry_name_2 = 'Těžba a dobývání'
	OR industry_name = 'Vzdělávání' AND industry_name_2 = 'Vzdělávání'
	OR industry_name = 'Veřejná správa a obrana; povinné sociální zabezpečení' AND industry_name_2 = 'Veřejná správa a obrana; povinné sociální zabezpečení'
	OR industry_name = 'Peněžnictví a pojišťovnictví' AND industry_name_2 = 'Peněžnictví a pojišťovnictví'
	OR industry_name = 'Velkoobchod a maloobchod; opravy a údržba motorových vozidel' AND industry_name_2 = 'Velkoobchod a maloobchod; opravy a údržba motorových vozidel'
	OR industry_name = 'Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu' AND industry_name_2 = 'Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu'
	OR industry_name = 'Zpracovatelský průmysl' AND industry_name_2 = 'Zpracovatelský průmysl'
	OR industry_name = 'Ostatní činnosti' AND industry_name_2 = 'Ostatní činnosti'
	OR industry_name = 'Informační a komunikační činnosti' AND industry_name_2 = 'Informační a komunikační činnosti'
	OR industry_name = 'Stavebnictví' AND industry_name_2 = 'Stavebnictví'
	OR industry_name = 'Administrativní a podpůrné činnosti' AND industry_name_2 = 'Administrativní a podpůrné činnosti'
	OR industry_name = 'Kulturní, zábavní a rekreační činnosti' AND industry_name_2 = 'Kulturní, zábavní a rekreační činnosti'
	OR industry_name = 'Ubytování, stravování a pohostinství' AND industry_name_2 = 'Ubytování, stravování a pohostinství'
	OR industry_name = 'Zásobování vodou; činnosti související s odpady a sanacemi' AND industry_name_2 = 'Zásobování vodou; činnosti související s odpady a sanacemi'
	OR industry_name = 'Profesní, vědecké a technické činnosti' AND industry_name_2 = 'Profesní, vědecké a technické činnosti'
	OR industry_name = 'Zdravotní a sociální péče' AND industry_name_2 = 'Zdravotní a sociální péče'
	OR industry_name = 'Zemědělství, lesnictví, rybářství' AND industry_name_2 = 'Zemědělství, lesnictví, rybářství'
	OR industry_name = 'Činnosti v oblasti nemovitostí' AND industry_name_2 = 'Činnosti v oblasti nemovitostí'
	OR industry_name = 'Doprava a skladování' AND industry_name_2 = 'Doprava a skladování'
ORDER BY industry_name ASC, payroll_year ASC;

SELECT *
FROM t_salary_growth;

-- Vpocet mezirocnimu rustu cen u potravin.
SELECT *,
	round((average_price_2 - average_price) / average_price_2 * 100, 2 ) AS price_growth
FROM t_food_price_change
ORDER BY price_growth ASC;

-- Spojeni dvou tabulek t_difference_salary_food_price a t_food_price_change pres (year_of_measurement = payroll_year).
CREATE OR REPLACE TABLE t_difference_salary_food_price AS 
SELECT *
FROM (
	SELECT food_name, year_of_measurement, 
		round((average_price_2 - average_price) / average_price_2 * 100, 2 ) AS price_growth
	FROM t_food_price_change) t1
LEFT JOIN (
	SELECT payroll_year, industry_name, salary_growth
	FROM t_salary_growth) t2
	ON year_of_measurement = payroll_year;

-- Ukazat vse z nove tabulky t_difference_salary_food_price.
SELECT *
FROM t_difference_salary_food_price;

-- Filtrovani a urceni poradi dat v tabulce t_difference_salary_food_price.
SELECT year_of_measurement, food_name, price_growth, salary_growth, industry_name,
	price_growth - salary_growth AS rozdil
FROM t_difference_salary_food_price
ORDER BY rozdil DESC;

-- ODPOVED (4/5): 
-- Ano, je spoustu potravin, ktere mezirocne zdrazily o vice nez 10% narust mezd. Celkem zdrazilo 593 polozek o vice jak 10 % nad rozdil rustu mezd
-- ve srovnavacim obdobi. Nejvice zdrazily konzumni brambory v roce 2012 (47,5%) oproti rustu mzdy pro lidi pracujici v oboru Peneznictvi a pojistovnictvi.  


-- 5. OTAZKA:
-- Ma vyska HDP vliv na zmeny ve mzdach a cenach potravin? Neboli, pokud HDP vzroste vyrazneji v jednom roce, projevi se to na cenach potravin 
-- ci mzdach ve stejnem nebo nasdujícím roce vyraznějším rustem?

-- Vyuziju druhe tabulky t_martin_kucirek_project_sql_secondary_final a prejmenuju si ji pro ucely 5. otazky na t_differences_in_salary_and_prices. 
-- Pridam podminku pro Czech Republic.
-- Vyuziti vypoctu pomoci lag - OVER. Klauzule pouzije udaje z predchoziho radku srovnano podle YEAR a vypocita se change_of_gdp.
CREATE OR REPLACE TABLE t_differences_in_salary_and_prices AS 
SELECT country_countries, country_economy, t2.YEAR, t2.gdp, t2.gini, t2.population,
	round(((gdp - (lag(gdp) OVER (ORDER BY `YEAR`))) / (lag(gdp) OVER (ORDER BY `YEAR`)) * 100), 2) AS change_of_gdp
FROM (	
	SELECT c.country AS country_countries, c.continent
	FROM countries c 
	WHERE c.country = 'Czech Republic') t1
LEFT JOIN (
	SELECT e.country AS country_economy, e.population, e.YEAR, e.gdp, e.gini
	FROM economies e
	WHERE YEAR >= 2000 ) t2 
	ON country_countries = country_economy;

-- Vyuziti vypoctu pomoci lag - OVER. Klauzule pouzije udaje z predchoziho radku srovnano podle YEAR a vypocita se change_of_gdp.

SELECT *
FROM t_differences_in_salary_and_prices;


-- Tabulka ze 4.ukolu t_difference_salary_food_price.
CREATE OR REPLACE TABLE t_difference_salary_food_price AS 
SELECT *,
	price_growth - salary_growth AS difference_price_and_salary
FROM (
	SELECT food_name, year_of_measurement, 
	round((average_price_2 - average_price) / average_price_2 * 100, 2 ) AS price_growth
	FROM t_food_price_change) t1
LEFT JOIN (
	SELECT payroll_year, industry_name, salary_growth
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
SELECT year_of_measurement, country_countries, food_name, industry_name, 
	change_of_gdp, price_growth, salary_growth, difference_price_and_salary
FROM t_difference_salary_food_price
JOIN t_differences_in_salary_and_prices
	ON t_differences_in_salary_and_prices.year = t_difference_salary_food_price.year_of_measurement;

-- ODPOVED (5/5):
-- Podle vysledku z tabulky nema primy vliv na cenu veskereho zbozi rust mezd jednotlivych odvetvi anebo narust gdp.

