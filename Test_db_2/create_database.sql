CREATE SCHEMA persons_db; #create BD

USE persons_db; #init BD

-- DROP TABLE table_persons;
-- DROP TABLE table_first_names;
-- DROP TABLE table_last_names;
-- DROP VIEW view_persons;

#create tables
CREATE TABLE table_first_names(
    id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE table_last_names(
    id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE table_persons(
    id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_first_name INTEGER NOT NULL,
    id_last_name INTEGER NOT NULL,
    date_of_birth DATE NOT NULL,
    is_delete INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (id_last_name)
        REFERENCES table_last_names(id)
            ON UPDATE NO ACTION
            ON DELETE NO ACTION,
    FOREIGN KEY (id_first_name)
        REFERENCES table_first_names(id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
);

INSERT INTO table_first_names (name) VALUES ('Vladimir'),
                                            ('Anonim');

INSERT INTO table_last_names (name) VALUES ('Ignatiew'),
                                           ('Anonimus');

#add something viable
# #########################################################
INSERT INTO table_persons (id_first_name, id_last_name, date_of_birth)
VALUES ((SELECT id
         FROM table_first_names
         WHERE name = 'Vladimir'),
        (SELECT id
         FROM table_last_names
         WHERE name = 'Ignatiew'),
        NOW());
INSERT INTO table_persons (id_first_name, id_last_name, date_of_birth)
VALUES ((SELECT id
         FROM table_first_names
         WHERE name = 'Anonim'),
        (SELECT id
         FROM table_last_names
         WHERE name = 'Anonimus'), NOW());
# #########################################################

#create VIEW_PERSONS
CREATE VIEW view_persons AS
    SELECT table_persons.id AS 'id',
           table_last_names.name AS 'last_name',
           table_first_names.name AS 'first_name',
           table_persons.date_of_birth AS 'date_of_birth',
           table_persons.is_delete AS 'is_delete'
    FROM table_persons
    JOIN table_first_names
        ON table_persons.id_first_name = table_first_names.id
    JOIN table_last_names
        ON table_persons.id_last_name = table_last_names.id;

#create PROCEDURE
CREATE PROCEDURE procedure_insert_into_table_persons(IN first_name TEXT,last_name TEXT, IN date DATE)
BEGIN
    IF NOT EXISTS(SELECT * FROM table_first_names WHERE name = first_name) THEN
        INSERT INTO table_first_names (name) VALUES (first_name);
    END IF;

    IF NOT EXISTS(SELECT * FROM table_last_names WHERE name = last_name) THEN
        INSERT INTO table_last_names (name) VALUES (last_name);
    END IF;

 INSERT INTO table_persons (id_first_name, id_last_name, date_of_birth)
 VALUES ((SELECT id
         FROM table_first_names
         WHERE name = first_name),
        (SELECT id
         FROM table_last_names
         WHERE name = last_name),
        date);
END;

SELECT * FROM view_persons;
CALL procedure_insert_into_table_persons('Anna','Karenina', NOW());