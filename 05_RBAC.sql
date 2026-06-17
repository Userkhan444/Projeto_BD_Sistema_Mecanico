-- ==========================================
-- 1. CRIAÇÃO DOS PAPÉIS E ACESSO AO SCHEMA
-- ==========================================
CREATE ROLE role_gerente;
CREATE ROLE role_atendente;
CREATE ROLE role_mecanico;

-- Concedendo acesso básico ao schema para todas as roles
GRANT USAGE ON SCHEMA mecanica TO role_gerente, role_atendente, role_mecanico;


-- ==========================================
-- 2. PRIVILÉGIOS: GERENTE
-- ==========================================
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA mecanica TO role_gerente;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA mecanica TO role_gerente;


-- ==========================================
-- 3. PRIVILÉGIOS: ATENDENTE
-- ==========================================
-- Permissão de leitura em tabelas de catálogo/apoio
GRANT SELECT ON 
    mecanica.estado, mecanica.cidade, mecanica.servico, 
    mecanica.mecanico, mecanica.atendente 
TO role_atendente; 

-- Leitura restrita (apenas CPF) na tabela de funcionários
GRANT SELECT (cpf_funcionario) ON mecanica.funcionario TO role_atendente;

-- O Atendente precisa poder LER as tabelas pessoa e cliente (devido a FKs/JOINs nas consultas), mas NÃO PODE editar diretamente
GRANT SELECT ON mecanica.pessoa, mecanica.cliente TO role_atendente;

-- Permissão de manipulação nas tabelas operacionais do dia a dia e na nova View de Clientes
GRANT SELECT, INSERT, UPDATE ON
    mecanica.vw_clientes,
    mecanica.telefones,
    mecanica.veiculo,
    mecanica.ordem_servico,
    mecanica.ordem_pagamento,
    mecanica.solicitacao_compra,
    mecanica.ordem_servico_peca,
    mecanica.item_os_servico,
    mecanica.garantia_servico,
    mecanica.peca
TO role_atendente;

-- Permissão nas sequences para gerar novos IDs (PKs) nos INSERTS
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA mecanica TO role_atendente;


-- ==========================================
-- 4. PRIVILÉGIOS: MECÂNICO
-- ==========================================
-- Permissão exclusiva de LEITURA para consultar catálogos e itens da OS
GRANT SELECT ON 
    mecanica.peca, mecanica.servico, mecanica.item_os_servico, 
    mecanica.ordem_servico_peca, mecanica.garantia_servico, 
    mecanica.rateio_mecanico_servico 
TO role_mecanico;

-- Leitura da view de painel com os dados filtrados do serviço atual
GRANT SELECT ON mecanica.vw_painel_mecanico TO role_mecanico;

-- Atualização restrita a atributos técnicos do andamento do trabalho
GRANT UPDATE (status_os, quilometragem, descricao) ON mecanica.ordem_servico TO role_mecanico;

