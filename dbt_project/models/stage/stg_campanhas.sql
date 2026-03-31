SELECT 
    session_id,
    template as nm_template,
    version as nr_versao,
    CAST(publish_time AS TIMESTAMP) as dt_publicacao,
    CAST(publish_time AS DATE) as dta_referencia
FROM read_json_auto('../data/raw/campanhas.json')