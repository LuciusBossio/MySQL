-- Lucius Bossio
-- COMP 20 - Assignment 2
-- Canuck Advenmtures Database

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema A2Bossio
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `A2Bossio` DEFAULT CHARACTER SET utf8 ;
USE `A2Bossio` ;

-- -----------------------------------------------------
-- Table `A2Bossio`.`tblTrips`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `A2Bossio`.`tblTrips` (
  `tripID` INT NOT NULL,
  `tripName` VARCHAR(30) NULL,
  `tripType` ENUM('biking', 'hiking', 'paddling') NULL,
  `tripAdress` VARCHAR(20) NULL,
  `tripCity` VARCHAR(45) NULL,
  `tripProvince` ENUM('NB', 'NS', 'QC') NULL,
  `tripDistance` INT NULL,
  `tripMaxReserv` INT NULL,
  `tripBasePrice` DECIMAL(5,2) NULL,
  PRIMARY KEY (`tripID`))
ENGINE = InnoDB;

INSERT IGNORE INTO tblTrips VALUES
(01, 'Big Cliff Mountain Hike', 'hiking', '123 Mountain Road', 'Mont Tremblant', 'QC', 4500, 15, 99.99),
(02, 'Lazy River Paddle', 'paddling', '666 Water Street', 'Antigonish', 'NS', 1500, 8, 199.99),
(03, 'Painfully Long Bike Ride', 'biking', '735 Ecofriendly Lane', 'Moncton', 'NB', 23500, 10, 149.99);


-- -----------------------------------------------------
-- Table `A2Bossio`.`tblGuides`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `A2Bossio`.`tblGuides` (
  `guideID` INT NOT NULL,
  `guideFName` VARCHAR(30) NULL,
  `guideLName` VARCHAR(30) NULL,
  `guidePhone` VARCHAR(15) NULL,
  PRIMARY KEY (`guideID`))
ENGINE = InnoDB;

INSERT IGNORE INTO tblGuides Values
(01, 'Mark', 'Jackson', '1-613-888-9076'),
(02, 'Steve', 'Smith', '1-213-395-9967'),
(03, 'Rickard', 'Nixon', '1-666-999-4200'),
(04, 'Peter', 'Piper', '1-647-324-9076');


