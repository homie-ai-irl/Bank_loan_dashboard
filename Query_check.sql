--Total Loan Applications

;SELECT COUNT(*) AS Total_Applications
FROM Bankloandata


--MTD Loan Applications

;SELECT COUNT(*) AS MTD_Total_Applications
FROM Bankloandata
WHERE MONTH(issue_date) = 12


--PMTD Loan Applications

;SELECT COUNT(*) AS PMTD_Total_Applications
FROM Bankloandata
WHERE MONTH(issue_date) = 11


--MoM Loan Applications

;WITH Monthlydata AS (
	SELECT 
		YEAR(issue_date) AS year_id,
		MONTH(issue_date) AS month_id,
		COUNT(*) AS Total_Loan_Applications
	FROM Bankloandata
	GROUP BY YEAR(issue_date), MONTH(issue_date)
),
MoM AS(
	SELECT
		year_id,
		month_id,
		Total_Loan_Applications,
		LAG(Total_Loan_Applications) OVER (ORDER BY year_id, month_id) AS PMTD_Loan_Applications
	FROM Monthlydata 
)
SELECT
	year_id,
	month_id,
	Total_Loan_Applications,
	PMTD_Loan_Applications,
	ROUND((Total_Loan_Applications - PMTD_Loan_Applications) * 100.0 / NULLIF(PMTD_Loan_Applications,0),2
	) AS MoM_percentage
FROM MoM


--Total Funded Amount

;SELECT SUM(loan_amount) AS Total_Funded_Amount
FROM Bankloandata


--MTD Total Funded Amount

;SELECT SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM Bankloandata
WHERE MONTH(issue_date) = 12


--PMTD Total Funded Amount

;SELECT SUM(loan_amount) AS PMTD_Total_Funded_Amount
FROM Bankloandata
WHERE MONTH(issue_date) = 11


--MoM Total Funded Amount

;WITH Monthlydata AS (
	SELECT 
		YEAR(issue_date) AS year_id,
		MONTH(issue_date) AS month_id,
		SUM(loan_amount) AS Total_Funded_Amount
	FROM Bankloandata
	GROUP BY YEAR(issue_date), MONTH(issue_date)
),
MoM AS(
	SELECT
		year_id,
		month_id,
		Total_Funded_Amount,
		LAG(Total_Funded_Amount) OVER (ORDER BY year_id, month_id) AS PMTD_Funded_Amount
	FROM Monthlydata 
)
SELECT
	year_id,
	month_id,
	Total_Funded_Amount,
	PMTD_Funded_Amount,
	ROUND((Total_Funded_Amount - PMTD_Funded_Amount) * 100.0 / NULLIF(PMTD_Funded_Amount,0),2
	) AS MoM_percentage
FROM MoM


--Total Received Amount

;SELECT SUM(total_payment) AS Total_Received_Amount
FROM Bankloandata

--MTD Received Amount

;SELECT SUM(total_payment) AS MTD_Received_Amount
FROM Bankloandata
WHERE MONTH(issue_date) = 12


--PMTD Received Amount

;SELECT SUM(total_payment) AS PMTD_Total_Received_Amount
FROM Bankloandata
WHERE MONTH(issue_date) = 11


--MoM Total Received Amount

;WITH Monthlydata AS (
	SELECT 
		YEAR(issue_date) AS year_id,
		MONTH(issue_date) AS month_id,
		SUM(total_payment) AS Total_Received_Amount
	FROM Bankloandata
	GROUP BY YEAR(issue_date), MONTH(issue_date)
),
MoM AS(
	SELECT
		year_id,
		month_id,
		Total_Received_Amount,
		LAG(Total_Received_Amount) OVER (ORDER BY year_id, month_id) AS PMTD_Received_Amount
	FROM Monthlydata 
)
SELECT
	year_id,
	month_id,
	Total_Received_Amount,
	PMTD_Received_Amount,
	ROUND((Total_Received_Amount - PMTD_Received_Amount) * 100.0 / NULLIF(PMTD_Received_Amount,0),2
	) AS MoM_percentage
FROM MoM


--Avg Interest Rate

;SELECT	
	CAST(AVG(int_rate)*100 AS decimal(6,2)) AS AVG_Int_Rate
FROM Bankloandata


--MTD Avg Interest Rate

;SELECT	
	CAST(AVG(int_rate)*100 AS decimal(6,2)) AS MTD_AVG_Int_Rate
FROM Bankloandata
WHERE MONTH(issue_date) = 12

--PMTD Avg Interest Rate

;SELECT	
	CAST(AVG(int_rate)*100 AS decimal(6,2)) AS PMTD_AVG_Int_Rate
FROM Bankloandata
WHERE MONTH(issue_date) = 11


--MoM Avg Interest Rate

;WITH MonthlyData AS (
	SELECT MONTH(issue_date) AS month_id,
	YEAR(issue_date) AS year_id,
	AVG(int_rate) AS AVG_int_rate
	FROM Bankloandata
	GROUP BY MONTH(issue_date), YEAR(issue_date)
),
MoM AS(
	SELECT year_id,
	month_id,
	AVG_int_rate,
	LAG(AVG_int_rate) OVER(ORDER BY year_id, month_id) AS AVG_rate_previous_month
	FROM MonthlyData
)
SELECT
	year_id,
	month_id,
	AVG_int_rate,
	AVG_rate_previous_month,
	ROUND(
	(AVG_int_rate - AVG_rate_previous_month )*100.0 / NULLIF(AVG_rate_previous_month,0), 2 )AS MoM_Percentage
FROM MoM
ORDER BY year_id, month_id


