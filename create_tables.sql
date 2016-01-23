# ************************************************************
# Sequel Pro SQL dump
# Version 4499
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.5.46-0+deb7u1-log)
# Database: fb
# Generation Time: 2016-01-23 01:14:48 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table collection
# ------------------------------------------------------------

DROP TABLE IF EXISTS `collection`;

CREATE TABLE `collection` (
  `collection_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `label` varchar(1000) DEFAULT NULL,
  `class` varchar(255) DEFAULT NULL,
  `template` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `is_required` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `name` varchar(255) DEFAULT NULL,
  `is_autofilled` tinyint(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`collection_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



# Dump of table collection_element
# ------------------------------------------------------------

DROP TABLE IF EXISTS `collection_element`;

CREATE TABLE `collection_element` (
  `collection` int(11) unsigned DEFAULT NULL,
  `element` int(11) unsigned DEFAULT NULL,
  `sort_order` int(11) unsigned DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



# Dump of table element
# ------------------------------------------------------------

DROP TABLE IF EXISTS `element`;

CREATE TABLE `element` (
  `element_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `label` varchar(1000) DEFAULT NULL,
  `class` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `value` text,
  `template` varchar(255) DEFAULT NULL,
  `itemset` int(11) unsigned DEFAULT NULL,
  `is_required` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `name` varchar(255) DEFAULT NULL,
  `is_required_in_collection` int(1) unsigned DEFAULT '0',
  `is_autofilled` tinyint(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`element_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



# Dump of table form
# ------------------------------------------------------------

DROP TABLE IF EXISTS `form`;

CREATE TABLE `form` (
  `form_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `path` varchar(500) DEFAULT '',
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `is_live` tinyint(1) unsigned DEFAULT NULL,
  `template` varchar(255) DEFAULT NULL,
  `css` varchar(255) DEFAULT NULL,
  `templates_path` varchar(255) DEFAULT NULL,
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `theme` varchar(255) DEFAULT NULL,
  `confirmation_method` varchar(255) DEFAULT NULL,
  `confirmation_text` varchar(10240) DEFAULT NULL,
  `confirmation_url` varchar(255) DEFAULT NULL,
  `confirmation_email` varchar(255) DEFAULT NULL,
  `submission_method` varchar(255) DEFAULT NULL,
  `submission_email` varchar(512) DEFAULT NULL,
  `submission_email_csv` tinyint(1) unsigned DEFAULT NULL,
  `creator` char(8) DEFAULT NULL,
  `is_deleted` int(1) unsigned zerofill NOT NULL DEFAULT '0',
  `date_deleted` datetime DEFAULT NULL,
  `deleted_by` varchar(255) DEFAULT NULL,
  `last_submission_date` datetime DEFAULT NULL,
  `url` varchar(500) DEFAULT NULL,
  `total_submissions` int(11) unsigned NOT NULL DEFAULT '0',
  `has_submission_database` int(1) unsigned DEFAULT '0',
  `total_database_submissions` int(11) unsigned DEFAULT '0',
  `submission_email_subject` varchar(255) DEFAULT NULL,
  `submission_email_sender` varchar(255) DEFAULT NULL,
  `can_be_continued` int(1) unsigned DEFAULT NULL,
  `confirm_before_submit` int(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`form_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


# Dump of table item
# ------------------------------------------------------------

DROP TABLE IF EXISTS `item`;

CREATE TABLE `item` (
  `item_id` int(11) unsigned NOT NULL auto_increment,
  `label` varchar(255) default NULL,
  `value` varchar(255) default NULL,
  `itemset_id` int(11) unsigned default NULL,
  `sort_order` int(11) unsigned default NULL,
  PRIMARY KEY  (`item_id`)
) ENGINE=MyISAM AUTO_INCREMENT=10313 DEFAULT CHARSET=latin1;

INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8232','Argentina','Argentina','1','10');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8226','Afghanistan','Afghanistan','1','4');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8240','Barbados','Barbados','1','18');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8239','Bangladesh','Bangladesh','1','17');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8238','Bahrain','Bahrain','1','16');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8237','Bahamas','Bahamas','1','15');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8236','Azerbaijan','Azerbaijan','1','14');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8235','Austria','Austria','1','13');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8234','Australia','Australia','1','12');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8233','Armenia','Armenia','1','11');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8231','Antigua and Barbuda','Antigua and Barbuda','1','9');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8230','Angola','Angola','1','8');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8229','Andorra','Andorra','1','7');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8228','Algeria','Algeria','1','6');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8227','Albania','Albania','1','5');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8225','---','---','1','3');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8224','Mexico','Mexico','1','2');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8223','Canada','Canada','1','1');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8222','United States','United States','1','0');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8241','Belarus','Belarus','1','19');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8242','Belgium','Belgium','1','20');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8243','Belize','Belize','1','21');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8244','Benin','Benin','1','22');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8245','Bhutan','Bhutan','1','23');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8246','Bolivia','Bolivia','1','24');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8247','Bosnia and Herzegovina','Bosnia and Herzegovina','1','25');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8248','Botswana','Botswana','1','26');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8249','Brazil','Brazil','1','27');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8250','Brunei','Brunei','1','28');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8251','Bulgaria','Bulgaria','1','29');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8252','Burkina Faso','Burkina Faso','1','30');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8253','Burundi','Burundi','1','31');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8254','Cambodia','Cambodia','1','32');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8255','Cameroon','Cameroon','1','33');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8256','Canada','Canada','1','34');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8257','Cape Verde','Cape Verde','1','35');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8258','Central African Republic','Central African Republic','1','36');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8259','Chad','Chad','1','37');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8260','Chile','Chile','1','38');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8261','China','China','1','39');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8262','Colombia','Colombia','1','40');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8263','Comoros','Comoros','1','41');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8264','Congo','Congo','1','42');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8265','Costa Rica','Costa Rica','1','43');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8266','C&ocirc;te d\'Ivoire','C&ocirc;te d\'Ivoire','1','44');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8267','Croatia','Croatia','1','45');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8268','Cuba','Cuba','1','46');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8269','Cyprus','Cyprus','1','47');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8270','Czech Republic','Czech Republic','1','48');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8271','Denmark','Denmark','1','49');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8272','Djibouti','Djibouti','1','50');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8273','Dominica','Dominica','1','51');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8274','Dominican Republic','Dominican Republic','1','52');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8275','East Timor','East Timor','1','53');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8276','Ecuador','Ecuador','1','54');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8277','Egypt','Egypt','1','55');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8278','El Salvador','El Salvador','1','56');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8279','Equatorial Guinea','Equatorial Guinea','1','57');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8280','Eritrea','Eritrea','1','58');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8281','Estonia','Estonia','1','59');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8282','Ethiopia','Ethiopia','1','60');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8283','Fiji','Fiji','1','61');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8284','Finland','Finland','1','62');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8285','France','France','1','63');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8286','Gabon','Gabon','1','64');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8287','Gambia','Gambia','1','65');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8288','Georgia','Georgia','1','66');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8289','Germany','Germany','1','67');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8290','Ghana','Ghana','1','68');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8291','Greece','Greece','1','69');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8292','Grenada','Grenada','1','70');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8293','Guatemala','Guatemala','1','71');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8294','Guinea','Guinea','1','72');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8295','Guinea-Bissau','Guinea-Bissau','1','73');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8296','Guyana','Guyana','1','74');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8297','Haiti','Haiti','1','75');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8298','Honduras','Honduras','1','76');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8299','Hong Kong','Hong Kong','1','77');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8300','Hungary','Hungary','1','78');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8301','Iceland','Iceland','1','79');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8302','India','India','1','80');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8303','Indonesia','Indonesia','1','81');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8304','Iran','Iran','1','82');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8305','Iraq','Iraq','1','83');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8306','Ireland','Ireland','1','84');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8307','Israel','Israel','1','85');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8308','Italy','Italy','1','86');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8309','Jamaica','Jamaica','1','87');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8310','Japan','Japan','1','88');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8311','Jordan','Jordan','1','89');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8312','Kazakhstan','Kazakhstan','1','90');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8313','Kenya','Kenya','1','91');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8314','Kiribati','Kiribati','1','92');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8315','North Korea','North Korea','1','93');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8316','South Korea','South Korea','1','94');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8317','Kuwait','Kuwait','1','95');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8318','Kyrgyzstan','Kyrgyzstan','1','96');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8319','Laos','Laos','1','97');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8320','Latvia','Latvia','1','98');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8321','Lebanon','Lebanon','1','99');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8322','Lesotho','Lesotho','1','100');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8323','Liberia','Liberia','1','101');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8324','Libya','Libya','1','102');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8325','Liechtenstein','Liechtenstein','1','103');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8326','Lithuania','Lithuania','1','104');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8327','Luxembourg','Luxembourg','1','105');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8328','Macedonia','Macedonia','1','106');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8329','Madagascar','Madagascar','1','107');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8330','Malawi','Malawi','1','108');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8331','Malaysia','Malaysia','1','109');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8332','Maldives','Maldives','1','110');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8333','Mali','Mali','1','111');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8334','Malta','Malta','1','112');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8335','Marshall Islands','Marshall Islands','1','113');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8336','Mauritania','Mauritania','1','114');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8337','Mauritius','Mauritius','1','115');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8338','Mexico','Mexico','1','116');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8339','Micronesia','Micronesia','1','117');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8340','Moldova','Moldova','1','118');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8341','Monaco','Monaco','1','119');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8342','Mongolia','Mongolia','1','120');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8343','Montenegro','Montenegro','1','121');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8344','Morocco','Morocco','1','122');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8345','Mozambique','Mozambique','1','123');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8346','Myanmar','Myanmar','1','124');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8347','Namibia','Namibia','1','125');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8348','Nauru','Nauru','1','126');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8349','Nepal','Nepal','1','127');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8350','Netherlands','Netherlands','1','128');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8351','New Zealand','New Zealand','1','129');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8352','Nicaragua','Nicaragua','1','130');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8353','Niger','Niger','1','131');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8354','Nigeria','Nigeria','1','132');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8355','Norway','Norway','1','133');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8356','Oman','Oman','1','134');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8357','Pakistan','Pakistan','1','135');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8358','Palau','Palau','1','136');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8359','Palestine','Palestine','1','137');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8360','Panama','Panama','1','138');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8361','Papua New Guinea','Papua New Guinea','1','139');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8362','Paraguay','Paraguay','1','140');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8363','Peru','Peru','1','141');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8364','Philippines','Philippines','1','142');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8365','Poland','Poland','1','143');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8366','Portugal','Portugal','1','144');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8367','Puerto Rico','Puerto Rico','1','145');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8368','Qatar','Qatar','1','146');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8369','Romania','Romania','1','147');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8370','Russia','Russia','1','148');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8371','Rwanda','Rwanda','1','149');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8372','Saint Kitts and Nevis','Saint Kitts and Nevis','1','150');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8373','Saint Lucia','Saint Lucia','1','151');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8374','Saint Vincent and the Grenadines','Saint Vincent and the Grenadines','1','152');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8375','Samoa','Samoa','1','153');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8376','San Marino','San Marino','1','154');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8377','Sao Tome and Principe','Sao Tome and Principe','1','155');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8378','Saudi Arabia','Saudi Arabia','1','156');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8379','Senegal','Senegal','1','157');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8380','Serbia and Montenegro','Serbia and Montenegro','1','158');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8381','Seychelles','Seychelles','1','159');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8382','Sierra Leone','Sierra Leone','1','160');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8383','Singapore','Singapore','1','161');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8384','Slovakia','Slovakia','1','162');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8385','Slovenia','Slovenia','1','163');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8386','Solomon Islands','Solomon Islands','1','164');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8387','Somalia','Somalia','1','165');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8388','South Africa','South Africa','1','166');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8389','Spain','Spain','1','167');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8390','Sri Lanka','Sri Lanka','1','168');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8391','Sudan','Sudan','1','169');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8392','Suriname','Suriname','1','170');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8393','Swaziland','Swaziland','1','171');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8394','Sweden','Sweden','1','172');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8395','Switzerland','Switzerland','1','173');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8396','Syria','Syria','1','174');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8397','Taiwan','Taiwan','1','175');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8398','Tajikistan','Tajikistan','1','176');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8399','Tanzania','Tanzania','1','177');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8400','Thailand','Thailand','1','178');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8401','Togo','Togo','1','179');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8402','Tonga','Tonga','1','180');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8403','Trinidad and Tobago','Trinidad and Tobago','1','181');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8404','Tunisia','Tunisia','1','182');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8405','Turkey','Turkey','1','183');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8406','Turkmenistan','Turkmenistan','1','184');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8407','Tuvalu','Tuvalu','1','185');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8408','Uganda','Uganda','1','186');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8409','Ukraine','Ukraine','1','187');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8410','United Arab Emirates','United Arab Emirates','1','188');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8411','United Kingdom','United Kingdom','1','189');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8412','United States','United States','1','190');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8413','Uruguay','Uruguay','1','191');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8414','Uzbekistan','Uzbekistan','1','192');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8415','Vanuatu','Vanuatu','1','193');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8416','Vatican City','Vatican City','1','194');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8417','Venezuela','Venezuela','1','195');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8418','Vietnam','Vietnam','1','196');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8419','Yemen','Yemen','1','197');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8420','Zambia','Zambia','1','198');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('8421','Zimbabwe','Zimbabwe','1','199');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9826','VoIP Voice Over IP','VoIP Voice Over IP','2','157');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9825','Voice Mail - Enhanced Call Processing','Voice Mail - Enhanced Call Processing','2','156');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9824','Voice Mail','Voice Mail','2','155');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9823','Virtual Host Service','Virtual Host Service','2','154');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9822','Usenet Newsgroups','Usenet Newsgroups','2','153');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9821','Usability Analysis, Design, and Testing','Usability Analysis, Design, and Testing','2','152');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9820','Unix/Linux Systems Planning','Unix/Linux Systems Planning','2','151');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9819','UNIX/Linux System Administration','UNIX/Linux System Administration','2','150');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9818','UNIX Computing Resources at Stanford','UNIX Computing Resources at Stanford','2','149');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9817','Underground Conduit','Underground Conduit','2','148');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9816','Transferring Files at Stanford','Transferring Files at Stanford','2','147');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9815','Training','Training','2','146');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9814','TIPS (Team for Improving Productivity at Stanford)','TIPS (Team for Improving Productivity at Stanford)','2','145');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9813','Time Tracking','Time Tracking','2','144');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9812','Test Service','Test Service','2','143');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9811','Telephones, Cable TV, &amp; Internet for Stanford West &amp; Welch Road Residents','Telephones, Cable TV, &amp; Internet for Stanford West &amp; Welch Road Residents','2','142');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9810','Telephones for Student Residents','Telephones for Student Residents','2','141');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9809','Telephones &amp; Voice Mail for Faculty and Staff','Telephones &amp; Voice Mail for Faculty and Staff','2','140');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9808','Telephones & Voice Mail','Telephones & Voice Mail','2','139');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9807','TechPort Online Technology Training','TechPort Online Technology Training','2','138');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9806','Technology Support for Courses (web site)','Technology Support for Courses (web site)','2','137');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9805','Tech Express','Tech Express','2','136');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9804','Tech Briefings','Tech Briefings','2','135');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9803','TBA Training By Appointment','TBA Training By Appointment','2','134');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9802','Support for KB','Support for KB','2','133');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9801','SUNet The Stanford University Network','SUNet The Stanford University Network','2','132');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9800','Sundial Calendar','Sundial Calendar','2','131');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9799','Streaming Media','Streaming Media','2','130');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9798','Storage Management','Storage Management','2','129');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9797','StanfordWho Stanford Person Search','StanfordWho Stanford Person Search','2','128');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9796','StanfordWhat Stanford Network Search','StanfordWhat Stanford Network Search','2','127');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9795','Stanford West CATV','Stanford West CATV','2','126');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9794','Stanford Network Self-Registration','Stanford Network Self-Registration','2','125');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9793','Stanford Hospital Patient TV','Stanford Hospital Patient TV','2','124');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9792','Stanford Answers (KnowledgeBase Service)','Stanford Answers (KnowledgeBase Service)','2','123');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9791','SpectraLink Pocket Phones (Medical Center)','SpectraLink Pocket Phones (Medical Center)','2','122');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9790','Special Circuits','Special Circuits','2','121');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9789','Spam Tagging','Spam Tagging','2','120');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9788','Spam Deletion Tool','Spam Deletion Tool','2','119');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9787','Software','Software','2','118');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9786','SmartPage','SmartPage','2','117');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9785','Shibboleth','Shibboleth','2','116');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9784','Services from Other IT Providers (computing.stanford.edu)','Services from Other IT Providers (computing.stanford.edu)','2','115');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9783','Server Hosting','Server Hosting','2','114');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9782','Server Backup','Server Backup','2','113');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9781','Secure Email','Secure Email','2','112');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9780','Searching Stanford - Web Search','Searching Stanford - Web Search','2','111');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9779','RFP issuance','RFP issuance','2','110');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9778','Remote Dial Up - Sunsetting service','Remote Dial Up - Sunsetting service','2','109');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9777','Remedy Application','Remedy Application','2','108');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9776','Pubsw Software','Pubsw Software','2','107');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9775','PSTN','PSTN','2','106');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9774','Project Management','Project Management','2','105');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9773','Printing Resources','Printing Resources','2','104');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9772','Printing','Printing','2','103');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9771','PDA Community Support at Stanford','PDA Community Support at Stanford','2','102');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9770','PC-Leland','PC-Leland','2','101');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9769','PC Security Self-Help Tool','PC Security Self-Help Tool','2','100');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9768','Pathworks','Pathworks','2','99');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9767','Parallel virtual machine','Parallel virtual machine','2','98');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9766','Paging Services (Medical Center)','Paging Services (Medical Center)','2','97');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9765','OSP Design and Construction','OSP Design and Construction','2','96');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9764','OrderIT - Web Tool for Department IT Ordering &amp; Billing','OrderIT - Web Tool for Department IT Ordering &amp; Billing','2','95');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9763','Operator Services','Operator Services','2','94');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9762','OpenAFS','OpenAFS','2','93');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9761','Online Card Access','Online Card Access','2','92');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9760','On-call Computer Consulting','On-call Computer Consulting','2','91');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9759','Off line card access','Off line card access','2','90');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9758','New Service Listing #2','New Service Listing #2','2','89');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9757','New Service','New Service','2','88');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9756','New Faculty Orientation','New Faculty Orientation','2','87');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9755','Network Connections','Network Connections','2','86');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9754','NetDB','NetDB','2','85');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9753','Net-to-Switch Service','Net-to-Switch Service','2','84');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9752','Net-to-Jack Service','Net-to-Jack Service','2','83');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9751','MySQL Database Hosting','MySQL Database Hosting','2','82');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9750','My IT Services Site','My IT Services Site','2','81');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9749','Modem Pool Stanford Dial-up Service','Modem Pool Stanford Dial-up Service','2','80');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9748','Meal Plans','Meal Plans','2','79');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9747','Mac-Leland','Mac-Leland','2','78');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9746','Long-Reach Ethernet','Long-Reach Ethernet','2','77');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9745','Load Balancing','Load Balancing','2','76');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9744','LNA Local Network Administrator','LNA Local Network Administrator','2','75');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9743','LNA Guide','LNA Guide','2','74');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9742','List Services','List Services','2','73');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9741','Licensed Software','Licensed Software','2','72');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9740','Lab and Training Facilities','Lab and Training Facilities','2','71');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9739','Kerberos','Kerberos','2','70');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9738','IT Services Course Support','IT Services Course Support','2','69');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9737','IT Open House','IT Open House','2','68');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9736','IT Help Desk (Tier 2) - Technical Analysts','IT Help Desk (Tier 2) - Technical Analysts','2','67');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9735','IT Help Desk (Tier 1)','IT Help Desk (Tier 1)','2','66');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9734','IT Help Desk','IT Help Desk','2','65');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9733','ISDN','ISDN','2','64');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9732','iPass','iPass','2','63');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9731','Internet2','Internet2','2','62');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9730','Incident Response','Incident Response','2','61');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9729','IMAP Email','IMAP Email','2','60');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9728','Identity card','Identity card','2','59');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9727','Hosted Storage','Hosted Storage','2','58');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9726','HelpSU (Stanford Help Request System)','HelpSU (Stanford Help Request System)','2','57');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9725','Formage','Formage','2','56');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9724','Firewalls - Departmental (Project)','Firewalls - Departmental (Project)','2','55');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9723','Firewalls - Administrative and Custom','Firewalls - Administrative and Custom','2','54');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9722','Feature Options','Feature Options','2','53');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9721','Fax Lines','Fax Lines','2','52');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9720','Facilities: Computing','Facilities: Computing','2','51');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9719','Essential Stanford Software ESS','Essential Stanford Software ESS','2','50');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9718','Entitlements','Entitlements','2','49');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9717','Email','Email','2','48');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9716','ECP Enhanced Call Processing','ECP Enhanced Call Processing','2','47');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9715','eCommerce','eCommerce','2','46');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9714','E911 emergency call service','E911 emergency call service','2','45');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9713','DSL Service','DSL Service','2','44');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9712','DSL for Students','DSL for Students','2','43');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9711','DSL for Faculty/Staff','DSL for Faculty/Staff','2','42');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9710','DocuShare','DocuShare','2','41');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9709','Documentation support','Documentation support','2','40');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9708','Discussion Groups for Courses (Online)','Discussion Groups for Courses (Online)','2','39');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9707','Directory Services (OpenLDAP)','Directory Services (OpenLDAP)','2','38');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9706','Dial Tone','Dial Tone','2','37');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9705','Departmental compute servers','Departmental compute servers','2','36');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9704','Dell Purchase Program','Dell Purchase Program','2','35');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9703','Debit Plan','Debit Plan','2','34');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9702','Database Services','Database Services','2','33');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9701','Contract Support: Computer Resource Consulting','Contract Support: Computer Resource Consulting','2','32');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9700','Consulting','Consulting','2','31');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9699','Consulting','Consulting','2','30');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9698','Construction Management','Construction Management','2','29');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9697','Cluster Systems','Cluster Systems','2','28');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9696','Classrooms with Technology Enhancements','Classrooms with Technology Enhancements','2','27');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9695','CIFS','CIFS','2','26');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9694','Child Domain service','Child Domain service','2','25');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9693','Change Management System','Change Management System','2','24');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9692','CHaMP Campus Hardware Maintenance Program','CHaMP Campus Hardware Maintenance Program','2','23');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9691','CGI Services','CGI Services','2','22');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9687','Card Services','Card Services','2','18');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9688','Cell Phone','Cell Phone','2','19');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9689','Cellular Phones for Personal Use','Cellular Phones for Personal Use','2','20');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9690','Cellular Phones for University Business','Cellular Phones for University Business','2','21');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9686','Calling Cards','Calling Cards','2','17');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9685','Cable TV: Student Residential','Cable TV: Student Residential','2','16');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9684','Cable TV: Academic','Cable TV: Academic','2','15');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9683','Cable TV','Cable TV','2','14');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9681','Blog Software','Blog Software','2','12');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9682','Bulk email','Bulk email','2','13');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9679','Bible Sheets (CNSCAD)','Bible Sheets (CNSCAD)','2','10');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9680','Big Fix Patch Management','Big Fix Patch Management','2','11');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9678','Basic University Domain service','Basic University Domain service','2','9');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9677','Backup and Recovery for Servers','Backup and Recovery for Servers','2','8');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9676','Backup and Recovery for Desktops','Backup and Recovery for Desktops','2','7');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9675','Apple Purchase Program','Apple Purchase Program','2','6');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9674','Antivirus','Antivirus','2','5');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9673','AFS Disk Space/Storage','AFS Disk Space/Storage','2','4');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9672','AFS Andrew File System','AFS Andrew File System','2','3');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9671','ACD Automated Call Distribution (Enhanced)','ACD Automated Call Distribution (Enhanced)','2','2');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9670','ACD Automated Call Distribution','ACD Automated Call Distribution','2','1');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9669','800 Toll Free Service, 411 Directory information calls','800 Toll Free Service, 411 Directory information calls','2','0');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9827','VPN Virtual Private Network','VPN Virtual Private Network','2','158');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9828','Web Login','Web Login','2','159');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9829','Web Services','Web Services','2','160');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9830','WebAuth','WebAuth','2','161');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9831','WebEx','WebEx','2','162');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9832','Webmail','Webmail','2','163');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9833','Windows at Stanford','Windows at Stanford','2','164');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9834','Windows Infrastructure (Active Directory)','Windows Infrastructure (Active Directory)','2','165');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9835','Windows Server Infrastructure','Windows Server Infrastructure','2','166');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9836','Windows Systems Administration','Windows Systems Administration','2','167');
INSERT INTO `item` (`item_id`,`label`,`value`,`itemset_id`,`sort_order`) VALUES ('9837','Wireless Network and Services','Wireless Network and Services','2','168');


