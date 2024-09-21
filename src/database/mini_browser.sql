-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 18-09-2024 a las 08:24:10
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
-- Base de datos: `mini_browser`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `calcular_page_rank` ()   BEGIN
    DECLARE damping_factor FLOAT DEFAULT 0.85;
    DECLARE num_iterations INT DEFAULT 100;
    DECLARE i INT DEFAULT 0;

    WHILE i < num_iterations DO
        UPDATE page_rank pr
        SET rank = (1 - damping_factor) / (SELECT COUNT(*) FROM pages) +
                   damping_factor * (
                       SELECT COALESCE(SUM(pr2.rank / NULLIF(count_links.count, 0)), 0)
                       FROM links l
                       JOIN page_rank pr2 ON l.from_page_id = pr2.id
                       JOIN (SELECT from_page_id, COUNT(*) AS count FROM links GROUP BY from_page_id) AS count_links
                       ON l.from_page_id = count_links.from_page_id
                       WHERE l.to_page_id = pr.id
                   );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historialbusquedas`
--

CREATE TABLE `historialbusquedas` (
  `id_busqueda` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `id_pagina` int(11) DEFAULT NULL,
  `consulta` varchar(255) NOT NULL,
  `fecha_busqueda` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `links`
--

CREATE TABLE `links` (
  `id` int(11) NOT NULL,
  `from_page_id` int(11) DEFAULT NULL,
  `to_page_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `links`
--

INSERT INTO `links` (`id`, `from_page_id`, `to_page_id`) VALUES
(1, 1, 2),
(2, 1, 3),
(3, 2, 4),
(4, 3, 5),
(5, 4, 6),
(6, 5, 7),
(7, 6, 8),
(8, 7, 9),
(9, 8, 10),
(10, 9, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pages`
--

CREATE TABLE `pages` (
  `id` int(11) NOT NULL,
  `url` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pages`
--

INSERT INTO `pages` (`id`, `url`, `title`) VALUES
(1, 'https://example.com/page1', 'Página 1'),
(2, 'https://example.com/page2', 'Página 2'),
(3, 'https://example.com/page3', 'Página 3'),
(4, 'https://example.com/page4', 'Página 4'),
(5, 'https://example.com/page5', 'Página 5'),
(6, 'https://example.com/page6', 'Página 6'),
(7, 'https://example.com/page7', 'Página 7'),
(8, 'https://example.com/page8', 'Página 8'),
(9, 'https://example.com/page9', 'Página 9'),
(10, 'https://example.com/page10', 'Página 10');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `contraseña` varchar(255) NOT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `email`, `contraseña`, `fecha_registro`) VALUES
(1, 'Juan Pérez', 'juan.perez@example.com', 'contraseña1', '2024-09-16 10:36:41'),
(2, 'María López', 'maria.lopez@example.com', 'contraseña2', '2024-09-16 10:36:41'),
(3, 'Carlos García', 'carlos.garcia@example.com', 'contraseña3', '2024-09-16 10:36:41'),
(4, 'Ana Martínez', 'ana.martinez@example.com', 'contraseña4', '2024-09-16 10:36:41'),
(5, 'Luis Rodríguez', 'luis.rodriguez@example.com', 'contraseña5', '2024-09-16 10:36:41'),
(6, 'Laura Fernández', 'laura.fernandez@example.com', 'contraseña6', '2024-09-16 10:36:41'),
(7, 'Javier Hernández', 'javier.hernandez@example.com', 'contraseña7', '2024-09-16 10:36:41'),
(8, 'Sofía Sánchez', 'sofia.sanchez@example.com', 'contraseña8', '2024-09-16 10:36:41'),
(9, 'Diego Torres', 'diego.torres@example.com', 'contraseña9', '2024-09-16 10:36:41'),
(10, 'Valentina Castro', 'valentina.castro@example.com', 'contraseña10', '2024-09-16 10:36:41');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `historialbusquedas`
--
ALTER TABLE `historialbusquedas`
  ADD PRIMARY KEY (`id_busqueda`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_pagina` (`id_pagina`);

--
-- Indices de la tabla `links`
--
ALTER TABLE `links`
  ADD PRIMARY KEY (`id`),
  ADD KEY `from_page_id` (`from_page_id`),
  ADD KEY `to_page_id` (`to_page_id`);

--
-- Indices de la tabla `pages`
--
ALTER TABLE `pages`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `historialbusquedas`
--
ALTER TABLE `historialbusquedas`
  MODIFY `id_busqueda` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `links`
--
ALTER TABLE `links`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `pages`
--
ALTER TABLE `pages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `historialbusquedas`
--
ALTER TABLE `historialbusquedas`
  ADD CONSTRAINT `historialbusquedas_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE,
  ADD CONSTRAINT `historialbusquedas_ibfk_2` FOREIGN KEY (`id_pagina`) REFERENCES `pages` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `links`
--
ALTER TABLE `links`
  ADD CONSTRAINT `links_ibfk_1` FOREIGN KEY (`from_page_id`) REFERENCES `pages` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `links_ibfk_2` FOREIGN KEY (`to_page_id`) REFERENCES `pages` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
