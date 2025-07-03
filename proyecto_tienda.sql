DROP DATABASE IF EXISTS `proyecto_tienda`;

-- Crear la base de datos
CREATE DATABASE `proyecto_tienda` 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_general_ci;

-- Usar la base de datos
USE `proyecto_tienda`;

-- ============================================
-- 2. CREACIÓN DE TABLAS
-- ============================================

-- Tabla: clientes
CREATE TABLE `clientes` (
  `idCliente` INT(11) NOT NULL AUTO_INCREMENT,
  `dni` VARCHAR(9) NOT NULL,
  `nombre` VARCHAR(50) NOT NULL,
  `apellidos` VARCHAR(100) NOT NULL,
  `direccion` VARCHAR(200) NOT NULL,
  `cp` VARCHAR(5) NOT NULL,
  `provincia` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`idCliente`),
  UNIQUE KEY `uk_dni` (`dni`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla: productos
CREATE TABLE `productos` (
  `idProducto` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `descripcion` TEXT NOT NULL,
  `precio` DECIMAL(10,2) NOT NULL,
  `stock` INT(11) NOT NULL,
  `categoria` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`idProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla: ventas
CREATE TABLE `ventas` (
  `idVenta` INT(11) NOT NULL AUTO_INCREMENT,
  `fechaHora` DATETIME NOT NULL,
  `idCliente` INT(11) NOT NULL,
  `idEmpleado` INT(11) NOT NULL,
  `precioVenta` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`idVenta`),
  KEY `fk_ventas_cliente` (`idCliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla: lventas (líneas de ventas)
CREATE TABLE `lventas` (
  `idLventa` INT(11) NOT NULL AUTO_INCREMENT,
  `idVenta` INT(11) NOT NULL,
  `idProducto` INT(11) NOT NULL,
  `unidades` INT(11) NOT NULL,
  `precioUnidad` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`idLventa`),
  KEY `fk_lventas_venta` (`idVenta`),
  KEY `fk_lventas_producto` (`idProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ============================================
-- 3. INSERCIÓN DE DATOS
-- ============================================

-- Insertar datos en la tabla clientes
INSERT INTO `clientes` (`idCliente`, `dni`, `nombre`, `apellidos`, `direccion`, `cp`, `provincia`) VALUES
(1, '12345678A', 'María', 'García López', 'Calle Gran Vía 15, 3ºB', '28013', 'Madrid'),
(2, '23456789B', 'Carmen', 'Rodríguez Martín', 'Avenida Constitución 42', '41001', 'Sevilla'),
(3, '34567890C', 'Ana', 'Fernández Ruiz', 'Plaza Mayor 8, 1ºA', '47001', 'Valladolid'),
(4, '45678901D', 'Isabel', 'Sánchez Moreno', 'Calle Valencia 156', '08011', 'Barcelona'),
(5, '56789012E', 'Pilar', 'Jiménez Castro', 'Avenida del Puerto 23', '46011', 'Valencia'),
(6, '67890123F', 'Rosa', 'Muñoz Delgado', 'Calle Real 89', '15001', 'A Coruña'),
(7, '78901234G', 'Dolores', 'Álvarez Vega', 'Plaza España 12', '33001', 'Asturias'),
(8, '89012345H', 'Francisca', 'Romero Díaz', 'Calle Mayor 67', '39001', 'Cantabria'),
(9, '90123456I', 'Antonia', 'Navarro Gil', 'Avenida Libertad 34', '30001', 'Murcia'),
(10, '01234567J', 'Josefa', 'Torres Herrera', 'Calle Sierpes 78', '41004', 'Sevilla'),
(11, '11234567K', 'Mercedes', 'Domínguez Ramos', 'Gran Vía 102', '48001', 'Vizcaya'),
(12, '21234567L', 'Encarnación', 'Guerrero Peña', 'Calle Alcalá 245', '28028', 'Madrid'),
(13, '31234567M', 'Concepción', 'Méndez Ortega', 'Rambla Catalunya 88', '08008', 'Barcelona'),
(14, '41234567N', 'Amparo', 'Caballero Santos', 'Avenida Andalucía 156', '18001', 'Granada'),
(15, '51234567O', 'Remedios', 'Iglesias Vargas', 'Calle Colón 45', '46004', 'Valencia'),
(16, '61234567P', 'Purificación', 'Medina Cortés', 'Plaza del Obradoiro 7', '15705', 'A Coruña'),
(17, '71234567Q', 'Milagros', 'Garrido Núñez', 'Calle Uría 112', '33003', 'Asturias'),
(18, '81234567R', 'Esperanza', 'Carmona Aguilar', 'Avenida Cantabria 78', '39005', 'Cantabria'),
(19, '91234567S', 'Asunción', 'Herrero Blanco', 'Calle Gran Vía 234', '30008', 'Murcia'),
(20, '02345678T', 'Inmaculada', 'Prieto Rubio', 'Plaza Nueva 16', '41001', 'Sevilla'),
(21, '12345679U', 'Rosario', 'Morales Fuentes', 'Calle Arenal 89', '48005', 'Vizcaya'),
(22, '22345678V', 'Soledad', 'Ortiz Moya', 'Paseo de la Castellana 167', '28046', 'Madrid'),
(23, '32345678W', 'Angustias', 'Rubio Pascual', 'Via Laietana 234', '08003', 'Barcelona'),
(24, '42345678X', 'Visitación', 'Marin Iglesias', 'Calle Recogidas 123', '18005', 'Granada'),
(25, '52345678Y', 'Nieves', 'Santos Lozano', 'Calle Poeta Querol 34', '46002', 'Valencia'),
(26, '62345678Z', 'Luz', 'Calvo Jiménez', 'Rúa do Franco 56', '15704', 'A Coruña'),
(27, '72345678A', 'Natividad', 'Gallego Soler', 'Calle Jovellanos 78', '33201', 'Asturias'),
(28, '82345678B', 'Virtudes', 'León Ferrer', 'Calle del Sol 45', '39001', 'Cantabria'),
(29, '92345678C', 'Paz', 'Vargas Campos', 'Avenida Juan Carlos I 167', '30100', 'Murcia'),
(30, '03456789D', 'Esperanza', 'Serrano Peña', 'Calle Betis 234', '41010', 'Sevilla');

-- Insertar datos en la tabla productos
INSERT INTO `productos` (`idProducto`, `nombre`, `descripcion`, `precio`, `stock`, `categoria`) VALUES
(1, 'Sujetador Deportivo Nike Pro', 'Sujetador deportivo de alto rendimiento con tecnología Dri-FIT que mantiene la piel seca y cómoda. Diseñado con copas moldeadas sin costuras para mayor comodidad y soporte medio. Ideal para entrenamientos de intensidad media como yoga, pilates o cardio ligero. Disponible en varios colores.', 35.99, 25, 'Sujetadores Deportivos'),
(2, 'Sujetador Deportivo Adidas Believe This', 'Sujetador deportivo con tecnología AEROREADY que absorbe la humedad para mantenerte seca durante todo el entrenamiento. Ofrece soporte medio con tirantes ajustables y banda elástica inferior. Perfecto para running, fitness y deportes de equipo. Material reciclado sostenible.', 29.95, 30, 'Sujetadores Deportivos'),
(3, 'Sujetador Sport Under Armour Mid', 'Sujetador deportivo de soporte medio con tecnología HeatGear que mantiene la piel fresca y seca. Construcción sin costuras para evitar rozaduras y máxima comodidad. Tirantes cruzados en la espalda para mayor estilo y libertad de movimiento. Ideal para entrenamientos variados.', 42.00, 20, 'Sujetadores Deportivos'),
(4, 'Sujetador Deportivo Puma Studio', 'Sujetador deportivo minimalista con tecnología dryCELL que absorbe la humedad. Diseño moderno con banda elástica ancha para mayor soporte y comodidad. Perfecto para yoga, pilates y entrenamientos de bajo impacto. Tejido suave y elástico que se adapta al cuerpo.', 24.99, 35, 'Sujetadores Deportivos'),
(5, 'Sujetador High Support Reebok', 'Sujetador deportivo de alto soporte especialmente diseñado para actividades de alto impacto como running intenso, HIIT o deportes de contacto. Tecnología Speedwick que elimina el sudor rápidamente. Copas moldeadas con acolchado removible para personalizar el ajuste.', 39.50, 18, 'Sujetadores Deportivos'),
(6, 'Sujetador Deportivo Calvin Klein Performance', 'Sujetador deportivo elegante con logo CK icónico. Ofrece soporte medio con tecnología de secado rápido. Diseño moderno con detalles en contraste y banda elástica suave. Ideal para entrenamientos en el gimnasio o actividades al aire libre. Combina estilo y funcionalidad.', 32.00, 28, 'Sujetadores Deportivos'),
(7, 'Sports Bra New Balance NB Ice', 'Sujetador deportivo con tecnología NB ICE que proporciona sensación de frescura durante el ejercicio. Soporte medio con copas removibles y tirantes ajustables. Diseño versátil perfecto para múltiples actividades deportivas. Tejido antibacteriano que previene olores.', 27.95, 22, 'Sujetadores Deportivos'),
(8, 'Sujetador Deportivo Lotto Dinamico', 'Sujetador deportivo italiano con diseño ergonómico y soporte medio-alto. Tecnología de ventilación estratégica en zonas de mayor sudoración. Construcción sin costuras laterales para mayor comodidad. Perfecto para deportes de raqueta, atletismo y fitness grupal.', 21.50, 40, 'Sujetadores Deportivos'),
(9, 'Sujetador Sport Fila Heritage', 'Sujetador deportivo retro con el clásico logo Fila. Ofrece soporte medio con banda ancha y cómoda. Tejido de algodón mezcla que proporciona suavidad y durabilidad. Ideal para uso casual deportivo o entrenamientos ligeros. Diseño atemporal que nunca pasa de moda.', 19.99, 33, 'Sujetadores Deportivos'),
(10, 'Sujetador Deportivo Asics Seamless', 'Sujetador deportivo sin costuras con tecnología MotionDry que mantiene la piel seca. Soporte medio con diseño ergonómico que se adapta perfectamente al contorno del cuerpo. Ideal para running de larga distancia y entrenamientos intensos. Reflectantes para visibilidad nocturna.', 44.00, 15, 'Sujetadores Deportivos'),
(11, 'Mallas Nike Pro 365', 'Mallas deportivas de talle alto con tecnología Dri-FIT ADV que combina absorción de humedad con transpirabilidad avanzada. Tejido de compresión suave que ofrece soporte muscular y libertad de movimiento. Bolsillo lateral para móvil. Perfectas para cualquier actividad deportiva o uso casual.', 65.00, 45, 'Mallas Deportivas'),
(12, 'Leggings Adidas Techfit Life', 'Mallas deportivas de compresión con tecnología AEROREADY y protección UV. Cinturilla alta que estiliza la figura y proporciona soporte abdominal. Diseño sin costuras en entrepierna para evitar rozaduras. Ideales para yoga, pilates, running y entrenamientos de fuerza.', 55.95, 38, 'Mallas Deportivas'),
(13, 'Mallas Under Armour HeatGear', 'Mallas deportivas ultraligeras con tecnología HeatGear que mantiene la piel fresca y seca. Compresión 4-way stretch para total libertad de movimiento. Cintura ancha anti-deslizante y costura plana para máxima comodidad. Perfectas para climas cálidos y entrenamientos intensos.', 58.00, 32, 'Mallas Deportivas'),
(14, 'Leggings Puma Train Favorite', 'Mallas deportivas versátiles con tecnología dryCELL de secado rápido. Diseño de talle alto con cinturilla ancha y elástica. Tejido suave al tacto con propiedades de compresión ligera. Ideales para entrenamientos variados, desde cardio hasta yoga. Logo Puma reflectante.', 39.99, 50, 'Mallas Deportivas'),
(15, 'Mallas Reebok Lux High-Rise', 'Mallas deportivas premium con tecnología Speedwick que elimina la humedad instantáneamente. Talle alto moldeador con panel de malla transpirable. Bolsillos laterales con cremallera para guardar objetos de valor. Perfectas para HIIT, crossfit y entrenamientos funcionales.', 49.50, 28, 'Mallas Deportivas'),
(16, 'Leggings Calvin Klein Performance Logo', 'Mallas deportivas elegantes con banda elástica con logo CK en contraste. Tejido de compresión suave que realza la figura. Tecnología de secado rápido y control de olores. Diseño moderno perfecto para gimnasio, street style o actividades al aire libre.', 45.00, 35, 'Mallas Deportivas'),
(17, 'Mallas New Balance Transform', 'Mallas deportivas transformadoras con tecnología NB DRY que absorbe la humedad. Compresión graduada que mejora la circulación y reduce la fatiga muscular. Cintura alta con bolsillo interno para llaves. Ideales para running, ciclismo y entrenamientos de resistencia.', 52.95, 25, 'Mallas Deportivas'),
(18, 'Leggings Lotto Athletica', 'Mallas deportivas italianas con diseño ergonómico y tecnología de ventilación estratégica. Compresión media que proporciona soporte sin restricción. Costuras planas para evitar irritaciones. Perfectas para deportes de equipo, atletismo y fitness. Diseño elegante y funcional.', 43.00, 42, 'Mallas Deportivas'),
(19, 'Mallas Fila Disruptor', 'Mallas deportivas con estilo urbano deportivo y el icónico logo Fila. Talle alto con cinturilla ancha y cómoda. Tejido de algodón-lycra que combina comodidad y flexibilidad. Ideales para uso casual deportivo, entrenamientos ligeros o como prenda de descanso activo.', 37.95, 55, 'Mallas Deportivas'),
(20, 'Leggings Asics Road Balance', 'Mallas deportivas técnicas con tecnología MotionDry y protección UV 50+. Compresión específica para running con bandas reflectantes para visibilidad nocturna. Bolsillo trasero con cremallera y bolsillos laterales. Perfectas para corredoras que buscan rendimiento y seguridad.', 61.00, 20, 'Mallas Deportivas'),
(21, 'Mallas Champion Powercore', 'Mallas deportivas de compresión con tecnología Vapor que mantiene la piel seca durante entrenamientos intensos. Cintura alta moldeadora con soporte abdominal. Tejido duradero que mantiene su forma después de múltiples lavados. Ideales para entrenamientos de fuerza y cardio intenso.', 37.95, 40, 'Mallas Deportivas'),
(22, 'Leggings Kappa Authentic', 'Mallas deportivas retro con las clásicas bandas laterales Kappa. Tejido de compresión ligera con propiedades elásticas. Cintura media cómoda con cordón ajustable. Perfectas para deportes vintage, entrenamiento funcional o como declaración de moda deportiva urbana.', 33.50, 30, 'Mallas Deportivas'),
(23, 'Mallas Umbro Velocita', 'Mallas deportivas dinámicas con tecnología de control térmico que se adapta a la temperatura corporal. Compresión 360° para soporte muscular completo. Paneles de malla en zonas estratégicas para ventilación extra. Ideales para deportes de alta intensidad y entrenamientos explosivos.', 43.00, 24, 'Mallas Deportivas'),
(24, 'Leggings Joma Elite', 'Mallas deportivas profesionales con tecnología Micro-Mesh que favorece la transpirabilidad. Compresión graduada que mejora el rendimiento deportivo. Cintura alta con banda ancha anti-deslizante. Costuras ergonómicas que siguen el movimiento natural del cuerpo durante el ejercicio.', 38.95, 33, 'Mallas Deportivas'),
(25, 'Falda Deportiva Nike Court Victory', 'Falda deportiva de tenis con tecnología Dri-FIT que mantiene la comodidad durante todo el partido. Diseño plisado clásico con shorts integrados para mayor cobertura y confianza. Cintura elástica ajustable y bolsillos laterales para pelotas. Perfecta para tenis, pádel y deportes de raqueta.', 41.95, 22, 'Faldas Sport'),
(26, 'Falda Sport Adidas Club', 'Falda deportiva versátil con tecnología AEROREADY que absorbe la humedad. Corte A-line favorecedor con shorts incorporados de compresión ligera. Cintura alta con banda ancha para mayor comodidad. Ideal para tenis, golf, running casual o actividades al aire libre.', 31.50, 18, 'Faldas Sport'),
(27, 'Falda Deportiva Under Armour Play Up', 'Falda deportiva ultra-ligera con tecnología HeatGear que proporciona frescura durante la actividad. Diseño moderno con shorts internos seamless. Cintura elástica con cordón ajustable interno. Perfecta para entrenamientos variados, deportes de equipo y actividades recreativas.', 34.50, 25, 'Faldas Sport'),
(28, 'Falda Sport Puma Active', 'Falda deportiva contemporánea con tecnología dryCELL de secado rápido. Diseño asimétrico con detalles en contraste y logo Puma. Shorts integrados con tecnología de compresión suave. Ideal para fitness, yoga dinámico, danza deportiva y entrenamientos creativos.', 35.99, 28, 'Faldas Sport'),
(29, 'Falda Deportiva Wilson Team', 'Falda deportiva específica para deportes de raqueta con tecnología nanoWIK que elimina la humedad instantáneamente. Pliegues estratégicos que permiten total libertad de movimiento. Shorts internos con banda de silicona anti-deslizante. Perfecta para competición y entrenamientos intensos de tenis.', 35.99, 15, 'Faldas Sport'),
(30, 'Falda Sport Fila Heritage', 'Falda deportiva retro con el clásico estilo Fila de los años 80. Tejido de algodón-poliéster que combina comodidad vintage con funcionalidad moderna. Shorts integrados básicos y cintura elástica cómoda. Ideal para tenis recreativo, moda deportiva urbana y actividades casuales.', 52.00, 30, 'Faldas Sport');

-- Insertar datos en la tabla ventas
INSERT INTO `ventas` (`idVenta`, `fechaHora`, `idCliente`, `idEmpleado`, `precioVenta`) VALUES
(1, '2024-12-01 10:15:00', 1, 1, 67.99),
(2, '2024-12-01 11:30:00', 2, 2, 99.50),
(3, '2024-12-01 14:45:00', 3, 1, 35.99),
(4, '2024-12-02 09:20:00', 4, 3, 149.94),
(5, '2024-12-02 12:10:00', 5, 2, 39.50),
(6, '2024-12-02 16:30:00', 6, 1, 107.48),
(7, '2024-12-03 08:45:00', 7, 2, 52.00),
(8, '2024-12-03 13:25:00', 8, 3, 72.95),
(9, '2024-12-03 17:15:00', 9, 1, 123.44),
(10, '2024-12-04 10:00:00', 10, 2, 53.50),
(11, '2024-12-04 15:20:00', 11, 1, 58.00),
(12, '2024-12-05 09:30:00', 12, 3, 94.95),
(13, '2024-12-05 12:45:00', 13, 2, 161.50),
(14, '2024-12-05 16:10:00', 14, 1, 87.98),
(15, '2024-12-06 11:15:00', 15, 2, 49.50),
(16, '2024-12-06 14:30:00', 16, 3, 95.50),
(17, '2024-12-07 10:45:00', 17, 1, 103.45),
(18, '2024-12-07 13:20:00', 18, 2, 96.95),
(19, '2024-12-08 09:15:00', 19, 3, 139.94),
(20, '2024-12-08 15:40:00', 20, 1, 70.95),
(21, '2024-12-09 11:00:00', 21, 2, 90.45),
(22, '2024-12-09 16:25:00', 22, 3, 121.93),
(23, '2024-12-10 08:30:00', 23, 1, 163.94),
(24, '2024-12-10 14:15:00', 24, 2, 84.49),
(25, '2024-12-11 10:20:00', 25, 3, 182.95),
(26, '2024-12-11 15:45:00', 26, 1, 76.99),
(27, '2024-12-12 09:50:00', 27, 2, 149.45),
(28, '2024-12-12 13:30:00', 28, 3, 55.00),
(29, '2024-12-13 11:40:00', 29, 1, 158.99),
(30, '2024-12-13 16:00:00', 30, 2, 116.89);

-- Insertar datos en la tabla lventas
INSERT INTO `lventas` (`idLventa`, `idVenta`, `idProducto`, `unidades`, `precioUnidad`) VALUES
(1, 1, 1, 1, 35.99),
(2, 1, 6, 1, 32.00),
(3, 2, 11, 1, 65.00),
(4, 2, 27, 1, 34.50),
(5, 3, 1, 1, 35.99),
(6, 4, 12, 1, 55.95),
(7, 4, 13, 1, 58.00),
(8, 4, 29, 1, 35.99),
(9, 5, 5, 1, 39.50),
(10, 6, 14, 1, 39.99),
(11, 6, 1, 1, 35.99),
(12, 6, 26, 1, 31.50),
(13, 7, 30, 1, 52.00),
(14, 8, 2, 1, 29.95),
(15, 8, 18, 1, 43.00),
(16, 9, 15, 1, 49.50),
(17, 9, 19, 1, 37.95),
(18, 9, 28, 1, 35.99),
(19, 10, 16, 1, 32.00),
(20, 10, 8, 1, 21.50),
(21, 11, 13, 1, 58.00),
(22, 12, 3, 1, 42.00),
(23, 12, 17, 1, 52.95),
(24, 13, 11, 2, 65.00),
(25, 13, 26, 1, 31.50),
(26, 14, 4, 1, 24.99),
(27, 14, 18, 1, 43.00),
(28, 14, 9, 1, 19.99),
(29, 15, 15, 1, 49.50),
(30, 16, 20, 1, 61.00),
(31, 16, 27, 1, 34.50),
(32, 17, 21, 1, 37.95),
(33, 17, 22, 1, 33.50),
(34, 17, 6, 1, 32.00),
(35, 18, 10, 1, 44.00),
(36, 18, 17, 1, 52.95),
(37, 19, 11, 1, 65.00),
(38, 19, 24, 1, 38.95),
(39, 19, 28, 1, 35.99),
(40, 20, 7, 1, 27.95),
(41, 20, 23, 1, 43.00),
(42, 21, 12, 1, 55.95),
(43, 21, 27, 1, 34.50),
(44, 22, 14, 2, 39.99),
(45, 22, 25, 1, 41.95),
(46, 23, 13, 1, 58.00),
(47, 23, 16, 1, 32.00),
(48, 23, 19, 1, 37.95),
(49, 23, 1, 1, 35.99),
(50, 24, 18, 1, 43.00),
(51, 24, 8, 1, 21.50),
(52, 24, 9, 1, 19.99),
(53, 25, 11, 1, 65.00),
(54, 25, 20, 1, 61.00),
(55, 25, 17, 1, 52.95),
(56, 25, 3, 1, 42.00),
(57, 26, 30, 1, 52.00),
(58, 26, 4, 1, 24.99),
(59, 27, 12, 1, 55.95),
(60, 27, 15, 1, 49.50),
(61, 27, 10, 1, 44.00),
(62, 28, 22, 1, 33.50),
(63, 28, 8, 1, 21.50),
(64, 29, 11, 1, 65.00),
(65, 29, 13, 1, 58.00),
(66, 29, 29, 1, 35.99),
(67, 30, 24, 1, 38.95),
(68, 30, 25, 1, 41.95),
(69, 30, 1, 1, 35.99);

-- ============================================
-- 4. CREACIÓN DE CLAVES FORÁNEAS
-- ============================================

-- Agregar clave foránea en la tabla ventas
ALTER TABLE `ventas` 
ADD CONSTRAINT `fk_ventas_cliente` 
FOREIGN KEY (`idCliente`) 
REFERENCES `clientes` (`idCliente`) 
ON DELETE RESTRICT 
ON UPDATE CASCADE;

-- Agregar clave foránea en la tabla lventas para ventas
ALTER TABLE `lventas` 
ADD CONSTRAINT `fk_lventas_venta` 
FOREIGN KEY (`idVenta`) 
REFERENCES `ventas` (`idVenta`) 
ON DELETE CASCADE 
ON UPDATE CASCADE;

-- Agregar clave foránea en la tabla lventas para productos
ALTER TABLE `lventas` 
ADD CONSTRAINT `fk_lventas_producto` 
FOREIGN KEY (`idProducto`) 
REFERENCES `productos` (`idProducto`) 
ON DELETE RESTRICT 
ON UPDATE CASCADE;

-- ============================================
-- 5. VERIFICACIÓN DE LA INSTALACIÓN
-- ============================================

-- Mostrar información sobre las tablas creadas
SHOW TABLES;

-- Verificar la estructura de cada tabla
DESCRIBE clientes;
DESCRIBE productos;
DESCRIBE ventas;
DESCRIBE lventas;

-- Verificar que los datos se insertaron correctamente
SELECT 'Clientes' as Tabla, COUNT(*) as Total_Registros FROM clientes
UNION ALL
SELECT 'Productos' as Tabla, COUNT(*) as Total_Registros FROM productos
UNION ALL
SELECT 'Ventas' as Tabla, COUNT(*) as Total_Registros FROM ventas
UNION ALL
SELECT 'Líneas de Venta' as Tabla, COUNT(*) as Total_Registros FROM lventas;

-- Verificar las relaciones funcionan correctamente
SELECT 
    v.idVenta,
    c.nombre as Cliente,
    c.apellidos,
    v.fechaHora,
    v.precioVenta
FROM ventas v
JOIN clientes c ON v.idCliente = c.idCliente
LIMIT 5;

