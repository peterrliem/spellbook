{{ config(
        schema = 'odos',
        alias = 'trades',
        post_hook='{{ expose_spells(\'["optimism", "ethereum", "base", "arbitrum"]\',
                                "project",
                                "odos",
                                \'["Henrystats", "amalashkevich","lequangphu"]\') }}'
        )
}}

{% set odos_models = [
  ref('odos_ethereum_trades'),
  ref('odos_optimism_trades'),
  ref('odos_arbitrum_trades'),
  ref('odos_base_trades')
] %}


SELECT *
FROM (
    {% for aggregator_model in odos_models %}
    SELECT
        blockchain,
        project,
        version,
        block_date,
        block_month,
        block_time,
        token_bought_symbol,
        token_sold_symbol,
        token_pair,
        token_bought_amount,
        token_sold_amount,
        token_bought_amount_raw,
        token_sold_amount_raw,
        amount_usd,
        token_bought_address,
        token_sold_address,
        taker,
        maker,
        project_contract_address,
        tx_hash,
        tx_from,
        tx_to,
        trace_address,
        evt_index
    FROM {{ aggregator_model }}
    {% if not loop.last %}
    UNION ALL
    {% endif %}
    {% endfor %}
);
