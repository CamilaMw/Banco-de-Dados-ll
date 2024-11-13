-- Alunas: Letícia e Camila 

CREATE TABLE Clientes (
	id_cliente INT Primary Key,
	nome VARCHAR(100),
	email VARCHAR(100),
	saldo DECIMAL(10, 2),
	data_criacao TIMESTAMP
);

CREATE TABLE Pedidos (
	id_pedido INT PRIMARY KEY,
	id_cliente INT,
	data_pedido TIMESTAMP,
	valor_total DECIMAL(10, 2),
	FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE Itens_de_Pedido (
	id_item INT PRIMARY KEY,
	id_pedido INT,
	produto VARCHAR(100),
	quantidade INT,
	preco_unitario DECIMAL(10, 2),
	valor_total DECIMAL(10, 2),
	FOREIGN KEY (id_pedido) REFERENCES Pedidos (id_pedido)
);
 CREATE TABLE Produtos(
id_produto INT PRIMARY KEY,
nome VARCHAR(100),
estoque INT,
preco DECIMAL(10,2));


-- A) Trigger para Atualização do Saldo do Cliente após Pedido

CREATE OR REPLACE FUNCTION atualiza_saldo_cliente_func()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE clientes
    SET saldo = saldo - NEW.valor_total
    WHERE id_cliente = NEW.id_cliente;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER atualiza_saldo_cliente
AFTER INSERT ON pedidos
FOR EACH ROW
EXECUTE FUNCTION atualiza_saldo_cliente_func();


-- B) Trigger para Atualização do Estoque após Inserção de Item de Pedido

CREATE OR REPLACE FUNCTION atualiza_estoque_produto_func()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE produtos
    SET estoque = estoque - NEW.quantidade
    WHERE id_produto = (SELECT id_produto FROM produtos WHERE nome = NEW.produto);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER atualiza_estoque_produto
AFTER INSERT ON itens_de_pedido
FOR EACH ROW
EXECUTE FUNCTION atualiza_estoque_produto_func();


-- c) Trigger para Verificação de Estoque Suficiente Antes de Adicionar um Item ao Pedido

CREATE OR REPLACE FUNCTION verifica_estoque_suficiente_func()
RETURNS TRIGGER AS $$
DECLARE
    quantidade_disponivel INT;
BEGIN
    SELECT estoque INTO quantidade_disponivel
    FROM produtos
    WHERE id_produto = (SELECT id_produto FROM produtos WHERE nome = NEW.produto);

    IF quantidade_disponivel < NEW.quantidade THEN
        RAISE EXCEPTION 'Estoque insuficiente para o produto.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verifica_estoque_suficiente
BEFORE INSERT ON itens_de_pedido
FOR EACH ROW
EXECUTE FUNCTION verifica_estoque_suficiente_func();


-- d) Trigger para Calcular o Valor Total de um Pedido após Inserção de Itens

CREATE OR REPLACE FUNCTION calcula_valor_total_pedido_func()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE pedidos
    SET valor_total = valor_total + NEW.valor_total
    WHERE id_pedido = NEW.id_pedido;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER calcula_valor_total_pedido
AFTER INSERT ON itens_de_pedido
FOR EACH ROW
EXECUTE FUNCTION calcula_valor_total_pedido_func();


-- e) Trigger para Histórico de Alterações no Estoque

CREATE TABLE historico_estoque (
    id_historico SERIAL PRIMARY KEY,
    id_produto INT,
    data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estoque_anterior INT,
    estoque_atual INT,
    quantidade_alterada INT
);

CREATE OR REPLACE FUNCTION historico_alteracao_estoque_func()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO historico_estoque (id_produto, estoque_anterior, estoque_atual, quantidade_alterada)
    VALUES (NEW.id_produto, OLD.estoque, NEW.estoque, OLD.estoque - NEW.estoque);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER historico_alteracao_estoque
AFTER UPDATE ON produtos
FOR EACH ROW
EXECUTE FUNCTION historico_alteracao_estoque_func();

