# ************************************************************
# Sequel Pro SQL dump
# Version 3447
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: localhost (MySQL 5.1.46)
# Database: pcard_development
# Generation Time: 2011-10-19 02:18:22 +0800
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table attachments
# ------------------------------------------------------------

DROP TABLE IF EXISTS `attachments`;

CREATE TABLE `attachments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `container_id` int(11) NOT NULL DEFAULT '0',
  `container_type` varchar(30) NOT NULL DEFAULT '',
  `filename` varchar(255) NOT NULL DEFAULT '',
  `disk_filename` varchar(255) NOT NULL DEFAULT '',
  `filesize` int(11) NOT NULL DEFAULT '0',
  `content_type` varchar(255) DEFAULT '',
  `digest` varchar(40) NOT NULL DEFAULT '',
  `downloads` int(11) NOT NULL DEFAULT '0',
  `author_id` int(11) NOT NULL DEFAULT '0',
  `created_on` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_attachments_on_container_id_and_container_type` (`container_id`,`container_type`),
  KEY `index_attachments_on_author_id` (`author_id`),
  KEY `index_attachments_on_created_on` (`created_on`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table auth_sources
# ------------------------------------------------------------

DROP TABLE IF EXISTS `auth_sources`;

CREATE TABLE `auth_sources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(30) NOT NULL DEFAULT '',
  `name` varchar(60) NOT NULL DEFAULT '',
  `host` varchar(60) DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  `account` varchar(255) DEFAULT NULL,
  `account_password` varchar(255) DEFAULT '',
  `base_dn` varchar(255) DEFAULT NULL,
  `attr_login` varchar(30) DEFAULT NULL,
  `attr_firstname` varchar(30) DEFAULT NULL,
  `attr_lastname` varchar(30) DEFAULT NULL,
  `attr_mail` varchar(30) DEFAULT NULL,
  `onthefly_register` tinyint(1) NOT NULL DEFAULT '0',
  `tls` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_auth_sources_on_id_and_type` (`id`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table boards
# ------------------------------------------------------------

DROP TABLE IF EXISTS `boards`;

CREATE TABLE `boards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) DEFAULT NULL,
  `position` int(11) DEFAULT '1',
  `topics_count` int(11) NOT NULL DEFAULT '0',
  `messages_count` int(11) NOT NULL DEFAULT '0',
  `last_message_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `boards_project_id` (`project_id`),
  KEY `index_boards_on_last_message_id` (`last_message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table changes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `changes`;

CREATE TABLE `changes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `changeset_id` int(11) NOT NULL,
  `action` varchar(1) NOT NULL DEFAULT '',
  `path` text NOT NULL,
  `from_path` text,
  `from_revision` varchar(255) DEFAULT NULL,
  `revision` varchar(255) DEFAULT NULL,
  `branch` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `changesets_changeset_id` (`changeset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table changesets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `changesets`;

CREATE TABLE `changesets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `repository_id` int(11) NOT NULL,
  `revision` varchar(255) NOT NULL,
  `committer` varchar(255) DEFAULT NULL,
  `committed_on` datetime NOT NULL,
  `comments` text,
  `commit_date` date DEFAULT NULL,
  `scmid` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `changesets_repos_rev` (`repository_id`,`revision`),
  KEY `index_changesets_on_user_id` (`user_id`),
  KEY `index_changesets_on_repository_id` (`repository_id`),
  KEY `index_changesets_on_committed_on` (`committed_on`),
  KEY `changesets_repos_scmid` (`repository_id`,`scmid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table changesets_issues
# ------------------------------------------------------------

DROP TABLE IF EXISTS `changesets_issues`;

CREATE TABLE `changesets_issues` (
  `changeset_id` int(11) NOT NULL,
  `issue_id` int(11) NOT NULL,
  UNIQUE KEY `changesets_issues_ids` (`changeset_id`,`issue_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table comments
# ------------------------------------------------------------

DROP TABLE IF EXISTS `comments`;

CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `commented_type` varchar(30) NOT NULL DEFAULT '',
  `commented_id` int(11) NOT NULL DEFAULT '0',
  `author_id` int(11) NOT NULL DEFAULT '0',
  `comments` text,
  `created_on` datetime NOT NULL,
  `updated_on` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_comments_on_commented_id_and_commented_type` (`commented_id`,`commented_type`),
  KEY `index_comments_on_author_id` (`author_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table custom_fields
# ------------------------------------------------------------

DROP TABLE IF EXISTS `custom_fields`;

CREATE TABLE `custom_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(30) NOT NULL DEFAULT '',
  `name` varchar(30) NOT NULL DEFAULT '',
  `field_format` varchar(30) NOT NULL DEFAULT '',
  `possible_values` text,
  `regexp` varchar(255) DEFAULT '',
  `min_length` int(11) NOT NULL DEFAULT '0',
  `max_length` int(11) NOT NULL DEFAULT '0',
  `is_required` tinyint(1) NOT NULL DEFAULT '0',
  `is_for_all` tinyint(1) NOT NULL DEFAULT '0',
  `is_filter` tinyint(1) NOT NULL DEFAULT '0',
  `position` int(11) DEFAULT '1',
  `searchable` tinyint(1) DEFAULT '0',
  `default_value` text,
  `editable` tinyint(1) DEFAULT '1',
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `index_custom_fields_on_id_and_type` (`id`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `custom_fields` WRITE;
/*!40000 ALTER TABLE `custom_fields` DISABLE KEYS */;

INSERT INTO `custom_fields` (`id`, `type`, `name`, `field_format`, `possible_values`, `regexp`, `min_length`, `max_length`, `is_required`, `is_for_all`, `is_filter`, `position`, `searchable`, `default_value`, `editable`, `visible`)
VALUES
	(2,'IssueCustomField','唯一编号','string','--- []\n\n','^\\d{11}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$',15,15,1,0,1,1,1,'',1,1),
	(3,'IssueCustomField','头像数量','int','--- []\n\n','^\\d+$',0,2,0,0,1,2,0,'1',1,1);

/*!40000 ALTER TABLE `custom_fields` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table custom_fields_projects
# ------------------------------------------------------------

DROP TABLE IF EXISTS `custom_fields_projects`;

CREATE TABLE `custom_fields_projects` (
  `custom_field_id` int(11) NOT NULL DEFAULT '0',
  `project_id` int(11) NOT NULL DEFAULT '0',
  KEY `index_custom_fields_projects_on_custom_field_id_and_project_id` (`custom_field_id`,`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `custom_fields_projects` WRITE;
/*!40000 ALTER TABLE `custom_fields_projects` DISABLE KEYS */;

INSERT INTO `custom_fields_projects` (`custom_field_id`, `project_id`)
VALUES
	(2,1),
	(3,1);

/*!40000 ALTER TABLE `custom_fields_projects` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table custom_fields_trackers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `custom_fields_trackers`;

CREATE TABLE `custom_fields_trackers` (
  `custom_field_id` int(11) NOT NULL DEFAULT '0',
  `tracker_id` int(11) NOT NULL DEFAULT '0',
  KEY `index_custom_fields_trackers_on_custom_field_id_and_tracker_id` (`custom_field_id`,`tracker_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `custom_fields_trackers` WRITE;
/*!40000 ALTER TABLE `custom_fields_trackers` DISABLE KEYS */;

INSERT INTO `custom_fields_trackers` (`custom_field_id`, `tracker_id`)
VALUES
	(2,1),
	(2,2),
	(2,3),
	(2,4),
	(2,5),
	(3,1),
	(3,2),
	(3,3),
	(3,4);

/*!40000 ALTER TABLE `custom_fields_trackers` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table custom_values
# ------------------------------------------------------------

DROP TABLE IF EXISTS `custom_values`;

CREATE TABLE `custom_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customized_type` varchar(30) NOT NULL DEFAULT '',
  `customized_id` int(11) NOT NULL DEFAULT '0',
  `custom_field_id` int(11) NOT NULL DEFAULT '0',
  `value` text,
  PRIMARY KEY (`id`),
  KEY `custom_values_customized` (`customized_type`,`customized_id`),
  KEY `index_custom_values_on_custom_field_id` (`custom_field_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table documents
# ------------------------------------------------------------

DROP TABLE IF EXISTS `documents`;

CREATE TABLE `documents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL DEFAULT '0',
  `category_id` int(11) NOT NULL DEFAULT '0',
  `title` varchar(60) NOT NULL DEFAULT '',
  `description` text,
  `created_on` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `documents_project_id` (`project_id`),
  KEY `index_documents_on_category_id` (`category_id`),
  KEY `index_documents_on_created_on` (`created_on`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table enabled_modules
# ------------------------------------------------------------

DROP TABLE IF EXISTS `enabled_modules`;

CREATE TABLE `enabled_modules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `enabled_modules_project_id` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `enabled_modules` WRITE;
/*!40000 ALTER TABLE `enabled_modules` DISABLE KEYS */;

INSERT INTO `enabled_modules` (`id`, `project_id`, `name`)
VALUES
	(1,1,'issue_tracking'),
	(2,1,'time_tracking'),
	(3,1,'news'),
	(4,1,'documents'),
	(5,1,'files'),
	(6,1,'wiki'),
	(8,1,'boards'),
	(9,1,'calendar'),
	(10,1,'gantt');

/*!40000 ALTER TABLE `enabled_modules` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table enumerations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `enumerations`;

CREATE TABLE `enumerations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL DEFAULT '',
  `position` int(11) DEFAULT '1',
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `type` varchar(255) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `project_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_enumerations_on_project_id` (`project_id`),
  KEY `index_enumerations_on_id_and_type` (`id`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `enumerations` WRITE;
/*!40000 ALTER TABLE `enumerations` DISABLE KEYS */;

INSERT INTO `enumerations` (`id`, `name`, `position`, `is_default`, `type`, `active`, `project_id`, `parent_id`)
VALUES
	(1,'用户文档',1,0,'DocumentCategory',1,NULL,NULL),
	(2,'技术文档',2,0,'DocumentCategory',1,NULL,NULL),
	(3,'低',1,0,'IssuePriority',1,NULL,NULL),
	(4,'普通',2,1,'IssuePriority',1,NULL,NULL),
	(5,'高',3,0,'IssuePriority',1,NULL,NULL),
	(6,'紧急',4,0,'IssuePriority',1,NULL,NULL),
	(7,'立刻',5,0,'IssuePriority',1,NULL,NULL),
	(8,'设计',2,0,'TimeEntryActivity',1,NULL,NULL),
	(9,'沟通',3,0,'TimeEntryActivity',1,NULL,NULL),
	(10,'调研',1,0,'TimeEntryActivity',1,NULL,NULL);

/*!40000 ALTER TABLE `enumerations` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table groups_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `groups_users`;

CREATE TABLE `groups_users` (
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  UNIQUE KEY `groups_users_ids` (`group_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table issue_categories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `issue_categories`;

CREATE TABLE `issue_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(30) NOT NULL DEFAULT '',
  `assigned_to_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `issue_categories_project_id` (`project_id`),
  KEY `index_issue_categories_on_assigned_to_id` (`assigned_to_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `issue_categories` WRITE;
/*!40000 ALTER TABLE `issue_categories` DISABLE KEYS */;

INSERT INTO `issue_categories` (`id`, `project_id`, `name`, `assigned_to_id`)
VALUES
	(1,1,'手绘Q图版',NULL),
	(2,1,'场景版',NULL),
	(3,1,'图库自选版',NULL),
	(4,1,'客户上传版',NULL);

/*!40000 ALTER TABLE `issue_categories` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table issue_relations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `issue_relations`;

CREATE TABLE `issue_relations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `issue_from_id` int(11) NOT NULL,
  `issue_to_id` int(11) NOT NULL,
  `relation_type` varchar(255) NOT NULL DEFAULT '',
  `delay` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_issue_relations_on_issue_from_id` (`issue_from_id`),
  KEY `index_issue_relations_on_issue_to_id` (`issue_to_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table issue_statuses
# ------------------------------------------------------------

DROP TABLE IF EXISTS `issue_statuses`;

CREATE TABLE `issue_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL DEFAULT '',
  `is_closed` tinyint(1) NOT NULL DEFAULT '0',
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `position` int(11) DEFAULT '1',
  `default_done_ratio` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_issue_statuses_on_position` (`position`),
  KEY `index_issue_statuses_on_is_closed` (`is_closed`),
  KEY `index_issue_statuses_on_is_default` (`is_default`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `issue_statuses` WRITE;
/*!40000 ALTER TABLE `issue_statuses` DISABLE KEYS */;

INSERT INTO `issue_statuses` (`id`, `name`, `is_closed`, `is_default`, `position`, `default_done_ratio`)
VALUES
	(10,'待审核',0,1,1,NULL),
	(20,'图片审核中',0,0,2,NULL),
	(30,'图片审核不通过',1,0,6,NULL),
	(40,'制图中',0,0,3,NULL),
	(50,'制图成功',1,0,4,NULL),
	(60,'制图失败',1,0,5,NULL);

/*!40000 ALTER TABLE `issue_statuses` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table issues
# ------------------------------------------------------------

DROP TABLE IF EXISTS `issues`;

CREATE TABLE `issues` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tracker_id` int(11) NOT NULL DEFAULT '0',
  `project_id` int(11) NOT NULL DEFAULT '0',
  `subject` varchar(255) NOT NULL DEFAULT '',
  `description` text,
  `due_date` date DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `status_id` int(11) NOT NULL DEFAULT '0',
  `assigned_to_id` int(11) DEFAULT NULL,
  `priority_id` int(11) NOT NULL DEFAULT '0',
  `fixed_version_id` int(11) DEFAULT NULL,
  `author_id` int(11) NOT NULL DEFAULT '0',
  `lock_version` int(11) NOT NULL DEFAULT '0',
  `created_on` datetime DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `done_ratio` int(11) NOT NULL DEFAULT '0',
  `estimated_hours` float DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `root_id` int(11) DEFAULT NULL,
  `lft` int(11) DEFAULT NULL,
  `rgt` int(11) DEFAULT NULL,
  `is_private` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `issues_project_id` (`project_id`),
  KEY `index_issues_on_status_id` (`status_id`),
  KEY `index_issues_on_category_id` (`category_id`),
  KEY `index_issues_on_assigned_to_id` (`assigned_to_id`),
  KEY `index_issues_on_fixed_version_id` (`fixed_version_id`),
  KEY `index_issues_on_tracker_id` (`tracker_id`),
  KEY `index_issues_on_priority_id` (`priority_id`),
  KEY `index_issues_on_author_id` (`author_id`),
  KEY `index_issues_on_created_on` (`created_on`),
  KEY `index_issues_on_root_id_and_lft_and_rgt` (`root_id`,`lft`,`rgt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table journal_details
# ------------------------------------------------------------

DROP TABLE IF EXISTS `journal_details`;

CREATE TABLE `journal_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `journal_id` int(11) NOT NULL DEFAULT '0',
  `property` varchar(30) NOT NULL DEFAULT '',
  `prop_key` varchar(30) NOT NULL DEFAULT '',
  `old_value` text,
  `value` text,
  PRIMARY KEY (`id`),
  KEY `journal_details_journal_id` (`journal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table journals
# ------------------------------------------------------------

DROP TABLE IF EXISTS `journals`;

CREATE TABLE `journals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `journalized_id` int(11) NOT NULL DEFAULT '0',
  `journalized_type` varchar(30) NOT NULL DEFAULT '',
  `user_id` int(11) NOT NULL DEFAULT '0',
  `notes` text,
  `created_on` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `journals_journalized_id` (`journalized_id`,`journalized_type`),
  KEY `index_journals_on_user_id` (`user_id`),
  KEY `index_journals_on_journalized_id` (`journalized_id`),
  KEY `index_journals_on_created_on` (`created_on`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table member_roles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `member_roles`;

CREATE TABLE `member_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `inherited_from` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_member_roles_on_member_id` (`member_id`),
  KEY `index_member_roles_on_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `member_roles` WRITE;
/*!40000 ALTER TABLE `member_roles` DISABLE KEYS */;

INSERT INTO `member_roles` (`id`, `member_id`, `role_id`, `inherited_from`)
VALUES
	(1,1,8,NULL),
	(2,2,6,NULL),
	(3,3,7,NULL),
	(4,4,3,NULL);

/*!40000 ALTER TABLE `member_roles` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table members
# ------------------------------------------------------------

DROP TABLE IF EXISTS `members`;

CREATE TABLE `members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `project_id` int(11) NOT NULL DEFAULT '0',
  `created_on` datetime DEFAULT NULL,
  `mail_notification` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_members_on_user_id_and_project_id` (`user_id`,`project_id`),
  KEY `index_members_on_user_id` (`user_id`),
  KEY `index_members_on_project_id` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;

INSERT INTO `members` (`id`, `user_id`, `project_id`, `created_on`, `mail_notification`)
VALUES
	(1,6,1,'2011-09-30 16:17:21',0),
	(2,5,1,'2011-09-30 16:17:43',0),
	(3,7,1,'2011-09-30 16:18:40',0),
	(4,3,1,'2011-10-19 01:23:09',0);

/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table messages
# ------------------------------------------------------------

DROP TABLE IF EXISTS `messages`;

CREATE TABLE `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `board_id` int(11) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `subject` varchar(255) NOT NULL DEFAULT '',
  `content` text,
  `author_id` int(11) DEFAULT NULL,
  `replies_count` int(11) NOT NULL DEFAULT '0',
  `last_reply_id` int(11) DEFAULT NULL,
  `created_on` datetime NOT NULL,
  `updated_on` datetime NOT NULL,
  `locked` tinyint(1) DEFAULT '0',
  `sticky` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `messages_board_id` (`board_id`),
  KEY `messages_parent_id` (`parent_id`),
  KEY `index_messages_on_last_reply_id` (`last_reply_id`),
  KEY `index_messages_on_author_id` (`author_id`),
  KEY `index_messages_on_created_on` (`created_on`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table news
# ------------------------------------------------------------

DROP TABLE IF EXISTS `news`;

CREATE TABLE `news` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `title` varchar(60) NOT NULL DEFAULT '',
  `summary` varchar(255) DEFAULT '',
  `description` text,
  `author_id` int(11) NOT NULL DEFAULT '0',
  `created_on` datetime DEFAULT NULL,
  `comments_count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `news_project_id` (`project_id`),
  KEY `index_news_on_author_id` (`author_id`),
  KEY `index_news_on_created_on` (`created_on`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table open_id_authentication_associations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `open_id_authentication_associations`;

CREATE TABLE `open_id_authentication_associations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `issued` int(11) DEFAULT NULL,
  `lifetime` int(11) DEFAULT NULL,
  `handle` varchar(255) DEFAULT NULL,
  `assoc_type` varchar(255) DEFAULT NULL,
  `server_url` blob,
  `secret` blob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table open_id_authentication_nonces
# ------------------------------------------------------------

DROP TABLE IF EXISTS `open_id_authentication_nonces`;

CREATE TABLE `open_id_authentication_nonces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` int(11) NOT NULL,
  `server_url` varchar(255) DEFAULT NULL,
  `salt` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table projects
# ------------------------------------------------------------

DROP TABLE IF EXISTS `projects`;

CREATE TABLE `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` text,
  `homepage` varchar(255) DEFAULT '',
  `is_public` tinyint(1) NOT NULL DEFAULT '1',
  `parent_id` int(11) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `identifier` varchar(255) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  `lft` int(11) DEFAULT NULL,
  `rgt` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_projects_on_lft` (`lft`),
  KEY `index_projects_on_rgt` (`rgt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;

INSERT INTO `projects` (`id`, `name`, `description`, `homepage`, `is_public`, `parent_id`, `created_on`, `updated_on`, `identifier`, `status`, `lft`, `rgt`)
VALUES
	(1,'浦发个性信用卡','浦发个性信用卡：工作流及任务管理系统','',0,NULL,'2011-09-30 13:19:26','2011-09-30 13:27:45','pcard',1,1,2);

/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table projects_trackers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `projects_trackers`;

CREATE TABLE `projects_trackers` (
  `project_id` int(11) NOT NULL DEFAULT '0',
  `tracker_id` int(11) NOT NULL DEFAULT '0',
  UNIQUE KEY `projects_trackers_unique` (`project_id`,`tracker_id`),
  KEY `projects_trackers_project_id` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `projects_trackers` WRITE;
/*!40000 ALTER TABLE `projects_trackers` DISABLE KEYS */;

INSERT INTO `projects_trackers` (`project_id`, `tracker_id`)
VALUES
	(1,1),
	(1,2),
	(1,3),
	(1,4);

/*!40000 ALTER TABLE `projects_trackers` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table queries
# ------------------------------------------------------------

DROP TABLE IF EXISTS `queries`;

CREATE TABLE `queries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `filters` text,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `is_public` tinyint(1) NOT NULL DEFAULT '0',
  `column_names` text,
  `sort_criteria` text,
  `group_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_queries_on_project_id` (`project_id`),
  KEY `index_queries_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table repositories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `repositories`;

CREATE TABLE `repositories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL DEFAULT '0',
  `url` varchar(255) NOT NULL DEFAULT '',
  `login` varchar(60) DEFAULT '',
  `password` varchar(255) DEFAULT '',
  `root_url` varchar(255) DEFAULT '',
  `type` varchar(255) DEFAULT NULL,
  `path_encoding` varchar(64) DEFAULT NULL,
  `log_encoding` varchar(64) DEFAULT NULL,
  `extra_info` text,
  PRIMARY KEY (`id`),
  KEY `index_repositories_on_project_id` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table roles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `roles`;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL DEFAULT '',
  `position` int(11) DEFAULT '1',
  `assignable` tinyint(1) DEFAULT '1',
  `builtin` int(11) NOT NULL DEFAULT '0',
  `permissions` text,
  `issues_visibility` varchar(30) NOT NULL DEFAULT 'default',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;

INSERT INTO `roles` (`id`, `name`, `position`, `assignable`, `builtin`, `permissions`, `issues_visibility`)
VALUES
	(1,'Non member',1,1,1,'--- \n- :view_issues\n- :add_issues\n- :add_issue_notes\n- :save_queries\n- :view_gantt\n- :view_calendar\n- :view_time_entries\n- :comment_news\n- :view_documents\n- :view_wiki_pages\n- :view_wiki_edits\n- :add_messages\n- :view_files\n- :browse_repository\n- :view_changesets\n','default'),
	(2,'Anonymous',2,1,2,'--- []\n\n','default'),
	(3,'系统管理员',3,1,0,'--- \n- :add_project\n- :edit_project\n- :select_project_modules\n- :manage_members\n- :manage_versions\n- :add_subprojects\n- :manage_boards\n- :add_messages\n- :edit_messages\n- :edit_own_messages\n- :delete_messages\n- :delete_own_messages\n- :view_calendar\n- :manage_documents\n- :view_documents\n- :manage_files\n- :view_files\n- :view_gantt\n- :manage_categories\n- :view_issues\n- :add_issues\n- :edit_issues\n- :manage_issue_relations\n- :manage_subtasks\n- :set_issues_private\n- :set_own_issues_private\n- :add_issue_notes\n- :edit_issue_notes\n- :edit_own_issue_notes\n- :move_issues\n- :delete_issues\n- :manage_public_queries\n- :save_queries\n- :view_issue_watchers\n- :add_issue_watchers\n- :delete_issue_watchers\n- :manage_news\n- :comment_news\n- :manage_repository\n- :browse_repository\n- :view_changesets\n- :commit_access\n- :log_time\n- :view_time_entries\n- :edit_time_entries\n- :edit_own_time_entries\n- :manage_project_activities\n- :manage_wiki\n- :rename_wiki_pages\n- :delete_wiki_pages\n- :view_wiki_pages\n- :export_wiki_pages\n- :view_wiki_edits\n- :edit_wiki_pages\n- :delete_wiki_pages_attachments\n- :protect_wiki_pages\n','all'),
	(6,'项目管理员',4,1,0,'--- \n- :manage_members\n- :manage_boards\n- :add_messages\n- :edit_messages\n- :edit_own_messages\n- :delete_messages\n- :delete_own_messages\n- :view_calendar\n- :manage_documents\n- :view_documents\n- :manage_files\n- :view_files\n- :view_gantt\n- :view_issues\n- :add_issues\n- :edit_issues\n- :manage_issue_relations\n- :manage_subtasks\n- :set_issues_private\n- :set_own_issues_private\n- :add_issue_notes\n- :edit_issue_notes\n- :edit_own_issue_notes\n- :move_issues\n- :delete_issues\n- :manage_public_queries\n- :save_queries\n- :view_issue_watchers\n- :add_issue_watchers\n- :delete_issue_watchers\n- :manage_news\n- :comment_news\n- :log_time\n- :view_time_entries\n- :edit_time_entries\n- :edit_own_time_entries\n- :manage_project_activities\n- :manage_wiki\n- :rename_wiki_pages\n- :delete_wiki_pages\n- :view_wiki_pages\n- :export_wiki_pages\n- :view_wiki_edits\n- :edit_wiki_pages\n- :delete_wiki_pages_attachments\n- :protect_wiki_pages\n','default'),
	(7,'设计师',5,1,0,'--- \n- :add_messages\n- :edit_own_messages\n- :view_calendar\n- :view_documents\n- :view_files\n- :view_gantt\n- :view_issues\n- :edit_issues\n- :add_issue_notes\n- :edit_issue_notes\n- :edit_own_issue_notes\n- :save_queries\n- :view_issue_watchers\n- :add_issue_watchers\n- :delete_issue_watchers\n- :comment_news\n- :log_time\n- :view_time_entries\n- :edit_time_entries\n- :edit_own_time_entries\n- :view_wiki_pages\n- :view_wiki_edits\n','own'),
	(8,'客服',6,1,0,'--- \n- :add_messages\n- :edit_own_messages\n- :view_calendar\n- :view_documents\n- :view_files\n- :view_gantt\n- :view_issues\n- :edit_issues\n- :add_issue_notes\n- :edit_issue_notes\n- :edit_own_issue_notes\n- :view_issue_watchers\n- :add_issue_watchers\n- :delete_issue_watchers\n- :comment_news\n- :log_time\n- :view_time_entries\n- :edit_time_entries\n- :edit_own_time_entries\n- :view_wiki_pages\n- :view_wiki_edits\n','own');

/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table schema_migrations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `schema_migrations`;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;

INSERT INTO `schema_migrations` (`version`)
VALUES
	('1'),
	('10'),
	('100'),
	('101'),
	('102'),
	('103'),
	('104'),
	('105'),
	('106'),
	('107'),
	('108'),
	('11'),
	('12'),
	('13'),
	('14'),
	('15'),
	('16'),
	('17'),
	('18'),
	('19'),
	('2'),
	('20'),
	('20090214190337'),
	('20090312172426'),
	('20090312194159'),
	('20090318181151'),
	('20090323224724'),
	('20090401221305'),
	('20090401231134'),
	('20090403001910'),
	('20090406161854'),
	('20090425161243'),
	('20090503121501'),
	('20090503121505'),
	('20090503121510'),
	('20090614091200'),
	('20090704172350'),
	('20090704172355'),
	('20090704172358'),
	('20091010093521'),
	('20091017212227'),
	('20091017212457'),
	('20091017212644'),
	('20091017212938'),
	('20091017213027'),
	('20091017213113'),
	('20091017213151'),
	('20091017213228'),
	('20091017213257'),
	('20091017213332'),
	('20091017213444'),
	('20091017213536'),
	('20091017213642'),
	('20091017213716'),
	('20091017213757'),
	('20091017213835'),
	('20091017213910'),
	('20091017214015'),
	('20091017214107'),
	('20091017214136'),
	('20091017214236'),
	('20091017214308'),
	('20091017214336'),
	('20091017214406'),
	('20091017214440'),
	('20091017214519'),
	('20091017214611'),
	('20091017214644'),
	('20091017214720'),
	('20091017214750'),
	('20091025163651'),
	('20091108092559'),
	('20091114105931'),
	('20091123212029'),
	('20091205124427'),
	('20091220183509'),
	('20091220183727'),
	('20091220184736'),
	('20091225164732'),
	('20091227112908'),
	('20100129193402'),
	('20100129193813'),
	('20100221100219'),
	('20100313132032'),
	('20100313171051'),
	('20100705164950'),
	('20100819172912'),
	('20101104182107'),
	('20101107130441'),
	('20101114115114'),
	('20101114115359'),
	('20110220160626'),
	('20110223180944'),
	('20110223180953'),
	('20110224000000'),
	('20110226120112'),
	('20110226120132'),
	('20110227125750'),
	('20110228000000'),
	('20110228000100'),
	('20110401192910'),
	('20110408103312'),
	('20110412065600'),
	('20110511000000'),
	('20111017172219'),
	('21'),
	('22'),
	('23'),
	('24'),
	('25'),
	('26'),
	('27'),
	('28'),
	('29'),
	('3'),
	('30'),
	('31'),
	('32'),
	('33'),
	('34'),
	('35'),
	('36'),
	('37'),
	('38'),
	('39'),
	('4'),
	('40'),
	('41'),
	('42'),
	('43'),
	('44'),
	('45'),
	('46'),
	('47'),
	('48'),
	('49'),
	('5'),
	('50'),
	('51'),
	('52'),
	('53'),
	('54'),
	('55'),
	('56'),
	('57'),
	('58'),
	('59'),
	('6'),
	('60'),
	('61'),
	('62'),
	('63'),
	('64'),
	('65'),
	('66'),
	('67'),
	('68'),
	('69'),
	('7'),
	('70'),
	('71'),
	('72'),
	('73'),
	('74'),
	('75'),
	('76'),
	('77'),
	('78'),
	('79'),
	('8'),
	('80'),
	('81'),
	('82'),
	('83'),
	('84'),
	('85'),
	('86'),
	('87'),
	('88'),
	('89'),
	('9'),
	('90'),
	('91'),
	('92'),
	('93'),
	('94'),
	('95'),
	('96'),
	('97'),
	('98'),
	('99');

/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table settings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `settings`;

CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `value` text,
  `updated_on` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_settings_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;

INSERT INTO `settings` (`id`, `name`, `value`, `updated_on`)
VALUES
	(1,'attachment_max_size','12240','2011-09-30 13:08:16'),
	(2,'per_page_options','25,50,100','2011-09-30 13:08:16'),
	(3,'diff_max_lines_displayed','1500','2011-09-30 13:08:16'),
	(4,'app_title','浦发个性信用卡：工作流及任务管理系统','2011-09-30 13:08:16'),
	(5,'host_name','pcard.koocaa.com','2011-09-30 13:08:16'),
	(6,'text_formatting','textile','2011-09-30 13:08:16'),
	(7,'welcome_text','欢迎使用【浦发个性信用卡：工作流及任务管理系统】','2011-09-30 13:08:16'),
	(8,'protocol','http','2011-09-30 13:08:16'),
	(9,'file_max_size_displayed','512','2011-09-30 13:08:16'),
	(10,'activity_days_default','30','2011-09-30 13:08:16'),
	(11,'feeds_limit','15','2011-09-30 13:08:16'),
	(12,'cache_formatted_text','0','2011-09-30 13:08:16'),
	(13,'wiki_compression','','2011-09-30 13:08:16'),
	(14,'time_format','%H:%M','2011-09-30 13:58:02'),
	(15,'start_of_week','1','2011-09-30 13:58:02'),
	(16,'ui_theme','basecamp','2011-09-30 13:10:52'),
	(17,'gravatar_default','wavatar','2011-09-30 13:10:52'),
	(18,'date_format','%Y-%m-%d','2011-09-30 13:58:02'),
	(19,'gravatar_enabled','1','2011-09-30 13:10:52'),
	(20,'default_language','zh','2011-09-30 13:10:52'),
	(21,'user_format','lastname_firstname','2011-09-30 13:56:11'),
	(22,'sequential_project_identifiers','0','2011-09-30 13:14:24'),
	(23,'default_projects_modules','--- \n- issue_tracking\n- time_tracking\n- news\n- documents\n- files\n- wiki\n- boards\n- calendar\n- gantt\n','2011-09-30 13:39:52'),
	(24,'default_projects_public','0','2011-10-19 01:41:21'),
	(25,'cross_project_issue_relations','0','2011-09-30 13:16:26'),
	(26,'issues_export_limit','500','2011-09-30 13:16:26'),
	(27,'gantt_items_limit','500','2011-09-30 13:16:26'),
	(28,'issue_group_assignment','0','2011-09-30 13:16:26'),
	(29,'issue_done_ratio','issue_field','2011-09-30 13:16:26'),
	(30,'display_subprojects_issues','1','2011-09-30 13:16:26'),
	(31,'issue_list_default_columns','--- \n- tracker\n- status\n- priority\n- subject\n- assigned_to\n- updated_on\n- category\n- cf_2\n','2011-10-19 01:43:37'),
	(32,'emails_footer','您接收到本邮件，是由于您或者订阅了它，或者是本邮件内容与您有关。如果你需要修改邮件通知偏好，请点击这里：http://pcard.koocaa.com/my/account','2011-09-30 13:18:04'),
	(33,'default_notification_option','only_my_events','2011-09-30 13:18:04'),
	(34,'mail_from','pcard-robot@koocaa.cm','2011-09-30 13:18:04'),
	(35,'notified_events','--- \n- issue_added\n- issue_updated\n','2011-09-30 13:18:04'),
	(36,'bcc_recipients','1','2011-09-30 13:18:04'),
	(37,'emails_header','邮件标题头','2011-09-30 13:18:04'),
	(38,'plain_text_mail','0','2011-09-30 13:18:04'),
	(39,'commit_ref_keywords','refs,references,IssueID','2011-09-30 13:18:19'),
	(40,'commit_fix_status_id','0','2011-09-30 13:18:19'),
	(41,'enabled_scm','--- \n- Subversion\n- Cvs\n- Git\n','2011-09-30 13:18:19'),
	(42,'commit_logtime_enabled','0','2011-09-30 13:18:19'),
	(43,'repositories_encodings','','2011-09-30 13:18:19'),
	(44,'sys_api_enabled','0','2011-09-30 13:18:19'),
	(45,'commit_fix_done_ratio','100','2011-09-30 13:18:19'),
	(46,'autofetch_changesets','1','2011-09-30 13:18:19'),
	(47,'commit_fix_keywords','fixes,closes','2011-09-30 13:18:19'),
	(48,'repository_log_display_limit','100','2011-09-30 13:18:19'),
	(49,'self_registration','0','2011-09-30 13:55:57'),
	(50,'login_required','1','2011-09-30 13:55:58'),
	(51,'rest_api_enabled','0','2011-09-30 13:55:58'),
	(52,'lost_password','1','2011-09-30 13:55:58'),
	(53,'openid','0','2011-09-30 13:55:58'),
	(54,'autologin','7','2011-09-30 13:55:58'),
	(55,'password_min_length','8','2011-09-30 13:55:58');

/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table time_entries
# ------------------------------------------------------------

DROP TABLE IF EXISTS `time_entries`;

CREATE TABLE `time_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `issue_id` int(11) DEFAULT NULL,
  `hours` float NOT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `activity_id` int(11) NOT NULL,
  `spent_on` date NOT NULL,
  `tyear` int(11) NOT NULL,
  `tmonth` int(11) NOT NULL,
  `tweek` int(11) NOT NULL,
  `created_on` datetime NOT NULL,
  `updated_on` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `time_entries_project_id` (`project_id`),
  KEY `time_entries_issue_id` (`issue_id`),
  KEY `index_time_entries_on_activity_id` (`activity_id`),
  KEY `index_time_entries_on_user_id` (`user_id`),
  KEY `index_time_entries_on_created_on` (`created_on`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table tokens
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tokens`;

CREATE TABLE `tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `action` varchar(30) NOT NULL DEFAULT '',
  `value` varchar(40) NOT NULL DEFAULT '',
  `created_on` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_tokens_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `tokens` WRITE;
/*!40000 ALTER TABLE `tokens` DISABLE KEYS */;

INSERT INTO `tokens` (`id`, `user_id`, `action`, `value`, `created_on`)
VALUES
	(2,1,'feeds','2177e3911be3a6df5967d4026b3dd50edff3a3ad','2011-09-30 13:05:39'),
	(5,3,'feeds','f3a97dba6a05d4099145fb9da0e8f33b105b85d3','2011-09-30 13:27:53'),
	(6,4,'autologin','189c13ed7024b88591991edf8aafcbd36cf5e4d2','2011-09-30 14:06:05'),
	(8,4,'feeds','127ccb15b14424a9f137526fb9a73778d0460f35','2011-09-30 14:06:05'),
	(11,7,'feeds','0ddde5c6d1cd4fdb2673bd6ce744ad84ec82b92d','2011-10-18 02:19:48');

/*!40000 ALTER TABLE `tokens` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table trackers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `trackers`;

CREATE TABLE `trackers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL DEFAULT '',
  `is_in_chlog` tinyint(1) NOT NULL DEFAULT '0',
  `position` int(11) DEFAULT '1',
  `is_in_roadmap` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `trackers` WRITE;
/*!40000 ALTER TABLE `trackers` DISABLE KEYS */;

INSERT INTO `trackers` (`id`, `name`, `is_in_chlog`, `position`, `is_in_roadmap`)
VALUES
	(1,'手绘Q图版',1,1,1),
	(2,'场景版',1,2,1),
	(3,'图库自选版',1,3,1),
	(4,'客户上传版',1,4,1);

/*!40000 ALTER TABLE `trackers` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table user_preferences
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user_preferences`;

CREATE TABLE `user_preferences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `others` text,
  `hide_mail` tinyint(1) DEFAULT '0',
  `time_zone` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_user_preferences_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `user_preferences` WRITE;
/*!40000 ALTER TABLE `user_preferences` DISABLE KEYS */;

INSERT INTO `user_preferences` (`id`, `user_id`, `others`, `hide_mail`, `time_zone`)
VALUES
	(1,2,'--- {}\n\n',0,NULL),
	(2,1,'--- \n:gantt_months: 6\n:warn_on_leaving_unsaved: \"1\"\n:no_self_notified: false\n:comments_sorting: asc\n:gantt_zoom: 2\n',0,''),
	(3,3,'--- \n:comments_sorting: asc\n:gantt_zoom: 2\n:gantt_months: 6\n:warn_on_leaving_unsaved: \"1\"\n:no_self_notified: false\n',0,''),
	(4,4,'--- \n:comments_sorting: asc\n:gantt_zoom: 2\n:gantt_months: 6\n:warn_on_leaving_unsaved: \"1\"\n:no_self_notified: false\n',0,''),
	(5,5,'--- \n:warn_on_leaving_unsaved: \"1\"\n:no_self_notified: false\n:comments_sorting: asc\n',0,''),
	(6,6,'--- \n:warn_on_leaving_unsaved: \"1\"\n:no_self_notified: false\n:comments_sorting: asc\n',0,''),
	(7,7,'--- \n:warn_on_leaving_unsaved: \"1\"\n:no_self_notified: false\n:comments_sorting: asc\n',0,'');

/*!40000 ALTER TABLE `user_preferences` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(30) NOT NULL DEFAULT '',
  `hashed_password` varchar(40) NOT NULL DEFAULT '',
  `firstname` varchar(30) NOT NULL DEFAULT '',
  `lastname` varchar(30) NOT NULL DEFAULT '',
  `mail` varchar(60) NOT NULL DEFAULT '',
  `admin` tinyint(1) NOT NULL DEFAULT '0',
  `status` int(11) NOT NULL DEFAULT '1',
  `last_login_on` datetime DEFAULT NULL,
  `language` varchar(5) DEFAULT '',
  `auth_source_id` int(11) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `identity_url` varchar(255) DEFAULT NULL,
  `mail_notification` varchar(255) NOT NULL DEFAULT '',
  `salt` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_users_on_id_and_type` (`id`,`type`),
  KEY `index_users_on_auth_source_id` (`auth_source_id`),
  KEY `index_users_on_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;

INSERT INTO `users` (`id`, `login`, `hashed_password`, `firstname`, `lastname`, `mail`, `admin`, `status`, `last_login_on`, `language`, `auth_source_id`, `created_on`, `updated_on`, `type`, `identity_url`, `mail_notification`, `salt`)
VALUES
	(1,'admin','9d398ab19f032dfbefb6aa98a2f944f7887326b6','System','Admin','alexchien97@gmail.com',1,1,'2011-09-30 13:22:53','zh',NULL,'2011-09-29 23:18:59','2011-10-19 02:04:48','User',NULL,'all','04c7f52121634f854fe9d9043b81e36f'),
	(2,'','','','Anonymous','',0,0,NULL,'',NULL,'2011-09-29 23:29:09','2011-09-29 23:29:09','AnonymousUser',NULL,'only_my_events',NULL),
	(3,'boombastic','24f4345c5dd067393ded6a4898558b03e5c5b7ba','晓栋','钱','alex.chien@koocaa.com',1,1,'2011-10-18 23:55:39','zh',NULL,'2011-09-30 13:21:23','2011-10-18 23:55:39','User',NULL,'only_my_events','8baa57bb3c89f687cc741b56555b3090'),
	(4,'jjicetea','648bb0207455da61d871eb6bddb187a607d95faf','剑','李','jian.li@koocaa.com',1,1,'2011-09-30 14:06:05','zh',NULL,'2011-09-30 13:22:11','2011-09-30 14:06:05','User',NULL,'only_my_events','2c934bd4611507a33be03589fc59be23'),
	(5,'pm','568d03736d115313eab24445c90ab2bf2281fcf7','Project','Manager','pj@koocaa.com',0,1,NULL,'zh',NULL,'2011-09-30 16:16:29','2011-10-19 02:03:57','User',NULL,'only_my_events','3ec92220d85cac1ba514913da52f7cc3'),
	(6,'csr','198c427688170e212957c3701451ecca22239986','CSR','CSR','csr@koocaa.com',0,1,NULL,'zh',NULL,'2011-09-30 16:16:59','2011-10-19 02:03:08','User',NULL,'only_my_events','276ecffca230752ac1e63d64bbd934d0'),
	(7,'designer','33603d801425f51a8399464243238608fba8a4ad','designer','designer','designer@koocaa.com',0,1,'2011-10-19 01:24:03','zh',NULL,'2011-09-30 16:18:18','2011-10-19 02:03:31','User',NULL,'only_my_events','8cb205d457eb3f3df6681d2433f10b66');

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table versions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `versions`;

CREATE TABLE `versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) DEFAULT '',
  `effective_date` date DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `wiki_page_title` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT 'open',
  `sharing` varchar(255) NOT NULL DEFAULT 'none',
  PRIMARY KEY (`id`),
  KEY `versions_project_id` (`project_id`),
  KEY `index_versions_on_sharing` (`sharing`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table watchers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `watchers`;

CREATE TABLE `watchers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `watchable_type` varchar(255) NOT NULL DEFAULT '',
  `watchable_id` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `watchers_user_id_type` (`user_id`,`watchable_type`),
  KEY `index_watchers_on_user_id` (`user_id`),
  KEY `index_watchers_on_watchable_id_and_watchable_type` (`watchable_id`,`watchable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `watchers` WRITE;
/*!40000 ALTER TABLE `watchers` DISABLE KEYS */;

INSERT INTO `watchers` (`id`, `watchable_type`, `watchable_id`, `user_id`)
VALUES
	(1,'Issue',1,1);

/*!40000 ALTER TABLE `watchers` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table wiki_content_versions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `wiki_content_versions`;

CREATE TABLE `wiki_content_versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wiki_content_id` int(11) NOT NULL,
  `page_id` int(11) NOT NULL,
  `author_id` int(11) DEFAULT NULL,
  `data` longblob,
  `compression` varchar(6) DEFAULT '',
  `comments` varchar(255) DEFAULT '',
  `updated_on` datetime NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `wiki_content_versions_wcid` (`wiki_content_id`),
  KEY `index_wiki_content_versions_on_updated_on` (`updated_on`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table wiki_contents
# ------------------------------------------------------------

DROP TABLE IF EXISTS `wiki_contents`;

CREATE TABLE `wiki_contents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page_id` int(11) NOT NULL,
  `author_id` int(11) DEFAULT NULL,
  `text` longtext,
  `comments` varchar(255) DEFAULT '',
  `updated_on` datetime NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `wiki_contents_page_id` (`page_id`),
  KEY `index_wiki_contents_on_author_id` (`author_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table wiki_pages
# ------------------------------------------------------------

DROP TABLE IF EXISTS `wiki_pages`;

CREATE TABLE `wiki_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wiki_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `created_on` datetime NOT NULL,
  `protected` tinyint(1) NOT NULL DEFAULT '0',
  `parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `wiki_pages_wiki_id_title` (`wiki_id`,`title`),
  KEY `index_wiki_pages_on_wiki_id` (`wiki_id`),
  KEY `index_wiki_pages_on_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table wiki_redirects
# ------------------------------------------------------------

DROP TABLE IF EXISTS `wiki_redirects`;

CREATE TABLE `wiki_redirects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wiki_id` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `redirects_to` varchar(255) DEFAULT NULL,
  `created_on` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `wiki_redirects_wiki_id_title` (`wiki_id`,`title`),
  KEY `index_wiki_redirects_on_wiki_id` (`wiki_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table wikis
# ------------------------------------------------------------

DROP TABLE IF EXISTS `wikis`;

CREATE TABLE `wikis` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `start_page` varchar(255) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `wikis_project_id` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `wikis` WRITE;
/*!40000 ALTER TABLE `wikis` DISABLE KEYS */;

INSERT INTO `wikis` (`id`, `project_id`, `start_page`, `status`)
VALUES
	(1,1,'Wiki',1);

/*!40000 ALTER TABLE `wikis` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table workflows
# ------------------------------------------------------------

DROP TABLE IF EXISTS `workflows`;

CREATE TABLE `workflows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tracker_id` int(11) NOT NULL DEFAULT '0',
  `old_status_id` int(11) NOT NULL DEFAULT '0',
  `new_status_id` int(11) NOT NULL DEFAULT '0',
  `role_id` int(11) NOT NULL DEFAULT '0',
  `assignee` tinyint(1) NOT NULL DEFAULT '0',
  `author` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `wkfs_role_tracker_old_status` (`role_id`,`tracker_id`,`old_status_id`),
  KEY `index_workflows_on_old_status_id` (`old_status_id`),
  KEY `index_workflows_on_role_id` (`role_id`),
  KEY `index_workflows_on_new_status_id` (`new_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `workflows` WRITE;
/*!40000 ALTER TABLE `workflows` DISABLE KEYS */;

INSERT INTO `workflows` (`id`, `tracker_id`, `old_status_id`, `new_status_id`, `role_id`, `assignee`, `author`)
VALUES
	(198,5,1,2,3,0,0),
	(199,5,1,3,3,0,0),
	(200,5,1,4,3,0,0),
	(201,5,1,5,3,0,0),
	(202,5,1,6,3,0,0),
	(203,5,2,1,3,0,0),
	(204,5,2,3,3,0,0),
	(205,5,2,4,3,0,0),
	(206,5,2,5,3,0,0),
	(207,5,2,6,3,0,0),
	(208,5,3,1,3,0,0),
	(209,5,3,2,3,0,0),
	(210,5,3,4,3,0,0),
	(211,5,3,5,3,0,0),
	(212,5,3,6,3,0,0),
	(213,5,4,1,3,0,0),
	(214,5,4,2,3,0,0),
	(215,5,4,3,3,0,0),
	(216,5,4,5,3,0,0),
	(217,5,4,6,3,0,0),
	(218,5,5,1,3,0,0),
	(219,5,5,2,3,0,0),
	(220,5,5,3,3,0,0),
	(221,5,5,4,3,0,0),
	(222,5,5,6,3,0,0),
	(223,5,6,1,3,0,0),
	(224,5,6,2,3,0,0),
	(225,5,6,3,3,0,0),
	(226,5,6,4,3,0,0),
	(227,5,6,5,3,0,0),
	(387,3,1,2,6,0,0),
	(388,3,1,3,6,0,0),
	(389,3,1,4,6,0,0),
	(390,3,1,5,6,0,0),
	(391,3,2,3,6,0,0),
	(392,3,2,4,6,0,0),
	(393,3,2,5,6,0,0),
	(394,3,3,2,6,0,0),
	(395,3,3,4,6,0,0),
	(396,3,3,5,6,0,0),
	(397,3,4,2,6,0,0),
	(398,3,4,3,6,0,0),
	(399,3,4,5,6,0,0),
	(417,5,1,2,6,0,0),
	(418,5,1,3,6,0,0),
	(419,5,1,4,6,0,0),
	(420,5,1,5,6,0,0),
	(421,5,2,3,6,0,0),
	(422,5,2,4,6,0,0),
	(423,5,2,5,6,0,0),
	(424,5,3,2,6,0,0),
	(425,5,3,4,6,0,0),
	(426,5,3,5,6,0,0),
	(427,5,4,2,6,0,0),
	(428,5,4,3,6,0,0),
	(429,5,4,5,6,0,0),
	(462,3,1,2,7,0,0),
	(463,3,1,3,7,0,0),
	(464,3,1,4,7,0,0),
	(465,3,1,5,7,0,0),
	(466,3,2,3,7,0,0),
	(467,3,2,4,7,0,0),
	(468,3,2,5,7,0,0),
	(469,3,3,2,7,0,0),
	(470,3,3,4,7,0,0),
	(471,3,3,5,7,0,0),
	(472,3,4,2,7,0,0),
	(473,3,4,3,7,0,0),
	(474,3,4,5,7,0,0),
	(477,4,1,2,7,0,0),
	(478,4,1,3,7,0,0),
	(479,4,1,4,7,0,0),
	(480,4,1,5,7,0,0),
	(481,4,2,3,7,0,0),
	(482,4,2,4,7,0,0),
	(483,4,2,5,7,0,0),
	(484,4,3,2,7,0,0),
	(485,4,3,4,7,0,0),
	(486,4,3,5,7,0,0),
	(487,4,4,2,7,0,0),
	(488,4,4,3,7,0,0),
	(489,4,4,5,7,0,0),
	(492,5,1,2,7,0,0),
	(493,5,1,3,7,0,0),
	(494,5,1,4,7,0,0),
	(495,5,1,5,7,0,0),
	(496,5,2,3,7,0,0),
	(497,5,2,4,7,0,0),
	(498,5,2,5,7,0,0),
	(499,5,3,2,7,0,0),
	(500,5,3,4,7,0,0),
	(501,5,3,5,7,0,0),
	(502,5,4,2,7,0,0),
	(503,5,4,3,7,0,0),
	(504,5,4,5,7,0,0),
	(507,1,1,5,8,0,0),
	(508,1,2,5,8,0,0),
	(509,1,3,5,8,0,0),
	(510,1,3,4,8,0,0),
	(511,1,4,5,8,0,0),
	(514,2,1,5,8,0,0),
	(515,2,2,5,8,0,0),
	(516,2,3,5,8,0,0),
	(517,2,3,4,8,0,0),
	(518,2,4,5,8,0,0),
	(521,3,1,5,8,0,0),
	(522,3,2,5,8,0,0),
	(523,3,3,5,8,0,0),
	(524,3,3,4,8,0,0),
	(525,3,4,5,8,0,0),
	(535,5,1,5,8,0,0),
	(536,5,2,5,8,0,0),
	(537,5,3,5,8,0,0),
	(538,5,3,4,8,0,0),
	(539,5,4,5,8,0,0),
	(690,3,50,50,3,0,0),
	(691,3,50,10,3,0,0),
	(692,3,10,50,3,0,0),
	(693,3,10,10,3,0,0),
	(818,4,50,50,3,0,0),
	(819,4,50,20,3,0,0),
	(820,4,30,30,3,0,0),
	(821,4,30,20,3,0,0),
	(822,4,20,50,3,0,0),
	(823,4,20,30,3,0,0),
	(824,4,20,20,3,0,0),
	(825,4,10,20,3,0,0),
	(826,4,10,10,3,0,0),
	(941,1,60,60,7,0,0),
	(942,1,60,40,7,0,0),
	(943,1,50,50,7,0,0),
	(944,1,50,40,7,0,0),
	(945,1,40,60,7,0,0),
	(946,1,40,50,7,0,0),
	(947,1,40,40,7,0,0),
	(962,2,60,60,7,0,0),
	(963,2,60,40,7,0,0),
	(964,2,50,50,7,0,0),
	(965,2,50,40,7,0,0),
	(966,2,40,60,7,0,0),
	(967,2,40,50,7,0,0),
	(968,2,40,40,7,0,0),
	(969,4,50,50,8,0,0),
	(970,4,50,20,8,0,0),
	(971,4,30,30,8,0,0),
	(972,4,30,20,8,0,0),
	(973,4,20,50,8,0,0),
	(974,4,20,30,8,0,0),
	(975,4,20,20,8,0,0),
	(976,4,50,50,6,0,0),
	(977,4,50,20,6,0,0),
	(978,4,30,30,6,0,0),
	(979,4,30,20,6,0,0),
	(980,4,20,50,6,0,0),
	(981,4,20,30,6,0,0),
	(982,4,20,20,6,0,0),
	(1010,1,60,60,3,0,0),
	(1011,1,60,40,3,0,0),
	(1012,1,50,50,3,0,0),
	(1013,1,50,40,3,0,0),
	(1014,1,40,60,3,0,0),
	(1015,1,40,50,3,0,0),
	(1016,1,40,40,3,0,0),
	(1017,1,30,30,3,0,0),
	(1018,1,30,20,3,0,0),
	(1019,1,20,50,3,0,0),
	(1020,1,20,30,3,0,0),
	(1021,1,20,20,3,0,0),
	(1022,1,10,50,3,0,0),
	(1023,1,10,40,3,0,0),
	(1024,1,10,20,3,0,0),
	(1025,1,10,10,3,0,0),
	(1026,1,10,50,6,0,0),
	(1027,1,10,40,6,0,0),
	(1028,1,10,20,6,0,0),
	(1029,1,10,10,6,0,0),
	(1030,1,20,50,6,0,0),
	(1031,1,20,30,6,0,0),
	(1032,1,20,20,6,0,0),
	(1033,1,30,30,6,0,0),
	(1034,1,30,20,6,0,0),
	(1035,1,40,60,6,0,0),
	(1036,1,40,50,6,0,0),
	(1037,1,40,40,6,0,0),
	(1038,1,50,50,6,0,0),
	(1039,1,50,40,6,0,0),
	(1040,1,60,60,6,0,0),
	(1041,1,60,40,6,0,0),
	(1057,2,10,50,3,0,0),
	(1058,2,10,40,3,0,0),
	(1059,2,10,20,3,0,0),
	(1060,2,10,10,3,0,0),
	(1061,2,20,50,3,0,0),
	(1062,2,20,30,3,0,0),
	(1063,2,20,20,3,0,0),
	(1064,2,30,30,3,0,0),
	(1065,2,30,20,3,0,0),
	(1066,2,40,60,3,0,0),
	(1067,2,40,50,3,0,0),
	(1068,2,40,40,3,0,0),
	(1069,2,50,50,3,0,0),
	(1070,2,50,40,3,0,0),
	(1071,2,60,60,3,0,0),
	(1072,2,60,40,3,0,0),
	(1088,2,10,50,6,0,0),
	(1089,2,10,40,6,0,0),
	(1090,2,10,20,6,0,0),
	(1091,2,10,10,6,0,0),
	(1092,2,20,50,6,0,0),
	(1093,2,20,30,6,0,0),
	(1094,2,20,20,6,0,0),
	(1095,2,30,30,6,0,0),
	(1096,2,30,20,6,0,0),
	(1097,2,40,60,6,0,0),
	(1098,2,40,50,6,0,0),
	(1099,2,40,40,6,0,0),
	(1100,2,50,50,6,0,0),
	(1101,2,50,40,6,0,0),
	(1102,2,60,60,6,0,0),
	(1103,2,60,40,6,0,0);

/*!40000 ALTER TABLE `workflows` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
