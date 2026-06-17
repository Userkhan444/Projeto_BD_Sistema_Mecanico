-- ================================================
-- VIEW: Expõe apenas dados do domínio de Clientes
-- ================================================
CREATE OR REPLACE VIEW mecanica.vw_clientes AS
 SELECT
 p.cpf, p.nome, p.email, p.logradouro, p.numero, p.bairro, p.cep, p.id_cidade,
 c.data_cadastro
 FROM mecanica.pessoa p
 INNER JOIN mecanica.cliente c ON c.cpf_cliente = p.cpf;
-- ================================================
-- TRIGGER FUNCTION: Gerencia Inserções na Herança
-- ================================================
CREATE OR REPLACE FUNCTION mecanica.fn_insert_vw_clientes()
RETURNS TRIGGER SECURITY DEFINER AS $$

BEGIN
 INSERT INTO mecanica.pessoa (cpf, nome, email, logradouro, numero, bairro, cep, id_cidade)
 VALUES (NEW.cpf, NEW.nome, NEW.email, NEW.logradouro, NEW.numero, NEW.bairro, NEW.cep, NEW.id_cidade)
 ON CONFLICT (cpf) DO UPDATE SET
 nome = EXCLUDED.nome,
 email = EXCLUDED.email,
 logradouro = EXCLUDED.logradouro,
 numero = EXCLUDED.numero,
 bairro = EXCLUDED.bairro,
 cep = EXCLUDED.cep,
 id_cidade = EXCLUDED.id_cidade;
 INSERT INTO mecanica.cliente (cpf_cliente, data_cadastro)
 VALUES (NEW.cpf, COALESCE(NEW.data_cadastro, now()))
 ON CONFLICT (cpf_cliente) DO NOTHING;
 RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_insert_vw_clientes
 INSTEAD OF INSERT ON mecanica.vw_clientes
 FOR EACH ROW EXECUTE FUNCTION mecanica.fn_insert_vw_clientes();
-- ================================================
-- TRIGGER FUNCTION: Gerencia Atualizações
-- ================================================
CREATE OR REPLACE FUNCTION mecanica.fn_update_vw_clientes()
RETURNS TRIGGER SECURITY DEFINER AS $$
BEGIN
 UPDATE mecanica.pessoa
 SET
 nome = NEW.nome,
 email = NEW.email,
 logradouro = NEW.logradouro,
 numero = NEW.numero,
 bairro = NEW.bairro,
 cep = NEW.cep,
 id_cidade = NEW.id_cidade
 WHERE cpf = OLD.cpf;

 RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_update_vw_clientes
 INSTEAD OF UPDATE ON mecanica.vw_clientes
 FOR EACH ROW EXECUTE FUNCTION mecanica.fn_update_vw_clientes();
