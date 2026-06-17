-- Consulta 1 — Seleção Simples: Catálogo de Serviços com Garantia

-- Lista todos os serviços disponíveis com seus parâmetros de garantia, ordenados pelo valor.

SELECT
    v.placa,
    v.marca,
    v.modelo,
    v.ano,
    v.cor,
    p.nome AS proprietario
FROM mecanica.veiculo v
INNER JOIN mecanica.cliente c ON c.cpf_cliente = v.cpf_dono
INNER JOIN mecanica.pessoa  p ON p.cpf         = c.cpf_cliente
ORDER BY p.nome;

-- Consulta 2 — INNER JOIN: Veículos e seus Proprietários

-- Retorna todos os veículos cadastrados com o nome do cliente dono.

SELECT
    v.placa,
    v.marca,
    v.modelo,
    v.ano,
    v.cor,
    p.nome AS proprietario
FROM mecanica.veiculo v
INNER JOIN mecanica.cliente c ON c.cpf_cliente = v.cpf_dono
INNER JOIN mecanica.pessoa  p ON p.cpf         = c.cpf_cliente
ORDER BY p.nome;

-- Consulta 3 — LEFT JOIN: Clientes sem Veículo

-- Exibe todos os clientes, incluindo os que não possuem nenhum veículo cadastrado.

SELECT
    p.nome       AS cliente,
    p.email,
    v.placa,
    v.modelo
FROM mecanica.cliente c
INNER JOIN mecanica.pessoa  p ON p.cpf     = c.cpf_cliente
LEFT  JOIN mecanica.veiculo v ON v.cpf_dono = c.cpf_cliente
ORDER BY v.placa NULLS LAST;

-- Consulta 4 — RIGHT JOIN: Serviços Nunca Executados

-- Identifica serviços do catálogo que ainda não foram aplicados em nenhuma OS.

SELECT
    s.codigo_servico,
        s.descricao,
            s.valor,
                i.codigo_os
                FROM mecanica.item_os_servico i
                RIGHT JOIN mecanica.servico s ON s.codigo_servico = i.codigo_servico
                WHERE i.id_item IS NULL
                ORDER BY s.valor DESC;

-- Consulta 5 — GROUP BY e HAVING: Faturamento por Atendente

-- Agrupa o total faturado por atendente, exibindo apenas os que ultrapassaram R$ 300,00 em OS finalizadas.

SELECT
    p.nome        AS atendente,
    COUNT(os.codigo_os)         AS total_os,
    SUM(f.valor_total_fatura)   AS faturamento_total
FROM mecanica.ordem_servico os
INNER JOIN mecanica.atendente      a ON a.cpf_atendente = os.cpf_atendente
INNER JOIN mecanica.pessoa         p ON p.cpf           = a.cpf_atendente
INNER JOIN mecanica.vw_faturamento_os f ON f.codigo_os  = os.codigo_os
WHERE os.status_os = 'Finalizado'
GROUP BY p.nome
HAVING SUM(f.valor_total_fatura) > 300
ORDER BY faturamento_total DESC;

-- Consulta 6 — Subconsulta Não Correlacionada: OS acima da Média

-- Lista todas as OS cujo faturamento supera a média geral de todas as OS.

SELECT
    f.codigo_os,
    f.descricao,
    f.status_os,
    f.valor_total_fatura
FROM mecanica.vw_faturamento_os f
WHERE f.valor_total_fatura > (
    SELECT AVG(valor_total_fatura)
    FROM mecanica.vw_faturamento_os
)
ORDER BY f.valor_total_fatura DESC;

-- Consulta 7 — Subconsulta Correlacionada: Mecânicos com mais de um Serviço

-- Retorna mecânicos que executaram serviços em mais de uma OS distinta.

SELECT
    p.nome        AS mecanico,
    f.salario_base,
    (
        SELECT COUNT(DISTINCT i.codigo_os)
        FROM mecanica.rateio_mecanico_servico r
        INNER JOIN mecanica.item_os_servico   i ON i.id_item = r.id_item
        WHERE r.cpf_mecanico = m.cpf_mecanico
    ) AS total_os_atendidas
FROM mecanica.mecanico    m
INNER JOIN mecanica.funcionario f ON f.cpf_funcionario = m.cpf_mecanico
INNER JOIN mecanica.pessoa      p ON p.cpf             = m.cpf_mecanico
WHERE (
    SELECT COUNT(DISTINCT i.codigo_os)
    FROM mecanica.rateio_mecanico_servico r
    INNER JOIN mecanica.item_os_servico   i ON i.id_item = r.id_item
    WHERE r.cpf_mecanico = m.cpf_mecanico
) > 1
ORDER BY total_os_atendidas DESC;

-- Consulta 8 — Operador de Conjunto INTERSECT: Clientes com Veículo e OS Finalizada

-- Retorna apenas os clientes que possuem veículo cadastrado E têm ao menos uma OS finalizada — interseção real de dois conjuntos.

SELECT cpf_cliente AS cpf
FROM mecanica.cliente c
INNER JOIN mecanica.veiculo v ON v.cpf_dono = c.cpf_cliente

INTERSECT

SELECT c.cpf_cliente AS cpf
FROM mecanica.ordem_servico os
INNER JOIN mecanica.veiculo v ON v.placa = os.placa_veiculo
INNER JOIN mecanica.cliente c ON c.cpf_cliente = v.cpf_dono
WHERE os.status_os = 'Finalizado';

-- Consulta 9 — Operador de Conjunto EXCEPT: Peças Nunca Solicitadas para Compra

-- Identifica peças do estoque que nunca geraram uma solicitação de compra.

SELECT codigo_peca, nome
FROM mecanica.peca

EXCEPT

SELECT p.codigo_peca, p.nome
FROM mecanica.peca p
INNER JOIN mecanica.solicitacao_compra sc ON sc.peca_solicitada = p.codigo_peca;

-- Consulta 10 — View + JOIN: Garantias Ativas por Veículo

-- Usa a view de faturamento combinada com os dados de garantia para exibir o histórico completo de cobertura ativa por veículo.

SELECT
    v.placa,
    v.modelo,
    p.nome          AS proprietario,
    s.descricao     AS servico,
    g.data_inicio,
    g.data_fim,
    g.km_inicio,
    g.km_fim,
    g.utilizada,
    f.valor_total_fatura AS valor_os
FROM mecanica.garantia_servico    g
INNER JOIN mecanica.item_os_servico   i  ON i.id_item      = g.id_item
INNER JOIN mecanica.servico           s  ON s.codigo_servico= i.codigo_servico
INNER JOIN mecanica.ordem_servico     os ON os.codigo_os   = i.codigo_os
INNER JOIN mecanica.veiculo           v  ON v.placa        = os.placa_veiculo
INNER JOIN mecanica.cliente           c  ON c.cpf_cliente  = v.cpf_dono
INNER JOIN mecanica.pessoa            p  ON p.cpf          = c.cpf_cliente
INNER JOIN mecanica.vw_faturamento_os f  ON f.codigo_os    = os.codigo_os
WHERE g.utilizada = false
  AND g.data_fim >= CURRENT_DATE
ORDER BY g.data_fim;

