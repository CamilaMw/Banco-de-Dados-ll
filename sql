--ATIVIDADE DE BANCO DE DADOS ll--

---- EXERCICIO 1 --

CREATE TABLE pessoa (
    codigo_pessoa SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

INSERT INTO pessoa (nome) VALUES ('Pedro');
INSERT INTO pessoa (nome) VALUES ('Ana');
INSERT INTO pessoa (nome) VALUES ('Gabriel');

CREATE TABLE postagem (
    codigo_postagem SERIAL PRIMARY KEY,
    conteudo TEXT,
    codigo_pessoa INTEGER,
    FOREIGN KEY (codigo_pessoa) REFERENCES pessoa(codigo_pessoa)
);

CREATE TABLE comentario (
    codigo_comentario SERIAL PRIMARY KEY,
    conteudo TEXT,
    codigo_pessoa INTEGER,
    codigo_respondido INTEGER,
    postagem_comentada INTEGER,
    FOREIGN KEY (codigo_pessoa) REFERENCES pessoa(codigo_pessoa),
    FOREIGN KEY (codigo_respondido) REFERENCES comentario(codigo_comentario),
    FOREIGN KEY (postagem_comentada) REFERENCES postagem(codigo_postagem)
);

SELECT * FROM pessoa

INSERT INTO postagem (conteudo, cod_pessoa) 
VALUES
('Hoje eu acordei feliz =)', 1);

SELECT * FROM postagem

SELECT nome, conteudo FROM pessoa, postagem WHERE pessoa.cod_pessoa=postagem.cod_pessoa;

INSERT INTO comentario (conteudo, cod_pessoa, cod_postagem )
VALUES
('O que houve para tanta felicidade?', 2, 1);

SELECT * FROM postagem, comentario

SELECT * FROM comentario

INSERT INTO comentario (conteudo, cod_pessoa, com_respondido, cod_postagem)
VALUES
('Hoje é aula de BD!', 1, 1, 1);



--TESTE--

SELECT pessoa.nome, postagem.conteudo, comentario.cod_pessoa, comentario.conteudo
FROM pessoa
INNER JOIN postagem ON pessoa.cod_pessoa = postagem.cod_pessoa
INNER JOIN comentario ON comentario.cod_postagem=postagem.cod_postagem

SELECT pessoa.nome, postagem.conteudo
FROM pessoa
INNER JOIN postagem
ON pessoa.cod_pessoa = postagem.cod_pessoa


-- EXERCICIO 2 --

CREATE TABLE banco(
	codigo SERIAL PRIMARY KEY,
	nome VARCHAR(100)
);

CREATE TABLE agencia(
	numero_agencia VARCHAR(20) PRIMARY KEY,
	endereco VARCHAR(255),
	cod_banco INTEGER NOT NULL,
	FOREIGN KEY (cod_banco) REFERENCES banco(codigo)
);

CREATE TABLE cliente(
	cpf VARCHAR(20) PRIMARY KEY,
	nome VARCHAR(100),
	sexo VARCHAR(25),
	endereco VARCHAR(255)
);

CREATE TABLE conta(
	numero_conta VARCHAR(20) PRIMARY KEY,
	saldo NUMERIC(10,2),
	tipo_conta INTEGER,
	num_agencia VARCHAR(20) NOT NULL,
	FOREIGN KEY (num_agencia) REFERENCES agencia(numero_agencia)
);

CREATE TABLE historico(
	cpf VARCHAR(20) NOT NULL,
	num_conta VARCHAR(20) NOT NULL,
	data_inicio DATE,
	FOREIGN KEY (cpf) REFERENCES cliente(cpf),
	FOREIGN KEY (num_conta) REFERENCES conta(numero_conta)
);

CREATE TABLE telefone_cliente(
	cpf_cli VARCHAR(20) NOT NULL,
	telefone_cli VARCHAR(20) PRIMARY KEY,
	FOREIGN KEY (cpf_cli) REFERENCES cliente(cpf)
);

-- EXERCICIO 3 --

INSERT INTO banco(codigo, nome) 
VALUES 
(1, 'Banco do Brasil'),
(4, 'CEF');

SELECT * FROM banco

INSERT INTO agencia(numero_agencia, endereco, cod_banco)
VALUES
('0562', 'Rua Joaquim Teixeira Alves, 1555', 4),
('3153', 'Av. Marcelino Pires, 1960', 1);

SELECT * FROM agencia

INSERT INTO cliente(cpf, nome, sexo, endereco)
VALUES
('111.222.333-44', 'Jennifer B Souza', 'F', 'Rua Cuiabá, 1050'),
('666.777.888-99', 'Caetano K Lima', 'M', 'Rua Ivinhema, 879'),
('555.444.777-33', 'Silvia Macedo', 'F', 'Rua Estados Unidos, 735');

SELECT * FROM cliente

INSERT INTO conta(numero_conta, saldo, tipo_conta, num_agencia)
VALUES
('86340-2', 763.05, 2, '3153'),
('23584-7', 3879.12, 1, '0562');

SELECT * FROM conta

INSERT INTO historico(cpf, num_conta, data_inicio)
VALUES
('111.222.333-44', '23584-7', '17-12-1997'),
('666.777.888-99', '23584-7', '17-12-1997'),
('555.444.777-33', '86340-2', '29-11-2010');

SELECT * FROM historico

INSERT INTO telefone_cliente(cpf_cli, telefone_cli)
VALUES
('111.222.333-44', '(67)3422-7788'),
('666.777.888-99', '(67)3423-9900'),
('666.777.888-99', '(67)8121-8833');

SELECT * FROM telefone_cliente

-- EXERCICIO 4 --

ALTER TABLE cliente ADD COLUMN email VARCHAR(30);

SELECT * FROM cliente