-- -----------------------------------------------------
-- Table `A2Bossio`.`tblTrips_has_tblGuides`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `A2Bossio`.`tblTrips_has_tblGuides` (
  `tblTrips_tripID` INT NOT NULL,
  `tblGuides_guideID` INT NOT NULL,
  PRIMARY KEY (`tblTrips_tripID`, `tblGuides_guideID`),
  INDEX `fk_tblTrips_has_tblGuides_tblGuides1_idx` (`tblGuides_guideID` ASC) VISIBLE,
  INDEX `fk_tblTrips_has_tblGuides_tblTrips_idx` (`tblTrips_tripID` ASC) VISIBLE,
  CONSTRAINT `fk_tblTrips_has_tblGuides_tblTrips`
    FOREIGN KEY (`tblTrips_tripID`)
    REFERENCES `A2Bossio`.`tblTrips` (`tripID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tblTrips_has_tblGuides_tblGuides1`
    FOREIGN KEY (`tblGuides_guideID`)
    REFERENCES `A2Bossio`.`tblGuides` (`guideID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT IGNORE INTO tblTrips_has_tblGuides VALUES
(01, 01),
(02, 01),
(02, 02),
(03, 03);


-- -----------------------------------------------------
-- Table `A2Bossio`.`tblCustomers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `A2Bossio`.`tblCustomers` (
  `custID` INT NOT NULL,
  `custFName` VARCHAR(30) NULL,
  `custLName` VARCHAR(30) NULL,
  `custPhone` VARCHAR(15) NULL,
  `custIsSenior` TINYINT(0) NULL,
  `custIsStudent` TINYINT(0) NULL,
  `custIsReturn` TINYINT(0) NULL,
  PRIMARY KEY (`custID`))
ENGINE = InnoDB;

INSERT IGNORE INTO tblCustomers VALUES
(01, 'Jane', 'Doe', '1-897-765-2234', 0, 1, 1),
(02, 'Lara', 'Croft', '1-236-789-4675', 0, 0, 1),
(03, 'Steve', 'Daniels', '1-902-674-8943', 1, 0, 0);


-- -----------------------------------------------------
-- Table `A2Bossio`.`tblReservations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `A2Bossio`.`tblReservations` (
  `resID` INT NOT NULL,
  `resDate` DATE NULL,
  `tblTrips_tripID` INT NOT NULL,
  `tblCustomers_custID` INT NOT NULL,
  PRIMARY KEY (`resID`),
  INDEX `fk_tblReservations_tblTrips1_idx` (`tblTrips_tripID` ASC) VISIBLE,
  INDEX `fk_tblReservations_tblCustomers1_idx` (`tblCustomers_custID` ASC) VISIBLE,
  CONSTRAINT `fk_tblReservations_tblTrips1`
    FOREIGN KEY (`tblTrips_tripID`)
    REFERENCES `A2Bossio`.`tblTrips` (`tripID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tblReservations_tblCustomers1`
    FOREIGN KEY (`tblCustomers_custID`)
    REFERENCES `A2Bossio`.`tblCustomers` (`custID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT IGNORE INTO tblReservations VALUES
(01, '2020-06-23', 01, 02),
(02, '2020-07-11', 02, 02),
(03, '2020-05-15', 03, 01),
(04, '2020-09-01', 03, 01);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- Queries
SELECT * FROM tblTrips;
SELECT * FROM tblGuides;
SELECT * FROM tblTrips_has_tblGuides;
SELECT * FROM tblCustomers;
SELECT * FROM tblReservations;

DROP FUNCTION IF EXISTS fetchTripID;
DELIMITER //
CREATE FUNCTION fetchTripID
(
	tName	VARCHAR(30)
)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE tID INT;
    
    IF tName = 'biking' THEN
        SET tID = 01;
	ELSEIF tName = 'hiking' THEN
		SET tID = 02;
	ELSEIF tName = 'paddling' THEN
		SET tID = 03;
	END IF;
    
	RETURN (tID);
END//
DELIMITER ;

SELECT fetchTripID('hiking');


DROP PROCEDURE IF EXISTS createReservation;
DELIMITER //
CREATE PROCEDURE createReservation
(
	rID			INT,
    rDate		DATE,
    tName		VARCHAR(30),
    cID			INT
)
BEGIN
	DECLARE tID		INT;
    DECLARE idFound	INT DEFAULT NULL;
    
    SELECT fetchTripID(tName) INTO tID;
    
    SELECT c.custID INTO idFound FROM tblCustomers c WHERE c.custID = cID;
	IF idFOUND IS NOT NULL THEN
		INSERT IGNORE INTO tblReservations VALUES (rID, rDate, tID, cID);
        SELECT 'Reservation succcessfully added for existing customer.';
	ELSE
		SELECT 'Reservation could not be added as customer does not exist.';
	END IF;
END//
DELIMITER ;

SELECT * FROM tblReservations;
CALL createReservation(99, '2021-06-06', 'biking', 01);
SELECT * FROM tblReservations;


DROP PROCEDURE IF EXISTS deleteCustAndTrips;
 DELIMITER //
CREATE PROCEDURE deleteCustAndTrips
(
	cID		INT
)
BEGIN
	DECLARE sqlError TINYINT DEFAULT FALSE;
    
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET sqlError = TRUE;
	   
    START TRANSACTION;
		DELETE FROM tblCustomers
			WHERE custID = cID;
		
        DELETE FROM tblReservations
			WHERE tblCustomers_custID = cID;
		
        IF sqlError = FALSE THEN
			COMMIT;
            SELECT 'Records successfully deleted.';
		ELSE
			ROLLBACK;
            SELECT 'Records were not deleted.';
		END IF;
END//
DELIMITER ;; 

SELECT * FROM tblCustomers;
SELECT * FROM tblReservations;
CALL deleteCustAndTrips(01);
SELECT * FROM tblCustomers;
SELECT * FROM tblReservations;
