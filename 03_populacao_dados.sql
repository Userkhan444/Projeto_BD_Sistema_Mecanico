-- ============================================================
-- POPULAÇÃO DO BANCO DE DADOS — SISTEMA MECÂNICA
-- ============================================================


-- ============================================================
-- 1. ESTADO (5 Tuplas)
-- ============================================================
INSERT INTO mecanica.estado (sigla, nome) VALUES
('AL', 'Alagoas'),
('PE', 'Pernambuco'),
('SE', 'Sergipe'),
('BA', 'Bahia'),
('SP', 'São Paulo');


-- ============================================================
-- 2. CIDADE (5 Tuplas)
-- ============================================================
INSERT INTO mecanica.cidade (nome, id_estado) VALUES
('Arapiraca', 1),
('Maceió',    1),
('Caruaru',   2),
('Aracaju',   3),
('Salvador',  4);


-- ============================================================
-- 3. PESSOA (16 Tuplas)
-- Contém clientes, 5 atendentes e 5 mecânicos.
-- ============================================================
INSERT INTO mecanica.pessoa (cpf, nome, email, logradouro, numero, bairro, cep, id_cidade) VALUES
-- Atendentes
('11111111111', 'Carlos Augusto',  'carlos.atend@gmail.com',     'Rua XV de Novembro',      '100',  'Centro',           '57300010', 1),
('22222222222', 'Mariana Costa',   'mariana.atend@hotmail.com',  'Av. Venturosa',           '45B',  'Eldorado',         '57304120', 1),
('33333333333', 'Roberto Almeida', 'roberto.atend@yahoo.com',    'Rua São Francisco',       '890',  'Caititus',         '57312050', 1),
('10101010101', 'Juliana Torres',  'juliana.atend@gmail.com',    'Rua Nova',                '12',   'Centro',           '57300000', 1),
('20202020202', 'Ricardo Mendes',  'ricardo.atend@hotmail.com',  'Av. Brasil',              '99',   'Canaã',            '57300001', 1),
-- Mecânicos
('44444444444', 'José Silva',      'ze.mecanico@gmail.com',      'Rua Delmiro Gouveia',     '12',   'Brasília',         '57301000', 1),
('55555555555', 'Lucas Santos',    'lucas.mecanico@outlook.com', 'Av. Deputada Ceci Cunha', '700',  'Alto do Cruzeiro', '57318000', 1),
('66666666666', 'Marcos Oliveira', 'marcos.mecanico@gmail.com',  'Rua Santa Rita',          '33',   'Baixão',           '57305200', 1),
('77777777777', 'André Souza',     'andre.mecanico@hotmail.com', 'Rua Pedro II',            '104',  'Centro',           '57020000', 2),
('30303030303', 'Fábio Júnior',    'fabio.mecanico@yahoo.com',   'Rua do Sol',              '55',   'Eldorado',         '57300002', 1),
-- Clientes
('88888888888', 'Arthur Pendragon','arthur.cliente@gmail.com',   'Av. Fernandes Lima',      '2000', 'Farol',            '57050000', 2),
('99999999999', 'Beatriz Silva',   'beatriz.cliente@hotmail.com','Rua Agapito Magalhães',   '44',   'Ouro Preto',       '57306010', 1),
('00000000000', 'Claudio Duarte',  'claudio.cliente@yahoo.com',  'Rua São João',            '501',  'Canaã',            '57314100', 1),
('12345678901', 'Diana Prince',    'diana.cliente@gmail.com',    'Rua Rui Barbosa',         '99',   'Centro',           '55000000', 3),
('98765432109', 'Eduardo Ramos',   'eduardo.cliente@outlook.com','Av. Hermes Fontes',       '1230', 'Suíssa',           '49000000', 4),
-- Cliente sem OS e sem veículo — para demonstrar LEFT JOIN
('10293847560', 'Fernanda Lins',   'fernanda.semOS@gmail.com',   'Rua das Flores',          '77',   'Centro',           '57300100', 1);


