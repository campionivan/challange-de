-- 1. Criando View das Campanhas (Dimensão)
CREATE OR REPLACE VIEW campanhas AS 
SELECT * FROM read_json('../challange-de/data/raw/campanhas.json');

-- 2. Criando View das Conversas Higienizadas (Fato)
CREATE OR REPLACE VIEW conversas AS 
SELECT * FROM read_json('../challange-de/data/trusted/conversas.json');

CREATE OR REPLACE VIEW logs AS 
SELECT * FROM read_csv('../challange-de/data/raw/logs_omnichannel.csv');

-- Validação do Dashboard
SELECT 
    c.template,
    COUNT(v.message_id) as total_disparos
FROM campanhas c
LEFT JOIN conversas v ON c.session_id = v.session_id
WHERE CAST(c.publish_time AS DATE) IN ('2026-03-19', '2026-03-20')
  AND c.template IN ('crm_cerebro_ads_apple_1903', 'crm_cerebro_galaxys26')
GROUP BY 1;

-- Investigação Apple (TYPO)
SELECT 
    template,
    version,
    publish_time,
    session_id
FROM campanhas
WHERE (template ILIKE '%apple%')
  AND CAST(publish_time AS DATE) = '2026-03-19';

-- Investigação Samsung (LOGS)
SELECT 
    "jsonPayload.message",
    COUNT(*) as qtd_erros,
    MIN(timestamp) as primeiro_registro,
    MAX(timestamp) as ultimo_registro
FROM logs
WHERE CAST(regexp_extract(timestamp, '\d{4}-\d{2}-\d{2}') AS DATE) BETWEEN '2026-03-20' AND '2026-03-21'
  AND "jsonPayload.message" ILIKE '%Galaxy S26%'
GROUP BY 1;