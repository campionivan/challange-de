-- models/marts/fct_disparos.sql
WITH campanhas AS (
    SELECT * FROM {{ ref('stg_campanhas') }}
),
conversas AS (
    SELECT * FROM read_json_auto('../data/trusted/conversas.json')
)

SELECT 
    c.session_id,
    c.nm_template,
    c.nr_versao,
    c.dt_publicacao,
    c.dta_referencia,
    CASE WHEN v.message_id IS NOT NULL THEN 1 ELSE 0 END as fl_disparo_sucesso,
    v.message_id
FROM campanhas c
LEFT JOIN conversas v ON c.session_id = v.session_id