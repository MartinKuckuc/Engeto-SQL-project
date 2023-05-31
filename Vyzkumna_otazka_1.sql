-- 1. OTAZKA
-- Rostou v prubehu let mzdy ve vsech odvetvich anebo v nekterych klesaji? 

-- Vyuzijeme primarni tabulku a pomoci SELECT a GROUP BY si z ni vygenerujeme informace, ktere potrebujeme.
SELECT 
	payroll_year, industry_name, average_salary
FROM t_martin_kucirek_project_sql_primary_final
GROUP BY payroll_year, industry_name 
ORDER BY industry_name ASC, payroll_year ASC;

-- ODPOVED (1/5): 
-- Data v tabulce referuji celkem o 19 odvetvi. Vetsinove rostou prumerne mzdy zamestnancu. Ovsem jsou roky, kdy dojde k poklesu hrube mzdy zamestnancu.
-- Atak jsou pouze 2 odvetvi, ve kterych rostou mzdy po celou dobu. Odvetvi N (Administrativni a podpurne cinnosti) a J (Informacni a komunikacni oblasti). 
