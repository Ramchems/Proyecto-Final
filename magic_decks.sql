-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 14-11-2024 a las 23:28:37
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `magic_decks`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `deck_id` int(11) DEFAULT NULL,
  `comment` text DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `comments`
--

INSERT INTO `comments` (`id`, `user_id`, `deck_id`, `comment`, `timestamp`) VALUES
(1, 8, 5, 'Hola, me encanta el deck', '2024-11-13 14:37:14'),
(2, 8, 5, 'Hola, me encanta el deck', '2024-11-13 14:37:14'),
(3, 8, 5, 'hola', '2024-11-13 14:37:50'),
(4, 8, 5, 'hola', '2024-11-13 14:37:50'),
(5, 8, 5, '', '2024-11-13 14:37:56'),
(6, 8, 5, 'GRacias', '2024-11-13 14:38:06'),
(7, 8, 5, 'GRacias', '2024-11-13 14:38:06'),
(8, 8, 4, 'Esto es un comentario', '2024-11-13 14:40:09'),
(9, 8, 4, 'Esto es un comentario', '2024-11-13 14:40:09'),
(10, 8, 6, 'Comentario en deck actual', '2024-11-13 23:51:55'),
(11, 8, 6, 'Comentario en deck actual', '2024-11-13 23:51:55'),
(12, 6, 6, 'Segunda prueba de comentarios', '2024-11-13 23:52:21'),
(13, 6, 6, 'Segunda prueba de comentarios', '2024-11-13 23:52:21'),
(14, 6, 6, 'hola', '2024-11-13 23:53:36'),
(15, 6, 6, 'esto es otro comentario', '2024-11-13 23:53:42'),
(16, 2, 5, 'Otro comentario', '2024-11-13 23:54:19'),
(17, 7, 7, 'Comentario bonito\n', '2024-11-13 23:58:25'),
(18, 8, 3, 'Este deck es mio y me encanta', '2024-11-14 00:14:27');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `decks`
--

CREATE TABLE `decks` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `colors` varchar(10) DEFAULT NULL,
  `likes` int(11) DEFAULT 0,
  `average_rating` float DEFAULT 0,
  `commander` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`commander`)),
  `cards` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`cards`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `decks`
--

