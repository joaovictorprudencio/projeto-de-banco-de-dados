create database DB_biblioteca;

use DB_biblioteca;

CREATE TABLE tb_usuario (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    nome NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    telefone NVARCHAR(15),
    data_registro DATE DEFAULT CONVERT(DATE, GETDATE())
);

CREATE TABLE tb_autor (
    id_autor INT IDENTITY(1,1) PRIMARY KEY,
    nome NVARCHAR(100) NOT NULL
);

CREATE TABLE tb_genero (
    id_genero INT IDENTITY(1,1) PRIMARY KEY,
    descricao NVARCHAR(50) NOT NULL
);

CREATE TABLE tb_livro (
    id_livro INT IDENTITY(1,1) PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    id_autor INT NOT NULL,
    id_genero INT NOT NULL,
    ano_publicacao INT NOT NULL,
    quantidade INT DEFAULT 0,
    FOREIGN KEY (id_autor) REFERENCES tb_autor(id_autor),
    FOREIGN KEY (id_genero) REFERENCES tb_genero(id_genero)
);

CREATE TABLE tb_emprestimo (
    id_emprestimo INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_livro INT NOT NULL,
    data_emprestimo DATE DEFAULT CONVERT(DATE, GETDATE()),
    data_devolucao DATE,
    status NVARCHAR(10) CHECK (status IN ('PENDENTE', 'DEVOLVIDO')) DEFAULT 'PENDENTE',
    FOREIGN KEY (id_usuario) REFERENCES tb_usuario(id_usuario),
    FOREIGN KEY (id_livro) REFERENCES tb_livro(id_livro)
);

select * from tb_emprestimo;
select * from tb_livro;


  CREATE VIEW vw_status_emprestimo AS
  SELECT
   u.id_usuario as numero_cadastro,
   u.nome as cliente,
   l.titulo as livro,
   e.data_emprestimo as data_de_locacao,
   e.data_devolucao
 FROM tb_usuario u
       JOIN tb_emprestimo e ON u.id_usuario = e.id_usuario
	   JOIN tb_livro l on e.id_livro = l.id_livro;


 DROP VIEW IF EXISTS vw_status_emprestimo;

 SELECT * from vw_status_emprestimo;  	


select 
  l.titulo as livro,
  g.descricao as genero
  from tb_livro l   right join tb_genero g on l.id_genero = g.id_genero; 
 


SELECT 
    u.id_usuario AS numero_cadastro,
    u.nome AS cliente,
    e.data_emprestimo AS data_emprestimo,
    e.status AS status_emprestimo
FROM 
    tb_usuario u
JOIN 
    tb_emprestimo e ON u.id_usuario = e.id_usuario
WHERE 
    e.status = 'PENDENTE';



SELECT 
    l.titulo AS titulo_livro,
    a.nome AS autor
FROM 
    tb_livro l
LEFT JOIN 
    tb_emprestimo e ON l.id_livro = e.id_livro
JOIN 
    tb_autor a ON l.id_autor = a.id_autor
WHERE 
    e.id_emprestimo IS NULL;


DECLARE @cliente NVARCHAR(100);
SET @cliente = 'Maria Oliveira';

SELECT * FROM tb_usuario
WHERE nome = @cliente;


ALTER PROCEDURE GetEmprestimosCliente 
    @cliente NVARCHAR(100)
AS
BEGIN
    SELECT 
	  e.data_emprestimo AS data_da_aquisicao,
	  e.status AS devolucao,
	  l.titulo AS livro,
	  u.email
	FROM tb_emprestimo e 
	     join tb_usuario u on  e.id_usuario = u.id_usuario
		 join tb_livro l on e.id_livro = l.id_livro
    WHERE u.nome = @cliente; 
END


EXEC GetEmprestimosCliente @cliente = 'Rodrigo Azevedo';


 select * from tb_usuario



DROP TRIGGER trg_audit_emprestimo;


