# Criando um script SQL para um projeto lógico de uma montadora com complexidade similar
-- Banco de dados da Montadora
CREATE DATABASE Montadora;
USE Montadora;

-- Tabela de Fabricantes
CREATE TABLE Fabricantes (
    idFabricante INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    paisOrigem VARCHAR(50) NOT NULL
);

-- Tabela de Modelos
CREATE TABLE Modelos (
    idModelo INT AUTO_INCREMENT PRIMARY KEY,
    nomeModelo VARCHAR(50) NOT NULL,
    anoFabricacao YEAR NOT NULL,
    idFabricante INT NOT NULL,
    CONSTRAINT fk_modelo_fabricante FOREIGN KEY (idFabricante) REFERENCES Fabricantes(idFabricante) ON DELETE CASCADE
);

-- Tabela de Carros
CREATE TABLE Carros (
    idCarro INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(10) UNIQUE NOT NULL,
    cor VARCHAR(20),
    preco DECIMAL(10, 2) NOT NULL,
    idModelo INT NOT NULL,
    CONSTRAINT fk_carro_modelo FOREIGN KEY (idModelo) REFERENCES Modelos(idModelo) ON DELETE CASCADE
);

-- Tabela de Clientes (Física e Jurídica)
CREATE TABLE Clientes (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    tipoCliente ENUM('PF', 'PJ') NOT NULL,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11),
    cnpj CHAR(14),
    CONSTRAINT unique_document UNIQUE (cpf, cnpj),
    CONSTRAINT check_tipo_cliente CHECK (
        (tipoCliente = 'PF' AND cpf IS NOT NULL AND cnpj IS NULL) OR 
        (tipoCliente = 'PJ' AND cnpj IS NOT NULL AND cpf IS NULL)
    )
);

-- Tabela de Serviços
CREATE TABLE Servicos (
    idServico INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(255) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL
);

-- Tabela de Registro de Vendas
CREATE TABLE Vendas (
    idVenda INT AUTO_INCREMENT PRIMARY KEY,
    idCarro INT NOT NULL,
    idCliente INT NOT NULL,
    dataVenda DATE NOT NULL,
    CONSTRAINT fk_venda_carro FOREIGN KEY (idCarro) REFERENCES Carros(idCarro) ON DELETE SET NULL,
    CONSTRAINT fk_venda_cliente FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente) ON DELETE CASCADE
);

-- Tabela de Agendamentos de Serviço
CREATE TABLE Agendamentos (
    idAgendamento INT AUTO_INCREMENT PRIMARY KEY,
    idCarro INT NOT NULL,
    idServico INT NOT NULL,
    dataAgendamento DATE NOT NULL,
    CONSTRAINT fk_agendamento_carro FOREIGN KEY (idCarro) REFERENCES Carros(idCarro) ON DELETE CASCADE,
    CONSTRAINT fk_agendamento_servico FOREIGN KEY (idServico) REFERENCES Servicos(idServico) ON DELETE CASCADE
);

-- Fabricantes
INSERT INTO Fabricantes (nome, paisOrigem) VALUES 
('Toyota', 'Japão'),
('Ford', 'EUA'),
('Volkswagen', 'Alemanha');

-- Modelos
INSERT INTO Modelos (nomeModelo, anoFabricacao, idFabricante) VALUES 
('Corolla', 2023, 1),
('Mustang', 2022, 2),
('Golf', 2021, 3);

-- Carros
INSERT INTO Carros (placa, cor, preco, idModelo) VALUES 
('ABC-1234', 'Preto', 120000.00, 1),
('DEF-5678', 'Vermelho', 200000.00, 2),
('GHI-9012', 'Azul', 100000.00, 3);

-- Clientes
INSERT INTO Clientes (tipoCliente, nome, cpf, cnpj) VALUES 
('PF', 'João Silva', '12345678901', NULL),
('PF', 'Maria Oliveira', '98765432100', NULL),
('PJ', 'Empresa XYZ', NULL, '12345678000199');

-- Serviços
INSERT INTO Servicos (descricao, preco) VALUES 
('Troca de Óleo', 300.00),
('Revisão Completa', 1500.00);

-- Vendas
INSERT INTO Vendas (idCarro, idCliente, dataVenda) VALUES 
(1, 1, '2024-11-01'),
(2, 2, '2024-11-15');

-- Agendamentos
INSERT INTO Agendamentos (idCarro, idServico, dataAgendamento) VALUES 
(1, 1, '2024-12-01'),
(2, 2, '2024-12-05');

SELECT * FROM Carros;
SELECT nome, cpf FROM Clientes WHERE tipoCliente = 'PF';

SELECT * FROM Carros WHERE preco > 150000;
SELECT * FROM Vendas WHERE dataVenda BETWEEN '2024-11-01' AND '2024-11-30';

SELECT 
    nomeModelo, 
    preco, 
    (preco * 0.9) AS precoComDesconto 
FROM Carros;

SELECT * FROM Carros ORDER BY preco DESC;
SELECT * FROM Clientes ORDER BY nome ASC;

SELECT 
    idCliente, 
    COUNT(*) AS totalCompras 
FROM Vendas 
GROUP BY idCliente 
HAVING totalCompras > 1;

-- Lista de carros vendidos com informações dos clientes
SELECT 
    Carros.placa, 
    Carros.preco, 
    Clientes.nome AS cliente 
FROM Vendas
JOIN Carros ON Vendas.idCarro = Carros.idCarro
JOIN Clientes ON Vendas.idCliente = Clientes.idCliente;

-- Serviços agendados para carros
SELECT 
    Agendamentos.dataAgendamento, 
    Carros.placa, 
    Servicos.descricao 
FROM Agendamentos
JOIN Carros ON Agendamentos.idCarro = Carros.idCarro
JOIN Servicos ON Agendamentos.idServico = Servicos.idServico;


