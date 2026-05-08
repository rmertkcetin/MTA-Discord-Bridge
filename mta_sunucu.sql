CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `loginname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `discordid` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `playername` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `registerdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `loginname` (`loginname`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE IF NOT EXISTS `account_codes` (
  `accountid` int NOT NULL,
  `code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`accountid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE IF NOT EXISTS `account_permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `accountid` int NOT NULL,
  `aclname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiredate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_account_id` (`accountid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



INSERT INTO `account_permissions` (`id`, `accountid`, `aclname`, `expiredate`) VALUES



ALTER TABLE `account_codes`
  ADD CONSTRAINT `fk_codes_account` FOREIGN KEY (`accountid`) REFERENCES `accounts` (`id`) ON DELETE CASCADE;



ALTER TABLE `account_permissions`
  ADD CONSTRAINT `fk_permissions_account` FOREIGN KEY (`accountid`) REFERENCES `accounts` (`id`) ON DELETE CASCADE;
COMMIT;