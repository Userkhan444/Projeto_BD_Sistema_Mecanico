create schema mecanica;

--Create Types

create type mecanica.status_solicitacao as enum('Aberto','Em_andamento', 'Finalizado', 'Cancelado');
create type mecanica.status_pagamento as enum('Pago', 'Pendente', 'Parcial', 'Estornado');
create type mecanica.tipo_pagamento as enum('Pix', 'Dinheiro', 'Cartao_Debito', 'Cartao_Credito', 'Boleto');
create type mecanica.prioridade as enum ('Baixa', 'Normal', 'Alta', 'Urgente');
create type mecanica.status_os as enum ('Orcamento', 'Aguardando_Aprovacao', 'Aprovado', 'Em_Andamento', 'Aguardando_Peca', 'Finalizado', 'Cancelado');
create type mecanica.categoria as enum('Venda_Balcao', 'Manutencao_Veicular');

create table mecanica.pessoa (
    CPF varchar(11) primary key,
    nome varchar(100) not null,
    email varchar(254) not null unique,
    logradouro varchar(100) not null,
    numero varchar(10) not null,
    bairro varchar(50) not null,
    cidade varchar(50) not null,
    estado char(2) not null,
    cep varchar(8) not null
);

create table mecanica.telefones (
    id_telefone Serial primary key,
    cpf_pessoa varchar(11) not null references mecanica.pessoa(cpf),
    telefone varchar(20) not null
);

create table mecanica.funcionario(  
    cpf_funcionario varchar(11) primary key references mecanica.pessoa(cpf),
    salario_base numeric(10,2) not null
) ;

create table mecanica.atendente(  
    cpf_atendente varchar(11) primary key references mecanica.funcionario(cpf_funcionario)
) ;

create table mecanica.mecanico(  
    cpf_mecanico varchar(11) primary key references mecanica.funcionario(cpf_funcionario)
) ;

create table mecanica.cliente(
    cpf_cliente varchar(11) primary key references mecanica.pessoa(cpf),
    data_cadastro timestamp default now()
) ;

create table mecanica.veiculo(
    placa varchar(10) primary key,
    marca varchar(40) not null,
    ano smallint not null,
    cpf_dono varchar(11) not null references mecanica.cliente(cpf_cliente),
    quilometragem int not null,
    modelo varchar(80) not null
);

create table mecanica.peca(
    codigo_peca serial primary key,
    nome VARCHAR(80) not null,
    quantidade_estoque SMALLINT not null,
    valor_peca numeric (10, 2) not null
);

create table mecanica.solicitacao_compra (
    id_solicitacao serial primary key,
    status_solicitacao mecanica.status_solicitacao not null default 'Aberto',
    data_solicitacao date default current_date,
    quantidade_requerida smallint not null,
    peca_solicitada integer not null references mecanica.peca(codigo_peca)
);

create table mecanica.servico(  
    codigo_servico serial primary key,
    descricao text not null,
    valor numeric (10, 2),
    tempo_estimado smallint not null
);

create table mecanica.ordem_pagamento (
    id_pagamento serial primary key,
    status_pagamento mecanica.status_pagamento not null default 'Pendente',
    tipo_pagamento mecanica.tipo_pagamento not null,
    valor_total numeric(10,2) not null,
    data_pagamento date not null,
    codigo_os integer not null references mecanica.ordem_servico(codigo_os)
);

create table mecanica.ordem_servico(
    codigo_os serial primary key,
    categoria mecanica.categoria not null,
    prioridade mecanica.prioridade not null default 'Normal',
    data_abertura date not null default current_date,
    status_os mecanica.status_os not null default 'Orcamento',
    valor_total numeric(10,2) default 0.00,
    cpf_atendente varchar(11) not null references mecanica.atendente(cpf_atendente),
    placa_veiculo varchar(10) references mecanica.veiculo(placa),
    constraint chk_regra_negocio_os check (
        (categoria = 'Manutencao_Veicular' and placa_veiculo is not null) 
        OR 
        (categoria = 'Venda_Balcao' and placa_veiculo is null)
    )
);

create table mecanica.ordem_servico_peca (
    id_item_peca serial primary key,
    codigo_os integer not null references mecanica.ordem_servico(codigo_os),
    codigo_peca integer not null references mecanica.peca(codigo_peca),
    quantidade_requisitada smallint not null,
    valor_unitario_cobrado numeric(10,2) not null
);

create table mecanica.item_os_servico (
    id_item serial primary key,
    codigo_os integer not null references mecanica.ordem_servico(codigo_os),
    codigo_servico integer not null references mecanica.servico(codigo_servico),
    valor_cobrado numeric(10,2) not null 
);

create table mecanica.rateio_mecanico_servico (
    id_item integer not null references mecanica.item_os_servico(id_item),
    cpf_mecanico varchar(11) not null references mecanica.mecanico(cpf_mecanico),
    primary key (id_item, cpf_mecanico),
    percentual_rateio numeric(5,2) not null
    
);

