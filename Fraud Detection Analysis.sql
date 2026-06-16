CREATE DATABASE fraud_project;
USE fraud_project;


SELECT *
FROM fraud_detection_cleaned;

SELECT id, Amount, Class
FROM fraud_detection_cleaned;

SELECT id, Amount, Class
FROM fraud_detection_cleaned
LIMIT 10;

SELECT id, Amount, Class AS transaction_type
FROM fraud_detection_cleaned
LIMIT 10;

select count(id) from fraud_detection_cleaned;
SELECT COUNT(*)
FROM fraud_detection_cleaned;

SELECT id, Amount, Class
FROM fraud_detection_cleaned
LIMIT 5;

SELECT id, Amount, Class
FROM fraud_detection_cleaned
WHERE Class = 1;

RENAME TABLE fraud_detection_cleaned TO fraud_data;

SELECT id, Amount, Class
FROM fraud_data
WHERE Class = 0;

SELECT id, Amount, Class
FROM fraud_data
WHERE Amount > 1000;

SELECT id, Amount, Class
FROM fraud_data
WHERE Class = 1 AND Amount > 500;

SELECT id, Amount, Class
FROM fraud_data
WHERE Class = 1 OR Amount > 5000;

SELECT id, Amount, Class
FROM fraud_data
WHERE Amount BETWEEN 100 AND 500
LIMIT 20;

SELECT id, Amount, Class
FROM fraud_data
WHERE Class = 1 AND Amount > 500
LIMIT 10;

SELECT COUNT(*) AS total_fraud
FROM fraud_data
WHERE Class = 1;


SELECT COUNT(*) AS total_legitimate
FROM fraud_data
WHERE Class = 0;

SELECT SUM(Amount) AS total_fraud_amount
FROM fraud_data
WHERE Class = 1;

SELECT AVG(Amount) AS avg_fraud_amount
FROM fraud_data
WHERE Class = 1;

SELECT MAX(Amount) AS highest_fraud
FROM fraud_data
WHERE Class = 1;

SELECT MIN(Amount) AS lowest_fraud
FROM fraud_data
WHERE Class = 1;

SELECT 
    COUNT(*) AS total_fraud,
    SUM(Amount) AS total_amount,
    AVG(Amount) AS avg_amount,
    MAX(Amount) AS highest_amount,
    MIN(Amount) AS lowest_amount
FROM fraud_data
WHERE Class = 1;

SELECT 
    COUNT(*) AS total_transactions,
    SUM(Amount) AS total_amount,
    AVG(Amount) AS avg_amount
FROM fraud_data
WHERE Class = 0;


SELECT Class, COUNT(*) AS total_transactions
FROM fraud_data
GROUP BY Class;

SELECT Class, AVG(Amount) AS avg_amount
FROM fraud_data
GROUP BY Class;

SELECT Class, SUM(Amount) AS total_amount
FROM fraud_data
GROUP BY Class;

SELECT 
    Class,
    COUNT(*) AS total_transactions,
    SUM(Amount) AS total_amount,
    AVG(Amount) AS avg_amount,
    MAX(Amount) AS highest_amount,
    MIN(Amount) AS lowest_amount
FROM fraud_data
GROUP BY Class;

SELECT 
    CASE 
        WHEN Class = 0 THEN 'Legitimate'
        WHEN Class = 1 THEN 'Fraud'
    END AS transaction_type,
    COUNT(*) AS total_transactions,
    AVG(Amount) AS avg_amount
FROM fraud_data
GROUP BY Class;

SELECT id, Amount, Class
FROM fraud_data
WHERE Class = 1
ORDER BY Amount DESC;

SELECT id, Amount, Class
FROM fraud_data
WHERE Class = 1
ORDER BY Amount ASC;

SELECT id, Amount, Class
FROM fraud_data
WHERE Class = 1
ORDER BY Amount DESC
LIMIT 10;

SELECT id, Amount, Class
FROM fraud_data
ORDER BY Class ASC, Amount DESC
LIMIT 20;

SELECT 
    Class,
    COUNT(*) AS total_transactions,
    AVG(Amount) AS avg_amount
FROM fraud_data
GROUP BY Class
ORDER BY avg_amount DESC;

SELECT id, Amount, Class
FROM fraud_data
WHERE Class = 0
ORDER BY Amount DESC
LIMIT 5;

SELECT id, Amount, Class
FROM fraud_data
WHERE Class = 1 
AND Amount > (SELECT AVG(Amount) FROM fraud_data WHERE Class = 1);

SELECT AVG(Amount) AS fraud_avg
FROM fraud_data
WHERE Class = 1;

SELECT COUNT(*) AS above_avg_frauds
FROM fraud_data
WHERE Class = 1
AND Amount > (SELECT AVG(Amount) FROM fraud_data WHERE Class = 1);

