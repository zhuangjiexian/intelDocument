SELECT a.sid FROM (SELECT * FROM sc WHERE cid=1)a,(SELECT * FROM sc WHERE cid=2)b
WHERE a.sid=b.sid AND a.score>b.score;

SELECT sid,AVG(score) FROM sc GROUP BY sid HAVING AVG(score)>60;


SELECT s.sid,s.sname,COUNT(cid),SUM(score) FROM student s LEFT OUTER JOIN sc ON s.sid=sc.sid GROUP BY sid,sname;


SELECT COUNT(DISTINCT(tname)) FROM teacher WHERE tname LIKE '王%'

SELECT student.sid,student.sname FROM student WHERE sid 
NOT IN
(SELECT DISTINCT(sc.sid) FROM sc,teacher,course WHERE  course.cid=sc.cid AND teacher.tid=course.tid AND teacher.tname='王老师')

SELECT s.sid,s.sname FROM student s,sc WHERE s.sid=sc.sid AND sc.cid=1 AND EXISTS (SELECT * FROM 
sc AS sc_2 WHERE sc_2.cid=2 AND sc_2.sid=sc.sid)

SELECT sid,sname FROM student WHERE student.sid IN (SELECT sid FROM sc,teacher,course WHERE  teacher.tid=course.tid AND
course.cid=sc.cid AND teacher.tname='王老师' GROUP BY sid HAVING COUNT(sc.cid)=
(SELECT COUNT(*) FROM teacher,course WHERE course.tid=teacher.tid AND teacher.tname='王老师'))

SELECT sid,sname FROM student WHERE sid NOT IN (SELECT  DISTINCT(sid) FROM sc WHERE  sc.score>60);

SELECT student.sid,student.sname FROM student,sc WHERE student.sid=sc.sid GROUP BY student.sid HAVING COUNT(sc.cid)<(SELECT COUNT(*) FROM course)

SELECT DISTINCT(student.sid),student.sname FROM student,sc WHERE student.sid=sc.sid AND sc.cid IN
(SELECT cid FROM sc WHERE sid = 4);


UPDATE sc SET score=
(SELECT AVG(*) FROM sc sc2 WHERE sc2.cid=sc1.cid) FROM sc sc1,course,teacher WHERE teacher.tid=course.tid AND course.cid=sc.cid AND teacher.tname='王老师'

SELECT student.sid,student.sname FROM sc,student WHERE sc.sid=student.sid AND sc.cid IN (SELECT cid FROM sc WHERE sid=2)
GROUP BY sid HAVING COUNT(sc.cid)=(SELECT COUNT(*) FROM sc WHERE sid=2)

DELETE sc FROM course

