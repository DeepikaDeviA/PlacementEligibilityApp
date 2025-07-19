-- Show and use the correct database
SHOW DATABASES;
USE Placement_Eligibility_App;

-- 1. Which course has the highest student enrollment?
SELECT 
    course_batch, 
    COUNT(*) AS student_count
FROM Students
GROUP BY course_batch
ORDER BY student_count DESC
LIMIT 1;
-- Insight -> The course AI-S-WE-N-B07 has the highest enrollment with 38 students.


-- 2. Which course batches have the highest average programming project score?
SELECT 
    s.course_batch, 
    ROUND(AVG(pg.latest_project_score), 2) AS avg_project_score
FROM Students s 
JOIN Programming pg ON s.student_id = pg.student_id
GROUP BY s.course_batch
ORDER BY avg_project_score DESC;

-- Insights -> The course batch AI-S-WE-N-B05 has the highest average programming project score of 79.43, followed by DS-S-WE-N-B03 (79.31) and FSD-S-WD-N-B10 (77.91). These batches demonstrate strong programming performance overall.

-- 3. What are the top courses by total certifications earned?
SELECT 
    s.course_batch,
    SUM(p.certifications_earned) AS total_certifications
FROM Students s
JOIN Programming p ON s.student_id = p.student_id
GROUP BY s.course_batch
ORDER BY total_certifications DESC
LIMIT 3;

-- Insights -> The course batch AI-S-WE-N-B07 had the highest total certifications earned with 65, suggesting active participation in extra learning modules.

-- 4. Which course batches have the highest number of placed students?
SELECT 
    s.course_batch,
    COUNT(*) AS placed_students
FROM Students s
JOIN Placement pl ON s.student_id = pl.student_id
WHERE pl.placement_status = 'Placed'
GROUP BY s.course_batch
ORDER BY placed_students DESC
LIMIT 3;

-- Insights -> The batch FSD-S-WD-N-B12 had the highest number of placed students (16), followed by FSD-S-WD-N-B10 (15) and AI-S-WE-N-B07 (14), indicating strong placement readiness in these batches.

-- 5. How are students distributed across different placement statuses?
SELECT 
    placement_status, 
    COUNT(*) AS total_students
FROM Placement
GROUP BY placement_status;

-- insights -> Out of 500 students, 170 are 'Placed', 152 as 'Ready', and 178 as 'Not Ready'. This indicates that while a good number of students are nearing placement readiness, a significant portion still requires support and intervention to become placement eligible.

-- 6. Who are the top 5 ‘Ready’ students with the highest mock interview scores?
SELECT 
    s.name, s.email, pl.mock_interview_score, pl.placement_status
FROM Students s
JOIN Placement pl ON s.student_id = pl.student_id
WHERE pl.placement_status = 'Ready'
ORDER BY pl.mock_interview_score DESC
LIMIT 5;

-- Insights -> The top 5 ‘Ready’ students based on mock interview scores are Vasatika More, Kabir Sachar, Ijaya Talwar, Hitesh Sinha, and Abhiram Rajan. These candidates have demonstrated strong interview preparedness and are ideal for upcoming placement opportunities.

-- 7. Among students who cleared more than 2 interview rounds, how many were placed or ready for placement?
SELECT 
    placement_status,
    COUNT(*) AS student_count
FROM Placement
WHERE interview_rounds_cleared > 2
    AND placement_status IN ('Placed', 'Ready')
GROUP BY placement_status;

-- Insights ->   A total of 170 students were placed and 48 students are ready for placement among those who cleared more than two interview rounds.This indicates that clearing multiple interview rounds significantly increases a student's chances of being placed.

-- 8. Which programming language is most popular among students based on enrollment?
SELECT 
    language, 
    COUNT(*) AS student_count
FROM Programming
GROUP BY language
ORDER BY student_count DESC;

-- Insights -> Python is the top choice among students with 94 learners, followed by R and Java, showing strong interest in popular programming languages.

-- 9. What is the distribution of students by average soft skill score?
SELECT
  CASE
    WHEN soft_skill_avg BETWEEN 75 AND 100 THEN 'High'
    WHEN soft_skill_avg BETWEEN 50 AND 74 THEN 'Medium'
    ELSE 'Low'
  END AS skill_level,
  COUNT(*) AS student_count
FROM SoftSkills
GROUP BY skill_level
ORDER BY skill_level DESC;
-- insights -> The majority of students have Medium (152) or Low (178) soft skill scores, while only 170 students fall into the High category.

-- 10. What is the average programming project score for each placement status?
SELECT 
    pl.placement_status,
    ROUND(AVG(p.latest_project_score), 2) AS avg_project_score
FROM Placement pl
JOIN Programming p ON pl.student_id = p.student_id
GROUP BY pl.placement_status
ORDER BY avg_project_score DESC;

-- insights -> Students who are Placed have the highest average project score of 92.30, followed by Ready students at 77.14, while Not Ready students have the lowest at 54.24, highlighting a strong link between project performance and placement status.

-- 11. How is placement status distributed across genders?

SELECT 
    s.gender,
    pl.placement_status,
    COUNT(*) AS student_count
FROM Students s
JOIN Placement pl ON s.student_id = pl.student_id
GROUP BY s.gender, pl.placement_status
ORDER BY s.gender, pl.placement_status;

-- insights -> Female students have an even spread across all placement statuses, while more male students are not ready for placement compared to those who are ready.