# Dump of table itemset
# ------------------------------------------------------------

DROP TABLE IF EXISTS `itemset`;

CREATE TABLE `itemset` (
  `itemset_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `label` varchar(1000) DEFAULT NULL,
  `is_custom` tinyint(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`itemset_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

INSERT INTO `itemset` (`itemset_id`,`label`,`is_custom`) VALUES ('1','countries','1');
INSERT INTO `itemset` (`itemset_id`,`label`,`is_custom`) VALUES ('2','ITS Services','1');

# Dump of table node
# ------------------------------------------------------------

DROP TABLE IF EXISTS `node`;

CREATE TABLE `node` (
  `node_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `form_id` int(11) unsigned DEFAULT NULL,
  `node_type` varchar(255) DEFAULT NULL,
  `sort_order` int(11) unsigned DEFAULT NULL,
  `element_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`node_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



# Dump of table user
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `user_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `max_forms` int(4) DEFAULT NULL,
  `is_active` tinyint(4) unsigned NOT NULL DEFAULT '1',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `unique_identifier` (`identifier`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



# Dump of table user_form
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user_form`;

CREATE TABLE `user_form` (
  `form` int(11) unsigned NOT NULL DEFAULT '0',
  `role` varchar(255) DEFAULT NULL,
  `user` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`form`,`user`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
