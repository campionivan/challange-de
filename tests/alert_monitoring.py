# tests/alert_monitoring.py
import pandas as pd

def check_system_health():
    print("Análise de logs do Provedor Omnichannel...")
    
    logs = pd.read_csv('../data/raw/logs_omnichannel.csv')
    
    deserialize_errors = logs[logs['jsonPayload.message'].str.contains('cannot be deserialized', na=False)]
    
    if len(deserialize_errors) > 0:
        print(f"ALERTA CRÍTICO: {len(deserialize_errors)} falhas de integração detectadas!")
        # Função de webhook para envio do alerta no GChat
    else:
        print("Sistema operando normalmente. Sem erros de integração.")

if __name__ == "__main__":
    check_system_health()