CREATE TRIGGER trg_audit_emprestimo
ON tb_emprestimo
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
  
    IF EXISTS (SELECT * FROM INSERTED)
    BEGIN
        INSERT INTO tb_auditoria (operacao, descricao, usuario)
        SELECT 'INSERT', 
               CONCAT('Empréstimo ID ', id_emprestimo, ' foi inserido'),
               SUSER_NAME()  
        FROM INSERTED;
    END

  
    IF EXISTS (SELECT * FROM INSERTED) AND EXISTS (SELECT * FROM DELETED)
    BEGIN
        INSERT INTO tb_auditoria (operacao, descricao, usuario)
        SELECT 'UPDATE', 
               CONCAT('Empréstimo ID ', id_emprestimo, ' foi atualizado'),
               SUSER_NAME() 
        FROM INSERTED;
    END

   
    IF EXISTS (SELECT * FROM DELETED)
    BEGIN
        INSERT INTO tb_auditoria (operacao, descricao, usuario)
        SELECT 'DELETE', 
               CONCAT('Empréstimo ID ', id_emprestimo, ' foi excluído'),
               SUSER_NAME()  
        FROM DELETED;
    END
END;


CREATE TABLE tb_auditoria (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    operacao NVARCHAR(10),
    data_hora DATETIME DEFAULT GETDATE(),
    descricao NVARCHAR(50)
);

 alter table tb_auditoria 
   add  usuario NVARCHAR(100)




  delete tb_emprestimo
    WHERE id_emprestimo = 24;

select * from tb_emprestimo;

select* FROM tb_auditoria;

INSERT INTO tb_emprestimo (id_usuario, id_livro, data_devolucao, status)
VALUES (1, 2, '2024-12-31', 'PENDENTE');

UPDATE tb_emprestimo
   SET id_usuario = 2
    WHERE id_emprestimo = 24;   

	UPDATE tb_autor
     SET nome = 'Carlos magnos'
    WHERE id_autor = 19; 


select * from tb_autor;
select * from tb_livro;


DELETE FROM tb_emprestimo
WHERE id_emprestimo = 1;



INSERT INTO tb_usuario(nome, email, telefone, data_registro) VALUES 
('João Silva', 'joao.silva@email.com', '(11) 98888-7777', '2024-01-15'),
('Maria Oliveira', 'maria.oliveira@email.com', '(21) 97777-6666', '2024-02-10'),
('Carlos Souza', 'carlos.souza@email.com', '(31) 96666-5555', '2024-03-05'),
('Ana Pereira', 'ana.pereira@email.com', '(41) 95555-4444', '2024-04-12'),
('Pedro Santos', 'pedro.santos@email.com', '(51) 94444-3333', '2024-05-01'),
('Beatriz Costa', 'beatriz.costa@email.com', '(61) 93333-2222', '2024-06-20'),
('Lucas Lima', 'lucas.lima@email.com', '(71) 92222-1111', '2024-07-15'),
('Fernanda Gomes', 'fernanda.gomes@email.com', '(81) 91111-0000', '2024-08-18'),
('Rafael Almeida', 'rafael.almeida@email.com', '(91) 90000-8888', '2024-09-25'),
('Juliana Mendes', 'juliana.mendes@email.com', '(51) 98888-9999', '2024-10-02'),
('Ricardo Teixeira', 'ricardo.teixeira@email.com', '(11) 97777-7777', '2024-11-12'),
('Patrícia Nogueira', 'patricia.nogueira@email.com', '(21) 96666-6666', '2024-12-01'),
('Rodrigo Azevedo', 'rodrigo.azevedo@email.com', '(31) 95555-5555', '2024-01-10'),
('Camila Duarte', 'camila.duarte@email.com', '(41) 94444-4444', '2024-02-14'),
('Fábio Reis', 'fabio.reis@email.com', '(51) 93333-3333', '2024-03-30'),
('Isabela Martins', 'isabela.martins@email.com', '(61) 92222-2222', '2024-04-08'),
('Diego Rocha', 'diego.rocha@email.com', '(71) 91111-1111', '2024-05-17'),
('Larissa Barbosa', 'larissa.barbosa@email.com', '(81) 90000-0000', '2024-06-22'),
('Gustavo Ferreira', 'gustavo.ferreira@email.com', '(91) 98888-1234', '2024-07-30'),
('Carla Figueiredo', 'carla.figueiredo@email.com', '(51) 97777-5678', '2024-08-19');

