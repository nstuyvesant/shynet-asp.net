-- Connect to the existing database
\connect da0jnnc2g2liki

-- Support generation of uuids
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Create tables

CREATE TABLE old_payment_types (
	id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
	name varchar(16) NOT NULL,
	ordinal smallint NOT NULL,
	active boolean DEFAULT true NOT NULL
);

CREATE TABLE old_instructors (
	id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
	active boolean DEFAULT true NOT NULL,
	firstname varchar(20) NOT NULL,
	lastname varchar(20) NOT NULL,
	email varchar(50) NULL,
  UNIQUE (lastname, firstname)
);

CREATE TABLE old_classes (
	id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
	active boolean DEFAULT true NOT NULL,
	name varchar(80) NOT NULL
);

CREATE TABLE old_students (
	id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
	active boolean DEFAULT true NOT NULL,
	firstname varchar(20) NOT NULL,
	lastname varchar(20) NOT NULL,
  UNIQUE (firstname, lastname)
);

CREATE TABLE old_locations (
	id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
	active boolean DEFAULT true NOT NULL,
	name varchar(50) NOT NULL
);

CREATE TABLE old_purchases (
	id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
	student_id uuid NOT NULL REFERENCES old_students(id),
	purchased_on timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	quantity smallint DEFAULT 1 NOT NULL,
	payment_type_id uuid NOT NULL REFERENCES old_payment_types(id),
	location_id uuid NULL REFERENCES old_locations(id),
	instructor_id uuid NULL REFERENCES old_instructors(id),
	class_id uuid NULL REFERENCES old_classes(id)
);

CREATE TABLE old_attendances (
	id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
	instructor_id uuid NOT NULL REFERENCES old_instructors(id),
	class_id uuid NOT NULL REFERENCES old_classes(id),
	location_id uuid NOT NULL REFERENCES old_locations(id),
	student_id uuid NOT NULL REFERENCES old_students(id),
	class_date date DEFAULT CURRENT_DATE NOT NULL,
  UNIQUE (instructor_id, class_id, location_id, student_id, class_date)
);

-- Create indices
CREATE INDEX ix_old_payment_types_ordinal ON old_payment_types USING btree (active, ordinal);
CREATE INDEX ix_old_instructors_active ON old_instructors USING btree (active, lastname);
CREATE INDEX ix_old_classes_active_name ON old_classes USING btree (active, name);
CREATE INDEX ix_old_students_active ON old_students USING btree (active, lastname);
CREATE INDEX ix_old_locations_active ON old_locations USING btree (active, name);

CREATE INDEX fkey_old_purchases_student ON old_purchases USING btree (student_id);
CREATE INDEX fkey_old_purchases_student_date ON old_purchases USING btree (student_id, purchased_on);
CREATE INDEX fkey_old_attendances_student ON old_attendances USING btree (student_id);
CREATE INDEX fkey_old_attendances_student_date ON old_attendances USING btree (student_id, class_date);
CREATE INDEX fkey_old_attendances_in_class ON old_attendances USING btree (class_date, location_id, class_id, instructor_id);
CREATE INDEX fkey_old_attendances_locations ON old_attendances USING btree (location_id, class_date);

-- Create views
CREATE OR REPLACE VIEW old_students_purchased_attended AS
  SELECT
    firstname,
    lastname,
    SUM(quantity) AS purchased,
    COUNT(old_attendances.id) AS attended
  FROM
    old_students LEFT OUTER JOIN
        old_attendances ON old_students.id = old_attendances.student_id LEFT OUTER JOIN
          old_purchases ON old_students.id = old_purchases.student_id
  GROUP BY firstname, lastname, old_students.id;

