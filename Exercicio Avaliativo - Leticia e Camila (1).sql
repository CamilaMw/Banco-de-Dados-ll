-- Exercício 1

-- a) Crie e popule as tabelas clientes pedos exibidas no slide 17;
CREATE TABLE clientes(
	id_cliente SERIAL PRIMARY KEY,
	nome VARCHAR(255),
	cidade VARCHAR(255)
);

CREATE TABLE pedidos(
	id_pedido INTEGER PRIMARY KEY,
	id_cliente INTEGER,
	produto VARCHAR(255),
	quantidade INTEGER,
	FOREIGN KEY(id_cliente) REFERENCES clientes(id_cliente)
);

INSERT INTO clientes(id_cliente, nome, cidade) VALUES 
	(1, 'João Silva', 'São Paulo'),
	(2, 'Maria Souza', 'Rio de Janeiro'),
	(3, 'Carlos Lima', 'Belo Horizonte');
	
INSERT INTO pedidos(id_pedido, id_cliente, produto, quantidade) VALUES
	(101, 1, 'Notebook', 1),
	(102, 2, 'Smartphone', 2),
	(103, 1, 'Monitor', 1),
	(104, 3, 'Tablet', 1);

-- b) Crie uma consulta que utilize junções para obter informações combinadas das duas tabelas criadas no item a)
SELECT * FROM clientes
INNER JOIN pedidos
ON clientes.id_cliente = pedidos.id_cliente; 

-- c) Crie uma consulta para listar todos clientes, incluindo aqueles que não fizeram pedidos.
SELECT * FROM clientes
LEFT JOIN pedidos
ON clientes.id_cliente = pedidos.id_cliente;

-- d) Crie uma consulta para listar todos os pedidos, incluindo aqueles que não têm um cliente correspondente na tabela de clientes
SELECT * FROM clientes
RIGHT JOIN pedidos
ON clientes.id_cliente = pedidos.id_pedido;

-- e) Crie uma consulta para listar todos clientes e todos pedidos, combinando as informações de ambas tabelas.
SELECT * FROM clientes
FULL OUTER JOIN pedidos
ON clientes.id_cliente = pedidos.id_cliente;

-- f) Crie uma consulta para listar apenas os pedidos de clientes da cidade de São Paulo.
SELECT * FROM clientes
INNER JOIN pedidos
ON clientes.id_cliente = pedidos.id_cliente
WHERE clientes.cidade = 'São Paulo';

-- Exercício 2

-- a) Crie e popule as tabelas padeiros e auxiliares exibidas no slide 32.
CREATE TABLE padeiros(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(255),
	departamento VARCHAR(255),
	data_admissao DATE
);

CREATE TABLE auxiliares(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(255),
	departamento VARCHAR(255),
	data_admissao DATE
);

INSERT INTO padeiros (nome, departamento, data_admissao) VALUES
	('Roberta Luna', 'Padeiro', '2015-01-01'),
	('José Santiago', 'Padeiro', '2017-02-25');

INSERT INTO auxiliares(nome, departamento, data_admissao) VALUES
	('Joaquim Borges', 'Auxiliar', '2019-01-01'),
	('Antonio França', 'Auxiliar', '2018-03-25'),
	('Emanuel Costa', 'Auxiliar', '2022-01-01');
	
-- b) Crie uma consulta que promova a Padeiro todos os auxiliares que se encontram na empresa antes de 2020 adicionando os auxiliares promovidos na tabela padeiro.
INSERT INTO padeiros (nome, departamento, data_admissao)
SELECT nome, 'Padeiro', data_admissao
FROM auxiliares
WHERE data_admissao < '2020-01-01';

