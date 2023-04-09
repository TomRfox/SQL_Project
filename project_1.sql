CREATE VIEW payroll_without_null AS
SELECT
    id,
    value,
    value_type_code,
    industry_branch_code,
    payroll_year
FROM
    czechia_payroll AS cp
WHERE
(
    industry_branch_code IS NOT NULL AND value_type_code = "5958"
);


/* Vytvoří pohled, seskupí a seřadí dle roku najde MIN a MAX hodnotu v roce a odvětví a zprůměruje mzdy ve VŠECH odvětvích.
 */

CREATE VIEW avg_payroll_by_years AS
SELECT
    industry_branch_code,
    MIN(value) AS minimal,
    MAX(value) AS maximal,
    ROUND(AVG(value), 0) AS average,
    CASE
        WHEN MAX(value) - MIN(value) < 0 THEN 'mzdy klesají'
        WHEN MAX(value) - MIN(value) > 0 THEN 'mzdy rostou'
        ELSE 'stagnují'
    END AS difference
FROM payroll_without_null AS pwn
GROUP BY industry_branch_code
ORDER BY payroll_year DESC;

/* dole pokusy nahoře FINAL

SELECT
    *
FROM czechia_payroll_industry_branch AS cpib
WHERE code IN (
    SELECT
        industry_branch_code
    FROM payroll_without_null AS pwn
    WHERE value IN (
        SELECT
            MAX(value)
        FROM payroll_without_null AS pwn2
    )
);


SELECT
    industry_branch_code,
    value,
    MIN(value) AS `MIN`,
    MAX(value) AS `MAX`,
    ROUND(AVG(value), 2) AS average
FROM payroll_without_null AS pwn
GROUP BY industry_branch_code
ORDER BY average DESC;



SELECT
    industry_branch_code,
    MIN(value),
    MAX(value),
    CASE
        WHEN MAX(value) - MIN(value) < 0 THEN 'mzdy klesají'
        WHEN MAX(value) - MIN(value) > 0 THEN 'mzdy rostou'
        ELSE 'stagnují'
    END AS difference
FROM payroll_without_null AS pwn
GROUP BY industry_branch_code;

