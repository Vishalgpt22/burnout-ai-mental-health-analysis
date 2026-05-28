CREATE DATABASE burnout_ai_analysis;

use burnout_ai_analysis;

select * from employee_burnout;

-- Check Null Values

SELECT COUNT(*) AS missing_burnout
FROM employee_burnout
WHERE burnout_score IS NULL;

-- Duplicate Employee IDs

SELECT employee_id, COUNT(*)
       FROM employee_burnout
       GROUP BY employee_id
       HAVING COUNT(*) > 1;
       
-- Invalid Burnout Scores

SELECT *
FROM employee_burnout
WHERE burnout_score < 0
OR burnout_score > 10;

-- Average Burnout Score

SELECT ROUND(AVG(burnout_score),2) AS avg_burnout
FROM employee_burnout;

-- Average Stress Score

SELECT ROUND(AVG(stress_score),2) AS avg_stress
FROM employee_burnout;

-- Average Sleep Hours

SELECT ROUND(AVG(sleep_hours_per_night),2) AS avg_sleep
FROM employee_burnout;

-- Attrition Risk %

SELECT ROUND( AVG(job_change_intention) * 100,2) AS attrition_risk_percentage
FROM employee_burnout;

-- Mental Support Seeking %

SELECT ROUND(AVG(seeks_mental_health_support) * 100, 2 ) AS support_seeking_percentage
FROM employee_burnout;

-- Burnout by Work Mode

SELECT work_mode,ROUND( AVG(burnout_score), 2 ) AS avg_burnout
FROM employee_burnout
GROUP BY work_mode
ORDER BY avg_burnout DESC;

-- Stress by Work Mode

SELECT work_mode,ROUND( AVG(stress_score),2) AS avg_stress
FROM employee_burnout
GROUP BY work_mode;

-- Burnout by Gender

SELECT gender,ROUND( AVG(burnout_score),2) AS avg_burnout
FROM employee_burnout
GROUP BY gender;

-- Burnout by Seniority

SELECT seniority_level,ROUND( AVG(burnout_score),2) AS avg_burnout
FROM employee_burnout
GROUP BY seniority_level
ORDER BY avg_burnout DESC;

-- Burnout by Job Role

SELECT job_role,ROUND(AVG(burnout_score),2) AS avg_burnout
FROM employee_burnout
GROUP BY job_role
ORDER BY avg_burnout DESC;

-- AI Usage vs Burnout

SELECT ai_user_type,ROUND( AVG(burnout_score),2) AS avg_burnout,
ROUND(AVG(stress_score),2) AS avg_stress
FROM employee_burnout
GROUP BY ai_user_type;

-- AI Usage vs Job Satisfaction

SELECT ai_user_type,ROUND( AVG(job_satisfaction_score), 2) AS avg_satisfaction
FROM employee_burnout
GROUP BY ai_user_type;

-- AI Usage vs Work Hours

SELECT ai_user_type, ROUND(AVG(work_hours_per_week),2) AS avg_work_hours
FROM employee_burnout
GROUP BY ai_user_type;

-- Burnout vs Attrition

SELECT burnout_risk, ROUND(AVG(job_change_intention) * 100, 2 ) AS attrition_percentage
FROM employee_burnout
GROUP BY burnout_risk;

-- High Risk Employees

SELECT employee_id,
       burnout_score,
       stress_score,
       work_hours_per_week
FROM employee_burnout
WHERE burnout_score > 8
AND stress_score > 8
AND job_change_intention = 1;

-- Sleep Impact on Burnout

SELECT CASE
           WHEN sleep_hours_per_night < 5 THEN 'Very Low Sleep'
           WHEN sleep_hours_per_night BETWEEN 5 AND 7 THEN 'Moderate Sleep'
		ELSE 'Healthy Sleep'
       END AS sleep_group,
   ROUND(AVG(burnout_score),2) AS avg_burnout
FROM employee_burnout
GROUP BY sleep_group;

-- Exercise Impact

SELECT CASE
            WHEN exercise_days_per_week <= 1 THEN 'Low Exercise'
            WHEN exercise_days_per_week BETWEEN 2 AND 4 THEN 'Moderate Exercise'
           ELSE 'High Exercise'
		END AS exercise_group,
      ROUND(AVG(stress_score),2) AS avg_stress
FROM employee_burnout
GROUP BY exercise_group;

-- Support vs Burnout

SELECT CASE
           WHEN manager_support_score < 4 THEN 'Low Support'
           WHEN manager_support_score BETWEEN 4 AND 7 THEN 'Moderate Support'
         ELSE 'High Support'
	   END AS support_group,
     ROUND(AVG(burnout_score), 2) AS avg_burnout
FROM employee_burnout
GROUP BY support_group;

-- Burnout Ranking

SELECT employee_id,burnout_score,
       RANK() OVER(ORDER BY burnout_score DESC) AS burnout_rank
FROM employee_burnout;

-- Country-wise Ranking

SELECT country,
       employee_id,
	   burnout_score,
       RANK() OVER(PARTITION BY country ORDER BY burnout_score DESC) AS country_rank
FROM employee_burnout;

-- High Stress Employees with CTEs

WITH high_stress AS (SELECT employee_id,
							burnout_score,
                            stress_score
     FROM employee_burnout
     WHERE stress_score > 8
     )

SELECT * FROM high_stress;

-- KPI VIEW

CREATE VIEW executive_kpis AS
SELECT
     ROUND(AVG(burnout_score),2) AS avg_burnout,
     ROUND(AVG(stress_score),2) AS avg_stress,
     ROUND(AVG(work_hours_per_week),2) AS avg_work_hours,
     ROUND(AVG(sleep_hours_per_night),2) AS avg_sleep,
     ROUND(AVG(job_change_intention) * 100, 2) AS attrition_percentage
FROM employee_burnout;

select * from executive_kpis;