INSERT INTO `decks` (`id`, `user_id`, `name`, `description`, `colors`, `likes`, `average_rating`, `commander`, `cards`) VALUES
(3, 8, 'rojo', NULL, NULL, 1, 0, '{\"id\":\"175b3d28-5c74-4972-9b5c-5e39762c78f4\",\"name\":\"Relic of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/1/7/175b3d28-5c74-4972-9b5c-5e39762c78f4.jpg?1686964447\"}', '[{\"id\":\"175b3d28-5c74-4972-9b5c-5e39762c78f4\",\"name\":\"Relic of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/1/7/175b3d28-5c74-4972-9b5c-5e39762c78f4.jpg?1686964447\"},{\"id\":\"175b3d28-5c74-4972-9b5c-5e39762c78f4\",\"name\":\"Relic of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/1/7/175b3d28-5c74-4972-9b5c-5e39762c78f4.jpg?1686964447\"},{\"id\":\"175b3d28-5c74-4972-9b5c-5e39762c78f4\",\"name\":\"Relic of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/1/7/175b3d28-5c74-4972-9b5c-5e39762c78f4.jpg?1686964447\"},{\"id\":\"175b3d28-5c74-4972-9b5c-5e39762c78f4\",\"name\":\"Relic of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/1/7/175b3d28-5c74-4972-9b5c-5e39762c78f4.jpg?1686964447\"},{\"id\":\"fc53dec0-79fe-4f6f-9d5b-cf298588e808\",\"name\":\"Sauron, Lord of the Rings\",\"image\":\"https://cards.scryfall.io/normal/front/f/c/fc53dec0-79fe-4f6f-9d5b-cf298588e808.jpg?1686963724\"},{\"id\":\"fc53dec0-79fe-4f6f-9d5b-cf298588e808\",\"name\":\"Sauron, Lord of the Rings\",\"image\":\"https://cards.scryfall.io/normal/front/f/c/fc53dec0-79fe-4f6f-9d5b-cf298588e808.jpg?1686963724\"},{\"id\":\"6b98850c-ad69-42da-b91a-8dc5e226c444\",\"name\":\"Sauron\'s Ransom\",\"image\":\"https://cards.scryfall.io/normal/front/6/b/6b98850c-ad69-42da-b91a-8dc5e226c444.jpg?1686970005\"},{\"id\":\"6b98850c-ad69-42da-b91a-8dc5e226c444\",\"name\":\"Sauron\'s Ransom\",\"image\":\"https://cards.scryfall.io/normal/front/6/b/6b98850c-ad69-42da-b91a-8dc5e226c444.jpg?1686970005\"},{\"id\":\"6b98850c-ad69-42da-b91a-8dc5e226c444\",\"name\":\"Sauron\'s Ransom\",\"image\":\"https://cards.scryfall.io/normal/front/6/b/6b98850c-ad69-42da-b91a-8dc5e226c444.jpg?1686970005\"},{\"id\":\"7d86dc2e-6f0c-4714-9d30-5d099d3b895c\",\"name\":\"Frodo, Sauron\'s Bane\",\"image\":\"https://cards.scryfall.io/normal/front/7/d/7d86dc2e-6f0c-4714-9d30-5d099d3b895c.jpg?1686967812\"},{\"id\":\"7d86dc2e-6f0c-4714-9d30-5d099d3b895c\",\"name\":\"Frodo, Sauron\'s Bane\",\"image\":\"https://cards.scryfall.io/normal/front/7/d/7d86dc2e-6f0c-4714-9d30-5d099d3b895c.jpg?1686967812\"},{\"id\":\"7d86dc2e-6f0c-4714-9d30-5d099d3b895c\",\"name\":\"Frodo, Sauron\'s Bane\",\"image\":\"https://cards.scryfall.io/normal/front/7/d/7d86dc2e-6f0c-4714-9d30-5d099d3b895c.jpg?1686967812\"},{\"id\":\"76a88814-aa30-4297-b338-3d851bfe7256\",\"name\":\"The Mouth of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/7/6/76a88814-aa30-4297-b338-3d851bfe7256.jpg?1686969905\"},{\"id\":\"76a88814-aa30-4297-b338-3d851bfe7256\",\"name\":\"The Mouth of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/7/6/76a88814-aa30-4297-b338-3d851bfe7256.jpg?1686969905\"},{\"id\":\"377d65d8-21c8-4292-97db-610e0173ba59\",\"name\":\"Sauron, the Necromancer\",\"image\":\"https://cards.scryfall.io/normal/front/3/7/377d65d8-21c8-4292-97db-610e0173ba59.jpg?1686968699\"},{\"id\":\"377d65d8-21c8-4292-97db-610e0173ba59\",\"name\":\"Sauron, the Necromancer\",\"image\":\"https://cards.scryfall.io/normal/front/3/7/377d65d8-21c8-4292-97db-610e0173ba59.jpg?1686968699\"},{\"id\":\"d82a4c78-d2fc-425a-8d0e-2e64509a08f1\",\"name\":\"Sauron, the Lidless Eye\",\"image\":\"https://cards.scryfall.io/normal/front/d/8/d82a4c78-d2fc-425a-8d0e-2e64509a08f1.jpg?1715720382\"},{\"id\":\"d82a4c78-d2fc-425a-8d0e-2e64509a08f1\",\"name\":\"Sauron, the Lidless Eye\",\"image\":\"https://cards.scryfall.io/normal/front/d/8/d82a4c78-d2fc-425a-8d0e-2e64509a08f1.jpg?1715720382\"}]'),
(4, 4, 'rojo', NULL, NULL, 6, 0, '{\"id\":\"7d86dc2e-6f0c-4714-9d30-5d099d3b895c\",\"name\":\"Frodo, Sauron\'s Bane\",\"image\":\"https://cards.scryfall.io/normal/front/7/d/7d86dc2e-6f0c-4714-9d30-5d099d3b895c.jpg?1686967812\"}', '[{\"id\":\"7d86dc2e-6f0c-4714-9d30-5d099d3b895c\",\"name\":\"Frodo, Sauron\'s Bane\",\"image\":\"https://cards.scryfall.io/normal/front/7/d/7d86dc2e-6f0c-4714-9d30-5d099d3b895c.jpg?1686967812\"},{\"id\":\"7d86dc2e-6f0c-4714-9d30-5d099d3b895c\",\"name\":\"Frodo, Sauron\'s Bane\",\"image\":\"https://cards.scryfall.io/normal/front/7/d/7d86dc2e-6f0c-4714-9d30-5d099d3b895c.jpg?1686967812\"},{\"id\":\"175b3d28-5c74-4972-9b5c-5e39762c78f4\",\"name\":\"Relic of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/1/7/175b3d28-5c74-4972-9b5c-5e39762c78f4.jpg?1686964447\"},{\"id\":\"175b3d28-5c74-4972-9b5c-5e39762c78f4\",\"name\":\"Relic of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/1/7/175b3d28-5c74-4972-9b5c-5e39762c78f4.jpg?1686964447\"},{\"id\":\"fc53dec0-79fe-4f6f-9d5b-cf298588e808\",\"name\":\"Sauron, Lord of the Rings\",\"image\":\"https://cards.scryfall.io/normal/front/f/c/fc53dec0-79fe-4f6f-9d5b-cf298588e808.jpg?1686963724\"},{\"id\":\"fc53dec0-79fe-4f6f-9d5b-cf298588e808\",\"name\":\"Sauron, Lord of the Rings\",\"image\":\"https://cards.scryfall.io/normal/front/f/c/fc53dec0-79fe-4f6f-9d5b-cf298588e808.jpg?1686963724\"},{\"id\":\"6b98850c-ad69-42da-b91a-8dc5e226c444\",\"name\":\"Sauron\'s Ransom\",\"image\":\"https://cards.scryfall.io/normal/front/6/b/6b98850c-ad69-42da-b91a-8dc5e226c444.jpg?1686970005\"},{\"id\":\"6b98850c-ad69-42da-b91a-8dc5e226c444\",\"name\":\"Sauron\'s Ransom\",\"image\":\"https://cards.scryfall.io/normal/front/6/b/6b98850c-ad69-42da-b91a-8dc5e226c444.jpg?1686970005\"},{\"id\":\"fc53dec0-79fe-4f6f-9d5b-cf298588e808\",\"name\":\"Sauron, Lord of the Rings\",\"image\":\"https://cards.scryfall.io/normal/front/f/c/fc53dec0-79fe-4f6f-9d5b-cf298588e808.jpg?1686963724\"},{\"id\":\"fc53dec0-79fe-4f6f-9d5b-cf298588e808\",\"name\":\"Sauron, Lord of the Rings\",\"image\":\"https://cards.scryfall.io/normal/front/f/c/fc53dec0-79fe-4f6f-9d5b-cf298588e808.jpg?1686963724\"},{\"id\":\"175b3d28-5c74-4972-9b5c-5e39762c78f4\",\"name\":\"Relic of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/1/7/175b3d28-5c74-4972-9b5c-5e39762c78f4.jpg?1686964447\"},{\"id\":\"7d86dc2e-6f0c-4714-9d30-5d099d3b895c\",\"name\":\"Frodo, Sauron\'s Bane\",\"image\":\"https://cards.scryfall.io/normal/front/7/d/7d86dc2e-6f0c-4714-9d30-5d099d3b895c.jpg?1686967812\"},{\"id\":\"7d86dc2e-6f0c-4714-9d30-5d099d3b895c\",\"name\":\"Frodo, Sauron\'s Bane\",\"image\":\"https://cards.scryfall.io/normal/front/7/d/7d86dc2e-6f0c-4714-9d30-5d099d3b895c.jpg?1686967812\"},{\"id\":\"175b3d28-5c74-4972-9b5c-5e39762c78f4\",\"name\":\"Relic of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/1/7/175b3d28-5c74-4972-9b5c-5e39762c78f4.jpg?1686964447\"},{\"id\":\"fc53dec0-79fe-4f6f-9d5b-cf298588e808\",\"name\":\"Sauron, Lord of the Rings\",\"image\":\"https://cards.scryfall.io/normal/front/f/c/fc53dec0-79fe-4f6f-9d5b-cf298588e808.jpg?1686963724\"},{\"id\":\"6b98850c-ad69-42da-b91a-8dc5e226c444\",\"name\":\"Sauron\'s Ransom\",\"image\":\"https://cards.scryfall.io/normal/front/6/b/6b98850c-ad69-42da-b91a-8dc5e226c444.jpg?1686970005\"}]'),
(5, 4, 'azul', NULL, NULL, 5, 0, '{\"id\":\"7d86dc2e-6f0c-4714-9d30-5d099d3b895c\",\"name\":\"Frodo, Sauron\'s Bane\",\"image\":\"https://cards.scryfall.io/normal/front/7/d/7d86dc2e-6f0c-4714-9d30-5d099d3b895c.jpg?1686967812\"}', '[{\"id\":\"7d86dc2e-6f0c-4714-9d30-5d099d3b895c\",\"name\":\"Frodo, Sauron\'s Bane\",\"image\":\"https://cards.scryfall.io/normal/front/7/d/7d86dc2e-6f0c-4714-9d30-5d099d3b895c.jpg?1686967812\"},{\"id\":\"7d86dc2e-6f0c-4714-9d30-5d099d3b895c\",\"name\":\"Frodo, Sauron\'s Bane\",\"image\":\"https://cards.scryfall.io/normal/front/7/d/7d86dc2e-6f0c-4714-9d30-5d099d3b895c.jpg?1686967812\"},{\"id\":\"175b3d28-5c74-4972-9b5c-5e39762c78f4\",\"name\":\"Relic of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/1/7/175b3d28-5c74-4972-9b5c-5e39762c78f4.jpg?1686964447\"},{\"id\":\"175b3d28-5c74-4972-9b5c-5e39762c78f4\",\"name\":\"Relic of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/1/7/175b3d28-5c74-4972-9b5c-5e39762c78f4.jpg?1686964447\"},{\"id\":\"175b3d28-5c74-4972-9b5c-5e39762c78f4\",\"name\":\"Relic of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/1/7/175b3d28-5c74-4972-9b5c-5e39762c78f4.jpg?1686964447\"},{\"id\":\"fc53dec0-79fe-4f6f-9d5b-cf298588e808\",\"name\":\"Sauron, Lord of the Rings\",\"image\":\"https://cards.scryfall.io/normal/front/f/c/fc53dec0-79fe-4f6f-9d5b-cf298588e808.jpg?1686963724\"},{\"id\":\"fc53dec0-79fe-4f6f-9d5b-cf298588e808\",\"name\":\"Sauron, Lord of the Rings\",\"image\":\"https://cards.scryfall.io/normal/front/f/c/fc53dec0-79fe-4f6f-9d5b-cf298588e808.jpg?1686963724\"},{\"id\":\"fc53dec0-79fe-4f6f-9d5b-cf298588e808\",\"name\":\"Sauron, Lord of the Rings\",\"image\":\"https://cards.scryfall.io/normal/front/f/c/fc53dec0-79fe-4f6f-9d5b-cf298588e808.jpg?1686963724\"},{\"id\":\"fc53dec0-79fe-4f6f-9d5b-cf298588e808\",\"name\":\"Sauron, Lord of the Rings\",\"image\":\"https://cards.scryfall.io/normal/front/f/c/fc53dec0-79fe-4f6f-9d5b-cf298588e808.jpg?1686963724\"}]'),
(6, 8, 'Sauron', NULL, NULL, 4, 0, '{\"id\":\"034e0929-b2c7-4b5f-94f2-8eaf4fb1a2a1\",\"name\":\"Sauron, the Dark Lord\",\"image\":\"https://cards.scryfall.io/normal/front/0/3/034e0929-b2c7-4b5f-94f2-8eaf4fb1a2a1.jpg?1693611218\"}', '[{\"id\":\"d82a4c78-d2fc-425a-8d0e-2e64509a08f1\",\"name\":\"Sauron, the Lidless Eye\",\"image\":\"https://cards.scryfall.io/normal/front/d/8/d82a4c78-d2fc-425a-8d0e-2e64509a08f1.jpg?1715720382\"},{\"id\":\"034e0929-b2c7-4b5f-94f2-8eaf4fb1a2a1\",\"name\":\"Sauron, the Dark Lord\",\"image\":\"https://cards.scryfall.io/normal/front/0/3/034e0929-b2c7-4b5f-94f2-8eaf4fb1a2a1.jpg?1693611218\"},{\"id\":\"d82a4c78-d2fc-425a-8d0e-2e64509a08f1\",\"name\":\"Sauron, the Lidless Eye\",\"image\":\"https://cards.scryfall.io/normal/front/d/8/d82a4c78-d2fc-425a-8d0e-2e64509a08f1.jpg?1715720382\"},{\"id\":\"d82a4c78-d2fc-425a-8d0e-2e64509a08f1\",\"name\":\"Sauron, the Lidless Eye\",\"image\":\"https://cards.scryfall.io/normal/front/d/8/d82a4c78-d2fc-425a-8d0e-2e64509a08f1.jpg?1715720382\"},{\"id\":\"d82a4c78-d2fc-425a-8d0e-2e64509a08f1\",\"name\":\"Sauron, the Lidless Eye\",\"image\":\"https://cards.scryfall.io/normal/front/d/8/d82a4c78-d2fc-425a-8d0e-2e64509a08f1.jpg?1715720382\"},{\"id\":\"d82a4c78-d2fc-425a-8d0e-2e64509a08f1\",\"name\":\"Sauron, the Lidless Eye\",\"image\":\"https://cards.scryfall.io/normal/front/d/8/d82a4c78-d2fc-425a-8d0e-2e64509a08f1.jpg?1715720382\"},{\"id\":\"d82a4c78-d2fc-425a-8d0e-2e64509a08f1\",\"name\":\"Sauron, the Lidless Eye\",\"image\":\"https://cards.scryfall.io/normal/front/d/8/d82a4c78-d2fc-425a-8d0e-2e64509a08f1.jpg?1715720382\"},{\"id\":\"377d65d8-21c8-4292-97db-610e0173ba59\",\"name\":\"Sauron, the Necromancer\",\"image\":\"https://cards.scryfall.io/normal/front/3/7/377d65d8-21c8-4292-97db-610e0173ba59.jpg?1686968699\"},{\"id\":\"377d65d8-21c8-4292-97db-610e0173ba59\",\"name\":\"Sauron, the Necromancer\",\"image\":\"https://cards.scryfall.io/normal/front/3/7/377d65d8-21c8-4292-97db-610e0173ba59.jpg?1686968699\"},{\"id\":\"377d65d8-21c8-4292-97db-610e0173ba59\",\"name\":\"Sauron, the Necromancer\",\"image\":\"https://cards.scryfall.io/normal/front/3/7/377d65d8-21c8-4292-97db-610e0173ba59.jpg?1686968699\"},{\"id\":\"76a88814-aa30-4297-b338-3d851bfe7256\",\"name\":\"The Mouth of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/7/6/76a88814-aa30-4297-b338-3d851bfe7256.jpg?1686969905\"},{\"id\":\"76a88814-aa30-4297-b338-3d851bfe7256\",\"name\":\"The Mouth of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/7/6/76a88814-aa30-4297-b338-3d851bfe7256.jpg?1686969905\"},{\"id\":\"76a88814-aa30-4297-b338-3d851bfe7256\",\"name\":\"The Mouth of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/7/6/76a88814-aa30-4297-b338-3d851bfe7256.jpg?1686969905\"},{\"id\":\"7d86dc2e-6f0c-4714-9d30-5d099d3b895c\",\"name\":\"Frodo, Sauron\'s Bane\",\"image\":\"https://cards.scryfall.io/normal/front/7/d/7d86dc2e-6f0c-4714-9d30-5d099d3b895c.jpg?1686967812\"},{\"id\":\"7d86dc2e-6f0c-4714-9d30-5d099d3b895c\",\"name\":\"Frodo, Sauron\'s Bane\",\"image\":\"https://cards.scryfall.io/normal/front/7/d/7d86dc2e-6f0c-4714-9d30-5d099d3b895c.jpg?1686967812\"},{\"id\":\"7d86dc2e-6f0c-4714-9d30-5d099d3b895c\",\"name\":\"Frodo, Sauron\'s Bane\",\"image\":\"https://cards.scryfall.io/normal/front/7/d/7d86dc2e-6f0c-4714-9d30-5d099d3b895c.jpg?1686967812\"},{\"id\":\"7d86dc2e-6f0c-4714-9d30-5d099d3b895c\",\"name\":\"Frodo, Sauron\'s Bane\",\"image\":\"https://cards.scryfall.io/normal/front/7/d/7d86dc2e-6f0c-4714-9d30-5d099d3b895c.jpg?1686967812\"},{\"id\":\"7d86dc2e-6f0c-4714-9d30-5d099d3b895c\",\"name\":\"Frodo, Sauron\'s Bane\",\"image\":\"https://cards.scryfall.io/normal/front/7/d/7d86dc2e-6f0c-4714-9d30-5d099d3b895c.jpg?1686967812\"},{\"id\":\"7d86dc2e-6f0c-4714-9d30-5d099d3b895c\",\"name\":\"Frodo, Sauron\'s Bane\",\"image\":\"https://cards.scryfall.io/normal/front/7/d/7d86dc2e-6f0c-4714-9d30-5d099d3b895c.jpg?1686967812\"},{\"id\":\"7d86dc2e-6f0c-4714-9d30-5d099d3b895c\",\"name\":\"Frodo, Sauron\'s Bane\",\"image\":\"https://cards.scryfall.io/normal/front/7/d/7d86dc2e-6f0c-4714-9d30-5d099d3b895c.jpg?1686967812\"},{\"id\":\"175b3d28-5c74-4972-9b5c-5e39762c78f4\",\"name\":\"Relic of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/1/7/175b3d28-5c74-4972-9b5c-5e39762c78f4.jpg?1686964447\"},{\"id\":\"175b3d28-5c74-4972-9b5c-5e39762c78f4\",\"name\":\"Relic of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/1/7/175b3d28-5c74-4972-9b5c-5e39762c78f4.jpg?1686964447\"},{\"id\":\"175b3d28-5c74-4972-9b5c-5e39762c78f4\",\"name\":\"Relic of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/1/7/175b3d28-5c74-4972-9b5c-5e39762c78f4.jpg?1686964447\"},{\"id\":\"175b3d28-5c74-4972-9b5c-5e39762c78f4\",\"name\":\"Relic of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/1/7/175b3d28-5c74-4972-9b5c-5e39762c78f4.jpg?1686964447\"}]'),
(7, 8, 'Bonito', NULL, NULL, 1, 0, '{\"id\":\"175b3d28-5c74-4972-9b5c-5e39762c78f4\",\"name\":\"Relic of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/1/7/175b3d28-5c74-4972-9b5c-5e39762c78f4.jpg?1686964447\"}', '[{\"id\":\"fc53dec0-79fe-4f6f-9d5b-cf298588e808\",\"name\":\"Sauron, Lord of the Rings\",\"image\":\"https://cards.scryfall.io/normal/front/f/c/fc53dec0-79fe-4f6f-9d5b-cf298588e808.jpg?1686963724\"},{\"id\":\"7d86dc2e-6f0c-4714-9d30-5d099d3b895c\",\"name\":\"Frodo, Sauron\'s Bane\",\"image\":\"https://cards.scryfall.io/normal/front/7/d/7d86dc2e-6f0c-4714-9d30-5d099d3b895c.jpg?1686967812\"},{\"id\":\"175b3d28-5c74-4972-9b5c-5e39762c78f4\",\"name\":\"Relic of Sauron\",\"image\":\"https://cards.scryfall.io/normal/front/1/7/175b3d28-5c74-4972-9b5c-5e39762c78f4.jpg?1686964447\"}]'),
(8, 8, 'rojosa', NULL, NULL, 0, 0, '{\"id\":\"17dd0b7f-bd26-4a46-a7a1-bc65138d54ed\",\"name\":\"Apple of Eden, Isu Relic\",\"image\":\"https://cards.scryfall.io/normal/front/1/7/17dd0b7f-bd26-4a46-a7a1-bc65138d54ed.jpg?1721424175\"}', '[{\"id\":\"2cae24c1-53f1-4f3f-8795-b634c46a17c4\",\"name\":\"Derelict Attic // Widow\'s Walk\",\"image\":\"https://cards.scryfall.io/normal/front/2/c/2cae24c1-53f1-4f3f-8795-b634c46a17c4.jpg?1726780598\"},{\"id\":\"0fd8c918-62d9-41be-a3e1-32ddac71b7e7\",\"name\":\"Darksteel Relic\",\"image\":\"https://cards.scryfall.io/normal/front/0/f/0fd8c918-62d9-41be-a3e1-32ddac71b7e7.jpg?1562875578\"},{\"id\":\"ef44324a-32bd-47e9-8fd9-258ba668de53\",\"name\":\"Coalition Relic\",\"image\":\"https://cards.scryfall.io/normal/front/e/f/ef44324a-32bd-47e9-8fd9-258ba668de53.jpg?1673305762\"},{\"id\":\"17dd0b7f-bd26-4a46-a7a1-bc65138d54ed\",\"name\":\"Apple of Eden, Isu Relic\",\"image\":\"https://cards.scryfall.io/normal/front/1/7/17dd0b7f-bd26-4a46-a7a1-bc65138d54ed.jpg?1721424175\"}]');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `favorites`
--

