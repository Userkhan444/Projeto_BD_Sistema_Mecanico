
-- CONSULTA 1: Ordenar as peças por quantidade em estoque, mostrando apenas aquelas com menos de 10 unidades disponíveis.
SELECT nome, quantidade_estoque, valor_peca 
FROM mecanica.peca 
WHERE quantidade_estoque < 10 
ORDER BY quantidade_estoque ASC;

-- CONSULTA 2: Alterando o valor das peças que estão abaixo de R$ 100,00, aumentando o preço em 20%.
UPDATE mecanica.peca
SET valor_peca = valor_peca * 1.2
WHERE valor_peca < 100;

-- CONSULTA 3: Listar as Ordens de Serviço (OS) detalhando os serviços realizados, os mecânicos responsáveis e o percentual de rateio
SELECT 
    os.codigo_os, 
    s.descricao AS servico_realizado, 
    p.nome AS nome_mecanico, 
    r.percentual_rateio
FROM mecanica.ordem_servico os
INNER JOIN mecanica.item_os_servico ios ON os.codigo_os = ios.codigo_os
INNER JOIN mecanica.servico s ON ios.codigo_servico = s.codigo_servico
INNER JOIN mecanica.rateio_mecanico_servico r ON ios.id_item = r.id_item
INNER JOIN mecanica.pessoa p ON r.cpf_mecanico = p.cpf;

-- CONSULTA 4: Encontrar clientes cadastrados que não possuem nenhum veículo
SELECT 
    c.cpf_cliente, 
    p.nome AS nome_cliente, 
    v.placa
FROM mecanica.cliente c
INNER JOIN mecanica.pessoa p ON c.cpf_cliente = p.cpf
LEFT JOIN mecanica.veiculo v ON c.cpf_cliente = v.cpf_dono
WHERE v.placa IS NULL;

-- CONSULTA 5: Identificar pessoas no sistema que não têm nenhum telefone registado para contacto
SELECT 
    p.nome, 
    p.cpf, 
    t.telefone
FROM mecanica.pessoa p
LEFT JOIN mecanica.telefones t ON p.cpf = t.cpf_pessoa
WHERE t.telefone IS NULL;

/*CONSULTA 6: Listar todos os serviços do catálogo e cruzar com os itens das OS para 
encontrar os serviços que nunca foram executados.*/

SELECT 
    s.codigo_servico, 
    s.descricao AS servico_catalogo, 
    ios.codigo_os
FROM mecanica.item_os_servico ios
RIGHT JOIN mecanica.servico s ON ios.codigo_servico = s.codigo_servico
WHERE ios.codigo_os IS NULL;

/*CONSULTA 7: Listar os nomes dos clientes e as matrículas (placas) dos veículos que 
possuem pelo menos um serviço com garantia ainda ativa e não utilizada.*/

SELECT 
    p.nome AS nome_cliente, v.placa
FROM mecanica.cliente c
INNER JOIN mecanica.pessoa p ON c.cpf_cliente = p.cpf
INNER JOIN mecanica.veiculo v ON c.cpf_cliente = v.cpf_dono
WHERE EXISTS (
    SELECT 1 
    FROM mecanica.ordem_servico os
    INNER JOIN mecanica.item_os_servico ios ON os.codigo_os = ios.codigo_os
    INNER JOIN mecanica.garantia_servico g ON ios.id_item = g.id_item
    WHERE os.placa_veiculo = v.placa 
      AND g.data_fim >= CURRENT_DATE 
      AND g.utilizada = false
);

-- CONSULTA 8: Identificar os mecânicos que possuem mais de um serviço executado e rateado no seu nome.
SELECT 
    p.nome AS mecanico, 
    COUNT(r.id_item) AS total_servicos_executados
FROM mecanica.mecanico m
INNER JOIN mecanica.pessoa p ON m.cpf_mecanico = p.cpf
INNER JOIN mecanica.rateio_mecanico_servico r ON m.cpf_mecanico = r.cpf_mecanico
GROUP BY p.nome
HAVING COUNT(r.id_item) > 1;

-- CONSULTA 9: Operador EXCEPT (Atendentes que abriram OS de Manutenção, EXCETO os que abriram Venda Balcão)
SELECT cpf_atendente
FROM mecanica.ordem_servico
WHERE categoria = 'Manutencao_Veicular'

EXCEPT

SELECT cpf_atendente
FROM mecanica.ordem_servico
WHERE categoria = 'Venda_Balcao'

-- CONSULTA 10: View 5 serviços que deram mais lucro para a oficina
SELECT 
    codigo_os, 
    placa_veiculo, 
    descricao, 
    valor_total_fatura
FROM mecanica.vw_faturamento_os
ORDER BY valor_total_fatura DESC
LIMIT 5;
