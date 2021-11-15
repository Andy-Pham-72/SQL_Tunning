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

-- 2. List the names of students with id in the range of v2 (id) to v3 (inclusive).
SELECT name FROM Student WHERE id BETWEEN @v2 AND @v3;

# Check query performance
EXPLAIN SELECT name FROM Student WHERE id BETWEEN @v2 AND @v3;

/*
- Bottle Neck: MySQL has to implement Full Table Scan in order to run the query for the result.
    + Query Cost: 41
    + In the expense of: 400 rows

- Solution: Create indexes in order for the column "id" and "name"
*/


CREATE INDEX student_indx ON Student(id,name) USING BTREE;

# Check query performance
EXPLAIN SELECT name FROM Student WHERE id BETWEEN @v2 AND @v3;

/*
# After creating indexes on column "id" and "name" run the query again. We have "Index Range Scan"
	+ Query Cost: 64.52
    + In the expense of: 278 rows
*/