SELECT id, Amount, Class
FROM fraud_data
WHERE Class = 1
AND Amount IN (
    SELECT Amount
    FROM fraud_data
    WHERE Class = 1
    ORDER BY Amount DESC
    LIMIT 5
);


SELECT id, Amount, Class
FROM fraud_data
WHERE Class = 1
AND Amount IN (
    SELECT Amount FROM (
        SELECT Amount
        FROM fraud_data
        WHERE Class = 1
        ORDER BY Amount DESC
        LIMIT 5
    ) AS top5
);

SELECT id, Amount, Class
FROM fraud_data
WHERE Class = 1
AND Amount > (SELECT AVG(Amount) FROM fraud_data WHERE Class = 0);

SELECT id, Amount, Class
FROM fraud_data
WHERE Amount = (SELECT MAX(Amount) FROM fraud_data WHERE Class = 1)
AND Class = 1;

SELECT 
    Class,
    AVG(Amount) AS avg_amount,
    (SELECT AVG(Amount) FROM fraud_data) AS overall_avg
FROM fraud_data
GROUP BY Class;

CREATE VIEW fraud_transactions AS
SELECT id, Amount, Class
FROM fraud_data
WHERE Class = 1;

CREATE VIEW high_value_fraud AS
SELECT id, Amount, Class
FROM fraud_data
WHERE Class = 1 AND Amount > 500;

CREATE VIEW fraud_summary AS
SELECT 
    CASE 
        WHEN Class = 0 THEN 'Legitimate'
        WHEN Class = 1 THEN 'Fraud'
    END AS transaction_type,
    COUNT(*) AS total_transactions,
    SUM(Amount) AS total_amount,
    AVG(Amount) AS avg_amount,
    MAX(Amount) AS highest_amount,
    MIN(Amount) AS lowest_amount
FROM fraud_data
GROUP BY Class;

SELECT * FROM fraud_transactions
WHERE Amount > 1000;

SHOW FULL TABLES 
WHERE Table_type = 'VIEW';

DROP VIEW fraud_transactions;

CREATE OR REPLACE VIEW fraud_transactions AS
SELECT id, Amount, Class
FROM fraud_data
WHERE Class = 1 AND Amount > 0;

# Business Question 1 — Fraud Rate kya hai?

SELECT 
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS total_fraud,
    ROUND(
        SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
    2) AS fraud_percentage
FROM fraud_data;

# Business Question 2 — Kitne Fraud ₹1000 se Upar Hain? 
SELECT 
    COUNT(*) AS high_value_frauds,
    SUM(Amount) AS total_amount,
    AVG(Amount) AS avg_amount,
    MAX(Amount) AS highest_amount
FROM fraud_data
WHERE Class = 1 AND Amount > 1000;

# Business Question 3 — Legitimate vs Fraud Amount Compare karo
SELECT 
    CASE 
        WHEN Class = 0 THEN 'Legitimate'
        WHEN Class = 1 THEN 'Fraud'
    END AS transaction_type,
    COUNT(*) AS total_count,
    ROUND(AVG(Amount), 2) AS avg_amount,
    ROUND(SUM(Amount), 2) AS total_amount
FROM fraud_data
GROUP BY Class
ORDER BY avg_amount DESC;

# Business Question 4 — Amount Range ke hisaab se Fraud Breakdown
SELECT 
    CASE 
        WHEN Amount < 100 THEN 'Low (0-100)'
        WHEN Amount BETWEEN 100 AND 1000 THEN 'Medium (100-1000)'
        WHEN Amount > 1000 THEN 'High (1000+)'
    END AS amount_range,
    COUNT(*) AS total_fraud,
    ROUND(AVG(Amount), 2) AS avg_amount
FROM fraud_data
WHERE Class = 1
GROUP BY 
    CASE 
        WHEN Amount < 100 THEN 'Low (0-100)'
        WHEN Amount BETWEEN 100 AND 1000 THEN 'Medium (100-1000)'
        WHEN Amount > 1000 THEN 'High (1000+)'
    END
ORDER BY avg_amount DESC;

# Business Question 5 — Top 10 Highest Fraud Transactions 
SELECT 
    id,
    ROUND(Amount, 2) AS fraud_amount,
    CASE 
        WHEN Amount > 1000 THEN '🚨 Critical'
        WHEN Amount BETWEEN 500 AND 1000 THEN '⚠️ High'
        WHEN Amount BETWEEN 100 AND 500 THEN '📌 Medium'
        ELSE '✅ Low'
    END AS risk_level
FROM fraud_data
WHERE Class = 1
ORDER BY Amount DESC
LIMIT 10;

