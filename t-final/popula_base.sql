-- Gerar 100 registros na tabela `company`
INSERT INTO company (name)
SELECT CONCAT('Company ', LPAD(n, 3, '0'))
FROM (SELECT @rownum := @rownum + 1 AS n FROM (SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0) a,
                                              (SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0) b, (SELECT @rownum := 0) r) numbers
LIMIT 100;

-- Gerar 100 registros na tabela `knowledge_area`
INSERT INTO knowledge_area (name)
SELECT CONCAT('Knowledge Area ', LPAD(n, 3, '0'))
FROM (SELECT @rownum := @rownum + 1 AS n FROM (SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0) a,
                                              (SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0) b, (SELECT @rownum := 0) r) numbers
LIMIT 100;

-- Gerar 100 registros na tabela `nationality`
INSERT INTO nationality (country)
SELECT CONCAT('Country ', LPAD(n, 3, '0'))
FROM (SELECT @rownum := @rownum + 1 AS n FROM (SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0) a,
                                              (SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0) b, (SELECT @rownum := 0) r) numbers
LIMIT 100;

-- Gerar 100 registros na tabela `position`
INSERT INTO position (name)
SELECT CONCAT('Position ', LPAD(n, 3, '0'))
FROM (SELECT @rownum := @rownum + 1 AS n FROM (SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0) a,
                                              (SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0) b, (SELECT @rownum := 0) r) numbers
LIMIT 100;

INSERT INTO mentoring_status (name) VALUES
                                        ('Pending'),
                                        ('Ongoing'),
                                        ('Completed'),
                                        ('Cancelled');

-- Tabela `role`
INSERT INTO role (name) VALUES
                            ('Admin'),
                            ('Mentor'),
                            ('Client');

-- Gerar 100 registros na tabela `skill`, com dependência de `knowledge_area`
INSERT INTO skill (name, knowledge_area_id)
SELECT
    CONCAT('Skill ', LPAD(n, 3, '0')),
    FLOOR(1 + (RAND() * (SELECT COUNT(*) FROM knowledge_area)))
FROM (SELECT @rownum := @rownum + 1 AS n FROM
                                             (SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0) a,
                                             (SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0) b,
                                             (SELECT @rownum := 0) r) numbers
LIMIT 100;

-- Gerar 100 registros na tabela `user`, com dependência de `role` e `nationality`
INSERT INTO user (email, password, name, role_id, nationality_id, short_description, verified, created_at, updated_at)
SELECT
    CONCAT('user', LPAD(n, 3, '0'), '@example.com'),
    CONCAT('hashed_password', n),
    CONCAT('User ', LPAD(n, 3, '0')),
    FLOOR(1 + (RAND() * 3)), -- IDs de role: 1, 2, 3
    FLOOR(1 + (RAND() * (SELECT COUNT(*) FROM nationality))),
    CONCAT('Short description for User ', LPAD(n, 3, '0')),
    FLOOR(RAND() * 2), -- 0 ou 1
    NOW(),
    NOW()
FROM (SELECT @rownum := @rownum + 1 AS n FROM
                                             (SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0) a,
                                             (SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0) b,
                                             (SELECT @rownum := 0) r) numbers
LIMIT 100;

-- Gerar 100 registros na tabela `user_skill`, com dependência de `user` e `skill`
INSERT INTO user_skill (user_id, skill_id)
SELECT
    FLOOR(1 + (RAND() * (SELECT COUNT(*) FROM user))),
    FLOOR(1 + (RAND() * (SELECT COUNT(*) FROM skill)))
FROM (SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1) a,
     (SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1) b
LIMIT 100;

-- Gerar 100 registros na tabela `mentoring_plan`, com dependência de `user` (mentores)
INSERT INTO mentoring_plan (cost, mentorr_id, duration)
SELECT
    FLOOR(100 + (RAND() * 900)), -- Custos entre 100 e 1000
    id,
    CONCAT('2024-01-01 ', LPAD(FLOOR(RAND() * 5) + 1, 2, '0'), ':00:00') -- Duração aleatória entre 1 e 5 horas
FROM user
WHERE role_id = 2 -- Apenas mentores
LIMIT 100;

-- Gerar 100 registros na tabela `mentoring`, com dependência de `mentoring_plan`, `mentoring_status`, e `user`
INSERT INTO mentoring (date, mentoring_status_id, mentorr_id, client_id, mentoring_plan_id)
SELECT
    NOW() + INTERVAL FLOOR(RAND() * 100) DAY, -- Data aleatória nos próximos 100 dias
    FLOOR(1 + (RAND() * 4)), -- Status de 1 a 4
    mp.mentorr_id,
    FLOOR(1 + (RAND() * (SELECT COUNT(*) FROM user WHERE role_id = 3))), -- Cliente com role_id = 3
    mp.id
FROM mentoring_plan mp
LIMIT 600;

-- Gerar 100 registros na tabela `review`, com dependência de `mentoring`
INSERT INTO review (rating, comment, mentoring_id, created_at)
SELECT
    FLOOR(1 + (RAND() * 5)), -- Nota de 1 a 5
    CONCAT('Comment for mentoring ', id),
    id,
    NOW() - INTERVAL FLOOR(RAND() * 30) DAY -- Criado nos últimos 30 dias
FROM mentoring
LIMIT 100;

-- Gerar 100 registros na tabela `user_company`, com dependência de `user` e `company`
INSERT INTO user_company (user_id, company_id)
SELECT
    FLOOR(1 + (RAND() * 100)), -- IDs de usuários
    FLOOR(1 + (RAND() * 100)) -- IDs de empresas
FROM (SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1) a,
     (SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1) b
LIMIT 100;

-- Gerar 100 registros na tabela `user_knowledge_area`, com dependência de `user` e `knowledge_area`
INSERT INTO user_knowledge_area (user_id, knowlegde_area_id)
SELECT
    FLOOR(1 + (RAND() * 100)), -- IDs de usuários
    FLOOR(1 + (RAND() * 100)) -- IDs de áreas de conhecimento
FROM (SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1) a,
     (SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1) b
LIMIT 100;

-- Gerar 100 registros na tabela `user_position`, com dependência de `user` e `position`
INSERT INTO user_position (user_id, position_id)
SELECT
    FLOOR(1 + (RAND() * 100)), -- IDs de usuários
    FLOOR(1 + (RAND() * 100)) -- IDs de posições
FROM (SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1) a,
     (SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1) b
LIMIT 100;

select * from user;
select * from user_company;
select * from user_knowledge_area;
select * from user_position;
select * from review;
select * from mentoring;
select * from mentoring_plan;
select * from user_skill;
select * from company;
select * from knowledge_area;
select * from nationality;
select * from position;
select * from role;
select * from mentoring_status;
select * from skill;
