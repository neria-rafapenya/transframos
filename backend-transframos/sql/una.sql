-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 21-03-2026 a las 16:50:46
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `provider_manager`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_ai_conversation_messages`
--

CREATE TABLE `tra_ai_conversation_messages` (
  `message_id` char(36) NOT NULL,
  `session_id` char(36) NOT NULL,
  `message_sequence` int(11) NOT NULL,
  `sender_type` varchar(20) NOT NULL,
  `message_text` text NOT NULL,
  `raw_payload` longtext DEFAULT NULL,
  `extracted_intent_id` char(36) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tra_ai_conversation_messages`
--

INSERT INTO `tra_ai_conversation_messages` (`message_id`, `session_id`, `message_sequence`, `sender_type`, `message_text`, `raw_payload`, `extracted_intent_id`, `created_at`) VALUES
('0020479c-5e2a-4789-9894-a4cd329215b4', '95759801-03ef-4e15-b6d4-5372b8989d09', 1, 'user', 'Necesito transportar 4000 litros de zumo', NULL, NULL, '2026-03-21 11:16:57'),
('0039e0af-e43f-4b44-9200-9ee66bd0ee39', '861a7967-6a5d-4829-91fe-ec2309ef4046', 7, 'user', 'recogida el 24/05/2026 a las 21:34', NULL, NULL, '2026-03-21 11:03:46'),
('03357e2b-54c7-4d89-b3b2-93e0cc87acca', '9032db00-ebd9-412e-9525-dec6a6a56837', 6, 'user', 'necesito transportar 1200 litros de leche de lleida a malaga', NULL, NULL, '2026-03-20 19:11:01'),
('0389f7f4-cdef-4115-b195-5cb06d3312e6', 'ee55ce44-2ccd-4b28-9c3a-80739ad0748d', 1, 'user', 'necesito transportar 1200 litros de leche desde Malaga a Gijon', NULL, NULL, '2026-03-20 19:31:34'),
('0427d60a-2be1-4efe-9256-a2c5aaae7eaf', '036ca52d-e76e-47bb-89e1-efd58819ec66', 2, 'assistant', 'He entendido producto: leche, cantidad: 1200 litros, origen: Malaga, destino: Madrid. Me faltan la fecha de recogida y el límite de entrega. ¿Me los indicas?', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":\"leche\",\"quantityValue\":1200,\"quantityUnit\":\"litros\",\"originText\":\"Malaga\",\"destinationText\":\"Madrid\",\"requestedPickupAt\":null,\"deliveryDeadlineAt\":null},\"missingFields\":[\"requested_date\",\"delivery_deadline\"],\"nextBestQuestion\":\"¿Para qué fecha necesitas que recojamos la leche y cuál es la fecha límite de entrega?\",\"confidence\":0.9},\"validationSummary\":null}', NULL, '2026-03-20 20:48:18'),
('04e1e928-0d34-4660-9e16-42873bed340e', '691208f1-454b-47fc-b454-c963ca6cd035', 1, 'user', 'necesito una cuba de transorte para llevar leche desde Lleida a Morón de la frontera', NULL, NULL, '2026-03-21 11:45:15'),
('05bcb4ad-2b65-424c-9bf7-81d558b478dc', '861a7967-6a5d-4829-91fe-ec2309ef4046', 9, 'user', 'lmite de enrega el día 4 de Agosto a las 12:00', NULL, NULL, '2026-03-21 11:04:10'),
('09c9bf99-66e7-46bb-a93e-f20eceb070bb', 'a94a2422-7ad6-4323-9035-f3ae5af00538', 6, 'assistant', 'He podido completar la solicitud, pero de momento no pasa validación.', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":\"leche\",\"quantityValue\":1200,\"quantityUnit\":\"litros\",\"originText\":\"Malaga\",\"destinationText\":\"madrid\",\"requestedPickupAt\":\"2026-05-12T12:34:00\",\"deliveryDeadlineAt\":\"2026-05-14T22:00:00\"},\"missingFields\":[],\"nextBestQuestion\":null,\"confidence\":0.95},\"validationSummary\":{\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"total\":7,\"passed\":6,\"failed\":1,\"warnings\":0,\"results\":[{\"id\":\"108e5de0-e686-4165-9b4c-4c12ae8f5326\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"LOAD_DATE_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Fecha de carga informada correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:56:38.000Z\"},{\"id\":\"4b192783-5951-4011-9607-d493703d52e5\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"DELIVERY_DEADLINE_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Límite de entrega informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:56:38.000Z\"},{\"id\":\"778d7486-f681-494f-bb48-045473acd002\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"QUANTITY_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Cantidad informada correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:56:38.000Z\"},{\"id\":\"b2f8418a-62f2-49b0-913b-f182cd40017b\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"DESTINATION_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Destino informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:56:38.000Z\"},{\"id\":\"cd1cc36e-d4a3-48f3-8b4d-e280dc0e09ac\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"PRODUCT_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Producto informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:56:38.000Z\"},{\"id\":\"da5767de-9ab9-49c8-9fcb-4ee4f92d152c\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"COMPATIBILITY_PRODUCT_NOT_FOUND\",\"severity\":\"error\",\"validationStatus\":\"failed\",\"message\":\"No se ha podido normalizar el producto en catálogo para validar compatibilidad.\",\"blocking\":true,\"createdAt\":\"2026-03-20T20:56:38.000Z\"},{\"id\":\"dbe0cfef-0aaf-4e21-8e0e-0b43a95a0939\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"ORIGIN_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Origen informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:56:38.000Z\"}]}}', NULL, '2026-03-20 20:56:38'),
('169ec64d-dfd9-4d05-af58-9c6ea0662418', '6f5dad78-f378-444a-92f0-3a5a12152765', 1, 'user', 'csdcw', NULL, NULL, '2026-03-21 11:32:33'),
('17980a84-8259-4b66-a330-f2bf6b6e386b', 'fb969b06-0124-4c89-aeb2-c5f1c9c00d16', 5, 'user', 'recogida el 12 de agosto a las 14:00 y entrega limite el 25 de octubre a las 12:00', NULL, NULL, '2026-03-21 13:50:16'),
('1a21f742-67c9-43fd-9863-75a40aa817b3', '861a7967-6a5d-4829-91fe-ec2309ef4046', 4, 'assistant', 'He entendido producto: zumo, cantidad: 4000 litros, origen: Lleida. Todavía necesito el destino, la fecha de recogida y el límite de entrega.', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":\"zumo\",\"quantityValue\":4000,\"quantityUnit\":\"litros\",\"originText\":\"Lleida\",\"destinationText\":null,\"requestedPickupAt\":null,\"deliveryDeadlineAt\":null},\"missingFields\":[\"destination\",\"requested_date\",\"delivery_deadline\"],\"nextBestQuestion\":\"¿Cuál es el destino del transporte y qué fechas tienes para la recogida y la entrega?\",\"confidence\":0.9},\"validationSummary\":null}', NULL, '2026-03-21 11:02:57'),
('1e0e322f-eb0f-4695-8339-842dd29fc85f', 'fb969b06-0124-4c89-aeb2-c5f1c9c00d16', 6, 'assistant', 'He podido completar la solicitud, pero hay varios puntos que impiden validarla: Necesito una dirección o punto de carga válido para el origen; No hay disponibilidad registrada de vehículos para esa fecha; Necesito una dirección o punto de entrega válido para el destino. ¿Puedes revisarlos?', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":\"leche\",\"quantityValue\":1200,\"quantityUnit\":\"litros\",\"originText\":\"lleida\",\"destinationText\":\"malaga\",\"originAddressText\":null,\"originContactName\":null,\"originContactPhone\":null,\"destinationAddressText\":null,\"destinationContactName\":null,\"destinationContactPhone\":null,\"requestedPickupAt\":\"2024-08-12T14:00:00\",\"deliveryDeadlineAt\":\"2024-10-25T12:00:00\"},\"missingFields\":[\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\"],\"nextBestQuestion\":\"¿Me puedes proporcionar las direcciones y los datos de contacto tanto del origen en Lleida como del destino en Málaga?\",\"confidence\":0.95},\"validationSummary\":{\"quoteRequestId\":\"ac7957fc-a794-449a-9b16-ba59bfb3c317\",\"total\":11,\"passed\":7,\"failed\":3,\"warnings\":1,\"results\":[{\"id\":\"1658cdc6-34c5-496a-ad61-0d79189a2a7b\",\"sessionId\":null,\"quoteRequestId\":\"ac7957fc-a794-449a-9b16-ba59bfb3c317\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"ORIGIN_POINT_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"failed\",\"message\":\"Necesito una dirección o punto de carga válido para el origen.\",\"blocking\":true,\"createdAt\":\"2026-03-21T13:50:20.000Z\"},{\"id\":\"545ec014-dccb-4103-96f9-065ef9c817e3\",\"sessionId\":null,\"quoteRequestId\":\"ac7957fc-a794-449a-9b16-ba59bfb3c317\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"COMPATIBILITY_REVIEW_REQUIRED\",\"severity\":\"warning\",\"validationStatus\":\"warning\",\"message\":\"No hay validación directa de food grade a nivel de vehículo. Se recomienda revisión operativa si es crítico.\",\"blocking\":false,\"createdAt\":\"2026-03-21T13:50:20.000Z\"},{\"id\":\"7b0b4e1b-7f39-4927-8ff0-c152438499a3\",\"sessionId\":null,\"quoteRequestId\":\"ac7957fc-a794-449a-9b16-ba59bfb3c317\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"DESTINATION_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Destino informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T13:50:20.000Z\"},{\"id\":\"7dbe6dcd-d658-4475-b1cc-76684c09ba07\",\"sessionId\":null,\"quoteRequestId\":\"ac7957fc-a794-449a-9b16-ba59bfb3c317\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"QUANTITY_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Cantidad informada correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T13:50:20.000Z\"},{\"id\":\"81f8e4fa-e2e5-4ffc-83a9-7a1e7787ab43\",\"sessionId\":null,\"quoteRequestId\":\"ac7957fc-a794-449a-9b16-ba59bfb3c317\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"PRODUCT_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Producto informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T13:50:20.000Z\"},{\"id\":\"8d1ab5d0-224a-4c3a-bbec-d56ca243c487\",\"sessionId\":null,\"quoteRequestId\":\"ac7957fc-a794-449a-9b16-ba59bfb3c317\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"LOAD_DATE_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Fecha de carga informada correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T13:50:20.000Z\"},{\"id\":\"c0f00baf-f9d2-4cb1-bb54-4589de297992\",\"sessionId\":null,\"quoteRequestId\":\"ac7957fc-a794-449a-9b16-ba59bfb3c317\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"AVAILABILITY_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"failed\",\"message\":\"No hay disponibilidad registrada de vehículos para esa fecha.\",\"blocking\":true,\"createdAt\":\"2026-03-21T13:50:20.000Z\"},{\"id\":\"c41f9309-87ea-46cf-ac31-ac8c2a58c30a\",\"sessionId\":null,\"quoteRequestId\":\"ac7957fc-a794-449a-9b16-ba59bfb3c317\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"DESTINATION_POINT_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"failed\",\"message\":\"Necesito una dirección o punto de entrega válido para el destino.\",\"blocking\":true,\"createdAt\":\"2026-03-21T13:50:20.000Z\"},{\"id\":\"c5abd9bc-f76e-4c1c-ad15-13d84d8d9d40\",\"sessionId\":null,\"quoteRequestId\":\"ac7957fc-a794-449a-9b16-ba59bfb3c317\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"COMPATIBILITY_TANKS_AVAILABLE\",\"severity\":\"info\",\"validationStatus\":\"passed\",\"message\":\"Se han encontrado 2 tanques compatibles para el producto.\",\"blocking\":false,\"createdAt\":\"2026-03-21T13:50:20.000Z\"},{\"id\":\"c6d0886c-fa23-4600-9d96-8f5bd2c90776\",\"sessionId\":null,\"quoteRequestId\":\"ac7957fc-a794-449a-9b16-ba59bfb3c317\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"DELIVERY_DEADLINE_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Límite de entrega informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T13:50:20.000Z\"},{\"id\":\"e00c557c-00fd-4a02-9724-d22b5c018c8d\",\"sessionId\":null,\"quoteRequestId\":\"ac7957fc-a794-449a-9b16-ba59bfb3c317\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"ORIGIN_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Origen informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T13:50:20.000Z\"}]}}', NULL, '2026-03-21 13:50:20'),
('22a3d7bb-0295-4739-a002-07dc5fb9dbe9', '861a7967-6a5d-4829-91fe-ec2309ef4046', 3, 'user', 'desde Lleida', NULL, NULL, '2026-03-21 11:02:53'),
('255d0352-03af-44e3-962a-42f90cda918f', 'fb969b06-0124-4c89-aeb2-c5f1c9c00d16', 2, 'assistant', 'He entendido producto: leche, cantidad: 1200 litros. Todavía necesito el origen, el destino, la fecha de recogida y el límite de entrega.', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":\"leche\",\"quantityValue\":1200,\"quantityUnit\":\"litros\",\"originText\":null,\"destinationText\":null,\"originAddressText\":null,\"originContactName\":null,\"originContactPhone\":null,\"destinationAddressText\":null,\"destinationContactName\":null,\"destinationContactPhone\":null,\"requestedPickupAt\":null,\"deliveryDeadlineAt\":null},\"missingFields\":[\"origin\",\"destination\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"],\"nextBestQuestion\":\"¿Podrías indicarme el lugar de origen y destino, así como las direcciones y los contactos con teléfono para ambos puntos, además de las fechas de recogida y entrega?\",\"confidence\":0.8},\"validationSummary\":null}', NULL, '2026-03-21 13:49:43'),
('3430d3d4-1844-4b11-a464-d57e009c56c8', '861a7967-6a5d-4829-91fe-ec2309ef4046', 10, 'assistant', 'He podido completar la solicitud, pero hay un punto que impide validarla: No se ha podido normalizar el producto en catálogo para validar compatibilidad. ¿Puedes revisarlo?', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":\"zumo\",\"quantityValue\":4000,\"quantityUnit\":\"litros\",\"originText\":\"Lleida\",\"destinationText\":\"Málaga\",\"requestedPickupAt\":\"2026-05-24T21:34:00\",\"deliveryDeadlineAt\":\"2026-08-04T12:00:00\"},\"missingFields\":[],\"nextBestQuestion\":null,\"confidence\":0.95},\"validationSummary\":{\"quoteRequestId\":\"04d06af3-dcff-4d4d-b1f0-f003ee894ab7\",\"total\":7,\"passed\":6,\"failed\":1,\"warnings\":0,\"results\":[{\"id\":\"08fd37c7-b3c7-4b6f-977d-77383c05b42d\",\"sessionId\":null,\"quoteRequestId\":\"04d06af3-dcff-4d4d-b1f0-f003ee894ab7\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"ORIGIN_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Origen informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T11:04:12.000Z\"},{\"id\":\"660971e1-3ded-4c2d-a951-26d42939c80f\",\"sessionId\":null,\"quoteRequestId\":\"04d06af3-dcff-4d4d-b1f0-f003ee894ab7\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"DELIVERY_DEADLINE_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Límite de entrega informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T11:04:12.000Z\"},{\"id\":\"75e8f070-7cdd-4144-baf9-d7681977eca1\",\"sessionId\":null,\"quoteRequestId\":\"04d06af3-dcff-4d4d-b1f0-f003ee894ab7\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"PRODUCT_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Producto informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T11:04:12.000Z\"},{\"id\":\"9d13e602-7125-4f94-b8e1-ffd5da454576\",\"sessionId\":null,\"quoteRequestId\":\"04d06af3-dcff-4d4d-b1f0-f003ee894ab7\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"LOAD_DATE_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Fecha de carga informada correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T11:04:12.000Z\"},{\"id\":\"ac576102-f24d-42d4-bab1-c52b2f24e02d\",\"sessionId\":null,\"quoteRequestId\":\"04d06af3-dcff-4d4d-b1f0-f003ee894ab7\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"QUANTITY_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Cantidad informada correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T11:04:12.000Z\"},{\"id\":\"e1acfc7a-ad4c-44be-90b3-1964326786e1\",\"sessionId\":null,\"quoteRequestId\":\"04d06af3-dcff-4d4d-b1f0-f003ee894ab7\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"COMPATIBILITY_PRODUCT_NOT_FOUND\",\"severity\":\"error\",\"validationStatus\":\"failed\",\"message\":\"No se ha podido normalizar el producto en catálogo para validar compatibilidad.\",\"blocking\":true,\"createdAt\":\"2026-03-21T11:04:12.000Z\"},{\"id\":\"f8730790-5b7c-4427-8599-789cf4d50194\",\"sessionId\":null,\"quoteRequestId\":\"04d06af3-dcff-4d4d-b1f0-f003ee894ab7\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"DESTINATION_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Destino informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T11:04:12.000Z\"}]}}', NULL, '2026-03-21 11:04:12'),
('351e9fa2-e621-4405-8f73-3d61c18f444f', '9032db00-ebd9-412e-9525-dec6a6a56837', 7, 'assistant', 'Todavía necesito el producto, la cantidad, el origen, el destino, la fecha de recogida y el límite de entrega.', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":null,\"quantityValue\":null,\"quantityUnit\":null,\"originText\":null,\"destinationText\":null,\"requestedPickupAt\":null,\"deliveryDeadlineAt\":null},\"missingFields\":[],\"nextBestQuestion\":null,\"confidence\":0},\"validationSummary\":null}', NULL, '2026-03-20 19:11:01'),
('3a8edf16-8a3d-4eaf-bf98-79acf809e409', '9032db00-ebd9-412e-9525-dec6a6a56837', 4, 'user', 'necesito transportar 1200 litros de lehce de lleid aa malaga', NULL, NULL, '2026-03-20 19:09:59'),
('3d7c0ca1-7a46-4146-8c47-10bb8def0c24', '036ca52d-e76e-47bb-89e1-efd58819ec66', 4, 'assistant', 'He entendido fecha de recogida: 2026-05-12T00:00:00, límite de entrega: 2026-05-14T22:00:00. Todavía necesito la cantidad, el origen y el destino.', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":null,\"quantityValue\":null,\"quantityUnit\":null,\"originText\":null,\"destinationText\":null,\"requestedPickupAt\":\"2026-05-12T00:00:00\",\"deliveryDeadlineAt\":\"2026-05-14T22:00:00\"},\"missingFields\":[\"product\",\"quantity\",\"origin\",\"destination\"],\"nextBestQuestion\":\"¿Podrías confirmarme el producto, la cantidad, el origen y el destino para completar la información?\",\"confidence\":0.9},\"validationSummary\":null}', NULL, '2026-03-20 20:49:06'),
('485b4984-b04d-4f8a-89ae-41bc563de61a', 'd7433268-cf01-4283-a7e4-930bd36ea92d', 4, 'assistant', 'Resumen: Se realizará un transporte de 15000 litros de leche con recogida 2024-08-12T12:30:00 en Lleida. Entrega 2024-08-13T22:00:00 en Moron. Coste estimado: 2050 €. Tránsito estimado: N/D horas.', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":null,\"quantityValue\":15000,\"quantityUnit\":\"litros\",\"originText\":null,\"destinationText\":\"Moron\",\"originAddressText\":null,\"originContactName\":null,\"originContactPhone\":null,\"destinationAddressText\":null,\"destinationContactName\":null,\"destinationContactPhone\":null,\"requestedPickupAt\":\"2024-08-12T12:30:00\",\"deliveryDeadlineAt\":\"2024-08-13T22:00:00\"},\"missingFields\":[\"product\",\"origin\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\"],\"nextBestQuestion\":\"¿Podrías indicarme qué producto se transporta, la dirección exacta y el contacto (nombre y teléfono) tanto del origen como del destino?\",\"confidence\":0.9},\"validationSummary\":{\"quoteRequestId\":\"fa35312a-bb27-4f29-bac0-401419fd54ab\",\"total\":8,\"passed\":7,\"failed\":0,\"warnings\":1,\"results\":[{\"id\":\"0bb0f11c-9d40-4b8b-91bc-fe2034cc1e70\",\"sessionId\":null,\"quoteRequestId\":\"fa35312a-bb27-4f29-bac0-401419fd54ab\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"QUANTITY_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Cantidad informada correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T11:53:56.000Z\"},{\"id\":\"1f57a0e4-5176-4660-9c6b-160b1abafd20\",\"sessionId\":null,\"quoteRequestId\":\"fa35312a-bb27-4f29-bac0-401419fd54ab\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"DESTINATION_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Destino informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T11:53:56.000Z\"},{\"id\":\"a504bc07-054f-47df-8f4e-d10222705f84\",\"sessionId\":null,\"quoteRequestId\":\"fa35312a-bb27-4f29-bac0-401419fd54ab\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"COMPATIBILITY_REVIEW_REQUIRED\",\"severity\":\"warning\",\"validationStatus\":\"warning\",\"message\":\"No hay validación directa de food grade a nivel de vehículo. Se recomienda revisión operativa si es crítico.\",\"blocking\":false,\"createdAt\":\"2026-03-21T11:53:56.000Z\"},{\"id\":\"ad200e19-1a58-4752-9d1d-880f4ad9761b\",\"sessionId\":null,\"quoteRequestId\":\"fa35312a-bb27-4f29-bac0-401419fd54ab\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"LOAD_DATE_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Fecha de carga informada correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T11:53:56.000Z\"},{\"id\":\"d1b65467-75fc-4e65-bdf8-a42eb8d898e7\",\"sessionId\":null,\"quoteRequestId\":\"fa35312a-bb27-4f29-bac0-401419fd54ab\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"ORIGIN_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Origen informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T11:53:56.000Z\"},{\"id\":\"e37ef666-3099-4714-b917-be9049544240\",\"sessionId\":null,\"quoteRequestId\":\"fa35312a-bb27-4f29-bac0-401419fd54ab\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"DELIVERY_DEADLINE_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Límite de entrega informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T11:53:56.000Z\"},{\"id\":\"e3c3091c-d805-401f-a3c2-4ded0387660c\",\"sessionId\":null,\"quoteRequestId\":\"fa35312a-bb27-4f29-bac0-401419fd54ab\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"PRODUCT_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Producto informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T11:53:56.000Z\"},{\"id\":\"eadc4986-894a-4149-b0ed-278247d49326\",\"sessionId\":null,\"quoteRequestId\":\"fa35312a-bb27-4f29-bac0-401419fd54ab\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"COMPATIBILITY_TANKS_AVAILABLE\",\"severity\":\"info\",\"validationStatus\":\"passed\",\"message\":\"Se han encontrado 2 tanques compatibles para el producto.\",\"blocking\":false,\"createdAt\":\"2026-03-21T11:53:56.000Z\"}]}}', NULL, '2026-03-21 11:53:56'),
('4e8398e3-d75e-4565-9053-dd0173b6ee21', '95759801-03ef-4e15-b6d4-5372b8989d09', 2, 'assistant', 'Aviso: el producto indicado no está en el catálogo. He entendido producto: zumo, cantidad: 4000 litros. Todavía necesito el origen, el destino, la fecha de recogida y el límite de entrega.', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":\"zumo\",\"quantityValue\":4000,\"quantityUnit\":\"litros\",\"originText\":null,\"destinationText\":null,\"originAddressText\":null,\"originContactName\":null,\"originContactPhone\":null,\"destinationAddressText\":null,\"destinationContactName\":null,\"destinationContactPhone\":null,\"requestedPickupAt\":null,\"deliveryDeadlineAt\":null},\"missingFields\":[\"origin\",\"destination\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"],\"nextBestQuestion\":\"¿Podrías indicarme el lugar de origen y destino del transporte, así como las direcciones y los datos de contacto de ambas ubicaciones, además de las fechas de recogida y entrega?\",\"confidence\":0.8},\"validationSummary\":null}', NULL, '2026-03-21 11:17:04'),
('4e9caf07-7e0e-4cc8-8f57-c06c089ac81e', 'fb969b06-0124-4c89-aeb2-c5f1c9c00d16', 1, 'user', 'quiero transportar 1200 litros de leche', NULL, NULL, '2026-03-21 13:49:39'),
('50787f08-4ed2-489b-a029-4302c4a65237', 'd7433268-cf01-4283-a7e4-930bd36ea92d', 3, 'user', 'serían 15000 litros para recoger el 12 de agosto a las 12:30 y llevarlo a Moron el día 13 antes de las 22:00', NULL, NULL, '2026-03-21 11:53:49'),
('517ffaaf-82a1-46ff-b592-48aa0635859e', '584fe2ec-1416-4c49-8fed-dbd2b8ccdacf', 2, 'assistant', 'Aviso: el producto indicado no está en el catálogo. He entendido producto: zumo, cantidad: 4000 litros. Antes de seguir, necesito que indiques un producto que esté en el catálogo. ¿Puedes decirme otro producto? Si prefieres, puedo pasar tu solicitud a ventas.', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":\"zumo\",\"quantityValue\":4000,\"quantityUnit\":\"litros\",\"originText\":null,\"destinationText\":null,\"originAddressText\":null,\"originContactName\":null,\"originContactPhone\":null,\"destinationAddressText\":null,\"destinationContactName\":null,\"destinationContactPhone\":null,\"requestedPickupAt\":null,\"deliveryDeadlineAt\":null},\"missingFields\":[\"origin\",\"destination\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"],\"nextBestQuestion\":\"¿Podrías indicarme el lugar de origen y destino, así como las direcciones y los contactos para la recogida y entrega, además de las fechas de recogida y entrega previstas?\",\"confidence\":0.9},\"validationSummary\":null}', NULL, '2026-03-21 11:19:10'),
('5952dd6f-3f0e-4902-ad3c-f1d3958f9c58', 'a94a2422-7ad6-4323-9035-f3ae5af00538', 1, 'user', 'quiero transportar 1200 litros de leche desde Malaga a madrid', NULL, NULL, '2026-03-20 20:55:15'),
('5a8d2ca9-726a-4c86-93bd-298633092176', '036ca52d-e76e-47bb-89e1-efd58819ec66', 3, 'user', 'recogida el 12/05/2026 pra entregar antes de las 22:0 del 14/05/2026', NULL, NULL, '2026-03-20 20:49:02'),
('617a2b9f-8bc2-47e8-af29-7366dd10da9f', '9032db00-ebd9-412e-9525-dec6a6a56837', 2, 'user', 'necesito transportar 1200 litros de lehce de lleid aa malaga', NULL, NULL, '2026-03-20 18:19:42'),
('679338a2-c73c-472d-aa70-deaac94e0904', 'd7433268-cf01-4283-a7e4-930bd36ea92d', 2, 'assistant', 'He entendido producto: leche, origen: Lleida, destino: Morón de la frontera. Todavía necesito la cantidad, la fecha de recogida y el límite de entrega.', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":\"leche\",\"quantityValue\":null,\"quantityUnit\":null,\"originText\":\"Lleida\",\"destinationText\":\"Morón de la frontera\",\"originAddressText\":null,\"originContactName\":null,\"originContactPhone\":null,\"destinationAddressText\":null,\"destinationContactName\":null,\"destinationContactPhone\":null,\"requestedPickupAt\":null,\"deliveryDeadlineAt\":null},\"missingFields\":[\"quantity\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"],\"nextBestQuestion\":\"¿Podrías indicarme la cantidad y unidad del producto, las direcciones completas de origen y destino, los nombres y teléfonos de contacto en ambos lugares, así como la fecha y hora solicitadas para la recogida y la entrega?\",\"confidence\":0.8},\"validationSummary\":null}', NULL, '2026-03-21 11:53:36'),
('759b1237-22eb-4f2d-9568-212eae1c6f5e', 'a94a2422-7ad6-4323-9035-f3ae5af00538', 3, 'user', 'recogida el 12/05/2026 para entregar antes de las 22:0 del 14/05/2026', NULL, NULL, '2026-03-20 20:55:28'),
('77e3acb7-da75-48e9-bc47-adcfec943088', '584fe2ec-1416-4c49-8fed-dbd2b8ccdacf', 4, 'assistant', 'Aviso: el producto indicado no está en el catálogo. Antes de seguir, necesito que indiques un producto que esté en el catálogo. ¿Puedes decirme otro producto? Si prefieres, puedo pasar tu solicitud a ventas.', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":null,\"quantityValue\":null,\"quantityUnit\":null,\"originText\":null,\"destinationText\":null,\"originAddressText\":null,\"originContactName\":null,\"originContactPhone\":null,\"destinationAddressText\":null,\"destinationContactName\":null,\"destinationContactPhone\":null,\"requestedPickupAt\":null,\"deliveryDeadlineAt\":null},\"missingFields\":[\"product\",\"quantity\",\"origin\",\"destination\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"],\"nextBestQuestion\":\"¿Podrías proporcionarme los detalles del producto, cantidad, origen, destino, direcciones y contactos, así como las fechas de recogida y entrega para poder pasar la solicitud a ventas?\",\"confidence\":0.1},\"validationSummary\":null}', NULL, '2026-03-21 11:19:31'),
('7b440cb1-760d-4f5d-a2a5-59ccc52a3b4d', 'fb969b06-0124-4c89-aeb2-c5f1c9c00d16', 8, 'user', 'origen desde c/ master 23, 25006 LLeida y entrega en C/ Velazqueza 45 456789 Malaga', NULL, NULL, '2026-03-21 13:51:23'),
('80053872-debf-493c-bfbc-bbe56419dcc4', 'd7433268-cf01-4283-a7e4-930bd36ea92d', 1, 'user', 'necesito una cuba de transorte para llevar leche desde Lleida a Morón de la frontera', NULL, NULL, '2026-03-21 11:53:31'),
('81c6ec21-30f1-48f4-8de2-893e0e1fb275', 'a94a2422-7ad6-4323-9035-f3ae5af00538', 11, 'user', 'recogida el 12/05/2026 a las 12:34 para entregar antes de las 22:00 del 14/05/2026', NULL, NULL, '2026-03-20 21:00:51'),
('833cd6e0-b0f2-4626-b9f4-4e5fd58b0024', '9032db00-ebd9-412e-9525-dec6a6a56837', 5, 'assistant', 'Todavía necesito el producto, la cantidad, el origen, el destino, la fecha de recogida y el límite de entrega.', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":null,\"quantityValue\":null,\"quantityUnit\":null,\"originText\":null,\"destinationText\":null,\"requestedPickupAt\":null,\"deliveryDeadlineAt\":null},\"missingFields\":[],\"nextBestQuestion\":null,\"confidence\":0},\"validationSummary\":null}', NULL, '2026-03-20 19:09:59'),
('84c040e7-9ac6-44e1-9467-2d66d77a0663', 'a94a2422-7ad6-4323-9035-f3ae5af00538', 10, 'assistant', 'He podido completar la solicitud, pero hay un punto que impide validarla: No se ha podido normalizar el producto en catálogo para validar compatibilidad. ¿Puedes revisarlo?', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":null,\"quantityValue\":null,\"quantityUnit\":null,\"originText\":null,\"destinationText\":null,\"requestedPickupAt\":\"2026-05-12T12:34:00\",\"deliveryDeadlineAt\":\"2026-05-14T22:00:00\"},\"missingFields\":[\"product\",\"quantity\",\"origin\",\"destination\"],\"nextBestQuestion\":\"¿Podrías indicarme el producto, la cantidad con unidad, el origen y el destino del transporte?\",\"confidence\":0.9},\"validationSummary\":{\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"total\":7,\"passed\":6,\"failed\":1,\"warnings\":0,\"results\":[{\"id\":\"34b661dd-6f18-4c66-89bf-b9bf4ca709b4\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"DESTINATION_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Destino informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:58:32.000Z\"},{\"id\":\"536e9508-07b5-4059-9987-88450c218935\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"LOAD_DATE_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Fecha de carga informada correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:58:32.000Z\"},{\"id\":\"bc542b0f-9fa8-4fd5-bcd4-060093e67bdb\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"COMPATIBILITY_PRODUCT_NOT_FOUND\",\"severity\":\"error\",\"validationStatus\":\"failed\",\"message\":\"No se ha podido normalizar el producto en catálogo para validar compatibilidad.\",\"blocking\":true,\"createdAt\":\"2026-03-20T20:58:32.000Z\"},{\"id\":\"d231b4fc-ed98-4b10-82b7-46a5cbdb917c\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"ORIGIN_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Origen informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:58:32.000Z\"},{\"id\":\"e20728a4-5ecd-4030-9101-9ac5f20d26b5\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"QUANTITY_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Cantidad informada correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:58:32.000Z\"},{\"id\":\"ebdb5757-0910-43ca-844e-89dea3228b29\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"PRODUCT_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Producto informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:58:32.000Z\"},{\"id\":\"f8686713-e6d0-42bc-b424-b14577d3f59c\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"DELIVERY_DEADLINE_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Límite de entrega informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:58:32.000Z\"}]}}', NULL, '2026-03-20 20:58:32'),
('94b85527-674e-4b18-876a-52db122f8343', '691208f1-454b-47fc-b454-c963ca6cd035', 2, 'assistant', 'He entendido producto: leche, origen: Lleida, destino: Morón de la frontera. Todavía necesito la cantidad, la fecha de recogida y el límite de entrega.', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":\"leche\",\"quantityValue\":null,\"quantityUnit\":null,\"originText\":\"Lleida\",\"destinationText\":\"Morón de la frontera\",\"originAddressText\":null,\"originContactName\":null,\"originContactPhone\":null,\"destinationAddressText\":null,\"destinationContactName\":null,\"destinationContactPhone\":null,\"requestedPickupAt\":null,\"deliveryDeadlineAt\":null},\"missingFields\":[\"quantity\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"],\"nextBestQuestion\":\"¿Podrías indicarme la cantidad y unidad del producto, las direcciones completas de origen y destino, los nombres y teléfonos de contacto en ambos lugares, así como las fechas de recogida y entrega?\",\"confidence\":0.8},\"validationSummary\":null}', NULL, '2026-03-21 11:45:21'),
('9fa35295-8156-4fc0-af01-728e139a4507', '861a7967-6a5d-4829-91fe-ec2309ef4046', 5, 'user', 'a Málaga', NULL, NULL, '2026-03-21 11:03:08'),
('a35f92c1-52dd-479d-8417-5fbb554b7cf8', 'ee55ce44-2ccd-4b28-9c3a-80739ad0748d', 3, 'user', 'el 12 de mayo a las 14:00, como limite el mismo día a las 22:00', NULL, NULL, '2026-03-20 19:32:22'),
('a3aca71e-7f9e-4008-b36d-9f962d35b9bc', '9032db00-ebd9-412e-9525-dec6a6a56837', 3, 'assistant', 'Necesito algunos datos más para continuar con la solicitud.', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":null,\"quantityValue\":null,\"quantityUnit\":null,\"originText\":null,\"destinationText\":null,\"requestedPickupAt\":null,\"deliveryDeadlineAt\":null},\"missingFields\":[],\"nextBestQuestion\":null,\"confidence\":0},\"validationSummary\":null}', NULL, '2026-03-20 18:19:42'),
('bbddb5f2-223e-4e86-82e3-d4aa5343efad', 'a94a2422-7ad6-4323-9035-f3ae5af00538', 2, 'assistant', 'He entendido producto: leche, cantidad: 1200 litros, origen: Malaga, destino: madrid. Me faltan la fecha de recogida y el límite de entrega. ¿Me los indicas?', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":\"leche\",\"quantityValue\":1200,\"quantityUnit\":\"litros\",\"originText\":\"Malaga\",\"destinationText\":\"madrid\",\"requestedPickupAt\":null,\"deliveryDeadlineAt\":null},\"missingFields\":[\"requested_date\",\"delivery_deadline\"],\"nextBestQuestion\":\"¿Para qué fecha necesitas que recojamos la leche y cuál es la fecha límite de entrega?\",\"confidence\":0.9},\"validationSummary\":null}', NULL, '2026-03-20 20:55:19'),
('bdd905a7-4803-49f7-a914-22db3ccefcd6', 'a94a2422-7ad6-4323-9035-f3ae5af00538', 9, 'user', 'recogida el 12/05/2026 a las 12:34 para entregar antes de las 22:00 del 14/05/2026', NULL, NULL, '2026-03-20 20:58:29'),
('c06dc95e-e8b0-496e-9d5e-edfc24912af2', '6f5dad78-f378-444a-92f0-3a5a12152765', 2, 'assistant', 'Todavía necesito el producto, la cantidad, el origen, el destino, la fecha de recogida y el límite de entrega.', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":null,\"quantityValue\":null,\"quantityUnit\":null,\"originText\":null,\"destinationText\":null,\"originAddressText\":null,\"originContactName\":null,\"originContactPhone\":null,\"destinationAddressText\":null,\"destinationContactName\":null,\"destinationContactPhone\":null,\"requestedPickupAt\":null,\"deliveryDeadlineAt\":null},\"missingFields\":[\"product\",\"quantity\",\"origin\",\"destination\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"],\"nextBestQuestion\":\"¿Podrías proporcionarme el producto, la cantidad con unidad, los lugares de origen y destino, las direcciones y contactos de ambos, así como las fechas de recogida y entrega?\",\"confidence\":0},\"validationSummary\":null}', NULL, '2026-03-21 11:32:37'),
('c274a6a0-e362-4ea5-995d-a9e24567ad8e', 'a94a2422-7ad6-4323-9035-f3ae5af00538', 8, 'assistant', 'He podido completar la solicitud, pero de momento no pasa validación.', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":null,\"quantityValue\":null,\"quantityUnit\":null,\"originText\":null,\"destinationText\":null,\"requestedPickupAt\":\"2026-05-12T12:34:00\",\"deliveryDeadlineAt\":\"2026-05-14T22:00:00\"},\"missingFields\":[\"product\",\"quantity\",\"origin\",\"destination\"],\"nextBestQuestion\":\"¿Podrías confirmarme qué producto quieres transportar, la cantidad exacta con unidad, y los lugares de origen y destino?\",\"confidence\":0.9},\"validationSummary\":{\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"total\":7,\"passed\":6,\"failed\":1,\"warnings\":0,\"results\":[{\"id\":\"3c1cb209-49d5-43c3-9506-8e0aaccb68b2\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"ORIGIN_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Origen informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:58:14.000Z\"},{\"id\":\"4c4b70c2-f53c-48fc-b3db-3aa651309207\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"LOAD_DATE_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Fecha de carga informada correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:58:14.000Z\"},{\"id\":\"5486cc1f-5e03-4c97-a9cf-ade7f043bf15\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"COMPATIBILITY_PRODUCT_NOT_FOUND\",\"severity\":\"error\",\"validationStatus\":\"failed\",\"message\":\"No se ha podido normalizar el producto en catálogo para validar compatibilidad.\",\"blocking\":true,\"createdAt\":\"2026-03-20T20:58:14.000Z\"},{\"id\":\"704b5a32-d6dc-4930-8343-3241e3d54fc1\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"PRODUCT_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Producto informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:58:14.000Z\"},{\"id\":\"98d1d013-deeb-4827-aebd-681e8a9652ea\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"QUANTITY_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Cantidad informada correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:58:14.000Z\"},{\"id\":\"a8b4d190-4dd0-42da-9a8c-c191322a7b32\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"DELIVERY_DEADLINE_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Límite de entrega informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:58:14.000Z\"},{\"id\":\"fe5c549a-ba00-49d8-9897-917c24b3efcb\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"DESTINATION_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Destino informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:58:14.000Z\"}]}}', NULL, '2026-03-20 20:58:14'),
('c9c9d192-4323-4464-a7bd-fccab632b61f', '584fe2ec-1416-4c49-8fed-dbd2b8ccdacf', 1, 'user', 'Necesito transportar 4000 litros de zumo', NULL, NULL, '2026-03-21 11:19:06'),
('c9fc8185-e309-48b3-a59d-b167da4f8f60', 'ee55ce44-2ccd-4b28-9c3a-80739ad0748d', 4, 'assistant', 'Ya tengo todos los datos y he generado una opción recomendada. Coste estimado: 394 €. Tránsito estimado: 12 horas.', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":\"leche\",\"quantityValue\":1200,\"quantityUnit\":\"litros\",\"originText\":\"Malaga\",\"destinationText\":\"Gijon\",\"requestedPickupAt\":\"2024-05-12T14:00:00+02:00\",\"deliveryDeadlineAt\":\"2024-05-12T22:00:00+02:00\"},\"missingFields\":[],\"nextBestQuestion\":null,\"confidence\":0.95},\"validationSummary\":{\"quoteRequestId\":\"d72cf8f2-d6ea-448b-94c0-e993af9bd482\",\"total\":6,\"passed\":6,\"failed\":0,\"warnings\":0,\"results\":[{\"id\":\"55adb7be-bd02-463a-abb6-a913e49cc59a\",\"sessionId\":null,\"quoteRequestId\":\"d72cf8f2-d6ea-448b-94c0-e993af9bd482\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"LOAD_DATE_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Fecha de carga informada correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T19:32:25.000Z\"},{\"id\":\"67338d7c-c967-460d-94f0-306d65cc78cb\",\"sessionId\":null,\"quoteRequestId\":\"d72cf8f2-d6ea-448b-94c0-e993af9bd482\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"PRODUCT_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Producto informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T19:32:25.000Z\"},{\"id\":\"93c56148-d033-44a4-82c0-c9693c5a6cf1\",\"sessionId\":null,\"quoteRequestId\":\"d72cf8f2-d6ea-448b-94c0-e993af9bd482\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"QUANTITY_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Cantidad informada correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T19:32:25.000Z\"},{\"id\":\"9c67a773-b0f2-4eb1-bfcb-4a55486b247e\",\"sessionId\":null,\"quoteRequestId\":\"d72cf8f2-d6ea-448b-94c0-e993af9bd482\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"DESTINATION_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Destino informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T19:32:25.000Z\"},{\"id\":\"cf26b35d-c03f-42ce-884b-3785ed76f1bb\",\"sessionId\":null,\"quoteRequestId\":\"d72cf8f2-d6ea-448b-94c0-e993af9bd482\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"DELIVERY_DEADLINE_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Límite de entrega informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T19:32:25.000Z\"},{\"id\":\"dedd64c9-b989-4770-88a7-2c24b7339efa\",\"sessionId\":null,\"quoteRequestId\":\"d72cf8f2-d6ea-448b-94c0-e993af9bd482\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"ORIGIN_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Origen informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T19:32:25.000Z\"}]}}', NULL, '2026-03-20 19:32:25'),
('ca56b6e0-28a5-4dd2-a74c-5c172e6f3b75', '861a7967-6a5d-4829-91fe-ec2309ef4046', 6, 'assistant', 'He entendido destino: Málaga. Me faltan la fecha de recogida y el límite de entrega. ¿Me los indicas?', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":null,\"quantityValue\":null,\"quantityUnit\":null,\"originText\":null,\"destinationText\":\"Málaga\",\"requestedPickupAt\":null,\"deliveryDeadlineAt\":null},\"missingFields\":[\"product\",\"quantity\",\"origin\",\"requested_date\",\"delivery_deadline\"],\"nextBestQuestion\":\"¿Podrías confirmarme el producto, la cantidad, el origen, la fecha de recogida y el límite de entrega, por favor?\",\"confidence\":0.9},\"validationSummary\":null}', NULL, '2026-03-21 11:03:12'),
('cd7d48b4-24bf-4430-a5e3-dff2f3ffa30e', '861a7967-6a5d-4829-91fe-ec2309ef4046', 1, 'user', 'Necesito transportar 4000 litros de zumo', NULL, NULL, '2026-03-21 11:02:31');
INSERT INTO `tra_ai_conversation_messages` (`message_id`, `session_id`, `message_sequence`, `sender_type`, `message_text`, `raw_payload`, `extracted_intent_id`, `created_at`) VALUES
('d12fe451-4c4e-4073-bd4a-f383399bb506', '691208f1-454b-47fc-b454-c963ca6cd035', 4, 'assistant', 'Ya tengo todos los datos y he generado una opción recomendada. Coste estimado: 2050 €. Tránsito estimado: N/D horas.', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":\"leche\",\"quantityValue\":15000,\"quantityUnit\":\"litros\",\"originText\":\"Lleida\",\"destinationText\":\"Morón de la frontera\",\"originAddressText\":null,\"originContactName\":null,\"originContactPhone\":null,\"destinationAddressText\":null,\"destinationContactName\":null,\"destinationContactPhone\":null,\"requestedPickupAt\":\"2024-08-12T12:30:00\",\"deliveryDeadlineAt\":\"2024-08-13T22:00:00\"},\"missingFields\":[\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\"],\"nextBestQuestion\":\"¿Podrías proporcionarme la dirección y el contacto (nombre y teléfono) tanto del origen en Lleida como del destino en Morón de la frontera?\",\"confidence\":0.95},\"validationSummary\":{\"quoteRequestId\":\"4db7e754-15d5-4360-afd4-1619be8859d4\",\"total\":8,\"passed\":7,\"failed\":0,\"warnings\":1,\"results\":[{\"id\":\"2a2719a1-0072-4581-8b1d-ffaecd7aaf54\",\"sessionId\":null,\"quoteRequestId\":\"4db7e754-15d5-4360-afd4-1619be8859d4\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"LOAD_DATE_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Fecha de carga informada correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T11:46:12.000Z\"},{\"id\":\"33efccec-d423-42dd-bf9d-446bec0054df\",\"sessionId\":null,\"quoteRequestId\":\"4db7e754-15d5-4360-afd4-1619be8859d4\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"DELIVERY_DEADLINE_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Límite de entrega informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T11:46:12.000Z\"},{\"id\":\"379acfbd-9a15-4f85-a649-1e0994ab381d\",\"sessionId\":null,\"quoteRequestId\":\"4db7e754-15d5-4360-afd4-1619be8859d4\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"COMPATIBILITY_TANKS_AVAILABLE\",\"severity\":\"info\",\"validationStatus\":\"passed\",\"message\":\"Se han encontrado 2 tanques compatibles para el producto.\",\"blocking\":false,\"createdAt\":\"2026-03-21T11:46:12.000Z\"},{\"id\":\"37cba683-3333-4140-bb0e-6182b4487ccc\",\"sessionId\":null,\"quoteRequestId\":\"4db7e754-15d5-4360-afd4-1619be8859d4\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"PRODUCT_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Producto informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T11:46:12.000Z\"},{\"id\":\"3c4ae498-fa10-42ff-8122-dd16544ff3a5\",\"sessionId\":null,\"quoteRequestId\":\"4db7e754-15d5-4360-afd4-1619be8859d4\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"DESTINATION_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Destino informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T11:46:12.000Z\"},{\"id\":\"5b00055a-2805-42db-8db8-46297fb2ea23\",\"sessionId\":null,\"quoteRequestId\":\"4db7e754-15d5-4360-afd4-1619be8859d4\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"COMPATIBILITY_REVIEW_REQUIRED\",\"severity\":\"warning\",\"validationStatus\":\"warning\",\"message\":\"No hay validación directa de food grade a nivel de vehículo. Se recomienda revisión operativa si es crítico.\",\"blocking\":false,\"createdAt\":\"2026-03-21T11:46:12.000Z\"},{\"id\":\"9ee42a80-4eb0-4519-92a1-2bb60d85c282\",\"sessionId\":null,\"quoteRequestId\":\"4db7e754-15d5-4360-afd4-1619be8859d4\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"ORIGIN_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Origen informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T11:46:12.000Z\"},{\"id\":\"b0f4984b-2b65-4efb-aaf7-6216a5ebc8cc\",\"sessionId\":null,\"quoteRequestId\":\"4db7e754-15d5-4360-afd4-1619be8859d4\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"QUANTITY_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Cantidad informada correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-21T11:46:12.000Z\"}]}}', NULL, '2026-03-21 11:46:12'),
('d2965f7f-5f9c-429c-a5e6-3f9a81545072', '861a7967-6a5d-4829-91fe-ec2309ef4046', 8, 'assistant', 'He entendido producto: zumo, cantidad: 4000 litros, origen: Lleida, destino: Málaga, fecha de recogida: 2026-05-24T21:34:00. Me falta el límite de entrega.', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":\"zumo\",\"quantityValue\":4000,\"quantityUnit\":\"litros\",\"originText\":\"Lleida\",\"destinationText\":\"Málaga\",\"requestedPickupAt\":\"2026-05-24T21:34:00\",\"deliveryDeadlineAt\":null},\"missingFields\":[\"delivery_deadline\"],\"nextBestQuestion\":\"¿Cuál es el límite de entrega para el transporte del zumo desde Lleida a Málaga?\",\"confidence\":0.95},\"validationSummary\":null}', NULL, '2026-03-21 11:03:48'),
('d58ae528-5c30-4e00-9989-cc07e26eff4d', 'a94a2422-7ad6-4323-9035-f3ae5af00538', 7, 'user', 'recogida el 12/05/2026 a las 12:34 para entregar antes de las 22:00 del 14/05/2026', NULL, NULL, '2026-03-20 20:58:08'),
('d6524163-eeb5-4f41-be02-cbe804882206', 'fb969b06-0124-4c89-aeb2-c5f1c9c00d16', 7, 'user', 'origen desde c/ master 23, 25006 LLeida y entrega en C/ Velazqueza 45 456789 Malaga', NULL, NULL, '2026-03-21 13:51:07'),
('d8d223c7-a2a4-4ff6-9b4b-baf8113dd6ec', '9032db00-ebd9-412e-9525-dec6a6a56837', 1, 'user', 'becesito transportar 12000 litros de lehce de lleid a a malaga', NULL, NULL, '2026-03-20 18:14:01'),
('e24e1bca-2319-4b42-82d5-7eeb774b0971', 'a94a2422-7ad6-4323-9035-f3ae5af00538', 12, 'assistant', 'Ya tengo todos los datos y he generado una opción recomendada. Coste estimado: 394 €. Tránsito estimado: N/D horas.', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":null,\"quantityValue\":null,\"quantityUnit\":null,\"originText\":null,\"destinationText\":null,\"requestedPickupAt\":\"2026-05-12T12:34:00\",\"deliveryDeadlineAt\":\"2026-05-14T22:00:00\"},\"missingFields\":[\"product\",\"quantity\",\"origin\",\"destination\"],\"nextBestQuestion\":\"¿Podrías indicarme qué producto se va a transportar, la cantidad y las ubicaciones de origen y destino?\",\"confidence\":0.9},\"validationSummary\":{\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"total\":8,\"passed\":7,\"failed\":0,\"warnings\":1,\"results\":[{\"id\":\"0a31381b-8552-484f-9d3a-234eb8ff51eb\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"COMPATIBILITY_REVIEW_REQUIRED\",\"severity\":\"warning\",\"validationStatus\":\"warning\",\"message\":\"No hay validación directa de food grade a nivel de vehículo. Se recomienda revisión operativa si es crítico.\",\"blocking\":false,\"createdAt\":\"2026-03-20T21:00:55.000Z\"},{\"id\":\"2c2e7e97-f134-4979-a5fa-b6910df20c6e\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"LOAD_DATE_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Fecha de carga informada correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T21:00:55.000Z\"},{\"id\":\"300204c6-afe1-4455-9d0a-c8c7490b646f\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"DELIVERY_DEADLINE_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Límite de entrega informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T21:00:55.000Z\"},{\"id\":\"3295ad06-ea42-4355-a6a6-e070b863b51d\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"PRODUCT_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Producto informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T21:00:55.000Z\"},{\"id\":\"4af1826d-a5fd-4324-ae61-d17d78a50f12\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"COMPATIBILITY_TANKS_AVAILABLE\",\"severity\":\"info\",\"validationStatus\":\"passed\",\"message\":\"Se han encontrado 2 tanques compatibles para el producto.\",\"blocking\":false,\"createdAt\":\"2026-03-20T21:00:55.000Z\"},{\"id\":\"932d4154-f499-4632-a163-bdaecd54d53e\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"QUANTITY_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Cantidad informada correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T21:00:55.000Z\"},{\"id\":\"d2b4ce9d-87de-4f70-a9fa-9e9379b5e2e4\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"ORIGIN_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Origen informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T21:00:55.000Z\"},{\"id\":\"ff37bfd8-cd26-43df-b8b3-2bcd664c1a0b\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"DESTINATION_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Destino informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T21:00:55.000Z\"}]}}', NULL, '2026-03-20 21:00:55'),
('e3c5d9ae-4309-4d53-a09f-4013de523525', 'fb969b06-0124-4c89-aeb2-c5f1c9c00d16', 9, 'user', 'origen desde c/ master 23, 25006 LLeida y entrega en C/ Velazqueza 45 456789 Malaga', NULL, NULL, '2026-03-21 13:51:43'),
('e87de4bd-d0fe-4dc1-8ba8-8863a18decb4', 'a94a2422-7ad6-4323-9035-f3ae5af00538', 4, 'assistant', 'He podido completar la solicitud, pero de momento no pasa validación.', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":null,\"quantityValue\":null,\"quantityUnit\":null,\"originText\":null,\"destinationText\":null,\"requestedPickupAt\":\"2026-05-12T00:00:00\",\"deliveryDeadlineAt\":\"2026-05-14T22:00:00\"},\"missingFields\":[\"product\",\"quantity\",\"origin\",\"destination\"],\"nextBestQuestion\":\"¿Podrías confirmarme el producto, la cantidad con unidad, el origen y el destino del transporte?\",\"confidence\":0.9},\"validationSummary\":{\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"total\":7,\"passed\":6,\"failed\":1,\"warnings\":0,\"results\":[{\"id\":\"78349e2a-d43e-46de-a312-34376c826319\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"LOAD_DATE_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Fecha de carga informada correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:55:32.000Z\"},{\"id\":\"7e2ccebe-8370-475c-866d-4d5b6f69c411\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"DESTINATION_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Destino informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:55:32.000Z\"},{\"id\":\"85ccc4cf-e57a-48fa-b9d0-5447fd461991\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"DELIVERY_DEADLINE_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Límite de entrega informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:55:32.000Z\"},{\"id\":\"8805d669-c46e-41a1-a446-7df65982df1e\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"PRODUCT_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Producto informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:55:32.000Z\"},{\"id\":\"970575af-43b5-4de8-80c6-9afc5a2af5f2\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"QUANTITY_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Cantidad informada correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:55:32.000Z\"},{\"id\":\"bd1dc761-5303-4d7c-bfdb-86f4c695a8f6\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"ORIGIN_REQUIRED\",\"severity\":\"error\",\"validationStatus\":\"passed\",\"message\":\"Origen informado correctamente.\",\"blocking\":false,\"createdAt\":\"2026-03-20T20:55:32.000Z\"},{\"id\":\"eed38acb-82fd-42be-8177-38f36e2f23b8\",\"sessionId\":null,\"quoteRequestId\":\"4b1e33b5-cef5-43ae-b69b-029e74527449\",\"orderId\":null,\"validationScope\":\"quote_request\",\"ruleCode\":\"COMPATIBILITY_PRODUCT_NOT_FOUND\",\"severity\":\"error\",\"validationStatus\":\"failed\",\"message\":\"No se ha podido normalizar el producto en catálogo para validar compatibilidad.\",\"blocking\":true,\"createdAt\":\"2026-03-20T20:55:32.000Z\"}]}}', NULL, '2026-03-20 20:55:32'),
('eb57b0eb-faf8-4a76-8eb5-18de498edf2b', 'fb969b06-0124-4c89-aeb2-c5f1c9c00d16', 4, 'assistant', 'He entendido producto: leche, cantidad: 1200 litros, origen: lleida, destino: malaga. Me faltan la fecha de recogida y el límite de entrega. ¿Me los indicas?', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":\"leche\",\"quantityValue\":1200,\"quantityUnit\":\"litros\",\"originText\":\"lleida\",\"destinationText\":\"malaga\",\"originAddressText\":null,\"originContactName\":null,\"originContactPhone\":null,\"destinationAddressText\":null,\"destinationContactName\":null,\"destinationContactPhone\":null,\"requestedPickupAt\":null,\"deliveryDeadlineAt\":null},\"missingFields\":[\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"],\"nextBestQuestion\":\"¿Podrías proporcionarme la dirección exacta y el contacto (nombre y teléfono) tanto del origen en Lleida como del destino en Málaga, además de la fecha y hora solicitadas para la recogida y el límite de entrega?\",\"confidence\":0.9},\"validationSummary\":null}', NULL, '2026-03-21 13:49:54'),
('ecf06792-b420-4800-9246-f5d8e19b8d3c', 'a94a2422-7ad6-4323-9035-f3ae5af00538', 5, 'user', 'recogida el 12/05/2026 a las 12:34 para entregar antes de las 22:00 del 14/05/2026', NULL, NULL, '2026-03-20 20:56:34'),
('eed5031e-5afc-40a9-92ff-ef9abdf411dd', '584fe2ec-1416-4c49-8fed-dbd2b8ccdacf', 3, 'user', 'pasa la solicitud a ventas', NULL, NULL, '2026-03-21 11:19:26'),
('f0f4ac85-dd52-4608-9be7-9f390f0b8dbd', 'fb969b06-0124-4c89-aeb2-c5f1c9c00d16', 3, 'user', 'desde lleida hasta malaga', NULL, NULL, '2026-03-21 13:49:51'),
('f1bc8de3-27a4-4a9d-9c41-cb50539a6738', '691208f1-454b-47fc-b454-c963ca6cd035', 3, 'user', 'serían 15000 litros para recoger el 12 de agosto a las 12:30 y llevarlo a Moron el día 13 antes de las 22:00', NULL, NULL, '2026-03-21 11:46:08'),
('f3a207d1-749a-461e-9f06-58b80e238f2a', 'ee55ce44-2ccd-4b28-9c3a-80739ad0748d', 2, 'assistant', 'He entendido producto: leche, cantidad: 1200 litros, origen: Malaga, destino: Gijon. Me faltan la fecha de recogida y el límite de entrega. ¿Me los indicas?', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":\"leche\",\"quantityValue\":1200,\"quantityUnit\":\"litros\",\"originText\":\"Malaga\",\"destinationText\":\"Gijon\",\"requestedPickupAt\":null,\"deliveryDeadlineAt\":null},\"missingFields\":[\"requested_date\",\"delivery_deadline\"],\"nextBestQuestion\":\"¿Para qué fecha necesitas la recogida y cuál es el plazo máximo para la entrega?\",\"confidence\":0.9},\"validationSummary\":null}', NULL, '2026-03-20 19:31:38'),
('fc295331-3901-4f30-ac99-61b8241c42bf', '861a7967-6a5d-4829-91fe-ec2309ef4046', 2, 'assistant', 'He entendido producto: zumo, cantidad: 4000 litros. Todavía necesito el origen, el destino, la fecha de recogida y el límite de entrega.', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":\"zumo\",\"quantityValue\":4000,\"quantityUnit\":\"litros\",\"originText\":null,\"destinationText\":null,\"requestedPickupAt\":null,\"deliveryDeadlineAt\":null},\"missingFields\":[\"origin\",\"destination\",\"requested_date\",\"delivery_deadline\"],\"nextBestQuestion\":\"¿Desde dónde y hacia dónde quieres transportar los 4000 litros de zumo, y en qué fechas necesitas la recogida y la entrega?\",\"confidence\":0.9},\"validationSummary\":null}', NULL, '2026-03-21 11:02:35'),
('fea851cc-f35b-4fcf-b08f-f99cab808999', '036ca52d-e76e-47bb-89e1-efd58819ec66', 1, 'user', 'quiero transportar 1200 litros de leche desde Malaga a Madrid', NULL, NULL, '2026-03-20 20:48:14');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_ai_conversation_sessions`
--

CREATE TABLE `tra_ai_conversation_sessions` (
  `session_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'active',
  `channel` varchar(50) NOT NULL DEFAULT 'chat',
  `language` varchar(10) NOT NULL DEFAULT 'es',
  `context_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`context_json`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tra_ai_conversation_sessions`
--

INSERT INTO `tra_ai_conversation_sessions` (`session_id`, `user_id`, `title`, `status`, `channel`, `language`, `context_json`, `created_at`, `updated_at`) VALUES
('036ca52d-e76e-47bb-89e1-efd58819ec66', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-20 20:47:52', '2026-03-20 20:49:06'),
('05bbd453-fbe9-4569-b207-34767d4a365e', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-21 12:00:45', '2026-03-21 12:00:45'),
('0c9651b9-662b-41a8-a32a-dbf5cd2e7204', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-21 11:19:02', '2026-03-21 11:19:02'),
('15e70f97-556a-4f6d-9a21-99525be64db8', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-21 13:49:29', '2026-03-21 13:49:29'),
('1cda45b7-86ec-43e4-83d0-4cb22b95e25b', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-20 18:13:45', '2026-03-20 18:13:45'),
('1d7c4348-4682-445d-9340-179dae34b39d', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-21 11:32:29', '2026-03-21 11:32:29'),
('1df02ea5-6370-4cf0-a480-d89436856c72', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-21 11:53:21', '2026-03-21 11:53:21'),
('1dffb067-9752-49dc-9f9e-a8bc33502c98', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-20 20:54:58', '2026-03-20 20:54:58'),
('2424c1e8-7289-4217-ae12-a6a6010bbabf', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-21 11:02:13', '2026-03-21 11:02:13'),
('2b298c17-7a7a-4d6f-a516-2184b6e3da28', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page_restart\"}', '2026-03-21 11:19:04', '2026-03-21 11:19:04'),
('3e6f74d1-8476-49da-816a-5ed7cf8b4b84', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-20 20:47:52', '2026-03-20 20:47:52'),
('4aaa85d6-0c4e-4516-a815-59fa253a0cb3', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-21 11:19:02', '2026-03-21 11:19:02'),
('4c6c0e0d-5ef6-47d2-bfa2-2784d9f40e6b', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-21 11:19:02', '2026-03-21 11:19:02'),
('584fe2ec-1416-4c49-8fed-dbd2b8ccdacf', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-21 11:19:04', '2026-03-21 11:19:31'),
('5c0dfd9c-6742-4051-9d2b-8a83b0206657', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-20 19:31:10', '2026-03-20 19:31:10'),
('5ca6fbc4-e138-4107-821f-05c2d5b2bbbc', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-21 11:53:21', '2026-03-21 11:53:21'),
('691208f1-454b-47fc-b454-c963ca6cd035', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-21 11:34:28', '2026-03-21 11:46:12'),
('6f5dad78-f378-444a-92f0-3a5a12152765', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-21 11:32:29', '2026-03-21 11:32:37'),
('7e458e82-0bc3-46a9-ac24-a6d198703f69', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-21 11:34:28', '2026-03-21 11:34:28'),
('861a7967-6a5d-4829-91fe-ec2309ef4046', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-21 11:02:13', '2026-03-21 11:04:12'),
('9032db00-ebd9-412e-9525-dec6a6a56837', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-20 18:13:45', '2026-03-20 19:11:01'),
('95759801-03ef-4e15-b6d4-5372b8989d09', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-21 11:16:53', '2026-03-21 11:17:04'),
('9b673c1c-bd9f-46b5-839f-ce052506dd7e', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page_restart\"}', '2026-03-21 11:16:53', '2026-03-21 11:16:53'),
('a5876029-ef53-4bf0-9ebf-2051b01f4813', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-20 20:09:25', '2026-03-20 20:09:25'),
('a94a2422-7ad6-4323-9035-f3ae5af00538', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page_restart\"}', '2026-03-20 20:54:58', '2026-03-20 21:00:55'),
('aab298d4-dc64-47c6-94ea-dc656e3261ba', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-20 20:09:25', '2026-03-20 20:09:25'),
('adefd115-cdbf-49bc-adc1-3ae95982fec5', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-21 13:54:50', '2026-03-21 13:54:50'),
('b92d9c38-9037-48d4-bd69-c5b289d7ac4c', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-21 11:53:21', '2026-03-21 11:53:21'),
('c78f2258-69c3-422d-b784-31c13bed63c7', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-20 19:31:10', '2026-03-20 19:31:10'),
('d7433268-cf01-4283-a7e4-930bd36ea92d', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-21 11:53:22', '2026-03-21 11:53:56'),
('e3618a59-359b-493a-9a98-f6a13618b208', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-21 11:34:28', '2026-03-21 11:34:28'),
('e70b9b32-6c60-49e7-bee5-aad4de9f928d', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page_restart\"}', '2026-03-21 11:53:22', '2026-03-21 11:53:22'),
('ee55ce44-2ccd-4b28-9c3a-80739ad0748d', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-20 19:31:10', '2026-03-20 19:32:25'),
('f40114f2-21c7-4535-ad5f-b4801deff89b', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-21 13:54:50', '2026-03-21 13:54:50'),
('f8e1ab3a-cb27-442e-a3f3-80f9671f904b', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-21 11:32:29', '2026-03-21 11:32:29'),
('fb969b06-0124-4c89-aeb2-c5f1c9c00d16', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-21 13:49:29', '2026-03-21 13:50:20');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_ai_draft_orders`
--

CREATE TABLE `tra_ai_draft_orders` (
  `draft_order_id` char(36) NOT NULL,
  `quote_request_id` char(36) NOT NULL,
  `quote_option_id` char(36) DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'draft',
  `notes` text DEFAULT NULL,
  `draft_payload_json` longtext DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_ai_quote_options`
--

CREATE TABLE `tra_ai_quote_options` (
  `quote_option_id` char(36) NOT NULL,
  `quote_request_id` char(36) NOT NULL,
  `vehicle_type_id` char(36) DEFAULT NULL,
  `cleaning_protocol_id` char(36) DEFAULT NULL,
  `estimated_cost` decimal(12,2) DEFAULT NULL,
  `estimated_transit_hours` decimal(10,2) DEFAULT NULL,
  `is_feasible` tinyint(1) NOT NULL DEFAULT 1,
  `recommendation_score` decimal(10,2) DEFAULT NULL,
  `reasoning_json` longtext DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tra_ai_quote_options`
--

INSERT INTO `tra_ai_quote_options` (`quote_option_id`, `quote_request_id`, `vehicle_type_id`, `cleaning_protocol_id`, `estimated_cost`, `estimated_transit_hours`, `is_feasible`, `recommendation_score`, `reasoning_json`, `notes`, `created_at`, `updated_at`) VALUES
('16963444-cc6a-4765-bf87-27e79d69768a', 'd72cf8f2-d6ea-448b-94c0-e993af9bd482', NULL, NULL, 394.00, 12.00, 1, 90.00, '{\"formula\":\"base + liters * 0.12\"}', 'Opción generada por motor simplificado.', '2026-03-20 19:32:25', '2026-03-20 19:32:25'),
('3f472110-0e74-42a5-a58b-6a8a6f6920df', '4db7e754-15d5-4360-afd4-1619be8859d4', '3737307a-249d-11f1-9638-5a0d05a37ed3', NULL, 2050.00, NULL, 1, 90.00, '{\"formula\":\"base + liters * 0.12\",\"productId\":\"d865c108-249f-11f1-9638-5a0d05a37ed3\",\"categoryId\":\"d85cc936-249f-11f1-9638-5a0d05a37ed3\",\"compatibleTanks\":2,\"availableVehicles\":2,\"routeId\":null,\"distanceKm\":null,\"selectedVehicleId\":\"3737307a-249d-11f1-9638-5a0d05a37ed3\",\"selectedVehicleCode\":\"VEH-001\",\"selectedTankId\":\"373932bc-249d-11f1-9638-5a0d05a37ed3\",\"usedFallbackRoute\":false,\"fallbackSpeedKmh\":null}', 'Origen no normalizado en catálogo. Destino no normalizado en catálogo. No hay disponibilidad registrada; se asumen vehículos activos.', '2026-03-21 11:46:12', '2026-03-21 11:46:12'),
('7a9a85f2-7c87-4b15-8b33-288f44c2295c', '4b1e33b5-cef5-43ae-b69b-029e74527449', '3737307a-249d-11f1-9638-5a0d05a37ed3', NULL, 394.00, NULL, 1, 90.00, '{\"formula\":\"base + liters * 0.12\",\"productId\":\"d865c108-249f-11f1-9638-5a0d05a37ed3\",\"categoryId\":\"d85cc936-249f-11f1-9638-5a0d05a37ed3\",\"compatibleTanks\":2,\"availableVehicles\":2,\"routeId\":null,\"distanceKm\":null,\"selectedVehicleId\":\"3737307a-249d-11f1-9638-5a0d05a37ed3\",\"selectedVehicleCode\":\"VEH-001\",\"selectedTankId\":\"373932bc-249d-11f1-9638-5a0d05a37ed3\",\"usedFallbackRoute\":false,\"fallbackSpeedKmh\":null}', 'Origen no normalizado en catálogo. Destino no normalizado en catálogo. No hay disponibilidad registrada; se asumen vehículos activos.', '2026-03-20 21:00:55', '2026-03-20 21:00:55'),
('f0853e3a-8cd6-4d2f-b4f7-61403edc9f76', 'fa35312a-bb27-4f29-bac0-401419fd54ab', '3737307a-249d-11f1-9638-5a0d05a37ed3', NULL, 2050.00, NULL, 1, 90.00, '{\"formula\":\"base + liters * 0.12\",\"productId\":\"d865c108-249f-11f1-9638-5a0d05a37ed3\",\"categoryId\":\"d85cc936-249f-11f1-9638-5a0d05a37ed3\",\"compatibleTanks\":2,\"availableVehicles\":2,\"routeId\":null,\"distanceKm\":null,\"selectedVehicleId\":\"3737307a-249d-11f1-9638-5a0d05a37ed3\",\"selectedVehicleCode\":\"VEH-001\",\"selectedTankId\":\"373932bc-249d-11f1-9638-5a0d05a37ed3\",\"usedFallbackRoute\":false,\"fallbackSpeedKmh\":null}', 'Origen no normalizado en catálogo. Destino no normalizado en catálogo. No hay disponibilidad registrada; se asumen vehículos activos.', '2026-03-21 11:53:56', '2026-03-21 11:53:56');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_ai_quote_requests`
--

CREATE TABLE `tra_ai_quote_requests` (
  `quote_request_id` char(36) NOT NULL,
  `conversation_session_id` char(36) DEFAULT NULL,
  `external_reference` varchar(50) DEFAULT NULL,
  `source_channel` varchar(20) NOT NULL DEFAULT 'chat',
  `client_id` char(36) DEFAULT NULL,
  `requester_name` varchar(150) DEFAULT NULL,
  `requester_email` varchar(150) DEFAULT NULL,
  `requester_phone` varchar(40) DEFAULT NULL,
  `requested_product_text` varchar(150) NOT NULL,
  `requested_product_id` char(36) DEFAULT NULL,
  `requested_category_id` char(36) DEFAULT NULL,
  `requested_volume_liters` int(11) DEFAULT NULL,
  `requested_weight_tn` decimal(10,2) DEFAULT NULL,
  `requested_load_date` date DEFAULT NULL,
  `origin_text` varchar(200) DEFAULT NULL,
  `destination_text` varchar(200) DEFAULT NULL,
  `origin_loading_point_id` char(36) DEFAULT NULL,
  `destination_unloading_point_id` char(36) DEFAULT NULL,
  `service_constraints_text` text DEFAULT NULL,
  `requested_mode` varchar(20) DEFAULT NULL,
  `extracted_json` longtext DEFAULT NULL,
  `validation_status` varchar(20) NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `delivery_deadline_datetime` timestamp NULL DEFAULT NULL,
  `wizard_status` varchar(20) NOT NULL DEFAULT 'idle'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tra_ai_quote_requests`
--

INSERT INTO `tra_ai_quote_requests` (`quote_request_id`, `conversation_session_id`, `external_reference`, `source_channel`, `client_id`, `requester_name`, `requester_email`, `requester_phone`, `requested_product_text`, `requested_product_id`, `requested_category_id`, `requested_volume_liters`, `requested_weight_tn`, `requested_load_date`, `origin_text`, `destination_text`, `origin_loading_point_id`, `destination_unloading_point_id`, `service_constraints_text`, `requested_mode`, `extracted_json`, `validation_status`, `created_at`, `updated_at`, `delivery_deadline_datetime`, `wizard_status`) VALUES
('04d06af3-dcff-4d4d-b1f0-f003ee894ab7', '861a7967-6a5d-4829-91fe-ec2309ef4046', '861a7967-6a5d-4829-91fe-ec2309ef4046', 'chat', NULL, NULL, NULL, NULL, 'zumo', NULL, NULL, 4000, NULL, '2026-05-24', 'Lleida', 'Málaga', NULL, NULL, NULL, 'litros', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":\"zumo\",\"quantityValue\":4000,\"quantityUnit\":\"litros\",\"originText\":\"Lleida\",\"destinationText\":\"Málaga\",\"requestedPickupAt\":\"2026-05-24T21:34:00\",\"deliveryDeadlineAt\":\"2026-08-04T12:00:00\"},\"missingFields\":[],\"nextBestQuestion\":null,\"confidence\":0.95}}', 'failed', '2026-03-21 11:02:31', '2026-03-21 11:04:12', '2026-08-04 10:00:00', 'collecting_data'),
('10ac196c-9ac7-4a60-9e48-63250d82c671', '6f5dad78-f378-444a-92f0-3a5a12152765', '6f5dad78-f378-444a-92f0-3a5a12152765', 'chat', NULL, NULL, NULL, NULL, 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":null,\"quantityValue\":null,\"quantityUnit\":null,\"originText\":null,\"destinationText\":null,\"originAddressText\":null,\"originContactName\":null,\"originContactPhone\":null,\"destinationAddressText\":null,\"destinationContactName\":null,\"destinationContactPhone\":null,\"requestedPickupAt\":null,\"deliveryDeadlineAt\":null},\"missingFields\":[\"product\",\"quantity\",\"origin\",\"destination\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"],\"nextBestQuestion\":\"¿Podrías proporcionarme el producto, la cantidad con unidad, los lugares de origen y destino, las direcciones y contactos de ambos, así como las fechas de recogida y entrega?\",\"confidence\":0}}', 'pending', '2026-03-21 11:32:34', '2026-03-21 11:32:37', NULL, 'collecting_data'),
('17e4bb20-c75d-48ad-95a9-8f8484a08c8e', '95759801-03ef-4e15-b6d4-5372b8989d09', '95759801-03ef-4e15-b6d4-5372b8989d09', 'chat', NULL, NULL, NULL, NULL, 'zumo', NULL, NULL, 4000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'litros', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":\"zumo\",\"quantityValue\":4000,\"quantityUnit\":\"litros\",\"originText\":null,\"destinationText\":null,\"originAddressText\":null,\"originContactName\":null,\"originContactPhone\":null,\"destinationAddressText\":null,\"destinationContactName\":null,\"destinationContactPhone\":null,\"requestedPickupAt\":null,\"deliveryDeadlineAt\":null},\"missingFields\":[\"origin\",\"destination\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"],\"nextBestQuestion\":\"¿Podrías indicarme el lugar de origen y destino del transporte, así como las direcciones y los datos de contacto de ambas ubicaciones, además de las fechas de recogida y entrega?\",\"confidence\":0.8}}', 'pending', '2026-03-21 11:16:57', '2026-03-21 11:17:04', NULL, 'collecting_data'),
('4b1e33b5-cef5-43ae-b69b-029e74527449', 'a94a2422-7ad6-4323-9035-f3ae5af00538', 'a94a2422-7ad6-4323-9035-f3ae5af00538', 'chat', NULL, NULL, NULL, NULL, 'leche', NULL, NULL, 1200, NULL, '2026-05-12', 'Malaga', 'madrid', NULL, NULL, NULL, 'litros', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":null,\"quantityValue\":null,\"quantityUnit\":null,\"originText\":null,\"destinationText\":null,\"requestedPickupAt\":\"2026-05-12T12:34:00\",\"deliveryDeadlineAt\":\"2026-05-14T22:00:00\"},\"missingFields\":[\"product\",\"quantity\",\"origin\",\"destination\"],\"nextBestQuestion\":\"¿Podrías indicarme qué producto se va a transportar, la cantidad y las ubicaciones de origen y destino?\",\"confidence\":0.9}}', 'passed', '2026-03-20 20:55:15', '2026-03-20 21:00:55', '2026-05-14 20:00:00', 'collecting_data'),
('4db7e754-15d5-4360-afd4-1619be8859d4', '691208f1-454b-47fc-b454-c963ca6cd035', '691208f1-454b-47fc-b454-c963ca6cd035', 'chat', NULL, NULL, NULL, NULL, 'leche', NULL, NULL, 15000, NULL, '2024-08-12', 'Lleida', 'Morón de la frontera', NULL, NULL, NULL, 'litros', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":\"leche\",\"quantityValue\":15000,\"quantityUnit\":\"litros\",\"originText\":\"Lleida\",\"destinationText\":\"Morón de la frontera\",\"originAddressText\":null,\"originContactName\":null,\"originContactPhone\":null,\"destinationAddressText\":null,\"destinationContactName\":null,\"destinationContactPhone\":null,\"requestedPickupAt\":\"2024-08-12T12:30:00\",\"deliveryDeadlineAt\":\"2024-08-13T22:00:00\"},\"missingFields\":[\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\"],\"nextBestQuestion\":\"¿Podrías proporcionarme la dirección y el contacto (nombre y teléfono) tanto del origen en Lleida como del destino en Morón de la frontera?\",\"confidence\":0.95}}', 'passed', '2026-03-21 11:45:15', '2026-03-21 11:46:12', '2024-08-13 20:00:00', 'collecting_data'),
('a7dcb5a5-b505-48ef-9dee-30d59d886118', '036ca52d-e76e-47bb-89e1-efd58819ec66', '036ca52d-e76e-47bb-89e1-efd58819ec66', 'chat', NULL, NULL, NULL, NULL, 'leche', NULL, NULL, NULL, NULL, '2026-05-12', NULL, NULL, NULL, NULL, NULL, NULL, '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":null,\"quantityValue\":null,\"quantityUnit\":null,\"originText\":null,\"destinationText\":null,\"requestedPickupAt\":\"2026-05-12T00:00:00\",\"deliveryDeadlineAt\":\"2026-05-14T22:00:00\"},\"missingFields\":[\"product\",\"quantity\",\"origin\",\"destination\"],\"nextBestQuestion\":\"¿Podrías confirmarme el producto, la cantidad, el origen y el destino para completar la información?\",\"confidence\":0.9}}', 'pending', '2026-03-20 20:48:14', '2026-03-20 20:49:06', '2026-05-14 20:00:00', 'collecting_data'),
('ac7957fc-a794-449a-9b16-ba59bfb3c317', 'fb969b06-0124-4c89-aeb2-c5f1c9c00d16', 'fb969b06-0124-4c89-aeb2-c5f1c9c00d16', 'chat', NULL, NULL, NULL, NULL, 'leche', NULL, NULL, 1200, NULL, '2024-08-12', 'lleida', 'malaga', NULL, NULL, NULL, 'litros', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":\"leche\",\"quantityValue\":1200,\"quantityUnit\":\"litros\",\"originText\":\"lleida\",\"destinationText\":\"malaga\",\"originAddressText\":null,\"originContactName\":null,\"originContactPhone\":null,\"destinationAddressText\":null,\"destinationContactName\":null,\"destinationContactPhone\":null,\"requestedPickupAt\":\"2024-08-12T14:00:00\",\"deliveryDeadlineAt\":\"2024-10-25T12:00:00\"},\"missingFields\":[\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\"],\"nextBestQuestion\":\"¿Me puedes proporcionar las direcciones y los datos de contacto tanto del origen en Lleida como del destino en Málaga?\",\"confidence\":0.95}}', 'failed', '2026-03-21 13:49:39', '2026-03-21 13:50:20', '2024-10-25 10:00:00', 'collecting_data'),
('d72cf8f2-d6ea-448b-94c0-e993af9bd482', 'ee55ce44-2ccd-4b28-9c3a-80739ad0748d', 'ee55ce44-2ccd-4b28-9c3a-80739ad0748d', 'chat', NULL, NULL, NULL, NULL, 'leche', NULL, NULL, 1200, NULL, '2024-05-12', 'Malaga', 'Gijon', NULL, NULL, NULL, 'litros', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":\"leche\",\"quantityValue\":1200,\"quantityUnit\":\"litros\",\"originText\":\"Malaga\",\"destinationText\":\"Gijon\",\"requestedPickupAt\":\"2024-05-12T14:00:00+02:00\",\"deliveryDeadlineAt\":\"2024-05-12T22:00:00+02:00\"},\"missingFields\":[],\"nextBestQuestion\":null,\"confidence\":0.95}}', 'passed', '2026-03-20 19:31:34', '2026-03-20 19:32:25', '2024-05-12 20:00:00', 'collecting_data'),
('f196ac83-4336-461c-bb38-f5463f15ea4d', '9032db00-ebd9-412e-9525-dec6a6a56837', '9032db00-ebd9-412e-9525-dec6a6a56837', 'chat', NULL, NULL, NULL, NULL, 'Pendiente', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":null,\"quantityValue\":null,\"quantityUnit\":null,\"originText\":null,\"destinationText\":null,\"requestedPickupAt\":null,\"deliveryDeadlineAt\":null},\"missingFields\":[],\"nextBestQuestion\":null,\"confidence\":0}}', 'pending', '2026-03-20 18:14:01', '2026-03-20 18:19:42', NULL, 'collecting_data'),
('f3e99abb-f0e1-40da-92c6-97ebbfe73a4f', '584fe2ec-1416-4c49-8fed-dbd2b8ccdacf', '584fe2ec-1416-4c49-8fed-dbd2b8ccdacf', 'chat', NULL, NULL, NULL, NULL, 'zumo', NULL, NULL, 4000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'litros', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":null,\"quantityValue\":null,\"quantityUnit\":null,\"originText\":null,\"destinationText\":null,\"originAddressText\":null,\"originContactName\":null,\"originContactPhone\":null,\"destinationAddressText\":null,\"destinationContactName\":null,\"destinationContactPhone\":null,\"requestedPickupAt\":null,\"deliveryDeadlineAt\":null},\"missingFields\":[\"product\",\"quantity\",\"origin\",\"destination\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"],\"nextBestQuestion\":\"¿Podrías proporcionarme los detalles del producto, cantidad, origen, destino, direcciones y contactos, así como las fechas de recogida y entrega para poder pasar la solicitud a ventas?\",\"confidence\":0.1}}', 'pending', '2026-03-21 11:19:06', '2026-03-21 11:19:31', NULL, 'collecting_data'),
('fa35312a-bb27-4f29-bac0-401419fd54ab', 'd7433268-cf01-4283-a7e4-930bd36ea92d', 'd7433268-cf01-4283-a7e4-930bd36ea92d', 'chat', NULL, NULL, NULL, NULL, 'leche', NULL, NULL, 15000, NULL, '2024-08-12', 'Lleida', 'Moron', NULL, NULL, NULL, 'litros', '{\"extraction\":{\"intent\":\"create_or_update_quote_request\",\"extractedFields\":{\"productText\":null,\"quantityValue\":15000,\"quantityUnit\":\"litros\",\"originText\":null,\"destinationText\":\"Moron\",\"originAddressText\":null,\"originContactName\":null,\"originContactPhone\":null,\"destinationAddressText\":null,\"destinationContactName\":null,\"destinationContactPhone\":null,\"requestedPickupAt\":\"2024-08-12T12:30:00\",\"deliveryDeadlineAt\":\"2024-08-13T22:00:00\"},\"missingFields\":[\"product\",\"origin\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\"],\"nextBestQuestion\":\"¿Podrías indicarme qué producto se transporta, la dirección exacta y el contacto (nombre y teléfono) tanto del origen como del destino?\",\"confidence\":0.9}}', 'passed', '2026-03-21 11:53:31', '2026-03-21 11:53:56', '2024-08-13 20:00:00', 'collecting_data');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_ai_session_step_state`
--

CREATE TABLE `tra_ai_session_step_state` (
  `session_step_state_id` char(36) NOT NULL,
  `session_id` char(36) NOT NULL,
  `quote_request_id` char(36) DEFAULT NULL,
  `wizard_step_id` char(36) NOT NULL,
  `step_status` varchar(20) NOT NULL,
  `raw_value_text` text DEFAULT NULL,
  `normalized_value_json` longtext DEFAULT NULL,
  `confidence_score` decimal(5,2) DEFAULT NULL,
  `source_message_id` char(36) DEFAULT NULL,
  `asked_at` timestamp NULL DEFAULT NULL,
  `answered_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tra_ai_session_step_state`
--

INSERT INTO `tra_ai_session_step_state` (`session_step_state_id`, `session_id`, `quote_request_id`, `wizard_step_id`, `step_status`, `raw_value_text`, `normalized_value_json`, `confidence_score`, `source_message_id`, `asked_at`, `answered_at`, `created_at`, `updated_at`) VALUES
('0038acc9-102b-49c0-adbc-c423e940bb9b', '9032db00-ebd9-412e-9525-dec6a6a56837', NULL, '55880974-2483-11f1-9638-5a0d05a37ed3', 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-20 18:14:01', '2026-03-20 18:14:01'),
('03f9a8fb-2dc5-4dae-b39c-530dabcf3b68', 'a94a2422-7ad6-4323-9035-f3ae5af00538', NULL, '55880974-2483-11f1-9638-5a0d05a37ed3', 'completed', '2026-05-12T12:34:00', '{\"requestedPickupAt\":\"2026-05-12T12:34:00\"}', NULL, NULL, NULL, NULL, '2026-03-20 20:55:15', '2026-03-20 20:56:38'),
('0a761192-37d7-4240-b30a-fcb50cf591e9', 'fb969b06-0124-4c89-aeb2-c5f1c9c00d16', NULL, '55880974-2483-11f1-9638-5a0d05a37ed3', 'completed', '2024-08-12T14:00:00', '{\"requestedPickupAt\":\"2024-08-12T14:00:00\"}', NULL, NULL, NULL, NULL, '2026-03-21 13:49:39', '2026-03-21 13:50:20'),
('1af5bb34-2d63-46db-afb4-b546403de3ba', '95759801-03ef-4e15-b6d4-5372b8989d09', NULL, '558809a6-2483-11f1-9638-5a0d05a37ed3', 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-21 11:16:57', '2026-03-21 11:16:57'),
('1b6c7e03-d7b8-44b6-aac9-83741429459d', '95759801-03ef-4e15-b6d4-5372b8989d09', NULL, '558806f4-2483-11f1-9638-5a0d05a37ed3', 'completed', '4000 litros', '{\"quantityValue\":4000,\"quantityUnit\":\"litros\"}', NULL, NULL, NULL, NULL, '2026-03-21 11:16:57', '2026-03-21 11:17:04'),
('1c21c4cd-c081-43f4-8829-fe1188fdd573', '861a7967-6a5d-4829-91fe-ec2309ef4046', NULL, '5588091a-2483-11f1-9638-5a0d05a37ed3', 'completed', 'Lleida', '{\"originText\":\"Lleida\"}', NULL, NULL, NULL, NULL, '2026-03-21 11:02:31', '2026-03-21 11:02:57'),
('21a18bf2-f297-4dd1-9acf-3bdb6ee270d9', '861a7967-6a5d-4829-91fe-ec2309ef4046', NULL, '558806f4-2483-11f1-9638-5a0d05a37ed3', 'completed', '4000 litros', '{\"quantityValue\":4000,\"quantityUnit\":\"litros\"}', NULL, NULL, NULL, NULL, '2026-03-21 11:02:31', '2026-03-21 11:02:35'),
('25035463-2862-405d-bb4c-39b7e4c51d72', '95759801-03ef-4e15-b6d4-5372b8989d09', NULL, '55880974-2483-11f1-9638-5a0d05a37ed3', 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-21 11:16:57', '2026-03-21 11:16:57'),
('26a0e2bf-f1a6-4e66-a293-a2289a2d5aa1', '861a7967-6a5d-4829-91fe-ec2309ef4046', NULL, '558804b0-2483-11f1-9638-5a0d05a37ed3', 'completed', 'zumo', '{\"productText\":\"zumo\"}', NULL, NULL, NULL, NULL, '2026-03-21 11:02:31', '2026-03-21 11:02:35'),
('27c2afb6-d9c6-4806-bb92-2268f36fb65b', '861a7967-6a5d-4829-91fe-ec2309ef4046', NULL, '558809a6-2483-11f1-9638-5a0d05a37ed3', 'completed', '2026-08-04T12:00:00', '{\"deliveryDeadlineAt\":\"2026-08-04T12:00:00\"}', NULL, NULL, NULL, NULL, '2026-03-21 11:02:31', '2026-03-21 11:04:12'),
('3044cde6-9401-43d7-bded-99d368d072bf', 'd7433268-cf01-4283-a7e4-930bd36ea92d', NULL, '5588091a-2483-11f1-9638-5a0d05a37ed3', 'completed', 'Lleida', '{\"originText\":\"Lleida\"}', NULL, NULL, NULL, NULL, '2026-03-21 11:53:31', '2026-03-21 11:53:36'),
('32cbe619-d6fd-4e25-a07b-ba8a471c772c', 'd7433268-cf01-4283-a7e4-930bd36ea92d', NULL, '55880974-2483-11f1-9638-5a0d05a37ed3', 'completed', '2024-08-12T12:30:00', '{\"requestedPickupAt\":\"2024-08-12T12:30:00\"}', NULL, NULL, NULL, NULL, '2026-03-21 11:53:31', '2026-03-21 11:53:56'),
('33811689-6097-4826-a170-67d8d5523795', 'ee55ce44-2ccd-4b28-9c3a-80739ad0748d', NULL, '55880974-2483-11f1-9638-5a0d05a37ed3', 'completed', '2024-05-12T14:00:00+02:00', '{\"requestedPickupAt\":\"2024-05-12T14:00:00+02:00\"}', NULL, NULL, NULL, NULL, '2026-03-20 19:31:34', '2026-03-20 19:32:25'),
('342f3e6f-a739-4e1d-88c8-0721a36af172', '9032db00-ebd9-412e-9525-dec6a6a56837', NULL, '55880942-2483-11f1-9638-5a0d05a37ed3', 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-20 18:14:01', '2026-03-20 18:14:01'),
('3721f005-bae4-402c-9d84-dae0982b2112', 'fb969b06-0124-4c89-aeb2-c5f1c9c00d16', NULL, '558804b0-2483-11f1-9638-5a0d05a37ed3', 'completed', 'leche', '{\"productText\":\"leche\"}', NULL, NULL, NULL, NULL, '2026-03-21 13:49:39', '2026-03-21 13:49:43'),
('39ad2c2c-914f-4d29-9ff2-d38abffb1995', '691208f1-454b-47fc-b454-c963ca6cd035', NULL, '5588091a-2483-11f1-9638-5a0d05a37ed3', 'completed', 'Lleida', '{\"originText\":\"Lleida\"}', NULL, NULL, NULL, NULL, '2026-03-21 11:45:15', '2026-03-21 11:45:21'),
('3e7a499e-c424-4356-acc7-e2e20454589a', '95759801-03ef-4e15-b6d4-5372b8989d09', NULL, '558804b0-2483-11f1-9638-5a0d05a37ed3', 'completed', 'zumo', '{\"productText\":\"zumo\"}', NULL, NULL, NULL, NULL, '2026-03-21 11:16:57', '2026-03-21 11:17:04'),
('42c4f729-dc42-43c8-bc58-16c62c2216e7', 'fb969b06-0124-4c89-aeb2-c5f1c9c00d16', NULL, '55880942-2483-11f1-9638-5a0d05a37ed3', 'completed', 'malaga', '{\"destinationText\":\"malaga\"}', NULL, NULL, NULL, NULL, '2026-03-21 13:49:39', '2026-03-21 13:49:54'),
('44690738-53d4-48de-a43f-b1ceee7be6ee', '584fe2ec-1416-4c49-8fed-dbd2b8ccdacf', NULL, '558806f4-2483-11f1-9638-5a0d05a37ed3', 'completed', '4000 litros', '{\"quantityValue\":4000,\"quantityUnit\":\"litros\"}', NULL, NULL, NULL, NULL, '2026-03-21 11:19:06', '2026-03-21 11:19:10'),
('59ade959-a08d-4a37-aa45-a9dce5a1b692', '584fe2ec-1416-4c49-8fed-dbd2b8ccdacf', NULL, '5588091a-2483-11f1-9638-5a0d05a37ed3', 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-21 11:19:06', '2026-03-21 11:19:06'),
('5d0f9707-979e-42b6-8694-705aed3e324e', '036ca52d-e76e-47bb-89e1-efd58819ec66', NULL, '558806f4-2483-11f1-9638-5a0d05a37ed3', 'completed', '1200 litros', '{\"quantityValue\":1200,\"quantityUnit\":\"litros\"}', NULL, NULL, NULL, NULL, '2026-03-20 20:48:14', '2026-03-20 20:48:18'),
('5ec88aac-d0bb-4628-a600-f1bbf118c724', 'fb969b06-0124-4c89-aeb2-c5f1c9c00d16', NULL, '558809a6-2483-11f1-9638-5a0d05a37ed3', 'completed', '2024-10-25T12:00:00', '{\"deliveryDeadlineAt\":\"2024-10-25T12:00:00\"}', NULL, NULL, NULL, NULL, '2026-03-21 13:49:39', '2026-03-21 13:50:20'),
('63211341-d06b-48c5-9628-e188c0db94e3', '6f5dad78-f378-444a-92f0-3a5a12152765', NULL, '5588091a-2483-11f1-9638-5a0d05a37ed3', 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-21 11:32:33', '2026-03-21 11:32:33'),
('63576e70-0ef1-421e-881c-1ddc4f394b77', '691208f1-454b-47fc-b454-c963ca6cd035', NULL, '558804b0-2483-11f1-9638-5a0d05a37ed3', 'completed', 'leche', '{\"productText\":\"leche\"}', NULL, NULL, NULL, NULL, '2026-03-21 11:45:15', '2026-03-21 11:45:21'),
('65f7cbbb-f054-486d-9e5e-60556e50d4d3', 'a94a2422-7ad6-4323-9035-f3ae5af00538', NULL, '558809a6-2483-11f1-9638-5a0d05a37ed3', 'completed', '2026-05-14T22:00:00', '{\"deliveryDeadlineAt\":\"2026-05-14T22:00:00\"}', NULL, NULL, NULL, NULL, '2026-03-20 20:55:15', '2026-03-20 20:55:32'),
('673b562d-de80-4953-b14a-540b429c2220', '9032db00-ebd9-412e-9525-dec6a6a56837', NULL, '558806f4-2483-11f1-9638-5a0d05a37ed3', 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-20 18:14:01', '2026-03-20 18:14:01'),
('6bd59953-e109-44bb-84de-dab696290429', '036ca52d-e76e-47bb-89e1-efd58819ec66', NULL, '558809a6-2483-11f1-9638-5a0d05a37ed3', 'completed', '2026-05-14T22:00:00', '{\"deliveryDeadlineAt\":\"2026-05-14T22:00:00\"}', NULL, NULL, NULL, NULL, '2026-03-20 20:48:14', '2026-03-20 20:49:06'),
('6e46816a-63da-441b-b6c0-3064f32853f3', '584fe2ec-1416-4c49-8fed-dbd2b8ccdacf', NULL, '55880942-2483-11f1-9638-5a0d05a37ed3', 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-21 11:19:06', '2026-03-21 11:19:06'),
('7069658f-a78b-4b5f-8753-15193bd16971', '691208f1-454b-47fc-b454-c963ca6cd035', NULL, '558806f4-2483-11f1-9638-5a0d05a37ed3', 'completed', '15000 litros', '{\"quantityValue\":15000,\"quantityUnit\":\"litros\"}', NULL, NULL, NULL, NULL, '2026-03-21 11:45:15', '2026-03-21 11:46:12'),
('709e8450-f727-42d8-b479-ed06ab219b69', '036ca52d-e76e-47bb-89e1-efd58819ec66', NULL, '55880974-2483-11f1-9638-5a0d05a37ed3', 'completed', '2026-05-12T00:00:00', '{\"requestedPickupAt\":\"2026-05-12T00:00:00\"}', NULL, NULL, NULL, NULL, '2026-03-20 20:48:14', '2026-03-20 20:49:06'),
('751b2ba7-f12d-42b7-8e50-ea46302b1b23', 'a94a2422-7ad6-4323-9035-f3ae5af00538', NULL, '5588091a-2483-11f1-9638-5a0d05a37ed3', 'completed', 'Malaga', '{\"originText\":\"Malaga\"}', NULL, NULL, NULL, NULL, '2026-03-20 20:55:15', '2026-03-20 20:55:19'),
('77d69d36-7bd4-4b71-a44b-413037a6683b', '6f5dad78-f378-444a-92f0-3a5a12152765', NULL, '55880974-2483-11f1-9638-5a0d05a37ed3', 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-21 11:32:33', '2026-03-21 11:32:33'),
('7a4e076d-b8d5-47c5-b4db-f28a2d050d7b', 'fb969b06-0124-4c89-aeb2-c5f1c9c00d16', NULL, '558806f4-2483-11f1-9638-5a0d05a37ed3', 'completed', '1200 litros', '{\"quantityValue\":1200,\"quantityUnit\":\"litros\"}', NULL, NULL, NULL, NULL, '2026-03-21 13:49:39', '2026-03-21 13:49:43'),
('7b43ee35-dc18-4cd2-85c3-340b08cef54c', '9032db00-ebd9-412e-9525-dec6a6a56837', NULL, '5588091a-2483-11f1-9638-5a0d05a37ed3', 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-20 18:14:01', '2026-03-20 18:14:01'),
('7d3aa4e1-8184-4aff-9b82-78ab30da60ac', '691208f1-454b-47fc-b454-c963ca6cd035', NULL, '55880942-2483-11f1-9638-5a0d05a37ed3', 'completed', 'Morón de la frontera', '{\"destinationText\":\"Morón de la frontera\"}', NULL, NULL, NULL, NULL, '2026-03-21 11:45:15', '2026-03-21 11:45:21'),
('7e7c0ebe-e127-4999-aa5e-e80fa9690781', '584fe2ec-1416-4c49-8fed-dbd2b8ccdacf', NULL, '558809a6-2483-11f1-9638-5a0d05a37ed3', 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-21 11:19:06', '2026-03-21 11:19:06'),
('7f67d338-d655-44d5-a21b-18c61922fbcb', '861a7967-6a5d-4829-91fe-ec2309ef4046', NULL, '55880942-2483-11f1-9638-5a0d05a37ed3', 'completed', 'Málaga', '{\"destinationText\":\"Málaga\"}', NULL, NULL, NULL, NULL, '2026-03-21 11:02:31', '2026-03-21 11:03:12'),
('830a4248-7851-42e5-b573-487e34335693', 'ee55ce44-2ccd-4b28-9c3a-80739ad0748d', NULL, '558809a6-2483-11f1-9638-5a0d05a37ed3', 'completed', '2024-05-12T22:00:00+02:00', '{\"deliveryDeadlineAt\":\"2024-05-12T22:00:00+02:00\"}', NULL, NULL, NULL, NULL, '2026-03-20 19:31:34', '2026-03-20 19:32:25'),
('848018e6-182a-4f7e-93b9-3b506e4a2d12', '691208f1-454b-47fc-b454-c963ca6cd035', NULL, '55880974-2483-11f1-9638-5a0d05a37ed3', 'completed', '2024-08-12T12:30:00', '{\"requestedPickupAt\":\"2024-08-12T12:30:00\"}', NULL, NULL, NULL, NULL, '2026-03-21 11:45:15', '2026-03-21 11:46:12'),
('88ededbb-1465-4c48-8ac7-7bb7a5968883', '6f5dad78-f378-444a-92f0-3a5a12152765', NULL, '55880942-2483-11f1-9638-5a0d05a37ed3', 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-21 11:32:33', '2026-03-21 11:32:33'),
('8fae8171-7dda-4a12-8a51-069c3a7557cc', '691208f1-454b-47fc-b454-c963ca6cd035', NULL, '558809a6-2483-11f1-9638-5a0d05a37ed3', 'completed', '2024-08-13T22:00:00', '{\"deliveryDeadlineAt\":\"2024-08-13T22:00:00\"}', NULL, NULL, NULL, NULL, '2026-03-21 11:45:15', '2026-03-21 11:46:12'),
('92d05324-d316-4d94-bfb8-1565e1ba9ef1', '6f5dad78-f378-444a-92f0-3a5a12152765', NULL, '558809a6-2483-11f1-9638-5a0d05a37ed3', 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-21 11:32:33', '2026-03-21 11:32:33'),
('975ddf56-e696-49e1-8cbe-9a7a13451686', '9032db00-ebd9-412e-9525-dec6a6a56837', NULL, '558804b0-2483-11f1-9638-5a0d05a37ed3', 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-20 18:14:01', '2026-03-20 18:14:01'),
('9b1e7d89-2c89-4805-96d5-3cc9f7717010', '036ca52d-e76e-47bb-89e1-efd58819ec66', NULL, '5588091a-2483-11f1-9638-5a0d05a37ed3', 'completed', 'Malaga', '{\"originText\":\"Malaga\"}', NULL, NULL, NULL, NULL, '2026-03-20 20:48:14', '2026-03-20 20:48:18'),
('a2dc60d3-85eb-4d50-9ca2-357f71dc6dfe', '6f5dad78-f378-444a-92f0-3a5a12152765', NULL, '558806f4-2483-11f1-9638-5a0d05a37ed3', 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-21 11:32:33', '2026-03-21 11:32:33'),
('a4f190a4-6f5c-4809-b134-f1deb36ffc9c', 'd7433268-cf01-4283-a7e4-930bd36ea92d', NULL, '558809a6-2483-11f1-9638-5a0d05a37ed3', 'completed', '2024-08-13T22:00:00', '{\"deliveryDeadlineAt\":\"2024-08-13T22:00:00\"}', NULL, NULL, NULL, NULL, '2026-03-21 11:53:31', '2026-03-21 11:53:56'),
('a4fbe411-998f-4bd1-a74e-a9ec103db856', 'd7433268-cf01-4283-a7e4-930bd36ea92d', NULL, '55880942-2483-11f1-9638-5a0d05a37ed3', 'completed', 'Moron', '{\"destinationText\":\"Moron\"}', NULL, NULL, NULL, NULL, '2026-03-21 11:53:31', '2026-03-21 11:53:56'),
('b932be81-d78f-4d01-8e41-921e167dcaab', '036ca52d-e76e-47bb-89e1-efd58819ec66', NULL, '558804b0-2483-11f1-9638-5a0d05a37ed3', 'completed', 'leche', '{\"productText\":\"leche\"}', NULL, NULL, NULL, NULL, '2026-03-20 20:48:14', '2026-03-20 20:48:18'),
('b9a0c876-2c18-46ad-827e-3d9ddc8d17ad', '036ca52d-e76e-47bb-89e1-efd58819ec66', NULL, '55880942-2483-11f1-9638-5a0d05a37ed3', 'completed', 'Madrid', '{\"destinationText\":\"Madrid\"}', NULL, NULL, NULL, NULL, '2026-03-20 20:48:14', '2026-03-20 20:48:18'),
('bb08854f-15e7-4c00-9e37-6115acccb58d', 'ee55ce44-2ccd-4b28-9c3a-80739ad0748d', NULL, '558806f4-2483-11f1-9638-5a0d05a37ed3', 'completed', '1200 litros', '{\"quantityValue\":1200,\"quantityUnit\":\"litros\"}', NULL, NULL, NULL, NULL, '2026-03-20 19:31:34', '2026-03-20 19:31:38'),
('c3c1b480-5dce-4d42-9774-0fdfaad98556', '584fe2ec-1416-4c49-8fed-dbd2b8ccdacf', NULL, '558804b0-2483-11f1-9638-5a0d05a37ed3', 'completed', 'zumo', '{\"productText\":\"zumo\"}', NULL, NULL, NULL, NULL, '2026-03-21 11:19:06', '2026-03-21 11:19:10'),
('c4aed7fa-54be-4c3e-93b7-c44010fc92dc', 'ee55ce44-2ccd-4b28-9c3a-80739ad0748d', NULL, '558804b0-2483-11f1-9638-5a0d05a37ed3', 'completed', 'leche', '{\"productText\":\"leche\"}', NULL, NULL, NULL, NULL, '2026-03-20 19:31:34', '2026-03-20 19:31:38'),
('c62d9b15-82bd-4bbf-87c3-3872fdcdc140', 'ee55ce44-2ccd-4b28-9c3a-80739ad0748d', NULL, '5588091a-2483-11f1-9638-5a0d05a37ed3', 'completed', 'Malaga', '{\"originText\":\"Malaga\"}', NULL, NULL, NULL, NULL, '2026-03-20 19:31:34', '2026-03-20 19:31:38'),
('d5d528f4-0d80-483c-bbf9-ddcd8eaa024f', 'a94a2422-7ad6-4323-9035-f3ae5af00538', NULL, '55880942-2483-11f1-9638-5a0d05a37ed3', 'completed', 'madrid', '{\"destinationText\":\"madrid\"}', NULL, NULL, NULL, NULL, '2026-03-20 20:55:15', '2026-03-20 20:55:19'),
('dcdc50bc-abe5-4f29-9eb6-96597246a6bb', '9032db00-ebd9-412e-9525-dec6a6a56837', NULL, '558809a6-2483-11f1-9638-5a0d05a37ed3', 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-20 18:14:01', '2026-03-20 18:14:01'),
('df95f619-eb2f-49d8-a38e-722621b65ec7', '95759801-03ef-4e15-b6d4-5372b8989d09', NULL, '5588091a-2483-11f1-9638-5a0d05a37ed3', 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-21 11:16:57', '2026-03-21 11:16:57'),
('e5fc20b7-ae3f-412d-8474-2b59e8c9cf53', 'a94a2422-7ad6-4323-9035-f3ae5af00538', NULL, '558806f4-2483-11f1-9638-5a0d05a37ed3', 'completed', '1200 litros', '{\"quantityValue\":1200,\"quantityUnit\":\"litros\"}', NULL, NULL, NULL, NULL, '2026-03-20 20:55:15', '2026-03-20 20:55:19'),
('e8278ded-8c59-4b21-ad7f-6c1034343caa', '95759801-03ef-4e15-b6d4-5372b8989d09', NULL, '55880942-2483-11f1-9638-5a0d05a37ed3', 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-21 11:16:57', '2026-03-21 11:16:57'),
('e9cc64b4-491c-4662-9f0f-95310411af35', 'a94a2422-7ad6-4323-9035-f3ae5af00538', NULL, '558804b0-2483-11f1-9638-5a0d05a37ed3', 'completed', 'leche', '{\"productText\":\"leche\"}', NULL, NULL, NULL, NULL, '2026-03-20 20:55:15', '2026-03-20 20:55:19'),
('ea7c8727-1fb8-4638-a39b-af6a71e43adc', 'fb969b06-0124-4c89-aeb2-c5f1c9c00d16', NULL, '5588091a-2483-11f1-9638-5a0d05a37ed3', 'completed', 'lleida', '{\"originText\":\"lleida\"}', NULL, NULL, NULL, NULL, '2026-03-21 13:49:39', '2026-03-21 13:49:54'),
('ef8d6d8a-93c0-4e5f-8acb-26bd7131d8fa', '584fe2ec-1416-4c49-8fed-dbd2b8ccdacf', NULL, '55880974-2483-11f1-9638-5a0d05a37ed3', 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-21 11:19:06', '2026-03-21 11:19:06'),
('f21ee97f-e4d9-4e21-8a3c-c0a28f6d9204', '6f5dad78-f378-444a-92f0-3a5a12152765', NULL, '558804b0-2483-11f1-9638-5a0d05a37ed3', 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-21 11:32:33', '2026-03-21 11:32:33'),
('f255889a-e4e0-44c5-bf50-ac4611b05dea', 'ee55ce44-2ccd-4b28-9c3a-80739ad0748d', NULL, '55880942-2483-11f1-9638-5a0d05a37ed3', 'completed', 'Gijon', '{\"destinationText\":\"Gijon\"}', NULL, NULL, NULL, NULL, '2026-03-20 19:31:34', '2026-03-20 19:31:38'),
('f5c446e9-6ac9-4ec1-97bf-68d439a286b3', 'd7433268-cf01-4283-a7e4-930bd36ea92d', NULL, '558806f4-2483-11f1-9638-5a0d05a37ed3', 'completed', '15000 litros', '{\"quantityValue\":15000,\"quantityUnit\":\"litros\"}', NULL, NULL, NULL, NULL, '2026-03-21 11:53:31', '2026-03-21 11:53:56'),
('f95c1472-2a54-44d8-8710-f9360732b2cb', '861a7967-6a5d-4829-91fe-ec2309ef4046', NULL, '55880974-2483-11f1-9638-5a0d05a37ed3', 'completed', '2026-05-24T21:34:00', '{\"requestedPickupAt\":\"2026-05-24T21:34:00\"}', NULL, NULL, NULL, NULL, '2026-03-21 11:02:31', '2026-03-21 11:03:48'),
('fb20d918-ba39-410a-9bfc-d795acaafa56', 'd7433268-cf01-4283-a7e4-930bd36ea92d', NULL, '558804b0-2483-11f1-9638-5a0d05a37ed3', 'completed', 'leche', '{\"productText\":\"leche\"}', NULL, NULL, NULL, NULL, '2026-03-21 11:53:31', '2026-03-21 11:53:36');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_ai_validation_results`
--

CREATE TABLE `tra_ai_validation_results` (
  `validation_result_id` char(36) NOT NULL,
  `session_id` char(36) DEFAULT NULL,
  `quote_request_id` char(36) DEFAULT NULL,
  `order_id` char(36) DEFAULT NULL,
  `validation_scope` varchar(30) NOT NULL,
  `rule_code` varchar(40) NOT NULL,
  `severity` varchar(20) NOT NULL,
  `validation_status` varchar(20) NOT NULL,
  `message` text NOT NULL,
  `blocking` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tra_ai_validation_results`
--

INSERT INTO `tra_ai_validation_results` (`validation_result_id`, `session_id`, `quote_request_id`, `order_id`, `validation_scope`, `rule_code`, `severity`, `validation_status`, `message`, `blocking`, `created_at`) VALUES
('08fd37c7-b3c7-4b6f-977d-77383c05b42d', NULL, '04d06af3-dcff-4d4d-b1f0-f003ee894ab7', NULL, 'quote_request', 'ORIGIN_REQUIRED', 'error', 'passed', 'Origen informado correctamente.', 0, '2026-03-21 11:04:12'),
('0a31381b-8552-484f-9d3a-234eb8ff51eb', NULL, '4b1e33b5-cef5-43ae-b69b-029e74527449', NULL, 'quote_request', 'COMPATIBILITY_REVIEW_REQUIRED', 'warning', 'warning', 'No hay validación directa de food grade a nivel de vehículo. Se recomienda revisión operativa si es crítico.', 0, '2026-03-20 21:00:55'),
('0bb0f11c-9d40-4b8b-91bc-fe2034cc1e70', NULL, 'fa35312a-bb27-4f29-bac0-401419fd54ab', NULL, 'quote_request', 'QUANTITY_REQUIRED', 'error', 'passed', 'Cantidad informada correctamente.', 0, '2026-03-21 11:53:56'),
('1658cdc6-34c5-496a-ad61-0d79189a2a7b', NULL, 'ac7957fc-a794-449a-9b16-ba59bfb3c317', NULL, 'quote_request', 'ORIGIN_POINT_REQUIRED', 'error', 'failed', 'Necesito una dirección o punto de carga válido para el origen.', 1, '2026-03-21 13:50:20'),
('1f57a0e4-5176-4660-9c6b-160b1abafd20', NULL, 'fa35312a-bb27-4f29-bac0-401419fd54ab', NULL, 'quote_request', 'DESTINATION_REQUIRED', 'error', 'passed', 'Destino informado correctamente.', 0, '2026-03-21 11:53:56'),
('2a2719a1-0072-4581-8b1d-ffaecd7aaf54', NULL, '4db7e754-15d5-4360-afd4-1619be8859d4', NULL, 'quote_request', 'LOAD_DATE_REQUIRED', 'error', 'passed', 'Fecha de carga informada correctamente.', 0, '2026-03-21 11:46:12'),
('2c2e7e97-f134-4979-a5fa-b6910df20c6e', NULL, '4b1e33b5-cef5-43ae-b69b-029e74527449', NULL, 'quote_request', 'LOAD_DATE_REQUIRED', 'error', 'passed', 'Fecha de carga informada correctamente.', 0, '2026-03-20 21:00:55'),
('300204c6-afe1-4455-9d0a-c8c7490b646f', NULL, '4b1e33b5-cef5-43ae-b69b-029e74527449', NULL, 'quote_request', 'DELIVERY_DEADLINE_REQUIRED', 'error', 'passed', 'Límite de entrega informado correctamente.', 0, '2026-03-20 21:00:55'),
('3295ad06-ea42-4355-a6a6-e070b863b51d', NULL, '4b1e33b5-cef5-43ae-b69b-029e74527449', NULL, 'quote_request', 'PRODUCT_REQUIRED', 'error', 'passed', 'Producto informado correctamente.', 0, '2026-03-20 21:00:55'),
('33efccec-d423-42dd-bf9d-446bec0054df', NULL, '4db7e754-15d5-4360-afd4-1619be8859d4', NULL, 'quote_request', 'DELIVERY_DEADLINE_REQUIRED', 'error', 'passed', 'Límite de entrega informado correctamente.', 0, '2026-03-21 11:46:12'),
('379acfbd-9a15-4f85-a649-1e0994ab381d', NULL, '4db7e754-15d5-4360-afd4-1619be8859d4', NULL, 'quote_request', 'COMPATIBILITY_TANKS_AVAILABLE', 'info', 'passed', 'Se han encontrado 2 tanques compatibles para el producto.', 0, '2026-03-21 11:46:12'),
('37cba683-3333-4140-bb0e-6182b4487ccc', NULL, '4db7e754-15d5-4360-afd4-1619be8859d4', NULL, 'quote_request', 'PRODUCT_REQUIRED', 'error', 'passed', 'Producto informado correctamente.', 0, '2026-03-21 11:46:12'),
('3c4ae498-fa10-42ff-8122-dd16544ff3a5', NULL, '4db7e754-15d5-4360-afd4-1619be8859d4', NULL, 'quote_request', 'DESTINATION_REQUIRED', 'error', 'passed', 'Destino informado correctamente.', 0, '2026-03-21 11:46:12'),
('4af1826d-a5fd-4324-ae61-d17d78a50f12', NULL, '4b1e33b5-cef5-43ae-b69b-029e74527449', NULL, 'quote_request', 'COMPATIBILITY_TANKS_AVAILABLE', 'info', 'passed', 'Se han encontrado 2 tanques compatibles para el producto.', 0, '2026-03-20 21:00:55'),
('545ec014-dccb-4103-96f9-065ef9c817e3', NULL, 'ac7957fc-a794-449a-9b16-ba59bfb3c317', NULL, 'quote_request', 'COMPATIBILITY_REVIEW_REQUIRED', 'warning', 'warning', 'No hay validación directa de food grade a nivel de vehículo. Se recomienda revisión operativa si es crítico.', 0, '2026-03-21 13:50:20'),
('55adb7be-bd02-463a-abb6-a913e49cc59a', NULL, 'd72cf8f2-d6ea-448b-94c0-e993af9bd482', NULL, 'quote_request', 'LOAD_DATE_REQUIRED', 'error', 'passed', 'Fecha de carga informada correctamente.', 0, '2026-03-20 19:32:25'),
('5b00055a-2805-42db-8db8-46297fb2ea23', NULL, '4db7e754-15d5-4360-afd4-1619be8859d4', NULL, 'quote_request', 'COMPATIBILITY_REVIEW_REQUIRED', 'warning', 'warning', 'No hay validación directa de food grade a nivel de vehículo. Se recomienda revisión operativa si es crítico.', 0, '2026-03-21 11:46:12'),
('660971e1-3ded-4c2d-a951-26d42939c80f', NULL, '04d06af3-dcff-4d4d-b1f0-f003ee894ab7', NULL, 'quote_request', 'DELIVERY_DEADLINE_REQUIRED', 'error', 'passed', 'Límite de entrega informado correctamente.', 0, '2026-03-21 11:04:12'),
('67338d7c-c967-460d-94f0-306d65cc78cb', NULL, 'd72cf8f2-d6ea-448b-94c0-e993af9bd482', NULL, 'quote_request', 'PRODUCT_REQUIRED', 'error', 'passed', 'Producto informado correctamente.', 0, '2026-03-20 19:32:25'),
('75e8f070-7cdd-4144-baf9-d7681977eca1', NULL, '04d06af3-dcff-4d4d-b1f0-f003ee894ab7', NULL, 'quote_request', 'PRODUCT_REQUIRED', 'error', 'passed', 'Producto informado correctamente.', 0, '2026-03-21 11:04:12'),
('7b0b4e1b-7f39-4927-8ff0-c152438499a3', NULL, 'ac7957fc-a794-449a-9b16-ba59bfb3c317', NULL, 'quote_request', 'DESTINATION_REQUIRED', 'error', 'passed', 'Destino informado correctamente.', 0, '2026-03-21 13:50:20'),
('7dbe6dcd-d658-4475-b1cc-76684c09ba07', NULL, 'ac7957fc-a794-449a-9b16-ba59bfb3c317', NULL, 'quote_request', 'QUANTITY_REQUIRED', 'error', 'passed', 'Cantidad informada correctamente.', 0, '2026-03-21 13:50:20'),
('81f8e4fa-e2e5-4ffc-83a9-7a1e7787ab43', NULL, 'ac7957fc-a794-449a-9b16-ba59bfb3c317', NULL, 'quote_request', 'PRODUCT_REQUIRED', 'error', 'passed', 'Producto informado correctamente.', 0, '2026-03-21 13:50:20'),
('8d1ab5d0-224a-4c3a-bbec-d56ca243c487', NULL, 'ac7957fc-a794-449a-9b16-ba59bfb3c317', NULL, 'quote_request', 'LOAD_DATE_REQUIRED', 'error', 'passed', 'Fecha de carga informada correctamente.', 0, '2026-03-21 13:50:20'),
('932d4154-f499-4632-a163-bdaecd54d53e', NULL, '4b1e33b5-cef5-43ae-b69b-029e74527449', NULL, 'quote_request', 'QUANTITY_REQUIRED', 'error', 'passed', 'Cantidad informada correctamente.', 0, '2026-03-20 21:00:55'),
('93c56148-d033-44a4-82c0-c9693c5a6cf1', NULL, 'd72cf8f2-d6ea-448b-94c0-e993af9bd482', NULL, 'quote_request', 'QUANTITY_REQUIRED', 'error', 'passed', 'Cantidad informada correctamente.', 0, '2026-03-20 19:32:25'),
('9c67a773-b0f2-4eb1-bfcb-4a55486b247e', NULL, 'd72cf8f2-d6ea-448b-94c0-e993af9bd482', NULL, 'quote_request', 'DESTINATION_REQUIRED', 'error', 'passed', 'Destino informado correctamente.', 0, '2026-03-20 19:32:25'),
('9d13e602-7125-4f94-b8e1-ffd5da454576', NULL, '04d06af3-dcff-4d4d-b1f0-f003ee894ab7', NULL, 'quote_request', 'LOAD_DATE_REQUIRED', 'error', 'passed', 'Fecha de carga informada correctamente.', 0, '2026-03-21 11:04:12'),
('9ee42a80-4eb0-4519-92a1-2bb60d85c282', NULL, '4db7e754-15d5-4360-afd4-1619be8859d4', NULL, 'quote_request', 'ORIGIN_REQUIRED', 'error', 'passed', 'Origen informado correctamente.', 0, '2026-03-21 11:46:12'),
('a504bc07-054f-47df-8f4e-d10222705f84', NULL, 'fa35312a-bb27-4f29-bac0-401419fd54ab', NULL, 'quote_request', 'COMPATIBILITY_REVIEW_REQUIRED', 'warning', 'warning', 'No hay validación directa de food grade a nivel de vehículo. Se recomienda revisión operativa si es crítico.', 0, '2026-03-21 11:53:56'),
('ac576102-f24d-42d4-bab1-c52b2f24e02d', NULL, '04d06af3-dcff-4d4d-b1f0-f003ee894ab7', NULL, 'quote_request', 'QUANTITY_REQUIRED', 'error', 'passed', 'Cantidad informada correctamente.', 0, '2026-03-21 11:04:12'),
('ad200e19-1a58-4752-9d1d-880f4ad9761b', NULL, 'fa35312a-bb27-4f29-bac0-401419fd54ab', NULL, 'quote_request', 'LOAD_DATE_REQUIRED', 'error', 'passed', 'Fecha de carga informada correctamente.', 0, '2026-03-21 11:53:56'),
('b0f4984b-2b65-4efb-aaf7-6216a5ebc8cc', NULL, '4db7e754-15d5-4360-afd4-1619be8859d4', NULL, 'quote_request', 'QUANTITY_REQUIRED', 'error', 'passed', 'Cantidad informada correctamente.', 0, '2026-03-21 11:46:12'),
('c0f00baf-f9d2-4cb1-bb54-4589de297992', NULL, 'ac7957fc-a794-449a-9b16-ba59bfb3c317', NULL, 'quote_request', 'AVAILABILITY_REQUIRED', 'error', 'failed', 'No hay disponibilidad registrada de vehículos para esa fecha.', 1, '2026-03-21 13:50:20'),
('c41f9309-87ea-46cf-ac31-ac8c2a58c30a', NULL, 'ac7957fc-a794-449a-9b16-ba59bfb3c317', NULL, 'quote_request', 'DESTINATION_POINT_REQUIRED', 'error', 'failed', 'Necesito una dirección o punto de entrega válido para el destino.', 1, '2026-03-21 13:50:20'),
('c5abd9bc-f76e-4c1c-ad15-13d84d8d9d40', NULL, 'ac7957fc-a794-449a-9b16-ba59bfb3c317', NULL, 'quote_request', 'COMPATIBILITY_TANKS_AVAILABLE', 'info', 'passed', 'Se han encontrado 2 tanques compatibles para el producto.', 0, '2026-03-21 13:50:20'),
('c6d0886c-fa23-4600-9d96-8f5bd2c90776', NULL, 'ac7957fc-a794-449a-9b16-ba59bfb3c317', NULL, 'quote_request', 'DELIVERY_DEADLINE_REQUIRED', 'error', 'passed', 'Límite de entrega informado correctamente.', 0, '2026-03-21 13:50:20'),
('cf26b35d-c03f-42ce-884b-3785ed76f1bb', NULL, 'd72cf8f2-d6ea-448b-94c0-e993af9bd482', NULL, 'quote_request', 'DELIVERY_DEADLINE_REQUIRED', 'error', 'passed', 'Límite de entrega informado correctamente.', 0, '2026-03-20 19:32:25'),
('d1b65467-75fc-4e65-bdf8-a42eb8d898e7', NULL, 'fa35312a-bb27-4f29-bac0-401419fd54ab', NULL, 'quote_request', 'ORIGIN_REQUIRED', 'error', 'passed', 'Origen informado correctamente.', 0, '2026-03-21 11:53:56'),
('d2b4ce9d-87de-4f70-a9fa-9e9379b5e2e4', NULL, '4b1e33b5-cef5-43ae-b69b-029e74527449', NULL, 'quote_request', 'ORIGIN_REQUIRED', 'error', 'passed', 'Origen informado correctamente.', 0, '2026-03-20 21:00:55'),
('dedd64c9-b989-4770-88a7-2c24b7339efa', NULL, 'd72cf8f2-d6ea-448b-94c0-e993af9bd482', NULL, 'quote_request', 'ORIGIN_REQUIRED', 'error', 'passed', 'Origen informado correctamente.', 0, '2026-03-20 19:32:25'),
('e00c557c-00fd-4a02-9724-d22b5c018c8d', NULL, 'ac7957fc-a794-449a-9b16-ba59bfb3c317', NULL, 'quote_request', 'ORIGIN_REQUIRED', 'error', 'passed', 'Origen informado correctamente.', 0, '2026-03-21 13:50:20'),
('e1acfc7a-ad4c-44be-90b3-1964326786e1', NULL, '04d06af3-dcff-4d4d-b1f0-f003ee894ab7', NULL, 'quote_request', 'COMPATIBILITY_PRODUCT_NOT_FOUND', 'error', 'failed', 'No se ha podido normalizar el producto en catálogo para validar compatibilidad.', 1, '2026-03-21 11:04:12'),
('e37ef666-3099-4714-b917-be9049544240', NULL, 'fa35312a-bb27-4f29-bac0-401419fd54ab', NULL, 'quote_request', 'DELIVERY_DEADLINE_REQUIRED', 'error', 'passed', 'Límite de entrega informado correctamente.', 0, '2026-03-21 11:53:56'),
('e3c3091c-d805-401f-a3c2-4ded0387660c', NULL, 'fa35312a-bb27-4f29-bac0-401419fd54ab', NULL, 'quote_request', 'PRODUCT_REQUIRED', 'error', 'passed', 'Producto informado correctamente.', 0, '2026-03-21 11:53:56'),
('eadc4986-894a-4149-b0ed-278247d49326', NULL, 'fa35312a-bb27-4f29-bac0-401419fd54ab', NULL, 'quote_request', 'COMPATIBILITY_TANKS_AVAILABLE', 'info', 'passed', 'Se han encontrado 2 tanques compatibles para el producto.', 0, '2026-03-21 11:53:56'),
('f8730790-5b7c-4427-8599-789cf4d50194', NULL, '04d06af3-dcff-4d4d-b1f0-f003ee894ab7', NULL, 'quote_request', 'DESTINATION_REQUIRED', 'error', 'passed', 'Destino informado correctamente.', 0, '2026-03-21 11:04:12'),
('ff37bfd8-cd26-43df-b8b3-2bcd664c1a0b', NULL, '4b1e33b5-cef5-43ae-b69b-029e74527449', NULL, 'quote_request', 'DESTINATION_REQUIRED', 'error', 'passed', 'Destino informado correctamente.', 0, '2026-03-20 21:00:55');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_ai_wizard_steps`
--

CREATE TABLE `tra_ai_wizard_steps` (
  `wizard_step_id` char(36) NOT NULL,
  `step_code` varchar(40) NOT NULL,
  `step_label` varchar(120) NOT NULL,
  `step_order` int(11) NOT NULL,
  `maps_to_table` varchar(60) DEFAULT NULL,
  `maps_to_field` varchar(80) DEFAULT NULL,
  `is_required` tinyint(1) NOT NULL DEFAULT 1,
  `allow_free_text` tinyint(1) NOT NULL DEFAULT 1,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tra_ai_wizard_steps`
--

INSERT INTO `tra_ai_wizard_steps` (`wizard_step_id`, `step_code`, `step_label`, `step_order`, `maps_to_table`, `maps_to_field`, `is_required`, `allow_free_text`, `active`, `created_at`, `updated_at`) VALUES
('558804b0-2483-11f1-9638-5a0d05a37ed3', 'product', 'Producto', 1, 'tra_ai_quote_requests', 'requested_product_text', 1, 1, 1, '2026-03-20 17:36:31', '2026-03-20 17:36:31'),
('558806f4-2483-11f1-9638-5a0d05a37ed3', 'quantity', 'Cantidad', 2, 'tra_ai_quote_requests', 'requested_volume_liters', 1, 1, 1, '2026-03-20 17:36:31', '2026-03-20 17:36:31'),
('5588091a-2483-11f1-9638-5a0d05a37ed3', 'origin', 'Origen', 3, 'tra_ai_quote_requests', 'origin_text', 1, 1, 1, '2026-03-20 17:36:31', '2026-03-20 17:36:31'),
('55880942-2483-11f1-9638-5a0d05a37ed3', 'destination', 'Destino', 4, 'tra_ai_quote_requests', 'destination_text', 1, 1, 1, '2026-03-20 17:36:31', '2026-03-20 17:36:31'),
('55880974-2483-11f1-9638-5a0d05a37ed3', 'requested_date', 'Fecha solicitada', 11, 'tra_ai_quote_requests', 'requested_load_date', 1, 1, 1, '2026-03-20 17:36:31', '2026-03-21 13:54:15'),
('558809a6-2483-11f1-9638-5a0d05a37ed3', 'delivery_deadline', 'Límite de entrega', 12, 'tra_ai_quote_requests', 'delivery_deadline_datetime', 1, 1, 1, '2026-03-20 17:36:31', '2026-03-21 13:54:15'),
('73018cf0-252d-11f1-8370-5a0d05a37ed2', 'origin_address', 'Dirección de recogida', 5, NULL, NULL, 1, 1, 1, '2026-03-21 13:54:15', '2026-03-21 13:54:15'),
('7302bbf2-252d-11f1-8370-5a0d05a37ed2', 'origin_contact_name', 'Responsable de recogida', 6, NULL, NULL, 1, 1, 1, '2026-03-21 13:54:15', '2026-03-21 13:54:15'),
('73039d1a-252d-11f1-8370-5a0d05a37ed2', 'origin_contact_phone', 'Teléfono de recogida', 7, NULL, NULL, 1, 1, 1, '2026-03-21 13:54:15', '2026-03-21 13:54:15'),
('7304ba4c-252d-11f1-8370-5a0d05a37ed2', 'destination_address', 'Dirección de entrega', 8, NULL, NULL, 1, 1, 1, '2026-03-21 13:54:15', '2026-03-21 13:54:15'),
('7305a1f0-252d-11f1-8370-5a0d05a37ed2', 'destination_contact_name', 'Responsable de entrega', 9, NULL, NULL, 1, 1, 1, '2026-03-21 13:54:15', '2026-03-21 13:54:15'),
('73068a48-252d-11f1-8370-5a0d05a37ed2', 'destination_contact_phone', 'Teléfono de entrega', 10, NULL, NULL, 1, 1, 1, '2026-03-21 13:54:15', '2026-03-21 13:54:15');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_assignments`
--

CREATE TABLE `tra_assignments` (
  `assignment_id` char(36) NOT NULL COMMENT 'Identificador de asignación',
  `order_id` char(36) NOT NULL COMMENT 'Pedido asignado',
  `vehicle_id` char(36) NOT NULL COMMENT 'Vehículo asignado',
  `tank_id` char(36) NOT NULL COMMENT 'Cisterna/tanque asignado',
  `driver_id` char(36) NOT NULL COMMENT 'Conductor asignado',
  `assigned_route_id` char(36) DEFAULT NULL COMMENT 'Ruta base asignada',
  `assignment_status` varchar(20) NOT NULL COMMENT 'Estado de asignación',
  `assignment_score` decimal(6,2) DEFAULT NULL COMMENT 'Puntuación de adecuación',
  `reason_selected` text DEFAULT NULL COMMENT 'Motivo/resumen de selección',
  `assigned_at` timestamp NULL DEFAULT NULL COMMENT 'Momento de asignación',
  `assigned_by` varchar(120) DEFAULT NULL COMMENT 'Usuario/sistema asignador',
  `manual_override` tinyint(1) NOT NULL COMMENT 'Se forzó manualmente',
  `override_reason` text DEFAULT NULL COMMENT 'Motivo de override',
  `planned_km` int(11) DEFAULT NULL COMMENT 'Km planificados',
  `planned_minutes` int(11) DEFAULT NULL COMMENT 'Minutos planificados'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_assignments';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_auth_sessions`
--

CREATE TABLE `tra_auth_sessions` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `access_token_jti` varchar(255) DEFAULT NULL,
  `refresh_token_hash` varchar(255) DEFAULT NULL,
  `ip_address` varchar(128) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `is_revoked` tinyint(1) NOT NULL DEFAULT 0,
  `expires_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tra_auth_sessions`
--

INSERT INTO `tra_auth_sessions` (`id`, `user_id`, `access_token_jti`, `refresh_token_hash`, `ip_address`, `user_agent`, `is_revoked`, `expires_at`, `created_at`, `updated_at`) VALUES
('1b44c179-f6db-49cb-ad20-0002067d2b1f', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'a98b7539-255e-41b9-a782-6f63ac216e18', '$2b$10$GSF3go/4cJKO5OFlL3vIaONriE.zT99gcaVaVyRjRdRec/hdVZBqG', '::1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 0, '2026-03-28 14:54:47', '2026-03-21 14:54:47', '2026-03-21 14:54:47'),
('305e42e0-6e4d-424b-969c-b36fe44ee014', 'f3ef2b90-23b8-11f1-bf2e-5a0d05a37ed2', 'f70d913f-ccff-4ce4-a40a-0800ea850654', NULL, '::1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 1, '2026-03-27 10:33:58', '2026-03-20 10:33:58', '2026-03-20 10:34:19'),
('376624bf-b058-4744-891e-f6459ae5230c', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', '90974892-e758-4534-a3fa-cae9966e05f2', '$2b$10$r63X9MPmJVGiFlN7JCgvSuDajz.wOd1d7o8pgs1wIKhY5s2KBeQzS', '::1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 0, '2026-03-27 21:47:49', '2026-03-20 21:47:49', '2026-03-20 21:47:49'),
('39ee5f6e-3979-40c4-b719-897f577dab03', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', '17dda477-ea0c-4f0c-9b37-71b51767da46', '$2b$10$7aGUdw5ZEOjd596vHTIyX.gjkcBtRQam41Ew0kL2FObLcNsxTocnq', '::1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 0, '2026-03-28 14:49:26', '2026-03-21 14:49:26', '2026-03-21 14:49:26'),
('756bd4a4-2e5b-4192-b9a5-564b96d8a22a', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', '6778bff6-f265-4c6f-9319-5f31754d1d39', '$2b$10$byE3US0NIbjW.o9xT1tot.Wp.iAwbA.m..gHbTi0znXowpIpah7C.', '::1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 0, '2026-03-28 12:53:21', '2026-03-21 12:02:10', '2026-03-21 12:53:21'),
('a0f9124d-dd08-4259-9b32-f2a4b0851da3', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', '0291f787-30de-43d5-8f43-d4bbc17f93dc', NULL, '::1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 1, '2026-03-26 23:02:38', '2026-03-19 23:02:38', '2026-03-19 23:03:37'),
('a198eb15-89ed-4169-af98-6d1c00844206', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'de0d9453-cea6-4d56-a8e8-b84121a1d569', '$2b$10$gsX9PJcV1iMZwewK5RlfgevkPo43B1yiJrhu.t7033mOoso.hR6u2', '::1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 0, '2026-03-27 10:34:31', '2026-03-20 10:34:31', '2026-03-20 10:34:31'),
('a5d920a2-e867-46e8-8a19-3e28848a52df', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', NULL, NULL, '::1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 0, NULL, '2026-03-19 20:21:57', '2026-03-19 20:21:57'),
('abcbc4e0-9878-4cef-b915-ca95bf057cf6', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'dff8f56e-062a-49af-bea1-81033d597f7a', '$2b$10$ixVqtbUGzgnjVQK8kCqAp.zW7GsWG.phu8HpqBbl74HRh4u6tlMiO', '::1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 0, '2026-03-26 23:00:11', '2026-03-19 23:00:10', '2026-03-19 23:00:11'),
('b4b8cbae-a551-40e8-b925-25af1a5d016c', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', '039448b8-2ec9-4dd5-8856-726b531b11b9', '$2b$10$PvJ1zp2v.L2ODAhO3OwRoOuDncZ53T4L4aDMWGrN8I4X02xdv7bDW', '::1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 0, '2026-03-26 23:06:09', '2026-03-19 23:06:09', '2026-03-19 23:06:09'),
('c72d8d8e-70fc-4520-af74-4e35e1212f7a', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'ef91672a-c3ee-4832-ba3b-13db25cad21f', '$2b$10$qxrar65WqkunvsrrHckXQep6qDkV5ghsz/H6iU1gNhp3kzFE.3rKG', '::1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 0, '2026-03-27 21:09:23', '2026-03-20 21:09:23', '2026-03-20 21:09:23'),
('cb30295b-3590-4439-b6ba-007cce67c31a', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'c73bb4f7-03ed-4ccc-94b8-ae0be201a69c', '$2b$10$xTDjlZaqqjMs0geLfgpUU.cabqfOmOxyqp4sngeAN375QxOwLlZIO', '::1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 0, '2026-03-27 17:50:35', '2026-03-20 16:51:10', '2026-03-20 17:50:35'),
('d6b48dbd-bac3-4e74-9fd5-6b45aef56a05', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', '8947f2d6-b6ec-4130-add7-d0267864c9a6', '$2b$10$ArqRpKwJ5AGpJOuddwsRc.YE1QAqU.GgpPs9m.U/EMTFi1rhA0.0C', '::1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 0, '2026-03-27 20:31:09', '2026-03-20 20:09:53', '2026-03-20 20:31:10'),
('d9343fb9-946a-4f47-b439-16a14e2a3281', 'f3ef2b90-23b8-11f1-bf2e-5a0d05a37ed2', '5ab97594-2362-45e5-9352-8b8fd8798da9', NULL, '::1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 1, '2026-03-26 22:27:48', '2026-03-19 21:15:34', '2026-03-19 22:32:14'),
('e1db063c-5893-4327-af0c-e48bb4100214', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', '2730f11e-1c89-4565-b0c2-55d91c50fb92', '$2b$10$X11xJ0jD2IhRBgm/HWCruO6SWY4UUDNZE9QAgrmzJVwCIwA5fdlye', '::1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 0, '2026-03-26 22:49:07', '2026-03-19 22:32:21', '2026-03-19 22:49:07'),
('fa7b44d1-2ad7-46a3-a404-f32d7ed6a240', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', '71078276-af16-4166-a51d-eb907eb329e0', '$2b$10$f3R7Xmf7SD/RM2cGc0azx.5WzRaEAIsP.2BVbodTb7X2aSPa8VMzS', '::1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 0, '2026-03-27 19:13:42', '2026-03-20 19:13:42', '2026-03-20 19:13:43');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_clients`
--

CREATE TABLE `tra_clients` (
  `client_id` char(36) NOT NULL COMMENT 'Identificador único del cliente',
  `client_code` varchar(30) NOT NULL COMMENT 'Código interno legible',
  `legal_name` varchar(200) NOT NULL COMMENT 'Razón social',
  `trade_name` varchar(150) DEFAULT NULL COMMENT 'Nombre comercial',
  `vat_number` varchar(30) DEFAULT NULL COMMENT 'NIF/VAT/CIF',
  `country_code` char(2) NOT NULL COMMENT 'País principal ISO 3166-1 alpha-2',
  `status` varchar(20) NOT NULL COMMENT 'Estado del registro',
  `client_type` varchar(20) NOT NULL COMMENT 'Tipo de relación',
  `primary_sector` varchar(30) NOT NULL COMMENT 'Sector principal',
  `sla_tier` varchar(20) DEFAULT NULL COMMENT 'Nivel de servicio acordado',
  `payment_terms_days` int(11) DEFAULT NULL COMMENT 'Plazo de pago en días',
  `preferred_language` varchar(10) DEFAULT NULL COMMENT 'Idioma preferente',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha de alta lógica',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización',
  `notes` text DEFAULT NULL COMMENT 'Observaciones operativas/comerciales'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_clients';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_client_contacts`
--

CREATE TABLE `tra_client_contacts` (
  `contact_id` char(36) NOT NULL COMMENT 'Identificador del contacto',
  `client_id` char(36) NOT NULL COMMENT 'Cliente propietario del contacto',
  `full_name` varchar(150) NOT NULL COMMENT 'Nombre y apellidos',
  `role` varchar(80) DEFAULT NULL COMMENT 'Cargo',
  `department` varchar(80) DEFAULT NULL COMMENT 'Departamento',
  `email` varchar(150) DEFAULT NULL COMMENT 'Correo electrónico',
  `phone` varchar(40) DEFAULT NULL COMMENT 'Teléfono fijo',
  `mobile_phone` varchar(40) DEFAULT NULL COMMENT 'Móvil',
  `is_primary` tinyint(1) NOT NULL COMMENT 'Marca si es contacto principal',
  `receives_order_updates` tinyint(1) NOT NULL COMMENT 'Recibe notificaciones de pedidos',
  `receives_quote_updates` tinyint(1) NOT NULL COMMENT 'Recibe notificaciones de presupuestos',
  `language_code` varchar(10) DEFAULT NULL COMMENT 'Idioma del contacto',
  `active` tinyint(1) NOT NULL COMMENT 'Contacto activo',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha de alta',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_client_contacts';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_conversation_messages`
--

CREATE TABLE `tra_conversation_messages` (
  `message_id` char(36) NOT NULL COMMENT 'Identificador de mensaje',
  `session_id` char(36) NOT NULL COMMENT 'Sesión asociada',
  `message_sequence` int(11) NOT NULL COMMENT 'Secuencia en la sesión',
  `sender_type` varchar(20) NOT NULL COMMENT 'Emisor',
  `message_text` text NOT NULL COMMENT 'Texto normalizado del mensaje',
  `raw_payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Payload bruto del canal' CHECK (json_valid(`raw_payload`)),
  `extracted_intent_id` char(36) DEFAULT NULL COMMENT 'Intent vinculado',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha/hora del mensaje'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_conversation_messages';

--
-- Volcado de datos para la tabla `tra_conversation_messages`
--

INSERT INTO `tra_conversation_messages` (`message_id`, `session_id`, `message_sequence`, `sender_type`, `message_text`, `raw_payload`, `extracted_intent_id`, `created_at`) VALUES
('28299cf7-4064-45c1-b02e-0a1e6b988dc7', 'e673d422-21f0-407a-bc6a-db1a5ebe98e4', 1, 'user', 'Necesito transportar 12000 litros de leche desde Málaga a Lleida', NULL, NULL, '2026-03-20 16:42:05'),
('565c735c-3f43-47f2-90ce-d5db51799af4', 'aa1e4bd5-7c45-4ee5-98b7-a641b4668611', 1, 'user', 'neceito transportar 12000 litros de leche de lleida a malaga', NULL, NULL, '2026-03-20 16:50:54');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_conversation_sessions`
--

CREATE TABLE `tra_conversation_sessions` (
  `session_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'active',
  `channel` varchar(50) NOT NULL DEFAULT 'chat',
  `language` varchar(10) NOT NULL DEFAULT 'es',
  `context_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`context_json`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tra_conversation_sessions`
--

INSERT INTO `tra_conversation_sessions` (`session_id`, `user_id`, `title`, `status`, `channel`, `language`, `context_json`, `created_at`, `updated_at`) VALUES
('0d614518-6ae1-4ea1-953f-f16337ed1ba2', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-20 16:31:17', '2026-03-20 16:31:17'),
('1ff74e8c-baa5-4a2a-80d1-f81cc1a56422', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-20 16:41:44', '2026-03-20 16:41:44'),
('4e6cc5e8-f78e-4635-9fb7-8586e05c7da2', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-20 16:41:44', '2026-03-20 16:41:44'),
('94c61998-21f2-4e19-89fc-73ad1eb057f4', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-20 16:37:20', '2026-03-20 16:37:20'),
('a4484c9e-f920-498e-8181-59f5dad261e9', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-20 16:31:17', '2026-03-20 16:31:17'),
('a4c3effb-e00c-43d8-b883-81052bcb5166', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-20 16:37:20', '2026-03-20 16:37:20'),
('aa1e4bd5-7c45-4ee5-98b7-a641b4668611', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-20 16:50:35', '2026-03-20 16:50:35'),
('b97425e8-ee61-4c82-bec6-2515acc8b680', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-20 16:31:17', '2026-03-20 16:31:17'),
('cf2231f0-cd65-4901-8c67-cf6368d803e9', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-20 16:50:35', '2026-03-20 16:50:35'),
('e32f0685-5eca-4814-a6db-73b0273d2941', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-20 16:37:20', '2026-03-20 16:37:20'),
('e673d422-21f0-407a-bc6a-db1a5ebe98e4', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-20 16:41:44', '2026-03-20 16:41:44'),
('fdabe623-a663-4497-92d1-d071ee451c2f', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'Asistente de transporte', 'active', 'chat', 'es', '{\"source\":\"assistant_page\"}', '2026-03-20 16:50:35', '2026-03-20 16:50:35');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_conversation_sessions_legacy`
--

CREATE TABLE `tra_conversation_sessions_legacy` (
  `session_id` char(36) NOT NULL COMMENT 'Identificador de sesión',
  `channel` varchar(20) NOT NULL COMMENT 'Canal',
  `client_id` char(36) DEFAULT NULL COMMENT 'Cliente conocido',
  `contact_id` char(36) DEFAULT NULL COMMENT 'Contacto conocido',
  `user_type` varchar(20) NOT NULL COMMENT 'Tipo de usuario',
  `started_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Inicio de sesión',
  `ended_at` timestamp NULL DEFAULT NULL COMMENT 'Fin de sesión',
  `session_status` varchar(20) NOT NULL COMMENT 'Estado',
  `detected_intent_summary` varchar(150) DEFAULT NULL COMMENT 'Resumen intención',
  `source_language` varchar(10) DEFAULT NULL COMMENT 'Idioma',
  `transcript_ref` varchar(200) DEFAULT NULL COMMENT 'Referencia de transcripción',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_conversation_sessions';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_deliveries`
--

CREATE TABLE `tra_deliveries` (
  `delivery_id` char(36) NOT NULL COMMENT 'Identificador de entrega',
  `order_id` char(36) NOT NULL COMMENT 'Pedido',
  `assignment_id` char(36) NOT NULL COMMENT 'Asignación ejecutada',
  `pickup_completed_at` timestamp NULL DEFAULT NULL COMMENT 'Carga completada',
  `delivery_completed_at` timestamp NULL DEFAULT NULL COMMENT 'Entrega completada',
  `delivered_volume_liters` int(11) DEFAULT NULL COMMENT 'Volumen entregado',
  `delivered_weight_tn` decimal(5,2) DEFAULT NULL COMMENT 'Peso entregado',
  `pod_received` tinyint(1) NOT NULL COMMENT 'POD recibido',
  `pod_received_at` timestamp NULL DEFAULT NULL COMMENT 'Fecha de POD',
  `temperature_log_ok` tinyint(1) DEFAULT NULL COMMENT 'Log de temperatura correcto',
  `gps_trace_available` tinyint(1) DEFAULT NULL COMMENT 'Trazado GPS disponible',
  `delivery_status` varchar(20) NOT NULL COMMENT 'Estado final',
  `receiver_name` varchar(150) DEFAULT NULL COMMENT 'Receptor en destino',
  `receiver_signature_ref` varchar(150) DEFAULT NULL COMMENT 'Referencia de firma',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_deliveries';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_delivery_documents`
--

CREATE TABLE `tra_delivery_documents` (
  `delivery_document_id` char(36) NOT NULL COMMENT 'Identificador documental',
  `order_id` char(36) NOT NULL COMMENT 'Pedido',
  `delivery_id` char(36) DEFAULT NULL COMMENT 'Entrega',
  `document_type` varchar(30) NOT NULL COMMENT 'Tipo de documento',
  `document_number` varchar(60) DEFAULT NULL COMMENT 'Número/document id',
  `document_date` date DEFAULT NULL COMMENT 'Fecha del documento',
  `file_ref` varchar(250) DEFAULT NULL COMMENT 'Referencia al fichero',
  `linked_cleaning_id` char(36) DEFAULT NULL COMMENT 'Lavado relacionado',
  `linked_incident_id` char(36) DEFAULT NULL COMMENT 'Incidencia relacionada',
  `gps_trace_ref` varchar(250) DEFAULT NULL COMMENT 'Referencia traza GPS',
  `temperature_log_ref` varchar(250) DEFAULT NULL COMMENT 'Referencia log temperatura',
  `verified` tinyint(1) NOT NULL COMMENT 'Documento verificado',
  `verified_at` timestamp NULL DEFAULT NULL COMMENT 'Fecha de verificación',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_delivery_documents';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_drivers`
--

CREATE TABLE `tra_drivers` (
  `driver_id` char(36) NOT NULL COMMENT 'Identificador del conductor',
  `driver_code` varchar(30) NOT NULL COMMENT 'Código interno',
  `full_name` varchar(150) NOT NULL COMMENT 'Nombre y apellidos',
  `base_location` varchar(120) DEFAULT NULL COMMENT 'Base habitual',
  `license_type` varchar(20) NOT NULL COMMENT 'Permiso habilitante',
  `adr_certified` tinyint(1) NOT NULL COMMENT 'Dispone de ADR',
  `food_handling_certified` tinyint(1) NOT NULL COMMENT 'Formación/manipulación alimentaria',
  `language_skills` varchar(120) DEFAULT NULL COMMENT 'Idiomas',
  `employment_status` varchar(20) NOT NULL COMMENT 'Estado laboral',
  `max_daily_km` int(11) DEFAULT NULL COMMENT 'Km máximos diarios',
  `max_weekly_km` int(11) DEFAULT NULL COMMENT 'Km máximos semanales',
  `max_daily_driving_minutes` int(11) DEFAULT NULL COMMENT 'Minutos máximos de conducción/día',
  `max_routes_per_day` int(11) DEFAULT NULL COMMENT 'Número máximo de rutas/día',
  `active` tinyint(1) NOT NULL COMMENT 'Conductor activo',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha de alta',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_drivers';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_driver_availability`
--

CREATE TABLE `tra_driver_availability` (
  `driver_availability_id` char(36) NOT NULL COMMENT 'Identificador de disponibilidad',
  `driver_id` char(36) NOT NULL COMMENT 'Conductor',
  `availability_date` date NOT NULL COMMENT 'Fecha',
  `shift_start` time DEFAULT NULL COMMENT 'Inicio de turno',
  `shift_end` time DEFAULT NULL COMMENT 'Fin de turno',
  `available` tinyint(1) NOT NULL COMMENT 'Disponible',
  `leave_reason` varchar(80) DEFAULT NULL COMMENT 'Motivo si no disponible',
  `planned_km_limit` int(11) DEFAULT NULL COMMENT 'Límite km de esa fecha',
  `planned_route_limit` int(11) DEFAULT NULL COMMENT 'Límite rutas de esa fecha',
  `notes` text DEFAULT NULL COMMENT 'Observaciones',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_driver_availability';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_driver_route_limits`
--

CREATE TABLE `tra_driver_route_limits` (
  `driver_route_limit_id` char(36) NOT NULL COMMENT 'Identificador de límite',
  `driver_id` char(36) NOT NULL COMMENT 'Conductor',
  `category_id` char(36) DEFAULT NULL COMMENT 'Categoría afectada',
  `route_id` char(36) DEFAULT NULL COMMENT 'Ruta específica',
  `max_routes_per_day` int(11) DEFAULT NULL COMMENT 'Máximo rutas/día',
  `max_km_per_day` int(11) DEFAULT NULL COMMENT 'Máximo km/día',
  `max_nights_out_per_week` int(11) DEFAULT NULL COMMENT 'Máximo pernoctas/semana',
  `max_hours_per_shift` int(11) DEFAULT NULL COMMENT 'Máximo horas por turno',
  `valid_from` date DEFAULT NULL COMMENT 'Inicio de vigencia',
  `valid_to` date DEFAULT NULL COMMENT 'Fin de vigencia',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_driver_route_limits';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_extracted_entities`
--

CREATE TABLE `tra_extracted_entities` (
  `extracted_entity_id` char(36) NOT NULL COMMENT 'Identificador de entidad',
  `session_id` char(36) NOT NULL COMMENT 'Sesión',
  `entity_type` varchar(40) NOT NULL COMMENT 'Tipo de entidad',
  `entity_value_raw` varchar(150) NOT NULL COMMENT 'Texto original',
  `entity_value_normalized` varchar(150) DEFAULT NULL COMMENT 'Valor normalizado',
  `confidence_score` decimal(5,2) NOT NULL COMMENT 'Confianza',
  `mapped_table` varchar(60) DEFAULT NULL COMMENT 'Tabla destino',
  `mapped_record_id` char(36) DEFAULT NULL COMMENT 'Registro destino',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_extracted_entities';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_extracted_intents`
--

CREATE TABLE `tra_extracted_intents` (
  `extracted_intent_id` char(36) NOT NULL COMMENT 'Identificador del intent',
  `session_id` char(36) NOT NULL COMMENT 'Sesión',
  `intent_code` varchar(40) NOT NULL COMMENT 'Código del intent',
  `intent_name` varchar(100) NOT NULL COMMENT 'Nombre descriptivo',
  `confidence_score` decimal(5,2) NOT NULL COMMENT 'Confianza',
  `mapped_entity_type` varchar(40) DEFAULT NULL COMMENT 'Tipo de entidad destino',
  `requires_follow_up` tinyint(1) NOT NULL COMMENT 'Requiere preguntas adicionales',
  `resolution_status` varchar(20) NOT NULL COMMENT 'Estado de resolución',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_extracted_intents';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_incidents`
--

CREATE TABLE `tra_incidents` (
  `incident_id` char(36) NOT NULL COMMENT 'Identificador de incidencia',
  `order_id` char(36) NOT NULL COMMENT 'Pedido afectado',
  `assignment_id` char(36) DEFAULT NULL COMMENT 'Asignación afectada',
  `incident_type` varchar(30) NOT NULL COMMENT 'Tipo de incidencia',
  `severity` varchar(20) NOT NULL COMMENT 'Severidad',
  `incident_status` varchar(20) NOT NULL COMMENT 'Estado',
  `occurred_at` timestamp NULL DEFAULT NULL COMMENT 'Momento del incidente',
  `reported_at` timestamp NULL DEFAULT NULL COMMENT 'Momento del reporte',
  `reported_by` varchar(120) DEFAULT NULL COMMENT 'Informado por',
  `description` text NOT NULL COMMENT 'Descripción',
  `root_cause` text DEFAULT NULL COMMENT 'Causa raíz',
  `corrective_action` text DEFAULT NULL COMMENT 'Acción correctiva',
  `customer_notified` tinyint(1) NOT NULL COMMENT 'Cliente informado',
  `resolved_at` timestamp NULL DEFAULT NULL COMMENT 'Cierre de incidencia'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_incidents';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_llm_actions`
--

CREATE TABLE `tra_llm_actions` (
  `id` char(36) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `provider` varchar(100) NOT NULL,
  `model` varchar(150) NOT NULL,
  `action_type` varchar(100) NOT NULL,
  `input_text` longtext DEFAULT NULL,
  `input_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`input_json`)),
  `output_text` longtext DEFAULT NULL,
  `output_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`output_json`)),
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `error_message` text DEFAULT NULL,
  `latency_ms` int(11) DEFAULT NULL,
  `tokens_input` int(11) DEFAULT NULL,
  `tokens_output` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ;

--
-- Volcado de datos para la tabla `tra_llm_actions`
--

INSERT INTO `tra_llm_actions` (`id`, `user_id`, `provider`, `model`, `action_type`, `input_text`, `input_json`, `output_text`, `output_json`, `status`, `error_message`, `latency_ms`, `tokens_input`, `tokens_output`, `created_at`) VALUES
('13266563-a436-4742-a5f0-9f469c36b84c', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- originAddressText\n- originContactName\n- originContactPhone\n- destinationAddressText\n- destinationContactName\n- destinationContactPhone\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nASSISTANT: He entendido producto: leche, cantidad: 1200 litros. Todavía necesito el origen, el destino, la fecha de recogida y el límite de entrega.\nUSER: desde lleida hasta malaga\nASSISTANT: He entendido producto: leche, cantidad: 1200 litros, origen: lleida, destino: malaga. Me faltan la fecha de recogida y el límite de entrega. ¿Me los indicas?\nUSER: recogida el 12 de agosto a las 14:00 y entrega limite el 25 de octubre a las 12:00\nASSISTANT: He podido completar la solicitud, pero hay varios puntos que impiden validarla: Necesito una dirección o punto de carga válido para el origen; No hay disponibilidad registrada de vehículos para esa fecha; Necesito una dirección o punto de entrega válido para el destino. ¿Puedes revisarlos?\nUSER: origen desde c/ master 23, 25006 LLeida y entrega en C/ Velazqueza 45 456789 Malaga\nUSER: origen desde c/ master 23, 25006 LLeida y entrega en C/ Velazqueza 45 456789 Malaga\nUSER: origen desde c/ master 23, 25006 LLeida y entrega en C/ Velazqueza 45 456789 Malaga\n\nMensaje:\norigen desde c/ master 23, 25006 LLeida y entrega en C/ Velazqueza 45 456789 Malaga\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": \"leche\",\n    \"quantityValue\": 1200,\n    \"quantityUnit\": \"litros\",\n    \"originText\": \"lleida\",\n    \"destinationText\": \"malaga\",\n    \"originAddressText\": \"c/ master 23, 25006 LLeida\",\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": \"C/ Velazqueza 45 456789 Malaga\",\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": \"2024-08-12T14:00:00\",\n    \"deliveryDeadlineAt\": \"2024-10-25T12:00:00\"\n  },\n  \"missingFields\": [\n    \"origin_contact_name\",\n    \"origin_contact_phone\",\n    \"destination_contact_name\",\n    \"destination_contact_phone\"\n  ],\n  \"nextBestQuestion\": \"¿Me puedes proporcionar el nombre y teléfono de contacto tanto para el origen como para el destino?\",\n  \"confidence\": 0.9\n}', NULL, 'success', NULL, 4114, 699, 247, '2026-03-21 14:51:48'),
('182ba310-1641-47bb-b032-1aa490f3d689', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- originAddressText\n- originContactName\n- originContactPhone\n- destinationAddressText\n- destinationContactName\n- destinationContactPhone\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: Necesito transportar 4000 litros de zumo\n\nMensaje:\nNecesito transportar 4000 litros de zumo\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": \"zumo\",\n    \"quantityValue\": 4000,\n    \"quantityUnit\": \"litros\",\n    \"originText\": null,\n    \"destinationText\": null,\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [\n    \"origin\",\n    \"destination\",\n    \"origin_address\",\n    \"origin_contact_name\",\n    \"origin_contact_phone\",\n    \"destination_address\",\n    \"destination_contact_name\",\n    \"destination_contact_phone\",\n    \"requested_date\",\n    \"delivery_deadline\"\n  ],\n  \"nextBestQuestion\": \"¿Podrías indicarme el lugar de origen y destino, así como las direcciones y los contactos para la recogida y entrega, además de las fechas de recogida y entrega previstas?\",\n  \"confidence\": 0.9\n}', NULL, 'success', NULL, 3649, 412, 244, '2026-03-21 12:19:10'),
('1c934785-98ce-4c21-843c-448ec918fb8d', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- originAddressText\n- originContactName\n- originContactPhone\n- destinationAddressText\n- destinationContactName\n- destinationContactPhone\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: Necesito transportar 4000 litros de zumo\n\nMensaje:\nNecesito transportar 4000 litros de zumo\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": \"zumo\",\n    \"quantityValue\": 4000,\n    \"quantityUnit\": \"litros\",\n    \"originText\": null,\n    \"destinationText\": null,\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [\n    \"origin\",\n    \"destination\",\n    \"origin_address\",\n    \"origin_contact_name\",\n    \"origin_contact_phone\",\n    \"destination_address\",\n    \"destination_contact_name\",\n    \"destination_contact_phone\",\n    \"requested_date\",\n    \"delivery_deadline\"\n  ],\n  \"nextBestQuestion\": \"¿Podrías indicarme el lugar de origen y destino del transporte, así como las direcciones y los datos de contacto de ambas ubicaciones, además de las fechas de recogida y entrega?\",\n  \"confidence\": 0.8\n}', NULL, 'success', NULL, 7531, 412, 245, '2026-03-21 12:17:04'),
('24932913-0dff-4057-b29f-dcec54a935fa', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- requestedPickupAt\n- deliveryDeadlineAt\n\nHistorial:\nUSER: becesito transportar 12000 litros de lehce de lleid a a malaga\nUSER: necesito transportar 1200 litros de lehce de lleid aa malaga\nASSISTANT: Necesito algunos datos más para continuar con la solicitud.\nUSER: necesito transportar 1200 litros de lehce de lleid aa malaga\n\nMensaje:\nnecesito transportar 1200 litros de lehce de lleid aa malaga\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, 'OPENAI_PROVIDER_PLACEHOLDER [https://api.openai.com/v1]: Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- requestedPickupAt\n- deliveryDeadlineAt\n\nHistorial:\nUSER: becesito transportar 12000 litros de lehce de lleid a a malaga\nUSER: necesito transportar 1200 litros de lehce de lleid aa malaga\nASSISTANT: Necesito algunos datos más para continuar con la solicitud.\nUSER: necesito transportar 1200 litros de lehce de lleid aa malaga\n\nMensaje:\nnecesito transportar 1200 litros de lehce de lleid aa malaga\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, 'success', NULL, 0, NULL, NULL, '2026-03-20 20:09:59'),
('2b683c88-9f70-4986-9382-838a2408f1f4', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- originAddressText\n- originContactName\n- originContactPhone\n- destinationAddressText\n- destinationContactName\n- destinationContactPhone\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: quiero transportar 1200 litros de leche\nASSISTANT: He entendido producto: leche, cantidad: 1200 litros. Todavía necesito el origen, el destino, la fecha de recogida y el límite de entrega.\nUSER: desde lleida hasta malaga\nASSISTANT: He entendido producto: leche, cantidad: 1200 litros, origen: lleida, destino: malaga. Me faltan la fecha de recogida y el límite de entrega. ¿Me los indicas?\nUSER: recogida el 12 de agosto a las 14:00 y entrega limite el 25 de octubre a las 12:00\nASSISTANT: He podido completar la solicitud, pero hay varios puntos que impiden validarla: Necesito una dirección o punto de carga válido para el origen; No hay disponibilidad registrada de vehículos para esa fecha; Necesito una dirección o punto de entrega válido para el destino. ¿Puedes revisarlos?\nUSER: origen desde c/ master 23, 25006 LLeida y entrega en C/ Velazqueza 45 456789 Malaga\nUSER: origen desde c/ master 23, 25006 LLeida y entrega en C/ Velazqueza 45 456789 Malaga\n\nMensaje:\norigen desde c/ master 23, 25006 LLeida y entrega en C/ Velazqueza 45 456789 Malaga\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": \"leche\",\n    \"quantityValue\": 1200,\n    \"quantityUnit\": \"litros\",\n    \"originText\": \"lleida\",\n    \"destinationText\": \"malaga\",\n    \"originAddressText\": \"c/ master 23, 25006 LLeida\",\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": \"C/ Velazqueza 45 456789 Malaga\",\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": \"2024-08-12T14:00:00\",\n    \"deliveryDeadlineAt\": \"2024-10-25T12:00:00\"\n  },\n  \"missingFields\": [\n    \"origin_contact_name\",\n    \"origin_contact_phone\",\n    \"destination_contact_name\",\n    \"destination_contact_phone\"\n  ],\n  \"nextBestQuestion\": \"¿Me puedes facilitar el nombre y teléfono de contacto tanto para el origen como para el destino?\",\n  \"confidence\": 0.9\n}', NULL, 'success', NULL, 4464, 678, 247, '2026-03-21 14:51:28'),
('2d6cf69f-7e1d-456f-b990-b29cb81dd3b7', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- originAddressText\n- originContactName\n- originContactPhone\n- destinationAddressText\n- destinationContactName\n- destinationContactPhone\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: necesito una cuba de transorte para llevar leche desde Lleida a Morón de la frontera\n\nMensaje:\nnecesito una cuba de transorte para llevar leche desde Lleida a Morón de la frontera\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": \"leche\",\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": \"Lleida\",\n    \"destinationText\": \"Morón de la frontera\",\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [\n    \"quantity\",\n    \"origin_address\",\n    \"origin_contact_name\",\n    \"origin_contact_phone\",\n    \"destination_address\",\n    \"destination_contact_name\",\n    \"destination_contact_phone\",\n    \"requested_date\",\n    \"delivery_deadline\"\n  ],\n  \"nextBestQuestion\": \"¿Podrías indicarme la cantidad y unidad del producto, las direcciones completas de origen y destino, los nombres y teléfonos de contacto en ambos lugares, así como la fecha y hora solicitadas para la recogida y la entrega?\",\n  \"confidence\": 0.8\n}', NULL, 'success', NULL, 4620, 430, 253, '2026-03-21 12:53:36'),
('34e8708b-6b0b-4277-9cb4-98c3117a6a75', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: quiero transportar 1200 litros de leche desde Malaga a madrid\nASSISTANT: He entendido producto: leche, cantidad: 1200 litros, origen: Malaga, destino: madrid. Me faltan la fecha de recogida y el límite de entrega. ¿Me los indicas?\nUSER: recogida el 12/05/2026 para entregar antes de las 22:0 del 14/05/2026\nASSISTANT: He podido completar la solicitud, pero de momento no pasa validación.\nUSER: recogida el 12/05/2026 a las 12:34 para entregar antes de las 22:00 del 14/05/2026\n\nMensaje:\nrecogida el 12/05/2026 a las 12:34 para entregar antes de las 22:00 del 14/05/2026\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": \"leche\",\n    \"quantityValue\": 1200,\n    \"quantityUnit\": \"litros\",\n    \"originText\": \"Malaga\",\n    \"destinationText\": \"madrid\",\n    \"requestedPickupAt\": \"2026-05-12T12:34:00\",\n    \"deliveryDeadlineAt\": \"2026-05-14T22:00:00\"\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.95\n}', NULL, 'success', NULL, 3938, 467, 131, '2026-03-20 21:56:38'),
('4124a042-296f-41f9-95f7-1a9ce06097e2', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- originAddressText\n- originContactName\n- originContactPhone\n- destinationAddressText\n- destinationContactName\n- destinationContactPhone\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: necesito una cuba de transorte para llevar leche desde Lleida a Morón de la frontera\nASSISTANT: He entendido producto: leche, origen: Lleida, destino: Morón de la frontera. Todavía necesito la cantidad, la fecha de recogida y el límite de entrega.\nUSER: serían 15000 litros para recoger el 12 de agosto a las 12:30 y llevarlo a Moron el día 13 antes de las 22:00\n\nMensaje:\nserían 15000 litros para recoger el 12 de agosto a las 12:30 y llevarlo a Moron el día 13 antes de las 22:00\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": 15000,\n    \"quantityUnit\": \"litros\",\n    \"originText\": null,\n    \"destinationText\": \"Moron\",\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": \"2024-08-12T12:30:00\",\n    \"deliveryDeadlineAt\": \"2024-08-13T22:00:00\"\n  },\n  \"missingFields\": [\n    \"product\",\n    \"origin\",\n    \"origin_address\",\n    \"origin_contact_name\",\n    \"origin_contact_phone\",\n    \"destination_address\",\n    \"destination_contact_name\",\n    \"destination_contact_phone\"\n  ],\n  \"nextBestQuestion\": \"¿Podrías indicarme qué producto se transporta, la dirección exacta y el contacto (nombre y teléfono) tanto del origen como del destino?\",\n  \"confidence\": 0.9\n}', NULL, 'success', NULL, 7484, 524, 249, '2026-03-21 12:53:56'),
('47d19559-e4b2-47fd-b130-744800bce512', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nASSISTANT: He entendido producto: leche, cantidad: 1200 litros, origen: Malaga, destino: madrid. Me faltan la fecha de recogida y el límite de entrega. ¿Me los indicas?\nUSER: recogida el 12/05/2026 para entregar antes de las 22:0 del 14/05/2026\nASSISTANT: He podido completar la solicitud, pero de momento no pasa validación.\nUSER: recogida el 12/05/2026 a las 12:34 para entregar antes de las 22:00 del 14/05/2026\nASSISTANT: He podido completar la solicitud, pero de momento no pasa validación.\nUSER: recogida el 12/05/2026 a las 12:34 para entregar antes de las 22:00 del 14/05/2026\nASSISTANT: He podido completar la solicitud, pero de momento no pasa validación.\nUSER: recogida el 12/05/2026 a las 12:34 para entregar antes de las 22:00 del 14/05/2026\n\nMensaje:\nrecogida el 12/05/2026 a las 12:34 para entregar antes de las 22:00 del 14/05/2026\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": \"2026-05-12T12:34:00\",\n    \"deliveryDeadlineAt\": \"2026-05-14T22:00:00\"\n  },\n  \"missingFields\": [\n    \"product\",\n    \"quantity\",\n    \"origin\",\n    \"destination\"\n  ],\n  \"nextBestQuestion\": \"¿Podrías indicarme el producto, la cantidad con unidad, el origen y el destino del transporte?\",\n  \"confidence\": 0.9\n}', NULL, 'success', NULL, 2602, 560, 160, '2026-03-20 21:58:32'),
('4c5b9757-ca5a-4d11-b63f-28355c30e281', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: quiero transportar 1200 litros de leche desde Malaga a madrid\nASSISTANT: He entendido producto: leche, cantidad: 1200 litros, origen: Malaga, destino: madrid. Me faltan la fecha de recogida y el límite de entrega. ¿Me los indicas?\nUSER: recogida el 12/05/2026 para entregar antes de las 22:0 del 14/05/2026\n\nMensaje:\nrecogida el 12/05/2026 para entregar antes de las 22:0 del 14/05/2026\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": \"2026-05-12T00:00:00\",\n    \"deliveryDeadlineAt\": \"2026-05-14T22:00:00\"\n  },\n  \"missingFields\": [\n    \"product\",\n    \"quantity\",\n    \"origin\",\n    \"destination\"\n  ],\n  \"nextBestQuestion\": \"¿Podrías confirmarme el producto, la cantidad con unidad, el origen y el destino del transporte?\",\n  \"confidence\": 0.9\n}', NULL, 'success', NULL, 4263, 407, 160, '2026-03-20 21:55:32'),
('4fe80f6b-7f03-4196-87a2-6cb86938be99', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- originAddressText\n- originContactName\n- originContactPhone\n- destinationAddressText\n- destinationContactName\n- destinationContactPhone\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: quiero transportar 1200 litros de leche\nASSISTANT: He entendido producto: leche, cantidad: 1200 litros. Todavía necesito el origen, el destino, la fecha de recogida y el límite de entrega.\nUSER: desde lleida hasta malaga\nASSISTANT: He entendido producto: leche, cantidad: 1200 litros, origen: lleida, destino: malaga. Me faltan la fecha de recogida y el límite de entrega. ¿Me los indicas?\nUSER: recogida el 12 de agosto a las 14:00 y entrega limite el 25 de octubre a las 12:00\n\nMensaje:\nrecogida el 12 de agosto a las 14:00 y entrega limite el 25 de octubre a las 12:00\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": \"leche\",\n    \"quantityValue\": 1200,\n    \"quantityUnit\": \"litros\",\n    \"originText\": \"lleida\",\n    \"destinationText\": \"malaga\",\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": \"2024-08-12T14:00:00\",\n    \"deliveryDeadlineAt\": \"2024-10-25T12:00:00\"\n  },\n  \"missingFields\": [\n    \"origin_address\",\n    \"origin_contact_name\",\n    \"origin_contact_phone\",\n    \"destination_address\",\n    \"destination_contact_name\",\n    \"destination_contact_phone\"\n  ],\n  \"nextBestQuestion\": \"¿Me puedes proporcionar las direcciones y los datos de contacto tanto del origen en Lleida como del destino en Málaga?\",\n  \"confidence\": 0.95\n}', NULL, 'success', NULL, 4295, 551, 238, '2026-03-21 14:50:20'),
('6164d261-3d72-4713-a9c6-51161edfc125', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: Necesito transportar 4000 litros de zumo\nASSISTANT: He entendido producto: zumo, cantidad: 4000 litros. Todavía necesito el origen, el destino, la fecha de recogida y el límite de entrega.\nUSER: desde Lleida\nASSISTANT: He entendido producto: zumo, cantidad: 4000 litros, origen: Lleida. Todavía necesito el destino, la fecha de recogida y el límite de entrega.\nUSER: a Málaga\n\nMensaje:\na Málaga\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": \"Málaga\",\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [\"product\",\"quantity\",\"origin\",\"requested_date\",\"delivery_deadline\"],\n  \"nextBestQuestion\": \"¿Podrías confirmarme el producto, la cantidad, el origen, la fecha de recogida y el límite de entrega, por favor?\",\n  \"confidence\": 0.9\n}', NULL, 'success', NULL, 3757, 393, 140, '2026-03-21 12:03:12'),
('69b3a2ec-50e6-4d98-b7d0-5b6e4390bfaa', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: Necesito transportar 4000 litros de zumo\nASSISTANT: He entendido producto: zumo, cantidad: 4000 litros. Todavía necesito el origen, el destino, la fecha de recogida y el límite de entrega.\nUSER: desde Lleida\n\nMensaje:\ndesde Lleida\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": \"zumo\",\n    \"quantityValue\": 4000,\n    \"quantityUnit\": \"litros\",\n    \"originText\": \"Lleida\",\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [\"destination\", \"requested_date\", \"delivery_deadline\"],\n  \"nextBestQuestion\": \"¿Cuál es el destino del transporte y qué fechas tienes para la recogida y la entrega?\",\n  \"confidence\": 0.9\n}', NULL, 'success', NULL, 3711, 349, 135, '2026-03-21 12:02:57'),
('6bd1f062-2716-44fa-b5c4-d7c5a3ea7fc8', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nASSISTANT: He podido completar la solicitud, pero de momento no pasa validación.\nUSER: recogida el 12/05/2026 a las 12:34 para entregar antes de las 22:00 del 14/05/2026\nASSISTANT: He podido completar la solicitud, pero de momento no pasa validación.\nUSER: recogida el 12/05/2026 a las 12:34 para entregar antes de las 22:00 del 14/05/2026\nASSISTANT: He podido completar la solicitud, pero de momento no pasa validación.\nUSER: recogida el 12/05/2026 a las 12:34 para entregar antes de las 22:00 del 14/05/2026\nASSISTANT: He podido completar la solicitud, pero hay un punto que impide validarla: No se ha podido normalizar el producto en catálogo para validar compatibilidad. ¿Puedes revisarlo?\nUSER: recogida el 12/05/2026 a las 12:34 para entregar antes de las 22:00 del 14/05/2026\n\nMensaje:\nrecogida el 12/05/2026 a las 12:34 para entregar antes de las 22:00 del 14/05/2026\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": \"2026-05-12T12:34:00\",\n    \"deliveryDeadlineAt\": \"2026-05-14T22:00:00\"\n  },\n  \"missingFields\": [\n    \"product\",\n    \"quantity\",\n    \"origin\",\n    \"destination\"\n  ],\n  \"nextBestQuestion\": \"¿Podrías indicarme qué producto se va a transportar, la cantidad y las ubicaciones de origen y destino?\",\n  \"confidence\": 0.9\n}', NULL, 'success', NULL, 3704, 561, 162, '2026-03-20 22:00:55'),
('6edc4161-ee4b-4489-9e38-676294376c73', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: quiero transportar 1200 litros de leche desde Malaga a Madrid\nASSISTANT: He entendido producto: leche, cantidad: 1200 litros, origen: Malaga, destino: Madrid. Me faltan la fecha de recogida y el límite de entrega. ¿Me los indicas?\nUSER: recogida el 12/05/2026 pra entregar antes de las 22:0 del 14/05/2026\n\nMensaje:\nrecogida el 12/05/2026 pra entregar antes de las 22:0 del 14/05/2026\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": \"2026-05-12T00:00:00\",\n    \"deliveryDeadlineAt\": \"2026-05-14T22:00:00\"\n  },\n  \"missingFields\": [\n    \"product\",\n    \"quantity\",\n    \"origin\",\n    \"destination\"\n  ],\n  \"nextBestQuestion\": \"¿Podrías confirmarme el producto, la cantidad, el origen y el destino para completar la información?\",\n  \"confidence\": 0.9\n}', NULL, 'success', NULL, 4288, 407, 160, '2026-03-20 21:49:06'),
('76c1b42a-20e7-4e66-9e2b-5063468a0fb0', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: Necesito transportar 4000 litros de zumo\nASSISTANT: He entendido producto: zumo, cantidad: 4000 litros. Todavía necesito el origen, el destino, la fecha de recogida y el límite de entrega.\nUSER: desde Lleida\nASSISTANT: He entendido producto: zumo, cantidad: 4000 litros, origen: Lleida. Todavía necesito el destino, la fecha de recogida y el límite de entrega.\nUSER: a Málaga\nASSISTANT: He entendido destino: Málaga. Me faltan la fecha de recogida y el límite de entrega. ¿Me los indicas?\nUSER: recogida el 24/05/2026 a las 21:34\n\nMensaje:\nrecogida el 24/05/2026 a las 21:34\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": \"zumo\",\n    \"quantityValue\": 4000,\n    \"quantityUnit\": \"litros\",\n    \"originText\": \"Lleida\",\n    \"destinationText\": \"Málaga\",\n    \"requestedPickupAt\": \"2026-05-24T21:34:00\",\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [\"delivery_deadline\"],\n  \"nextBestQuestion\": \"¿Cuál es el límite de entrega para el transporte del zumo desde Lleida a Málaga?\",\n  \"confidence\": 0.95\n}', NULL, 'success', NULL, 2573, 457, 142, '2026-03-21 12:03:48'),
('78ad9bf8-bd2d-4b28-b080-121671f63fc0', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- requestedPickupAt\n- deliveryDeadlineAt\n\nHistorial:\nUSER: becesito transportar 12000 litros de lehce de lleid a a malaga\nUSER: necesito transportar 1200 litros de lehce de lleid aa malaga\n\nMensaje:\nnecesito transportar 1200 litros de lehce de lleid aa malaga\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, 'OPENAI_PROVIDER_PLACEHOLDER [https://api.openai.com/v1]: Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- requestedPickupAt\n- deliveryDeadlineAt\n\nHistorial:\nUSER: becesito transportar 12000 litros de lehce de lleid a a malaga\nUSER: necesito transportar 1200 litros de lehce de lleid aa malaga\n\nMensaje:\nnecesito transportar 1200 litros de lehce de lleid aa malaga\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, 'success', NULL, 0, NULL, NULL, '2026-03-20 19:19:42');
INSERT INTO `tra_llm_actions` (`id`, `user_id`, `provider`, `model`, `action_type`, `input_text`, `input_json`, `output_text`, `output_json`, `status`, `error_message`, `latency_ms`, `tokens_input`, `tokens_output`, `created_at`) VALUES
('803ac71c-67c7-47f6-b3b3-2a44e196e145', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- originAddressText\n- originContactName\n- originContactPhone\n- destinationAddressText\n- destinationContactName\n- destinationContactPhone\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: quiero transportar 1200 litros de leche\nASSISTANT: He entendido producto: leche, cantidad: 1200 litros. Todavía necesito el origen, el destino, la fecha de recogida y el límite de entrega.\nUSER: desde lleida hasta malaga\nASSISTANT: He entendido producto: leche, cantidad: 1200 litros, origen: lleida, destino: malaga. Me faltan la fecha de recogida y el límite de entrega. ¿Me los indicas?\nUSER: recogida el 12 de agosto a las 14:00 y entrega limite el 25 de octubre a las 12:00\nASSISTANT: He podido completar la solicitud, pero hay varios puntos que impiden validarla: Necesito una dirección o punto de carga válido para el origen; No hay disponibilidad registrada de vehículos para esa fecha; Necesito una dirección o punto de entrega válido para el destino. ¿Puedes revisarlos?\nUSER: origen desde c/ master 23, 25006 LLeida y entrega en C/ Velazqueza 45 456789 Malaga\n\nMensaje:\norigen desde c/ master 23, 25006 LLeida y entrega en C/ Velazqueza 45 456789 Malaga\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": \"leche\",\n    \"quantityValue\": 1200,\n    \"quantityUnit\": \"litros\",\n    \"originText\": \"lleida\",\n    \"destinationText\": \"malaga\",\n    \"originAddressText\": \"c/ master 23, 25006 LLeida\",\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": \"C/ Velazqueza 45 456789 Malaga\",\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": \"2024-08-12T14:00:00\",\n    \"deliveryDeadlineAt\": \"2024-10-25T12:00:00\"\n  },\n  \"missingFields\": [\n    \"origin_contact_name\",\n    \"origin_contact_phone\",\n    \"destination_contact_name\",\n    \"destination_contact_phone\"\n  ],\n  \"nextBestQuestion\": \"¿Me puedes facilitar el nombre y teléfono de contacto tanto para el origen como para el destino?\",\n  \"confidence\": 0.9\n}', NULL, 'success', NULL, 3582, 646, 247, '2026-03-21 14:51:10'),
('846f6713-449f-44fb-8504-e615bc001424', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- requestedPickupAt\n- deliveryDeadlineAt\n\nHistorial:\nUSER: becesito transportar 12000 litros de lehce de lleid a a malaga\nUSER: necesito transportar 1200 litros de lehce de lleid aa malaga\nASSISTANT: Necesito algunos datos más para continuar con la solicitud.\nUSER: necesito transportar 1200 litros de lehce de lleid aa malaga\nASSISTANT: Todavía necesito el producto, la cantidad, el origen, el destino, la fecha de recogida y el límite de entrega.\nUSER: necesito transportar 1200 litros de leche de lleida a malaga\n\nMensaje:\nnecesito transportar 1200 litros de leche de lleida a malaga\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, 'OPENAI_PROVIDER_PLACEHOLDER [https://api.orrpenai.com/v1]: Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- requestedPickupAt\n- deliveryDeadlineAt\n\nHistorial:\nUSER: becesito transportar 12000 litros de lehce de lleid a a malaga\nUSER: necesito transportar 1200 litros de lehce de lleid aa malaga\nASSISTANT: Necesito algunos datos más para continuar con la solicitud.\nUSER: necesito transportar 1200 litros de lehce de lleid aa malaga\nASSISTANT: Todavía necesito el producto, la cantidad, el origen, el destino, la fecha de recogida y el límite de entrega.\nUSER: necesito transportar 1200 litros de leche de lleida a malaga\n\nMensaje:\nnecesito transportar 1200 litros de leche de lleida a malaga\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, 'success', NULL, 0, NULL, NULL, '2026-03-20 20:11:01'),
('87d39c1f-acb9-4f52-ba5c-7a070cd48ae2', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: Necesito transportar 4000 litros de zumo\n\nMensaje:\nNecesito transportar 4000 litros de zumo\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": \"zumo\",\n    \"quantityValue\": 4000,\n    \"quantityUnit\": \"litros\",\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [\"origin\", \"destination\", \"requested_date\", \"delivery_deadline\"],\n  \"nextBestQuestion\": \"¿Desde dónde y hacia dónde quieres transportar los 4000 litros de zumo, y en qué fechas necesitas la recogida y la entrega?\",\n  \"confidence\": 0.9\n}', NULL, 'success', NULL, 3821, 312, 145, '2026-03-21 12:02:35'),
('99426d8b-483f-4895-a5a3-c6738af274ee', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- originAddressText\n- originContactName\n- originContactPhone\n- destinationAddressText\n- destinationContactName\n- destinationContactPhone\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: Necesito transportar 4000 litros de zumo\nASSISTANT: Aviso: el producto indicado no está en el catálogo. He entendido producto: zumo, cantidad: 4000 litros. Antes de seguir, necesito que indiques un producto que esté en el catálogo. ¿Puedes decirme otro producto? Si prefieres, puedo pasar tu solicitud a ventas.\nUSER: pasa la solicitud a ventas\n\nMensaje:\npasa la solicitud a ventas\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [\n    \"product\",\n    \"quantity\",\n    \"origin\",\n    \"destination\",\n    \"origin_address\",\n    \"origin_contact_name\",\n    \"origin_contact_phone\",\n    \"destination_address\",\n    \"destination_contact_name\",\n    \"destination_contact_phone\",\n    \"requested_date\",\n    \"delivery_deadline\"\n  ],\n  \"nextBestQuestion\": \"¿Podrías proporcionarme los detalles del producto, cantidad, origen, destino, direcciones y contactos, así como las fechas de recogida y entrega para poder pasar la solicitud a ventas?\",\n  \"confidence\": 0.1\n}', NULL, 'success', NULL, 4767, 480, 246, '2026-03-21 12:19:31'),
('9b6a142f-f08a-4d72-bae5-fe4a7603f03f', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- originAddressText\n- originContactName\n- originContactPhone\n- destinationAddressText\n- destinationContactName\n- destinationContactPhone\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: quiero transportar 1200 litros de leche\n\nMensaje:\nquiero transportar 1200 litros de leche\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": \"leche\",\n    \"quantityValue\": 1200,\n    \"quantityUnit\": \"litros\",\n    \"originText\": null,\n    \"destinationText\": null,\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [\n    \"origin\",\n    \"destination\",\n    \"origin_address\",\n    \"origin_contact_name\",\n    \"origin_contact_phone\",\n    \"destination_address\",\n    \"destination_contact_name\",\n    \"destination_contact_phone\",\n    \"requested_date\",\n    \"delivery_deadline\"\n  ],\n  \"nextBestQuestion\": \"¿Podrías indicarme el lugar de origen y destino, así como las direcciones y los contactos con teléfono para ambos puntos, además de las fechas de recogida y entrega?\",\n  \"confidence\": 0.8\n}', NULL, 'success', NULL, 4311, 409, 242, '2026-03-21 14:49:43'),
('accd493c-db88-4081-9927-0a0b89703c86', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: necesito transportar 1200 litros de leche desde Malaga a Gijon\nASSISTANT: He entendido producto: leche, cantidad: 1200 litros, origen: Malaga, destino: Gijon. Me faltan la fecha de recogida y el límite de entrega. ¿Me los indicas?\nUSER: el 12 de mayo a las 14:00, como limite el mismo día a las 22:00\n\nMensaje:\nel 12 de mayo a las 14:00, como limite el mismo día a las 22:00\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": \"leche\",\n    \"quantityValue\": 1200,\n    \"quantityUnit\": \"litros\",\n    \"originText\": \"Malaga\",\n    \"destinationText\": \"Gijon\",\n    \"requestedPickupAt\": \"2024-05-12T14:00:00+02:00\",\n    \"deliveryDeadlineAt\": \"2024-05-12T22:00:00+02:00\"\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.95\n}', NULL, 'success', NULL, 2308, 402, 140, '2026-03-20 20:32:25'),
('b3782e69-167c-4846-a449-36077f86c498', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- originAddressText\n- originContactName\n- originContactPhone\n- destinationAddressText\n- destinationContactName\n- destinationContactPhone\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: necesito una cuba de transorte para llevar leche desde Lleida a Morón de la frontera\n\nMensaje:\nnecesito una cuba de transorte para llevar leche desde Lleida a Morón de la frontera\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": \"leche\",\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": \"Lleida\",\n    \"destinationText\": \"Morón de la frontera\",\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [\n    \"quantity\",\n    \"origin_address\",\n    \"origin_contact_name\",\n    \"origin_contact_phone\",\n    \"destination_address\",\n    \"destination_contact_name\",\n    \"destination_contact_phone\",\n    \"requested_date\",\n    \"delivery_deadline\"\n  ],\n  \"nextBestQuestion\": \"¿Podrías indicarme la cantidad y unidad del producto, las direcciones completas de origen y destino, los nombres y teléfonos de contacto en ambos lugares, así como las fechas de recogida y entrega?\",\n  \"confidence\": 0.8\n}', NULL, 'success', NULL, 5622, 430, 247, '2026-03-21 12:45:21'),
('b8f1efab-c874-4c79-92e5-428bacaaa9be', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- originAddressText\n- originContactName\n- originContactPhone\n- destinationAddressText\n- destinationContactName\n- destinationContactPhone\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: csdcw\n\nMensaje:\ncsdcw\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [\n    \"product\",\n    \"quantity\",\n    \"origin\",\n    \"destination\",\n    \"origin_address\",\n    \"origin_contact_name\",\n    \"origin_contact_phone\",\n    \"destination_address\",\n    \"destination_contact_name\",\n    \"destination_contact_phone\",\n    \"requested_date\",\n    \"delivery_deadline\"\n  ],\n  \"nextBestQuestion\": \"¿Podrías proporcionarme el producto, la cantidad con unidad, los lugares de origen y destino, las direcciones y contactos de ambos, así como las fechas de recogida y entrega?\",\n  \"confidence\": 0.0\n}', NULL, 'success', NULL, 3700, 398, 246, '2026-03-21 12:32:37'),
('bd2db7b9-2108-44dc-a91f-ade64d802ebb', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: necesito transportar 1200 litros de leche desde Malaga a Gijon\n\nMensaje:\nnecesito transportar 1200 litros de leche desde Malaga a Gijon\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": \"leche\",\n    \"quantityValue\": 1200,\n    \"quantityUnit\": \"litros\",\n    \"originText\": \"Malaga\",\n    \"destinationText\": \"Gijon\",\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [\n    \"requested_date\",\n    \"delivery_deadline\"\n  ],\n  \"nextBestQuestion\": \"¿Para qué fecha necesitas la recogida y cuál es el plazo máximo para la entrega?\",\n  \"confidence\": 0.9\n}', NULL, 'success', NULL, 3919, 322, 138, '2026-03-20 20:31:38'),
('d27bae80-92e2-48aa-a5d8-856f471caeae', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: quiero transportar 1200 litros de leche desde Malaga a madrid\nASSISTANT: He entendido producto: leche, cantidad: 1200 litros, origen: Malaga, destino: madrid. Me faltan la fecha de recogida y el límite de entrega. ¿Me los indicas?\nUSER: recogida el 12/05/2026 para entregar antes de las 22:0 del 14/05/2026\nASSISTANT: He podido completar la solicitud, pero de momento no pasa validación.\nUSER: recogida el 12/05/2026 a las 12:34 para entregar antes de las 22:00 del 14/05/2026\nASSISTANT: He podido completar la solicitud, pero de momento no pasa validación.\nUSER: recogida el 12/05/2026 a las 12:34 para entregar antes de las 22:00 del 14/05/2026\n\nMensaje:\nrecogida el 12/05/2026 a las 12:34 para entregar antes de las 22:00 del 14/05/2026\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": \"2026-05-12T12:34:00\",\n    \"deliveryDeadlineAt\": \"2026-05-14T22:00:00\"\n  },\n  \"missingFields\": [\n    \"product\",\n    \"quantity\",\n    \"origin\",\n    \"destination\"\n  ],\n  \"nextBestQuestion\": \"¿Podrías confirmarme qué producto quieres transportar, la cantidad exacta con unidad, y los lugares de origen y destino?\",\n  \"confidence\": 0.9\n}', NULL, 'success', NULL, 5407, 521, 164, '2026-03-20 21:58:14'),
('de3fd83b-2737-4da7-b57e-f51cb9f9d0eb', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: quiero transportar 1200 litros de leche desde Malaga a Madrid\n\nMensaje:\nquiero transportar 1200 litros de leche desde Malaga a Madrid\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": \"leche\",\n    \"quantityValue\": 1200,\n    \"quantityUnit\": \"litros\",\n    \"originText\": \"Malaga\",\n    \"destinationText\": \"Madrid\",\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [\"requested_date\", \"delivery_deadline\"],\n  \"nextBestQuestion\": \"¿Para qué fecha necesitas que recojamos la leche y cuál es la fecha límite de entrega?\",\n  \"confidence\": 0.9\n}', NULL, 'success', NULL, 4395, 317, 133, '2026-03-20 21:48:18'),
('e0d99771-a6d0-49b0-a6f9-df144cae6c09', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nASSISTANT: He entendido producto: zumo, cantidad: 4000 litros. Todavía necesito el origen, el destino, la fecha de recogida y el límite de entrega.\nUSER: desde Lleida\nASSISTANT: He entendido producto: zumo, cantidad: 4000 litros, origen: Lleida. Todavía necesito el destino, la fecha de recogida y el límite de entrega.\nUSER: a Málaga\nASSISTANT: He entendido destino: Málaga. Me faltan la fecha de recogida y el límite de entrega. ¿Me los indicas?\nUSER: recogida el 24/05/2026 a las 21:34\nASSISTANT: He entendido producto: zumo, cantidad: 4000 litros, origen: Lleida, destino: Málaga, fecha de recogida: 2026-05-24T21:34:00. Me falta el límite de entrega.\nUSER: lmite de enrega el día 4 de Agosto a las 12:00\n\nMensaje:\nlmite de enrega el día 4 de Agosto a las 12:00\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": \"zumo\",\n    \"quantityValue\": 4000,\n    \"quantityUnit\": \"litros\",\n    \"originText\": \"Lleida\",\n    \"destinationText\": \"Málaga\",\n    \"requestedPickupAt\": \"2026-05-24T21:34:00\",\n    \"deliveryDeadlineAt\": \"2026-08-04T12:00:00\"\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.95\n}', NULL, 'success', NULL, 2178, 517, 132, '2026-03-21 12:04:12'),
('ed5a17a2-4878-41c8-b5ba-6e26442ac245', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- originAddressText\n- originContactName\n- originContactPhone\n- destinationAddressText\n- destinationContactName\n- destinationContactPhone\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: necesito una cuba de transorte para llevar leche desde Lleida a Morón de la frontera\nASSISTANT: He entendido producto: leche, origen: Lleida, destino: Morón de la frontera. Todavía necesito la cantidad, la fecha de recogida y el límite de entrega.\nUSER: serían 15000 litros para recoger el 12 de agosto a las 12:30 y llevarlo a Moron el día 13 antes de las 22:00\n\nMensaje:\nserían 15000 litros para recoger el 12 de agosto a las 12:30 y llevarlo a Moron el día 13 antes de las 22:00\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": \"leche\",\n    \"quantityValue\": 15000,\n    \"quantityUnit\": \"litros\",\n    \"originText\": \"Lleida\",\n    \"destinationText\": \"Morón de la frontera\",\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": \"2024-08-12T12:30:00\",\n    \"deliveryDeadlineAt\": \"2024-08-13T22:00:00\"\n  },\n  \"missingFields\": [\n    \"origin_address\",\n    \"origin_contact_name\",\n    \"origin_contact_phone\",\n    \"destination_address\",\n    \"destination_contact_name\",\n    \"destination_contact_phone\"\n  ],\n  \"nextBestQuestion\": \"¿Podrías proporcionarme la dirección y el contacto (nombre y teléfono) tanto del origen en Lleida como del destino en Morón de la frontera?\",\n  \"confidence\": 0.95\n}', NULL, 'success', NULL, 3814, 524, 250, '2026-03-21 12:46:12'),
('f1f1b0a5-b3d3-49ec-aef8-5b0ae6618bab', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: quiero transportar 1200 litros de leche desde Malaga a madrid\n\nMensaje:\nquiero transportar 1200 litros de leche desde Malaga a madrid\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": \"leche\",\n    \"quantityValue\": 1200,\n    \"quantityUnit\": \"litros\",\n    \"originText\": \"Malaga\",\n    \"destinationText\": \"madrid\",\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [\"requested_date\", \"delivery_deadline\"],\n  \"nextBestQuestion\": \"¿Para qué fecha necesitas que recojamos la leche y cuál es la fecha límite de entrega?\",\n  \"confidence\": 0.9\n}', NULL, 'success', NULL, 3999, 317, 134, '2026-03-20 21:55:19'),
('ff798b64-eb8c-4a28-b0be-e72e18848086', 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'openai', 'gpt-4.1-mini-2025-04-14', 'wizard_data_extraction', 'Eres un extractor de datos para un wizard de transporte de líquidos.\n\nDebes devolver EXCLUSIVAMENTE JSON válido.\n\n\npor cierto, en adelante usarás yarn para las instalaciones, no npm\n\nExtrae estos campos:\n- productText\n- quantityValue\n- quantityUnit\n- originText\n- destinationText\n- originAddressText\n- originContactName\n- originContactPhone\n- destinationAddressText\n- destinationContactName\n- destinationContactPhone\n- requestedPickupAt\n- deliveryDeadlineAt\n\nReglas:\n- Si un dato no aparece, usa null.\n- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.\n- missingFields debe incluir solo:\n  [\"product\",\"quantity\",\"origin\",\"destination\",\"origin_address\",\"origin_contact_name\",\"origin_contact_phone\",\"destination_address\",\"destination_contact_name\",\"destination_contact_phone\",\"requested_date\",\"delivery_deadline\"]\n- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.\n- confidence debe ser un número entre 0 y 1.\n\nHistorial:\nUSER: quiero transportar 1200 litros de leche\nASSISTANT: He entendido producto: leche, cantidad: 1200 litros. Todavía necesito el origen, el destino, la fecha de recogida y el límite de entrega.\nUSER: desde lleida hasta malaga\n\nMensaje:\ndesde lleida hasta malaga\n\nFormato:\n{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": null,\n    \"quantityValue\": null,\n    \"quantityUnit\": null,\n    \"originText\": null,\n    \"destinationText\": null,\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [],\n  \"nextBestQuestion\": null,\n  \"confidence\": 0.0\n}', NULL, '{\n  \"intent\": \"create_or_update_quote_request\",\n  \"extractedFields\": {\n    \"productText\": \"leche\",\n    \"quantityValue\": 1200,\n    \"quantityUnit\": \"litros\",\n    \"originText\": \"lleida\",\n    \"destinationText\": \"malaga\",\n    \"originAddressText\": null,\n    \"originContactName\": null,\n    \"originContactPhone\": null,\n    \"destinationAddressText\": null,\n    \"destinationContactName\": null,\n    \"destinationContactPhone\": null,\n    \"requestedPickupAt\": null,\n    \"deliveryDeadlineAt\": null\n  },\n  \"missingFields\": [\n    \"origin_address\",\n    \"origin_contact_name\",\n    \"origin_contact_phone\",\n    \"destination_address\",\n    \"destination_contact_name\",\n    \"destination_contact_phone\",\n    \"requested_date\",\n    \"delivery_deadline\"\n  ],\n  \"nextBestQuestion\": \"¿Podrías proporcionarme la dirección exacta y el contacto (nombre y teléfono) tanto del origen en Lleida como del destino en Málaga, además de la fecha y hora solicitadas para la recogida y el límite de entrega?\",\n  \"confidence\": 0.9\n}', NULL, 'success', NULL, 2578, 452, 249, '2026-03-21 14:49:54');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_loading_points`
--

CREATE TABLE `tra_loading_points` (
  `loading_point_id` char(36) NOT NULL COMMENT 'Identificador del punto de carga',
  `client_id` char(36) DEFAULT NULL COMMENT 'Cliente asociado al punto',
  `point_code` varchar(30) NOT NULL COMMENT 'Código del punto',
  `point_name` varchar(150) NOT NULL COMMENT 'Nombre del centro/planta',
  `country_code` char(2) NOT NULL COMMENT 'País',
  `postal_code` varchar(15) DEFAULT NULL COMMENT 'Código postal',
  `city` varchar(100) NOT NULL COMMENT 'Ciudad',
  `address_line1` varchar(200) NOT NULL COMMENT 'Dirección',
  `latitude` decimal(9,6) DEFAULT NULL COMMENT 'Latitud',
  `longitude` decimal(9,6) DEFAULT NULL COMMENT 'Longitud',
  `loading_window_start` time DEFAULT NULL COMMENT 'Inicio de ventana típica',
  `loading_window_end` time DEFAULT NULL COMMENT 'Fin de ventana típica',
  `loading_days_mask` varchar(20) DEFAULT NULL COMMENT 'Días operables',
  `requires_prealert` tinyint(1) NOT NULL COMMENT 'Requiere preaviso',
  `access_restrictions` text DEFAULT NULL COMMENT 'Restricciones físicas/documentales',
  `allowed_vehicle_types` varchar(100) DEFAULT NULL COMMENT 'Tipos de vehículo admitidos',
  `default_contact_id` char(36) DEFAULT NULL COMMENT 'Contacto por defecto',
  `active` tinyint(1) NOT NULL COMMENT 'Punto activo',
  `notes` text DEFAULT NULL COMMENT 'Observaciones'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_loading_points';

--
-- Volcado de datos para la tabla `tra_loading_points`
--

INSERT INTO `tra_loading_points` (`loading_point_id`, `client_id`, `point_code`, `point_name`, `country_code`, `postal_code`, `city`, `address_line1`, `latitude`, `longitude`, `loading_window_start`, `loading_window_end`, `loading_days_mask`, `requires_prealert`, `access_restrictions`, `allowed_vehicle_types`, `default_contact_id`, `active`, `notes`) VALUES
('d3a7660a-2515-11f1-8370-5a0d05a37ed2', NULL, 'MAL-PLANTA', 'Planta Málaga', 'ES', '29001', 'Málaga', 'Málaga', 36.721300, -4.421400, NULL, NULL, NULL, 0, NULL, 'CISTERNA, CISTERNA_FOOD', NULL, 1, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_orders`
--

CREATE TABLE `tra_orders` (
  `order_id` char(36) NOT NULL COMMENT 'Identificador del pedido',
  `order_number` varchar(40) NOT NULL COMMENT 'Número de pedido',
  `client_id` char(36) NOT NULL COMMENT 'Cliente del pedido',
  `quote_id` char(36) DEFAULT NULL COMMENT 'Presupuesto origen',
  `product_id` char(36) NOT NULL COMMENT 'Producto solicitado',
  `category_id` char(36) NOT NULL COMMENT 'Categoría del pedido',
  `origin_loading_point_id` char(36) NOT NULL COMMENT 'Origen',
  `destination_unloading_point_id` char(36) NOT NULL COMMENT 'Destino',
  `requested_pickup_datetime` timestamp NULL DEFAULT NULL COMMENT 'Carga solicitada',
  `requested_delivery_datetime` timestamp NULL DEFAULT NULL COMMENT 'Entrega solicitada',
  `confirmed_pickup_datetime` timestamp NULL DEFAULT NULL COMMENT 'Carga confirmada',
  `confirmed_delivery_datetime` timestamp NULL DEFAULT NULL COMMENT 'Entrega confirmada',
  `ordered_volume_liters` int(11) NOT NULL COMMENT 'Volumen pedido',
  `ordered_weight_tn` decimal(5,2) DEFAULT NULL COMMENT 'Peso pedido',
  `service_mode` varchar(20) NOT NULL COMMENT 'Modo de servicio',
  `order_status` varchar(20) NOT NULL COMMENT 'Estado del pedido',
  `priority_level` varchar(20) DEFAULT NULL COMMENT 'Prioridad',
  `client_reference` varchar(80) DEFAULT NULL COMMENT 'Referencia de cliente',
  `internal_notes` text DEFAULT NULL COMMENT 'Notas internas',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_orders';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_order_stops`
--

CREATE TABLE `tra_order_stops` (
  `order_stop_id` char(36) NOT NULL COMMENT 'Identificador de parada',
  `order_id` char(36) NOT NULL COMMENT 'Pedido asociado',
  `sequence_no` int(11) NOT NULL COMMENT 'Orden de parada',
  `stop_type` varchar(20) NOT NULL COMMENT 'Tipo de parada',
  `loading_point_id` char(36) DEFAULT NULL COMMENT 'Punto de carga si aplica',
  `unloading_point_id` char(36) DEFAULT NULL COMMENT 'Punto de descarga si aplica',
  `depot_location_text` varchar(150) DEFAULT NULL COMMENT 'Ubicación de depósito/lavado',
  `planned_arrival` timestamp NULL DEFAULT NULL COMMENT 'Llegada planificada',
  `planned_departure` timestamp NULL DEFAULT NULL COMMENT 'Salida planificada',
  `actual_arrival` timestamp NULL DEFAULT NULL COMMENT 'Llegada real',
  `actual_departure` timestamp NULL DEFAULT NULL COMMENT 'Salida real',
  `window_start` timestamp NULL DEFAULT NULL COMMENT 'Inicio de ventana',
  `window_end` timestamp NULL DEFAULT NULL COMMENT 'Fin de ventana',
  `dwell_time_minutes` int(11) DEFAULT NULL COMMENT 'Tiempo de estancia',
  `stop_notes` text DEFAULT NULL COMMENT 'Observaciones'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_order_stops';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_price_rules`
--

CREATE TABLE `tra_price_rules` (
  `price_rule_id` char(36) NOT NULL COMMENT 'Identificador de regla tarifaria',
  `rule_code` varchar(40) NOT NULL COMMENT 'Código de regla',
  `category_id` char(36) NOT NULL COMMENT 'Categoría aplicable',
  `origin_country_code` char(2) NOT NULL COMMENT 'País origen',
  `destination_country_code` char(2) NOT NULL COMMENT 'País destino',
  `mode` varchar(20) NOT NULL COMMENT 'Modo de servicio',
  `distance_from_km` int(11) NOT NULL COMMENT 'Tramo km inicial',
  `distance_to_km` int(11) NOT NULL COMMENT 'Tramo km final',
  `base_price_eur` decimal(10,2) NOT NULL COMMENT 'Tarifa base',
  `price_per_km_eur` decimal(10,4) DEFAULT NULL COMMENT 'Tarifa variable por km',
  `min_charge_eur` decimal(10,2) DEFAULT NULL COMMENT 'Mínimo facturable',
  `fuel_surcharge_pct` decimal(5,2) DEFAULT NULL COMMENT 'Recargo combustible',
  `heating_surcharge_eur` decimal(10,2) DEFAULT NULL COMMENT 'Recargo calefacción',
  `adr_surcharge_eur` decimal(10,2) DEFAULT NULL COMMENT 'Recargo ADR',
  `cleaning_surcharge_eur` decimal(10,2) DEFAULT NULL COMMENT 'Recargo lavado',
  `urgent_service_surcharge_pct` decimal(5,2) DEFAULT NULL COMMENT 'Recargo urgencia',
  `weekend_surcharge_pct` decimal(5,2) DEFAULT NULL COMMENT 'Recargo fin de semana',
  `intermodal_adjustment_eur` decimal(10,2) DEFAULT NULL COMMENT 'Ajuste intermodal',
  `active` tinyint(1) NOT NULL COMMENT 'Regla activa',
  `valid_from` date DEFAULT NULL COMMENT 'Inicio de vigencia',
  `valid_to` date DEFAULT NULL COMMENT 'Fin de vigencia',
  `notes` text DEFAULT NULL COMMENT 'Observaciones'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_price_rules';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_products`
--

CREATE TABLE `tra_products` (
  `product_id` char(36) NOT NULL COMMENT 'Identificador de producto',
  `product_code` varchar(30) NOT NULL COMMENT 'Código interno',
  `product_name` varchar(120) NOT NULL COMMENT 'Nombre del producto',
  `commercial_name` varchar(120) DEFAULT NULL COMMENT 'Nombre comercial',
  `category_id` char(36) NOT NULL COMMENT 'Categoría del producto',
  `density_kg_l` decimal(5,3) DEFAULT NULL COMMENT 'Densidad estimada',
  `adr_required` tinyint(1) NOT NULL COMMENT 'Requiere ADR',
  `adr_class` varchar(20) DEFAULT NULL COMMENT 'Clase ADR si aplica',
  `food_grade_required` tinyint(1) NOT NULL COMMENT 'Exige food grade',
  `feed_grade_required` tinyint(1) NOT NULL COMMENT 'Exige feed grade',
  `sandach_required` tinyint(1) NOT NULL COMMENT 'Exige SANDACH',
  `temperature_min_c` decimal(4,1) DEFAULT NULL COMMENT 'Temperatura mínima',
  `temperature_max_c` decimal(4,1) DEFAULT NULL COMMENT 'Temperatura máxima',
  `needs_heating` tinyint(1) NOT NULL COMMENT 'Requiere calefacción',
  `needs_cooling` tinyint(1) NOT NULL COMMENT 'Requiere refrigeración',
  `needs_bacteriological_filter` tinyint(1) NOT NULL COMMENT 'Requiere filtro bacteriológico',
  `viscosity_level` varchar(20) DEFAULT NULL COMMENT 'Nivel de viscosidad',
  `cleaning_level_required` varchar(30) DEFAULT NULL COMMENT 'Nivel de lavado exigido',
  `discharge_type_required` varchar(30) DEFAULT NULL COMMENT 'Tipo de descarga requerido',
  `default_max_transport_hours` int(11) DEFAULT NULL COMMENT 'Máx. horas recomendadas de transporte',
  `active` tinyint(1) NOT NULL COMMENT 'Producto activo',
  `notes` text DEFAULT NULL COMMENT 'Notas operativas'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_products';

--
-- Volcado de datos para la tabla `tra_products`
--

INSERT INTO `tra_products` (`product_id`, `product_code`, `product_name`, `commercial_name`, `category_id`, `density_kg_l`, `adr_required`, `adr_class`, `food_grade_required`, `feed_grade_required`, `sandach_required`, `temperature_min_c`, `temperature_max_c`, `needs_heating`, `needs_cooling`, `needs_bacteriological_filter`, `viscosity_level`, `cleaning_level_required`, `discharge_type_required`, `default_max_transport_hours`, `active`, `notes`) VALUES
('d865c108-249f-11f1-9638-5a0d05a37ed3', 'MILK', 'Leche', 'Leche', 'd85cc936-249f-11f1-9638-5a0d05a37ed3', NULL, 0, NULL, 1, 0, 0, 2.0, 6.0, 0, 1, 1, NULL, NULL, NULL, 24, 1, 'Producto alimentario: requiere frío y filtro bacteriológico');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_product_categories`
--

CREATE TABLE `tra_product_categories` (
  `category_id` char(36) NOT NULL COMMENT 'Identificador de categoría',
  `category_code` varchar(30) NOT NULL COMMENT 'Código de categoría',
  `category_name` varchar(80) NOT NULL COMMENT 'Nombre de categoría',
  `description` text DEFAULT NULL COMMENT 'Descripción funcional',
  `requires_food_grade` tinyint(1) NOT NULL COMMENT 'Exige tanque/grado alimentario',
  `requires_feed_grade` tinyint(1) NOT NULL COMMENT 'Exige control feed',
  `requires_sandach` tinyint(1) NOT NULL COMMENT 'Exige certificación SANDACH',
  `requires_adr` tinyint(1) NOT NULL COMMENT 'Exige ADR',
  `default_cleaning_level` varchar(30) DEFAULT NULL COMMENT 'Nivel de lavado por defecto',
  `allows_intermodal` tinyint(1) NOT NULL COMMENT 'Se permite servicio intermodal',
  `active` tinyint(1) NOT NULL COMMENT 'Categoría activa',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha de alta',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_product_categories';

--
-- Volcado de datos para la tabla `tra_product_categories`
--

INSERT INTO `tra_product_categories` (`category_id`, `category_code`, `category_name`, `description`, `requires_food_grade`, `requires_feed_grade`, `requires_sandach`, `requires_adr`, `default_cleaning_level`, `allows_intermodal`, `active`, `created_at`, `updated_at`) VALUES
('d85cc936-249f-11f1-9638-5a0d05a37ed3', 'LACTEOS', 'Lácteos', NULL, 1, 0, 0, 0, 'food', 1, 1, '2026-03-20 21:00:37', '2026-03-20 21:00:37');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_product_compatibility_rules`
--

CREATE TABLE `tra_product_compatibility_rules` (
  `compatibility_rule_id` char(36) NOT NULL COMMENT 'Identificador de compatibilidad',
  `previous_product_id` char(36) DEFAULT NULL COMMENT 'Producto anterior',
  `next_product_id` char(36) DEFAULT NULL COMMENT 'Producto siguiente',
  `previous_category_id` char(36) DEFAULT NULL COMMENT 'Categoría anterior',
  `next_category_id` char(36) DEFAULT NULL COMMENT 'Categoría siguiente',
  `cleaning_required` tinyint(1) NOT NULL COMMENT 'Exige limpieza intermedia',
  `required_cleaning_type` varchar(30) DEFAULT NULL COMMENT 'Tipo de lavado exigido',
  `cooling_or_heating_reset_required` tinyint(1) NOT NULL COMMENT 'Exige reset térmico',
  `bacteriological_filter_required` tinyint(1) NOT NULL COMMENT 'Exige filtro bacteriológico',
  `compatibility_status` varchar(20) NOT NULL COMMENT 'Compatible / condicional / no compatible',
  `rationale` text DEFAULT NULL COMMENT 'Motivo de la regla',
  `active` tinyint(1) NOT NULL COMMENT 'Regla activa',
  `valid_from` date DEFAULT NULL COMMENT 'Inicio de vigencia',
  `valid_to` date DEFAULT NULL COMMENT 'Fin de vigencia'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_product_compatibility_rules';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_prompt_templates`
--

CREATE TABLE `tra_prompt_templates` (
  `prompt_template_id` char(36) NOT NULL COMMENT 'Identificador del prompt',
  `wizard_step_id` char(36) DEFAULT NULL COMMENT 'Paso asociado si aplica',
  `prompt_code` varchar(60) NOT NULL COMMENT 'Código del prompt',
  `prompt_scope` varchar(20) NOT NULL COMMENT 'Ámbito: system, step, validation, recommendation',
  `prompt_title` varchar(120) NOT NULL COMMENT 'Nombre descriptivo',
  `prompt_text` longtext NOT NULL COMMENT 'Texto del prompt parametrizable',
  `version_no` int(11) NOT NULL COMMENT 'Versión del prompt',
  `active` tinyint(1) NOT NULL COMMENT 'Prompt activo',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_prompt_templates';

--
-- Volcado de datos para la tabla `tra_prompt_templates`
--

INSERT INTO `tra_prompt_templates` (`prompt_template_id`, `wizard_step_id`, `prompt_code`, `prompt_scope`, `prompt_title`, `prompt_text`, `version_no`, `active`, `created_at`, `updated_at`) VALUES
('00000000-0000-0000-0000-000000000201', NULL, 'wizard_system_v1', 'system', 'Prompt sistema wizard', 'Eres el asistente conversacional de transporte. Tu objetivo es interpretar lenguaje natural, completar el wizard paso a paso, normalizar entidades contra catálogos y proponer la mejor opción operativa disponible. Nunca inventes compatibilidades: consulta reglas, validaciones y catálogos antes de recomendar o emitir presupuesto.', 1, 1, '2026-03-20 10:15:11', '2026-03-20 10:15:11'),
('00000000-0000-0000-0000-000000000202', NULL, 'wizard_step_generic_v1', 'step', 'Prompt genérico de paso', 'Fase {{step_label}}. Formula una sola pregunta clara para obtener el dato que falta. Si ya existe una respuesta válida en la sesión, confirma brevemente y avanza. Si la respuesta del usuario es ambigua, propone 2-4 opciones normalizadas cuando existan en catálogo.', 1, 1, '2026-03-20 10:15:11', '2026-03-20 10:15:11'),
('00000000-0000-0000-0000-000000000203', NULL, 'wizard_validation_v1', 'validation', 'Prompt validación', 'Valida la solicitud con las reglas de negocio y devuelve un resumen trazable: qué regla se evaluó, si bloquea o no, qué dato falta y qué siguiente acción debe ejecutarse.', 1, 1, '2026-03-20 10:15:11', '2026-03-20 10:15:11'),
('00000000-0000-0000-0000-000000000204', NULL, 'wizard_recommendation_v1', 'recommendation', 'Prompt recomendación', 'Con toda la información disponible, recomienda la mejor opción de presupuesto o servicio. Explica viabilidad, riesgos, restricciones, nivel de confianza y si hace falta revisión humana.', 1, 1, '2026-03-20 10:15:11', '2026-03-20 10:15:11');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_quotes`
--

CREATE TABLE `tra_quotes` (
  `quote_id` char(36) NOT NULL COMMENT 'Identificador de presupuesto',
  `quote_request_id` char(36) NOT NULL COMMENT 'Solicitud origen',
  `quote_number` varchar(40) NOT NULL COMMENT 'Número de presupuesto',
  `feasibility_status` varchar(20) NOT NULL COMMENT 'Viabilidad',
  `estimated_price_eur` decimal(10,2) DEFAULT NULL COMMENT 'Precio estimado',
  `currency_code` char(3) NOT NULL COMMENT 'Moneda',
  `confidence_level_pct` decimal(5,2) DEFAULT NULL COMMENT 'Confianza del cálculo',
  `needs_manual_review` tinyint(1) NOT NULL COMMENT 'Exige revisión humana',
  `valid_until` date DEFAULT NULL COMMENT 'Validez del presupuesto',
  `generated_reasoning` text DEFAULT NULL COMMENT 'Explicación generada',
  `sales_owner` varchar(120) DEFAULT NULL COMMENT 'Comercial responsable',
  `quote_status` varchar(20) NOT NULL COMMENT 'Estado comercial',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_quotes';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_quote_requests`
--

CREATE TABLE `tra_quote_requests` (
  `quote_request_id` char(36) NOT NULL COMMENT 'Identificador de solicitud',
  `external_reference` varchar(50) DEFAULT NULL COMMENT 'Referencia externa',
  `source_channel` varchar(20) NOT NULL COMMENT 'Canal de origen',
  `client_id` char(36) DEFAULT NULL COMMENT 'Cliente conocido si existe',
  `requester_name` varchar(150) DEFAULT NULL COMMENT 'Nombre del solicitante',
  `requester_email` varchar(150) DEFAULT NULL COMMENT 'Email del solicitante',
  `requester_phone` varchar(40) DEFAULT NULL COMMENT 'Teléfono del solicitante',
  `requested_product_text` varchar(150) NOT NULL COMMENT 'Texto libre de producto',
  `requested_product_id` char(36) DEFAULT NULL COMMENT 'Producto normalizado si se resuelve',
  `requested_category_id` char(36) DEFAULT NULL COMMENT 'Categoría inferida',
  `requested_volume_liters` int(11) DEFAULT NULL COMMENT 'Volumen solicitado',
  `requested_weight_tn` decimal(5,2) DEFAULT NULL COMMENT 'Peso estimado',
  `requested_load_date` date DEFAULT NULL COMMENT 'Fecha objetivo de carga',
  `origin_text` varchar(200) DEFAULT NULL COMMENT 'Origen en texto libre',
  `destination_text` varchar(200) DEFAULT NULL COMMENT 'Destino en texto libre',
  `origin_loading_point_id` char(36) DEFAULT NULL COMMENT 'Origen normalizado',
  `destination_unloading_point_id` char(36) DEFAULT NULL COMMENT 'Destino normalizado',
  `service_constraints_text` text DEFAULT NULL COMMENT 'Restricciones solicitadas',
  `requested_mode` varchar(20) DEFAULT NULL COMMENT 'Modo preferido',
  `extracted_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Entidades extraídas por IA' CHECK (json_valid(`extracted_json`)),
  `validation_status` varchar(20) NOT NULL COMMENT 'Estado de validación',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización',
  `delivery_deadline_datetime` timestamp NULL DEFAULT NULL COMMENT 'Fecha/hora límite de entrega solicitada por el wizard',
  `wizard_status` varchar(20) NOT NULL DEFAULT 'idle' COMMENT 'Estado del wizard conversacional'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_quote_requests';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_recommendations`
--

CREATE TABLE `tra_recommendations` (
  `recommendation_id` char(36) NOT NULL COMMENT 'Identificador de recomendación',
  `session_id` char(36) NOT NULL COMMENT 'Sesión',
  `recommendation_type` varchar(30) NOT NULL COMMENT 'Tipo de recomendación',
  `recommendation_text` text NOT NULL COMMENT 'Texto mostrado',
  `recommended_action` varchar(60) DEFAULT NULL COMMENT 'Acción sugerida',
  `recommended_record_type` varchar(40) DEFAULT NULL COMMENT 'Tipo de registro propuesto',
  `recommended_record_id` char(36) DEFAULT NULL COMMENT 'Registro sugerido',
  `confidence_score` decimal(5,2) DEFAULT NULL COMMENT 'Confianza',
  `accepted_by_user` tinyint(1) DEFAULT NULL COMMENT 'Usuario aceptó',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_recommendations';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_routes`
--

CREATE TABLE `tra_routes` (
  `route_id` char(36) NOT NULL COMMENT 'Identificador de ruta',
  `route_code` varchar(30) NOT NULL COMMENT 'Código de ruta',
  `route_name` varchar(150) NOT NULL COMMENT 'Nombre descriptivo',
  `origin_loading_point_id` char(36) DEFAULT NULL COMMENT 'Punto origen habitual',
  `destination_unloading_point_id` char(36) DEFAULT NULL COMMENT 'Punto destino habitual',
  `standard_distance_km` int(11) NOT NULL COMMENT 'Distancia estándar',
  `standard_duration_minutes` int(11) NOT NULL COMMENT 'Duración estándar',
  `countries_crossed` varchar(120) DEFAULT NULL COMMENT 'Países de tránsito',
  `toll_cost_estimate` decimal(10,2) DEFAULT NULL COMMENT 'Peajes estimados',
  `ferry_cost_estimate` decimal(10,2) DEFAULT NULL COMMENT 'Coste ferry si aplica',
  `co2_estimate_kg` decimal(10,2) DEFAULT NULL COMMENT 'CO2 estimado',
  `preferred_mode` varchar(20) NOT NULL COMMENT 'Modo preferente',
  `intermodal_possible` tinyint(1) NOT NULL COMMENT 'Intermodal viable',
  `active` tinyint(1) NOT NULL COMMENT 'Ruta activa',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha de alta',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_routes';

--
-- Volcado de datos para la tabla `tra_routes`
--

INSERT INTO `tra_routes` (`route_id`, `route_code`, `route_name`, `origin_loading_point_id`, `destination_unloading_point_id`, `standard_distance_km`, `standard_duration_minutes`, `countries_crossed`, `toll_cost_estimate`, `ferry_cost_estimate`, `co2_estimate_kg`, `preferred_mode`, `intermodal_possible`, `active`, `created_at`, `updated_at`) VALUES
('d3aba292-2515-11f1-8370-5a0d05a37ed2', 'MAL-MAD', 'Málaga > Madrid', 'd3a7660a-2515-11f1-8370-5a0d05a37ed2', 'd3a7ea6c-2515-11f1-8370-5a0d05a37ed2', 530, 360, 'ES', NULL, NULL, NULL, 'road', 0, 1, '2026-03-21 11:05:10', '2026-03-21 11:05:10');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_service_rules`
--

CREATE TABLE `tra_service_rules` (
  `service_rule_id` char(36) NOT NULL COMMENT 'Identificador de regla',
  `rule_code` varchar(40) NOT NULL COMMENT 'Código de regla',
  `rule_name` varchar(150) NOT NULL COMMENT 'Nombre de regla',
  `rule_type` varchar(30) NOT NULL COMMENT 'Tipo de regla',
  `applies_to_scope` varchar(30) NOT NULL COMMENT 'Ámbito de aplicación',
  `client_id` char(36) DEFAULT NULL COMMENT 'Cliente específico si aplica',
  `product_id` char(36) DEFAULT NULL COMMENT 'Producto específico si aplica',
  `category_id` char(36) DEFAULT NULL COMMENT 'Categoría específica si aplica',
  `route_id` char(36) DEFAULT NULL COMMENT 'Ruta específica si aplica',
  `condition_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'Condición evaluable' CHECK (json_valid(`condition_json`)),
  `action_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'Acción/resultado esperado' CHECK (json_valid(`action_json`)),
  `severity` varchar(20) NOT NULL COMMENT 'Severidad',
  `active` tinyint(1) NOT NULL COMMENT 'Regla activa',
  `valid_from` date DEFAULT NULL COMMENT 'Inicio de vigencia',
  `valid_to` date DEFAULT NULL COMMENT 'Fin de vigencia',
  `notes` text DEFAULT NULL COMMENT 'Observaciones'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_service_rules';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_session_step_state`
--

CREATE TABLE `tra_session_step_state` (
  `session_step_state_id` char(36) NOT NULL COMMENT 'Identificador del estado del paso',
  `session_id` char(36) NOT NULL COMMENT 'Sesión conversacional',
  `quote_request_id` char(36) DEFAULT NULL COMMENT 'Solicitud asociada',
  `wizard_step_id` char(36) NOT NULL COMMENT 'Paso del wizard',
  `step_status` varchar(20) NOT NULL COMMENT 'pending, asked, answered, validated, blocked',
  `raw_value_text` text DEFAULT NULL COMMENT 'Valor textual recibido',
  `normalized_value_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Valor normalizado' CHECK (json_valid(`normalized_value_json`)),
  `confidence_score` decimal(5,2) DEFAULT NULL COMMENT 'Confianza de extracción',
  `source_message_id` char(36) DEFAULT NULL COMMENT 'Mensaje origen',
  `asked_at` timestamp NULL DEFAULT NULL COMMENT 'Fecha de pregunta',
  `answered_at` timestamp NULL DEFAULT NULL COMMENT 'Fecha de respuesta',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_session_step_state';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_tanks`
--

CREATE TABLE `tra_tanks` (
  `tank_id` char(36) NOT NULL COMMENT 'Identificador de cisterna/tanque',
  `tank_code` varchar(30) NOT NULL COMMENT 'Código interno',
  `tank_type` varchar(30) NOT NULL COMMENT 'Tipo de tanque',
  `capacity_liters` int(11) NOT NULL COMMENT 'Capacidad nominal en litros',
  `max_payload_tn` decimal(5,2) NOT NULL COMMENT 'Carga útil máxima en toneladas',
  `temperature_control` tinyint(1) NOT NULL COMMENT 'Control de temperatura',
  `heating_system` tinyint(1) NOT NULL COMMENT 'Dispone de calefacción',
  `cooling_system` tinyint(1) NOT NULL COMMENT 'Dispone de refrigeración',
  `self_unloading` tinyint(1) NOT NULL COMMENT 'Dispone de autodescarga',
  `bacteriological_filter` tinyint(1) NOT NULL COMMENT 'Filtro bacteriológico',
  `compartment_count` int(11) NOT NULL COMMENT 'Número de compartimentos',
  `dedicated_use` varchar(30) DEFAULT NULL COMMENT 'Uso dedicado si aplica',
  `cleaning_status` varchar(20) NOT NULL COMMENT 'Estado de limpieza',
  `current_location` varchar(120) DEFAULT NULL COMMENT 'Ubicación actual',
  `ownership_type` varchar(20) NOT NULL COMMENT 'Propio/externo/leasing',
  `active` tinyint(1) NOT NULL COMMENT 'Tanque activo',
  `last_cleaning_date` date DEFAULT NULL COMMENT 'Fecha último lavado',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha de alta',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización',
  `notes` text DEFAULT NULL COMMENT 'Observaciones técnicas'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_tanks';

--
-- Volcado de datos para la tabla `tra_tanks`
--

INSERT INTO `tra_tanks` (`tank_id`, `tank_code`, `tank_type`, `capacity_liters`, `max_payload_tn`, `temperature_control`, `heating_system`, `cooling_system`, `self_unloading`, `bacteriological_filter`, `compartment_count`, `dedicated_use`, `cleaning_status`, `current_location`, `ownership_type`, `active`, `last_cleaning_date`, `created_at`, `updated_at`, `notes`) VALUES
('373932bc-249d-11f1-9638-5a0d05a37ed3', 'TNK-001', 'food_grade', 26000, 24.00, 1, 0, 1, 1, 1, 3, 'milk', 'clean', NULL, 'owned', 1, NULL, '2026-03-20 20:41:48', '2026-03-20 20:41:48', 'Tanque dedicado a leche.'),
('3739382a-249d-11f1-9638-5a0d05a37ed3', 'TNK-002', 'standard', 24000, 22.50, 0, 0, 0, 1, 0, 2, NULL, 'clean', NULL, 'owned', 1, NULL, '2026-03-20 20:41:48', '2026-03-20 20:41:48', NULL),
('37394fd6-249d-11f1-9638-5a0d05a37ed3', 'TNK-003', 'food_grade', 28000, 25.00, 1, 1, 1, 1, 1, 4, 'milk', 'clean', NULL, 'leased', 1, NULL, '2026-03-20 20:41:48', '2026-03-20 20:41:48', 'Tanque con control termico.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_tank_cleanings`
--

CREATE TABLE `tra_tank_cleanings` (
  `cleaning_id` char(36) NOT NULL COMMENT 'Identificador de lavado',
  `tank_id` char(36) NOT NULL COMMENT 'Tanque limpiado',
  `cleaning_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Fecha/hora de lavado',
  `cleaning_center_name` varchar(150) DEFAULT NULL COMMENT 'Centro de lavado',
  `cleaning_center_country` char(2) DEFAULT NULL COMMENT 'País del centro',
  `cleaning_type` varchar(30) NOT NULL COMMENT 'Tipo de lavado',
  `previous_product_id` char(36) DEFAULT NULL COMMENT 'Producto previo',
  `certificate_number` varchar(60) DEFAULT NULL COMMENT 'Nº certificado',
  `valid_until` timestamp NULL DEFAULT NULL COMMENT 'Validez del lavado',
  `next_allowed_categories_text` varchar(200) DEFAULT NULL COMMENT 'Categorías permitidas tras lavado',
  `next_allowed_products_text` varchar(250) DEFAULT NULL COMMENT 'Productos permitidos tras lavado',
  `cleaning_document_ref` varchar(200) DEFAULT NULL COMMENT 'Referencia documental',
  `clearance_status` varchar(20) NOT NULL COMMENT 'Liberación',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_tank_cleanings';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_tank_last_loads`
--

CREATE TABLE `tra_tank_last_loads` (
  `tank_last_load_id` char(36) NOT NULL COMMENT 'Identificador de histórico de carga',
  `tank_id` char(36) NOT NULL COMMENT 'Tanque',
  `order_id` char(36) DEFAULT NULL COMMENT 'Pedido origen',
  `product_id` char(36) NOT NULL COMMENT 'Producto cargado',
  `category_id` char(36) NOT NULL COMMENT 'Categoría',
  `load_completed_at` timestamp NULL DEFAULT NULL COMMENT 'Fin de carga',
  `unload_completed_at` timestamp NULL DEFAULT NULL COMMENT 'Fin de descarga',
  `cleaning_id` char(36) DEFAULT NULL COMMENT 'Lavado posterior',
  `clearance_status` varchar(20) NOT NULL COMMENT 'Estado de liberación',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_tank_last_loads';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_tank_product_authorizations`
--

CREATE TABLE `tra_tank_product_authorizations` (
  `tank_product_authorization_id` char(36) NOT NULL COMMENT 'Identificador de autorización',
  `tank_id` char(36) NOT NULL COMMENT 'Tanque autorizado',
  `category_id` char(36) DEFAULT NULL COMMENT 'Categoría autorizada',
  `product_id` char(36) DEFAULT NULL COMMENT 'Producto autorizado',
  `allowed` tinyint(1) NOT NULL COMMENT 'Permitido',
  `authorization_type` varchar(20) NOT NULL COMMENT 'Nivel de autorización',
  `restriction_notes` text DEFAULT NULL COMMENT 'Restricciones',
  `valid_from` date DEFAULT NULL COMMENT 'Inicio de vigencia',
  `valid_to` date DEFAULT NULL COMMENT 'Fin de vigencia',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_tank_product_authorizations';

--
-- Volcado de datos para la tabla `tra_tank_product_authorizations`
--

INSERT INTO `tra_tank_product_authorizations` (`tank_product_authorization_id`, `tank_id`, `category_id`, `product_id`, `allowed`, `authorization_type`, `restriction_notes`, `valid_from`, `valid_to`, `created_at`, `updated_at`) VALUES
('d86793c0-249f-11f1-9638-5a0d05a37ed3', '373932bc-249d-11f1-9638-5a0d05a37ed3', 'd85cc936-249f-11f1-9638-5a0d05a37ed3', NULL, 1, 'standard', NULL, NULL, NULL, '2026-03-20 21:00:37', '2026-03-20 21:00:37'),
('d8689446-249f-11f1-9638-5a0d05a37ed3', '37394fd6-249d-11f1-9638-5a0d05a37ed3', 'd85cc936-249f-11f1-9638-5a0d05a37ed3', NULL, 1, 'standard', NULL, NULL, NULL, '2026-03-20 21:00:37', '2026-03-20 21:00:37');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_unloading_points`
--

CREATE TABLE `tra_unloading_points` (
  `unloading_point_id` char(36) NOT NULL COMMENT 'Identificador del punto de descarga',
  `client_id` char(36) DEFAULT NULL COMMENT 'Cliente asociado al punto',
  `point_code` varchar(30) NOT NULL COMMENT 'Código del punto',
  `point_name` varchar(150) NOT NULL COMMENT 'Nombre del centro/planta',
  `country_code` char(2) NOT NULL COMMENT 'País',
  `postal_code` varchar(15) DEFAULT NULL COMMENT 'Código postal',
  `city` varchar(100) NOT NULL COMMENT 'Ciudad',
  `address_line1` varchar(200) NOT NULL COMMENT 'Dirección',
  `latitude` decimal(9,6) DEFAULT NULL COMMENT 'Latitud',
  `longitude` decimal(9,6) DEFAULT NULL COMMENT 'Longitud',
  `unloading_window_start` time DEFAULT NULL COMMENT 'Inicio de ventana típica',
  `unloading_window_end` time DEFAULT NULL COMMENT 'Fin de ventana típica',
  `unloading_days_mask` varchar(20) DEFAULT NULL COMMENT 'Días operables',
  `requires_prealert` tinyint(1) NOT NULL COMMENT 'Requiere preaviso',
  `discharge_requirements` text DEFAULT NULL COMMENT 'Requisitos de descarga',
  `allowed_vehicle_types` varchar(100) DEFAULT NULL COMMENT 'Tipos de vehículo admitidos',
  `default_contact_id` char(36) DEFAULT NULL COMMENT 'Contacto por defecto',
  `active` tinyint(1) NOT NULL COMMENT 'Punto activo',
  `notes` text DEFAULT NULL COMMENT 'Observaciones'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_unloading_points';

--
-- Volcado de datos para la tabla `tra_unloading_points`
--

INSERT INTO `tra_unloading_points` (`unloading_point_id`, `client_id`, `point_code`, `point_name`, `country_code`, `postal_code`, `city`, `address_line1`, `latitude`, `longitude`, `unloading_window_start`, `unloading_window_end`, `unloading_days_mask`, `requires_prealert`, `discharge_requirements`, `allowed_vehicle_types`, `default_contact_id`, `active`, `notes`) VALUES
('d3a7ea6c-2515-11f1-8370-5a0d05a37ed2', NULL, 'MAD-PLANTA', 'Planta Madrid', 'ES', '28001', 'Madrid', 'Madrid', 40.416800, -3.703800, NULL, NULL, NULL, 0, NULL, 'CISTERNA, CISTERNA_FOOD', NULL, 1, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_users`
--

CREATE TABLE `tra_users` (
  `id` char(36) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `role` enum('admin','operator','client') NOT NULL DEFAULT 'client',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tra_users`
--

INSERT INTO `tra_users` (`id`, `email`, `password_hash`, `full_name`, `role`, `is_active`, `created_at`, `updated_at`) VALUES
('f3ef2b90-23b8-11f1-bf2e-5a0d05a37ed2', 'admin@transframos.local', '$2b$10$wAKbKfYQb9BPmE8JWOqYgOEZij9M4f3xh2OBbHpS1WPvOAeGXsk3K', 'admin', 'admin', 1, '2026-03-19 18:27:49', '2026-03-19 20:21:53'),
('f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2', 'user@transframos.local', '$2b$10$wAKbKfYQb9BPmE8JWOqYgOEZij9M4f3xh2OBbHpS1WPvOAeGXsk3K', 'user', 'client', 1, '2026-03-19 18:27:49', '2026-03-19 20:21:53');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_validation_results`
--

CREATE TABLE `tra_validation_results` (
  `validation_result_id` char(36) NOT NULL COMMENT 'Identificador de validación',
  `session_id` char(36) DEFAULT NULL COMMENT 'Sesión',
  `quote_request_id` char(36) DEFAULT NULL COMMENT 'Solicitud',
  `order_id` char(36) DEFAULT NULL COMMENT 'Pedido',
  `validation_scope` varchar(30) NOT NULL COMMENT 'Ámbito de validación',
  `rule_code` varchar(40) NOT NULL COMMENT 'Código de regla evaluada',
  `severity` varchar(20) NOT NULL COMMENT 'Severidad',
  `validation_status` varchar(20) NOT NULL COMMENT 'Resultado',
  `message` text NOT NULL COMMENT 'Mensaje generado',
  `blocking` tinyint(1) NOT NULL COMMENT 'Bloquea flujo',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_validation_results';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_vehicles`
--

CREATE TABLE `tra_vehicles` (
  `vehicle_id` char(36) NOT NULL COMMENT 'Identificador de vehículo',
  `vehicle_code` varchar(30) NOT NULL COMMENT 'Código interno',
  `plate_number` varchar(20) NOT NULL COMMENT 'Matrícula',
  `vehicle_type` varchar(20) NOT NULL COMMENT 'Tipo de vehículo',
  `home_base` varchar(120) DEFAULT NULL COMMENT 'Base habitual',
  `euro_class` varchar(20) DEFAULT NULL COMMENT 'Clase de emisiones',
  `max_daily_km` int(11) DEFAULT NULL COMMENT 'Km máximos diarios',
  `max_weekly_km` int(11) DEFAULT NULL COMMENT 'Km máximos semanales',
  `gps_enabled` tinyint(1) NOT NULL COMMENT 'Dispone de GPS',
  `intermodal_capable` tinyint(1) NOT NULL COMMENT 'Puede operar en esquemas intermodales',
  `maintenance_status` varchar(20) NOT NULL COMMENT 'Estado de mantenimiento',
  `last_maintenance_date` date DEFAULT NULL COMMENT 'Último mantenimiento',
  `next_maintenance_date` date DEFAULT NULL COMMENT 'Próximo mantenimiento',
  `active` tinyint(1) NOT NULL COMMENT 'Vehículo activo',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha de alta',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_vehicles';

--
-- Volcado de datos para la tabla `tra_vehicles`
--

INSERT INTO `tra_vehicles` (`vehicle_id`, `vehicle_code`, `plate_number`, `vehicle_type`, `home_base`, `euro_class`, `max_daily_km`, `max_weekly_km`, `gps_enabled`, `intermodal_capable`, `maintenance_status`, `last_maintenance_date`, `next_maintenance_date`, `active`, `created_at`, `updated_at`) VALUES
('3737307a-249d-11f1-9638-5a0d05a37ed3', 'VEH-001', '1234-ABC', 'CISTERNA', NULL, NULL, NULL, NULL, 1, 0, 'ok', NULL, NULL, 1, '2026-03-20 20:41:48', '2026-03-20 20:41:48'),
('373734b2-249d-11f1-9638-5a0d05a37ed3', 'VEH-002', '5678-DEF', 'CISTERNA', NULL, NULL, NULL, NULL, 1, 1, 'ok', NULL, NULL, 1, '2026-03-20 20:41:48', '2026-03-20 20:41:48'),
('3737355c-249d-11f1-9638-5a0d05a37ed3', 'VEH-003', '9012-GHI', 'CISTERNA_FOOD', NULL, NULL, NULL, NULL, 1, 0, 'ok', NULL, NULL, 1, '2026-03-20 20:41:48', '2026-03-20 20:41:48');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_vehicle_availability`
--

CREATE TABLE `tra_vehicle_availability` (
  `vehicle_availability_id` char(36) NOT NULL COMMENT 'Identificador de disponibilidad',
  `vehicle_id` char(36) NOT NULL COMMENT 'Vehículo',
  `availability_date` date NOT NULL COMMENT 'Fecha',
  `available_from` time DEFAULT NULL COMMENT 'Disponible desde',
  `available_until` time DEFAULT NULL COMMENT 'Disponible hasta',
  `available` tinyint(1) NOT NULL COMMENT 'Disponible',
  `unavailability_reason` varchar(80) DEFAULT NULL COMMENT 'Motivo si no disponible',
  `current_location` varchar(120) DEFAULT NULL COMMENT 'Ubicación',
  `planned_km_limit` int(11) DEFAULT NULL COMMENT 'Límite km del día',
  `notes` text DEFAULT NULL COMMENT 'Observaciones',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_vehicle_availability';

--
-- Volcado de datos para la tabla `tra_vehicle_availability`
--

INSERT INTO `tra_vehicle_availability` (`vehicle_availability_id`, `vehicle_id`, `availability_date`, `available_from`, `available_until`, `available`, `unavailability_reason`, `current_location`, `planned_km_limit`, `notes`, `created_at`, `updated_at`) VALUES
('17c16ba6-2516-11f1-8370-5a0d05a37ed2', '3737307a-249d-11f1-9638-5a0d05a37ed3', '2026-05-12', NULL, NULL, 1, NULL, NULL, NULL, NULL, '2026-03-21 11:07:04', '2026-03-21 11:07:04'),
('17c16e62-2516-11f1-8370-5a0d05a37ed2', '373734b2-249d-11f1-9638-5a0d05a37ed3', '2026-05-12', NULL, NULL, 1, NULL, NULL, NULL, NULL, '2026-03-21 11:07:04', '2026-03-21 11:07:04'),
('17c16eda-2516-11f1-8370-5a0d05a37ed2', '3737355c-249d-11f1-9638-5a0d05a37ed3', '2026-05-12', NULL, NULL, 1, NULL, NULL, NULL, NULL, '2026-03-21 11:07:04', '2026-03-21 11:07:04');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_vehicle_tanks`
--

CREATE TABLE `tra_vehicle_tanks` (
  `vehicle_tank_id` char(36) NOT NULL COMMENT 'Identificador de relación vehículo-tanque',
  `vehicle_id` char(36) NOT NULL COMMENT 'Vehículo',
  `tank_id` char(36) NOT NULL COMMENT 'Tanque',
  `active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Relación activa',
  `valid_from` date DEFAULT NULL COMMENT 'Inicio de vigencia',
  `valid_to` date DEFAULT NULL COMMENT 'Fin de vigencia',
  `notes` text DEFAULT NULL COMMENT 'Observaciones',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Relación vehículo-tanque';

--
-- Volcado de datos para la tabla `tra_vehicle_tanks`
--

INSERT INTO `tra_vehicle_tanks` (`vehicle_tank_id`, `vehicle_id`, `tank_id`, `active`, `valid_from`, `valid_to`, `notes`, `created_at`, `updated_at`) VALUES
('4dba8d5a-249e-11f1-9638-5a0d05a37ed3', '3737307a-249d-11f1-9638-5a0d05a37ed3', '373932bc-249d-11f1-9638-5a0d05a37ed3', 1, NULL, NULL, NULL, '2026-03-20 20:49:35', '2026-03-20 20:49:35'),
('4dba92f0-249e-11f1-9638-5a0d05a37ed3', '373734b2-249d-11f1-9638-5a0d05a37ed3', '3739382a-249d-11f1-9638-5a0d05a37ed3', 1, NULL, NULL, NULL, '2026-03-20 20:49:35', '2026-03-20 20:49:35'),
('4dba9372-249e-11f1-9638-5a0d05a37ed3', '3737355c-249d-11f1-9638-5a0d05a37ed3', '37394fd6-249d-11f1-9638-5a0d05a37ed3', 1, NULL, NULL, NULL, '2026-03-20 20:49:35', '2026-03-20 20:49:35'),
('7afdceb8-249d-11f1-9638-5a0d05a37ed3', '3737307a-249d-11f1-9638-5a0d05a37ed3', '373932bc-249d-11f1-9638-5a0d05a37ed3', 1, NULL, NULL, NULL, '2026-03-20 20:43:41', '2026-03-20 20:43:41');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tra_wizard_steps`
--

CREATE TABLE `tra_wizard_steps` (
  `wizard_step_id` char(36) NOT NULL COMMENT 'Identificador del paso del wizard',
  `step_code` varchar(40) NOT NULL COMMENT 'Código estable del paso',
  `step_label` varchar(120) NOT NULL COMMENT 'Etiqueta visible del paso',
  `step_order` int(11) NOT NULL COMMENT 'Orden del paso en el flujo',
  `maps_to_table` varchar(60) DEFAULT NULL COMMENT 'Tabla de destino principal',
  `maps_to_field` varchar(80) DEFAULT NULL COMMENT 'Campo de destino principal',
  `is_required` tinyint(1) NOT NULL COMMENT 'Indica si el paso es obligatorio',
  `allow_free_text` tinyint(1) NOT NULL COMMENT 'Permite captura en texto libre',
  `active` tinyint(1) NOT NULL COMMENT 'Paso activo',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tra_wizard_steps';

--
-- Volcado de datos para la tabla `tra_wizard_steps`
--

INSERT INTO `tra_wizard_steps` (`wizard_step_id`, `step_code`, `step_label`, `step_order`, `maps_to_table`, `maps_to_field`, `is_required`, `allow_free_text`, `active`, `created_at`, `updated_at`) VALUES
('00000000-0000-0000-0000-000000000101', 'product', 'Producto', 1, 'quote_requests', 'requested_product_text', 1, 1, 1, '2026-03-20 10:15:11', '2026-03-20 10:15:11'),
('00000000-0000-0000-0000-000000000102', 'quantity', 'Cantidad', 2, 'quote_requests', 'requested_volume_liters', 1, 1, 1, '2026-03-20 10:15:11', '2026-03-20 10:15:11'),
('00000000-0000-0000-0000-000000000103', 'origin', 'Origen', 3, 'quote_requests', 'origin_text', 1, 1, 1, '2026-03-20 10:15:11', '2026-03-20 10:15:11'),
('00000000-0000-0000-0000-000000000104', 'destination', 'Destino', 4, 'quote_requests', 'destination_text', 1, 1, 1, '2026-03-20 10:15:11', '2026-03-20 10:15:11'),
('00000000-0000-0000-0000-000000000105', 'requested_date', 'Fecha solicitada', 5, 'quote_requests', 'requested_load_date', 1, 1, 1, '2026-03-20 10:15:11', '2026-03-20 10:15:11'),
('00000000-0000-0000-0000-000000000106', 'delivery_deadline', 'Límite de entrega', 6, 'quote_requests', 'delivery_deadline_datetime', 1, 1, 1, '2026-03-20 10:15:11', '2026-03-20 10:15:11');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `tra_ai_conversation_messages`
--
ALTER TABLE `tra_ai_conversation_messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `idx_tra_ai_conversation_messages_session_id` (`session_id`),
  ADD KEY `idx_tra_ai_conversation_messages_sequence` (`session_id`,`message_sequence`);

--
-- Indices de la tabla `tra_ai_conversation_sessions`
--
ALTER TABLE `tra_ai_conversation_sessions`
  ADD PRIMARY KEY (`session_id`),
  ADD KEY `idx_tra_ai_conversation_sessions_user_id` (`user_id`),
  ADD KEY `idx_tra_ai_conversation_sessions_status` (`status`);

--
-- Indices de la tabla `tra_ai_draft_orders`
--
ALTER TABLE `tra_ai_draft_orders`
  ADD PRIMARY KEY (`draft_order_id`),
  ADD KEY `idx_tra_ai_draft_orders_quote_request_id` (`quote_request_id`),
  ADD KEY `idx_tra_ai_draft_orders_quote_option_id` (`quote_option_id`);

--
-- Indices de la tabla `tra_ai_quote_options`
--
ALTER TABLE `tra_ai_quote_options`
  ADD PRIMARY KEY (`quote_option_id`),
  ADD KEY `idx_tra_ai_quote_options_quote_request_id` (`quote_request_id`),
  ADD KEY `idx_tra_ai_quote_options_recommendation_score` (`recommendation_score`);

--
-- Indices de la tabla `tra_ai_quote_requests`
--
ALTER TABLE `tra_ai_quote_requests`
  ADD PRIMARY KEY (`quote_request_id`),
  ADD UNIQUE KEY `uq_tra_ai_quote_requests_external_reference` (`external_reference`),
  ADD KEY `idx_tra_ai_quote_requests_conversation_session_id` (`conversation_session_id`),
  ADD KEY `idx_tra_ai_quote_requests_validation_status` (`validation_status`),
  ADD KEY `idx_tra_ai_quote_requests_wizard_status` (`wizard_status`);

--
-- Indices de la tabla `tra_ai_session_step_state`
--
ALTER TABLE `tra_ai_session_step_state`
  ADD PRIMARY KEY (`session_step_state_id`),
  ADD UNIQUE KEY `uq_tra_ai_session_step_state_session_step` (`session_id`,`wizard_step_id`),
  ADD KEY `idx_tra_ai_session_step_state_quote_request_id` (`quote_request_id`),
  ADD KEY `idx_tra_ai_session_step_state_source_message_id` (`source_message_id`),
  ADD KEY `fk_tra_ai_session_step_state_wizard_step_id` (`wizard_step_id`);

--
-- Indices de la tabla `tra_ai_validation_results`
--
ALTER TABLE `tra_ai_validation_results`
  ADD PRIMARY KEY (`validation_result_id`),
  ADD KEY `idx_tra_ai_validation_results_session_id` (`session_id`),
  ADD KEY `idx_tra_ai_validation_results_quote_request_id` (`quote_request_id`),
  ADD KEY `idx_tra_ai_validation_results_rule_code` (`rule_code`);

--
-- Indices de la tabla `tra_ai_wizard_steps`
--
ALTER TABLE `tra_ai_wizard_steps`
  ADD PRIMARY KEY (`wizard_step_id`),
  ADD UNIQUE KEY `uq_tra_ai_wizard_steps_step_code` (`step_code`),
  ADD KEY `idx_tra_ai_wizard_steps_step_order` (`step_order`),
  ADD KEY `idx_tra_ai_wizard_steps_active` (`active`);

--
-- Indices de la tabla `tra_assignments`
--
ALTER TABLE `tra_assignments`
  ADD PRIMARY KEY (`assignment_id`),
  ADD KEY `idx_tra_assignments_order_id` (`order_id`),
  ADD KEY `idx_tra_assignments_vehicle_id` (`vehicle_id`),
  ADD KEY `idx_tra_assignments_tank_id` (`tank_id`),
  ADD KEY `idx_tra_assignments_driver_id` (`driver_id`),
  ADD KEY `idx_tra_assignments_assigned_route_id` (`assigned_route_id`);

--
-- Indices de la tabla `tra_auth_sessions`
--
ALTER TABLE `tra_auth_sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_tra_auth_sessions_user_id` (`user_id`);

--
-- Indices de la tabla `tra_clients`
--
ALTER TABLE `tra_clients`
  ADD PRIMARY KEY (`client_id`),
  ADD UNIQUE KEY `uk_tra_clients_client_code` (`client_code`),
  ADD UNIQUE KEY `uk_tra_clients_vat_number` (`vat_number`),
  ADD KEY `idx_tra_clients_country_code` (`country_code`),
  ADD KEY `idx_tra_clients_status` (`status`);

--
-- Indices de la tabla `tra_client_contacts`
--
ALTER TABLE `tra_client_contacts`
  ADD PRIMARY KEY (`contact_id`),
  ADD KEY `idx_tra_client_contacts_client_id` (`client_id`),
  ADD KEY `idx_tra_client_contacts_language_code` (`language_code`);

--
-- Indices de la tabla `tra_conversation_messages`
--
ALTER TABLE `tra_conversation_messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `idx_tra_conversation_messages_session_id` (`session_id`),
  ADD KEY `idx_tra_conversation_messages_extracted_intent_id` (`extracted_intent_id`);

--
-- Indices de la tabla `tra_conversation_sessions`
--
ALTER TABLE `tra_conversation_sessions`
  ADD PRIMARY KEY (`session_id`),
  ADD KEY `idx_tra_conversation_sessions_user_id` (`user_id`),
  ADD KEY `idx_tra_conversation_sessions_status` (`status`),
  ADD KEY `idx_tra_conversation_sessions_channel` (`channel`);

--
-- Indices de la tabla `tra_conversation_sessions_legacy`
--
ALTER TABLE `tra_conversation_sessions_legacy`
  ADD PRIMARY KEY (`session_id`),
  ADD KEY `idx_tra_conversation_sessions_client_id` (`client_id`),
  ADD KEY `idx_tra_conversation_sessions_contact_id` (`contact_id`);

--
-- Indices de la tabla `tra_deliveries`
--
ALTER TABLE `tra_deliveries`
  ADD PRIMARY KEY (`delivery_id`),
  ADD KEY `idx_tra_deliveries_order_id` (`order_id`),
  ADD KEY `idx_tra_deliveries_assignment_id` (`assignment_id`);

--
-- Indices de la tabla `tra_delivery_documents`
--
ALTER TABLE `tra_delivery_documents`
  ADD PRIMARY KEY (`delivery_document_id`),
  ADD UNIQUE KEY `uk_tra_delivery_documents_document_number` (`document_number`),
  ADD KEY `idx_tra_delivery_documents_order_id` (`order_id`),
  ADD KEY `idx_tra_delivery_documents_delivery_id` (`delivery_id`),
  ADD KEY `idx_tra_delivery_documents_linked_cleaning_id` (`linked_cleaning_id`),
  ADD KEY `idx_tra_delivery_documents_linked_incident_id` (`linked_incident_id`);

--
-- Indices de la tabla `tra_drivers`
--
ALTER TABLE `tra_drivers`
  ADD PRIMARY KEY (`driver_id`),
  ADD UNIQUE KEY `uk_tra_drivers_driver_code` (`driver_code`);

--
-- Indices de la tabla `tra_driver_availability`
--
ALTER TABLE `tra_driver_availability`
  ADD PRIMARY KEY (`driver_availability_id`),
  ADD KEY `idx_tra_driver_availability_driver_id` (`driver_id`);

--
-- Indices de la tabla `tra_driver_route_limits`
--
ALTER TABLE `tra_driver_route_limits`
  ADD PRIMARY KEY (`driver_route_limit_id`),
  ADD KEY `idx_tra_driver_route_limits_driver_id` (`driver_id`),
  ADD KEY `idx_tra_driver_route_limits_category_id` (`category_id`),
  ADD KEY `idx_tra_driver_route_limits_route_id` (`route_id`);

--
-- Indices de la tabla `tra_extracted_entities`
--
ALTER TABLE `tra_extracted_entities`
  ADD PRIMARY KEY (`extracted_entity_id`),
  ADD KEY `idx_tra_extracted_entities_session_id` (`session_id`);

--
-- Indices de la tabla `tra_extracted_intents`
--
ALTER TABLE `tra_extracted_intents`
  ADD PRIMARY KEY (`extracted_intent_id`),
  ADD KEY `idx_tra_extracted_intents_session_id` (`session_id`),
  ADD KEY `idx_tra_extracted_intents_intent_code` (`intent_code`);

--
-- Indices de la tabla `tra_incidents`
--
ALTER TABLE `tra_incidents`
  ADD PRIMARY KEY (`incident_id`),
  ADD KEY `idx_tra_incidents_order_id` (`order_id`),
  ADD KEY `idx_tra_incidents_assignment_id` (`assignment_id`);

--
-- Indices de la tabla `tra_llm_actions`
--
ALTER TABLE `tra_llm_actions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_tra_llm_actions_user_id` (`user_id`);

--
-- Indices de la tabla `tra_loading_points`
--
ALTER TABLE `tra_loading_points`
  ADD PRIMARY KEY (`loading_point_id`),
  ADD UNIQUE KEY `uk_tra_loading_points_point_code` (`point_code`),
  ADD KEY `idx_tra_loading_points_client_id` (`client_id`),
  ADD KEY `idx_tra_loading_points_default_contact_id` (`default_contact_id`),
  ADD KEY `idx_tra_loading_points_country_code` (`country_code`),
  ADD KEY `idx_tra_loading_points_postal_code` (`postal_code`);

--
-- Indices de la tabla `tra_orders`
--
ALTER TABLE `tra_orders`
  ADD PRIMARY KEY (`order_id`),
  ADD UNIQUE KEY `uk_tra_orders_order_number` (`order_number`),
  ADD KEY `idx_tra_orders_client_id` (`client_id`),
  ADD KEY `idx_tra_orders_quote_id` (`quote_id`),
  ADD KEY `idx_tra_orders_product_id` (`product_id`),
  ADD KEY `idx_tra_orders_category_id` (`category_id`),
  ADD KEY `idx_tra_orders_origin_loading_point_id` (`origin_loading_point_id`),
  ADD KEY `idx_tra_orders_destination_unloading_point_id` (`destination_unloading_point_id`);

--
-- Indices de la tabla `tra_order_stops`
--
ALTER TABLE `tra_order_stops`
  ADD PRIMARY KEY (`order_stop_id`),
  ADD KEY `idx_tra_order_stops_order_id` (`order_id`),
  ADD KEY `idx_tra_order_stops_loading_point_id` (`loading_point_id`),
  ADD KEY `idx_tra_order_stops_unloading_point_id` (`unloading_point_id`);

--
-- Indices de la tabla `tra_price_rules`
--
ALTER TABLE `tra_price_rules`
  ADD PRIMARY KEY (`price_rule_id`),
  ADD UNIQUE KEY `uk_tra_price_rules_rule_code` (`rule_code`),
  ADD KEY `idx_tra_price_rules_category_id` (`category_id`),
  ADD KEY `idx_tra_price_rules_origin_country_code` (`origin_country_code`),
  ADD KEY `idx_tra_price_rules_destination_country_code` (`destination_country_code`);

--
-- Indices de la tabla `tra_products`
--
ALTER TABLE `tra_products`
  ADD PRIMARY KEY (`product_id`),
  ADD UNIQUE KEY `uk_tra_products_product_code` (`product_code`),
  ADD KEY `idx_tra_products_category_id` (`category_id`);

--
-- Indices de la tabla `tra_product_categories`
--
ALTER TABLE `tra_product_categories`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `uk_tra_product_categories_category_code` (`category_code`);

--
-- Indices de la tabla `tra_product_compatibility_rules`
--
ALTER TABLE `tra_product_compatibility_rules`
  ADD PRIMARY KEY (`compatibility_rule_id`),
  ADD KEY `idx_tra_product_compatibility_rules_previous_product_id` (`previous_product_id`),
  ADD KEY `idx_tra_product_compatibility_rules_next_product_id` (`next_product_id`),
  ADD KEY `idx_tra_product_compatibility_rules_previous_category_id` (`previous_category_id`),
  ADD KEY `idx_tra_product_compatibility_rules_next_category_id` (`next_category_id`);

--
-- Indices de la tabla `tra_prompt_templates`
--
ALTER TABLE `tra_prompt_templates`
  ADD PRIMARY KEY (`prompt_template_id`),
  ADD UNIQUE KEY `uk_tra_prompt_templates_prompt_code` (`prompt_code`),
  ADD KEY `idx_tra_prompt_templates_wizard_step_id` (`wizard_step_id`);

--
-- Indices de la tabla `tra_quotes`
--
ALTER TABLE `tra_quotes`
  ADD PRIMARY KEY (`quote_id`),
  ADD UNIQUE KEY `uk_tra_quotes_quote_number` (`quote_number`),
  ADD KEY `idx_tra_quotes_quote_request_id` (`quote_request_id`),
  ADD KEY `idx_tra_quotes_currency_code` (`currency_code`);

--
-- Indices de la tabla `tra_quote_requests`
--
ALTER TABLE `tra_quote_requests`
  ADD PRIMARY KEY (`quote_request_id`),
  ADD UNIQUE KEY `uk_tra_quote_requests_external_reference` (`external_reference`),
  ADD KEY `idx_tra_quote_requests_client_id` (`client_id`),
  ADD KEY `idx_tra_quote_requests_requested_product_id` (`requested_product_id`),
  ADD KEY `idx_tra_quote_requests_requested_category_id` (`requested_category_id`),
  ADD KEY `idx_tra_quote_requests_origin_loading_point_id` (`origin_loading_point_id`),
  ADD KEY `idx_tra_quote_requests_destination_unloading_point_id` (`destination_unloading_point_id`);

--
-- Indices de la tabla `tra_recommendations`
--
ALTER TABLE `tra_recommendations`
  ADD PRIMARY KEY (`recommendation_id`),
  ADD KEY `idx_tra_recommendations_session_id` (`session_id`);

--
-- Indices de la tabla `tra_routes`
--
ALTER TABLE `tra_routes`
  ADD PRIMARY KEY (`route_id`),
  ADD UNIQUE KEY `uk_tra_routes_route_code` (`route_code`),
  ADD KEY `idx_tra_routes_origin_loading_point_id` (`origin_loading_point_id`),
  ADD KEY `idx_tra_routes_destination_unloading_point_id` (`destination_unloading_point_id`);

--
-- Indices de la tabla `tra_service_rules`
--
ALTER TABLE `tra_service_rules`
  ADD PRIMARY KEY (`service_rule_id`),
  ADD UNIQUE KEY `uk_tra_service_rules_rule_code` (`rule_code`),
  ADD KEY `idx_tra_service_rules_client_id` (`client_id`),
  ADD KEY `idx_tra_service_rules_product_id` (`product_id`),
  ADD KEY `idx_tra_service_rules_category_id` (`category_id`),
  ADD KEY `idx_tra_service_rules_route_id` (`route_id`);

--
-- Indices de la tabla `tra_session_step_state`
--
ALTER TABLE `tra_session_step_state`
  ADD PRIMARY KEY (`session_step_state_id`),
  ADD KEY `idx_tra_session_step_state_session_id` (`session_id`),
  ADD KEY `idx_tra_session_step_state_quote_request_id` (`quote_request_id`),
  ADD KEY `idx_tra_session_step_state_wizard_step_id` (`wizard_step_id`),
  ADD KEY `idx_tra_session_step_state_source_message_id` (`source_message_id`);

--
-- Indices de la tabla `tra_tanks`
--
ALTER TABLE `tra_tanks`
  ADD PRIMARY KEY (`tank_id`),
  ADD UNIQUE KEY `uk_tra_tanks_tank_code` (`tank_code`);

--
-- Indices de la tabla `tra_tank_cleanings`
--
ALTER TABLE `tra_tank_cleanings`
  ADD PRIMARY KEY (`cleaning_id`),
  ADD UNIQUE KEY `uk_tra_tank_cleanings_certificate_number` (`certificate_number`),
  ADD KEY `idx_tra_tank_cleanings_tank_id` (`tank_id`),
  ADD KEY `idx_tra_tank_cleanings_previous_product_id` (`previous_product_id`);

--
-- Indices de la tabla `tra_tank_last_loads`
--
ALTER TABLE `tra_tank_last_loads`
  ADD PRIMARY KEY (`tank_last_load_id`),
  ADD KEY `idx_tra_tank_last_loads_tank_id` (`tank_id`),
  ADD KEY `idx_tra_tank_last_loads_order_id` (`order_id`),
  ADD KEY `idx_tra_tank_last_loads_product_id` (`product_id`),
  ADD KEY `idx_tra_tank_last_loads_category_id` (`category_id`),
  ADD KEY `idx_tra_tank_last_loads_cleaning_id` (`cleaning_id`);

--
-- Indices de la tabla `tra_tank_product_authorizations`
--
ALTER TABLE `tra_tank_product_authorizations`
  ADD PRIMARY KEY (`tank_product_authorization_id`),
  ADD KEY `idx_tra_tank_product_authorizations_tank_id` (`tank_id`),
  ADD KEY `idx_tra_tank_product_authorizations_category_id` (`category_id`),
  ADD KEY `idx_tra_tank_product_authorizations_product_id` (`product_id`);

--
-- Indices de la tabla `tra_unloading_points`
--
ALTER TABLE `tra_unloading_points`
  ADD PRIMARY KEY (`unloading_point_id`),
  ADD UNIQUE KEY `uk_tra_unloading_points_point_code` (`point_code`),
  ADD KEY `idx_tra_unloading_points_client_id` (`client_id`),
  ADD KEY `idx_tra_unloading_points_default_contact_id` (`default_contact_id`),
  ADD KEY `idx_tra_unloading_points_country_code` (`country_code`),
  ADD KEY `idx_tra_unloading_points_postal_code` (`postal_code`);

--
-- Indices de la tabla `tra_users`
--
ALTER TABLE `tra_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_tra_users_email` (`email`);

--
-- Indices de la tabla `tra_validation_results`
--
ALTER TABLE `tra_validation_results`
  ADD PRIMARY KEY (`validation_result_id`),
  ADD KEY `idx_tra_validation_results_session_id` (`session_id`),
  ADD KEY `idx_tra_validation_results_quote_request_id` (`quote_request_id`),
  ADD KEY `idx_tra_validation_results_order_id` (`order_id`),
  ADD KEY `idx_tra_validation_results_rule_code` (`rule_code`);

--
-- Indices de la tabla `tra_vehicles`
--
ALTER TABLE `tra_vehicles`
  ADD PRIMARY KEY (`vehicle_id`),
  ADD UNIQUE KEY `uk_tra_vehicles_vehicle_code` (`vehicle_code`),
  ADD UNIQUE KEY `uk_tra_vehicles_plate_number` (`plate_number`);

--
-- Indices de la tabla `tra_vehicle_availability`
--
ALTER TABLE `tra_vehicle_availability`
  ADD PRIMARY KEY (`vehicle_availability_id`),
  ADD KEY `idx_tra_vehicle_availability_vehicle_id` (`vehicle_id`);

--
-- Indices de la tabla `tra_vehicle_tanks`
--
ALTER TABLE `tra_vehicle_tanks`
  ADD PRIMARY KEY (`vehicle_tank_id`),
  ADD KEY `idx_tra_vehicle_tanks_vehicle` (`vehicle_id`),
  ADD KEY `idx_tra_vehicle_tanks_tank` (`tank_id`);

--
-- Indices de la tabla `tra_wizard_steps`
--
ALTER TABLE `tra_wizard_steps`
  ADD PRIMARY KEY (`wizard_step_id`),
  ADD UNIQUE KEY `uk_tra_wizard_steps_step_code` (`step_code`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `tra_ai_conversation_messages`
--
ALTER TABLE `tra_ai_conversation_messages`
  ADD CONSTRAINT `fk_tra_ai_conversation_messages_session_id` FOREIGN KEY (`session_id`) REFERENCES `tra_ai_conversation_sessions` (`session_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_ai_draft_orders`
--
ALTER TABLE `tra_ai_draft_orders`
  ADD CONSTRAINT `fk_tra_ai_draft_orders_quote_option_id` FOREIGN KEY (`quote_option_id`) REFERENCES `tra_ai_quote_options` (`quote_option_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_ai_draft_orders_quote_request_id` FOREIGN KEY (`quote_request_id`) REFERENCES `tra_ai_quote_requests` (`quote_request_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_ai_quote_options`
--
ALTER TABLE `tra_ai_quote_options`
  ADD CONSTRAINT `fk_tra_ai_quote_options_quote_request_id` FOREIGN KEY (`quote_request_id`) REFERENCES `tra_ai_quote_requests` (`quote_request_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_ai_quote_requests`
--
ALTER TABLE `tra_ai_quote_requests`
  ADD CONSTRAINT `fk_tra_ai_quote_requests_conversation_session_id` FOREIGN KEY (`conversation_session_id`) REFERENCES `tra_ai_conversation_sessions` (`session_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_ai_session_step_state`
--
ALTER TABLE `tra_ai_session_step_state`
  ADD CONSTRAINT `fk_tra_ai_session_step_state_quote_request_id` FOREIGN KEY (`quote_request_id`) REFERENCES `tra_ai_quote_requests` (`quote_request_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_ai_session_step_state_session_id` FOREIGN KEY (`session_id`) REFERENCES `tra_ai_conversation_sessions` (`session_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_ai_session_step_state_source_message_id` FOREIGN KEY (`source_message_id`) REFERENCES `tra_ai_conversation_messages` (`message_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_ai_session_step_state_wizard_step_id` FOREIGN KEY (`wizard_step_id`) REFERENCES `tra_ai_wizard_steps` (`wizard_step_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_ai_validation_results`
--
ALTER TABLE `tra_ai_validation_results`
  ADD CONSTRAINT `fk_tra_ai_validation_results_quote_request_id` FOREIGN KEY (`quote_request_id`) REFERENCES `tra_ai_quote_requests` (`quote_request_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_ai_validation_results_session_id` FOREIGN KEY (`session_id`) REFERENCES `tra_ai_conversation_sessions` (`session_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_assignments`
--
ALTER TABLE `tra_assignments`
  ADD CONSTRAINT `fk_tra_assignments_assigned_route_id` FOREIGN KEY (`assigned_route_id`) REFERENCES `tra_routes` (`route_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_assignments_driver_id` FOREIGN KEY (`driver_id`) REFERENCES `tra_drivers` (`driver_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_assignments_order_id` FOREIGN KEY (`order_id`) REFERENCES `tra_orders` (`order_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_assignments_tank_id` FOREIGN KEY (`tank_id`) REFERENCES `tra_tanks` (`tank_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_assignments_vehicle_id` FOREIGN KEY (`vehicle_id`) REFERENCES `tra_vehicles` (`vehicle_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_auth_sessions`
--
ALTER TABLE `tra_auth_sessions`
  ADD CONSTRAINT `fk_tra_auth_sessions_user_id` FOREIGN KEY (`user_id`) REFERENCES `tra_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_client_contacts`
--
ALTER TABLE `tra_client_contacts`
  ADD CONSTRAINT `fk_tra_client_contacts_client_id` FOREIGN KEY (`client_id`) REFERENCES `tra_clients` (`client_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_conversation_messages`
--
ALTER TABLE `tra_conversation_messages`
  ADD CONSTRAINT `fk_tra_conversation_messages_extracted_intent_id` FOREIGN KEY (`extracted_intent_id`) REFERENCES `tra_extracted_intents` (`extracted_intent_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_conversation_messages_session_id` FOREIGN KEY (`session_id`) REFERENCES `tra_conversation_sessions` (`session_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_conversation_sessions_legacy`
--
ALTER TABLE `tra_conversation_sessions_legacy`
  ADD CONSTRAINT `fk_tra_conversation_sessions_client_id` FOREIGN KEY (`client_id`) REFERENCES `tra_clients` (`client_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_conversation_sessions_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `tra_client_contacts` (`contact_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_deliveries`
--
ALTER TABLE `tra_deliveries`
  ADD CONSTRAINT `fk_tra_deliveries_assignment_id` FOREIGN KEY (`assignment_id`) REFERENCES `tra_assignments` (`assignment_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_deliveries_order_id` FOREIGN KEY (`order_id`) REFERENCES `tra_orders` (`order_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_delivery_documents`
--
ALTER TABLE `tra_delivery_documents`
  ADD CONSTRAINT `fk_tra_delivery_documents_delivery_id` FOREIGN KEY (`delivery_id`) REFERENCES `tra_deliveries` (`delivery_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_delivery_documents_linked_cleaning_id` FOREIGN KEY (`linked_cleaning_id`) REFERENCES `tra_tank_cleanings` (`cleaning_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_delivery_documents_linked_incident_id` FOREIGN KEY (`linked_incident_id`) REFERENCES `tra_incidents` (`incident_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_delivery_documents_order_id` FOREIGN KEY (`order_id`) REFERENCES `tra_orders` (`order_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_driver_availability`
--
ALTER TABLE `tra_driver_availability`
  ADD CONSTRAINT `fk_tra_driver_availability_driver_id` FOREIGN KEY (`driver_id`) REFERENCES `tra_drivers` (`driver_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_driver_route_limits`
--
ALTER TABLE `tra_driver_route_limits`
  ADD CONSTRAINT `fk_tra_driver_route_limits_category_id` FOREIGN KEY (`category_id`) REFERENCES `tra_product_categories` (`category_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_driver_route_limits_driver_id` FOREIGN KEY (`driver_id`) REFERENCES `tra_drivers` (`driver_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_driver_route_limits_route_id` FOREIGN KEY (`route_id`) REFERENCES `tra_routes` (`route_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_extracted_entities`
--
ALTER TABLE `tra_extracted_entities`
  ADD CONSTRAINT `fk_tra_extracted_entities_session_id` FOREIGN KEY (`session_id`) REFERENCES `tra_conversation_sessions_legacy` (`session_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_extracted_intents`
--
ALTER TABLE `tra_extracted_intents`
  ADD CONSTRAINT `fk_tra_extracted_intents_session_id` FOREIGN KEY (`session_id`) REFERENCES `tra_conversation_sessions_legacy` (`session_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_incidents`
--
ALTER TABLE `tra_incidents`
  ADD CONSTRAINT `fk_tra_incidents_assignment_id` FOREIGN KEY (`assignment_id`) REFERENCES `tra_assignments` (`assignment_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_incidents_order_id` FOREIGN KEY (`order_id`) REFERENCES `tra_orders` (`order_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_llm_actions`
--
ALTER TABLE `tra_llm_actions`
  ADD CONSTRAINT `fk_tra_llm_actions_user_id` FOREIGN KEY (`user_id`) REFERENCES `tra_users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_loading_points`
--
ALTER TABLE `tra_loading_points`
  ADD CONSTRAINT `fk_tra_loading_points_client_id` FOREIGN KEY (`client_id`) REFERENCES `tra_clients` (`client_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_loading_points_default_contact_id` FOREIGN KEY (`default_contact_id`) REFERENCES `tra_client_contacts` (`contact_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_orders`
--
ALTER TABLE `tra_orders`
  ADD CONSTRAINT `fk_tra_orders_category_id` FOREIGN KEY (`category_id`) REFERENCES `tra_product_categories` (`category_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_orders_client_id` FOREIGN KEY (`client_id`) REFERENCES `tra_clients` (`client_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_orders_destination_unloading_point_id` FOREIGN KEY (`destination_unloading_point_id`) REFERENCES `tra_unloading_points` (`unloading_point_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_orders_origin_loading_point_id` FOREIGN KEY (`origin_loading_point_id`) REFERENCES `tra_loading_points` (`loading_point_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_orders_product_id` FOREIGN KEY (`product_id`) REFERENCES `tra_products` (`product_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_orders_quote_id` FOREIGN KEY (`quote_id`) REFERENCES `tra_quotes` (`quote_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_order_stops`
--
ALTER TABLE `tra_order_stops`
  ADD CONSTRAINT `fk_tra_order_stops_loading_point_id` FOREIGN KEY (`loading_point_id`) REFERENCES `tra_loading_points` (`loading_point_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_order_stops_order_id` FOREIGN KEY (`order_id`) REFERENCES `tra_orders` (`order_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_order_stops_unloading_point_id` FOREIGN KEY (`unloading_point_id`) REFERENCES `tra_unloading_points` (`unloading_point_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_price_rules`
--
ALTER TABLE `tra_price_rules`
  ADD CONSTRAINT `fk_tra_price_rules_category_id` FOREIGN KEY (`category_id`) REFERENCES `tra_product_categories` (`category_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_products`
--
ALTER TABLE `tra_products`
  ADD CONSTRAINT `fk_tra_products_category_id` FOREIGN KEY (`category_id`) REFERENCES `tra_product_categories` (`category_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_product_compatibility_rules`
--
ALTER TABLE `tra_product_compatibility_rules`
  ADD CONSTRAINT `fk_tra_product_compatibility_rules_next_category_id` FOREIGN KEY (`next_category_id`) REFERENCES `tra_product_categories` (`category_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_product_compatibility_rules_next_product_id` FOREIGN KEY (`next_product_id`) REFERENCES `tra_products` (`product_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_product_compatibility_rules_previous_category_id` FOREIGN KEY (`previous_category_id`) REFERENCES `tra_product_categories` (`category_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_product_compatibility_rules_previous_product_id` FOREIGN KEY (`previous_product_id`) REFERENCES `tra_products` (`product_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_prompt_templates`
--
ALTER TABLE `tra_prompt_templates`
  ADD CONSTRAINT `fk_tra_prompt_templates_wizard_step_id` FOREIGN KEY (`wizard_step_id`) REFERENCES `tra_wizard_steps` (`wizard_step_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_quotes`
--
ALTER TABLE `tra_quotes`
  ADD CONSTRAINT `fk_tra_quotes_quote_request_id` FOREIGN KEY (`quote_request_id`) REFERENCES `tra_quote_requests` (`quote_request_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_quote_requests`
--
ALTER TABLE `tra_quote_requests`
  ADD CONSTRAINT `fk_tra_quote_requests_client_id` FOREIGN KEY (`client_id`) REFERENCES `tra_clients` (`client_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_quote_requests_destination_unloading_point_id` FOREIGN KEY (`destination_unloading_point_id`) REFERENCES `tra_unloading_points` (`unloading_point_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_quote_requests_origin_loading_point_id` FOREIGN KEY (`origin_loading_point_id`) REFERENCES `tra_loading_points` (`loading_point_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_quote_requests_requested_category_id` FOREIGN KEY (`requested_category_id`) REFERENCES `tra_product_categories` (`category_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_quote_requests_requested_product_id` FOREIGN KEY (`requested_product_id`) REFERENCES `tra_products` (`product_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_recommendations`
--
ALTER TABLE `tra_recommendations`
  ADD CONSTRAINT `fk_tra_recommendations_session_id` FOREIGN KEY (`session_id`) REFERENCES `tra_conversation_sessions_legacy` (`session_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_routes`
--
ALTER TABLE `tra_routes`
  ADD CONSTRAINT `fk_tra_routes_destination_unloading_point_id` FOREIGN KEY (`destination_unloading_point_id`) REFERENCES `tra_unloading_points` (`unloading_point_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_routes_origin_loading_point_id` FOREIGN KEY (`origin_loading_point_id`) REFERENCES `tra_loading_points` (`loading_point_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_service_rules`
--
ALTER TABLE `tra_service_rules`
  ADD CONSTRAINT `fk_tra_service_rules_category_id` FOREIGN KEY (`category_id`) REFERENCES `tra_product_categories` (`category_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_service_rules_client_id` FOREIGN KEY (`client_id`) REFERENCES `tra_clients` (`client_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_service_rules_product_id` FOREIGN KEY (`product_id`) REFERENCES `tra_products` (`product_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_service_rules_route_id` FOREIGN KEY (`route_id`) REFERENCES `tra_routes` (`route_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_session_step_state`
--
ALTER TABLE `tra_session_step_state`
  ADD CONSTRAINT `fk_tra_session_step_state_quote_request_id` FOREIGN KEY (`quote_request_id`) REFERENCES `tra_quote_requests` (`quote_request_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_session_step_state_session_id` FOREIGN KEY (`session_id`) REFERENCES `tra_conversation_sessions_legacy` (`session_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_session_step_state_source_message_id` FOREIGN KEY (`source_message_id`) REFERENCES `tra_conversation_messages` (`message_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_session_step_state_wizard_step_id` FOREIGN KEY (`wizard_step_id`) REFERENCES `tra_wizard_steps` (`wizard_step_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_tank_cleanings`
--
ALTER TABLE `tra_tank_cleanings`
  ADD CONSTRAINT `fk_tra_tank_cleanings_previous_product_id` FOREIGN KEY (`previous_product_id`) REFERENCES `tra_products` (`product_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_tank_cleanings_tank_id` FOREIGN KEY (`tank_id`) REFERENCES `tra_tanks` (`tank_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_tank_last_loads`
--
ALTER TABLE `tra_tank_last_loads`
  ADD CONSTRAINT `fk_tra_tank_last_loads_category_id` FOREIGN KEY (`category_id`) REFERENCES `tra_product_categories` (`category_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_tank_last_loads_cleaning_id` FOREIGN KEY (`cleaning_id`) REFERENCES `tra_tank_cleanings` (`cleaning_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_tank_last_loads_order_id` FOREIGN KEY (`order_id`) REFERENCES `tra_orders` (`order_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_tank_last_loads_product_id` FOREIGN KEY (`product_id`) REFERENCES `tra_products` (`product_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_tank_last_loads_tank_id` FOREIGN KEY (`tank_id`) REFERENCES `tra_tanks` (`tank_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_tank_product_authorizations`
--
ALTER TABLE `tra_tank_product_authorizations`
  ADD CONSTRAINT `fk_tra_tank_product_authorizations_category_id` FOREIGN KEY (`category_id`) REFERENCES `tra_product_categories` (`category_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_tank_product_authorizations_product_id` FOREIGN KEY (`product_id`) REFERENCES `tra_products` (`product_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_tank_product_authorizations_tank_id` FOREIGN KEY (`tank_id`) REFERENCES `tra_tanks` (`tank_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_unloading_points`
--
ALTER TABLE `tra_unloading_points`
  ADD CONSTRAINT `fk_tra_unloading_points_client_id` FOREIGN KEY (`client_id`) REFERENCES `tra_clients` (`client_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_unloading_points_default_contact_id` FOREIGN KEY (`default_contact_id`) REFERENCES `tra_client_contacts` (`contact_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_validation_results`
--
ALTER TABLE `tra_validation_results`
  ADD CONSTRAINT `fk_tra_validation_results_order_id` FOREIGN KEY (`order_id`) REFERENCES `tra_orders` (`order_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_validation_results_quote_request_id` FOREIGN KEY (`quote_request_id`) REFERENCES `tra_quote_requests` (`quote_request_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tra_validation_results_session_id` FOREIGN KEY (`session_id`) REFERENCES `tra_conversation_sessions_legacy` (`session_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_vehicle_availability`
--
ALTER TABLE `tra_vehicle_availability`
  ADD CONSTRAINT `fk_tra_vehicle_availability_vehicle_id` FOREIGN KEY (`vehicle_id`) REFERENCES `tra_vehicles` (`vehicle_id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `tra_vehicle_tanks`
--
ALTER TABLE `tra_vehicle_tanks`
  ADD CONSTRAINT `fk_tra_vehicle_tanks_tank` FOREIGN KEY (`tank_id`) REFERENCES `tra_tanks` (`tank_id`),
  ADD CONSTRAINT `fk_tra_vehicle_tanks_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `tra_vehicles` (`vehicle_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
