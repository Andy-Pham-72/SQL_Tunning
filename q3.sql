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

-- 3. List the names of students who have taken course v4 (crsCode).
SELECT name FROM Student WHERE id IN (SELECT studId FROM Transcript WHERE crsCode = @v4);

/*
- Bottle Neck: MySQL has to implement Full Table Scan in the subquery. 
    + Query Cost: 16.75
    + In the expense of: 400 rows

- Solution: Create indexes in order for "crsCode" and "studId" column.
*/

CREATE INDEX trans_indx ON Transcript(crsCode, studId) USING BTREE;

# Check the query performance
SELECT name FROM Student WHERE id IN (SELECT studId FROM Transcript WHERE crsCode = @v4);

/*
# After creating indexes on "crsCode" and "studId" columns run the query again. We don't have Full Table Scan.
 And we have "Non-Unique Key Lookup" for the result in the subquery.
	+ Query Cost: 1.18
    + In the expense of: 1 rows
*/