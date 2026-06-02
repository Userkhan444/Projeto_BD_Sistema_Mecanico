-- ============================================================
-- VIEW — FATURAMENTO DA OS
-- Calcula o valor total dinamicamente, somando serviços
-- e peças. Substitui a coluna valor_total na tabela.
-- ============================================================
 
CREATE OR REPLACE VIEW mecanica.vw_faturamento_os AS
SELECT
    os.codigo_os,
    os.descricao,
    os.placa_veiculo,
    os.categoria,
    os.status_os,
    os.data_abertura,
    os.data_fechamento,
    COALESCE((
        SELECT SUM(valor_cobrado)
          FROM mecanica.item_os_servico
         WHERE codigo_os = os.codigo_os
    ), 0)
    +
    COALESCE((
        SELECT SUM(valor_unitario_cobrado * quantidade_requisitada)
          FROM mecanica.ordem_servico_peca
         WHERE codigo_os = os.codigo_os
    ), 0) AS valor_total_fatura
FROM mecanica.ordem_servico os;
 
 
-- ============================================================
-- PROCEDURE — FINALIZAR OS
-- Valida o estado da OS, atualiza o status para Finalizado
-- e gera as garantias dos serviços realizados.
-- Garantia de KM só é gerada para Manutencao_Veicular.
-- ============================================================
 
CREATE OR REPLACE PROCEDURE mecanica.sp_finalizar_os(p_codigo_os INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
    v_status mecanica.status_os;
BEGIN
    SELECT status_os INTO v_status
      FROM mecanica.ordem_servico
     WHERE codigo_os = p_codigo_os;
 
    IF NOT FOUND THEN
        RAISE EXCEPTION 'OS % não encontrada', p_codigo_os;
    END IF;
 
    IF v_status = 'Finalizado' THEN
        RAISE EXCEPTION 'OS % já está finalizada', p_codigo_os;
    END IF;
 
    IF v_status = 'Cancelado' THEN
        RAISE EXCEPTION 'OS % está cancelada e não pode ser finalizada', p_codigo_os;
    END IF;
 
    UPDATE mecanica.ordem_servico
       SET status_os       = 'Finalizado',
           data_fechamento = CURRENT_DATE
     WHERE codigo_os = p_codigo_os;
 
    INSERT INTO mecanica.garantia_servico
        (id_item, data_inicio, data_fim, km_inicio, km_fim)
    SELECT
        i.id_item,
        CURRENT_DATE,
        CURRENT_DATE + s.garantia_dias,
        os.quilometragem,
        os.quilometragem + s.garantia_km
      FROM mecanica.item_os_servico i
      JOIN mecanica.servico s         ON s.codigo_servico = i.codigo_servico
      JOIN mecanica.ordem_servico os  ON os.codigo_os     = i.codigo_os
     WHERE i.codigo_os    = p_codigo_os
       AND os.categoria   = 'Manutencao_Veicular';
END;
$$;