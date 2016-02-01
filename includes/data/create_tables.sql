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
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

# Dump of table itemset
# ------------------------------------------------------------

DROP TABLE IF EXISTS `itemset`;

CREATE TABLE `itemset` (
  `itemset_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `label` varchar(1000) DEFAULT NULL,
  `is_custom` tinyint(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`itemset_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

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
