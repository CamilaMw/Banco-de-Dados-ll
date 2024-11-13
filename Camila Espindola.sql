-- Camila Espindola Fernandes

/* 1. Cálculo de Desconto em Compras
Descrição: Crie uma função que calcula o preço final de uma compra após aplicar um
desconto percentual.
Tarefas:
• Crie uma tabela compras com colunas id, produto_id, quantidade e preco.
• Crie uma função calcular_preco_com_desconto que recebe compra_id e
percentual_desconto e retorna o preço final com desconto.
*/

CREATE TABLE compras(
	id SERIAL PRIMARY KEY,
	produto_id INTEGER,
	quantidade INTEGER,
	preco  REAL
);

DROP TABLE compras

INSERT INTO compras(produto_id, quantidade, preco)
VALUES(1, 1, 18)

CREATE OR REPLACE FUNCTION calcular_preco_com_desconto (compra_id INTEGER, percentual_desconto REAL)
RETURNS REAL AS $$
DECLARE
	preco_com_desconto REAL;
	preco_var REAL;
BEGIN	
	SELECT preco INTO preco_var 
	FROM compras WHERE id = compra_id;
	preco_com_desconto := preco_var - (preco_var * (percentual_desconto / 100));
	RETURN preco_com_desconto;
END
$$ LANGUAGE plpgsql;

SELECT calcular_preco_com_desconto(1, 10)

/*
2. Atualização de Salário
Descrição: Crie um procedimento que atualiza o salário de um funcionário, adicionando
um aumento percentual ao salário atual.
Tarefas:
• Crie uma tabela funcionarios com colunas id, nome e salario.
• Crie um procedimento atualizar_salario que recebe funcionario_id e
percentual_aumento e atualiza o salário do funcionário correspondente.
*/

CREATE TABLE funcionarios(
	id SERIAL PRIMARY KEY,
	nome varchar(100),
	salario REAL
);

INSERT INTO funcionarios (nome, salario)
VALUES ('Carlos', 1000),
('Otávio', 780)

CREATE OR REPLACE PROCEDURE atualizar_salario (funcionario_id INTEGER, 
											   percentual_aumento REAL)
LANGUAGE plpgsql
AS $$
DECLARE
	salario_calculado REAL;
BEGIN
	SELECT salario INTO salario_calculado 
	FROM funcionarios WHERE id = funcionario_id;
	salario_calculado := salario_calculado + (salario_calculado * (percentual_aumento / 100));
	UPDATE funcionarios 
		SET salario = salario_calculado
	WHERE id = funcionario_id;
END;
$$;

CALL atualizar_salario(1, 10)
CALL atualizar_salario(2, 20)

SELECT * FROM funcionarios

/*
3. Verificação de Estoque
Descrição: Crie uma função que verifica se um produto está disponível em estoque.
Tarefas:
• Crie uma tabela estoque com colunas produto_id, nome_produto e
quantidade.
• Crie uma função produto_em_estoque que recebe produto_id e retorna um
valor booleano indicando se o produto está em estoque.
*/

CREATE TABLE estoque(
	produto_id SERIAL PRIMARY KEY,
	nome_produto VARCHAR(100),
	quantidade INTEGER
);

INSERT INTO estoque (nome_produto, quantidade) 
VALUES ('Mouse', 10),
('Teclado', 0);