CREATE OR REPLACE VIEW old_attendances_location AS
  SELECT
    old_locations.name AS location,
    old_classes.name AS class,
    old_instructors.lastname || ', ' || old_instructors.firstname AS instructor,
    old_attendances.class_date, 
    COUNT(old_attendances.student_id) AS students
  FROM
    old_attendances INNER JOIN
        old_locations ON old_attendances.location_id = old_locations.id INNER JOIN
              old_instructors ON old_attendances.instructor_id = old_instructors.id INNER JOIN
                    old_classes ON old_attendances.class_id = old_classes.id
  GROUP BY
    old_locations.name, old_attendances.class_date, old_instructors.lastname, old_instructors.firstname, old_classes.name
  ORDER BY
    location, old_attendances.class_date;

CREATE OR REPLACE VIEW old_nh_quarterly_attendance AS
  SELECT
    SUM(students) AS attendances_last_quarter
  FROM
    old_attendances_location
  WHERE
    location = 'North Hills' AND
    class_date >= '2018-04-01'::date AND
    class_date < '2018-07-01'::date;

CREATE OR REPLACE VIEW old_class_counts AS
  SELECT
    old_instructors.lastname || ', ' || old_instructors.firstname AS instructor,
    old_classes.name AS class,
    old_locations.name AS location,
    old_attendances.class_date, 
    COUNT(old_attendances.student_id) AS students
  FROM
    old_attendances INNER JOIN
      old_instructors ON old_attendances.instructor_id = old_instructors.id INNER JOIN
        old_students ON old_attendances.student_id = old_students.id INNER JOIN
          old_locations ON old_attendances.location_id = old_locations.id INNER JOIN
            old_classes ON old_attendances.class_id = old_classes.id
  GROUP BY
    old_instructors.lastname || ', ' || old_instructors.firstname,
    old_classes.name,
    old_locations.name,
    old_attendances.class_date
  ORDER BY
    instructor, class, location, old_attendances.class_date;

CREATE OR REPLACE VIEW old_attendees AS
  SELECT
    old_attendances.id,
    old_students.lastname || ', ' || old_students.firstname AS name,
    old_attendances.class_date,
    old_attendances.instructor_id,
    old_attendances.class_id,
    old_attendances.location_id, 
    old_attendances.student_id
  FROM
    old_attendances INNER JOIN
        old_students ON old_attendances.student_id = old_students.id;

CREATE OR REPLACE VIEW old_attendances_full_info AS
  SELECT
    old_instructors.lastname || ', ' || old_instructors.firstname AS instructor,
    old_classes.name AS class,
    old_locations.name AS location,
    old_attendances.class_date, 
    old_students.lastname || ', ' || old_students.firstname AS student
  FROM
    old_attendances INNER JOIN
      old_instructors ON old_attendances.instructor_id = old_instructors.id INNER JOIN
        old_students ON old_attendances.student_id = old_students.id INNER JOIN
          old_locations ON old_attendances.location_id = old_locations.id INNER JOIN
            old_classes ON old_attendances.class_id = old_classes.id
  ORDER BY
    instructor, class, location, old_attendances.class_date;

CREATE OR REPLACE VIEW old_purchases_full_info AS
  SELECT
    old_students.lastname,
    old_students.firstname,
    old_purchases.purchased_on,
    old_purchases.quantity,
    old_payment_types.name AS method,
    old_locations.name AS location, 
    old_instructors.lastname || ', ' || old_instructors.firstname AS instructor,
    old_classes.name AS class
  FROM
    old_purchases INNER JOIN
      old_students ON old_purchases.student_id = old_students.id INNER JOIN
        old_payment_types ON old_purchases.payment_type_id = old_payment_types.id LEFT OUTER JOIN
          old_locations ON old_purchases.location_id = old_locations.id LEFT OUTER JOIN
            old_instructors ON old_purchases.instructor_id = old_instructors.id LEFT OUTER JOIN
              old_classes ON old_purchases.class_id = old_classes.id
  ORDER BY
    old_students.lastname, old_students.firstname, old_purchases.purchased_on DESC;