-- ============================================================
-- 4. TELEFONES (14 Tuplas)
-- Eduardo e Fernanda sem telefone — reforça LEFT JOIN
-- ============================================================
INSERT INTO mecanica.telefones (cpf_pessoa, telefone) VALUES
('11111111111', '82999990001'),
('22222222222', '82999990002'),
('33333333333', '82999990003'),
('10101010101', '82999990010'),
('20202020202', '82999990020'),
('44444444444', '82999990004'),
('55555555555', '82999990005'),
('66666666666', '82999990006'),
('77777777777', '82988881111'),
('30303030303', '82999990030'),
('88888888888', '82988882222'),
('99999999999', '82988883333'),
('00000000000', '82988884444'),
('12345678901', '81999887766');


-- ============================================================
-- 5. FUNCIONÁRIO (10 Tuplas)
-- ============================================================
INSERT INTO mecanica.funcionario (cpf_funcionario, salario_base) VALUES
('11111111111', 1600.00),
('22222222222', 1650.00),
('33333333333', 1600.00),
('10101010101', 1600.00),
('20202020202', 1600.00),
('44444444444', 3500.00),
('55555555555', 2400.00),
('66666666666', 2200.00),
('77777777777', 2300.00),
('30303030303', 2200.00);


-- ============================================================
-- 6. ATENDENTE (5 Tuplas)
-- ============================================================
INSERT INTO mecanica.atendente (cpf_atendente) VALUES
('11111111111'),
('22222222222'),
('33333333333'),
('10101010101'),
('20202020202');


-- ============================================================
-- 7. MECÂNICO (5 Tuplas)
-- ============================================================
INSERT INTO mecanica.mecanico (cpf_mecanico) VALUES
('44444444444'),
('55555555555'),
('66666666666'),
('77777777777'),
('30303030303');


-- ============================================================
-- 8. CLIENTE (6 Tuplas)
-- ============================================================
INSERT INTO mecanica.cliente (cpf_cliente) VALUES
('88888888888'),
('99999999999'),
('00000000000'),
('12345678901'),
('98765432109'),
('10293847560');  -- Fernanda: sem veículo e sem OS — LEFT JOIN


-- ============================================================
-- 9. VEÍCULO (5 Tuplas)
-- Fernanda não tem veículo — reforça LEFT JOIN
-- ============================================================
INSERT INTO mecanica.veiculo (placa, marca, ano, cor, tipo_combustivel, cpf_dono, modelo) VALUES
('MUV1A23', 'Honda',      2019, 'Cinza',    'Flex',   '88888888888', 'Civic EXL'),
('NLZ4X56', 'Toyota',     2021, 'Branco',   'Flex',   '99999999999', 'Corolla XEI'),
('ORD9Y88', 'Chevrolet',  2015, 'Preto',    'Flex',   '00000000000', 'Onix LTZ'),
('KGT2B11', 'Volkswagen', 2018, 'Vermelho', 'Flex',   '12345678901', 'Gol Trendline'),
('OHH7Z99', 'Ford',       2013, 'Prata',    'Diesel', '98765432109', 'Ranger XLS');


-- ============================================================
-- 10. PEÇA (5 Tuplas)
-- ============================================================
INSERT INTO mecanica.peca (nome, quantidade_estoque, valor_peca) VALUES
('Filtro de Óleo Fram',             45,  35.00),
('Pastilha de Freio Bosch',         20, 120.00),
('Correia Dentada Gates',           15,  85.00),
('Óleo Lubrificante Shell 5W30 L', 150,  42.00),
('Palheta Limpador Dyna',            8,  55.00);


