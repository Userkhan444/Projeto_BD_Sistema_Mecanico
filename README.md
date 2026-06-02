# ⚙️ Sistema de Gestão para Oficina Mecânica (Banco de Dados)

Este repositório contém o projeto e a implementação de um banco de dados relacional completo para o gerenciamento de uma oficina mecânica. O sistema cobre o ciclo operacional de ponta a ponta: cadastro de clientes e veículos, controle de estoque de peças, fluxo de Ordens de Serviço (OS), faturamento, rateio de comissões e acionamento de garantias.

Projeto desenvolvido como requisito avaliativo para a disciplina de **Banco de Dados** do curso de Ciência da Computação (Universidade Federal de Alagoas - UFAL, Campus Arapiraca).

## 🏗️ Arquitetura e Decisões de Modelagem

O banco de dados foi modelado e implementado em **PostgreSQL**, seguindo rigorosamente as restrições de integridade e a normalização até a 3ª Forma Normal (3FN).

* **Especialização Disjunta (Table Per Type):** A entidade central `Pessoa` é especializa em `Cliente` e `Funcionario`, que por sua vez se ramifica em `Atendente` e `Mecanico`.
* **Agregação (Entidade Associativa):** O relacionamento entre Serviço e OS foi encapsulado em uma entidade associativa para permitir o rateio percentual justo entre mecânicos por item executado.
* **Consistência Financeira (3FN):** O valor total da Ordem de Serviço não é armazenado fisicamente para evitar anomalias de atualização. O faturamento é consolidado dinamicamente via `VIEW`.
* **Inteligência no SGBD:** Automação de regras de negócio complexas através de Stored Procedures (como a `sp_finalizar_os`, que valida status e aciona o relógio de garantias automaticamente).

## 📂 Estrutura do Repositório

O projeto está dividido em scripts sequenciais para facilitar a implantação:

* **`criacao_tabelas.sql`**: Criação do schema, domínios restritos (`ENUMs`), tabelas e definição de integridade referencial (`PKs`, `FKs`, regras de `ON DELETE`).
* **`02_logica_e_regras.sql`**: Camada de comportamento, incluindo a View de faturamento e a Procedure transacional de encerramento de OS.
* **`03_populamento.sql`**: Script DML (*seed*) com dados estrategicamente desenhados para cobrir casos de borda e estressar o SGBD.
* **`04_consultas_dql.sql`**: Bateria de extração de dados demonstrando domínio em junções complexas, subconsultas correlacionadas, agregações (`GROUP BY / HAVING`) e operadores de conjunto.
* **`/diagramas`**: Modelos ER Conceitual e Relacional (Lógico).
* **`documento_gestao_bd_oficina_mecanica.pdf`**: Relatório técnico documentando o mini-mundo, cardinalidades e justificativas de projeto.

## 🚀 Como Executar

1.  Clone este repositório para a sua máquina local:
    ```bash
    git clone [https://github.com/Userkhan444/Projeto_BD_Sistema_Mecanico.git](https://github.com/Userkhan444/Projeto_BD_Sistema_Mecanico)
    ```
2.  Abra o seu cliente SQL preferido (recomendado: **DBeaver**).
3.  Conecte-se a uma instância rodando o PostgreSQL.
4.  Execute os scripts `.sql` na ordem numérica (do 01 ao 04).

---

**Autores:**
* Davison Gabriel Monteiro de Farias
* Ewerton Gabriel Oliveira Cavalcante
