create schema mecanica;

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
    cpf_pessoa varchar(11) references mecanica.pessoa(cpf),
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
    cpf_dono varchar(11) references mecanica.cliente(cpf_cliente)
);

