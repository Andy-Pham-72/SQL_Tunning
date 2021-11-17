USE springboardopt;

-- -------------------------------------
SET @v1 = 1612521;
SET @v2 = 1145072;
SET @v3 = 1828467;
SET @v4 = 'MGT382';
SET @v5 = 'Amber Hill';
SET @v6 = 'MGT';
SET @v7 = 'EE';			  
SET @v8 = 'MAT';

-- 4. List the names of students who have taken a course taught by professor v5 (name).

SELECT name FROM Student,
	(SELECT studId FROM Transcript,
		(SELECT crsCode, semester FROM Professor
			JOIN Teaching
			ON Professor.name = @v5 AND Professor.id = Teaching.profId) as alias1
	WHERE Transcript.crsCode = alias1.crsCode AND Transcript.semester = alias1.semester) as alias2
WHERE Student.id = alias2.studId;

/*
- Bottle Neck: MySQL has to implement Full Table Scan in the Professor table as well as Teaching table. 
    + Query Cost: 135.33
    + In the expense of: 41 rows

- Solution: Create indexes for Professor and Teaching tables
*/

CREATE INDEX teach_indx ON Teaching(profId, crsCode, semester) USING BTREE;
CREATE INDEX prof_indx ON Professor(name, id) USING BTREE;
CREATE INDEX trans_indx ON Transcript(crsCode, studId, semester) USING BTREE;


SELECT name FROM Student,
	(SELECT studId FROM Transcript,
		(SELECT crsCode, semester FROM Professor
			JOIN Teaching
			ON Professor.name = @v5 AND Professor.id = Teaching.profId) as alias1
	WHERE Transcript.crsCode = alias1.crsCode AND Transcript.semester = alias1.semester) as alias2
WHERE Student.id = alias2.studId;

/*
# After creating indexes for the "Teaching", "Professor", "Transcript" columns run the query again. We don't have Full Table Scan in the Teaching table.
 And we have "Non-Unique Key Lookup" for the result in the subquery.
	+ Query Cost: 1.1 
    + In the expense of: 1 row for each table
*/

# alternate solution
SELECT 
    s.name
FROM
    Student AS s
        JOIN
    Transcript AS t ON s.id = t.studId
WHERE
    t.crsCode IN (SELECT 
            crsCode
        FROM
            Professor AS p
                JOIN
            Teaching AS te ON p.name = @v5 AND p.id = te.profId)
    ;

