-- Ana Clara Monteiro de Andrade

-----------01-------------
-- a) Crie as tabelas e as popule conforme os dados são apresentados

CREATE TABLE autores (
    id_autor INT PRIMARY KEY,
    nome VARCHAR(100)
);

INSERT INTO autores (id_autor, nome) VALUES
(1, 'Sun Tzu'),
(2, 'Miguel de Cervantes'),
(3, 'J.R.R. Tolkien'),
(4, 'Fiódor Dostoiévski');

CREATE TABLE editoras (
    id_editora INT PRIMARY KEY,
    nome VARCHAR(100)
);

INSERT INTO editoras (id_editora, nome) VALUES
(1, 'Companhia das Letras'),
(2, 'Penguin Random House'),
(3, 'Editora 34');

CREATE TABLE livros (
    id_livro INT PRIMARY KEY,
    titulo VARCHAR(100),
    autor_id INT,
    editora_id INT,
    FOREIGN KEY (autor_id) REFERENCES autores(id_autor),
    FOREIGN KEY (editora_id) REFERENCES editoras(id_editora)
);

INSERT INTO livros (id_livro, titulo, autor_id, editora_id) VALUES
(1, 'A Arte da Guerra', 1, 1),
(2, 'Dom Quixote', 2, 2),
(3, 'O Sr. dos Anéis', 3, 1),
(4, 'Crime e Castigo', 4, 3);

/* b) Selecione o título dos livros, o nome dos autores e o nome das editoras 
correspondentes*/

SELECT livros.titulo AS "Título do Livro", autores.nome AS "Nome do Autor", editoras.nome AS "Nome da Editora"
FROM livros 
INNER JOIN autores ON livros.autor_id = autores.id_autor
INNER JOIN editoras ON livros.editora_id = editoras.id_editora;

/*c) Conte quantos livros cada autor escreveu, incluindo autores que não têm livros 
publicados.*/

SELECT autores.nome AS "Nome do Autor", COUNT(livros.id_livro) AS "Quantidade de Livros"
FROM autores 
LEFT JOIN livros  ON autores.id_autor = livros.autor_id
GROUP BY autores.nome
ORDER BY autores.nome;

/*d) Liste os títulos dos livros e os nomes dos autores publicados pela editora 
"Companhia das Letras"*/

SELECT livros.titulo AS "Título do Livro", autores.nome AS "Nome do Autor"
FROM livros
INNER JOIN autores ON livros.autor_id = autores.id_autor
INNER JOIN editoras ON livros.editora_id = editoras.id_editora
WHERE editoras.nome = 'Companhia das Letras';

---------------02----------------

-- a) Crie as tabelas e as popule conforme os dados são apresentados.

CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nome VARCHAR(100)
);

INSERT INTO clientes (id_cliente, nome) VALUES
(1, 'João'),
(2, 'Maria'),
(3, 'Pedro');

CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY,
    id_cliente INT,
    data_pedido DATE,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

INSERT INTO pedidos (id_pedido, id_cliente, data_pedido) VALUES
(1, 1, '2023-01-10'),
(2, 2, '2023-01-12'),
(3, 1, '2023-01-15'),
(4, 3, '2023-01-18'),
(5, 2, '2023-01-20');

CREATE TABLE itens_pedido (
    id_item INT PRIMARY KEY,
    id_pedido INT,
    produto VARCHAR(100),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);


INSERT INTO itens_pedido (id_item, id_pedido, produto) VALUES
(1, 1, 'Livro'),
(2, 1, 'Caderno'),
(3, 2, 'Caneta'),
(4, 3, 'Livro'),
(5, 4, 'Caderno'),
(6, 5, 'Caneta');

/*b) Liste, usando junções, os clientes distintos que fizeram pedidos contendo o produto 
"Livro".*/

SELECT DISTINCT clientes.nome AS "Nome do Cliente"
FROM clientes 
JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente
JOIN itens_pedido ON pedidos.id_pedido = itens_pedido.id_pedido
WHERE itens_pedido.produto = 'Livro';

/*c) Liste, usando subconsulta e junção, os clientes distintos que fizeram pedidos 
contendo o produto "Livro". Dica: você pode utilizar a cláusula WHERE EXISTS (...)
para verificar se existe pelo menos um registro na subconsulta.*/

SELECT DISTINCT clientes.nome AS "Nome do Cliente"
FROM clientes 
JOIN pedidos  ON clientes.id_cliente = pedidos.id_cliente
WHERE EXISTS (
    SELECT 
    FROM itens_pedido 
    WHERE itens_pedido.id_pedido = pedidos.id_pedido
    AND itens_pedido.produto = 'Livro'
);

/*d) Liste o nome de cada cliente e o número total de pedidos que ele fez.*/

SELECT clientes.nome AS "Nome do Cliente", COUNT(pedidos.id_pedido) AS "Total de Pedidos"
FROM clientes 
LEFT JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente
GROUP BY clientes.nome;


/*e) Liste o número do pedido, o nome do cliente e todos os itens associados a cada 
pedido.*/

SELECT pedidos.id_pedido AS "Número do Pedido", clientes.nome AS "Nome do Cliente", itens_pedido.produto AS "Produto"
FROM pedidos
JOIN clientes ON pedidos.id_cliente = clientes.id_cliente
JOIN itens_pedido ON pedidos.id_pedido = itens_pedido.id_pedido
ORDER BY pedidos.id_pedido, itens_pedido.id_item;

/*f) Liste os nomes dos autores que têm mais de um livro publicado. Dica: A cláusula 
HAVING especifica quais registros agrupados são exibidos em uma instrução SELECT 
com uma cláusula GROUP BY. Depois que GROUP BY combina os registros, HAVING 
exibe todos os registros agrupados pela cláusula GROUP BY que satisfaçam as 
condições da cláusula HAVING
SELECT DISTINCT c.nome AS 'Nome do Cliente'
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
JOIN itens_pedido ip ON p.id_pedido = ip.id_pedido
WHERE ip.produto = 'Livro';*/

SELECT autores.nome AS "Nome do Autor"
FROM autores
INNER JOIN livros ON autores.id_autor = livros.autor_id
GROUP BY autores.id_autor, autores.nome
HAVING COUNT(livros.id_livro) > 1;

