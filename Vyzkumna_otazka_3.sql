-- 3. OTAZKA
-- Ktera kategorie potravin zdrazuje nejpomaleji (je u ni nejnizsi percentualni mezirocni narust)?

-- Vytvoreni tabulky t_food_price, vytazeni informaci z primarni tabulky t_Martin_Kucirek_project_SQL_primary_final
-- Novou tabulku si musim pripravit, abych mohl nize pojovat data pres LEF JOIN

CREATE OR REPLACE TABLE t_food_price
SELECT
	food_name AS food_name_2,
	average_food_price AS average_food_price_2,
	year_of_measurement AS year_of_measurement_2
FROM t_Martin_Kucirek_project_SQL_primary_final
WHERE average_food_price IS NOT NULL;

-- Zobrazeni tabulky t_food_price
SELECT *
FROM t_food_price;


-- Vytvoreni tabulky t_food_price_change
-- Data musim brat z jine tabulky abych novou tabulku mohl propojit s tabulkou primary 
-- Spojeni PRIMARNI! tabulky (t_Martin_Kucirek_project_SQL_primary_final), ze které vycházím a t_food_price
-- Pres prikaz LEFT JOIN ON year_of_measurement = year_of_measurement_2 - 1

CREATE OR REPLACE TABLE t_food_price_change
SELECT 
	food_name,
	food_name_2,
	average_food_price,
	average_food_price_2,
	year_of_measurement, 
	year_of_measurement_2
FROM t_Martin_Kucirek_project_SQL_primary_final
LEFT JOIN t_food_price
	ON t_Martin_Kucirek_project_SQL_primary_final.year_of_measurement = t_food_price.year_of_measurement_2 - 1
WHERE food_name = food_name_2 
GROUP BY food_name, food_name_2, year_of_measurement;

-- Vypocet mezirocniho narustu pomoci klauzule round
-- Odpoved na otazku a je generovana z hlavni tabulky primary! (t_Martin_Kucirek_project_SQL_primary_final)

SELECT 
	round((t_food_price.average_food_price_2 - t_Martin_Kucirek_project_SQL_primary_final.average_food_price) / t_food_price.average_food_price_2 * 100, 2 ) AS price_growth,
	food_name,
	food_name_2,
	average_food_price,
	average_food_price_2,
	year_of_measurement, 
	year_of_measurement_2
FROM t_Martin_Kucirek_project_SQL_primary_final
LEFT JOIN t_food_price
	ON t_Martin_Kucirek_project_SQL_primary_final.year_of_measurement = t_food_price.year_of_measurement_2 - 1
WHERE t_Martin_Kucirek_project_SQL_primary_final.food_name = t_food_price.food_name_2 
GROUP BY food_name, food_name_2, year_of_measurement
ORDER BY price_growth ASC;


-- ODPOVED (3/5): 
-- Mnoho potravin mezirocne zlevnilo. Jedna se celkem o 119 polozek ve srovnavacim obdobi mezi lety 2006-2018.
-- Nejvice zlevnily rajska jablka cervena kulata, která mezi lety 2006 a 2007 zlevnily o 43,43 % (z 57,83 Kč za kg na 40,32 Kč). 
-- Nejmensi narust prumernych cen byl pozorovan u rostlinneho roztiratelneho tuku, ktery mezi lety 2008 a 2009 zdrazil pouze o 0.01 % (z 84,4 Kč za litr a 84,41 Kč).