CREATE OR REPLACE VIEW old_student_balances AS
  SELECT
    id, firstname, lastname,
    (SELECT COALESCE(SUM(quantity), 0) AS purchases
      FROM old_purchases
      WHERE (student_id = old_students.id)) +
    (SELECT - COUNT(*) AS attendances
      FROM old_attendances
      WHERE (student_id = old_students.id)) AS balance,
    (SELECT MAX(class_date) AS max_class_date
      FROM old_attendees
      WHERE (student_id = old_students.id)) AS last_attended,
    (SELECT MAX(purchased_on) AS max_purchased_on
      FROM old_purchases -- AS purchases_1
      WHERE (student_id = old_students.id)) AS last_purchase
  FROM old_students
  WHERE active = true
  ORDER BY lastname, firstname;

CREATE OR REPLACE VIEW old_students_who_owe AS
  SELECT
    lastname || ', ' || firstname AS name,
    balance
  FROM
    old_student_balances
  WHERE balance < 0
  ORDER BY lastname, firstname;

CREATE OR REPLACE VIEW old_students_purchased_attended AS
  SELECT
    old_students.firstname,
    old_students.lastname,
    SUM(old_purchases.quantity) AS purchased,
    COUNT(old_attendances.id) AS attended
  FROM
    old_students LEFT OUTER JOIN
      old_attendances ON old_students.id = old_attendances.student_id LEFT OUTER JOIN
        old_purchases ON old_students.id = old_purchases.student_id
  GROUP BY old_students.firstname, old_students.lastname, old_students.id
  ORDER BY old_students.lastname, old_students.firstname;

  CREATE OR REPLACE VIEW old_attendances_location AS
    SELECT
      old_locations.name AS location,
      old_classes.name AS class,
      old_instructors.lastname || ', ' || old_instructors.firstname AS instructor,
      old_attendances.class_date, 
      COUNT(old_attendances.student_id) AS students
    FROM
      old_attendances INNER JOIN
        old_locations ON old_attendances.location_id = old_locations.id INNER JOIN
          old_instructors ON old_attendances.instructor_id = old_instructors.id INNER JOIN
            old_classes ON old_attendances.class_id = old_classes.id
    GROUP BY old_locations.name, old_attendances.class_date, old_instructors.lastname, old_instructors.firstname, old_classes.name
    ORDER BY location, old_attendances.class_date;

-- Create functions

CREATE OR REPLACE FUNCTION old_delete_student (uuid) RETURNS boolean AS $$
DECLARE
  balance int;
BEGIN
  SELECT balance = (SELECT COUNT(*) FROM old_attendances WHERE student_id = $1) - (SELECT COUNT(*) FROM old_purchases WHERE student_id = $1);
  IF balance = 0 THEN
    DELETE FROM old_students WHERE id = $1;
    RETURN true;
  ELSE
    RETURN false;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION old_delete_history (char(1), uuid) RETURNS void AS $$
BEGIN
  IF $1 = 'P' THEN
    DELETE FROM old_purchases WHERE id = $2;
  ELSE
    DELETE FROM old_attendances WHERE id = $2;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION old_update_history (char(1), uuid, date, uuid, uuid, uuid, smallint, uuid) RETURNS void AS $$
BEGIN
  IF $1 = 'P' THEN
		UPDATE old_purchases
			SET
				purchased_on = $3,
				instructor_id = $4,
				location_id = $5,
				class_id = $6,
				quantity = $7,
				payment_type_id = $8
			WHERE id = $2;
	ELSE
		UPDATE old_attendances
			SET
				class_date = $3,
				instructor_id = $4,
				location_id = $5,
				class_id = $6
			WHERE id = $2;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION old_zero_old_passes () RETURNS void AS $$
DECLARE
  cutoff timestamp := CURRENT_TIMESTAMP - INTERVAL '12 months';
