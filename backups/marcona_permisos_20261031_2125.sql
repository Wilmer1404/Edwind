-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: marcona_permisos
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `action_logs`
--

DROP TABLE IF EXISTS `action_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `action_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `accion` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `entidad` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `entidad_id` bigint DEFAULT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_accion` (`accion`),
  KEY `idx_entidad` (`entidad`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_logs_date_user` (`created_at`,`user_id`),
  CONSTRAINT `action_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action_logs`
--

LOCK TABLES `action_logs` WRITE;
/*!40000 ALTER TABLE `action_logs` DISABLE KEYS */;
INSERT INTO `action_logs` VALUES (1,1,'login_intento','usuario',1,'Intento fallido de login','127.0.0.1','2026-10-23 07:43:27'),(2,1,'login','usuario',1,'Login exitoso','0:0:0:0:0:0:0:1','2026-10-23 07:46:25'),(3,1,'login','usuario',1,'Login exitoso','127.0.0.1','2026-10-23 07:47:08'),(4,1,'crear','empresa',1,'Empresa creada: Turismo Marcona','127.0.0.1','2026-10-23 07:48:46'),(5,1,'crear','chofer',1,'Chofer creado: Wilmer Samir Loro Amaya','127.0.0.1','2026-10-23 07:49:57'),(6,1,'crear','vehiculo',1,'Vehículo creado: ABC-123','127.0.0.1','2026-10-23 08:12:21'),(7,1,'asignar_conductor','vehiculo',1,'Conductor ID 1 asignado como propietario','127.0.0.1','2026-10-23 08:12:47'),(8,1,'generar_permiso','permiso',1,'Permiso generado: PERM-2026-00001','127.0.0.1','2026-10-23 08:13:18');
/*!40000 ALTER TABLE `action_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `companies` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ruc` varchar(11) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(9) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `direccion` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contacto` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`),
  UNIQUE KEY `ruc` (`ruc`),
  KEY `idx_ruc` (`ruc`),
  KEY `idx_estado` (`estado`),
  CONSTRAINT `companies_chk_1` CHECK (regexp_like(`ruc`,_utf8mb4'^(10|15|17|20)[0-9]{9}$')),
  CONSTRAINT `companies_chk_2` CHECK (regexp_like(`telefono`,_utf8mb4'^[0-9]{9}$'))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companies`
--

LOCK TABLES `companies` WRITE;
/*!40000 ALTER TABLE `companies` DISABLE KEYS */;
INSERT INTO `companies` VALUES (1,'Turismo Marcona','20123456789','904022627','marcona@gmail.com','Marcona /Ica','Wilmer Samir Loro Amaya','activo','2026-10-23 07:48:46','2026-10-23 07:48:46');
/*!40000 ALTER TABLE `companies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `drivers`
--

DROP TABLE IF EXISTS `drivers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drivers` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned DEFAULT NULL,
  `company_id` int unsigned DEFAULT NULL,
  `nombre_completo` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dni` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(9) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numero_licencia` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_vencimiento_licencia` date NOT NULL,
  `estado` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dni` (`dni`),
  UNIQUE KEY `numero_licencia` (`numero_licencia`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `idx_dni` (`dni`),
  KEY `idx_company_id` (`company_id`),
  KEY `idx_estado` (`estado`),
  KEY `idx_drivers_company` (`company_id`,`estado`),
  CONSTRAINT `drivers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `drivers_ibfk_2` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `drivers_chk_1` CHECK (regexp_like(`dni`,_utf8mb4'^[0-9]{8}$')),
  CONSTRAINT `drivers_chk_2` CHECK (regexp_like(`telefono`,_utf8mb4'^[0-9]{9}$'))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `drivers`
--

LOCK TABLES `drivers` WRITE;
/*!40000 ALTER TABLE `drivers` DISABLE KEYS */;
INSERT INTO `drivers` VALUES (1,NULL,1,'Wilmer Samir Loro Amaya','70942778','904022627','A-IIB','2027-12-31','activo','2026-10-23 07:49:57','2026-10-23 07:49:57');
/*!40000 ALTER TABLE `drivers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permit_sequences`
--

DROP TABLE IF EXISTS `permit_sequences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permit_sequences` (
  `year` year NOT NULL,
  `last_number` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permit_sequences`
--

LOCK TABLES `permit_sequences` WRITE;
/*!40000 ALTER TABLE `permit_sequences` DISABLE KEYS */;
INSERT INTO `permit_sequences` VALUES (2026,1);
/*!40000 ALTER TABLE `permit_sequences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permits`
--

DROP TABLE IF EXISTS `permits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permits` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `assignment_id` int unsigned DEFAULT NULL,
  `driver_id` int unsigned DEFAULT NULL,
  `vehicle_id` int unsigned NOT NULL,
  `company_id` int unsigned DEFAULT NULL,
  `tipo_permiso` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numero_permiso` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_emision` date NOT NULL,
  `fecha_vencimiento` date NOT NULL,
  `qr_code` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero_recibo` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `monto_pagado` decimal(10,2) DEFAULT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `created_by` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `numero_permiso` (`numero_permiso`),
  KEY `created_by` (`created_by`),
  KEY `idx_numero_permiso` (`numero_permiso`),
  KEY `idx_assignment_id` (`assignment_id`),
  KEY `idx_driver_id` (`driver_id`),
  KEY `idx_vehicle_id` (`vehicle_id`),
  KEY `idx_company_id` (`company_id`),
  KEY `idx_estado` (`estado`),
  KEY `idx_fecha_vencimiento` (`fecha_vencimiento`),
  KEY `idx_permits_estado_vence` (`estado`,`fecha_vencimiento`),
  KEY `idx_permits_state_date` (`estado`,`fecha_vencimiento`),
  CONSTRAINT `permits_ibfk_1` FOREIGN KEY (`assignment_id`) REFERENCES `vehicle_assignments` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `permits_ibfk_2` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `permits_ibfk_3` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `permits_ibfk_4` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `permits_ibfk_5` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permits`
--

LOCK TABLES `permits` WRITE;
/*!40000 ALTER TABLE `permits` DISABLE KEYS */;
INSERT INTO `permits` VALUES (1,1,1,1,1,'libre_transito','PERM-2026-00001','2026-10-23','2027-10-23','iVBORw0KGgoAAAANSUhEUgAAAPoAAAD6AQAAAACgl2eQAAABMElEQVR4Xu2VQXIDMQgE+Tk8zT9T6AFtXD74AZngXQk1rcuUXY7zvV7xST7KR6hQ5amsXtlYlxoJfQTriWSSI0GdhLqI5sx6qaOgnVYR2QoRCuioHIULho12qZEQqgS+fZb6CLeEUgFNSiofYUNJ8Dy/upPQPYyV4eOUUnMSwBNVL7yj6KKRsL0mO0Ib0Ufo03MWW4NdQbkIzC4eqqZEfYSp1lKDbQa9/bH+eUEsetRkRr0L0fgIGAzqWjMKstIPx0SoaWVoJBvXTOiudiR5xN3dBJZUQrI1pHESij6144YcCXl8hFuFwmwy4y0nQaEonZ0+MpqRINbHmAcVTxfTSQAWH/EcMuUoLGpnLxCgpZDMWGnmdRIIBCakJ2B0aSSEqg8b1VwQmy+Mh/C9/oWp1w/qeqmC+WiAdgAAAABJRU5ErkJggg==','vigente',NULL,NULL,'',1,'2026-10-23 08:13:18','2026-10-23 08:13:18');
/*!40000 ALTER TABLE `permits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rate_limits`
--

DROP TABLE IF EXISTS `rate_limits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rate_limits` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'IPv4 o IPv6 del cliente',
  `action` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Identificador de la accion',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_rate_ip_action_time` (`ip`,`action`,`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rate_limits`
--

LOCK TABLES `rate_limits` WRITE;
/*!40000 ALTER TABLE `rate_limits` DISABLE KEYS */;
INSERT INTO `rate_limits` VALUES (42,'0:0:0:0:0:0:0:1','api_general','2026-10-23 08:00:07'),(4,'0:0:0:0:0:0:0:1','login','2026-10-23 07:46:25'),(6,'127.0.0.1','api_general','2026-10-23 07:47:09'),(7,'127.0.0.1','api_general','2026-10-23 07:47:12'),(8,'127.0.0.1','api_general','2026-10-23 07:47:12'),(9,'127.0.0.1','api_general','2026-10-23 07:47:17'),(10,'127.0.0.1','api_general','2026-10-23 07:47:17'),(11,'127.0.0.1','api_general','2026-10-23 07:47:18'),(12,'127.0.0.1','api_general','2026-10-23 07:47:18'),(13,'127.0.0.1','api_general','2026-10-23 07:47:18'),(14,'127.0.0.1','api_general','2026-10-23 07:47:18'),(15,'127.0.0.1','api_general','2026-10-23 07:47:19'),(16,'127.0.0.1','api_general','2026-10-23 07:47:19'),(17,'127.0.0.1','api_general','2026-10-23 07:47:20'),(18,'127.0.0.1','api_general','2026-10-23 07:47:26'),(19,'127.0.0.1','api_general','2026-10-23 07:47:32'),(20,'127.0.0.1','api_general','2026-10-23 07:47:33'),(21,'127.0.0.1','api_general','2026-10-23 07:47:33'),(22,'127.0.0.1','api_general','2026-10-23 07:47:35'),(23,'127.0.0.1','api_general','2026-10-23 07:47:35'),(24,'127.0.0.1','api_general','2026-10-23 07:47:36'),(25,'127.0.0.1','api_general','2026-10-23 07:47:36'),(26,'127.0.0.1','api_general','2026-10-23 07:47:36'),(27,'127.0.0.1','api_general','2026-10-23 07:47:36'),(28,'127.0.0.1','api_general','2026-10-23 07:47:36'),(29,'127.0.0.1','api_general','2026-10-23 07:47:36'),(30,'127.0.0.1','api_general','2026-10-23 07:47:37'),(31,'127.0.0.1','api_general','2026-10-23 07:47:52'),(32,'127.0.0.1','api_general','2026-10-23 07:47:54'),(33,'127.0.0.1','api_general','2026-10-23 07:47:54'),(34,'127.0.0.1','api_general','2026-10-23 07:48:46'),(35,'127.0.0.1','api_general','2026-10-23 07:49:03'),(36,'127.0.0.1','api_general','2026-10-23 07:49:03'),(37,'127.0.0.1','api_general','2026-10-23 07:50:00'),(38,'127.0.0.1','api_general','2026-10-23 07:50:00'),(39,'127.0.0.1','api_general','2026-10-23 07:50:12'),(40,'127.0.0.1','api_general','2026-10-23 07:50:12'),(41,'127.0.0.1','api_general','2026-10-23 07:50:17'),(43,'127.0.0.1','api_general','2026-10-23 08:12:21'),(44,'127.0.0.1','api_general','2026-10-23 08:12:33'),(45,'127.0.0.1','api_general','2026-10-23 08:12:33'),(46,'127.0.0.1','api_general','2026-10-23 08:12:47'),(47,'127.0.0.1','api_general','2026-10-23 08:12:47'),(48,'127.0.0.1','api_general','2026-10-23 08:12:47'),(49,'127.0.0.1','api_general','2026-10-23 08:12:51'),(50,'127.0.0.1','api_general','2026-10-23 08:12:51'),(51,'127.0.0.1','api_general','2026-10-23 08:12:55'),(52,'127.0.0.1','api_general','2026-10-23 08:12:55'),(53,'127.0.0.1','api_general','2026-10-23 08:13:18'),(54,'127.0.0.1','api_general','2026-10-23 08:13:18'),(55,'127.0.0.1','api_general','2026-10-23 08:13:20'),(56,'127.0.0.1','api_general','2026-10-23 08:13:29'),(57,'127.0.0.1','api_general','2026-10-23 08:14:11'),(58,'127.0.0.1','api_general','2026-10-23 08:14:18'),(59,'127.0.0.1','api_general','2026-10-23 08:14:18'),(60,'127.0.0.1','api_general','2026-10-23 08:14:18'),(61,'127.0.0.1','api_general','2026-10-23 08:14:18'),(62,'127.0.0.1','api_general','2026-10-23 08:14:20'),(63,'127.0.0.1','api_general','2026-10-23 08:14:20'),(1,'127.0.0.1','login','2026-10-23 07:43:26'),(2,'127.0.0.1','login','2026-10-23 07:43:34'),(3,'127.0.0.1','login','2026-10-23 07:43:40'),(5,'127.0.0.1','login','2026-10-23 07:47:08');
/*!40000 ALTER TABLE `rate_limits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_email` (`email`),
  KEY `idx_role` (`role`),
  KEY `idx_estado` (`estado`),
  KEY `idx_users_email_role` (`email`,`role`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin@marcona.pe','$2a$12$CYrwjnLFl6rm09W8AhKG5.bmUeCUh44AVdmKiClapUD5pwJ1DKOai','Administrador General','admin','activo',1,'2026-10-23 07:40:03','2026-10-23 07:45:58');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicle_assignments`
--

DROP TABLE IF EXISTS `vehicle_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicle_assignments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `vehicle_id` int unsigned NOT NULL,
  `driver_id` int unsigned NOT NULL,
  `tipo` enum('propietario','alquiler','reemplazo_temporal') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'propietario',
  `propietario_nombre` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `propietario_dni` char(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `notas` text COLLATE utf8mb4_unicode_ci,
  `created_by` int unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_active_vehicle` (`vehicle_id`,`activo`),
  KEY `created_by` (`created_by`),
  KEY `idx_va_vehicle_active` (`vehicle_id`,`activo`),
  KEY `idx_va_driver` (`driver_id`),
  CONSTRAINT `vehicle_assignments_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `vehicle_assignments_ibfk_2` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `vehicle_assignments_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `vehicle_assignments_chk_1` CHECK (regexp_like(`propietario_dni`,_latin1'^[0-9]{8}$'))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicle_assignments`
--

LOCK TABLES `vehicle_assignments` WRITE;
/*!40000 ALTER TABLE `vehicle_assignments` DISABLE KEYS */;
INSERT INTO `vehicle_assignments` VALUES (1,1,1,'propietario','Wilmer Samir Loro Amaya','70942778','2026-10-23',NULL,1,NULL,1,'2026-10-23 08:12:47','2026-10-23 08:12:47');
/*!40000 ALTER TABLE `vehicle_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicle_images`
--

DROP TABLE IF EXISTS `vehicle_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicle_images` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `vehicle_id` int unsigned NOT NULL,
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mime_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_size` int unsigned NOT NULL,
  `sort_order` tinyint unsigned NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_vehicle_sort` (`vehicle_id`,`sort_order`),
  KEY `idx_vehicle_id` (`vehicle_id`),
  CONSTRAINT `vehicle_images_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicle_images`
--

LOCK TABLES `vehicle_images` WRITE;
/*!40000 ALTER TABLE `vehicle_images` DISABLE KEYS */;
INSERT INTO `vehicle_images` VALUES (1,1,'Gemini_Generated_Image_q1qb0eq1qb0eq1qb.jpeg','uploads/vehicles/1/vehicle_1_8b4571973c_1.jpg','image/jpeg',76104,1,'2026-10-23 08:12:21'),(2,1,'Gemini_Generated_Image_vfrqpovfrqpovfrq.jpeg','uploads/vehicles/1/vehicle_1_6fe81f8809_2.jpg','image/jpeg',66247,2,'2026-10-23 08:12:21');
/*!40000 ALTER TABLE `vehicle_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicles`
--

DROP TABLE IF EXISTS `vehicles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicles` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `driver_id` int unsigned DEFAULT NULL,
  `company_id` int unsigned DEFAULT NULL,
  `tipo_propiedad` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_servicio` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `categoria` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `placa` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL,
  `marca` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `modelo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `color` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ano_fabricacion` int DEFAULT NULL,
  `numero_vin` varchar(17) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero_motor` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `combustible` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `soat_poliza` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `soat_aseguradora` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `soat_vencimiento` date DEFAULT NULL,
  `rt_entidad` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rt_certificado` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rt_vencimiento` date DEFAULT NULL,
  `estado` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `placa` (`placa`),
  UNIQUE KEY `numero_vin` (`numero_vin`),
  KEY `idx_placa` (`placa`),
  KEY `idx_driver_id` (`driver_id`),
  KEY `idx_company_id` (`company_id`),
  KEY `idx_estado` (`estado`),
  KEY `idx_vehicles_company` (`company_id`,`estado`),
  CONSTRAINT `vehicles_ibfk_1` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `vehicles_ibfk_2` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `vehicles_chk_1` CHECK (regexp_like(`placa`,_utf8mb4'^[A-Z0-9-]{6,7}$'))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicles`
--

LOCK TABLES `vehicles` WRITE;
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
INSERT INTO `vehicles` VALUES (1,NULL,1,'particular','Moto-Taxi','L5','ABC-123','bajaj','Torito','blanco',2026,NULL,NULL,'Gasolina','R1020304050','Rimac','2026-10-31','Rimac','1020304050','2026-10-31','activo','2026-10-23 08:12:21','2026-10-23 08:12:21');
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `verifications`
--

DROP TABLE IF EXISTS `verifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `verifications` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `search_type` enum('placa','dni','permiso') COLLATE utf8mb4_unicode_ci NOT NULL,
  `search_query` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `resultado` enum('autorizado','rechazado') COLLATE utf8mb4_unicode_ci NOT NULL,
  `motivos` json DEFAULT NULL,
  `vehicle_data` json DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0.0.0.0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ver_user_created` (`user_id`,`created_at`),
  KEY `idx_ver_resultado` (`resultado`),
  KEY `idx_ver_created` (`created_at`),
  KEY `idx_ver_search` (`search_type`,`search_query`),
  CONSTRAINT `verifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `verifications`
--

LOCK TABLES `verifications` WRITE;
/*!40000 ALTER TABLE `verifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `verifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'marcona_permisos'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-01  2:25:44
