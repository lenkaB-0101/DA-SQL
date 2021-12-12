CREATE TABLE t_Lenka_Balcarova_projekt2_SQL_final (
 l_country serial PRIMARY KEY,
 l_countries TEXT,
 l_date DATETIME,
 l_confirmed DOUBLE 
 );
 
 -- POMOCNÁ IDENTIFIKACE SLOUPCŮ
 -- l_province text,
 -- l_weekend integer,
 -- l_population_calcul double,
 -- l_population_density double,
 -- l_year text,
 -- l_GDP_mil double,
 -- l_population double,
 -- l_gini double,
 -- l_mortaliy_under5 double,
-- l_median_age_2018 double,
-- l_religion text,
-- l_religion_share_2020 double,
 -- l_capital_city text,
-- l_max_temp varchar(512),
--  l_rain text,
 -- l_iso3 text,
--  l_time text,
--  l_city text,
--  l_max_wind varchar(512)


ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_weekend INTEGER;
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_province TEXT;
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_tests_performed INTEGER;
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_population_calcul DOUBLE;
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_population_density DOUBLE;
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_year TEXT;
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_GDP_mil DOUBLE;
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_population DOUBLE;
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_gini DOUBLE;
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_mortaliy_under5 DOUBLE;
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_median_age_2018 DOUBLE;
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_religion TEXT; 
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_religion_share_2020 DOUBLE;
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_life_exp_1965 DOUBLE;
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_life_exp_2015 DOUBLE;
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_life_exp_ratio DOUBLE;
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_iso3 TEXT;
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_capital_city TEXT;
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_max_temp VARCHAR(512);
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_rain TEXT;
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_time TEXT;
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_city TEXT;
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_max_wind VARCHAR(512);
ALTER TABLE t_Lenka_Balcarova_projekt2_SQL_final ADD COLUMN l_rocni_obdobi INTEGER;



INSERT INTO t_Lenka_Balcarova_projekt2_SQL_final (l_countries , l_date, l_confirmed); 
SELECT 
       country, 
       date, 
       confirmed 
FROM covid19_basic_differences
WHERE confirmed > 0;




INSERT INTO t_Lenka_Balcarova_projekt2_SQL_final (l_countries , l_province, l_date, l_weekend, l_confirmed);
SELECT 
	ccdg.country , 
	ccdg.province , 
	ccdg.date, 
CASE WHEN WEEKDAY(ccdg.date) IN (5, 6) THEN 1 
	ELSE 0 END AS weekend, 
        ccdg.confirmed 
FROM covid19_detail_global_differences ccdg 
JOIN lookup_table lt 
    	ON ccdg.country = lt.country 
    	AND ccdg.province = lt.province 
    	AND confirmed IS NOT NULL 
ORDER BY ccdg.province , ccdg.date DESC;




INSERT INTO t_Lenka_Balcarova_projekt2_SQL_final (l_countries , l_date, l_tests_performed);
SELECT 	
	ct.country, 
	ct.`date`, 
	COUNT(ct.tests_performed) AS l_tests_performed
FROM covid19_tests ct
GROUP BY tests_performed;




INSERT INTO t_Lenka_Balcarova_projekt2_SQL_final (l_countries, l_province, l_date, l_rocni_obdobi, l_confirmed);
SELECT  	
	ccdg.country , 
	ccdg.province , 
	ccdg.date, 
CASE WHEN MONTH(ccdg.date) IN (01, 02, 03) THEN 0 
    	 WHEN MONTH(ccdg.date) IN (04, 05, 06) THEN 1 
    	 WHEN MONTH(ccdg.date) IN (07, 08, 09) THEN 2
    	 ELSE 3 END AS rocni_obdobi, 
    ccdg.confirmed 
FROM covid19_detail_global_differences ccdg 
JOIN lookup_table lt 
    	ON ccdg.country = lt.country 
    	AND ccdg.province = lt.province 
    	AND confirmed IS NOT NULL 
ORDER BY ccdg.province , ccdg.date DESC;




