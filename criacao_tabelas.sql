create schema mecanica;

--Create Types

create type mecanica.status_solicitacao as enum('Aberto','Em_andamento', 'Finalizado', 'Cancelado');
create type mecanica.status_pagamento as enum('Pago', 'Pendente', 'Parcial', 'Estornado');
create type mecanica.tipo_pagamento as enum('Pix', 'Dinheiro', 'Cartao_Debito', 'Cartao_Credito', 'Boleto');
create type mecanica.prioridade as enum ('Baixa', 'Normal', 'Alta', 'Urgente');
create type mecanica.status_os as enum ('Orcamento', 'Aguardando_Aprovacao', 'Aprovado', 'Em_Andamento', 'Aguardando_Peca', 'Finalizado', 'Cancelado');
create type mecanica.categoria as enum('Venda_Balcao', 'Manutencao_Veicular');
create type mecanica.tipo_combustivel as enum('Gasolina', 'Diesel', 'Flex');


create table mecanica.estado (
    id_estado serial primary key,
    sigla char(2) not null unique,
    nome varchar(50) not null unique
);

create table mecanica.cidade (
    id_cidade serial primary key,
    nome varchar(100) not null,
    id_estado integer not null references mecanica.estado(id_estado) ON DELETE RESTRICT,
    unique(nome, id_estado)
);

create table mecanica.pessoa (
    cpf varchar(11) primary key,
    nome varchar(100) not null,
    email varchar(254) not null unique,
    logradouro varchar(100) not null,
    numero varchar(10) not null,
    bairro varchar(50) not null,
    cep varchar(8) not null,
    id_cidade integer not null references mecanica.cidade(id_cidade) ON DELETE RESTRICT
);

create table mecanica.telefones (
    id_telefone Serial primary key,
    cpf_pessoa varchar(11) not null references mecanica.pessoa(cpf) ON DELETE CASCADE,
    telefone varchar(20) not null,
    unique(cpf_pessoa, telefone)
);

create table mecanica.funcionario(  
    cpf_funcionario varchar(11) primary key references mecanica.pessoa(cpf) ON DELETE RESTRICT,
    salario_base numeric(10,2) not null check (salario_base > 0)
) ;

create table mecanica.atendente(  
    cpf_atendente varchar(11) primary key references mecanica.funcionario(cpf_funcionario) ON DELETE RESTRICT
) ;

create table mecanica.mecanico(  
    cpf_mecanico varchar(11) primary key references mecanica.funcionario(cpf_funcionario) ON DELETE RESTRICT
) ;

create table mecanica.cliente(
    cpf_cliente varchar(11) primary key references mecanica.pessoa(cpf) ON DELETE RESTRICT,
    data_cadastro timestamp not null default now()
) ;

create table mecanica.veiculo(
    placa varchar(10) primary key,
    marca varchar(40) not null,
    ano smallint not null check (ano >= 1900),
    cor varchar (20) not null,
    tipo_combustivel mecanica.tipo_combustivel not null,
    cpf_dono varchar(11) not null references mecanica.cliente(cpf_cliente),
    modelo varchar(80) not null
);

create table mecanica.peca(
    codigo_peca serial primary key,
    nome VARCHAR(80) not null,
    quantidade_estoque int not null check (quantidade_estoque >= 0),
    valor_peca numeric (10, 2) not null check (valor_peca > 0)
);

create table mecanica.solicitacao_compra (
    id_solicitacao serial primary key,
    cpf_atendente varchar(11) not null references mecanica.atendente(cpf_atendente),
    status_solicitacao mecanica.status_solicitacao not null default 'Aberto',
    data_solicitacao date default current_date,
    quantidade_requerida smallint not null CHECK (quantidade_requerida > 0),
    peca_solicitada integer not null references mecanica.peca(codigo_peca)
);

create table mecanica.servico(  
    codigo_servico serial primary key,
    descricao text not null,
    valor numeric (10, 2) not null check (valor > 0),
    tempo_estimado_horas smallint not null check (tempo_estimado_horas>0),
    garantia_dias smallint not null default 90 check (garantia_dias >= 0),
    garantia_km int not null default 3000 check (garantia_km >= 0)
);

create table mecanica.ordem_servico(
    codigo_os serial primary key,
    descricao text not null,
    data_fechamento date,
    data_estimada date not null,
    quilometragem int CHECK (quilometragem >= 0),
    categoria mecanica.categoria not null,
    prioridade mecanica.prioridade not null default 'Normal',
    data_abertura date not null default current_date,
    status_os mecanica.status_os not null default 'Orcamento',
    cpf_atendente varchar(11) not null references mecanica.atendente(cpf_atendente),
    placa_veiculo varchar(10) references mecanica.veiculo(placa) ON DELETE SET NULL,
    constraint chk_data_estimada check (data_estimada >= data_abertura),
    constraint chk_data_fechamento check (data_fechamento is null or data_fechamento >= data_abertura),
    constraint chk_regra_negocio_os check (
        (categoria = 'Manutencao_Veicular' and placa_veiculo is not null and quilometragem is not null) 
        OR 
        (categoria = 'Venda_Balcao' and placa_veiculo is null and quilometragem is null)
    )
);

create table mecanica.ordem_pagamento (
    id_pagamento serial primary key,
    status_pagamento mecanica.status_pagamento default 'Pendente',
    tipo_pagamento mecanica.tipo_pagamento not null,
    valor_pago numeric(10,2) not null check (valor_pago > 0),
    data_pagamento date,
    codigo_os integer not null references mecanica.ordem_servico(codigo_os)
);

create table mecanica.ordem_servico_peca (
    id_item_peca serial primary key,
    codigo_os integer not null references mecanica.ordem_servico(codigo_os) ON DELETE CASCADE,
    codigo_peca integer not null references mecanica.peca(codigo_peca),
    quantidade_requisitada smallint not null check (quantidade_requisitada > 0),
    valor_unitario_cobrado numeric(10,2) not null check (valor_unitario_cobrado > 0),
    unique(codigo_os, codigo_peca)
);

create table mecanica.item_os_servico (
    id_item serial primary key,
    codigo_os integer not null references mecanica.ordem_servico(codigo_os) ON DELETE CASCADE,
    codigo_servico integer not null references mecanica.servico(codigo_servico),
    valor_cobrado numeric(10,2) not null check (valor_cobrado > 0),
    unique(codigo_os, codigo_servico)
);

create table mecanica.rateio_mecanico_servico (
    id_item integer not null references mecanica.item_os_servico(id_item) ON DELETE CASCADE,
    cpf_mecanico varchar(11) not null references mecanica.mecanico(cpf_mecanico),
    primary key (id_item, cpf_mecanico),
    percentual_rateio numeric(5,2) not null check (percentual_rateio > 0 and percentual_rateio <= 100)
);

create table mecanica.garantia_servico (
    id_garantia serial primary key,
    id_item integer not null references mecanica.item_os_servico(id_item) ON DELETE RESTRICT,
    data_inicio date not null,
    data_fim date not null check(data_fim > data_inicio),
    km_inicio int not null,
    km_fim int not null check(km_fim >= km_inicio),
    utilizada boolean not null default false,
    data_utilizacao date,
    os_retorno integer references mecanica.ordem_servico(codigo_os) ON DELETE SET NULL
);