-- ============================================================
-- 11. SERVIÇO (7 Tuplas)
-- Serviços 6 e 7 nunca executados — para RIGHT JOIN
-- garantia_dias/km = 0 significa sem garantia
-- ============================================================
INSERT INTO mecanica.servico (descricao, valor, tempo_estimado_horas, garantia_dias, garantia_km) VALUES
('Troca de Óleo e Filtros',             60.00, 1,  90,  3000),
('Revisão Geral do Sistema de Freios', 150.00, 3, 120,  5000),
('Alinhamento e Balanceamento 3D',      90.00, 2,  30,  1000),
('Substituição de Correia Dentada',    250.00, 4, 180, 10000),
('Diagnóstico de Injeção Eletrônica',  120.00, 2,  90,  3000),
('Higienização Interna Completa',       80.00, 1,   0,     0),  -- Nunca executado
('Polimento Externo Automotivo',       200.00, 3,   0,     0);  -- Nunca executado


-- ============================================================
-- 12. ORDEM DE SERVIÇO (10 Tuplas)
-- Distribuídas entre todos os 5 atendentes.
-- Sem coluna valor_total — valor calculado pela view.
-- ============================================================
INSERT INTO mecanica.ordem_servico
    (descricao, data_fechamento, data_estimada, quilometragem,
     categoria, prioridade, data_abertura, status_os,
     cpf_atendente, placa_veiculo)
VALUES
('Revisão preventiva periódica',           '2026-05-12', '2026-05-12',  45000, 'Manutencao_Veicular', 'Normal',  '2026-05-10', 'Finalizado',      '11111111111', 'MUV1A23'),
('Troca urgente pastilha freio dianteiro', '2026-05-15', '2026-05-14',  89000, 'Manutencao_Veicular', 'Alta',    '2026-05-14', 'Finalizado',      '22222222222', 'NLZ4X56'),
('Venda direta balcão de palhetas',        '2026-05-15', '2026-05-15',   NULL, 'Venda_Balcao',        'Baixa',   '2026-05-15', 'Finalizado',      '33333333333',  NULL),
('Barulho estranho motor ao ligar',         NULL,        '2026-06-03', 105000, 'Manutencao_Veicular', 'Urgente', '2026-06-01', 'Em_Andamento',    '10101010101', 'ORD9Y88'),
('Venda direta balcão óleo de motor',      '2026-05-18', '2026-05-18',   NULL, 'Venda_Balcao',        'Baixa',   '2026-05-18', 'Finalizado',      '20202020202',  NULL),
('Troca kit correia e alinhamento',        '2026-05-25', '2026-05-26',  62000, 'Manutencao_Veicular', 'Normal',  '2026-05-24', 'Finalizado',      '11111111111', 'KGT2B11'),
('Revisão suspensão e freio',               NULL,        '2026-06-05', 155000, 'Manutencao_Veicular', 'Alta',    '2026-06-01', 'Aguardando_Peca', '10101010101', 'OHH7Z99'),
('Venda balcão filtro e óleo',             '2026-05-26', '2026-05-26',   NULL, 'Venda_Balcao',        'Baixa',   '2026-05-26', 'Finalizado',      '20202020202',  NULL),
('Retorno garantia — trepidação no freio', NULL,        '2026-06-04',  89200, 'Manutencao_Veicular', 'Alta',    '2026-06-02', 'Em_Andamento',    '33333333333', 'NLZ4X56'),
('Troca de óleo rápida de rotina',         '2026-05-30', '2026-05-30',  47500, 'Manutencao_Veicular', 'Normal',  '2026-05-30', 'Finalizado',      '22222222222', 'MUV1A23');


