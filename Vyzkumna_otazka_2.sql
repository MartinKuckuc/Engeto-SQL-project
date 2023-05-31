-- 2. OTAZKA
-- Kolik je mozne si koupit litru mleka a kilogramu chleba 
-- za prvni a posledni srovnatelne obdobi v dostupnych datech cen a mezd?

-- Vyuzijeme PRIMARNI tabulku a vyhledame jaka byla prumerna mzda v roce 2006. 
-- Prumerna mzda byla 20342 Kc

SELECT 
	payroll_year, avg(average_salary)
FROM t_martin_kucirek_project_sql_primary_final
WHERE payroll_year = 2006
ORDER BY industry_name ASC, payroll_year ASC;

-- Vyuzijeme PRIMARNI tabulku a vyhledame jaka byla prumerna mzda v roce 2018.
-- Prumerna mzda byla 31980 Kc.

SELECT 
	payroll_year, avg(average_salary)
FROM t_martin_kucirek_project_sql_primary_final
WHERE payroll_year = 2018
ORDER BY industry_name ASC, payroll_year ASC;

-- Vyuzijeme PRIMARNI tabulku a vyhledame prumernou cenu mléka a chleba v roce 2006 a 2018.
-- Mleko 14,44 (2006) a 19,82 (2018).
-- Chleb 16,12 (2006) a 24,24 (2018).

SELECT 
	food_name, payroll_year, average_food_price
FROM t_martin_kucirek_project_sql_primary_final tmkpspf
WHERE food_name = "Mléko polotučné pasterované"
	OR food_name = "Chléb konzumní kmínový"
GROUP BY food_name, payroll_year;

-- ODPOVED (2/5):
-- Mleko 14,44 (2006) a 19,82 (2018).
-- Chleb 16,12 (2006) a 24,24 (2018).
-- Prumerna mzda v roce 2006 byla 20342 Kc.
-- Prumerna mzda v roce 2018 byla 31980 Kc.

-- Vypocet pro rok 2006. Z prumerného platu si zamestnanec mohl v roce 2006 koopit 1408 litru mleka.  
SELECT 20342/14.44;
-- Vypocet pro rok 2006. Z prumerného platu si zamestnanec mohl v roce 2006 koopit 1261 kilogramu chleba. 
SELECT 20342/16.12;

-- Vypocet pro rok 2006. Z prumerného platu si zamestnanec mohl v roce 2006 koopit 1613 litru mleka.  
SELECT 31980/19.82;
-- Vypocet pro rok 2006. Z prumerného platu si zamestnanec mohl v roce 2006 koopit 1319 kilogramu chleba. 
SELECT 31980/24.24;
