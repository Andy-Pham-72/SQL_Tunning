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

-- 6. List the names of students who have taken all courses offered by department v8 (deptId).
SELECT name FROM Student,
	(SELECT studId
	FROM Transcript
		WHERE crsCode IN
		(SELECT crsCode FROM Course WHERE deptId = @v8 AND crsCode IN (SELECT crsCode FROM Teaching))
		GROUP BY studId
		HAVING COUNT(*) = 
			(SELECT COUNT(*) FROM Course WHERE deptId = @v8 AND crsCode IN (SELECT crsCode FROM Teaching))) as alias
WHERE id = alias.studId;


/*
- Bottle Neck: MySQL has to implement Full Table Scan in the subquery for the Teaching table 
    + Query Cost: 10.25
    + In the expense of: 100 rows (from Teaching)

- Solution: Create indexes for Teaching table
*/

# Drop the teach_indx which was created in the Question 4 since the order of the indexes is matter
DROP INDEX teach_indx ON Teaching;

# Create index for Teaching table and re-order the indexes (we could also remove the "profId" if we want)
CREATE INDEX teach_indx ON Teaching(crsCode, semester, profId) USING BTREE;

# Check the query performance
SELECT name FROM Student,
	(SELECT studId
	FROM Transcript
		WHERE crsCode IN
		(SELECT crsCode FROM Course WHERE deptId = @v8 AND crsCode IN (SELECT crsCode FROM Teaching))
		GROUP BY studId
		HAVING COUNT(*) = 
			(SELECT COUNT(*) FROM Course WHERE deptId = @v8 AND crsCode IN (SELECT crsCode FROM Teaching))) as alias
WHERE id = alias.studId;

/*
# After creating indexes on "crsCode" and "semester" columns in the Teaching table and run the query again. 
We don't have Full Table Scan in the Teaching table.
And we have "Non-Unique Key Lookup" for the result in the subquery.
	+ Query Cost: 6.89 (for Teaching table)
	+ In the expense of: 1 rows ( for Teaching table)
	and 19 rows (for Course table)
*/

# Alternate Solution
SELECT DISTINCT name 
	FROM Student AS s
    JOIN Transcript AS t
		ON s.id = t.studId
	WHERE t.crsCode IN
    ( SELECT c.crsCode
		FROM Course AS c
        JOIN Teaching AS t2
			ON c.crsCode = t2.crsCode
		WHERE c.deptId = @v8
	);
    
    /*
# After creating indexes on "crsCode" and "semester" columns in the Teaching table and run the query again. 
We don't have Full Table Scan in the Teaching table.
And we have "Non-Unique Key Lookup" for the result in the subquery.
	+ Query Cost: 6.89 (for Teaching table)
    + In the expense of: 1 rows ( for Teaching table)
    and 19 rows (for Course table)
*/