-- ============================================================
-- 13. ITEM OS SERVIÇO (13 Tuplas)
-- Adicionados serviços 11, 12 e 13 para garantir que as
-- garantias sejam atreladas apenas a OS Finalizadas.
-- ============================================================
INSERT INTO mecanica.item_os_servico (codigo_os, codigo_servico, valor_cobrado) VALUES
(1,  1,  60.00),   -- id_item 1:  OS 1  — Troca de Óleo
(1,  3,  90.00),   -- id_item 2:  OS 1  — Alinhamento
(2,  2, 150.00),   -- id_item 3:  OS 2  — Revisão Freio
(4,  5, 120.00),   -- id_item 4:  OS 4  — Diagnóstico Injeção
(6,  4, 250.00),   -- id_item 5:  OS 6  — Substituição Correia
(6,  3,  90.00),   -- id_item 6:  OS 6  — Alinhamento
(7,  2, 120.00),   -- id_item 7:  OS 7  — Revisão Freio (promocional)
(9,  2, 150.00),   -- id_item 8:  OS 9  — Freio retorno garantia
(10, 1,  60.00),   -- id_item 9:  OS 10 — Troca de Óleo
(10, 3,  90.00),   -- id_item 10: OS 10 — Alinhamento
(1,  5, 120.00),   -- id_item 11: OS 1  — Diagnóstico Injeção
(2,  3,  90.00),   -- id_item 12: OS 2  — Alinhamento
(6,  2, 150.00);   -- id_item 13: OS 6  — Revisão Freio


-- ============================================================
-- 14. ORDEM SERVIÇO PEÇA (10 Tuplas)
-- ============================================================
INSERT INTO mecanica.ordem_servico_peca
    (codigo_os, codigo_peca, quantidade_requisitada, valor_unitario_cobrado)
VALUES
(1,  4, 4,  11.00),   -- OS 1:  4 L óleo (preço negociado)
(1,  1, 1,   9.00),   -- OS 1:  1 filtro óleo (preço negociado)
(2,  2, 1, 120.00),   -- OS 2:  1 par pastilhas
(3,  5, 2,  55.00),   -- OS 3:  2 palhetas — Venda Balcão
(4,  4, 4,  42.00),   -- OS 4:  4 L óleo
(4,  1, 1,  35.00),   -- OS 4:  1 filtro óleo
(5,  4, 4,  42.00),   -- OS 5:  4 L óleo — Venda Balcão
(6,  3, 1,  85.00),   -- OS 6:  1 correia dentada
(8,  4, 4,  42.00),   -- OS 8:  4 L óleo — Venda Balcão
(10, 4, 4,  19.50);   -- OS 10: 4 L óleo (preço atacado)


-- ============================================================
-- 15. RATEIO MECÂNICO SERVIÇO (14 Tuplas)
-- Soma de percentual_rateio por id_item = 100% sempre.
-- ============================================================
INSERT INTO mecanica.rateio_mecanico_servico (id_item, cpf_mecanico, percentual_rateio) VALUES
(1,  '44444444444', 100.00),  -- José: Troca Óleo OS 1
(2,  '55555555555', 100.00),  -- Lucas: Alinhamento OS 1
(3,  '44444444444',  50.00),  -- José 50%: Revisão Freio OS 2
(3,  '66666666666',  50.00),  -- Marcos 50%: Revisão Freio OS 2 — equipe dividida
(4,  '77777777777', 100.00),  -- André: Diagnóstico OS 4
(5,  '30303030303', 100.00),  -- Fábio: Correia OS 6
(6,  '55555555555', 100.00),  -- Lucas: Alinhamento OS 6
(7,  '30303030303', 100.00),  -- Fábio: Freio OS 7
(8,  '66666666666', 100.00),  -- Marcos: Freio retorno OS 9
(9,  '44444444444', 100.00),  -- José: Troca Óleo OS 10
(10, '77777777777', 100.00),  -- André: Alinhamento OS 10
(11, '44444444444', 100.00),  -- José: Diagnóstico OS 1
(12, '55555555555', 100.00),  -- Lucas: Alinhamento OS 2
(13, '30303030303', 100.00);  -- Fábio: Revisão Freio OS 6


-- ============================================================
-- 16. ORDEM DE PAGAMENTO (10 Tuplas)
-- Matemática reajustada com a inclusão dos novos serviços:
--   OS 1: 323.00 (Serviços: 60+90+120 | Peças: 53) ✓
--   OS 2: 360.00 (Serviços: 150+90 | Peças: 120) ✓
--   OS 6: 575.00 (Serviços: 250+90+150 | Peças: 85) ✓
-- ============================================================
INSERT INTO mecanica.ordem_pagamento
    (status_pagamento, tipo_pagamento, valor_pago, data_pagamento, codigo_os)
