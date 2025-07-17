-- Show and use the correct database
SHOW DATABASES;
USE Placement_Eligibility_App;

-- 1. Total Number of Students per Batch
SELECT 
    course_batch, 
    COUNT(*) AS student_count
FROM Students
GROUP BY course_batch
ORDER BY course_batch;

-- 2. Average Programming Score per Course Batch
SELECT 
    s.course_batch, 
    ROUND(AVG(pg.latest_project_score), 2) AS avg_project_score
FROM Students s 
JOIN Programming pg ON s.student_id = pg.student_id
GROUP BY s.course_batch
ORDER BY avg_project_score DESC;

-- 3. Certifications Earned by Batch
SELECT 
    s.course_batch,
    SUM(p.certifications_earned) AS total_certifications
FROM Students s
JOIN Programming p ON s.student_id = p.student_id
GROUP BY s.course_batch;

-- 4. Placement Status Count by Batch
SELECT 
    s.course_batch,
    pl.placement_status,
    COUNT(*) AS student_count
FROM Students s
JOIN Placement pl ON s.student_id = pl.student_id
GROUP BY s.course_batch, pl.placement_status
ORDER BY s.course_batch, pl.placement_status;

-- 5. Count of Students by Placement Status
SELECT 
    placement_status, 
    COUNT(*) AS total_students
FROM Placement
GROUP BY placement_status;

-- 6. Top 5 'Ready' Students with Highest Mock Scores
SELECT 
    s.name, s.email, pl.mock_interview_score, pl.placement_status
FROM Students s
JOIN Placement pl ON s.student_id = pl.student_id
WHERE pl.placement_status = 'Ready'
ORDER BY pl.mock_interview_score DESC
LIMIT 5;

-- 7. Students Who Cleared More Than 2 Interview Rounds
SELECT 
    s.name, 
    pl.interview_rounds_cleared, 
    pl.placement_status
FROM Students s
JOIN Placement pl ON s.student_id = pl.student_id
WHERE pl.interview_rounds_cleared > 2
ORDER BY pl.interview_rounds_cleared DESC;

-- 8. Programming Language Popularity
SELECT 
    language, 
    COUNT(*) AS student_count
FROM Programming
GROUP BY language
ORDER BY student_count DESC;

-- 9. Soft Skills Distribution (Rounded Averages)
SELECT 
    ROUND((
        ss.communication + ss.teamwork + ss.presentation + 
        ss.leadership + ss.critical_thinking + ss.interpersonal_skills
    ) / 6, 0) AS avg_soft_skill,
    COUNT(*) AS student_count
FROM SoftSkills ss
GROUP BY avg_soft_skill
ORDER BY avg_soft_skill DESC;

-- 10. Average Project Score by Placement Status
SELECT 
    pl.placement_status,
    ROUND(AVG(p.latest_project_score), 2) AS avg_project_score
FROM Placement pl
JOIN Programming p ON pl.student_id = p.student_id
GROUP BY pl.placement_status
ORDER BY avg_project_score DESC;