BEGIN
  -- Create temp table of active students with their balance
  CREATE TEMPORARY TABLE IF NOT EXISTS student_balances_temp AS
    SELECT
      id, balance
    FROM
      student_balances WHERE balance > 0;
  
  -- Eliminate students who bought a card within the last 6 months
	DELETE FROM student_balances_temp WHERE id IN (SELECT DISTINCT student_id FROM old_purchases WHERE purchased_on >= cutoff);

  -- Insert negative purchase to expire class cards
	INSERT INTO old_purchases (student_id, quantity, payment_type_id, location_id, instructor_id, class_id)
	SELECT
		id,
		- balance,
		'd31914ca-2044-4a81-b6b8-d994fa91eebf' as payment_type_id,
		'65afdb35-fffc-420f-8d39-2e587cd8e558' AS location_id,
		'02299f3d-a39f-4b57-b72d-9368029fe391' AS instructor_id,
		'b8e952e6-17c5-46b9-b2ea-0f0f69870cc9' AS class_id
	FROM
		student_balances_temp;
  DROP TABLE student_balances_temp;
END;
$$ LANGUAGE plpgsql;

-- Used by history.aspx
CREATE OR REPLACE FUNCTION old_show_history (uuid) RETURNS setof record AS $$
BEGIN
  -- Create temp table for student's history
  CREATE TEMPORARY TABLE IF NOT EXISTS old_history_temp (
		id uuid,
		ord serial,
		transaction_type char(1),
		transaction_date date,
		what varchar(256),
		quantity integer,
		instructor_id uuid,
		class_id uuid,
		location_id uuid,
		payment_type_id uuid
  );

	INSERT INTO old_history_temp (id,transaction_type,transaction_date,what,quantity,instructor_id,class_id,location_id,payment_type_id)
		SELECT
			old_purchases.id,
			'P',
			old_purchases.purchased_on::date AS transaction_date,
			'<span class="text-success">Purchased</span> ' || to_char(old_purchases.quantity,'FM999MI') || ' class pass (' || old_payment_types.name || ')' AS what,
			old_purchases.quantity,
			COALESCE(instructor_id,'{f6609ffa-1814-4405-b359-140a4bfee954}'),
			COALESCE(class_id,'{22f89403-6871-4201-9eb1-014872f61238}'),
			COALESCE(location_id,'{65afdb35-fffc-420f-8d39-2e587cd8e558}'),
			COALESCE(payment_type_id,'{3f9b38fc-48c9-4c1b-a71f-516b3b602b13}')
		FROM
			old_purchases INNER JOIN
			old_payment_types ON old_purchases.payment_type_id = old_payment_types.id
		WHERE
			old_purchases.student_id = $1
	  UNION ALL
		SELECT
			old_attendances.id,
			'A',
			old_attendances.class_date AS transaction_date,
			'<span class="text-danger">Attended</span> ' || old_classes.name || ' (' || old_locations.name || '/' || old_instructors.lastname || ')' AS what,
			- 1 AS quantity,
			COALESCE(instructor_id,'{f6609ffa-1814-4405-b359-140a4bfee954}'),
			COALESCE(class_id,'{22f89403-6871-4201-9eb1-014872f61238}'),
			COALESCE(location_id,'{65afdb35-fffc-420f-8d39-2e587cd8e558}'),
			'{3f9b38fc-48c9-4c1b-a71f-516b3b602b13}'
		FROM
			old_attendances INNER JOIN
			old_classes ON old_attendances.class_id = old_classes.id INNER JOIN
			old_instructors ON old_attendances.instructor_id = old_instructors.id INNER JOIN
			old_locations ON old_attendances.location_id = old_locations.id
		WHERE
			old_attendances.student_id = $1
	ORDER BY
		transaction_date DESC;

	RETURN QUERY SELECT
		transaction_type,
		id,
		b.transaction_date,
		b.what AS "Description",
		b.quantity AS "Quantity",
		(SELECT SUM(a.quantity) FROM old_history_temp AS a WHERE
			a.ord >= b.ord) AS "Balance",
		instructor_id,
		class_id,
		location_id,
		payment_type_id
	FROM
		old_history_temp AS b
	ORDER BY
		transaction_date DESC;

  DROP TABLE old_history_temp;
END;
$$ LANGUAGE plpgsql;
