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

-- 1. List the name of the student with id equal to v1 (id).
SELECT name FROM Student WHERE id = @v1;

# Check query performance
EXPLAIN SELECT name FROM Student WHERE id = @v1;

/*
- Bottle Neck: MySQL has to implement Full Table Scan in order to run the query for the result.
    + Query Cost: 41
    + In the expense of: 400 rows

- Solution: Create index for the column "id"
*/

CREATE INDEX student_indx ON Student(id) USING BTREE;

# Check query performance
EXPLAIN SELECT name FROM Student WHERE id = @v1;

/*
# After creating index on column "id" and run the query again.
	+ Query Cost: 0.35
    + In the expense of: 1 row
*/