VALUES
('Pago',    'Pix',           323.00, '2026-05-12', 1),
('Pago',    'Cartao_Credito',360.00, '2026-05-15', 2),
('Pago',    'Dinheiro',      110.00, '2026-05-15', 3),
('Parcial', 'Pix',           100.00, '2026-06-01', 4),   -- 1º adiantamento
('Pago',    'Pix',           168.00, '2026-05-18', 5),
('Pago',    'Cartao_Debito', 575.00, '2026-05-25', 6),
('Parcial', 'Pix',            50.00, '2026-06-01', 7),   -- Sinal suspensão
('Pago',    'Boleto',        168.00, '2026-05-26', 8),
('Pago',    'Cartao_Credito',228.00, '2026-05-30', 10),
('Parcial', 'Dinheiro',      150.00, '2026-06-03', 4);   -- 2º pagamento motor


-- ============================================================
-- 17. GARANTIA SERVIÇO (10 Tuplas)
-- GARANTIAS ATRELADAS APENAS A OS FINALIZADAS (Regra de Negócio).
-- Os itens de OS pendentes (4, 7, 8) tiveram as garantias
-- substituídas pelos novos itens (11, 12, 13) Finalizados.
-- ============================================================
INSERT INTO mecanica.garantia_servico
    (id_item, data_inicio, data_fim, km_inicio, km_fim, utilizada, data_utilizacao, os_retorno)
VALUES
(1,  '2026-05-12', '2026-08-10',  45000,  48000, false, NULL,         NULL),  -- Troca Óleo OS 1
(2,  '2026-05-12', '2026-06-11',  45000,  46000, false, NULL,         NULL),  -- Alinhamento OS 1
(3,  '2026-05-15', '2026-09-12',  89000,  94000, true,  '2026-06-02', 9),     -- Freio OS 2 — ACIONADA
(5,  '2026-05-25', '2026-11-21',  62000,  72000, false, NULL,         NULL),  -- Correia OS 6
(6,  '2026-05-25', '2026-06-24',  62000,  63000, false, NULL,         NULL),  -- Alinhamento OS 6
(9,  '2026-05-30', '2026-08-28',  47500,  50500, false, NULL,         NULL),  -- Troca Óleo OS 10
(10, '2026-05-30', '2026-06-29',  47500,  48500, false, NULL,         NULL),  -- Alinhamento OS 10
(11, '2026-05-12', '2026-08-10',  45000,  48000, false, NULL,         NULL),  -- Diagnóstico OS 1
(12, '2026-05-15', '2026-06-14',  89000,  90000, false, NULL,         NULL),  -- Alinhamento OS 2
(13, '2026-05-25', '2026-09-22',  62000,  67000, false, NULL,         NULL);  -- Freio OS 6


-- ============================================================
-- 18. SOLICITAÇÃO DE COMPRA (10 Tuplas)
-- ============================================================
INSERT INTO mecanica.solicitacao_compra
    (cpf_atendente, status_solicitacao, quantidade_requerida, peca_solicitada)
VALUES
('11111111111', 'Aberto',        50, 4),  -- Reposição óleo — giro rápido
('22222222222', 'Em_andamento',  10, 5),  -- Palhetas baixas
('33333333333', 'Finalizado',    30, 2),  -- Pastilhas repostas
('10101010101', 'Cancelado',     20, 3),  -- Correia cancelada
('20202020202', 'Aberto',        15, 1),  -- Filtros abaixo do ideal
('10101010101', 'Finalizado',    20, 1),  -- Filtros repostos (ciclo anterior)
('20202020202', 'Aberto',         5, 5),  -- Palhetas — segundo pedido
('11111111111', 'Em_andamento',  15, 3),  -- Correia em negociação
('22222222222', 'Cancelado',     10, 2),  -- Pastilhas — fornecedor cancelou
('33333333333', 'Finalizado',   100, 4);  -- Reposição óleo em volume