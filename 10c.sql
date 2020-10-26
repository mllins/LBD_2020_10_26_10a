CREATE DATABASE Aula_2020_10_26
GO
USE Aula_2020_10_26

CREATE TABLE curso (
codigo			INT,
nome			VARCHAR(100),
duracao			INT
PRIMARY KEY(codigo))

CREATE TABLE disciplina (
codigo			INT,
nome			VARCHAR(100),
carga_horaria	INT
PRIMARY KEY (codigo))

CREATE TABLE disciplina_curso (
codigo_disciplina	INT,
codigo_curso		INT
PRIMARY KEY(codigo_curso,codigo_disciplina),
FOREIGN KEY(codigo_curso) REFERENCES curso(codigo),
FOREIGN KEY(codigo_disciplina) REFERENCES disciplina(codigo))

INSERT INTO curso VALUES 
(0, 'Análise e Desenvolvimento de Sistemas', 2880),
(1, 'Logistica', 2880),
(2, 'Polímeros', 2880),
(3, 'Comércio Exterior', 2600),
(4, 'Gestão Empresarial', 2600)

INSERT INTO disciplina VALUES
(1, 'Algoritmos', 80),
(2, 'Administração', 80),
(3, 'Laboratório de Hardware', 40),
(4, 'Pesquisa Operacional', 80),
(5, 'Física I', 80),
(6, 'Físico Química', 80),
(7, 'Comércio Exterior', 80),
(8, 'Fundamentos de Marketing', 80),
(9, 'Informática', 40),
(10, 'Sistemas de Informação', 80)

INSERT INTO disciplina_curso VALUES
(1, 0),
(2, 0),
(2, 1),
(2, 3),
(2, 4),
(3, 0),
(4, 1),
(5, 2),
(6, 2),
(7, 1),
(7, 3),
(8, 1),
(8, 4),
(9, 1),
(9, 3),
(10, 0),
(10, 4)

CREATE FUNCTION fn_busca_informacoes (@codigo	INT)
RETURNS @tabela TABLE (
	codigo			INT,
	nome			VARCHAR(100),
	carga_horaria	INT)
BEGIN
	DECLARE c_disciplina_curso CURSOR FOR SELECT codigo_disciplina 
			FROM disciplina_curso WHERE codigo_curso = @codigo
	DECLARE @codigo_disciplina		INT

	OPEN c_disciplina_curso
	FETCH NEXT FROM c_disciplina_curso INTO @codigo_disciplina
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO @tabela SELECT codigo, nome, carga_horaria FROM disciplina 
				WHERE codigo = @codigo_disciplina
		FETCH NEXT FROM c_disciplina_curso INTO @codigo_disciplina
	END
	RETURN
END

SELECT * FROM fn_busca_informacoes(0)