CREATE OR REPLACE FUNCTION produto_em_estoque(id_produto INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
	quantidade_estoque INTEGER;
BEGIN
	SELECT quantidade INTO quantidade_estoque 
	FROM estoque 
	WHERE produto_id = id_produto;
	
	RETURN quantidade_estoque > 0;
	
END;
$$ LANGUAGE plpgsql;

SELECT produto_em_estoque(1)
SELECT produto_em_estoque(2)

/*
4. Cálculo de Média de Notas
Descrição: Crie uma função que calcula a média das notas de um aluno.
Tarefas:
• Crie uma tabela notas com colunas aluno_id, disciplina e nota.
• Crie uma função calcular_media_notas que recebe aluno_id e retorna a
média das notas desse aluno.
*/

CREATE TABLE notas(
	aluno_id INTEGER,
	disciplina VARCHAR(100),
	nota REAL
);

INSERT INTO notas(aluno_id, disciplina, nota)
VALUES (1, 'Matemática', 7),
(1, 'Historia', 7),
(1, 'Geografia', 1)

SELECT * FROM notas

CREATE OR REPLACE FUNCTION calcular_media_notas(id_aluno INTEGER)
RETURNS REAL AS $$
DECLARE
	media_nota REAL;
BEGIN
	SELECT AVG(nota) INTO media_nota
	FROM notas
	WHERE aluno_id = id_aluno;
	RETURN media_nota;
END;
$$ LANGUAGE plpgsql

SELECT calcular_media_notas(1)

/*
5. Descrição: Crie um procedimento que insere um registro de atividade em uma tabela de
log.
Tarefas:
• Crie uma tabela log_atividades com colunas usuario_id, atividade e
timestamp.
• Crie um procedimento registrar_atividade_usuario que recebe
usuario_id e atividade e insere um registro na tabela de log.
*/

CREATE TABLE log_atividades(
	usuario_id INTEGER,
	atividade VARCHAR(100),
	data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE PROCEDURE registrar_atividade(usuario_id_p INTEGER,
							 atividade_p VARCHAR)
LANGUAGE SQL
AS $$
	INSERT INTO log_atividades (usuario_id, atividade)
	VALUES (usuario_id_p, atividade_p)
$$

CALL registrar_atividade(1, 'Estudante');

SELECT * FROM log_atividades

-- 6. Transferência de Fundos entre Contas
-- Descrição: Crie um procedimento que transfere fundos de uma conta para outra,
-- verificando saldos e aplicando a transferência.
-- Tarefas:
-- • Crie uma tabela contas com colunas id, numero_conta e saldo.
-- • Crie um procedimento transferir_fundos que recebe conta_origem,
-- conta_destino e valor e realiza a transferência, verificando se há saldo
-- suficiente na conta de origem.

CREATE TABLE contas(
	id NUMERIC,
	numero_conta NUMERIC UNIQUE,
	saldo NUMERIC
);

INSERT INTO contas(id, numero_conta, saldo)
VALUES (1, 1234, 1532.50),
(2, 4321, 72.00)

CREATE OR REPLACE PROCEDURE transferir_fundos(conta_origem NUMERIC,
											  conta_destino NUMERIC,
											  valor NUMERIC)
LANGUAGE plpgsql
AS $$
DECLARE
	saldo_destino NUMERIC;
	saldo_debitar NUMERIC;
BEGIN
	SELECT saldo INTO saldo_debitar
	FROM contas WHERE contas.numero_conta = conta_origem;
		
	IF saldo_debitar >= valor THEN
				
		UPDATE contas SET saldo = saldo + valor
		WHERE contas.numero_conta = conta_destino;
		
		UPDATE contas SET saldo = saldo - valor
		WHERE contas.numero_conta = conta_origem;
	ELSE
        RAISE EXCEPTION 'Saldo insuficiente';
	END IF;
END;
$$;

CALL transferir_fundos(1234, 4321, 30)
CALL transferir_fundos(4321, 1234, 2)

SELECT * FROM contas ORDER BY numero_conta

-- 7. Calculadora de Juros Compostos
-- Descrição: Crie uma função que calcula o montante final de um investimento com base
-- em juros compostos.
-- Tarefas:
-- • Crie uma função calcular_juros_compostos que recebe principal, taxa e
-- periodos e retorna o valor final após a aplicação dos juros compostos.

CREATE OR REPLACE FUNCTION calcular_juros_compostos(principal NUMERIC,
												    taxa NUMERIC,
												    periodos INTEGER)
RETURNS NUMERIC(10, 2) AS $$
DECLARE
	i INTEGER;
BEGIN
	taxa := taxa / 100;
	FOR i IN 1..periodos LOOP
		principal := principal * (1 + taxa);
	END LOOP;
	principal := ROUND(principal, 2);
	RETURN principal;
END;
$$ LANGUAGE plpgsql;

SELECT calcular_juros_compostos(1000, 5, 3);

-- 8. Arquivamento de Dados Antigos
-- Descrição: Crie um procedimento que move dados antigos de uma tabela principal para
-- uma tabela de histórico.
-- Tarefas:
-- • Crie uma tabela tabela_principal com colunas id, dados e data_registro.
-- • Crie uma tabela tabela_historico com a mesma estrutura da
-- tabela_principal.
-- • Crie um procedimento arquivar_dados_antigos que recebe uma
-- data_limite e move registros antigos da tabela_principal para a
-- tabela_historico

CREATE TABLE tabela_principal(
	id INTEGER UNIQUE,
	dados VARCHAR(100),
	data_registro DATE
);

INSERT INTO tabela_principal(id, dados, data_registro)
VALUES (1, 'Cadastro', '2020-08-31'),
(2, 'Despesas', '2018-10-15'),
(3, 'Vendas', '2024-02-18'),
(4, 'Comercio', '2015-05-13')

CREATE TABLE tabela_historico(
	id INTEGER UNIQUE,
	dados VARCHAR(100),
	data_registro DATE
);

CREATE OR REPLACE PROCEDURE arquivar_dados_antigos(data_limite DATE)
LANGUAGE SQL
AS $$
	INSERT INTO tabela_historico(id, dados, data_registro)
	SELECT id, dados, data_registro 
	FROM tabela_principal 
	WHERE data_registro <= data_limite;
$$;

CALL arquivar_dados_antigos('2025-11-15')

-- 9. Relatório de Vendas
-- Descrição: Crie uma função que gera um relatório resumido de vendas para um
-- determinado período.
-- Tarefas:
-- • Crie uma tabela vendas com colunas venda_id, produto_id, valor,
-- quantidade e data_venda.
-- • Crie uma função gerar_relatorio_vendas que recebe data_inicio e
-- data_fim e retorna um resumo das vendas nesse período.

CREATE TABLE vendas (
	vendas_id INTEGER UNIQUE,
	produto_id INTEGER,
	valor REAL,
	quantidade REAL,
	data_venda DATE
);

INSERT INTO vendas(vendas_id, produto_id, valor, quantidade, data_venda)
VALUES(1, 2, 15.00, 35, '2024-08-20'),
(2, 4, 32.50, 2, '2023-05-10'),
(3, 8, 28.72, 88, '2019-03-05');

CREATE OR REPLACE FUNCTION gerar_relatorio_vendas(
    data_inicio DATE,
    data_fim DATE
)
RETURNS TEXT AS $$
DECLARE
    relatorio TEXT;
BEGIN
    -- Cria uma string de resultado formatada
    SELECT INTO relatorio
    STRING_AGG(
        FORMAT(
            'Produto ID: %s, Total Vendas: %s, Quantidade Total: %s',
            subquery.produto_id,
            TO_CHAR(subquery.total_vendas, 'FM9999999990.00'),
            subquery.quantidade_total
        ),
        E'\n'
    )
    FROM (
        SELECT 
            v.produto_id,
            SUM(v.valor * v.quantidade)::NUMERIC(10, 2) AS total_vendas,
            SUM(v.quantidade)::INTEGER AS quantidade_total
        FROM 
            vendas v
        WHERE 
            v.data_venda BETWEEN data_inicio AND data_fim
        GROUP BY 
            v.produto_id
    ) AS subquery;

    RETURN relatorio;
END;
$$ LANGUAGE plpgsql;

SELECT gerar_relatorio_vendas('2018-01-01', '2025-01-01');

-- 10. Envio de Notificações
-- Descrição: Crie um procedimento que envia notificações para usuários com base em
-- um evento específico.
-- Tarefas:
-- • Crie uma tabela notificacoes com colunas notificacao_id, usuario_id,
-- mensagem e enviado_em.
-- • Crie um procedimento enviar_notificacao que recebe usuario_id e
-- mensagem, insere um registro na tabela notificacoes e marca o tempo de
-- envio.

CREATE TABLE notificacao(
	notificacoes_id SERIAL PRIMARY KEY,
	usuario_id INTEGER,
	mensagem TEXT,
	enviado_em TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE PROCEDURE enviar_notificacao(n_usuario_id INTEGER, n_mensagem TEXT)
LANGUAGE plpgsql
AS $$ 
BEGIN
	INSERT INTO notificacao(usuario_id, mensagem, enviado_em)
	VALUES (n_usuario_id, n_mensagem, CURRENT_TIMESTAMP);
END;
$$;

CALL enviar_notificacao(1, 'Mensagem');
CALL enviar_notificacao(5, 'Sua notificação fon enviada com sucesso!');

SELECT * FROM notificacao



































	