INSERT INTO tb_autor (nome) VALUES
('Machado de Assis'),
('Clarice Lispector'),
('Guimarães Rosa'),
('Graciliano Ramos'),
('Jorge Amado'),
('Monteiro Lobato'),
('Cecília Meireles'),
('Carlos Drummond de Andrade'),
('Vinícius de Moraes'),
('Manuel Bandeira'),
('João Cabral de Melo Neto'),
('Érico Veríssimo'),
('Lima Barreto'),
('Rubem Fonseca'),
('Nelson Rodrigues'),
('José Saramago'),
('Fernando Pessoa'),
('Eça de Queirós'),
('Mia Couto'),
('Camões');

INSERT INTO tb_genero (descricao) VALUES
('Ficção'),
('Romance'),
('Mistério'),
('Aventura'),
('Drama'),
('Fantasia'),
('Terror'),
('Suspense'),
('Histórico'),
('Biografia'),
('Poesia'),
('Crônica'),
('Infantil'),
('Jovem Adulto'),
('Científico'),
('Técnico'),
('Policial'),
('Dramédia'),
('Comédia');


INSERT INTO tb_livro (titulo, id_autor, id_genero, ano_publicacao, quantidade) VALUES
('Dom Casmurro', 1, 2, 1899, 10),
('A Hora da Estrela', 2, 1, 1977, 5),
('Grande Sertão: Veredas', 3, 2, 1956, 7),
('Vidas Secas', 4, 2, 1938, 8),
('Capitães da Areia', 5, 2, 1937, 6),
('O Sítio do Picapau Amarelo', 6, 13, 1920, 12),
('Meus Amigos', 7, 11, 1961, 4),
('Alguma Poesia', 8, 11, 1930, 9),
('O Corvo', 9, 11, 1935, 11),
('O Rio', 10, 11, 1955, 6),
('O Cabeleireiro', 11, 4, 1967, 3),
('A Moreninha', 12, 2, 1844, 7),
('A Moreninha II', 12, 2, 1845, 8),
('A Menina que Roubava Livros', 13, 1, 2005, 15),
('O Hobbit', 14, 6, 1937, 10),
('O Senhor dos Anéis', 14, 6, 1954, 14),
('Dom Quixote', 15, 2, 1605, 5),
('As Aventuras de Sherlock Holmes', 16, 3, 1892, 13),
('A Revolução dos Bichos', 17, 2, 1945, 9),
('O Processo', 18, 2, 1925, 7);

INSERT INTO tb_emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES
(1, 1, '2024-11-01', NULL, 'PENDENTE'),
(2, 3, '2024-11-03', NULL, 'PENDENTE'),
(3, 5, '2024-11-05', '2024-11-20', 'DEVOLVIDO'),
(4, 7, '2024-11-06', NULL, 'PENDENTE'),
(5, 2, '2024-11-07', NULL, 'PENDENTE'),
(6, 8, '2024-11-10', '2024-11-24', 'DEVOLVIDO'),
(7, 9, '2024-11-11', NULL, 'PENDENTE'),
(8, 10, '2024-11-12', '2024-11-26', 'DEVOLVIDO'),
(9, 11, '2024-11-13', NULL, 'PENDENTE'),
(10, 12, '2024-11-14', '2024-11-28', 'DEVOLVIDO'),
(11, 13, '2024-11-15', NULL, 'PENDENTE'),
(12, 14, '2024-11-17', NULL, 'PENDENTE'),
(13, 15, '2024-11-18', '2024-12-02', 'DEVOLVIDO'),
(14, 16, '2024-11-20', NULL, 'PENDENTE'),
(15, 17, '2024-11-21', '2024-12-05', 'DEVOLVIDO'),
(16, 18, '2024-11-22', NULL, 'PENDENTE'),
(17, 19, '2024-11-23', '2024-12-07', 'DEVOLVIDO'),
(18, 20, '2024-11-25', NULL, 'PENDENTE'),
(19, 1, '2024-11-26', '2024-12-10', 'DEVOLVIDO'),
(20, 2, '2024-11-28', NULL, 'PENDENTE');


