# Troubleshooting de Mensageria: Analytics Engineering

## O Desafio
Investigar e diagnosticar a ausência de dados de duas grandes campanhas de mensageria (Apple e Samsung) no Dashboard de acompanhamento da área de CRM. O objetivo é identificar se a raiz do problema está na construção visual do painel, na modelagem de dados ou em falhas de integração/operação.

## Diagnóstico
Após auditoria ponta a ponta no ciclo de vida do dado, constatou-se que **o Dashboard está operando corretamente**. A ausência de dados decorre de duas anomalias distintas na camada de ingestão e integração:

1. **Caso Apple (Falha de Qualidade de Dados):** O disparo ocorreu, mas o metadado foi salvo no banco de dados com nomenclatura divergente da esperada pelo painel (salvo como `apple_1003` em vez de `apple_1903`).
2. **Caso Samsung (Falha de Integração via API):** A campanha foi barrada pelo provedor de disparos (Omnichannel). O sistema do CRM enviou o botão de CTA em um formato inválido. A API rejeitou o arquivo por erro de conversão, impedindo a campanha de existir na nossa base de dados.

---

## Comunicação com a Área de Negócios

> "Bom dia, Fulano! Tudo bem?
>
> Analisando o dashboard e os dados para verificar a causa dos disparos não estarem aparecendo, verifiquei que o dashboard está funcionando normalmente, mas encontrei um problema diferente para cada campanha não estar aparecendo:
> 
> **1. Apple (19/03):** O disparo aconteceu com sucesso. Porém, por algum detalhe de preenchimento, a campanha foi salva no banco como `apple_1003` e `apple_1303` (em vez de `1903`), além de um possível cenário de reaproveitamento de campanhas anteriores para esse dia como `apple16e_natal_2025`, `apple7_natal_2025` e `crm_cerebro_ads_apple_at`. Me confirma se todos esses templates que te passei deveriam ser `crm_cerebro_ads_apple_1903` e os send types que eu já faço o ajuste aqui na base e as métricas devem aparecer no dash para você ainda hoje.
>
> **2. Samsung (20/03):** Aqui tivemos uma questão técnica de integração. Nós utilizamos um provedor que faz o intermédio entre o sistema de CRM e o envio das mensagens no Whatsapp, ele valida as mensagens antes de enviar os dados para o whatsapp e salvar os registros no nosso banco. Então analisando os logs desse provedor, vi que o botão 'Comprar Galaxy S26' foi enviado pelo sistema em um formato inválido e por isso não chegou a ser enviado para o Whatsapp do cliente e consequentemente não salvou nada no nosso banco para ser mostrado no dash.
> 
> Já estou mapeando com o time responsável pelo sistema a implementação de uma trava de segurança para garantir que o provedor sempre valide nossos botões corretamente.
>
>Fico aguardando sua confirmação sobre os nomes corretos dos templates para a campanha da Apple e qualquer outra dúvida, fico à disposição!"

---

## Proposta de prevenção
Sair do modelo reativo e implementar o modelo Data Observability, aplicando os seguintes processos:

* **Data Contracts:** Implementação de testes em ferramentas como o *dbt* ou Great Expectations diretamente na tabela de campanhas e conversas, exigindo padrões estritos em campos como `version` ou formatação específica no caso do json. Esses valores podem ser conciliados entre o que está parametrizado no sistema e o que chega na base, dessa forma, qualquer parâmetro diferente do que foi estipulado, seria alertado ao time que já atuaria em sua correção antes da área de negócio perceber.

* **Monitoramento de Logs:** Criação de alertas para identificar nos logs do provedor quando registros com `cannot be deserialized` são inseridos na base. Esses alertas seriam enviados diretamente no GChat para facilitar o monitoramento e correção mais rápida.

---

## Como navegar neste repositório
Para a área técnica e avaliadores, todo o detalhamento da engenharia, higienização de dados em memória utilizando Regex e queries simuladas no Pandas encontram-se no notebook:
- `discovery.ipynb`
Para verificar as queries em formato SQL, consulte o script:
- `discovery.sql`