# tests/check_quality_gx.py
import pandas as pd
import great_expectations as gx

def run_gx_validation():
    print("Iniciando Validação de Qualidade")
    
    df = pd.read_json('../data/raw/campanhas.json')
    
    context = gx.get_context()
    datasource = context.sources.add_pandas(name="crm_datasource")
    asset = datasource.add_dataframe_asset(name="campanhas_asset")
    validator = context.get_validator(batch_request=asset.build_batch_request(dataframe=df))

    # Teste 1: Garantir que o nome da campanha segue o padrão "crm_cerebro_*"
    validator.expect_column_values_to_match_regex("template", r"^crm_cerebro_.*")
    
    # Teste 2: Garantir que o session_id não é nulo
    validator.expect_column_values_to_not_be_null("session_id")

    results = validator.validate()
    
    if results["success"]:
        print("Dados OK: Todos os testes de qualidade foram aprovados!")
    else:
        print("Falha na qualidade: Padrão de nomenclatura divergente detectado.")

if __name__ == "__main__":
    run_gx_validation()