INSERT INTO t_Lenka_Balcarova_projekt2_SQL_final (l_countries , l_population_calcul, l_population_density);
SELECT 
	country, 
        ROUND( population / surface_area ) AS population_calcul, 
   	ROUND( population_density , 2 ) AS population_density
FROM countries
GROUP BY population_calcul DESC;




INSERT INTO t_Lenka_Balcarova_projekt2_SQL_final (l_countries, l_year, l_GDP_mil, l_population, l_gini);
SELECT  
	c.country,
  	e.year, 
        ROUND( e.GDP / 1000000, 2 ) as GDP_mil, 
        e.population , e.gini 
FROM countries c 
JOIN economies e 
    ON c.country = e.country
WHERE gini IS NOT NULL
GROUP BY GDP_mil desc;
 
  
   

INSERT INTO t_Lenka_Balcarova_projekt2_SQL_final (l_countries , l_year, l_mortaliy_under5);
SELECT 
	country,
	year,
	mortaliy_under5
FROM demographics d 
WHERE mortaliy_under5 IS NOT NULL
GROUP BY mortaliy_under5 DESC;



INSERT INTO t_Lenka_Balcarova_projekt2_SQL_final (l_countries , l_median_age_2018);
SELECT 
	country, 
	median_age_2018 
FROM countries
WHERE median_age_2018 IS NOT NULL
GROUP BY median_age_2018 DESC;



INSERT INTO t_Lenka_Balcarova_projekt2_SQL_final (l_countries , l_religion, l_religion_share_2020);
SELECT 
	   r.country , 
	   r.religion , 
           ROUND( r.population / r2.total_population_2020 * 100, 2 ) AS religion_share_2020
FROM religions r 
JOIN (
        SELECT 
		r.country , 
        	r.year,  
        	SUM(r.population) AS total_population_2020
FROM religions r 
WHERE r.year = 2020 AND r.country != 'All Countries' 
GROUP BY r.country
    ) r2
ON r.country = r2.country;
  
   
INSERT INTO t_Lenka_Balcarova_projekt2_SQL_final (l_countries, l_life_exp_1965, l_life_exp_2015, l_life_exp_ratio);
SELECT  
	a.country,
	a.life_exp_1965 , 
	b.life_exp_2015,
   	ROUND( b.life_exp_2015 / a.life_exp_1965, 2 ) AS life_exp_ratio
FROM (
SELECT  
	le.country , 
	le.life_expectancy AS life_exp_1965
FROM life_expectancy le 
WHERE year = 1965
    ) a 
JOIN (
SELECT  
	le.country , 
	le.life_expectancy AS life_exp_2015
FROM life_expectancy le 
WHERE year = 2015
    ) b
ON a.country = b.country;
    
   

INSERT INTO t_Lenka_Balcarova_projekt2_SQL_final (l_countries , l_date, l_iso3, l_capital_city, l_max_temp);
SELECT 
	cbd.country, 
	cbd.date, 
	lt.iso3 , 
	c2.capital_city ,
	w.max_temp
FROM covid19_basic AS cbd 
JOIN lookup_table lt 
    ON cbd.country = lt.country 
JOIN countries c2
    ON lt.iso3 = c2.iso3
JOIN (  
SELECT 
	w.city , 
	w.date , 
	MAX(w.temp) AS max_temp
FROM weather w 
GROUP BY w.city, w.date) w
    ON c2.capital_city = w.city 
    AND cbd.date = w.date
ORDER BY cbd.date DESC;



INSERT INTO t_Lenka_Balcarova_projekt2_SQL_final (l_date, l_rain, l_time, l_city);
SELECT 
	`date`, 
	rain,
	`time`, 
	city 
FROM weather 
WHERE `time` BETWEEN '06:00' AND '22:00'
	   AND rain > '0.2';


INSERT INTO t_Lenka_Balcarova_projekt2_SQL_final (l_city, l_time, l_max_wind)
SELECT
	city,
	`time`,
	MAX(wind) 
FROM weather 
WHERE `time` BETWEEN '06:00' AND '22:00';


-- výsledek

SELECT		
	*
FROM t_lenka_balcarova_projekt2_sql_final tlbpsf;
