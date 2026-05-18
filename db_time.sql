-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Tempo de geração: 18/05/2026 às 17:27
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `db_time`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_times`
--

CREATE TABLE `tb_times` (
  `cod_time` int(11) NOT NULL,
  `nome_time` varchar(100) NOT NULL,
  `sigla_time` varchar(17) NOT NULL,
  `estado_time` varchar(50) NOT NULL,
  `pais_time` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `tb_times`
--

INSERT INTO `tb_times` (`cod_time`, `nome_time`, `sigla_time`, `estado_time`, `pais_time`) VALUES
(1, 'Manchester City', 'MCI', 'Trafford', 'Inglaterra'),
(2, 'Real Madrid', 'RMA', 'Madrid', 'Espanha'),
(3, 'Barcelona', 'BAR', 'Catalunha', 'Espanha'),
(4, 'Bayern de Munique', 'BAY', 'Baviera', 'Alemanha'),
(5, 'Paris Saint-Germain', 'PSG', 'Paris', 'França'),
(6, 'Juventus', 'JUV', 'Turim', 'Itália'),
(7, 'Ajax', 'AJA', 'Amsterdã', 'Holanda'),
(8, 'Benfica', 'BEN', 'Lisboa', 'Portugal'),
(9, 'Galatasaray', 'GAL', 'Istambul', 'Turquia'),
(10, 'Al Hilal', 'HIL', 'Riade', 'Arábia Saudita'),
(11, 'River Plate', 'RIV', 'Buenos Aires', 'Argentina'),
(12, 'Boca Juniors', 'BOC', 'Buenos Aires', 'Argentina'),
(13, 'Flamengo', 'FLA', 'Rio de Janeiro', 'Brasil'),
(14, 'Palmeiras', 'PAL', 'São Paulo', 'Brasil'),
(15, 'Atlético Nacional', 'ATN', 'Medellín', 'Colômbia'),
(16, 'América do México', 'AME', 'Cidade do México', 'México'),
(17, 'LA Galaxy', 'LAG', 'Califórnia', 'Estados Unidos'),
(18, 'Toronto FC', 'TOR', 'Ontário', 'Canadá'),
(19, 'Kashima Antlers', 'KAS', 'Ibaraki', 'Japão'),
(20, 'Jeonbuk Hyundai Motors', 'JEO', 'Jeonju', 'Coreia do Sul'),
(21, 'Al Ahly', 'AHL', 'Cairo', 'Egito'),
(22, 'Kaizer Chiefs', 'KAI', 'Joanesburgo', 'África do Sul');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `tb_times`
--
ALTER TABLE `tb_times`
  ADD PRIMARY KEY (`cod_time`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `tb_times`
--
ALTER TABLE `tb_times`
  MODIFY `cod_time` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