--Avg AVG DTI

;SELECT	
	CAST(AVG(dti)*100 AS decimal(6,2)) AS AVG_DTI
FROM Bankloandata


--MTD AVG DTI

;SELECT	
	CAST(AVG(dti)*100 AS decimal(6,2)) AS MTD_AVG_DTI
FROM Bankloandata
WHERE MONTH(issue_date) = 12


--PMTD AVG DTI

;SELECT	
	CAST(AVG(dti)*100 AS decimal(6,2)) AS PMTD_AVG_DTI
FROM Bankloandata
WHERE MONTH(issue_date) = 11


--MoM AVG DTI

;WITH MonthlyData AS (
	SELECT MONTH(issue_date) AS month_id,
	YEAR(issue_date) AS year_id,
	AVG(dti) AS AVG_DTI
	FROM Bankloandata
	GROUP BY MONTH(issue_date), YEAR(issue_date)
),
MoM AS(
	SELECT year_id,
	month_id,
	AVG_DTI,
	LAG(AVG_DTI) OVER(ORDER BY year_id, month_id) AS Previous_AVG_DTI
	FROM MonthlyData
)
SELECT
	year_id,
	month_id,
	AVG_DTI,
	Previous_AVG_DTI	,
	ROUND(
	(AVG_DTI - Previous_AVG_DTI )*100.0 / NULLIF(Previous_AVG_DTI,0), 2 )AS MoM_Percentage
FROM MoM
ORDER BY year_id, month_id


--Good Loan Percentage

;SELECT
	CAST(
		COUNT(
			CASE
				WHEN loan_status IN ('Fully paid','Current') THEN id
				END
				) * 100.0 / COUNT(*) as decimal(6,2)
			) AS Good_Loan_Percentage
FROM Bankloandata


--Good Loan Applications

;SELECT
	COUNT(*) AS Total_good_loan_applications
FROM Bankloandata
WHERE loan_status IN ('Fully paid','Current')


--Good loan funded amount

;SELECT
	SUM(loan_amount) AS Total_good_funded_amount
FROM Bankloandata
WHERE loan_status IN ('Fully paid','Current')


--Good loan received amount

;SELECT
	SUM(total_payment) AS Total_good_received_amount
FROM Bankloandata
WHERE loan_status IN ('Fully paid','Current')


--Bad Loan Percentage

;SELECT
	CAST(
		COUNT(
			CASE
				WHEN loan_status = 'Charged Off' THEN id
				END
				) * 100.0 / COUNT(*) as decimal(6,2)
			) AS Bad_Loan_Percentage
FROM Bankloandata


--Bad Loan Applications

;SELECT
	COUNT(*) AS Total_bad_loan_applications
FROM Bankloandata
WHERE loan_status = 'Charged Off'


--Bad loan funded amount

;SELECT
	SUM(loan_amount) AS Total_bad_funded_amount
FROM Bankloandata
WHERE loan_status = 'Charged Off'

--Bad loan received amount

;SELECT
	SUM(total_payment) AS Total_bad_received_amount
FROM Bankloandata
WHERE loan_status = 'Charged Off'


--Loan status table

;SELECT
	loan_status,
	COUNT(*) AS Total_loan,
	SUM(loan_amount) AS Total_funded_amount,
	SUM(total_payment) AS Total_received_amount,
	AVG(int_rate) * 100 AS Interest_rate,
	AVG(dti) * 100 AS DTI
FROM Bankloandata
GROUP BY loan_status


--Loan status MTD table 

;SELECT
	loan_status,
	SUM(total_payment) AS MTD_total_received_amount,
	SUM(loan_amount) AS MTD_total_funded_amount
FROM Bankloandata
WHERE MONTH(issue_date) = 12
GROUP BY loan_status


--Month filter table

SELECT
	MONTH(issue_date) AS Month_number,
	COUNT(*) AS Total_loan_applications,
	SUM(loan_amount) AS Total_funded_amount,
	SUM(total_payment) AS Total_received_amount
FROM Bankloandata
GROUP BY MONTH(issue_date)
ORDER BY MONTH(issue_date)


--State filter table

SELECT
	address_state AS "sate",
	COUNT(*) AS Total_loan_applications,
	SUM(loan_amount) AS Total_funded_amount,
	SUM(total_payment) AS Total_received_amount
FROM Bankloandata
GROUP BY address_state
ORDER BY address_state


--Term filter table

SELECT
	term AS Term,
	COUNT(*) AS Total_loan_applications,
	SUM(loan_amount) AS Total_funded_amount,
	SUM(total_payment) AS Total_received_amount
FROM Bankloandata
GROUP BY term
ORDER BY term


--Employee length filter table

SELECT
	emp_length AS Employee_length,
	COUNT(*) AS Total_loan_applications,
	SUM(loan_amount) AS Total_funded_amount,
	SUM(total_payment) AS Total_received_amount
FROM Bankloandata
GROUP BY emp_length
ORDER BY emp_length


--Purpose filter table

SELECT
	purpose AS Purpose,
	COUNT(*) AS Total_loan_applications,
	SUM(loan_amount) AS Total_funded_amount,
	SUM(total_payment) AS Total_received_amount
FROM Bankloandata
GROUP BY purpose
ORDER BY purpose


--Home ownership

SELECT
	home_ownership AS Home_Ownership,
	COUNT(*) AS Total_loan_applications,
	SUM(loan_amount) AS Total_funded_amount,
	SUM(total_payment) AS Total_received_amount
FROM Bankloandata
GROUP BY home_ownership
ORDER BY home_ownership