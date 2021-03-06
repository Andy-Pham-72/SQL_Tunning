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

-- 5. List the names of students who have taken a course from department v6 (deptId), but not v7.
SELECT * FROM Student, 
	(SELECT studId FROM Transcript, Course WHERE deptId = @v6 AND Course.crsCode = Transcript.crsCode
	AND studId NOT IN
	(SELECT studId FROM Transcript, Course WHERE deptId = @v7 AND Course.crsCode = Transcript.crsCode)) as alias
WHERE Student.id = alias.studId;

/*
- Bottle Neck: MySQL has to implement Full Table Scan in the Course table. 
    + Query Cost: 17.40
    + In the expense of: 100 rows (from Course)

- Solution: Create indexes for Course tables
*/

CREATE INDEX course_indx ON Course(deptId, crsCode) USING BTREE;
CREATE INDEX trans_indx ON Transcript(crsCode, studId) USING BTREE;

/* From Full Table Scan to "Non-Unique Key Loockup" in the Course table.