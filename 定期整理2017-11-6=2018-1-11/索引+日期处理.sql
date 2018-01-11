/**
建立索引
*/
CREATE INDEX sname_index ON student(sname(10));
DROP INDEX sname_index ON student;
ALTER TABLE student ADD INDEX sname_index2 ON (sname(10));





CREATE INDEX name_ ON tableName(column_(length_)) 

SELECT * FROM student WHERE sname_index='张三'
SELECT * FROM YEAR(NOW()) FROM DUAL;
/**
********格式化日期***********
%Y 四位数字表示的年份
%y 两位数字表示的年份
%M 月名（January, February, ..., December）
%m 两位数字表示的月份（01, 02, ..., 12）
%D 英文后缀表示月中的天数（1st, 2nd, 3rd,...）
%d 两位数字表示月中的天数（00, 01,..., 31）
%S, %s 两位数字形式的秒（ 00,01, ..., 59）
%I, %i 两位数字形式的分（ 00,01, ..., 59）
%H 两位数字形式的小时，24 小时（00,01, ..., 23）
%h 两位数字形式的小时，12 小时（01,02, ..., 12）
*/
SELECT DATE_FORMAT(NOW(),'%Y-%m-%d %H:%I:%S');

/**
********字符串转化为格式日期******
select str_to_date('08/09/2008', '%m/%d/%Y'); -- 2008-08-09
select str_to_date('08/09/08' , '%m/%d/%y'); -- 2008-08-09
select str_to_date('08.09.2008', '%m.%d.%Y'); -- 2008-08-09
select str_to_date('08:09:30', '%h:%i:%s'); -- 08:09:30
select str_to_date('08.09.2008 08:09:30', '%m.%d.%Y %h:%i:%s'); -- 2008-08-09 08:09:30
*/
SELECT DATE_FORMAT(STR_TO_DATE('08/09/2008', '%m/%d/%Y'),'%y'); -- 2008-08-09
SELECT STR_TO_DATE('08/09/08' , '%m/%d/%Y'); -- 2008-08-9


/**
天数转换
*/
SELECT TO_DAYS('2008-08-08'); -- 733627
SELECT TO_DAYS('2008-08-12');
/**查询天数*/
SELECT ((SELECT TO_DAYS('2008-08-12'))-  (SELECT TO_DAYS('2008-08-08'))) result FROM DUAL;

/**
增加一个时间间隔
*/
SET @dt = NOW();

SELECT DATE_ADD(@dt, INTERVAL 1 DAY); -- add 1 day
SELECT DATE_ADD(@dt, INTERVAL 1 HOUR); -- add 1 hour
SELECT DATE_ADD(@dt, INTERVAL 1 MINUTE); -- ...
SELECT DATE_ADD(@dt, INTERVAL 1 SECOND);
SELECT DATE_ADD(@dt, INTERVAL 1 MICROSECOND);
SELECT DATE_ADD(@dt, INTERVAL 1 WEEK);
SELECT DATE_ADD(@dt, INTERVAL 1 MONTH);
SELECT DATE_ADD(@dt, INTERVAL 1 QUARTER);
SELECT DATE_ADD(@dt, INTERVAL 1 YEAR);

SELECT DATE_ADD(@dt, INTERVAL -1 DAY); -- sub 1 day

/**
减去一个时间间隔
*/
SET @dt=NOW();
SELECT DATE_SUB(@dt,INTERVAL 2 DAY);

/**
MySQL 日期、时间相减函数：datediff(date1,date2), timediff(time1,time2)
MySQL datediff(date1,date2)：两个日期相减 date1 - date2，返回天数。
*/
SELECT DATEDIFF('2008-08-08', '2008-08-01'); -- 7
SELECT DATEDIFF('2008-08-01', '2008-08-08'); -- -7

/**
MySQL timediff(time1,time2)：两个日期相减 time1 - time2，返回 time 差值。
*/
SELECT TIMEDIFF('2008-08-08 08:08:08', '2008-08-08 00:00:00'); -- 08:08:08
SELECT TIMEDIFF('08:08:08', '00:00:00'); -- 08:08:08


/**
MySQL 时间戳（timestamp）转换、增、减函数：
*/
TIMESTAMP(DATE) -- date to timestamp
TIMESTAMP(dt,TIME) -- dt + time
TIMESTAMPADD(unit,INTERVAL,datetime_expr) --
TIMESTAMPDIFF(unit,datetime_expr1,datetime_expr2) --
/**
请看示例部分：
*/
/**
复制代码
*/
SELECT TIMESTAMP('2008-08-08'); -- 2008-08-08 00:00:00
SELECT TIMESTAMP('2008-08-08 08:00:00', '01:01:01'); -- 2008-08-08 09:01:01
SELECT TIMESTAMP('2008-08-08 08:00:00', '10 01:01:01'); -- 2008-08-18 09:01:01

SELECT TIMESTAMPADD(DAY, 1, '2008-08-08 08:00:00'); -- 2008-08-09 08:00:00
SELECT DATE_ADD('2008-08-08 08:00:00', INTERVAL 1 DAY); -- 2008-08-09 08:00:00
/**
MySQL timestampadd() 函数类似于 date_add()
*/
SELECT TIMESTAMPDIFF(YEAR,'2002-05-01','2001-01-01'); -- -1
SELECT TIMESTAMPDIFF(DAY ,'2002-05-01','2001-01-01'); -- -485
SELECT TIMESTAMPDIFF(HOUR,'2008-08-08 12:00:00','2008-08-08 00:00:00'); -- -12

SELECT DATEDIFF('2008-08-08 12:00:00', '2008-08-01 00:00:00'); -- 7


