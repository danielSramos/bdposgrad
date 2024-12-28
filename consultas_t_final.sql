#Consultas Simples
SELECT id, name, email FROM user;

SELECT id, name, email
FROM user
WHERE role_id = (SELECT id FROM role WHERE name = 'Mentor');

SELECT id, name
FROM company;

SELECT * FROM mentoring_status;

SELECT COUNT(*) AS total_users
FROM user;

#Consultas Mais Complexas
#Q1
SELECT
    m.id AS mentoring_id,
    mentor.name AS mentor_name,
    client.name AS client_name,
    ms.name AS status
FROM mentoring m
         JOIN user mentor ON m.mentorr_id = mentor.id
         JOIN user client ON m.client_id = client.id
         JOIN mentoring_status ms ON m.mentoring_status_id = ms.id;

#Q2
SELECT
    u.name AS user_name,
    c.name AS company_name
FROM user_company uc
         JOIN user u ON uc.user_id = u.id
         JOIN company c ON uc.company_id = c.id;

#Q3
SELECT
    ka.name AS knowledge_area,
    u.name AS user_name
FROM user_knowledge_area uka
         JOIN user u ON uka.user_id = u.id
         JOIN knowledge_area ka ON uka.knowlegde_area_id = ka.id;

#Q4
SELECT
    ms.name AS status,
    COUNT(m.id) AS total_mentorships
FROM mentoring m
         JOIN mentoring_status ms ON m.mentoring_status_id = ms.id
GROUP BY ms.name;

#Q5
SELECT
    u.name AS mentor_name,
    s.name AS skill_name
FROM user u
         JOIN user_skill us ON u.id = us.user_id
         JOIN skill s ON us.skill_id = s.id
WHERE u.role_id = (SELECT id FROM role WHERE name = 'Mentor');

#Q6
SELECT
    m.id AS mentoring_id,
    mp.cost AS plan_cost,
    mentor.name AS mentor_name,
    client.name AS client_name
FROM mentoring m
         JOIN mentoring_plan mp ON m.mentoring_plan_id = mp.id
         JOIN user mentor ON m.mentorr_id = mentor.id
         JOIN user client ON m.client_id = client.id
WHERE mp.cost > 200;

#Q7
SELECT
    p.name AS position_name,
    COUNT(up.user_id) AS total_users
FROM user_position up
         JOIN position p ON up.position_id = p.id
GROUP BY p.name;

#Q8
SELECT
    r.rating,
    r.comment,
    mentor.name AS mentor_name,
    client.name AS client_name
FROM review r
         JOIN mentoring m ON r.mentoring_id = m.id
         JOIN user mentor ON m.mentorr_id = mentor.id
         JOIN user client ON m.client_id = client.id;

#Consultas Avançadas com Filtragem e Ordenação
#QF1
SELECT
    m.id AS mentoring_id,
    mentor.name AS mentor_name,
    client.name AS client_name,
    m.date
FROM mentoring m
         JOIN user mentor ON m.mentorr_id = mentor.id
         JOIN user client ON m.client_id = client.id
WHERE m.mentoring_status_id = (SELECT id FROM mentoring_status WHERE name = 'Completed')
ORDER BY m.date DESC;

#QF2
SELECT
    mentor.name AS mentor_name,
    COUNT(m.id) AS total_mentorships
FROM mentoring m
         JOIN user mentor ON m.mentorr_id = mentor.id
GROUP BY mentor.name
ORDER BY total_mentorships DESC
LIMIT 1;

#QF3
SELECT
    SUM(mp.cost) AS total_revenue
FROM mentoring m
         JOIN mentoring_plan mp ON m.mentoring_plan_id = mp.id;

#QF4
SELECT
    u.name AS user_name,
    n.country AS nationality
FROM user u
         JOIN nationality n ON u.nationality_id = n.id
WHERE u.verified = 0
ORDER BY n.country, u.name;

#QF5
SELECT
    m.id AS mentoring_id,
    ms.name AS status,
    client.name AS client_name,
    m.date AS mentoring_date
FROM mentoring m
         JOIN user mentor ON m.mentorr_id = mentor.id
         JOIN user client ON m.client_id = client.id
         JOIN mentoring_status ms ON m.mentoring_status_id = ms.id
WHERE mentor.name = 'User 001'
ORDER BY m.date ASC;

SELECT * FROM mentoring;
