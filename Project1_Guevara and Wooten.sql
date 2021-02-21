/*
Assignment: Project 1 - Database Design
Names: Thomas Wooten, Jasmine Guevara
Date: 1-26-2020
*/

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema CST363_DatabaseDesign_Project1
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `CST363_DatabaseDesign_Project1` ;

-- -----------------------------------------------------
-- Schema CST363_DatabaseDesign_Project1
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `CST363_DatabaseDesign_Project1` DEFAULT CHARACTER SET utf8 ;
USE `CST363_DatabaseDesign_Project1` ;

-- -----------------------------------------------------
-- Table `CST363_DatabaseDesign_Project1`.`doctor_specialty`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CST363_DatabaseDesign_Project1`.`doctor_specialty` ;

CREATE TABLE IF NOT EXISTS `CST363_DatabaseDesign_Project1`.`doctor_specialty` (
  `specialtyID` INT NOT NULL AUTO_INCREMENT,
  `specialty` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`specialtyID`),
  UNIQUE INDEX `specialty_UNIQUE` (`specialty` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CST363_DatabaseDesign_Project1`.`doctor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CST363_DatabaseDesign_Project1`.`doctor` ;

CREATE TABLE IF NOT EXISTS `CST363_DatabaseDesign_Project1`.`doctor` (
  `doctor_ssn` VARCHAR(11) NOT NULL,
  `name` VARCHAR(45) NULL,
  `specialtyID` INT NOT NULL DEFAULT 15,
  `expirence` INT NULL,
  PRIMARY KEY (`doctor_ssn`),
  INDEX `fc_doctor_specialty_idx` (`specialtyID` ASC) VISIBLE,
  CONSTRAINT `fc_doctor_specialty`
    FOREIGN KEY (`specialtyID`)
    REFERENCES `CST363_DatabaseDesign_Project1`.`doctor_specialty` (`specialtyID`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CST363_DatabaseDesign_Project1`.`patient`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CST363_DatabaseDesign_Project1`.`patient` ;

CREATE TABLE IF NOT EXISTS `CST363_DatabaseDesign_Project1`.`patient` (
  `patient_ssn` VARCHAR(11) NOT NULL,
  `doctor_ssn` VARCHAR(11) NOT NULL COMMENT 'primary care giver ssn',
  `name` VARCHAR(45) NULL,
  `age` INT NULL,
  `address` VARCHAR(45) NULL,
  PRIMARY KEY (`patient_ssn`),
  INDEX `fk_doctor_idx` (`doctor_ssn` ASC) VISIBLE,
  CONSTRAINT `fk_doctor`
    FOREIGN KEY (`doctor_ssn`)
    REFERENCES `CST363_DatabaseDesign_Project1`.`doctor` (`doctor_ssn`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CST363_DatabaseDesign_Project1`.`pharmaceutical_company`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CST363_DatabaseDesign_Project1`.`pharmaceutical_company` ;

CREATE TABLE IF NOT EXISTS `CST363_DatabaseDesign_Project1`.`pharmaceutical_company` (
  `companyID` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `phonenumber` VARCHAR(12) NULL,
  PRIMARY KEY (`companyID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CST363_DatabaseDesign_Project1`.`drug`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CST363_DatabaseDesign_Project1`.`drug` ;

CREATE TABLE IF NOT EXISTS `CST363_DatabaseDesign_Project1`.`drug` (
  `tradename` VARCHAR(45) NOT NULL,
  `formula` VARCHAR(45) NULL,
  `companyID` INT NOT NULL,
  PRIMARY KEY (`tradename`),
  INDEX `fk_drug_pharmaceutical company1_idx` (`companyID` ASC) VISIBLE,
  CONSTRAINT `fk_drug_pharmaceutical company1`
    FOREIGN KEY (`companyID`)
    REFERENCES `CST363_DatabaseDesign_Project1`.`pharmaceutical_company` (`companyID`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CST363_DatabaseDesign_Project1`.`pharmacy`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CST363_DatabaseDesign_Project1`.`pharmacy` ;

CREATE TABLE IF NOT EXISTS `CST363_DatabaseDesign_Project1`.`pharmacy` (
  `pharmacyID` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `address` VARCHAR(45) NULL,
  `phonenumber` VARCHAR(12) NULL,
  PRIMARY KEY (`pharmacyID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CST363_DatabaseDesign_Project1`.`Rx`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CST363_DatabaseDesign_Project1`.`Rx` ;

CREATE TABLE IF NOT EXISTS `CST363_DatabaseDesign_Project1`.`Rx` (
  `rxnumber` INT NOT NULL,
  `patient_ssn` VARCHAR(11) NOT NULL,
  `doctor_ssn` VARCHAR(11) NOT NULL,
  `date` DATE NOT NULL COMMENT 'date Rx was written',
  PRIMARY KEY (`rxnumber`),
  INDEX `fk_prescription_patient1_idx` (`patient_ssn` ASC) VISIBLE,
  INDEX `fk_prescription_doctor1_idx` (`doctor_ssn` ASC) VISIBLE,
  CONSTRAINT `fk_prescription_patient1`
    FOREIGN KEY (`patient_ssn`)
    REFERENCES `CST363_DatabaseDesign_Project1`.`patient` (`patient_ssn`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_prescription_doctor1`
    FOREIGN KEY (`doctor_ssn`)
    REFERENCES `CST363_DatabaseDesign_Project1`.`doctor` (`doctor_ssn`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CST363_DatabaseDesign_Project1`.`Rx_transaction`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CST363_DatabaseDesign_Project1`.`Rx_transaction` ;

CREATE TABLE IF NOT EXISTS `CST363_DatabaseDesign_Project1`.`Rx_transaction` (
  `transactionID` INT NOT NULL,
  `rxnumber` INT NOT NULL,
  `pharmacyID` INT NOT NULL COMMENT 'Rx has been sent to pharmacy to be filled',
  `tradename` VARCHAR(45) NOT NULL,
  `quantity` INT NOT NULL,
  `date` DATE NULL COMMENT 'if value null, Rx has not been filled',
  PRIMARY KEY (`transactionID`, `rxnumber`),
  INDEX `fk_includes_prescription1_idx` (`rxnumber` ASC) VISIBLE,
  INDEX `fk_includes_drug1_idx` (`tradename` ASC) VISIBLE,
  INDEX `fk_includes_pharmacy1_idx` (`pharmacyID` ASC) VISIBLE,
  CONSTRAINT `fk_includes_prescription1`
    FOREIGN KEY (`rxnumber`)
    REFERENCES `CST363_DatabaseDesign_Project1`.`Rx` (`rxnumber`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_includes_drug1`
    FOREIGN KEY (`tradename`)
    REFERENCES `CST363_DatabaseDesign_Project1`.`drug` (`tradename`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_includes_pharmacy1`
    FOREIGN KEY (`pharmacyID`)
    REFERENCES `CST363_DatabaseDesign_Project1`.`pharmacy` (`pharmacyID`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CST363_DatabaseDesign_Project1`.`contract`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CST363_DatabaseDesign_Project1`.`contract` ;

CREATE TABLE IF NOT EXISTS `CST363_DatabaseDesign_Project1`.`contract` (
  `contractID` INT NOT NULL,
  `supervisor` VARCHAR(45) NOT NULL,
  `startdate` DATE NULL,
  `enddate` DATE NULL,
  `text` VARCHAR(45) NULL,
  `pharmacyID` INT NOT NULL,
  `companyID` INT NOT NULL,
  `tradename` VARCHAR(45) NOT NULL,
  `price` INT NOT NULL,
  PRIMARY KEY (`contractID`, `supervisor`),
  INDEX `fk_contract_pharmacy1_idx` (`pharmacyID` ASC) VISIBLE,
  INDEX `fk_contract_pharmaceutical company1_idx` (`companyID` ASC) VISIBLE,
  INDEX `fk_contract_drug1_idx` (`tradename` ASC) VISIBLE,
  CONSTRAINT `fk_contract_pharmacy1`
    FOREIGN KEY (`pharmacyID`)
    REFERENCES `CST363_DatabaseDesign_Project1`.`pharmacy` (`pharmacyID`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_contract_pharmaceutical company1`
    FOREIGN KEY (`companyID`)
    REFERENCES `CST363_DatabaseDesign_Project1`.`pharmaceutical_company` (`companyID`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_contract_drug1`
    FOREIGN KEY (`tradename`)
    REFERENCES `CST363_DatabaseDesign_Project1`.`drug` (`tradename`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `CST363_DatabaseDesign_Project1`.`doctor_specialty`
-- -----------------------------------------------------
START TRANSACTION;
USE `CST363_DatabaseDesign_Project1`;
INSERT INTO `CST363_DatabaseDesign_Project1`.`doctor_specialty` (`specialtyID`, `specialty`) VALUES (DEFAULT, 'Anesthesiology');
INSERT INTO `CST363_DatabaseDesign_Project1`.`doctor_specialty` (`specialtyID`, `specialty`) VALUES (DEFAULT, 'Dermatology');
INSERT INTO `CST363_DatabaseDesign_Project1`.`doctor_specialty` (`specialtyID`, `specialty`) VALUES (DEFAULT, 'Emergency medicine');
INSERT INTO `CST363_DatabaseDesign_Project1`.`doctor_specialty` (`specialtyID`, `specialty`) VALUES (DEFAULT, 'Family medicine');
INSERT INTO `CST363_DatabaseDesign_Project1`.`doctor_specialty` (`specialtyID`, `specialty`) VALUES (DEFAULT, 'Internal medicine');
INSERT INTO `CST363_DatabaseDesign_Project1`.`doctor_specialty` (`specialtyID`, `specialty`) VALUES (DEFAULT, 'Neurology');
INSERT INTO `CST363_DatabaseDesign_Project1`.`doctor_specialty` (`specialtyID`, `specialty`) VALUES (DEFAULT, 'Gynecology');
INSERT INTO `CST363_DatabaseDesign_Project1`.`doctor_specialty` (`specialtyID`, `specialty`) VALUES (DEFAULT, 'Pathology');
INSERT INTO `CST363_DatabaseDesign_Project1`.`doctor_specialty` (`specialtyID`, `specialty`) VALUES (DEFAULT, 'Pediatrics');
INSERT INTO `CST363_DatabaseDesign_Project1`.`doctor_specialty` (`specialtyID`, `specialty`) VALUES (DEFAULT, 'Physical medicine');
INSERT INTO `CST363_DatabaseDesign_Project1`.`doctor_specialty` (`specialtyID`, `specialty`) VALUES (DEFAULT, 'Psychiatry');
INSERT INTO `CST363_DatabaseDesign_Project1`.`doctor_specialty` (`specialtyID`, `specialty`) VALUES (DEFAULT, 'Radiation oncology');
INSERT INTO `CST363_DatabaseDesign_Project1`.`doctor_specialty` (`specialtyID`, `specialty`) VALUES (DEFAULT, 'Surgery');
INSERT INTO `CST363_DatabaseDesign_Project1`.`doctor_specialty` (`specialtyID`, `specialty`) VALUES (DEFAULT, 'Urology');
INSERT INTO `CST363_DatabaseDesign_Project1`.`doctor_specialty` (`specialtyID`, `specialty`) VALUES (DEFAULT, 'General medicine');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CST363_DatabaseDesign_Project1`.`doctor`
-- -----------------------------------------------------
START TRANSACTION;
USE `CST363_DatabaseDesign_Project1`;
INSERT INTO `CST363_DatabaseDesign_Project1`.`doctor` (`doctor_ssn`, `name`, `specialtyID`, `expirence`) VALUES ('123-01-1010', 'MILLER', 1, 10);
INSERT INTO `CST363_DatabaseDesign_Project1`.`doctor` (`doctor_ssn`, `name`, `specialtyID`, `expirence`) VALUES ('564-02-3256', 'WHITE', 8, 20);
INSERT INTO `CST363_DatabaseDesign_Project1`.`doctor` (`doctor_ssn`, `name`, `specialtyID`, `expirence`) VALUES ('847-52-1189', 'LANG', 3, 7);
INSERT INTO `CST363_DatabaseDesign_Project1`.`doctor` (`doctor_ssn`, `name`, `specialtyID`, `expirence`) VALUES ('845-80-6589', 'HOWARD', 3, 13);

COMMIT;


-- -----------------------------------------------------
-- Data for table `CST363_DatabaseDesign_Project1`.`patient`
-- -----------------------------------------------------
START TRANSACTION;
USE `CST363_DatabaseDesign_Project1`;
INSERT INTO `CST363_DatabaseDesign_Project1`.`patient` (`patient_ssn`, `doctor_ssn`, `name`, `age`, `address`) VALUES ('112-05-5623', '123-01-1010', 'KIM', 21, '123 Way Street');
INSERT INTO `CST363_DatabaseDesign_Project1`.`patient` (`patient_ssn`, `doctor_ssn`, `name`, `age`, `address`) VALUES ('513-05-9875', '564-02-3256', 'LANGILL', 35, '6542 Miller Drive');
INSERT INTO `CST363_DatabaseDesign_Project1`.`patient` (`patient_ssn`, `doctor_ssn`, `name`, `age`, `address`) VALUES ('324-05-4815', '847-52-1189', 'BURTECH', 55, '380 Avinedia Pico');
INSERT INTO `CST363_DatabaseDesign_Project1`.`patient` (`patient_ssn`, `doctor_ssn`, `name`, `age`, `address`) VALUES ('987-23-5986', '564-02-3256', 'AGUDA', 11, '6273 Front Street');
INSERT INTO `CST363_DatabaseDesign_Project1`.`patient` (`patient_ssn`, `doctor_ssn`, `name`, `age`, `address`) VALUES ('021-00-3322', '847-52-1189', 'WOOTEN', 77, '1234 Buconerio');
INSERT INTO `CST363_DatabaseDesign_Project1`.`patient` (`patient_ssn`, `doctor_ssn`, `name`, `age`, `address`) VALUES ('354-45-0023', '845-80-6589', 'MITCHELL', 13, '2568 Village Road');
INSERT INTO `CST363_DatabaseDesign_Project1`.`patient` (`patient_ssn`, `doctor_ssn`, `name`, `age`, `address`) VALUES ('345-66-5666', '845-80-6589', 'BUBBA', 24, '34 Seven Street');
INSERT INTO `CST363_DatabaseDesign_Project1`.`patient` (`patient_ssn`, `doctor_ssn`, `name`, `age`, `address`) VALUES ('358-55-6677', '845-80-6589', 'WINSTON', 69, '45 8th Boluvard');
INSERT INTO `CST363_DatabaseDesign_Project1`.`patient` (`patient_ssn`, `doctor_ssn`, `name`, `age`, `address`) VALUES ('356-54-9874', '564-02-3256', 'LIVINGSTON', 45, '677891 Where Street');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CST363_DatabaseDesign_Project1`.`pharmaceutical_company`
-- -----------------------------------------------------
START TRANSACTION;
USE `CST363_DatabaseDesign_Project1`;
INSERT INTO `CST363_DatabaseDesign_Project1`.`pharmaceutical_company` (`companyID`, `name`, `phonenumber`) VALUES (100100, 'Johnson & Johnson', '800-459-8799');
INSERT INTO `CST363_DatabaseDesign_Project1`.`pharmaceutical_company` (`companyID`, `name`, `phonenumber`) VALUES (100200, 'Pfizer', '888-365-1245');
INSERT INTO `CST363_DatabaseDesign_Project1`.`pharmaceutical_company` (`companyID`, `name`, `phonenumber`) VALUES (100300, 'GlaxoSmithKline', '899-547-9875');
INSERT INTO `CST363_DatabaseDesign_Project1`.`pharmaceutical_company` (`companyID`, `name`, `phonenumber`) VALUES (100400, 'AbbVie', '800-658-9874');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CST363_DatabaseDesign_Project1`.`drug`
-- -----------------------------------------------------
START TRANSACTION;
USE `CST363_DatabaseDesign_Project1`;
INSERT INTO `CST363_DatabaseDesign_Project1`.`drug` (`tradename`, `formula`, `companyID`) VALUES ('Acetic Acid', 'acetic acid', 100100);
INSERT INTO `CST363_DatabaseDesign_Project1`.`drug` (`tradename`, `formula`, `companyID`) VALUES ('Zovirax', 'acyclovir', 100200);
INSERT INTO `CST363_DatabaseDesign_Project1`.`drug` (`tradename`, `formula`, `companyID`) VALUES ('Mephyton', 'phytonadione', 100300);
INSERT INTO `CST363_DatabaseDesign_Project1`.`drug` (`tradename`, `formula`, `companyID`) VALUES ('Plan B', 'levonorgestrel', 100200);
INSERT INTO `CST363_DatabaseDesign_Project1`.`drug` (`tradename`, `formula`, `companyID`) VALUES ('Femara', 'letrozole', 100400);
INSERT INTO `CST363_DatabaseDesign_Project1`.`drug` (`tradename`, `formula`, `companyID`) VALUES ('Diabinese', 'chlorpropamide', 100400);
INSERT INTO `CST363_DatabaseDesign_Project1`.`drug` (`tradename`, `formula`, `companyID`) VALUES ('Cialis', 'tadalafil', 100300);
INSERT INTO `CST363_DatabaseDesign_Project1`.`drug` (`tradename`, `formula`, `companyID`) VALUES ('Klonopin', 'clonazepam', 100300);
INSERT INTO `CST363_DatabaseDesign_Project1`.`drug` (`tradename`, `formula`, `companyID`) VALUES ('Remeron', 'mirtazapine', 100100);

COMMIT;


-- -----------------------------------------------------
-- Data for table `CST363_DatabaseDesign_Project1`.`pharmacy`
-- -----------------------------------------------------
START TRANSACTION;
USE `CST363_DatabaseDesign_Project1`;
INSERT INTO `CST363_DatabaseDesign_Project1`.`pharmacy` (`pharmacyID`, `name`, `address`, `phonenumber`) VALUES (1000, 'Green Pharma', '6649 N Blue Gum St', '760-584-7895');
INSERT INTO `CST363_DatabaseDesign_Project1`.`pharmacy` (`pharmacyID`, `name`, `address`, `phonenumber`) VALUES (2000, 'MedaPill', '25 E 75th St #69', '760-524-5625');
INSERT INTO `CST363_DatabaseDesign_Project1`.`pharmacy` (`pharmacyID`, `name`, `address`, `phonenumber`) VALUES (3000, 'HelpUout', '366 South Dr', '760-562-6655');
INSERT INTO `CST363_DatabaseDesign_Project1`.`pharmacy` (`pharmacyID`, `name`, `address`, `phonenumber`) VALUES (4000, 'Pharma Care', '17 Morena Blvd', '760-841-5236');
INSERT INTO `CST363_DatabaseDesign_Project1`.`pharmacy` (`pharmacyID`, `name`, `address`, `phonenumber`) VALUES (5000, 'EZ-Pharmacy', '6980 Dorsett Rd', '619-345-5623');
INSERT INTO `CST363_DatabaseDesign_Project1`.`pharmacy` (`pharmacyID`, `name`, `address`, `phonenumber`) VALUES (6000, 'Cheap Thrills & Pills', '2371 Jerrold Ave', '619-548-6235');
INSERT INTO `CST363_DatabaseDesign_Project1`.`pharmacy` (`pharmacyID`, `name`, `address`, `phonenumber`) VALUES (7000, 'Old Guy Discount Pills', '394 Manchester Blvd', '858-64-9988');
INSERT INTO `CST363_DatabaseDesign_Project1`.`pharmacy` (`pharmacyID`, `name`, `address`, `phonenumber`) VALUES (8000, 'Alternative Medicine', '1 Central Ave', '858-789-1245');
INSERT INTO `CST363_DatabaseDesign_Project1`.`pharmacy` (`pharmacyID`, `name`, `address`, `phonenumber`) VALUES (9000, 'MadMeds', '2 Cedar Ave #84', '858-666-7777');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CST363_DatabaseDesign_Project1`.`Rx`
-- -----------------------------------------------------
START TRANSACTION;
USE `CST363_DatabaseDesign_Project1`;
INSERT INTO `CST363_DatabaseDesign_Project1`.`Rx` (`rxnumber`, `patient_ssn`, `doctor_ssn`, `date`) VALUES (0000001, '112-05-5623', '123-01-1010', '2021-01-12');
INSERT INTO `CST363_DatabaseDesign_Project1`.`Rx` (`rxnumber`, `patient_ssn`, `doctor_ssn`, `date`) VALUES (0000002, '513-05-9875', '564-02-3256', '2019-12-01');
INSERT INTO `CST363_DatabaseDesign_Project1`.`Rx` (`rxnumber`, `patient_ssn`, `doctor_ssn`, `date`) VALUES (0000003, '324-05-4815', '564-02-3256', '2019-09-01');
INSERT INTO `CST363_DatabaseDesign_Project1`.`Rx` (`rxnumber`, `patient_ssn`, `doctor_ssn`, `date`) VALUES (0000004, '354-45-0023', '845-80-6589', '2020-01-03');
INSERT INTO `CST363_DatabaseDesign_Project1`.`Rx` (`rxnumber`, `patient_ssn`, `doctor_ssn`, `date`) VALUES (0000005, '112-05-5623', '123-01-1010', '2018-05-09');
INSERT INTO `CST363_DatabaseDesign_Project1`.`Rx` (`rxnumber`, `patient_ssn`, `doctor_ssn`, `date`) VALUES (0000006, '358-55-6677', '845-80-6589', '2020-02-02');
INSERT INTO `CST363_DatabaseDesign_Project1`.`Rx` (`rxnumber`, `patient_ssn`, `doctor_ssn`, `date`) VALUES (0000007, '358-55-6677', '845-80-6589', '2020-04-06');
INSERT INTO `CST363_DatabaseDesign_Project1`.`Rx` (`rxnumber`, `patient_ssn`, `doctor_ssn`, `date`) VALUES (0000008, '324-05-4815', '847-52-1189', '2020-12-25');
INSERT INTO `CST363_DatabaseDesign_Project1`.`Rx` (`rxnumber`, `patient_ssn`, `doctor_ssn`, `date`) VALUES (0000009, '358-55-6677', '845-80-6589', '2020-11-30');
INSERT INTO `CST363_DatabaseDesign_Project1`.`Rx` (`rxnumber`, `patient_ssn`, `doctor_ssn`, `date`) VALUES (0000010, '324-05-4815', '847-52-1189', '2020-10-16');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CST363_DatabaseDesign_Project1`.`Rx_transaction`
-- -----------------------------------------------------
START TRANSACTION;
USE `CST363_DatabaseDesign_Project1`;
INSERT INTO `CST363_DatabaseDesign_Project1`.`Rx_transaction` (`transactionID`, `rxnumber`, `pharmacyID`, `tradename`, `quantity`, `date`) VALUES (1, 0000001, 1000, 'Acetic Acid', 10, '2021-01-16');
INSERT INTO `CST363_DatabaseDesign_Project1`.`Rx_transaction` (`transactionID`, `rxnumber`, `pharmacyID`, `tradename`, `quantity`, `date`) VALUES (2, 0000002, 1000, 'Remeron', 20, '2019-12-08');
INSERT INTO `CST363_DatabaseDesign_Project1`.`Rx_transaction` (`transactionID`, `rxnumber`, `pharmacyID`, `tradename`, `quantity`, `date`) VALUES (3, 0000003, 2000, 'Zovirax', 15, '2019-09-02');
INSERT INTO `CST363_DatabaseDesign_Project1`.`Rx_transaction` (`transactionID`, `rxnumber`, `pharmacyID`, `tradename`, `quantity`, `date`) VALUES (4, 0000004, 3000, 'Mephyton', 3000, '2020-01-03');
INSERT INTO `CST363_DatabaseDesign_Project1`.`Rx_transaction` (`transactionID`, `rxnumber`, `pharmacyID`, `tradename`, `quantity`, `date`) VALUES (5, 0000005, 6000, 'Zovirax', 48, '2018-05-09');
INSERT INTO `CST363_DatabaseDesign_Project1`.`Rx_transaction` (`transactionID`, `rxnumber`, `pharmacyID`, `tradename`, `quantity`, `date`) VALUES (6, 0000006, 6000, 'Zovirax', 51, '2020-02-05');
INSERT INTO `CST363_DatabaseDesign_Project1`.`Rx_transaction` (`transactionID`, `rxnumber`, `pharmacyID`, `tradename`, `quantity`, `date`) VALUES (7, 0000007, 8000, 'Klonopin', 11, '2020-04-26');
INSERT INTO `CST363_DatabaseDesign_Project1`.`Rx_transaction` (`transactionID`, `rxnumber`, `pharmacyID`, `tradename`, `quantity`, `date`) VALUES (8, 0000008, 8000, 'Klonopin', 5, '2020-12-29');
INSERT INTO `CST363_DatabaseDesign_Project1`.`Rx_transaction` (`transactionID`, `rxnumber`, `pharmacyID`, `tradename`, `quantity`, `date`) VALUES (9, 0000009, 7000, 'Femara', 6, '2020-12-12');
INSERT INTO `CST363_DatabaseDesign_Project1`.`Rx_transaction` (`transactionID`, `rxnumber`, `pharmacyID`, `tradename`, `quantity`, `date`) VALUES (10, 00000010, 9000, 'Cialis', 4, '2020-10-16');
INSERT INTO `CST363_DatabaseDesign_Project1`.`Rx_transaction` (`transactionID`, `rxnumber`, `pharmacyID`, `tradename`, `quantity`, `date`) VALUES (11, 0000001, 1000, 'Remeron', 5, '2021-01-16');

COMMIT;


-- -----------------------------------------------------
-- Data for table `CST363_DatabaseDesign_Project1`.`contract`
-- -----------------------------------------------------
START TRANSACTION;
USE `CST363_DatabaseDesign_Project1`;
INSERT INTO `CST363_DatabaseDesign_Project1`.`contract` (`contractID`, `supervisor`, `startdate`, `enddate`, `text`, `pharmacyID`, `companyID`, `tradename`, `price`) VALUES (2, 'TOM', '2020-12-01', '2021-12-30', '', 1000, 100100, 'Acetic Acid', 5);
INSERT INTO `CST363_DatabaseDesign_Project1`.`contract` (`contractID`, `supervisor`, `startdate`, `enddate`, `text`, `pharmacyID`, `companyID`, `tradename`, `price`) VALUES (3, 'SAM', '2020-09-01', '2021-12-30', '', 3000, 100300, 'Mephyton', 8);
INSERT INTO `CST363_DatabaseDesign_Project1`.`contract` (`contractID`, `supervisor`, `startdate`, `enddate`, `text`, `pharmacyID`, `companyID`, `tradename`, `price`) VALUES (4, 'SAM', '2020-08-01', '2021-12-30', '', 6000, 100200, 'Zovirax', 22);
INSERT INTO `CST363_DatabaseDesign_Project1`.`contract` (`contractID`, `supervisor`, `startdate`, `enddate`, `text`, `pharmacyID`, `companyID`, `tradename`, `price`) VALUES (5, 'JIM', '2020-07-01', '2021-12-30', '', 4000, 100300, 'Mephyton', 4);
INSERT INTO `CST363_DatabaseDesign_Project1`.`contract` (`contractID`, `supervisor`, `startdate`, `enddate`, `text`, `pharmacyID`, `companyID`, `tradename`, `price`) VALUES (6, 'TOM', '2020-07-01', '2021-12-30', '', 8000, 100300, 'Klonopin', 12);
INSERT INTO `CST363_DatabaseDesign_Project1`.`contract` (`contractID`, `supervisor`, `startdate`, `enddate`, `text`, `pharmacyID`, `companyID`, `tradename`, `price`) VALUES (7, 'SALLY', '2020-09-01', '2021-12-30', '', 7000, 100400, 'Femara', 16);
INSERT INTO `CST363_DatabaseDesign_Project1`.`contract` (`contractID`, `supervisor`, `startdate`, `enddate`, `text`, `pharmacyID`, `companyID`, `tradename`, `price`) VALUES (8, 'SALLY', '2020-09-01', '2021-12-30', '', 9000, 100300, 'Cialis', 30);
INSERT INTO `CST363_DatabaseDesign_Project1`.`contract` (`contractID`, `supervisor`, `startdate`, `enddate`, `text`, `pharmacyID`, `companyID`, `tradename`, `price`) VALUES (9, 'SALLY', '2020-09-01', '2021-12-30', '', 1000, 100100, 'Remeron', 10);
INSERT INTO `CST363_DatabaseDesign_Project1`.`contract` (`contractID`, `supervisor`, `startdate`, `enddate`, `text`, `pharmacyID`, `companyID`, `tradename`, `price`) VALUES (1, 'TIM', '2020-11-01', '2021-12-30', '', 2000, 100200, 'Zovirax', 10);

COMMIT;

/*Five questions for upper management. */

-- Display the pharmacy name, pharmacy ID whose sales exceed has exceeded $1000.

SELECT p.pharmacyID, p.name, SUM(c.price * ri.quantity) AS 'TotalSales'
FROM pharmacy p
JOIN Rx_transaction ri ON p.pharmacyID = ri.pharmacyID
JOIN contract c ON p.pharmacyID = c.pharmacyID 
GROUP BY p.pharmacyID
HAVING TotalSales >= 1000;

-- Display doctors name who specialize in emergency medicine.

SELECT doctor.name, doctor_specialty.specialty
FROM doctor
JOIN doctor_specialty ON doctor.specialtyID = doctor_specialty.specialtyID
WHERE doctor_specialty.specialty = 'Emergency medicine';

-- Which pharmacies contracts will be expiring before December 31st, 2021?

SELECT p.pharmacyID, c.contractID, p.name, c.startdate, c.enddate
FROM pharmacy p
JOIN contract c on p.pharmacyID = c.pharmacyID
HAVING c.enddate < '20211231';

-- Display the company name that produces the most expensive drug also display drug trade name and price.  

SELECT pharmaceutical_company.name as company, drug.tradename, contract.price
FROM contract
JOIN drug ON contract.tradename = drug.tradename
JOIN pharmaceutical_company ON drug.companyID = pharmaceutical_company.companyID
HAVING price = (SELECT MAX(contract.price) FROM contract);

-- Which patients are older than 65? And what is their doctor's name?

SELECT p.name as 'patient', p.age as 'patient age', d.name as 'primary doctor'
FROM patient p
JOIN doctor d ON p.doctor_ssn = d.doctor_ssn
JOIN doctor_specialty ds ON d.specialtyID = ds.specialtyID
WHERE p.age > 65;