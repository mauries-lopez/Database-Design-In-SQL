-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.5.8-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema HOADB
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS `hoadb` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `hoadb`;


-- -----------------------------------------------------
-- Table `HOADB`.`ref_collectiondays`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ref_collectiondays` (
  `days` int(2) NOT NULL,
  PRIMARY KEY (`days`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Table `HOADB`.`ref_regions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ref_regions` (
  `regions` varchar(45) NOT NULL,
  PRIMARY KEY (`regions`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Table `HOADB`.`provinces`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `provinces` (
  `province` varchar(45) NOT NULL,
  `region` varchar(45) NOT NULL,
  PRIMARY KEY (`province`),
  KEY `FKAMELIA01_idx` (`region`),
  CONSTRAINT `FKAMELIA01` FOREIGN KEY (`region`) REFERENCES `ref_regions` (`regions`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Table `HOADB`.`zipcodes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `zipcodes` (
  `barangay` varchar(45) NOT NULL,
  `city` varchar(45) NOT NULL,
  `province` varchar(45) NOT NULL,
  `zipcode` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`barangay`,`city`,`province`),
  KEY `FKNORM06_idx` (`province`),
  CONSTRAINT `FKNORM06` FOREIGN KEY (`province`) REFERENCES `provinces` (`province`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Table `HOADB`.`hoa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hoa` (
  `hoa_name` varchar(45) NOT NULL,
  `ofcaddr_streetno` varchar(10) NOT NULL,
  `ofcaddr_street` varchar(45) NOT NULL,
  `ofcaddr_barangay` varchar(45) NOT NULL,
  `ofcaddr_city` varchar(45) NOT NULL,
  `ofcaddr_province` varchar(45) NOT NULL,
  `ofcaddr_lattitude` decimal(7,4) NOT NULL,
  `ofcaddr_longitude` decimal(7,2) NOT NULL,
  `year_establishment` date NOT NULL,
  `website` varchar(45) DEFAULT NULL,
  `subdivision_name` varchar(45) NOT NULL,
  `req_scannedarticles` varchar(45) DEFAULT NULL,
  `req_notarizedbylaws` varchar(45) DEFAULT NULL,
  `req_minutes` varchar(45) DEFAULT NULL,
  `req_attendance` varchar(45) DEFAULT NULL,
  `req_certification` varchar(45) DEFAULT NULL,
  `req_codeofethics` varchar(45) DEFAULT NULL,
  `req_regularmonthly` decimal(9,2) DEFAULT NULL,
  `req_collectionday` int(2) NOT NULL COMMENT 'Checking the \nintegrity of the \ndomain values is \nagreed to be \nhandled by the \nDB Application\n',
  PRIMARY KEY (`hoa_name`),
  KEY `FK003_idx` (`req_collectionday`),
  KEY `FKNORM08_idx` (`ofcaddr_barangay`,`ofcaddr_city`,`ofcaddr_province`),
  CONSTRAINT `FK003` FOREIGN KEY (`req_collectionday`) REFERENCES `ref_collectiondays` (`days`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FKNORM08` FOREIGN KEY (`ofcaddr_barangay`, `ofcaddr_city`, `ofcaddr_province`) REFERENCES `zipcodes` (`barangay`, `city`, `province`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Table `HOADB`.`hoa_geninfosheets`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hoa_geninfosheets` (
  `hoa_name` varchar(45) NOT NULL,
  `gen_infosheet` varchar(45) NOT NULL,
  PRIMARY KEY (`hoa_name`,`gen_infosheet`),
  CONSTRAINT `FK001` FOREIGN KEY (`hoa_name`) REFERENCES `hoa` (`hoa_name`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Table `HOADB`.`people`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `people` (
  `peopleid` int(4) NOT NULL,
  `lastname` varchar(45) NOT NULL,
  `firstname` varchar(45) NOT NULL,
  `gender` enum('M','F') NOT NULL,
  `email` varchar(45) DEFAULT NULL,
  `facebook` varchar(45) DEFAULT NULL,
  `picturefile` varchar(45) NOT NULL,
  `birthday` date NOT NULL,
  PRIMARY KEY (`peopleid`),
  UNIQUE KEY `picturefile_UNIQUE` (`picturefile`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- -----------------------------------------------------
-- Table `HOADB`.`homeowner`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `homeowner` (
  `ho_id` int(4) NOT NULL,
  `hostart_date` date NOT NULL,
  `undertaking` tinyint(1) NOT NULL,
  `want_member` tinyint(1) NOT NULL,
  `other_streetno` varchar(45) DEFAULT NULL,
  `other_street` varchar(45) DEFAULT NULL,
  `other_barangay` varchar(45) DEFAULT NULL,
  `other_city` varchar(45) DEFAULT NULL,
  `other_province` varchar(45) DEFAULT NULL,
  `other_longitude` decimal(7,4) DEFAULT NULL,
  `other_lattitude` decimal(7,4) DEFAULT NULL,
  `other_email` varchar(45) DEFAULT NULL,
  `other_mobile` bigint(10) DEFAULT NULL,
  PRIMARY KEY (`ho_id`),
  UNIQUE KEY `other_email_UNIQUE` (`other_email`),
  UNIQUE KEY `other_mobile_UNIQUE` (`other_mobile`),
  KEY `FKNORM03_idx` (`other_barangay`,`other_city`,`other_province`),
  CONSTRAINT `FKNORM03` FOREIGN KEY (`other_barangay`, `other_city`, `other_province`) REFERENCES `zipcodes` (`barangay`, `city`, `province`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FKSENATOR05` FOREIGN KEY (`ho_id`) REFERENCES `people` (`peopleid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- -----------------------------------------------------
-- Table `HOADB`.`household`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `household` (
  `household_id` int(4) NOT NULL,
  PRIMARY KEY (`household_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Table `HOADB`.`properties`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `properties` (
  `property_code` varchar(10) NOT NULL,
  `hoa_name` varchar(45) NOT NULL,
  `size` decimal(6,2) NOT NULL,
  `turnover_date` date DEFAULT NULL,
  `ho_id` int(4) DEFAULT NULL,
  `household_id` int(4) DEFAULT NULL,
  PRIMARY KEY (`property_code`,`hoa_name`),
  UNIQUE KEY `household_id_UNIQUE` (`household_id`),
  KEY `FKBENSON03_idx` (`hoa_name`),
  KEY `FKBENSON04_idx` (`ho_id`),
  KEY `FKJASON05_idx` (`household_id`),
  CONSTRAINT `FKBENSON03` FOREIGN KEY (`hoa_name`) REFERENCES `hoa` (`hoa_name`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FKBENSON04` FOREIGN KEY (`ho_id`) REFERENCES `homeowner` (`ho_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FKJASON05` FOREIGN KEY (`household_id`) REFERENCES `household` (`household_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- -----------------------------------------------------
-- Table `HOADB`.`residents`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `residents` (
  `resident_id` int(4) NOT NULL,
  `renter` tinyint(1) NOT NULL,
  `relationship` varchar(45) NOT NULL,
  `undertaking` tinyint(1) NOT NULL,
  `authorized` enum('Yes','No') NOT NULL,
  `household_id` int(4) DEFAULT NULL,
  `last_update` date NOT NULL,
  PRIMARY KEY (`resident_id`),
  KEY `FKGABRIEL01_idx` (`household_id`),
  CONSTRAINT `FKGABRIEL01` FOREIGN KEY (`household_id`) REFERENCES `household` (`household_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FKSENATOR06` FOREIGN KEY (`resident_id`) REFERENCES `people` (`peopleid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- -----------------------------------------------------
-- Table `HOADB`.`ref_positions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ref_positions` (
  `position` varchar(45) NOT NULL,
  PRIMARY KEY (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- -----------------------------------------------------
-- Table `HOADB`.`outsiders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `outsiders` (
  `name` varchar(45) NOT NULL,
  `mobileno` bigint(10) NOT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `mobileno_UNIQUE` (`mobileno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Table `HOADB`.`elections`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `elections` (
  `election_date` date NOT NULL,
  `election_venue` varchar(45) NOT NULL,
  `quorum` tinyint(1) NOT NULL,
  `outsider_wname` varchar(45) NOT NULL,
  PRIMARY KEY (`election_date`),
  KEY `FKNORM20_idx` (`outsider_wname`),
  CONSTRAINT `FKNORM20` FOREIGN KEY (`outsider_wname`) REFERENCES `outsiders` (`name`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Table `HOADB`.`officer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `officer` (
  `ho_id` int(4) NOT NULL,
  `position` varchar(45) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `election_date` date NOT NULL,
  `availability_time` enum('M','A') NOT NULL COMMENT 'M -Morning\nA - Afternoon\n',
  `M` tinyint(1) NOT NULL,
  `T` tinyint(1) NOT NULL,
  `W` tinyint(1) NOT NULL,
  `H` tinyint(1) NOT NULL,
  `F` tinyint(1) NOT NULL,
  `S` tinyint(1) NOT NULL,
  `N` tinyint(1) NOT NULL,
  PRIMARY KEY (`ho_id`,`position`,`election_date`),
  KEY `FKBENSON01_idx` (`position`),
  KEY `FKNORM01_idx` (`election_date`),
  CONSTRAINT `FKBENSON01` FOREIGN KEY (`position`) REFERENCES `ref_positions` (`position`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FKGABRIEL06` FOREIGN KEY (`ho_id`) REFERENCES `homeowner` (`ho_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FKNORM01` FOREIGN KEY (`election_date`) REFERENCES `elections` (`election_date`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Table `HOADB`.`ref_ornumbers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ref_ornumbers` (
  `ornum` int(9) NOT NULL,
  PRIMARY KEY (`ornum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Table `HOADB`.`resident_idcards`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `resident_idcards` (
  `card_number` int(4) NOT NULL,
  `requested_date` date NOT NULL,
  `request_reason` varchar(45) NOT NULL,
  `provided_date` date DEFAULT NULL,
  `ornum` int(9) DEFAULT NULL,
  `fee` decimal(9,2) NOT NULL,
  `resident_id` int(4) NOT NULL,
  `cancelled` tinyint(1) NOT NULL,
  `ofcr_hoid` int(4) NOT NULL,
  `position` varchar(45) NOT NULL,
  `election_date` date NOT NULL,
  PRIMARY KEY (`card_number`),
  UNIQUE KEY `ORnum_UNIQUE` (`ornum`),
  KEY `FKGABRIEL02_idx` (`resident_id`),
  KEY `FKSENATOR01_idx` (`ofcr_hoid`,`position`,`election_date`),
  CONSTRAINT `FKGABRIEL02` FOREIGN KEY (`resident_id`) REFERENCES `residents` (`resident_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FKJERICHO01` FOREIGN KEY (`ornum`) REFERENCES `ref_ornumbers` (`ornum`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FKSENATOR01` FOREIGN KEY (`ofcr_hoid`, `position`, `election_date`) REFERENCES `officer` (`ho_id`, `position`, `election_date`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Table `HOADB`.`people_mobile`
-- -----------------------------------------------------
-- Dumping structure for table hoadb.people_mobile
CREATE TABLE IF NOT EXISTS `people_mobile` (
  `peopleid` int(4) NOT NULL,
  `mobileno` bigint(10) NOT NULL,
  PRIMARY KEY (`peopleid`,`mobileno`),
  CONSTRAINT `FKSENATOR10` FOREIGN KEY (`peopleid`) REFERENCES `people` (`peopleid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- -----------------------------------------------------
-- Table `HOADB`.`assets`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `assets` (
  `asset_id` int(4) NOT NULL,
  `asset_name` varchar(45) NOT NULL,
  `asset_description` varchar(45) NOT NULL,
  `acquisition_date` date NOT NULL,
  `forrent` tinyint(1) NOT NULL,
  `asset_value` decimal(9,2) NOT NULL,
  `type_asset` enum('P','E','F','O') NOT NULL COMMENT 'P - Property\nE - Equipment\nF - F&F\nO - Others\n',
  `status` enum('W','D','P','S','X') NOT NULL COMMENT 'W - Working\nD - Deterioted\nP - For Repair\nS - For Disposal\nX - Disposed',
  `loc_lattitude` decimal(7,4) NOT NULL,
  `loc_longiture` decimal(7,4) NOT NULL,
  `hoa_name` varchar(45) NOT NULL,
  `enclosing_asset` int(4) DEFAULT NULL,
  PRIMARY KEY (`asset_id`),
  KEY `FKTYE05_idx` (`hoa_name`),
  KEY `FKTYE07_idx` (`enclosing_asset`),
  CONSTRAINT `FKTYE05` FOREIGN KEY (`hoa_name`) REFERENCES `hoa` (`hoa_name`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FKTYE07` FOREIGN KEY (`enclosing_asset`) REFERENCES `assets` (`asset_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Table `HOADB`.`officer_presidents`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `officer_presidents` (
  `ho_id` int(4) NOT NULL,
  `position` varchar(45) NOT NULL,
  `election_date` date NOT NULL,
  PRIMARY KEY (`ho_id`,`position`,`election_date`),
  CONSTRAINT `FKTYE50` FOREIGN KEY (`ho_id`, `position`, `election_date`) REFERENCES `officer` (`ho_id`, `position`, `election_date`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- -----------------------------------------------------
-- Table `HOADB`.`asset_transactions`
-- -----------------------------------------------------
-- Dumping structure for table hoadb.asset_transactions
CREATE TABLE IF NOT EXISTS `asset_transactions` (
  `asset_id` int(4) NOT NULL,
  `transaction_date` date NOT NULL,
  `trans_hoid` int(4) NOT NULL,
  `trans_position` varchar(45) NOT NULL,
  `trans_electiondate` date NOT NULL,
  `isdeleted` tinyint(1) NOT NULL,
  `approval_hoid` int(4) DEFAULT NULL,
  `approval_position` varchar(45) DEFAULT NULL,
  `approval_electiondate` date DEFAULT NULL,
  `ornum` int(9) DEFAULT NULL,
  `transaction_type` enum('R','T','A') NOT NULL,
  PRIMARY KEY (`asset_id`,`transaction_date`),
  UNIQUE KEY `ornum_UNIQUE` (`ornum`),
  KEY `FKLANZ15_idx` (`trans_hoid`,`trans_position`,`trans_electiondate`),
  KEY `FKLANZ16_idx` (`approval_hoid`,`approval_position`,`approval_electiondate`),
  KEY `FKLANZ17_idx` (`ornum`),
  CONSTRAINT `FKLANZ01` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`asset_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FKLANZ15` FOREIGN KEY (`trans_hoid`, `trans_position`, `trans_electiondate`) REFERENCES `officer` (`ho_id`, `position`, `election_date`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FKLANZ16` FOREIGN KEY (`approval_hoid`, `approval_position`, `approval_electiondate`) REFERENCES `officer_presidents` (`ho_id`, `position`, `election_date`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FKLANZ17` FOREIGN KEY (`ornum`) REFERENCES `ref_ornumbers` (`ornum`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- -----------------------------------------------------
-- Table `HOADB`.`asset_activity`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `asset_activity` (
  `asset_id` int(4) NOT NULL,
  `activity_date` date NOT NULL,
  `activity_description` varchar(45) DEFAULT NULL,
  `tent_start` date DEFAULT NULL,
  `tent_end` date DEFAULT NULL,
  `act_start` date DEFAULT NULL,
  `act_end` date DEFAULT NULL,
  `cost` decimal(9,2) DEFAULT NULL,
  `status` enum('S','O','C') NOT NULL COMMENT 'S - Scheduled\nO - Ongoing\nC - Completed\n',
  PRIMARY KEY (`asset_id`,`activity_date`),
  CONSTRAINT `FKLANZ11` FOREIGN KEY (`asset_id`, `activity_date`) REFERENCES `asset_transactions` (`asset_id`, `transaction_date`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- -----------------------------------------------------
-- Table `HOADB`.`asset_transfer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `asset_transfer` (
  `asset_id` int(4) NOT NULL,
  `schedule_date` date NOT NULL,
  `act_date` date DEFAULT NULL,
  `source_lattitude` decimal(7,4) NOT NULL,
  `source_longitude` decimal(7,4) NOT NULL,
  `dest_latittude` decimal(7,4) NOT NULL,
  `dest_longitude` decimal(7,4) NOT NULL,
  `transfer_cost` decimal(9,2) DEFAULT NULL,
  `status` enum('S','O','C') NOT NULL COMMENT 'S - Scheduled\nO - Ongoing\nC - Completed\n',
  `completename` varchar(45) NOT NULL,
  PRIMARY KEY (`asset_id`,`schedule_date`),
  KEY `FKNORM35_idx` (`completename`),
  CONSTRAINT `FKAT07` FOREIGN KEY (`asset_id`, `schedule_date`) REFERENCES `asset_transactions` (`asset_id`, `transaction_date`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FKNORM88` FOREIGN KEY (`completename`) REFERENCES `outsiders` (`name`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- -----------------------------------------------------
-- Table `HOADB`.`asset_rentals`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `asset_rentals` (
  `asset_id` int(4) NOT NULL,
  `rental_date` date NOT NULL,
  `reservation_date` date NOT NULL,
  `resident_id` int(4) NOT NULL,
  `rental_amount` decimal(9,2) DEFAULT NULL,
  `discount` decimal(9,2) DEFAULT NULL,
  `status` enum('R','C','O','N') NOT NULL COMMENT 'R - Reserved\nC - Cancelled\nO - On-Rent\nN - Returned\n',
  `inspection_details` longtext DEFAULT NULL,
  `assessed_value` decimal(9,2) DEFAULT NULL,
  `accept_hoid` int(4) DEFAULT NULL,
  `accept_position` varchar(45) DEFAULT NULL,
  `accept_electiondate` date DEFAULT NULL,
  `return_date` date DEFAULT NULL,
  PRIMARY KEY (`asset_id`,`rental_date`),
  KEY `FKTYE10_idx` (`accept_hoid`,`accept_position`,`accept_electiondate`),
  KEY `FKTYE63_idx` (`resident_id`),
  CONSTRAINT `FKLANZ10` FOREIGN KEY (`asset_id`, `rental_date`) REFERENCES `asset_transactions` (`asset_id`, `transaction_date`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FKTYE10` FOREIGN KEY (`accept_hoid`, `accept_position`, `accept_electiondate`) REFERENCES `officer` (`ho_id`, `position`, `election_date`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FKTYE63` FOREIGN KEY (`resident_id`) REFERENCES `residents` (`resident_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Table `HOADB`.`donors`
-- -----------------------------------------------------
-- Dumping structure for table hoadb.donors
CREATE TABLE IF NOT EXISTS `donors` (
  `donorname` varchar(45) NOT NULL,
  `address` varchar(45) NOT NULL,
  PRIMARY KEY (`donorname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Table `HOADB`.`asset_donations`
-- -----------------------------------------------------
-- Dumping structure for table hoadb.asset_donations
CREATE TABLE IF NOT EXISTS `asset_donations` (
  `donation_id` int(4) NOT NULL,
  `donor_completename` varchar(45) NOT NULL,
  `donation_formfile` varchar(45) DEFAULT NULL,
  `date_donation` date NOT NULL,
  `accept_hoid` int(4) NOT NULL,
  `accept_position` varchar(45) NOT NULL,
  `accept_electiondate` date NOT NULL,
  `isdeleted` tinyint(1) NOT NULL,
  `approval_hoid` int(4) DEFAULT NULL,
  `approval_position` varchar(45) DEFAULT NULL,
  `approval_electiondate` date DEFAULT NULL,
  PRIMARY KEY (`donation_id`),
  KEY `FKTYE40_idx` (`accept_hoid`,`accept_position`,`accept_electiondate`),
  KEY `FKTYE68_idx` (`approval_hoid`,`approval_position`,`approval_electiondate`),
  KEY `FKNORM30_idx` (`donor_completename`),
  CONSTRAINT `FKNORM30` FOREIGN KEY (`donor_completename`) REFERENCES `donors` (`donorname`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FKTYE40` FOREIGN KEY (`accept_hoid`, `accept_position`, `accept_electiondate`) REFERENCES `officer` (`ho_id`, `position`, `election_date`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FKTYE68` FOREIGN KEY (`approval_hoid`, `approval_position`, `approval_electiondate`) REFERENCES `officer_presidents` (`ho_id`, `position`, `election_date`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Table `HOADB`.`donated_assets`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `donated_assets` (
  `donation_id` int(4) NOT NULL,
  `asset_id` int(4) NOT NULL,
  `amount_donated` decimal(9,2) NOT NULL,
  PRIMARY KEY (`donation_id`,`asset_id`),
  KEY `FKTYE30_idx` (`asset_id`),
  CONSTRAINT `FKTYE30` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`asset_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FKTYE31` FOREIGN KEY (`donation_id`) REFERENCES `asset_donations` (`donation_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- -----------------------------------------------------
-- Table `HOADB`.`donation_pictures`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `donation_pictures` (
  `donation_id` int(4) NOT NULL,
  `picturefile` varchar(45) NOT NULL,
  PRIMARY KEY (`donation_id`,`picturefile`),
  CONSTRAINT `FKTYE70` FOREIGN KEY (`donation_id`) REFERENCES `asset_donations` (`donation_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Table `HOADB`.`program`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `program` (
  `program_id` int(4) NOT NULL AUTO_INCREMENT,
  `hoa_name` varchar(45) NOT NULL,
  `description` varchar(200) NOT NULL,
  `purpose` varchar(200) NOT NULL,
  `intended_participants` int(3) NOT NULL,
  `sponsoring_officer_id` int(4) NOT NULL,
  `max_participants` int(3) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `start_date_registration` date NOT NULL,
  `status` enum('Open for registration','Closed for registration','Ongoing','Cancelled','Completed') NOT NULL,
  `budget` int(9) NOT NULL,
  PRIMARY KEY (`program_id`),
  KEY `fk_sponsoring_officer_id` (`sponsoring_officer_id`),
  KEY `fk_hoa_name_program` (`hoa_name`),
  CONSTRAINT `fk_hoa_name_program` FOREIGN KEY (`hoa_name`) REFERENCES `hoa` (`hoa_name`),
  CONSTRAINT `fk_sponsoring_officer_id` FOREIGN KEY (`sponsoring_officer_id`) REFERENCES `officer` (`ho_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7006 DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Table `HOADB`.`program_staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `program_staff` (
  `staff_id` int(4) NOT NULL AUTO_INCREMENT,
  `program_id` int(4) NOT NULL,
  `resident_id` int(4) NOT NULL,
  `rank` enum('Committee Head','Member') NOT NULL,
  `officer_incharge` int(4) NOT NULL,
  PRIMARY KEY (`staff_id`,`program_id`,`resident_id`) USING BTREE,
  KEY `fk_2_idx` (`staff_id` ASC, `program_id` ASC) VISIBLE,
  KEY `fk_program_id_staff` (`program_id`),
  KEY `fk_resident_id_staff` (`resident_id`),
  KEY `fk_officer_incharge` (`officer_incharge`),
  KEY `fk_accepting_officer_evidence` (`officer_incharge` , `program_id`),
  CONSTRAINT `fk_officer_incharge` FOREIGN KEY (`officer_incharge`) REFERENCES `officer` (`ho_id`),
  CONSTRAINT `fk_program_id_staff` FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_resident_id_staff` FOREIGN KEY (`resident_id`) REFERENCES `residents` (`resident_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;

DELIMITER //

CREATE TRIGGER max_staff_per_program BEFORE INSERT ON program_staff
FOR EACH ROW
BEGIN
  DECLARE staff_count INT;
  SELECT COUNT(*) INTO staff_count FROM program_staff WHERE program_id = NEW.program_id;
  IF staff_count >= 4 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot add more than 4 staff members to a program.';
  END IF;
END//

CREATE TRIGGER program_staff_trigger
AFTER UPDATE ON program_staff
FOR EACH ROW
BEGIN
    DECLARE num_members INT;
    DECLARE num_committee_heads INT;
    
    IF OLD.rank <> NEW.rank THEN
    SELECT COUNT(*) INTO num_members FROM program_staff
    WHERE program_id = NEW.program_id AND `rank` = 'Member';

    SELECT COUNT(*) INTO num_committee_heads FROM program_staff
    WHERE program_id = NEW.program_id AND `rank` = 'Committee Head';

    IF (NEW.rank = 'Member' AND num_members >= 3) OR
       (NEW.rank = 'Committee Head' AND num_committee_heads >= 1) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Must be 3 members and 1 committee head per program.';
    END IF;
  END IF;
END//


DELIMITER ;


-- -----------------------------------------------------
-- Table `HOADB`.`program_participants`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `program_participants` (
  `participant_id` int(4) NOT NULL AUTO_INCREMENT,
  `program_id` int(4) NOT NULL,
  `priority` tinyint(1) NOT NULL,
  `status` enum('Accepted','Denied', 'Pending') NOT NULL,
  `resident_id` int(4) NOT NULL,
  `staff_id` int(4) NOT NULL,
  `denied_reason` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`participant_id`,`resident_id`,`program_id`),
  INDEX `fk_paticipant_id_evidence_idx` (`participant_id` ASC, `program_id` ASC) VISIBLE,
  INDEX `fk_1_idx` (`program_id` ASC) VISIBLE,
  INDEX `fk_2_idx` (`staff_id` ASC, `program_id` ASC) VISIBLE,
  INDEX `fk_3_idx` (`resident_id` ASC) VISIBLE,
  CONSTRAINT `fk_1`
    FOREIGN KEY (`program_id`)
    REFERENCES `HOADB`.`program` (`program_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_2`
    FOREIGN KEY (`staff_id` , `program_id`)
    REFERENCES `HOADB`.`program_staff` (`staff_id` , `program_id`)
	ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_3`
    FOREIGN KEY (`resident_id`)
    REFERENCES `HOADB`.`residents` (`resident_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=3024 DEFAULT CHARSET=utf8;


DELIMITER //

CREATE TRIGGER max_participants_trigger_insert
BEFORE INSERT ON program_participants
FOR EACH ROW
BEGIN
  DECLARE num_participants INT;
  SELECT COUNT(*) INTO num_participants FROM program_participants WHERE program_id = NEW.program_id AND status = 'Accepted';
  IF num_participants >= (SELECT max_participants FROM program WHERE program_id = NEW.program_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The maximum number of participants has been reached for this program.';
  END IF;
END//

CREATE TRIGGER max_participants_trigger_update
AFTER UPDATE ON program_participants
FOR EACH ROW
BEGIN
  DECLARE num_participants INT;
  SELECT COUNT(*) INTO num_participants FROM program_participants WHERE program_id = NEW.program_id AND status = 'Accepted';
  IF num_participants > (SELECT max_participants FROM program WHERE program_id = NEW.program_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The maximum number of participants has been exceeded for this program.';
  END IF;
END//

CREATE TRIGGER denied_reason_trigger
BEFORE INSERT ON program_participants
FOR EACH ROW
BEGIN
    IF NEW.status NOT IN ('Accepted', 'Denied', 'Pending') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The status must be either Accepted or Denied.';
    END IF;
    IF NEW.status = 'Denied' AND NEW.denied_reason IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The denied_reason cannot be null when the status is "Denied".';
    END IF;
END//
DELIMITER ;


-- -----------------------------------------------------
-- Table `HOADB`.`program_evidence`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `program_evidence` (
  `evidence_id` int(4) NOT NULL AUTO_INCREMENT,
  `program_id` int(4) NOT NULL,
  `description` varchar(200) NOT NULL,
  `file_name` varchar(45) NOT NULL,
  `submitting_resident` int(4) NOT NULL,
  `accepting_officer` int(4) NOT NULL,
  `submitted_date` date NOT NULL,
  PRIMARY KEY (`evidence_id`),
  INDEX `fk_program_participant_id_evidence_idx` (`submitting_resident` ASC, `program_id` ASC) VISIBLE,
  INDEX `fk_accepting_officer_evidence_idx` (`accepting_officer` ASC) VISIBLE,
  CONSTRAINT `fk_program_participant_id_evidence`
    FOREIGN KEY (`submitting_resident` , `program_id`)
    REFERENCES `HOADB`.`program_participants` (`participant_id`, `program_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_accepting_officer_evidence` 
    FOREIGN KEY (`accepting_officer`)
    REFERENCES `HOADB`.`officer` (`ho_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9012 DEFAULT CHARSET=utf8;



-- -----------------------------------------------------
-- Table `HOADB`.`program_end`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `program_end` (
  `program_id` int(4) NOT NULL,
  `participant_id` int(4) NOT NULL,
  `feedback` varchar(200) NOT NULL,
  `rating` tinyint(1) unsigned NOT NULL,
  `suggestion` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`participant_id`),
  INDEX `fk_1_end_idx` (`participant_id` ASC, `program_id` ASC) VISIBLE,
  CONSTRAINT `fk_1_end`
    FOREIGN KEY (`participant_id` , `program_id`)
    REFERENCES `HOADB`.`program_participants` (`participant_id` , `program_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DELIMITER //
CREATE TRIGGER complete_program_only_trigger
BEFORE INSERT ON program_end
FOR EACH ROW
BEGIN
    DECLARE program_status VARCHAR(10);
    SELECT status INTO program_status FROM program WHERE program_id = NEW.program_id;
    IF program_status != 'Completed' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The program is not yet completed.';
    END IF;
END//

CREATE TRIGGER rating_limit_trigger
BEFORE INSERT ON program_end
FOR EACH ROW
BEGIN
    IF NEW.rating NOT BETWEEN 0 AND 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The rating should be between 0 and 5.';
    END IF;
END//


CREATE TRIGGER suggestion_trigger
BEFORE INSERT ON program_end
FOR EACH ROW
BEGIN
	IF NEW.suggestion IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Suggestion is NULL. Put any suggestion/s';
	END IF;
END//

DELIMITER ;

-- -----------------------------------------------------
-- Table `HOADB`.`program_expense`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `program_expense` (
  `expense_id` int(4) NOT NULL AUTO_INCREMENT,
  `program_id` int(4) NOT NULL,
  `expense_date` date NOT NULL,
  `description` varchar(200) NOT NULL,
  `amount` int(9) NOT NULL,
  `staff_id` int(4) NOT NULL,
  `type` enum('Manpower','Services','Materials','Others') NOT NULL,
  `scanned_ornum` varchar(45) NOT NULL,
  PRIMARY KEY (`expense_id`),
  INDEX `fk_program_id_expense_idx` (`program_id` ASC) VISIBLE,
  INDEX `fk_program_staff_id_expense_idx` (`program_id` ASC, `staff_id` ASC) VISIBLE,
  INDEX `fk_self` (`expense_id` ASC) VISIBLE,
  CONSTRAINT `fk_program_id_expense`
    FOREIGN KEY (`program_id`)
    REFERENCES `HOADB`.`program` (`program_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_program_staff_id_expense`
    FOREIGN KEY (`program_id` , `staff_id`)
    REFERENCES `HOADB`.`program_staff` (`program_id` , `staff_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_enclosing_type_id_expense`
    FOREIGN KEY (`expense_id`)
    REFERENCES `HOADB`.`program_expense` (`expense_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DELIMITER //

CREATE TRIGGER cancelled_program
BEFORE INSERT ON program_expense
FOR EACH ROW
BEGIN
	DECLARE program_status ENUM ('Open for registration','Closed for registration','Ongoing','Cancelled','Completed');
    SELECT status INTO program_status FROM program WHERE program_id = NEW.program_id;
    IF program_status = 'Cancelled' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot add an expense to a cancelled program.';
    END IF;
END//

DELIMITER ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- -----------------------------------------------------
-- Data for table `HOADB`.`ref_collectiondays`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`ref_collectiondays` (`days`) VALUES (1);
INSERT INTO `HOADB`.`ref_collectiondays` (`days`) VALUES (2);
INSERT INTO `HOADB`.`ref_collectiondays` (`days`) VALUES (3);
INSERT INTO `HOADB`.`ref_collectiondays` (`days`) VALUES (4);
INSERT INTO `HOADB`.`ref_collectiondays` (`days`) VALUES (5);
INSERT INTO `HOADB`.`ref_collectiondays` (`days`) VALUES (6);
INSERT INTO `HOADB`.`ref_collectiondays` (`days`) VALUES (7);
INSERT INTO `HOADB`.`ref_collectiondays` (`days`) VALUES (8);
INSERT INTO `HOADB`.`ref_collectiondays` (`days`) VALUES (9);
INSERT INTO `HOADB`.`ref_collectiondays` (`days`) VALUES (10);
INSERT INTO `HOADB`.`ref_collectiondays` (`days`) VALUES (11);
INSERT INTO `HOADB`.`ref_collectiondays` (`days`) VALUES (12);
INSERT INTO `HOADB`.`ref_collectiondays` (`days`) VALUES (13);
INSERT INTO `HOADB`.`ref_collectiondays` (`days`) VALUES (14);
INSERT INTO `HOADB`.`ref_collectiondays` (`days`) VALUES (15);
INSERT INTO `HOADB`.`ref_collectiondays` (`days`) VALUES (16);
INSERT INTO `HOADB`.`ref_collectiondays` (`days`) VALUES (17);
INSERT INTO `HOADB`.`ref_collectiondays` (`days`) VALUES (18);
INSERT INTO `HOADB`.`ref_collectiondays` (`days`) VALUES (19);
INSERT INTO `HOADB`.`ref_collectiondays` (`days`) VALUES (20);

COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`ref_regions`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`ref_regions`
  (regions)
VALUES
  ('IV-A'),
  ('NCR'),
  ('CALABARZON'),
  ('Ilocos Region'),
  ('Central Region');
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`provinces`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`provinces`
  (province,region)
VALUES
  ('Oriental Mindoro','IV-A'),
  ('National Capital Region','NCR'),
  ('Cavite','CALABARZON'),
  ('Rizal','Ilocos Region'),
  ('Quezon','Central Region'),
  ('Laguna','CALABARZON'),
  ('Ilocos Norte','Ilocos Region'),
  ('Zambales','Central Region'),
  ('Pangasinan','Ilocos Region'),
  ('Batangas','CALABARZON'),
  ('Bataan','Central Region'),
  ('Ilocos Sur','Ilocos Region'),
  ('Pampanga','Central Region'),
  ('La Union','Ilocos Region'),
  ('Nueva Ecija','Central Region'),
  ('Tarlac','CALABARZON');
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`zipcodes`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`zipcodes`
  (barangay,city,province,zipcode)
VALUES
  ('Alabang','Muntinlupa','National Capital Region',1775),
  ('Bayanan','Lamesa','Oriental Mindoro',1801),
  ('Bayanan','Muntinlupa','National Capital Region',1771),
  ('Poblacion','Calapan','Oriental Mindoro',1800),
  ('Tunasan','Muntinlupa','National Capital Region',1770),
  ('Sampaloc','Dasmariñas','Cavite',4114),
  ('Inosluban','Lipa','Batangas',4217),
  ('San Mateo','Dasmariñas','Cavite',4115),
  ('Calawis','Antipolo','Rizal',1870),
  ('Mabato','Calamba','Laguna',4027),
  ('Francisco','Tagaytay','Cavite',4120),
  ('San Roque','Cainta','Rizal',1900),
  ('Aguso','Tarlac City','Tarlac',2300),
  ('Dulag','Lingayen','Pangasinan',2401),
  ('Canlalay','Biñan','Laguna',4033),
  ('Muzon','Taytay','Rizal',1920),
  ('Balagtas','Batangas City','Batangas',4200),
  ('Bagumbayan','Tanauan','Batangas',4232),
  ('Tenejero','Balanga','Bataan',2100),
  ('Malitlit','Santa Rosa','Laguna',4026),
  ('Don Jose','Santa Rosa','Laguna',4026),
  ('San Vicente','Biñan','Laguna',4033),
  ('Santa Ana','Taytay','Rizal',1920),
  ('San Juan','Antipolo','Rizal',1870),
  ('Magdalo','Imus','Cavite',4103),
  ('Santa Cruz II','Dasmariñas','Cavite',4114),
  ('San Nicolas I','Bacoor','Cavite',4102),
  ('Marauoy','Lipa','Batangas',4217),
  ('Dolores','Taytay','Rizal',1920);
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`hoa`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`hoa`
  (hoa_name,ofcaddr_streetno,ofcaddr_street,ofcaddr_barangay,ofcaddr_city,ofcaddr_province,ofcaddr_lattitude,ofcaddr_longitude,year_establishment,website,subdivision_name,req_scannedarticles,req_notarizedbylaws,req_minutes,req_attendance,req_certification,req_codeofethics,req_regularmonthly,req_collectionday)
VALUES
  ('SJH',15,'Chico St','Alabang','Muntinlupa','National Capital Region',14.234,29.29,'2003-12-13','www.sjh.com','Sait Joseph Homes','sjh_articles.pdf','sjh_bylaws.pdf','sjh_minutes.pdf','sjh_attendance.pdf','sjh_certification.pdf','sjh_codeofethics.pdf',250,10),
  ('SMH',10,'Jade St','Bayanan','Muntinlupa','National Capital Region',10.456,20.32,'2005-05-04','www.smh.com','Saint Marys Homes','smh_articles.pdf','smh_bylaws.pdf','smh_minutes.pdf','smh_attendance.pdf','smh_certification.pdf','smh_codeofethics.pdf',350,18),
  ('Marilag Homeowners Association',12,'Citrus St','Sampaloc','Dasmarinas','Cavite',14.3294,120.94,'2006-06-15','www.marilagsubdivision.com','Marilag Subdivision','ms_articles.pdf','ms_bylaws.pdf','ms_minutes.pdf','ms_attendance.pdf','ms_certification.pdf','ms_codeofethics.pdf',300,15),
  ('Bloomfields Heights Homeowners Association',24,'Jasmine St','Inosluban','Lipa','Batangas',13.9541,121.15,'2012-05-20','www.bloomfieldsheightslipa.com','Bloomfields Heights Lipa','bhl_articles.pdf','bhl_bylaws.pdf','bhl_minutes.pdf','bhl_attendance.pdf','bhl_certification.pdf','bhl_codeofethics.pdf',500,16);

COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`hoa_geninfosheets`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`hoa_geninfosheets`
  (hoa_name,gen_infosheet)
VALUES
  ('SJH','sjh_property01.pdf'),
  ('SJH','sjh_property02.pdf'),
  ('SJH','sjh_property03.pdf'),
  ('SJH','sjh_property04.pdf'),
  ('SJH','sjh_property05.pdf'),
  ('SJH','sjh_property06.pdf'),
  ('SJH','sjh_property07.pdf'),
  ('SJH','sjh_property08.pdf'),
  ('SJH','sjh_property09.pdf'),
  ('SJH','sjh_property10.pdf'),
  ('SJH','sjh_property11.pdf'),
  ('SJH','sjh_property12.pdf'),
  ('SJH','sjh_property13.pdf'),
  ('SJH','sjh_property14.pdf'),
  ('SJH','sjh_property15.pdf'),
  ('SMH','smh_property01.pdf'),
  ('SMH','smh_property03.pdf'),
  ('SMH','smh_property04.pdf'),
  ('SMH','smh_property05.pdf'),
  ('SMH','smh_property06.pdf'),
  ('SMH','smh_property07.pdf'),
  ('SMH','smh_property08.pdf'),
  ('SMH','smh_property09.pdf'),
  ('SMH','smh_property10.pdf'),
  ('SMH','smh_property11.pdf'),
  ('SMH','smh_property12.pdf'),
  ('SMH','smh_property13.pdf'),
  ('SMH','smh_property14.pdf'),
  ('SMH','smh_property15.pdf'),
  ('Marilag Homeowners Association','mha_property01.pdf'),
  ('Marilag Homeowners Association','mha_property02.pdf'),
  ('Marilag Homeowners Association','mha_property03.pdf'),
  ('Marilag Homeowners Association','mha_property04.pdf'),
  ('Marilag Homeowners Association','mha_property05.pdf'),
  ('Marilag Homeowners Association','mha_property06.pdf'),
  ('Marilag Homeowners Association','mha_property07.pdf'),
  ('Marilag Homeowners Association','mha_property08.pdf'),
  ('Marilag Homeowners Association','mha_property09.pdf'),
  ('Marilag Homeowners Association','mha_property10.pdf'),
  ('Marilag Homeowners Association','mha_property11.pdf'),
  ('Marilag Homeowners Association','mha_property12.pdf'),
  ('Marilag Homeowners Association','mha_property13.pdf'),
  ('Marilag Homeowners Association','mha_property14.pdf'),
  ('Marilag Homeowners Association','mha_property15.pdf'),
  ('Bloomfields Heights Homeowners Association','bhha_property01.pdf'),
  ('Bloomfields Heights Homeowners Association','bhha_property02.pdf'),
  ('Bloomfields Heights Homeowners Association','bhha_property03.pdf'),
  ('Bloomfields Heights Homeowners Association','bhha_property04.pdf'),
  ('Bloomfields Heights Homeowners Association','bhha_property05.pdf'),
  ('Bloomfields Heights Homeowners Association','bhha_property06.pdf'),
  ('Bloomfields Heights Homeowners Association','bhha_property07.pdf'),
  ('Bloomfields Heights Homeowners Association','bhha_property08.pdf'),
  ('Bloomfields Heights Homeowners Association','bhha_property09.pdf'),
  ('Bloomfields Heights Homeowners Association','bhha_property10.pdf'),
  ('Bloomfields Heights Homeowners Association','bhha_property11.pdf'),
  ('Bloomfields Heights Homeowners Association','bhha_property12.pdf'),
  ('Bloomfields Heights Homeowners Association','bhha_property13.pdf'),
  ('Bloomfields Heights Homeowners Association','bhha_property14.pdf'),
  ('Bloomfields Heights Homeowners Association','bhha_property15.pdf');
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`people`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`people`
  (peopleid,lastname,firstname,gender,email,facebook,picturefile,birthday)
VALUES
  (1000,'Kent','Cecil','M','cecil_kent28@gmail.com','https://www.facebook.com/cecil.kent','/images/individuals/cecil_kent.jpg','1952-12-28'),
  (1001,'Monroe','Yuvraj','M','yuvraj.monroe@gmail.com','https://www.facebook.com/yuvraj.monroe','/images/individuals/yuvraj_monroe.jpg','1979-03-08'),
  (1002,'Yang','Corey','M','corey.yang@gmail.com','https://www.facebook.com/corey.yang','/images/individuals/corey_yang.jpg','1989-02-23'),
  (1003,'Haines','Faiza','F','faiza.haines@gmail.com','https://www.facebook.com/faiza.haines','/images/individuals/faiza_haines.jpg','1983-09-23'),
  (1004,'Mckenzie','Benedict','M','benedict.mckenzie@gmail.com','https://www.facebook.com/benedict.mckenzie','/images/individuals/benedict_mckenzie.jpg','1983-01-15'),
  (1005,'Mcleod','Alissa','F','alissa.mcleod@gmail.com','https://www.facebook.com/alissa.mcleod','/images/individuals/alissa_mcleod.jpg','1951-12-21'),
  (1006,'Becker','Kacper','M','kacper.becker@gmail.com','https://www.facebook.com/kacper.becker','/images/individuals/kacper_becker.jpg','1974-10-22'),
  (1007,'Trevino','Gary','M','gary.trevino@gmail.com','https://www.facebook.com/gary.trevino','/images/individuals/gary_trevino.jpg','1967-07-20'),
  (1008,'Sykes','Mariam','F','mariam.sykes@gmail.com','https://www.facebook.com/mariam.sykes','/images/individuals/mariam_sykes.jpg','1968-07-30'),
  (1009,'Nelson','Keisha','F','keisha.nelson@gmail.com','https://www.facebook.com/keisha.nelson','/images/individuals/keisha_nelson.jpg','1959-06-18'),
  (1010,'Wagner','Amira','F','amira.wagner@gmail.com','https://www.facebook.com/amira.wagner','/images/individuals/amira_wagner.jpg','1981-08-14'),
  (1011,'Crosby','Mohamed','M','mohamed.crosby@gmail.com','https://www.facebook.com/mohamed.crosby','/images/individuals/mohamed_crosby.jpg','1970-12-02'),
  (1012,'Ferrell','Eleni','F','eleni.ferrell@gmail.com','https://www.facebook.com/eleni.ferrell','/images/individuals/eleni_ferrell.jpg','1998-01-10'),
  (1013,'Schroeder','Rosalie','F','rosalie_schroeder06@gmail.com','https://www.facebook.com/rosalie.schroeder','/images/individuals/rosalie_schroeder.jpg','2000-06-30'),
  (1014,'Johnson','Peter','M','peter_johnson06@gmail.com','https://www.facebook.com/peter.johnson','/images/individuals/peter_johnson.jpg','1992-07-03'),
  (1015,'Dejesus','Ismael','M','ismael.dejesus@gmail.com','https://www.facebook.com/ismael.dejesus','/images/individuals/ismael_dejesus.jpg','1957-01-05'),
  (1016,'Howe','James','M','james.howe@gmail.com','https://www.facebook.com/james.howe','/images/individuals/james_howe.jpg','1966-08-26'),
  (1017,'Rosario','Phyllis','F','phyllis.rosario@gmail.com','https://www.facebook.com/phyllis.rosario','/images/individuals/phyllis_rosario.jpg','1958-11-18'),
  (1018,'Doyle','Ayub','M','ayub_doyle72@gmail.com','https://www.facebook.com/ayub.doyle','/images/individuals/ayub_doyle.jpg','1972-03-04'),
  (1019,'Singleton','Muhammed','M','muhammed.singleton@gmail.com','https://www.facebook.com/muhammed.singleton','/images/individuals/muhammed_singleton.jpg','1976-05-29'),
  (1020,'Williamson','Reggie','M',NULL,'https://www.facebook.com/reggie.williamson','/images/individuals/reggie_williamson.jpg','1966-05-21'),
  (1021,'Petty','Josie','F',NULL,'https://www.facebook.com/josie.petty','/images/individuals/josie_petty.jpg','1983-04-03'),
  (1022,'Garner','Ashton','M','ashton.garner@gmail.com','https://www.facebook.com/ashton.garner','/images/individuals/ashton_garner.jpg','1966-01-21'),
  (1023,'Conley','William','M','william.conley@gmail.com','https://www.facebook.com/william.conley','/images/individuals/william_conley.jpg','1981-05-27'),
  (1024,'Johns','Tiana','F','tiana.johns@gmail.com','https://www.facebook.com/tiana.johns','/images/individuals/tiana_johns.jpg','1953-08-02'),
  (1025,'Armstrong','Donald','M',NULL,'https://www.facebook.com/donald.armstrong','/images/individuals/donald_armstrong.jpg','1964-02-21'),
  (1026,'Savage','Duncan','M','duncan.savage@gmail.com','https://www.facebook.com/duncan.savage','/images/individuals/duncan_savage.jpg','1986-10-21'),
  (1027,'OReilly','Noel','M','noel.oreilly@gmail.com','https://www.facebook.com/noel.oreilly','/images/individuals/noel_oreilly.jpg','1974-12-21'),
  (1028,'Howard','Abdullahi','M','abdullahi.howard@gmail.com','https://www.facebook.com/abdullahi.howard','/images/individuals/abdullahi_howard.jpg','1984-05-22'),
  (1029,'Fitzpatrick','Joanna','F','joanna.fitzpatrick@gmail.com','https://www. facebook.com/joanna.fitzpatrick','/images/individuals/joanna_fitzpatrick.jpg','1967-10-13'),
  (1030,'Mcgee','Ridwan','M','ridwan_mcgee09@gmail.com','https://www.facebook.com/ridwan.mcgee','/images/individuals/ridwan_mcgee.jpg','1965-09-20'),
  (1031,'Calderon','Ella','F',NULL,'https://www.facebook.com/ella.calderon','/images/individuals/ella_calderon.jpg','1953-07-12'),
  (1032,'Franco','Rodney','M','rodney.franco@gmail.com','https://www.facebook.com/rodney.franco','/images/individuals/rodney_franco.jpg','1993-02-11'),
  (1033,'Craig','Oskar','M','oskar.craig@gmail.com','https://www.facebook.com/oskar.craig','/images/individuals/oskar_craig.jpg','1978-09-18'),
  (1034,'Davies','Maximus','M','maximus.davies@gmail.com','https://www.facebook.com/maximus.davies','/images/individuals/maximus_davies.jpg','1962-01-22'),
  (1035,'Gonzalez','Heather','F','heather.gonzalez@gmail.com','https://www.facebook.com/heather.gonzalez','/images/individuals/heather_gonzalez.jpg','1992-10-01'),
  (1036,'Snyder','Kamran','M','kamran_snyder86@gmail.com','https://www.facebook.com/kamran.snyder','/images/individuals/kamran_snyder.jpg','1986-06-15'),
  (1037,'Russell','Edgar','M','ed_russell09@gmail.com','https://www.facebook.com/edgar.russell','/images/individuals/edgar_russell.jpg','1974-09-01'),
  (1038,'Blanchard','Fannie','F',NULL,'https://www.facebook.com/fannie.blanchard','/images/individuals/fannie_blanchard.jpg','1966-08-03'),
  (1039,'Knox','Estelle','F','estelle.knox@gmail.com','https://www.facebook.com/estelle.knox','/images/individuals/estelle_knox.jpg','1980-04-15'),
  (1040,'Bryant','Jeremiah','M','jeremiah.bryant@gmail.com','https://www.facebook.com/jeremiah.bryant','/images/individuals/jeremiah_bryant.jpg','1953-05-07'),
  (1041,'Willis','John','M',' john.willis@gmail.com','https://www.facebook.com/john.willis','/images/individuals/john_willis.jpg','1995-07-26'),
  (1042,'Coleman','Jay','M',' jay_coleman80@gmail.com','https://www.facebook.com/jay.coleman','/images/individuals/jay_coleman.jpg','1980-04-03'),
  (1043,'Pearson','Anjali','F',NULL,'https://www.facebook.com/anjali.pearson','/images/individuals/anjali_pearson.jpg','1990-11-19'),
  (1044,'Pena','Maddison','F','maddison_pena11@gmail.com','https://www.facebook.com/maddison.pena','/images/individuals/maddison_pena.jpg','2000-11-05');
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`homeowner`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`homeowner`
  (ho_id,hostart_date,undertaking,want_member,other_streetno,other_street,other_barangay,other_city,other_province,other_longitude,other_lattitude,other_email,other_mobile)
VALUES
  (1000,'2002-05-04',1,1,'10','Emerald St','San Mateo','Dasmariñas','Cavite','15.3','49','sparklyunicorns@gmail.com','9081376718'),
  (1001,'2002-05-02',1,1,'21','Ruby St','Calawis','Antipolo','Rizal','14','11','beachbumsquad@gmail.com','9115191730'),
  (1002,'2002-02-01',1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (1003,'2002-04-04',1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (1004,'2002-05-14',1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (1005,'2002-02-05',1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (1006,'2002-05-06',1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (1007,'2002-04-12',1,1,NULL,NULL,NULL,NULL,NULL,'17','13',NULL,'9709448492'),
  (1008,'2002-04-05',1,1,'1','National Road','Mabato','Calamba','Laguna','16','23','happygoatfarmers@gmail.com','9756686488'),
  (1009,'2022-03-15',1,1,'7','Banana St','Santa Ana','Taytay','Rizal',NULL,NULL,'mysticaldragonfly@gmail.com','9187348943'),
  (1010,'2022-03-12',1,1,'3','Orange St','Francisco','Tagaytay','Cavite','35','43','wonderlandexplorer@gmail.com','9818739319'),
  (1011,'2022-04-01',0,0,'15','Apple St','San Roque','Cainta','Rizal','47','44','rockstartraveller@gmail.com','9738854885'),
  (1012,'2022-04-10',0,0,'4','National Highway','Aguso','Tarlac City','Tarlac','20','33','bubbletealover@gmail.com','9988806592'),
  (1013,'2022-02-19',1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (1014,'2022-03-27',1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (1015,'2002-04-05',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (1016,'2002-04-04',1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (1017,'2002-04-05',1,1,'20','Papaya St','Dulag','Lingayen','Pangasinan','28','25','midnightowlparty@gmail.com','9090056649'),
  (1018,'2022-03-15',0,0,'24','Kamote St','Canlalay','Biñan','Laguna','15','49','chocolatechipcookiecraver@gmail.com','9604910450'),
  (1019,'2022-03-12',1,1,'31','Saging St','Muzon','Taytay','Rizal','14','42','lightningboltadventures@gmail.com','9361430110'),
  (1020,'2002-05-04',0,0,'32','Potato St','Balagtas','Batangas City','Batangas',NULL,NULL,'cosmicpenguinparty@gmail.com','9572968295'),
  (1021,'2002-04-12',0,0,'11','Radish St','Bagumbayan','Tanauan','Batangas','35','25',NULL,'9967737503'),
  (1022,'2022-03-15',1,1,'3','Sibuyas St','Tenejero','Balanga','Bataan','43','43','islandhopperadventurer@gmail.com','9365636494'),
  (1023,'2002-04-05',1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (1024,'2022-03-12',1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (1025,'2022-03-15',1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (1026,'2002-04-05',1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (1027,'2022-03-12',1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (1028,'2002-02-05',1,1,'9','Kalamansi St','Malitlit','Santa Rosa','Laguna','24','24','sunflowerchild@gmail.com','9722006539'),
  (1029,'2002-05-02',1,1,'5','National Road','Don Jose','Santa Rosa','Laguna',NULL,NULL,'rainbowwarriorsquad@gmail.com','9609451946'),
  (1030,'2022-03-15',0,0,'6','National Highway','San Vicente','Biñan','Laguna',NULL,NULL,'coffeebeanconnoisseur@gmail.com','9222212346'),
  (1031,'2002-04-05',1,1,'10','National Road','Santa Ana','Taytay','Rizal','13','12','mermaidtailadventures@gmail.com','9293258574'),
  (1032,'2002-05-04',1,1,'35','National Road','San Juan','Antipolo','Rizal','13','43',NULL,'9930695557'),
  (1033,'2002-02-05',1,1,'19','Grapes St','Magdalo','Imus','Cavite','41','12','bookwormwanderlust@gmail.com','9837101136'),
  (1034,'2022-04-10',1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (1035,'2002-04-12',1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (1036,'2002-05-14',1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (1037,'2002-05-02',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (1038,'2002-04-12',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (1039,'2002-04-04',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (1040,'2022-04-10',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
  (1041,'2022-03-15',1,1,'8','Strawberry St','Santa Cruz II','Dasmariñas','Cavite',NULL,NULL,'wildflowerwanderer@gmail.com','9868240106'),
  (1042,'2002-04-05',0,0,'6','National Road','San Nicolas I','Bacoor','Cavite','12','20',NULL,'9448715786'),
  (1043,'2002-04-04',1,1,'33','Durian St','Marauoy','Lipa','Batangas','15','44','auroraborealisadventurer@gmail.com','9721676916'),
  (1044,'2022-04-10',0,0,'29','Mangga St','Dolores','Taytay','Rizal','25','13','neonlightsnightowl@gmail.com','9244325615');
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`household`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`household`
VALUES
  (6001),
  (6002),
  (6003),
  (6004),
  (6005),
  (6006),
  (6007),
  (6008),
  (6009),
  (6010),
  (6011),
  (6012),
  (6013),
  (6014),
  (6015),
  (6016),
  (6017),
  (6018),
  (6019),
  (6020),
  (6021),
  (6022),
  (6023),
  (6024),
  (6025),
  (6026),
  (6027),
  (6028),
  (6029),
  (6030);
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`properties`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`properties` (`property_code`, `hoa_name`, `size`, `turnover_date`, `ho_id`, `household_id`) 
VALUES
  ('B01L01','SJH',25,'2003-01-01',1001,NULL),
  ('B01L01','SMH',40,'2003-01-02',1012,NULL),
  ('B01L02','SJH',25,'2003-01-02',1001,NULL),
  ('B01L03','SJH',25,'2003-01-03',1002,6001),
  ('B01L04','SJH',25,'2003-01-04',1002,NULL),
  ('B01L05','SJH',25,'2003-01-05',1001,NULL),
  ('B02L01','SJH',25,'2003-01-05',1004,NULL),
  ('B02L02','SJH',25,'2003-01-04',1005,6002),
  ('B02L03','SJH',25,'2003-01-03',1006,NULL),
  ('B02L04','SJH',25,'2003-01-02',1001,NULL),
  ('B02L05','SJH',25,'2003-01-01',1004,NULL),
  ('B03L01','SJH',25,'2003-01-01',1006,NULL),
  ('B03L02','SJH',25,'2003-01-01',1007,NULL),
  ('B03L03','SJH',25,'2003-01-05',1008,6015),
  ('B03L04','SJH',25,'2003-01-04',1009,6006),
  ('B03L05','SJH',25,'2003-01-03',1011,NULL),
  ('B04L01','SJH',30,'2003-01-02',1013,NULL),
  ('B04L02','SJH',30,'2003-01-05',1014,NULL),
  ('B04L03','SJH',30,'2003-01-03',1003,NULL),
  ('B04L05','SJH',40,'2003-01-03',1010,NULL),
  ('B04L06','SJH',25,'2003-01-01',1015,NULL),
  ('B04L07','SJH',30,'2003-01-01',1010,NULL),
  ('B04L08','SJH',25,'2003-01-01',1011,NULL),
  ('B04L09','SJH',25,'2003-01-05',1012,NULL),
  ('B04L10','SJH',25,'2003-01-03',1013,NULL),
  ('B04L11','SJH',25,'2003-01-01',1014,NULL),
  ('B04L12','SJH',100,'2003-01-05',1015,NULL),
  ('B04L13','SJH',40,'2003-01-03',1006,NULL),
  ('B04L14','SJH',40,'2003-01-04',1007,NULL),
  ('B04L15','SJH',40,'2003-01-01',1003,NULL),
  ('B01L01','Marilag Homeowners Association',50,'2003-01-01',1002,NULL),
  ('B01L02','Marilag Homeowners Association',100,'2003-01-02',1004,NULL),
  ('B01L03','Marilag Homeowners Association',50,'2003-01-02',1035,NULL),
  ('B01L04','Marilag Homeowners Association',30,'2003-01-03',1005,NULL),
  ('B01L05','Marilag Homeowners Association',25,'2003-01-04',1032,6008),
  ('B02L01','Marilag Homeowners Association',50,'2003-01-05',1018,6017),
  ('B02L02','Marilag Homeowners Association',25,'2003-01-05',1002,NULL),
  ('B02L03','Marilag Homeowners Association',30,'2003-01-04',1040,NULL),
  ('B02L04','Marilag Homeowners Association',100,'2003-01-03',1005,NULL),
  ('B02L05','Marilag Homeowners Association',40,'2003-01-02',1008,6028),
  ('B02L06','Marilag Homeowners Association',25,'2003-01-01',1014,NULL),
  ('B01L01','Bloomfields Heights Homeowners Association',30,'2003-01-01',1003,6014),
  ('B01L02','Bloomfields Heights Homeowners Association',25,'2003-01-01',1031,6004),
  ('B01L03','Bloomfields Heights Homeowners Association',25,'2003-01-05',1011,NULL),
  ('B01L04','Bloomfields Heights Homeowners Association',50,'2003-01-04',1023,NULL),
  ('B01L05','Bloomfields Heights Homeowners Association',50,'2003-01-03',1011,6024),
  ('B01L06','Bloomfields Heights Homeowners Association',25,'2003-01-02',1017,6009),
  ('B01L07','Bloomfields Heights Homeowners Association',100,'2003-01-05',1022,6027),
  ('B01L08','Bloomfields Heights Homeowners Association',100,'2003-01-03',1029,6012),
  ('B02L01','Bloomfields Heights Homeowners Association',40,'2003-01-03',1027,NULL),
  ('B02L02','Bloomfields Heights Homeowners Association',30,'2003-01-01',1026,NULL),
  ('B02L03','Bloomfields Heights Homeowners Association',100,'2003-01-01',1028,6003),
  ('B01L02','SMH',100,'2003-01-01',1037,NULL),
  ('B01L03','SMH',30,'2003-01-05',1016,NULL),
  ('B01L04','SMH',30,'2003-01-03',1010,6022),
  ('B01L05','SMH',100,'2003-01-01',1021,6010),
  ('B01L06','SMH',25,'2003-01-05',1025,NULL),
  ('B01L07','SMH',40,'2003-01-03',1042,6019),
  ('B01L08','SMH',30,'2003-01-04',1041,6030),
  ('B01L09','SMH',25,'2003-01-01',1039,NULL);
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`residents`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO  `HOADB`.`residents`
  (resident_id,renter,relationship,undertaking,authorized,household_id,last_update)
VALUES
  (1009,1,'Homeowners Friend',1,'Yes',6001,'2022-07-17'),
  (1023,1,'Homeowners Friend',1,'No',6001,'2022-05-22'),
  (1041,0,'Homeowner',1,'Yes',6001,'2022-12-03'),
  (1004,1,'None',1,'Yes',6009,'2023-02-01'),
  (1006,0,'None',1,'Yes',6010,'2022-10-08'),
  (1031,0,'Homeowner',1,'No',6002,'2023-01-15'),
  (1024,0,'Homeowner',1,'No',6003,'2022-09-19'),
  (1029,1,'None',1,'No',6011,'2022-11-26'),
  (1025,1,'None',1,'Yes',6012,'2022-06-13'),
  (1010,1,'Homeowners Mother',1,'Yes',6003,'2022-03-28'),
  (1034,0,'None',1,'Yes',6013,'2023-03-22'),
  (1018,1,'Homeowners Friend',1,'Yes',6002,'2022-08-05'),
  (1021,0,'Homeowners Wife',1,'Yes',6002,'2022-04-12'),
  (1013,0,'None',1,'No',6014,'2023-02-27'),
  (1014,0,'None',1,'Yes',6015,'2022-12-17'),
  (1015,0,'None',1,'Yes',6016,'2023-03-09'),
  (1030,0,'Homeowner',1,'No',6004,'2022-06-07'),
  (1003,0,'Homeowners Husband',1,'Yes',6004,'2022-12-11'),
  (1020,1,'None',1,'No',6017,'2022-10-15'),
  (1035,1,'Homeowners Sibling',1,'Yes',6005,'2022-04-19'),
  (1033,1,'None',1,'Yes',6018,'2022-09-24'),
  (1017,1,'Homeowners Sibling',1,'No',6005,'2022-11-18'),
  (1040,1,'None',1,'No',6019,'2022-03-12'),
  (1001,1,'None',1,'Yes',6020,'2023-01-10'),
  (1032,0,'Homeowner',1,'Yes',6005,'2022-05-11'),
  (1000,1,'None',1,'No',6021,'2022-08-14'),
  (1042,1,'None',1,'Yes',6022,'2023-03-17'),
  (1002,0,'None',1,'Yes',6023,'2022-12-23'),
  (1005,1,'Homeowner',1,'No',6006,'2022-10-02'),
  (1038,1,'None',1,'No',6024,'2023-02-23');
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`ref_positions`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`ref_positions` (`position`) VALUES ('President');
INSERT INTO `HOADB`.`ref_positions` (`position`) VALUES ('Vice-President');
INSERT INTO `HOADB`.`ref_positions` (`position`) VALUES ('Treasurer');
INSERT INTO `HOADB`.`ref_positions` (`position`) VALUES ('Auditor');
INSERT INTO `HOADB`.`ref_positions` (`position`) VALUES ('Secretary');

COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`outsiders`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`outsiders`
  (name,mobileno)
VALUES
  ('Emily Smith',9817776366),
  ('Michael Johnson',9824335454),
  ('Sarah Brown',9886696935),
  ('David Garcia',9185636018),
  ('Olivia Davis',9260097402),
  ('William Rodriguez',9119310085),
  ('Sophia Martinez',9146459486),
  ('Ethan Hernandez',9289243759),
  ('Ava Lopez',9581264435),
  ('Benjamin Gonzalez',9576665653),
  ('Emma Perez',9515986688),
  ('Jacob Taylor',9875536281),
  ('Isabella Anderson',9324496683),
  ('Christopher Wilson',9818295470),
  ('Mia Jackson',9940889586),
  ('Matthew Wright',9345309555),
  ('Charlotte Walker',9301740569),
  ('Nicholas White',9164548730),
  ('Amelia Harris',9595258449),
  ('Alexander Clark',9689806924),
  ('Harper Lewis',9669850869),
  ('Tyler Young',9403537854),
  ('Abigail Allen',9388698748),
  ('Anthony King',9429160406),
  ('Grace Wright',9064172047),
  ('James Scott',9473148654),
  ('Scarlett Green',9711023734),
  ('Benjamin Baker',9905653154),
  ('Natalie Adams',9330631494),
  ('Daniel Nelson',9176720141),
  ('Madison Carter',9906089259),
  ('Christopher Mitchell',9740915736),
  ('Elizabeth Perez',9141286886),
  ('Ryan Roberts',9304494353),
  ('Victoria Turner',9123482894),
  ('Joshua Phillips',9274957805),
  ('Claire Campbell',9201122149),
  ('Andrew Parker',9432351657),
  ('Aria Evans',9135256112),
  ('William Edwards',9844975733),
  ('Emily Collins',9457987791),
  ('Matthew Stewart',9100009950),
  ('Leah Flores',9424614871),
  ('Samuel Morris',9833166053),
  ('Addison Bailey',9712932523);
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`elections`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`elections`
  (election_date,election_venue,quorum,outsider_wname)
VALUES
  ('2022-07-11','Function Room',0,'Emily Smith'),
  ('2022-09-19','Gymnasium',1,'Michael Johnson'),
  ('2022-08-06','Clubhouse',0,'Sarah Brown'),
  ('2023-04-03','Function Room',0,'David Garcia'),
  ('2022-11-29','Clubhouse',1,'Olivia Davis'),
  ('2022-05-12','Gymnasium',0,'William Rodriguez'),
  ('2023-03-24','Gymnasium',0,'Sophia Martinez'),
  ('2022-11-14','Gymnasium',0,'Ethan Hernandez'),
  ('2022-10-23','Function Room',1,'Ava Lopez'),
  ('2022-05-08','Function Room',0,'Benjamin Gonzalez'),
  ('2022-09-27','Clubhouse',1,'Emma Perez'),
  ('2022-06-09','Clubhouse',1,'Jacob Taylor'),
  ('2023-03-06','Function Room',0,'Isabella Anderson'),
  ('2023-02-21','Gymnasium',0,'Christopher Wilson'),
  ('2022-12-18','Function Room',1,'Mia Jackson'),
  ('2022-05-10','Function Room',1,'Matthew Wright'),
  ('2022-06-27','Clubhouse',1,'Charlotte Walker'),
  ('2022-08-20','Clubhouse',0,'Nicholas White'),
  ('2023-03-23','Clubhouse',0,'Amelia Harris'),
  ('2022-08-08','Gymnasium',1,'Alexander Clark'),
  ('2022-05-01','Gymnasium',1,'Harper Lewis'),
  ('2022-07-10','Clubhouse',1,'Tyler Young'),
  ('2022-12-07','Clubhouse',1,'Abigail Allen'),
  ('2022-10-09','Gymnasium',1,'Anthony King'),
  ('2022-10-05','Gymnasium',1,'Grace Wright'),
  ('2022-12-11','Function Room',1,'James Scott'),
  ('2023-02-16','Function Room',0,'Scarlett Green'),
  ('2022-11-12','Function Room',0,'Benjamin Baker'),
  ('2023-03-17','Clubhouse',1,'Natalie Adams'),
  ('2022-12-04','Clubhouse',0,'Daniel Nelson'),
  ('2022-05-25','Gymnasium',0,'Madison Carter'),
  ('2022-06-26','Function Room',0,'Christopher Mitchell'),
  ('2022-02-11','Clubhouse',0,'Elizabeth Perez'),
  ('2022-10-17','Gymnasium',1,'Ryan Roberts'),
  ('2022-06-05','Function Room',0,'Victoria Turner'),
  ('2023-02-07','Clubhouse',1,'Joshua Phillips'),
  ('2023-01-17','Clubhouse',0,'Claire Campbell'),
  ('2022-09-23','Gymnasium',0,'Andrew Parker'),
  ('2022-09-01','Function Room',0,'Aria Evans'),
  ('2023-01-20','Function Room',0,'William Edwards'),
  ('2022-08-10','Clubhouse',1,'Emily Collins'),
  ('2023-04-01','Clubhouse',1,'Matthew Stewart'),
  ('2022-10-13','Gymnasium',0,'Leah Flores'),
  ('2022-09-11','Clubhouse',0,'Samuel Morris'),
  ('2022-07-16','Gymnasium',1,'Addison Bailey');
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`officer`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO  `HOADB`.`officer`
  (ho_id,position,election_date,start_date,end_date,availability_time,M,T,W,H,F,S,N)
VALUES
  (1004,'President','2022-11-29','2022-12-07','2023-12-15','M',1,0,0,1,0,0,0),
  (1005,'Vice-President','2023-01-17','2022-05-20','2023-05-28','A',1,1,1,0,1,0,0),
  (1006,'Auditor','2022-09-27','2023-04-01','2024-04-09','M',0,0,1,0,1,0,0),
  (1010,'Secretary','2022-08-06','2022-10-05','2023-10-13','M',1,0,0,1,0,1,1),
  (1011,'Secretary','2022-07-11','2022-06-17','2023-06-25','A',0,0,1,1,1,0,0),
  (1012,'Secretary','2023-03-06','2023-03-14','2024-04-22','A',0,0,0,0,1,0,1),
  (1013,'Auditor','2022-09-27','2023-03-01','2024-03-08','M',1,1,1,1,1,1,1),
  (1027,'Auditor','2022-10-05','2022-11-20','2023-12-18','M',1,0,0,1,1,1,1),
  (1028,'Auditor','2022-10-05','2023-03-25','2024-05-03','M',0,1,1,1,1,1,1),
  (1029,'Auditor','2022-10-05','2022-12-12','2023-12-20','A',0,0,0,0,1,1,1),
  (1030,'Treasurer','2022-09-27','2022-06-02','2023-06-10','M',0,1,1,1,1,0,1),
  (1031,'Treasurer','2023-01-20','2022-07-03','2023-07-11','A',1,0,0,1,0,1,1),
  (1032,'Auditor','2022-08-20','2022-02-19','2023-02-27','A',1,1,0,0,0,0,1),
  (1041,'Treasurer','2022-08-20','2023-04-09','2024-04-17','A',0,1,1,0,1,0,0),
  (1042,'Secretary','2022-07-16','2022-10-21','2023-10-29','M',1,0,0,1,0,0,0),
  (1043,'Treasurer','2022-07-16','2022-09-19','2023-09-27','A',0,0,1,0,1,0,0),
  (1044,'Secretary','2023-01-20','2022-07-24','2023-08-01','A',1,1,1,1,1,0,0);
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`ref_ornumbers`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`ref_ornumbers` 
  (ornum)
VALUES
  (3000001),
  (3000002),
  (3000003),
  (3000004),
  (3000005),
  (3000006),
  (3000007),
  (3000008),
  (3000009),
  (3000010),
  (3000011),
  (3000012),
  (3000013),
  (3000014),
  (3000015),
  (3000016),
  (3000017),
  (3000018),
  (3000019),
  (3000020),
  (3000021),
  (3000022),
  (3000023),
  (3000024),
  (3000025),
  (3000026),
  (3000027),
  (3000028),
  (3000029),
  (3000030),
  (3000031),
  (3000032),
  (3000033),
  (3000034),
  (3000035),
  (3000036),
  (3000037),
  (3000038);
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`resident_idcards`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`resident_idcards`
  (card_number,requested_date,request_reason,provided_date,ornum,fee,resident_id,cancelled,ofcr_hoid,position,election_date)
VALUES
  (5201,'2022-11-03','Security','2022-11-04',NULL,0,1023,1,1004,'President','2022-11-29'),
  (5202,'2022-11-05','Security','2022-11-05',3000002,100,1033,0,1004,'President','2022-11-29'),
  (5203,'2022-11-05','Barangay Identification','2022-11-05',NULL,0,1031,1,1005,'Vice-President','2023-01-17'),
  (5204,'2022-11-10','Barangay Identification','2022-11-15',3000003,100,1004,0,1030,'Treasurer','2022-09-27'),
  (5205,'2023-03-02','Access to Ameneties','2023-03-03',NULL,0,1032,1,1031,'Treasurer','2023-01-20'),
  (5206,'2022-06-28','Community events','2022-06-30',NULL,0,1017,1,1044,'Secretary','2023-01-20'),
  (5207,'2023-02-25','Barangay Identification','2023-02-28',3000004,100,1038,0,1044,'Secretary','2023-01-20'),
  (5208,'2022-07-30','Barangay Identification','2022-08-02',3000005,100,1020,0,1004,'President','2022-11-29'),
  (5209,'2023-02-15','Access to Ameneties','2023-02-16',3000006,100,1006,0,1005,'Vice-President','2023-01-17'),
  (5210,'2022-05-20','Security','2022-05-23',3000007,100,1029,0,1029,'Auditor','2022-10-05'),
  (5211,'2022-09-02','Barangay Identification','2022-09-05',3000008,100,1035,0,1041,'Treasurer','2022-08-20'),
  (5212,'2022-11-12','Security','2022-11-14',NULL,0,1021,1,1004,'President','2022-11-29'),
  (5213,'2023-02-18','Barangay Identification','2023-02-20',NULL,0,1010,1,1005,'Vice-President','2023-01-17'),
  (5214,'2022-10-09','Barangay Identification','2022-10-10',NULL,0,1040,1,1011,'Secretary','2022-07-11'),
  (5215,'2022-05-29','Security','2022-05-30',3000009,100,1018,0,1028,'Auditor','2022-10-05'),
  (5216,'2022-08-20','Community Events','2022-08-23',NULL,0,1009,1,1030,'Treasurer','2022-09-27'),
  (5217,'2022-10-18','Access to Ameneties','2022-12-26',3000010,100,1041,0,1013,'Auditor','2022-09-27'),
  (5218,'2022-12-25','Community Events','2022-03-17',3000011,100,1025,0,1030,'Treasurer','2022-09-27'),
  (5219,'2022-03-16','Community Events','2023-02-10',NULL,0,1005,1,1042,'Secretary','2022-07-16'),
  (5220,'2023-02-09','Access to Ameneties','2022-06-26',3000012,100,1015,0,1042,'Secretary','2022-07-16'),
  (5221,'2022-06-24','Security','2022-09-08',NULL,0,1001,1,1044,'Secretary','2023-01-20'),
  (5222,'2022-09-06','Security','2022-11-14',3000013,100,1014,0,1031,'Treasurer','2023-01-20'),
  (5223,'2022-11-13','Barangay Identification','2023-03-07',3000014,100,1013,0,1010,'Secretary','2022-08-06'),
  (5224,'2023-03-06','Barangay Identification','2022-05-16',NULL,0,1024,1,1005,'Vice-President','2023-01-17'),
  (5225,'2022-05-14','Barangay Identification','2022-08-26',NULL,0,1042,1,1005,'Vice-President','2023-01-17');
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`people_mobile`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`people_mobile`
  (peopleid,mobileno)
VALUES
  (1000,9123456789),
  (1001,9375689213),
  (1002,9264578923),
  (1003,9463217854),
  (1004,9198765432),
  (1005,9564892137),
  (1006,9276438291),
  (1007,9187654321),
  (1008,9452361872),
  (1009,9348721596),
  (1010,9135724689),
  (1011,9216875432),
  (1012,9435621876),
  (1013,9372548691),
  (1014,9193217465),
  (1015,9248721653),
  (1016,9562178394),
  (1017,9412583647),
  (1018,9145678923),
  (1019,9372841569),
  (1020,9258741263),
  (1021,9583627415),
  (1022,9465281743),
  (1023,9328574619),
  (1024,9198765432),
  (1025,9234567891),
  (1026,9456712389),
  (1027,9314785236),
  (1028,9192834756),
  (1029,9273456182),
  (1030,9586127345),
  (1031,9472513689),
  (1032,9135678234),
  (1033,9346182597),
  (1034,9281943765),
  (1035,9453821697),
  (1036,9362751489),
  (1037,9128475691),
  (1038,9241358726),
  (1039,9527483156),
  (1040,9463178259),
  (1041,9357284691),
  (1042,9137652918),
  (1043,9274581362),
  (1044,9563218457);
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`assets`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`assets`
  (asset_id,asset_name,asset_description,acquisition_date,forrent,asset_value,type_asset,status,loc_lattitude,loc_longiture,hoa_name,enclosing_asset)
VALUES
  (4001,'Sofa','A comfortable living room sofa','2022-01-03',1,800,'F','W',13.9541,121.15,'Bloomfields Heights Homeowners Association',NULL),
  (4002,'Lawnmower','A gas-powered lawnmower','2022-01-04',0,1200,'E','S',13.9541,121.15,'Bloomfields Heights Homeowners Association',NULL),
  (4003,'Refrigerator','A large refrigerator for food storage','2022-01-05',0,1500,'E','D',10.456,20.32,'SMH',NULL),
  (4005,'Lawn Chair','A comfortable chair for outdoor use','2022-01-06',1,50,'F','P',13.9541,121.15,'Bloomfields Heights Homeowners Association',NULL),
  (4007,'Kitchen Table','A large table for dining','2022-01-08',0,600,'F','D',10.456,20.32,'SMH',NULL),
  (4008,'Television','A 50-inch flat screen TV','2022-01-09',1,1000,'E','P',14.3294,120.94,'Marilag Homeowners Association',NULL),
  (4010,'Dining Chair','A comfortable chair for dining','2022-01-11',1,30,'F','W',10.456,20.32,'SMH',NULL),
  (4011,'AC Unit','Air conditioning unit','2022-01-12',0,1000,'E','D',14.3294,120.94,'Marilag Homeowners Association',NULL),
  (4012,'Sofa','Living room sofa','2022-01-13',1,500,'F','P',14.234,29.29,'SJH',NULL),
  (4013,'Refrigerator','Kitchen refrigerator','2022-01-14',0,1500,'P','W',13.9541,121.15,'Bloomfields Heights Homeowners Association',NULL),
  (4014,'Bed','Queen-size bed','2022-01-15',1,800,'O','S',14.5758,121.0493,'SMH',NULL),
  (4015,'Dining table','Wooden dining table','2022-01-16',0,700,'F','D',14.234,29.29,'SJH',NULL),
  (4016,'Microwave','Kitchen microwave','2022-01-17',1,300,'E','P',13.9541,121.15,'Bloomfields Heights Homeowners Association',NULL),
  (4017,'Office chair','Swivel chair','2022-01-18',0,150,'P','S',13.9541,121.15,'Bloomfields Heights Homeowners Association',4011),
  (4018,'Dresser','Bedroom dresser','2022-01-19',1,400,'O','D',10.456,20.32,'SMH',NULL),
  (4019,'TV','50-inch television','2022-01-20',0,1000,'P','W',13.9541,121.15,'Bloomfields Heights Homeowners Association',4017),
  (4020,'Armchair','Living room armchair','2022-01-21',1,250,'F','P',14.234,29.29,'SJH',NULL),
  (4021,'Dishwasher','Kitchen dishwasher','2022-01-22',0,800,'P','D',14.3294,120.94,'Marilag Homeowners Association',NULL),
  (4022,'Garden Tractor','Riding lawn mower','2022-01-23',0,2000,'E','P',14.3294,120.94,'Marilag Homeowners Association',NULL),
  (4023,'Fossil Watch','Vintage wristwatch','2022-01-24',1,1500,'F','D',14.234,29.29,'SJH',NULL),
  (4024,'Dining Table','Solid wood dining table','2022-01-25',1,5000,'P','S',10.456,20.32,'SMH',4012),
  (4025,'Yamaha Upright Piano','Classic design upright piano','2022-01-26',0,9000,'F','W',10.456,20.32,'SMH',NULL);
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`officer_presidents`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`officer_presidents`
VALUES
  (1004,'President','2022-11-29');
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`asset_transactions`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`asset_transactions`
  (asset_id,transaction_date,trans_hoid,trans_position,trans_electiondate,isdeleted,approval_hoid,approval_position,approval_electiondate,ornum,transaction_type)
VALUES
  (4001,'2022-12-20',1005,'Vice-President','2023-01-17',0,1004,'President','2022-11-29',3000001,'R'),
  (4001,'2022-12-21',1005,'Vice-President','2023-01-17',0,1004,'President','2022-11-29',3000015,'T'),
  (4002,'2022-12-21',1005,'Vice-President','2023-01-17',0,1004,'President','2022-11-29',3000016,'R'),
  (4003,'2022-12-23',1006,'Auditor','2022-09-27',0,1004,'President','2022-11-29',3000017,'R'),
  (4005,'2022-12-21',1012,'Secretary','2023-03-06',0,1004,'President','2022-11-29',3000018,'T'),
  (4007,'2022-12-23',1029,'Auditor','2022-10-05',0,1004,'President','2022-11-29',3000020,'A'),
  (4008,'2022-12-23',1013,'Auditor','2022-09-27',0,1004,'President','2022-11-29',3000021,'R'),
  (4008,'2022-12-24',1044,'Secretary','2023-01-20',0,1004,'President','2022-11-29',3000022,'A'),
  (4010,'2022-12-23',1032,'Auditor','2022-08-20',0,1004,'President','2022-11-29',3000023,'R');
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`asset_activity`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`asset_activity`
  (`asset_id`,`activity_date`,`activity_description`,`tent_start`,`tent_end`,`act_start`,`act_end`,`cost`,`status`)
VALUES
  (4001,'2022-12-20','Repair','2022-12-21','2022-12-21','2022-12-21','2022-12-21',100,'C'),
  (4001,'2022-12-21','Repaint','2022-12-22','2022-12-23','2022-12-22','2022-12-22',400,'C'),
  (4002,'2022-12-21','Repair','2022-12-22','2022-12-22','2022-12-22','2022-12-22',0,'C'),
  (4003,'2022-12-23','Repair and Wash','2022-12-23','2022-12-23','2022-12-23','2022-12-23',500,'S'),
  (4005,'2022-12-21','Repaint','2022-12-24','2022-12-24','2022-12-24','2022-12-24',300,'C'),
  (4007,'2022-12-23','Repair and Wash','2022-12-26','2022-12-26','2022-12-26','2022-12-26',100,'O'),
  (4008,'2022-12-23','Repair','2022-12-27','2022-12-27','2022-12-27','2022-12-27',200,'C'),
  (4008,'2022-12-24','Repair and Wash','2022-12-28','2022-12-28','2022-12-28','2022-12-28',400,'O'),
  (4010,'2022-12-23','Repair','2022-12-29','2022-12-29','2022-12-29','2022-12-29',0,'C');
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`asset_transfer`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`asset_transfer`
  (asset_id,schedule_date,act_date,source_lattitude,source_longitude,dest_latittude,dest_longitude,transfer_cost,status,completename)
VALUES
  (4007,'2022-12-23','2022-12-23',423.212,353.234,255.256,123.532,100,'C','Alexander Clark'),
  (4001,'2022-12-20','2022-12-21',174.347,154.426,178.455,165.456,50,'C','Mia Jackson'),
  (4001,'2022-12-21','2022-12-23',129.437,144.532,198.223,209.645,60,'C','Natalie Adams'),
  (4002,'2022-12-21','2022-12-21',346.652,243.344,187.665,112.234,120,'C','William Rodriguez'),
  (4003,'2022-12-23','2022-12-24',224.453,166.224,245.345,247.354,100,'C','Michael Johnson'),
  (4005,'2022-12-21','2022-12-21',145.224,212.345,189.456,198.444,80,'C','Christopher Mitchell'),
  (4008,'2022-12-23','2022-12-23',210.332,222.433,202.423,153.224,100,'C','Tyler Young'),
  (4008,'2022-12-24','2022-12-26',235.343,198.224,214.234,223.445,150,'C','Nicholas White'),
  (4010,'2022-12-23','2022-12-23',143.234,232.556,344.667,123.678,50,'C','Emma Perez');
COMMIT;

-- -----------------------------------------------------
-- Data for table `HOADB`.`asset_rentals`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`asset_rentals`
  (asset_id,rental_date,reservation_date,resident_id,rental_amount,discount,status,inspection_details,assessed_value,accept_hoid,accept_position,accept_electiondate,return_date)
VALUES
  (4001,'2022-12-20','2022-12-14',1023,100,0,'O','All returned OK',0,1004,'President','2022-11-29',NULL),
  (4001,'2022-12-21','2022-12-13',1010,50,0,'C','All returned OK',0,1005,'Vice-President','2023-01-17',NULL),
  (4002,'2022-12-21','2022-12-13',1014,60,0,'O','Some Damage',200,1006,'Auditor','2022-09-27',NULL),
  (4003,'2022-12-23','2022-12-12',1035,80,0,'C','All returned OK',0,1010,'Secretary','2022-08-06',NULL),
  (4005,'2022-12-21','2022-12-19',1041,100,0,'O','Some Damage',500,1011,'Secretary','2022-07-11',NULL),
  (4007,'2022-12-23','2022-12-13',1033,50,0,'R','All returned OK',0,1013,'Auditor','2022-09-27',NULL),
  (4008,'2022-12-23','2022-12-21',1001,80,0,'R','Some Damage',200,1027,'Auditor','2022-10-05',NULL),
  (4008,'2022-12-24','2022-12-20',1042,70,0,'N','Some Damage',700,1028,'Auditor','2022-10-05','2022-12-22'),
  (4010,'2022-12-23','2022-12-19',1038,100,0,'C','All returned OK',0,1029,'Auditor','2022-10-05',NULL);
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`donors`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`donors`
  (donorname,address)
VALUES
  ('Edgardo Tangchoco','Manila'),
  ('Ramon Magsaysay','Quezon City'),
  ('Romeo Joselito','Pasay'),
  ('Benjamin Parker','Santa Rosa'),
  ('Emily Rodriguez','Caloocan'),
  ('William Thompson','Taguig'),
  ('Sophia Lee','Biñan'),
  ('Ethan Davis','Makati'),
  ('Olivia Wilson','Pasig'),
  ('Alexander Martinez','Calamba'),
  ('Ava Collins','Batangas'),
  ('Michael Murphy','Taguig'),
  ('Isabella Scott','Tagaytay');
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`asset_donations`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`asset_donations`
  (donation_id,donor_completename,donation_formfile,date_donation,accept_hoid,accept_position,accept_electiondate,isdeleted,approval_hoid,approval_position,approval_electiondate)
VALUES
  (2001,'Ramon Magsaysay','2001ramon.pdf','2022-12-10',1004,'President','2022-11-29',0,1004,'President','2022-11-29'),
  (2002,'Edgardo Tangchoco','2002edgardo.pdf','2022-12-10',1004,'President','2022-11-29',0,1004,'President','2022-11-29'),
  (2003,'Edgardo Tangchoco','2003edgardo.pdf','2022-12-10',1004,'President','2022-11-29',0,1004,'President','2022-11-29'),
  (2004,'Romeo Joselito','2004romeo.pdf','2022-12-11',1005,'Vice-President','2023-01-17',0,1004,'President','2022-11-29'),
  (2005,'Benjamin Parker','2005benjamin.pdf','2022-12-12',1027,'Auditor','2022-10-05',0,1004,'President','2022-11-29'),
  (2006,'Emily Rodriguez','2006emily.pdf','2022-12-13',1030,'Treasurer','2022-09-27',0,1004,'President','2022-11-29'),
  (2007,'William Thompson','2007william.pdf','2022-12-14',1027,'Auditor','2022-10-05',0,1004,'President','2022-11-29'),
  (2008,'Sophia Lee','2008sophia.pdf','2022-12-15',1005,'Vice-President','2023-01-17',0,1004,'President','2022-11-29'),
  (2009,'Ethan Davis','2009ethan.pdf','2022-12-15',1030,'Treasurer','2022-09-27',0,1004,'President','2022-11-29'),
  (2010,'Olivia Wilson','2010olivia.pdf','2022-12-17',1005,'Vice-President','2023-01-17',0,1004,'President','2022-11-29'),
  (2011,'Alexander Martinez','2011alexander.pdf','2022-12-18',1027,'Auditor','2022-10-05',0,1004,'President','2022-11-29'),
  (2012,'Ava Collins','2012ava.pdf','2022-12-07',1043,'Treasurer','2022-07-16',0,1004,'President','2022-11-29'),
  (2013,'Michael Murphy','2013michael.pdf','2022-12-09',1005,'Vice-President','2023-01-17',0,1004,'President','2022-11-29'),
  (2014,'Isabella Scott','2014isabella.pdf','2022-12-21',1006,'Auditor','2022-09-27',0,1004,'President','2022-11-29');
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`donated_assets`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`donated_assets`
  (donation_id,asset_id,amount_donated)
VALUES
  (2001,4001,500),
  (2002,4001,800),
  (2003,4002,1200),
  (2004,4003,1500),
  (2005,4005,2000),
  (2006,4005,800),
  (2007,4007,600),
  (2008,4008,1000),
  (2009,4008,150),
  (2010,4010,1000),
  (2011,4002,1000),
  (2013,4001,1500),
  (2014,4008,800);
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`donation_pictures`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`donation_pictures`
  (donation_id,picturefile)
VALUES
  (2001,'2001-a.jpg'),
  (2001,'2001-b.jpg'),
  (2002,'2002.jpg'),
  (2004,'2004-a.jpg'),
  (2004,'2004-b.jpg'),
  (2004,'2004-s.jpg'),
  (2003,'2003-a.jpg'),
  (2005,'2005.jpg'),
  (2006,'2006.jpg'),
  (2007,'2007.jpg'),
  (2008,'2008.jpg'),
  (2009,'2009.jpg'),
  (2010,'2010.jpg'),
  (2011,'2011.jpg'),
  (2012,'2012.jpg'),
  (2013,'2013.jpg'),
  (2014,'2014.jpg'),
  (2003,'2003-b.jpg');
COMMIT;

-- -----------------------------------------------------
-- Data for table `HOADB`.`program`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`program`
  (program_id,hoa_name,description,purpose,sponsoring_officer_id,start_date,end_date,status,budget,start_date_registration,intended_participants,max_participants)
VALUES
  (7001,'SJH','New Years Eve Countdown Party','To celebrate the year-end and new year',1013,'2022-12-31','2023-01-01','Closed for registration',70000,'2022-12-01',100,200),
  (7002,'Bloomfields Heights Homeowners Association','Christmas Lantern Making Contest','To promote the Christmas spirit',1030,'2022-12-01','2022-12-08','Completed',10000,'2022-11-06',10,15),
  (7003,'SJH','Basketball Tournament','To promote sportsmanship',1043,'2023-04-12','2023-04-13','Ongoing',15000,'2023-03-13',50,50),
  (7004,'SMH','Easter Egg Hunt','To celebrate the Easter',1010,'2023-04-09','2023-04-09','Open for registration',5000,'2023-03-13',50,100),
  (7005,'Marilag Homeowners Association','Halloween Costume Contest','To showcase costume-making skills.',1004,'2022-10-28','2022-10-29','Cancelled',8000,'2022-10-01',30,50);
COMMIT;

-- -----------------------------------------------------
-- Data for table `HOADB`.`program_staff`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`program_staff`
  (staff_id,program_id,resident_id,`rank`,officer_incharge)
VALUES
  (10,7001,1000,'Committee Head',1004),
  (11,7001,1001,'Member',1004),
  (12,7001,1006,'Member',1004),
  (13,7001,1002,'Member',1004),
  (14,7002,1021,'Committee Head',1010),
  (15,7002,1031,'Member',1010),
  (16,7002,1033,'Member',1010),
  (17,7002,1038,'Member',1010),
  (18,7003,1041,'Committee Head',1041),
  (19,7003,1010,'Member',1041),
  (20,7003,1005,'Member',1041),
  (21,7003,1020,'Member',1041),
  (22,7004,1017,'Committee Head',1044),
  (23,7004,1034,'Member',1044),
  (24,7004,1035,'Member',1044),
  (25,7004,1025,'Member',1044),
  (26,7005,1018,'Committee Head',1005),
  (27,7005,1013,'Member',1005),
  (28,7005,1029,'Member',1005),
  (29,7005,1040,'Member',1005);
COMMIT;

-- -----------------------------------------------------
-- Data for table `HOADB`.`program_participants`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`program_participants`
  (participant_id,program_id,status,priority,resident_id,staff_id,denied_reason)
VALUES
  (3000,7001,'Accepted',0,1002,10,NULL),
  (3001,7002,'Denied',1,1005,14,'Program is full, priority first.'),
  (3002,7003,'Accepted',1,1006,20,NULL),
  (3003,7004,'Accepted',0,1009,22,NULL),
  (3004,7005,'Denied',0,1017,26,'The program has been cancelled'),
  (3005,7003,'Accepted',1,1014,18,NULL),
  (3006,7004,'Accepted',0,1024,25,NULL),
  (3007,7005,'Denied',1,1032,27,'The program has been cancelled'),
  (3008,7001,'Accepted',0,1003,13,NULL),
  (3009,7002,'Accepted',0,1010,14,NULL),
  (3010,7002,'Accepted',0,1013,15,NULL),
  (3011,7002,'Accepted',1,1015,14,NULL),
  (3012,7002,'Accepted',1,1018,15,NULL),
  (3013,7002,'Accepted',0,1020,16,NULL),
  (3014,7002,'Accepted',1,1021,14,NULL),
  (3015,7002,'Accepted',1,1023,15,NULL),
  (3016,7002,'Accepted',0,1025,16,NULL),
  (3017,7002,'Accepted',1,1029,17,NULL),
  (3018,7002,'Accepted',0,1030,17,NULL),
  (3019,7002,'Accepted',0,1031,17,NULL),
  (3020,7002,'Accepted',1,1033,16,NULL),
  (3021,7002,'Accepted',0,1034,16,NULL),
  (3022,7002,'Accepted',0,1035,15,NULL),
  (3023,7002,'Accepted',0,1041,14,NULL),
  (3024,7001,'Pending',0,1042,11,NULL);
COMMIT;

-- -----------------------------------------------------
-- Data for table `HOADB`.`program_end`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`program_end`
  (program_id,participant_id,feedback,rating,suggestion)
VALUES
  (7002,3009,'So glad to have been a part if this contest',2,'Some of the designs don''t fit the theme.'),
  (7002,3010,'Beautiful and festive works of art',5,'More contestants to participate'),
  (7002,3011,'Amazing creativity on display',3,'Lack of materials'),
  (7002,3012,'Very impressed with the intricate designs',4,'More contestants to participate'),
  (7002,3013,'It was a truly memorable experience',4,'Provide more art materials '),
  (7002,3014,'Everything went smoothly.',5,'None'),
  (7002,3015,'The event exceeded my expectations',5,'None'),
  (7002,3016,'Loved seeing the different interpretations of the theme',3,'More contestants to participate'),
  (7002,3017,'So much talent showcased in this contest',3,'More contestants to participate'),
  (7002,3018,'The program was fantastic, I had a great time',2,'Too dark in the venue'),
  (7002,3019,'The program was well-organized',4,'More contestants to participate'),
  (7002,3020,'I enjoyed seeing the creativity of each contestant',4,'Provide high-quality paper or cardboard'),
  (7002,3021,'Beautiful and festive works of art',5,'None'),
  (7002,3022,'The event exceeded my expectations',5,'More contestants to participate'),
  (7002,3023,'The level of skill was truly impressive',3,'Provide more art materials');
COMMIT;

-- -----------------------------------------------------
-- Data for table `HOADB`.`program_evidence`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`program_evidence`
  (evidence_id,program_id,description,file_name,submitting_resident,accepting_officer,submitted_date)
VALUES
  (9000,7001,'Photograph of fireworks display during New Year’s Eve celebration','New_Years_Eve1.pdf',3000,1004,'2024-01-03'),
  (9001,7001,'Photograph of residents gathered in the town square for New Year’s Eve countdown','New_Years_Eve2.pdf',3000,1004,'2024-01-03'),
  (9002,7001,'Flyer for New Year’s Eve party at the community center','New_Years_Eve3.pdf',3000,1004,'2024-01-03'),
  (9003,7001,'Menu for New Year’s Eve dinner at the clubhouse.','New_Years_Eve4.pdf',3000,1004,'2024-01-03'),
  (9004,7001,'Invitation to New Year’s Eve gala at the town hall','New_Years_Eve5.pdf',3000,1004,'2024-01-03'),
  (9005,7002,'Photograph of Christmas lanterns displayed along the main street','Christmas_Lantern1.pdf',3001,1010,'2023-12-10'),
  (9006,7002,'Flyer for Christmas lantern-making workshop at the community center.','Christmas_Lantern2.pdf',3001,1010,'2023-12-10'),
  (9007,7004,'Schedule for community basketball league games','Bball1.pdf',3006,1044,'2023-04-15'),
  (9008,7003,'Photograph of community basketball team during a game','Bball2.pdf',3002,1041,'2023-04-15'),
  (9009,7003,'Flyer for basketball clinic for kids at the park','Bball3.pdf',3002,1041,'2023-04-15'),
  (9010,7004,'Flyer for Easter egg hunt at the park','Easter_Egg_Hunt1.pdf',3006,1044,'2023-04-11'),
  (9011,7004,'Photograph of kids participating in Easter egg hunt at the park','Easter_Egg_Hunt2.pdf',3006,1044,'2023-04-11');
COMMIT;


-- -----------------------------------------------------
-- Data for table `HOADB`.`program_expense`
-- -----------------------------------------------------
START TRANSACTION;
USE `HOADB`;
INSERT INTO `HOADB`.`program_expense`
  (expense_id,program_id,staff_id,expense_date,description,amount,type,scanned_ornum)
VALUES
  (8201,7001,10,'2022-12-23','decorations',5000,'Materials','decorations7001.pdf'),
  (8202,7001,11,'2022-12-16','sound system',5000,'Materials','soundsystem7001.pdf'),
  (8203,7001,12,'2022-12-19','food and drinks',30000,'Others','food_drinks7001.pdf'),
  (8204,7001,13,'2022-12-31','entertainment',10000,'Services','entertainment7001.pdf'),
  (8205,7001,11,'2022-12-31','host, DJ, and staff fee',20000,'Manpower','HDSfee7001.pdf'),
  (8206,7002,14,'2022-10-31','prizes',4000,'Others','prizes7002.pdf'),
  (8207,7002,15,'2022-11-01','christmas lantern materials',6000,'Materials','materials7002.pdf'),
  (8208,7003,18,'2023-03-06','prizes',8000,'Others','prizes7003.pdf'),
  (8209,7003,20,'2023-04-03','referee fee',4000,'Manpower','referee_fee7003.pdf'),
  (8210,7003,20,'2023-04-01','trophies',3000,'Others','trophies7003.pdf'),
  (8211,7004,23,'2023-03-24','prizes',3000,'Others','prizes7004.pdf'),
  (8212,7004,25,'2023-04-01','decorations and materials',2000,'Others','decor_materials7004.pdf');
COMMIT;
