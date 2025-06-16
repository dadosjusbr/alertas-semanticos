select
    id_orgao,
    ano,
    mes,
    cast(
        sumario -> 'outras_remuneracoes' ->> 'total' as numeric
    ) as valor
from
    coletas c
where
    atual = true
    and (
        procinfo is null
        or procinfo :: text = 'null'
    )