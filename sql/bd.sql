-- ============================================
-- Script de População do Banco de Dados
-- Sistema de Refeições
-- Executar como root ou usuário com privilégios
-- ============================================

-- Drop e recriação do banco de dados
DROP DATABASE IF EXISTS refeicoes;
CREATE DATABASE refeicoes;

-- Selecionar o banco de dados
USE refeicoes;

-- ============================================
-- Criação de Tabelas
-- ============================================

-- Tabela: refeicao
-- Armazena registros de refeições por estudante e data
CREATE TABLE refeicao (
    id_cartao VARCHAR(20) NOT NULL,
    data_refeicao DATE NOT NULL,
    PRIMARY KEY (id_cartao, data_refeicao)
) ENGINE=InnoDB;
