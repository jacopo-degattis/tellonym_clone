-- MySQL dump 10.17  Distrib 10.3.22-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: tellonym
-- ------------------------------------------------------
-- Server version	10.3.22-MariaDB-1ubuntu1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Tell`
--

DROP TABLE IF EXISTS `Tell`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Tell` (
  `id_tell` int(11) NOT NULL AUTO_INCREMENT,
  `question` varchar(255) NOT NULL,
  `answer` varchar(255) NOT NULL,
  `id_utente_recv` int(11) NOT NULL,
  `id_utente_post` int(11) NOT NULL,
  `answered` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_tell`),
  KEY `Tell_fk0` (`id_utente_recv`),
  KEY `Tell_fk1` (`id_utente_post`),
  CONSTRAINT `Tell_fk0` FOREIGN KEY (`id_utente_recv`) REFERENCES `User` (`id_utente`),
  CONSTRAINT `Tell_fk1` FOREIGN KEY (`id_utente_post`) REFERENCES `User` (`id_utente`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tell`
--

LOCK TABLES `Tell` WRITE;
/*!40000 ALTER TABLE `Tell` DISABLE KEYS */;
INSERT INTO `Tell` VALUES (5,'Quanti hanni hai?','Oggi ne compio 18',5,6,0),(7,'Di dove sei?','Sono di Aosta',5,6,0),(8,'Qual e\' il tuo cibo preferito?','Decisamente la pizza ahaah',5,6,0),(9,'Qual e\' il tuo cibo preferito?','Decisamente la pizza ahaah',6,5,0),(10,'Di dove sei?','Sono di Aosta',6,5,0),(11,'ciao','',5,6,NULL),(12,'Come ti senti oggi?','',5,6,NULL);
/*!40000 ALTER TABLE `Tell` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `User` (
  `id_utente` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `Username` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `followers` int(11) DEFAULT NULL,
  `following` int(11) DEFAULT NULL,
  `tells` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_utente`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES (5,'Jacopo','De Gattis','jacopo.degattis@gmail.com','camillo01','__vndefined','https://padletuploads.blob.core.windows.net/prod/338313757/xv9cNVhJOnCldshv-zjMjA/f41906143bc5eb004cac88418b2a97a7.jpeg','questo mio stato!',848,2,312),(6,'Mattia','Giorla','mattiagiorla@gmail.com','carlo','mgsun','https://www.talkwalker.com/images/2020/blog-headers/image-analysis.png','Love Snowboarding',302,157,12);
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-09-04 20:12:27
