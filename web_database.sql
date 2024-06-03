-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Июн 03 2024 г., 18:29
-- Версия сервера: 8.3.0
-- Версия PHP: 8.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `web_database`
--

-- --------------------------------------------------------

--
-- Структура таблицы `blogs`
--

DROP TABLE IF EXISTS `blogs`;
CREATE TABLE IF NOT EXISTS `blogs` (
  `blog_id` int NOT NULL AUTO_INCREMENT,
  `blog_title` varchar(100) NOT NULL,
  `blog_img` varchar(1000) NOT NULL DEFAULT 'default.png',
  `blog_by` int NOT NULL,
  `blog_date` date NOT NULL,
  `blog_votes` int NOT NULL DEFAULT '0',
  `blog_content` longtext NOT NULL,
  PRIMARY KEY (`blog_id`),
  KEY `blog_by` (`blog_by`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `blogs`
--

INSERT INTO `blogs` (`blog_id`, `blog_title`, `blog_img`, `blog_by`, `blog_date`, `blog_votes`, `blog_content`) VALUES
(20, 'aaa', 'blog-cover.png', 40, '2024-06-03', 1, 'aaa'),
(21, 'BLOG???', 'blog-cover.png', 40, '2024-06-03', 2, 'yep it is');

-- --------------------------------------------------------

--
-- Структура таблицы `blogvotes`
--

DROP TABLE IF EXISTS `blogvotes`;
CREATE TABLE IF NOT EXISTS `blogvotes` (
  `voteId` int NOT NULL AUTO_INCREMENT,
  `voteBlog` int NOT NULL,
  `voteBy` int NOT NULL,
  `voteDate` date NOT NULL,
  `vote` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`voteId`),
  KEY `voteBlog` (`voteBlog`),
  KEY `voteBy` (`voteBy`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `blogvotes`
--

INSERT INTO `blogvotes` (`voteId`, `voteBlog`, `voteBy`, `voteDate`, `vote`) VALUES
(24, 20, 40, '2024-06-03', 1),
(25, 21, 40, '2024-06-03', 1),
(26, 21, 42, '2024-06-03', 1);

--
-- Триггеры `blogvotes`
--
DROP TRIGGER IF EXISTS `calc_blog_votes_after_delete`;
DELIMITER $$
CREATE TRIGGER `calc_blog_votes_after_delete` AFTER DELETE ON `blogvotes` FOR EACH ROW BEGIN

		update blogs
        set blogs.blog_votes = blogs.blog_votes - old.vote
        where blogs.blog_id = old.voteBlog;	

END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `calc_blog_votes_after_insert`;
DELIMITER $$
CREATE TRIGGER `calc_blog_votes_after_insert` AFTER INSERT ON `blogvotes` FOR EACH ROW BEGIN
	
	update blogs
        set blogs.blog_votes = blogs.blog_votes + new.vote
        where blogs.blog_id = new.voteBlog;	
		
    END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `calc_blog_votes_after_update`;
DELIMITER $$
CREATE TRIGGER `calc_blog_votes_after_update` AFTER UPDATE ON `blogvotes` FOR EACH ROW BEGIN
	
		update blogs
        set blogs.blog_votes = blogs.blog_votes + (new.vote * 2)
        where blogs.blog_id = new.voteBlog;	
		
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `categories`
--

DROP TABLE IF EXISTS `categories`;
CREATE TABLE IF NOT EXISTS `categories` (
  `cat_id` int NOT NULL AUTO_INCREMENT,
  `cat_name` varchar(255) NOT NULL,
  `cat_description` varchar(255) NOT NULL,
  PRIMARY KEY (`cat_id`),
  UNIQUE KEY `cat_name_unique` (`cat_name`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `categories`
--

INSERT INTO `categories` (`cat_id`, `cat_name`, `cat_description`) VALUES
(14, 'PHP', 'any PHP features');

-- --------------------------------------------------------

--
-- Структура таблицы `conversation`
--

DROP TABLE IF EXISTS `conversation`;
CREATE TABLE IF NOT EXISTS `conversation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_one` int NOT NULL,
  `user_two` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_one` (`user_one`),
  KEY `user_two` (`user_two`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Структура таблицы `events`
--

DROP TABLE IF EXISTS `events`;
CREATE TABLE IF NOT EXISTS `events` (
  `event_id` int NOT NULL AUTO_INCREMENT,
  `event_by` int NOT NULL,
  `title` varchar(100) NOT NULL,
  `date_created` date NOT NULL,
  `event_date` varchar(10) NOT NULL,
  `event_image` varchar(200) NOT NULL,
  PRIMARY KEY (`event_id`),
  KEY `events_ibfk_1` (`event_by`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `events`
--

INSERT INTO `events` (`event_id`, `event_by`, `title`, `date_created`, `event_date`, `event_image`) VALUES
(28, 40, 'Showing my work', '2024-06-03', '2024-06-06', 'event-cover.png');

-- --------------------------------------------------------

--
-- Структура таблицы `event_info`
--

DROP TABLE IF EXISTS `event_info`;
CREATE TABLE IF NOT EXISTS `event_info` (
  `event_id` int NOT NULL AUTO_INCREMENT,
  `event` int NOT NULL,
  `title` varchar(100) NOT NULL,
  `headline` varchar(100) NOT NULL,
  `description` varchar(6000) NOT NULL,
  PRIMARY KEY (`event_id`),
  KEY `event` (`event`),
  KEY `title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `event_info`
--

INSERT INTO `event_info` (`event_id`, `event`, `title`, `headline`, `description`) VALUES
(20, 28, 'Showing my work', 'nah i\'d win!', 'PRESENTATION LES GO');

-- --------------------------------------------------------

--
-- Структура таблицы `messages`
--

DROP TABLE IF EXISTS `messages`;
CREATE TABLE IF NOT EXISTS `messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `conversation_id` int NOT NULL,
  `user_from` int NOT NULL,
  `user_to` int NOT NULL,
  `message` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_from` (`user_from`),
  KEY `user_to` (`user_to`),
  KEY `conversation_id` (`conversation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Структура таблицы `polls`
--

DROP TABLE IF EXISTS `polls`;
CREATE TABLE IF NOT EXISTS `polls` (
  `id` int NOT NULL AUTO_INCREMENT,
  `subject` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `status` enum('1','0') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '1',
  `created_by` int NOT NULL,
  `poll_desc` varchar(5000) NOT NULL,
  `locked` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `polls`
--

INSERT INTO `polls` (`id`, `subject`, `created`, `modified`, `status`, `created_by`, `poll_desc`, `locked`) VALUES
(18, 'choose your character', '2024-06-03 16:05:00', '2024-06-03 16:05:00', '1', 40, 'favorite teacher!', 1),
(19, 'choose your character 2 ', '2024-06-03 16:07:27', '2024-06-03 16:07:27', '1', 40, '', 0);

-- --------------------------------------------------------

--
-- Структура таблицы `poll_options`
--

DROP TABLE IF EXISTS `poll_options`;
CREATE TABLE IF NOT EXISTS `poll_options` (
  `id` int NOT NULL AUTO_INCREMENT,
  `poll_id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `status` enum('1','0') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `poll_id` (`poll_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `poll_options`
--

INSERT INTO `poll_options` (`id`, `poll_id`, `name`, `created`, `modified`, `status`) VALUES
(36, 18, 'Skolotājs Bobers', '2024-06-03 16:05:00', '2024-06-03 16:05:00', '1'),
(37, 18, 'Misters Bigs', '2024-06-03 16:05:00', '2024-06-03 16:05:00', '1'),
(38, 18, 'hello kitty', '2024-06-03 16:05:00', '2024-06-03 16:05:00', '1'),
(39, 19, 'Mister bebris', '2024-06-03 16:07:27', '2024-06-03 16:07:27', '1'),
(40, 19, ' Irnis rozkovs', '2024-06-03 16:07:27', '2024-06-03 16:07:27', '1');

-- --------------------------------------------------------

--
-- Структура таблицы `poll_votes`
--

DROP TABLE IF EXISTS `poll_votes`;
CREATE TABLE IF NOT EXISTS `poll_votes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `poll_id` int NOT NULL,
  `poll_option_id` int NOT NULL,
  `vote_by` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `poll_id` (`poll_id`),
  KEY `poll_option_id` (`poll_option_id`),
  KEY `vote_by` (`vote_by`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `poll_votes`
--

INSERT INTO `poll_votes` (`id`, `poll_id`, `poll_option_id`, `vote_by`) VALUES
(25, 19, 39, 40);

-- --------------------------------------------------------

--
-- Структура таблицы `posts`
--

DROP TABLE IF EXISTS `posts`;
CREATE TABLE IF NOT EXISTS `posts` (
  `post_id` int NOT NULL AUTO_INCREMENT,
  `post_content` text NOT NULL,
  `post_date` datetime NOT NULL,
  `post_topic` int NOT NULL,
  `post_by` int NOT NULL,
  `post_votes` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`post_id`),
  KEY `post_topic` (`post_topic`),
  KEY `post_by` (`post_by`)
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `posts`
--

INSERT INTO `posts` (`post_id`, `post_content`, `post_date`, `post_topic`, `post_by`, `post_votes`) VALUES
(124, 'a', '2024-06-03 14:34:55', 46, 40, 1),
(125, 'question?', '2024-06-03 16:00:18', 47, 40, -1),
(126, 'reply to myself?', '2024-06-03 16:00:40', 46, 40, 1),
(127, 'huhuhuh!', '2024-06-03 18:56:20', 47, 42, 1),
(128, 'a', '2024-06-03 18:57:52', 48, 42, -1),
(129, 'dont touch me', '2024-06-03 18:58:06', 48, 42, -1);

-- --------------------------------------------------------

--
-- Структура таблицы `postvotes`
--

DROP TABLE IF EXISTS `postvotes`;
CREATE TABLE IF NOT EXISTS `postvotes` (
  `voteId` int NOT NULL AUTO_INCREMENT,
  `votePost` int NOT NULL,
  `voteBy` int NOT NULL,
  `voteDate` date NOT NULL,
  `vote` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`voteId`),
  KEY `voteBy` (`voteBy`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `postvotes`
--

INSERT INTO `postvotes` (`voteId`, `votePost`, `voteBy`, `voteDate`, `vote`) VALUES
(34, 126, 40, '2024-06-03', 1),
(35, 124, 40, '2024-06-03', 1),
(36, 125, 42, '2024-06-03', -1),
(37, 127, 42, '2024-06-03', 1),
(38, 128, 42, '2024-06-03', -1),
(39, 129, 42, '2024-06-03', -1);

--
-- Триггеры `postvotes`
--
DROP TRIGGER IF EXISTS `calc_forum_votes_after_delete`;
DELIMITER $$
CREATE TRIGGER `calc_forum_votes_after_delete` AFTER DELETE ON `postvotes` FOR EACH ROW BEGIN

		update posts
        set posts.post_votes = posts.post_votes - old.vote
        where posts.post_id = old.votePost;	

END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `calc_forum_votes_after_insert`;
DELIMITER $$
CREATE TRIGGER `calc_forum_votes_after_insert` AFTER INSERT ON `postvotes` FOR EACH ROW BEGIN
	
	update posts
        set posts.post_votes = posts.post_votes + new.vote
        where posts.post_id = new.votePost;	
		
    END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `calc_forum_votes_after_update`;
DELIMITER $$
CREATE TRIGGER `calc_forum_votes_after_update` AFTER UPDATE ON `postvotes` FOR EACH ROW BEGIN
	
		update posts
        set posts.post_votes = posts.post_votes + (new.vote * 2)
        where posts.post_id = new.votePost;	
		
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `pwdreset`
--

DROP TABLE IF EXISTS `pwdreset`;
CREATE TABLE IF NOT EXISTS `pwdreset` (
  `pwdResetId` int NOT NULL AUTO_INCREMENT,
  `pwdResetEmail` text NOT NULL,
  `pwdResetSelector` text NOT NULL,
  `pwdResetToken` longtext NOT NULL,
  `pwdResetExpires` text NOT NULL,
  PRIMARY KEY (`pwdResetId`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Структура таблицы `topics`
--

DROP TABLE IF EXISTS `topics`;
CREATE TABLE IF NOT EXISTS `topics` (
  `topic_id` int NOT NULL AUTO_INCREMENT,
  `topic_subject` varchar(255) NOT NULL,
  `topic_date` datetime NOT NULL,
  `topic_cat` int NOT NULL,
  `topic_by` int NOT NULL,
  PRIMARY KEY (`topic_id`),
  KEY `topic_cat` (`topic_cat`),
  KEY `topic_by` (`topic_by`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `topics`
--

INSERT INTO `topics` (`topic_id`, `topic_subject`, `topic_date`, `topic_cat`, `topic_by`) VALUES
(46, 'a', '2024-06-03 14:34:55', 14, 40),
(47, 'subject number one', '2024-06-03 16:00:18', 14, 40),
(48, 'aa', '2024-06-03 18:57:52', 14, 42);

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `idUsers` int NOT NULL AUTO_INCREMENT,
  `userLevel` int NOT NULL DEFAULT '0',
  `f_name` varchar(50) NOT NULL,
  `l_name` varchar(50) NOT NULL,
  `uidUsers` tinytext NOT NULL,
  `emailUsers` tinytext NOT NULL,
  `pwdUsers` longtext NOT NULL,
  `gender` char(1) NOT NULL,
  `headline` varchar(500) DEFAULT NULL,
  `bio` varchar(4000) DEFAULT NULL,
  `userImg` varchar(500) DEFAULT 'default.png',
  PRIMARY KEY (`idUsers`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`idUsers`, `userLevel`, `f_name`, `l_name`, `uidUsers`, `emailUsers`, `pwdUsers`, `gender`, `headline`, `bio`, `userImg`) VALUES
(40, 1, 'aaa', 'aaa', 'first', 'first@gmail.com', '$2y$10$qQUeD5rqYvlv89ednuHJQe8E80205TKsktwCuZ4CHJkSAertnRj9C', 'm', 'aa', 'a', 'default.png'),
(41, 0, 'aa', 'aa', 'second', 'second@gmail.com', '$2y$10$gNluU4MpWdP3OaWHW9XJZevR8Zu5q5wn/I4keL4IT5XTIhj88L1Km', 'm', 'a', 'a', 'default.png'),
(42, 0, 'aaa', 'aaa', 'aaa', 'aaa123@gmail.com', '$2y$10$LLxzsxLaK1d4ojhBgNKInuMKqAxQWZzynzWDE70gD7wPR9iY4RAiS', 'f', 'idk', 'emmty', '665de78d898c62.66946335.png');

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `blogs`
--
ALTER TABLE `blogs`
  ADD CONSTRAINT `blogs_ibfk_1` FOREIGN KEY (`blog_by`) REFERENCES `users` (`idUsers`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `blogvotes`
--
ALTER TABLE `blogvotes`
  ADD CONSTRAINT `blogvotes_ibfk_1` FOREIGN KEY (`voteBlog`) REFERENCES `blogs` (`blog_id`),
  ADD CONSTRAINT `blogvotes_ibfk_2` FOREIGN KEY (`voteBy`) REFERENCES `users` (`idUsers`);

--
-- Ограничения внешнего ключа таблицы `conversation`
--
ALTER TABLE `conversation`
  ADD CONSTRAINT `conversation_ibfk_1` FOREIGN KEY (`user_one`) REFERENCES `users` (`idUsers`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `conversation_ibfk_2` FOREIGN KEY (`user_two`) REFERENCES `users` (`idUsers`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `events`
--
ALTER TABLE `events`
  ADD CONSTRAINT `events_ibfk_1` FOREIGN KEY (`event_by`) REFERENCES `users` (`idUsers`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `event_info`
--
ALTER TABLE `event_info`
  ADD CONSTRAINT `event_info_ibfk_1` FOREIGN KEY (`event`) REFERENCES `events` (`event_id`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`user_from`) REFERENCES `users` (`idUsers`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`user_to`) REFERENCES `users` (`idUsers`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `messages_ibfk_3` FOREIGN KEY (`conversation_id`) REFERENCES `conversation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `polls`
--
ALTER TABLE `polls`
  ADD CONSTRAINT `polls_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`idUsers`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `poll_options`
--
ALTER TABLE `poll_options`
  ADD CONSTRAINT `poll_options_ibfk_1` FOREIGN KEY (`poll_id`) REFERENCES `polls` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `poll_votes`
--
ALTER TABLE `poll_votes`
  ADD CONSTRAINT `poll_votes_ibfk_1` FOREIGN KEY (`poll_id`) REFERENCES `polls` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `poll_votes_ibfk_2` FOREIGN KEY (`poll_option_id`) REFERENCES `poll_options` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `poll_votes_ibfk_3` FOREIGN KEY (`vote_by`) REFERENCES `users` (`idUsers`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`post_topic`) REFERENCES `topics` (`topic_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `posts_ibfk_2` FOREIGN KEY (`post_by`) REFERENCES `users` (`idUsers`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `postvotes`
--
ALTER TABLE `postvotes`
  ADD CONSTRAINT `postvotes_ibfk_1` FOREIGN KEY (`voteBy`) REFERENCES `users` (`idUsers`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `topics`
--
ALTER TABLE `topics`
  ADD CONSTRAINT `topics_ibfk_1` FOREIGN KEY (`topic_cat`) REFERENCES `categories` (`cat_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `topics_ibfk_2` FOREIGN KEY (`topic_by`) REFERENCES `users` (`idUsers`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
