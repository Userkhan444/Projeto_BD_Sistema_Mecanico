CREATE EXTENSION IF NOT EXISTS pgcrypto;

ALTER TABLE mecanica.funcionario 
ADD COLUMN senha_acesso VARCHAR(255);


UPDATE mecanica.funcionario SET senha_acesso = crypt('Carlos@2025', gen_salt('bf')) WHERE cpf_funcionario = '11111111111'; 
UPDATE mecanica.funcionario SET senha_acesso = crypt('Mariana#Atend', gen_salt('bf')) WHERE cpf_funcionario = '22222222222'; 
UPDATE mecanica.funcionario SET senha_acesso = crypt('Roberto!Oficina', gen_salt('bf')) WHERE cpf_funcionario = '33333333333'; 
UPDATE mecanica.funcionario SET senha_acesso = crypt('JuTorres@123', gen_salt('bf')) WHERE cpf_funcionario = '10101010101'; 
UPDATE mecanica.funcionario SET senha_acesso = crypt('RicardoM$88', gen_salt('bf')) WHERE cpf_funcionario = '20202020202'; 

UPDATE mecanica.funcionario SET senha_acesso = crypt('ZeMotor@99', gen_salt('bf')) WHERE cpf_funcionario = '44444444444'; 
UPDATE mecanica.funcionario SET senha_acesso = crypt('Lucas_Mec1', gen_salt('bf')) WHERE cpf_funcionario = '55555555555'; 
UPDATE mecanica.funcionario SET senha_acesso = crypt('MarcosFreio!', gen_salt('bf')) WHERE cpf_funcionario = '66666666666'; 
UPDATE mecanica.funcionario SET senha_acesso = crypt('AndreMec@10', gen_salt('bf')) WHERE cpf_funcionario = '77777777777'; 
UPDATE mecanica.funcionario SET senha_acesso = crypt('FabioJ!2026', gen_salt('bf')) WHERE cpf_funcionario = '30303030303'; 

ALTER TABLE mecanica.funcionario 
ALTER COLUMN senha_acesso SET NOT NULL;



CREATE INDEX idx_os_status ON mecanica.ordem_servico(status_os);

CREATE INDEX idx_veiculo_dono ON mecanica.veiculo(cpf_dono);

CREATE INDEX idx_os_data_abertura ON mecanica.ordem_servico(data_abertura);