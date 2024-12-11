/* 1. Quantas corridas por dia tivemos neste período? Qual a média de corridas por dia e por mês? - INICIO*/

/* Quantidade de corridas por dia - INICIO */
SELECT DATE(started_at) AS dia,
       COUNT(*) quantidade_corridas
FROM at_sincrona_bd_pos_unifap_01
WHERE started_at BETWEEN '2021-11-01' AND '2022-05-01'
GROUP BY dia
ORDER BY dia;
/*Quantidade de corridas por dia - FIM*/

/* Média de corridas por dia no período de 6 meses - INICIO */
SELECT
    COUNT(*) AS total_corridas_dia_6_meses,
    ROUND(COUNT(*) / DATEDIFF('2022-05-01', '2021-11-01'), 2) AS media_corridas_dia_6_meses
FROM at_sincrona_bd_pos_unifap_01
WHERE started_at BETWEEN '2021-11-01' AND '2022-05-01';
/*Média de corridas por dia no período de 6 meses - FIM*/

/* Média de corridas mensal - INICIO */
    SELECT
        date_format(started_at, '%Y-%m') as mes,
        COUNT(*) as total_corridas,
        ROUND(COUNT(*) / COUNT(DISTINCT DATE(started_at)), 2) AS media_mensal
    FROM at_sincrona_bd_pos_unifap_01
    WHERE started_at BETWEEN '2021-11-01' AND '2022-05-01'
    GROUP BY DATE_FORMAT(started_at, '%Y-%m')
    ORDER BY mes;
/*Média de corridas mensal - FIM*/
/* 1. QUESTÃO - FIM */

/* 2. Quais foram os Top 10 dias que tivemos mais corridas? - INICIO */
SELECT
    DATE(started_at) AS dia,
    COUNT(*) AS total_corridas
FROM at_sincrona_bd_pos_unifap_01
WHERE started_at BETWEEN '2021-11-01' AND '2022-05-01'
GROUP BY DATE(started_at)
ORDER BY total_corridas DESC
LIMIT 10;
/* 2. QUESTÃO - FIM */

/* 3. E o Top 10 dias com menos corridas? - INICIO */
SELECT
    DATE(started_at) AS dia,
    COUNT(*) AS total_corridas
FROM at_sincrona_bd_pos_unifap_01
WHERE started_at BETWEEN '2021-11-01' AND '2022-05-01'
GROUP BY DATE(started_at)
ORDER BY total_corridas
LIMIT 10;
/* 3. QUESTÃO - FIM */

/* 4. Quais são os Top 5 pontos de Início? Quantas corridas cada um teve? - INICIO */
SELECT
    start_station_name AS top5_local_inicio,
    COUNT(*) AS total_corridas
FROM at_sincrona_bd_pos_unifap_01
WHERE start_station_name IS NOT NULL
GROUP BY top5_local_inicio
ORDER BY total_corridas DESC
LIMIT 5;
/* 4. QUESTÃO - FIM */

/* 5. Quais são os Top 5 pontos de Destino? Quantas corridas cada um teve?  - INICIO */
SELECT
    end_station_name AS top5_local_destino,
    COUNT(*) AS total_corridas
FROM at_sincrona_bd_pos_unifap_01
WHERE end_station_name IS NOT NULL
GROUP BY top5_local_destino
ORDER BY total_corridas DESC
LIMIT 5;
/* 5. QUESTÃO - FIM */

/* 6. Qual o tempo mínimo, médio e máximo de cada um dos Top 5 pontos de Início para o ponto de destino mais frequente de cada um? - INICIO */
WITH top_local_inicio AS (
    SELECT
        start_station_name,
        COUNT(*) AS total_corridas
    FROM at_sincrona_bd_pos_unifap_01
    WHERE start_station_name IS NOT NULL
    GROUP BY start_station_name
    ORDER BY total_corridas DESC
    LIMIT 5
),
top_destinos AS (
    SELECT
        tli.start_station_name,
        atsbd.end_station_name,
        COUNT(*) AS total_corridas,
        ROW_NUMBER() OVER (PARTITION BY tli.start_station_name ORDER BY COUNT(*) DESC ) AS rn
    FROM at_sincrona_bd_pos_unifap_01 atsbd
    JOIN top_local_inicio tli
        ON atsbd.start_station_name = tli.start_station_name
    WHERE atsbd.end_station_name IS NOT NULL
    GROUP BY tli.start_station_name, atsbd.end_station_name
),
stats AS (
    SELECT
        td.start_station_name AS top5_local_inicio,
        td.end_station_name AS top5_local_inicio_fim,
        MIN(TIMESTAMPDIFF(MINUTE, atsbd.started_at, atsbd.ended_at)) AS tempo_minimo_minutos,
        ROUND(AVG(TIMESTAMPDIFF(MINUTE, atsbd.started_at, atsbd.ended_at)), 2) AS tempo_medio_minutos,
        MAX(TIMESTAMPDIFF(MINUTE, atsbd.started_at, atsbd.ended_at)) AS tempo_maximo_minutos
    FROM at_sincrona_bd_pos_unifap_01 atsbd
    JOIN top_destinos td
        ON atsbd.start_station_name = td.start_station_name
        AND atsbd.end_station_name = td.end_station_name
    WHERE td.rn = 1
    GROUP BY td.start_station_name, td.end_station_name
)
SELECT * FROM stats
ORDER BY top5_local_inicio;
/* 6. QUESTÃO - FIM */

/* 7. Qual o tempo médio, por mês, de todas as corridas entre “Membros” e “Casuais”? - INICIO */
SELECT
    DATE_FORMAT(started_at, '%Y-%m') AS mes,
    member_casual AS tipo_usuario,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, started_at, ended_at)), 2) AS tempo_medio_minutos
FROM at_sincrona_bd_pos_unifap_01
WHERE
    started_at IS NOT NULL
    AND ended_at IS NOT NULL
    AND member_casual IN ('member', 'casual')
GROUP BY
    DATE_FORMAT(started_at, '%Y-%m'),
    member_casual
ORDER BY
    mes,
    member_casual;
/* 7. QUESTÃO - FIM */