CREATE TABLE `favorites` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `deck_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `likes`
--

CREATE TABLE `likes` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `deck_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `likes`
--

INSERT INTO `likes` (`id`, `user_id`, `deck_id`) VALUES
(1, 8, 5),
(2, 8, 5),
(3, 8, 4),
(4, 8, 4),
(5, 8, 6),
(6, 8, 6),
(7, 6, 6),
(8, 6, 6),
(9, 3, 5),
(10, 2, 5),
(11, 7, 5),
(12, 7, 7),
(13, 8, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ratings`
--

CREATE TABLE `ratings` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `deck_id` int(11) DEFAULT NULL,
  `rating` int(11) DEFAULT NULL,
  `comment` text DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`) VALUES
(2, 'admin', 'admin@gmail.com', 'admin'),
(3, 'admin12', '12@n.com', 'admin'),
(4, 'admin14', '14@gm.co', 'admin'),
(5, 'admin14', '14@gm.co', 'admin'),
(6, 'admin17', '17@n.co', 'admin'),
(7, 'admin18', '12@pos.co', 'admin'),
(8, 'admin20', '20@u.co', 'admin'),
(9, 'admin20', '1234@gmail.com', 'admin');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `deck_id` (`deck_id`);

--
-- Indices de la tabla `decks`
--
ALTER TABLE `decks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `deck_id` (`deck_id`);

--
-- Indices de la tabla `likes`
--
ALTER TABLE `likes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `deck_id` (`deck_id`);

--
-- Indices de la tabla `ratings`
--
ALTER TABLE `ratings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `deck_id` (`deck_id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `decks`
--
ALTER TABLE `decks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `favorites`
--
ALTER TABLE `favorites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `likes`
--
ALTER TABLE `likes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `ratings`
--
ALTER TABLE `ratings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`deck_id`) REFERENCES `decks` (`id`);

--
-- Filtros para la tabla `decks`
--
ALTER TABLE `decks`
  ADD CONSTRAINT `decks_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `favorites`
--
ALTER TABLE `favorites`
  ADD CONSTRAINT `favorites_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `favorites_ibfk_2` FOREIGN KEY (`deck_id`) REFERENCES `decks` (`id`);

--
-- Filtros para la tabla `likes`
--
ALTER TABLE `likes`
  ADD CONSTRAINT `likes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `likes_ibfk_2` FOREIGN KEY (`deck_id`) REFERENCES `decks` (`id`);

--
-- Filtros para la tabla `ratings`
--
ALTER TABLE `ratings`
  ADD CONSTRAINT `ratings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `ratings_ibfk_2` FOREIGN KEY (`deck_id`) REFERENCES `decks` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
