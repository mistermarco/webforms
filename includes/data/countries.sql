# Sequel Pro dump
# Version 1191
# http://code.google.com/p/sequel-pro
#
# Host: 127.0.0.1 (MySQL 5.1.37)
# Database: fb
# Generation Time: 2009-08-29 00:15:28 -0700
# ************************************************************

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table item
# ------------------------------------------------------------

LOCK TABLES `item` WRITE;
/*!40000 ALTER TABLE `item` DISABLE KEYS */;
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`)
VALUES
	(11,'Argentina','Argentina',1,10),
	(5,'Afghanistan','Afghanistan',1,4),
	(19,'Barbados','Barbados',1,18),
	(18,'Bangladesh','Bangladesh',1,17),
	(17,'Bahrain','Bahrain',1,16),
	(16,'Bahamas','Bahamas',1,15),
	(15,'Azerbaijan','Azerbaijan',1,14),
	(14,'Austria','Austria',1,13),
	(13,'Australia','Australia',1,12),
	(12,'Armenia','Armenia',1,11),
	(10,'Antigua and Barbuda','Antigua and Barbuda',1,9),
	(9,'Angola','Angola',1,8),
	(8,'Andorra','Andorra',1,7),
	(7,'Algeria','Algeria',1,6),
	(6,'Albania','Albania',1,5),
	(4,'---','---',1,3),
	(3,'Mexico','Mexico',1,2),
	(2,'Canada','Canada',1,1),
	(1,'United States','United States',1,0),
	(20,'Belarus','Belarus',1,19),
	(21,'Belgium','Belgium',1,20),
	(22,'Belize','Belize',1,21),
	(23,'Benin','Benin',1,22),
	(24,'Bhutan','Bhutan',1,23),
	(25,'Bolivia','Bolivia',1,24),
	(26,'Bosnia and Herzegovina','Bosnia and Herzegovina',1,25),
	(27,'Botswana','Botswana',1,26),
	(28,'Brazil','Brazil',1,27),
	(29,'Brunei','Brunei',1,28),
	(30,'Bulgaria','Bulgaria',1,29),
	(31,'Burkina Faso','Burkina Faso',1,30),
	(32,'Burundi','Burundi',1,31),
	(33,'Cambodia','Cambodia',1,32),
	(34,'Cameroon','Cameroon',1,33),
	(35,'Canada','Canada',1,34),
	(36,'Cape Verde','Cape Verde',1,35),
	(37,'Central African Republic','Central African Republic',1,36),
	(38,'Chad','Chad',1,37),
	(39,'Chile','Chile',1,38),
	(40,'China','China',1,39),
	(41,'Colombia','Colombia',1,40),
	(42,'Comoros','Comoros',1,41),
	(43,'Congo','Congo',1,42),
	(44,'Costa Rica','Costa Rica',1,43),
	(45,'C&ocirc;te d\'Ivoire','C&ocirc;te d\'Ivoire',1,44),
	(46,'Croatia','Croatia',1,45),
	(47,'Cuba','Cuba',1,46),
	(48,'Cyprus','Cyprus',1,47),
	(49,'Czech Republic','Czech Republic',1,48),
	(50,'Denmark','Denmark',1,49),
	(51,'Djibouti','Djibouti',1,50),
	(52,'Dominica','Dominica',1,51),
	(53,'Dominican Republic','Dominican Republic',1,52),
	(54,'East Timor','East Timor',1,53),
	(55,'Ecuador','Ecuador',1,54),
	(56,'Egypt','Egypt',1,55),
	(57,'El Salvador','El Salvador',1,56),
	(58,'Equatorial Guinea','Equatorial Guinea',1,57),
	(59,'Eritrea','Eritrea',1,58),
	(60,'Estonia','Estonia',1,59),
	(61,'Ethiopia','Ethiopia',1,60),
	(62,'Fiji','Fiji',1,61),
	(63,'Finland','Finland',1,62),
	(64,'France','France',1,63),
	(65,'Gabon','Gabon',1,64),
	(66,'Gambia','Gambia',1,65),
	(67,'Georgia','Georgia',1,66),
	(68,'Germany','Germany',1,67),
	(69,'Ghana','Ghana',1,68),
	(70,'Greece','Greece',1,69),
	(71,'Grenada','Grenada',1,70),
	(72,'Guatemala','Guatemala',1,71),
	(73,'Guinea','Guinea',1,72),
	(74,'Guinea-Bissau','Guinea-Bissau',1,73),
	(75,'Guyana','Guyana',1,74),
	(76,'Haiti','Haiti',1,75),
	(77,'Honduras','Honduras',1,76),
	(78,'Hong Kong','Hong Kong',1,77),
	(79,'Hungary','Hungary',1,78),
	(80,'Iceland','Iceland',1,79),
	(81,'India','India',1,80),
	(82,'Indonesia','Indonesia',1,81),
	(83,'Iran','Iran',1,82),
	(84,'Iraq','Iraq',1,83),
	(85,'Ireland','Ireland',1,84),
	(86,'Israel','Israel',1,85),
	(87,'Italy','Italy',1,86),
	(88,'Jamaica','Jamaica',1,87),
	(89,'Japan','Japan',1,88),
	(90,'Jordan','Jordan',1,89),
	(91,'Kazakhstan','Kazakhstan',1,90),
	(92,'Kenya','Kenya',1,91),
	(93,'Kiribati','Kiribati',1,92),
	(94,'North Korea','North Korea',1,93),
	(95,'South Korea','South Korea',1,94),
	(96,'Kuwait','Kuwait',1,95),
	(97,'Kyrgyzstan','Kyrgyzstan',1,96),
	(98,'Laos','Laos',1,97),
	(99,'Latvia','Latvia',1,98),
	(100,'Lebanon','Lebanon',1,99),
	(101,'Lesotho','Lesotho',1,100),
	(102,'Liberia','Liberia',1,101),
	(103,'Libya','Libya',1,102),
	(104,'Liechtenstein','Liechtenstein',1,103),
	(105,'Lithuania','Lithuania',1,104),
	(106,'Luxembourg','Luxembourg',1,105),
	(107,'Macedonia','Macedonia',1,106),
	(108,'Madagascar','Madagascar',1,107),
	(109,'Malawi','Malawi',1,108),
	(110,'Malaysia','Malaysia',1,109),
	(111,'Maldives','Maldives',1,110),
	(112,'Mali','Mali',1,111),
	(113,'Malta','Malta',1,112),
	(114,'Marshall Islands','Marshall Islands',1,113),
	(115,'Mauritania','Mauritania',1,114),
	(116,'Mauritius','Mauritius',1,115),
	(117,'Mexico','Mexico',1,116),
	(118,'Micronesia','Micronesia',1,117),
	(119,'Moldova','Moldova',1,118),
	(120,'Monaco','Monaco',1,119),
	(121,'Mongolia','Mongolia',1,120),
	(122,'Montenegro','Montenegro',1,121),
	(123,'Morocco','Morocco',1,122),
	(124,'Mozambique','Mozambique',1,123),
	(125,'Myanmar','Myanmar',1,124),
	(126,'Namibia','Namibia',1,125),
	(127,'Nauru','Nauru',1,126),
	(128,'Nepal','Nepal',1,127),
	(129,'Netherlands','Netherlands',1,128),
	(130,'New Zealand','New Zealand',1,129),
	(131,'Nicaragua','Nicaragua',1,130),
	(132,'Niger','Niger',1,131),
	(133,'Nigeria','Nigeria',1,132),
	(134,'Norway','Norway',1,133),
	(135,'Oman','Oman',1,134),
	(136,'Pakistan','Pakistan',1,135),
	(137,'Palau','Palau',1,136),
	(138,'Palestine','Palestine',1,137),
	(139,'Panama','Panama',1,138),
	(140,'Papua New Guinea','Papua New Guinea',1,139),
	(141,'Paraguay','Paraguay',1,140),
	(142,'Peru','Peru',1,141),
	(143,'Philippines','Philippines',1,142),
	(144,'Poland','Poland',1,143),
	(145,'Portugal','Portugal',1,144),
	(146,'Puerto Rico','Puerto Rico',1,145),
	(147,'Qatar','Qatar',1,146),
	(148,'Romania','Romania',1,147),
	(149,'Russia','Russia',1,148),
	(150,'Rwanda','Rwanda',1,149),
	(151,'Saint Kitts and Nevis','Saint Kitts and Nevis',1,150),
	(152,'Saint Lucia','Saint Lucia',1,151),
	(153,'Saint Vincent and the Grenadines','Saint Vincent and the Grenadines',1,152),
	(154,'Samoa','Samoa',1,153),
	(155,'San Marino','San Marino',1,154),
	(156,'Sao Tome and Principe','Sao Tome and Principe',1,155),
	(157,'Saudi Arabia','Saudi Arabia',1,156),
	(158,'Senegal','Senegal',1,157),
	(159,'Serbia and Montenegro','Serbia and Montenegro',1,158),
	(160,'Seychelles','Seychelles',1,159),
	(161,'Sierra Leone','Sierra Leone',1,160),
	(162,'Singapore','Singapore',1,161),
	(163,'Slovakia','Slovakia',1,162),
	(164,'Slovenia','Slovenia',1,163),
	(165,'Solomon Islands','Solomon Islands',1,164),
	(166,'Somalia','Somalia',1,165),
	(167,'South Africa','South Africa',1,166),
	(168,'Spain','Spain',1,167),
	(169,'Sri Lanka','Sri Lanka',1,168),
	(170,'Sudan','Sudan',1,169),
	(171,'Suriname','Suriname',1,170),
	(172,'Swaziland','Swaziland',1,171),
	(173,'Sweden','Sweden',1,172),
	(174,'Switzerland','Switzerland',1,173),
	(175,'Syria','Syria',1,174),
	(176,'Taiwan','Taiwan',1,175),
	(177,'Tajikistan','Tajikistan',1,176),
	(178,'Tanzania','Tanzania',1,177),
	(179,'Thailand','Thailand',1,178),
	(180,'Togo','Togo',1,179),
	(181,'Tonga','Tonga',1,180),
	(182,'Trinidad and Tobago','Trinidad and Tobago',1,181),
	(183,'Tunisia','Tunisia',1,182),
	(184,'Turkey','Turkey',1,183),
	(185,'Turkmenistan','Turkmenistan',1,184),
	(186,'Tuvalu','Tuvalu',1,185),
	(187,'Uganda','Uganda',1,186),
	(188,'Ukraine','Ukraine',1,187),
	(189,'United Arab Emirates','United Arab Emirates',1,188),
	(190,'United Kingdom','United Kingdom',1,189),
	(191,'United States','United States',1,190),
	(192,'Uruguay','Uruguay',1,191),
	(193,'Uzbekistan','Uzbekistan',1,192),
	(194,'Vanuatu','Vanuatu',1,193),
	(195,'Vatican City','Vatican City',1,194),
	(196,'Venezuela','Venezuela',1,195),
	(197,'Vietnam','Vietnam',1,196),
	(198,'Yemen','Yemen',1,197),
	(199,'Zambia','Zambia',1,198),
	(200,'Zimbabwe','Zimbabwe',1,199);

/*!40000 ALTER TABLE `item` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table itemset
# ------------------------------------------------------------

LOCK TABLES `itemset` WRITE;
/*!40000 ALTER TABLE `itemset` DISABLE KEYS */;
INSERT INTO `itemset` (`itemset_id`,`label`,`is_custom`)
VALUES
	(1,'countries',1);

/*!40000 ALTER TABLE `itemset` ENABLE KEYS */;
UNLOCK TABLES;


/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
