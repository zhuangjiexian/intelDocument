mysql存储过程语法及实例 

mysql创建存储过程注意：
mysql> DELIMITER //  
 mysql> CREATE PROCEDURE proc1(OUT s int)  
     -> BEGIN 
     -> SELECT COUNT(*) INTO s FROM user;  
     -> END 
     -> //  
 mysql> DELIMITER ;
 这里需要注意的是DELIMITER //和DELIMITER ;两句，DELIMITER是分割符的意思，因为MySQL默认以";"为分隔符，如果我们没有声明分割符，
 那么编译器会把存储过程当成SQL语句进行处理，则存储过程的编译过程会报错，所以要事先用DELIMITER关键字申明当前段分隔符，这样MySQL才会将";
 "当做存储过程中的代码，不会执行这些代码，用完了之后要把分隔符还原。 






存储过程如同一门程序设计语言，同样包含了数据类型、流程控制、输入和输出和它自己的函数库。


--------------------基本语法--------------------

一.创建存储过程
create procedure sp_name()
begin
.........
end

二.调用存储过程
1.基本语法：call sp_name()
注意：存储过程名称后面必须加括号，哪怕该存储过程没有参数传递

三.删除存储过程
1.基本语法：
drop procedure sp_name//

2.注意事项
(1)不能在一个存储过程中删除另一个存储过程，只能调用另一个存储过程

四.其他常用命令

1.show procedure status
显示数据库中所有存储的存储过程基本信息，包括所属数据库，存储过程名称，创建时间等

2.show create procedure sp_name
显示某一个mysql存储过程的详细信息


--------------------数据类型及运算符--------------------
一、基本数据类型：
略

二、变量：

自定义变量：DECLARE   a INT ; SET a=100;    可用以下语句代替：DECLARE a INT DEFAULT 100;

变量分为用户变量和系统变量，系统变量又分为会话和全局级变量

用户变量：用户变量名一般以@开头，滥用用户变量会导致程序难以理解及管理

1、 在mysql客户端使用用户变量
mysql> SELECT 'Hello World' into @x;
mysql> SELECT @x;

mysql> SET @y='Goodbye Cruel World';
mysql> select @y;

mysql> SET @z=1+2+3;
mysql> select @z;


2、 在存储过程中使用用户变量

mysql> CREATE PROCEDURE GreetWorld( ) SELECT CONCAT(@greeting,' World');
mysql> SET @greeting='Hello';
mysql> CALL GreetWorld( );


3、 在存储过程间传递全局范围的用户变量
mysql> CREATE PROCEDURE p1( )   SET @last_procedure='p1';
mysql> CREATE PROCEDURE p2( ) SELECT CONCAT('Last procedure was ',@last_procedure);
mysql> CALL p1( );
mysql> CALL p2( );

 

三、运算符：
1.算术运算符
+     加   SET var1=2+2;       4
-     减   SET var2=3-2;       1
*      乘   SET var3=3*2;       6
/     除   SET var4=10/3;      3.3333
DIV   整除 SET var5=10 DIV 3; 3
%     取模 SET var6=10%3 ;     1

2.比较运算符
>            大于 1>2 False
<            小于 2<1 False
<=           小于等于 2<=2 True
>=           大于等于 3>=2 True
BETWEEN      在两值之间 5 BETWEEN 1 AND 10 True
NOT BETWEEN 不在两值之间 5 NOT BETWEEN 1 AND 10 False
IN           在集合中 5 IN (1,2,3,4) False
NOT IN       不在集合中 5 NOT IN (1,2,3,4) True
=             等于 2=3 False
<>, !=       不等于 2<>3 False
<=>          严格比较两个NULL值是否相等 NULL<=>NULL True
LIKE          简单模式匹配 "Guy Harrison" LIKE "Guy%" True
REGEXP       正则式匹配 "Guy Harrison" REGEXP "[Gg]reg" False
IS NULL      为空 0 IS NULL False
IS NOT NULL 不为空 0 IS NOT NULL True

3.逻辑运算符

4.位运算符
|   或
&   与
<< 左移位
>> 右移位
~   非(单目运算，按位取反)

注释：

mysql存储过程可使用两种风格的注释
双横杠：--

该风格一般用于单行注释
c风格：/* 注释内容 */ 一般用于多行注释

--------------------流程控制--------------------
一、顺序结构
二、分支结构
if
case

三、循环结构
for循环
while循环
loop循环
repeat until循环

注：
区块定义，常用
begin
......
end;
也可以给区块起别名，如：
lable:begin
...........
end lable;
可以用leave lable;跳出区块，执行区块以后的代码

begin和end如同C语言中的{ 和 }。

--------------------输入和输出--------------------

mysql存储过程的参数用在存储过程的定义，共有三种参数类型,IN,OUT,INOUT
Create procedure|function([[IN |OUT |INOUT ] 参数名 数据类形...])

IN 输入参数
表示该参数的值必须在调用存储过程时指定，在存储过程中修改该参数的值不能被返回，为默认值

OUT 输出参数
该值可在存储过程内部被改变，并可返回

INOUT 输入输出参数
调用时指定，并且可被改变和返回

IN参数例子：
CREATE PROCEDURE sp_demo_in_parameter(IN p_in INT)
BEGIN
SELECT p_in; --查询输入参数
SET p_in=2; --修改
select p_in;--查看修改后的值
END;

执行结果:
mysql> set @p_in=1
mysql> call sp_demo_in_parameter(@p_in)
略
mysql> select @p_in;
略
以上可以看出，p_in虽然在存储过程中被修改，但并不影响@p_id的值

OUT参数例子
创建:
mysql> CREATE PROCEDURE sp_demo_out_parameter(OUT p_out INT)
BEGIN
SELECT p_out;/*查看输出参数*/
SET p_out=2;/*修改参数值*/
SELECT p_out;/*看看有否变化*/
END;

执行结果:
mysql> SET @p_out=1
mysql> CALL sp_demo_out_parameter(@p_out)
略

mysql> SELECT @p_out;
略

INOUT参数例子：
mysql> CREATE PROCEDURE sp_demo_inout_parameter(INOUT p_inout INT)
BEGIN
SELECT p_inout;
SET p_inout=2;
SELECT p_inout;
END;

执行结果：
set @p_inout=1
call sp_demo_inout_parameter(@p_inout) //
略
select @p_inout;
略

 

 

附：函数库
mysql存储过程基本函数包括：字符串类型，数值类型，日期类型

一、字符串类
CHARSET(str) //返回字串字符集
CONCAT (string2 [,… ]) //连接字串
INSTR (string ,substring ) //返回substring首次在string中出现的位置,不存在返回0
LCASE (string2 ) //转换成小写
LEFT (string2 ,length ) //从string2中的左边起取length个字符
LENGTH (string ) //string长度
LOAD_FILE (file_name ) //从文件读取内容
LOCATE (substring , string [,start_position ] ) 同INSTR,但可指定开始位置
LPAD (string2 ,length ,pad ) //重复用pad加在string开头,直到字串长度为length
LTRIM (string2 ) //去除前端空格
REPEAT (string2 ,count ) //重复count次
REPLACE (str ,search_str ,replace_str ) //在str中用replace_str替换search_str
RPAD (string2 ,length ,pad) //在str后用pad补充,直到长度为length
RTRIM (string2 ) //去除后端空格
STRCMP (string1 ,string2 ) //逐字符比较两字串大小,
SUBSTRING (str , position [,length ]) //从str的position开始,取length个字符,
注：mysql中处理字符串时，默认第一个字符下标为1，即参数position必须大于等于1
mysql> select substring(’abcd’,0,2);
+———————–+
| substring(’abcd’,0,2) |
+———————–+
|                       |
+———————–+
1 row in set (0.00 sec)

mysql> select substring(’abcd’,1,2);
+———————–+
| substring(’abcd’,1,2) |
+———————–+
| ab                    |
+———————–+
1 row in set (0.02 sec)

TRIM([[BOTH|LEADING|TRAILING] [padding] FROM]string2) //去除指定位置的指定字符
UCASE (string2 ) //转换成大写
RIGHT(string2,length) //取string2最后length个字符
SPACE(count) //生成count个空格

二、数值类型

ABS (number2 ) //绝对值
BIN (decimal_number ) //十进制转二进制
CEILING (number2 ) //向上取整
CONV(number2,from_base,to_base) //进制转换
FLOOR (number2 ) //向下取整
FORMAT (number,decimal_places ) //保留小数位数
HEX (DecimalNumber ) //转十六进制
注：HEX()中可传入字符串，则返回其ASC-11码，如HEX(’DEF’)返回4142143
也可以传入十进制整数，返回其十六进制编码，如HEX(25)返回19
LEAST (number , number2 [,..]) //求最小值
MOD (numerator ,denominator ) //求余
POWER (number ,power ) //求指数
RAND([seed]) //随机数
ROUND (number [,decimals ]) //四舍五入,decimals为小数位数]

注：返回类型并非均为整数，如：

(1)默认变为整形值
mysql> select round(1.23);
+————-+
| round(1.23) |
+————-+
|           1 |
+————-+
1 row in set (0.00 sec)

mysql> select round(1.56);
+————-+
| round(1.56) |
+————-+
|           2 |
+————-+
1 row in set (0.00 sec)

(2)可以设定小数位数，返回浮点型数据

mysql> select round(1.567,2);
+—————-+
| round(1.567,2) |
+—————-+
|           1.57 |
+—————-+
1 row in set (0.00 sec)

SIGN (number2 ) //返回符号,正负或0
SQRT(number2) //开平方

三、日期类型

ADDTIME (date2 ,time_interval ) //将time_interval加到date2
CONVERT_TZ (datetime2 ,fromTZ ,toTZ ) //转换时区
CURRENT_DATE ( ) //当前日期
CURRENT_TIME ( ) //当前时间
CURRENT_TIMESTAMP ( ) //当前时间戳
DATE (datetime ) //返回datetime的日期部分
DATE_ADD (date2 , INTERVAL d_value d_type ) //在date2中加上日期或时间
DATE_FORMAT (datetime ,FormatCodes ) //使用formatcodes格式显示datetime
DATE_SUB (date2 , INTERVAL d_value d_type ) //在date2上减去一个时间
DATEDIFF (date1 ,date2 ) //两个日期差
DAY (date ) //返回日期的天
DAYNAME (date ) //英文星期
DAYOFWEEK (date ) //星期(1-7) ,1为星期天
DAYOFYEAR (date ) //一年中的第几天
EXTRACT (interval_name FROM date ) //从date中提取日期的指定部分
MAKEDATE (year ,day ) //给出年及年中的第几天,生成日期串
MAKETIME (hour ,minute ,second ) //生成时间串
MONTHNAME (date ) //英文月份名
NOW ( ) //当前时间+日期
SEC_TO_TIME (seconds ) //秒数转成时间
STR_TO_DATE (string ,format ) //字串转成时间,以format格式显示
TIMEDIFF (datetime1 ,datetime2 ) //两个时间差
TIME_TO_SEC (time ) //时间转秒数]
WEEK (date_time [,start_of_week ]) //第几周
YEAR (datetime ) //年份
DAYOFMONTH(datetime) //月的第几天
HOUR(datetime) //小时
LAST_DAY(date) //date的月的最后日期
MICROSECOND(datetime) //微秒
MONTH(datetime) //月
MINUTE(datetime) //分

注：可用在INTERVAL中的类型：DAY ,DAY_HOUR ,DAY_MINUTE ,DAY_SECOND ,HOUR ,HOUR_MINUTE ,HOUR_SECOND ,MINUTE ,MINUTE_SECOND,MONTH ,SECOND ,YEAR
DECLARE variable_name [,variable_name...] datatype [DEFAULT value]; 
其中，datatype为mysql的数据类型，如:INT, FLOAT, DATE, VARCHAR(length)

例：

DECLARE l_int INT unsigned default 4000000; 
DECLARE l_numeric NUMERIC(8,2) DEFAULT 9.95; 
DECLARE l_date DATE DEFAULT '1999-12-31'; 
DECLARE l_datetime DATETIME DEFAULT '1999-12-31 23:59:59';
DECLARE l_varchar VARCHAR(255) DEFAULT 'This will not be padded';






CREATE PROCEDURE developer_count  
2.(  
3.  searchType int,  
4.    startTime varchar(64),  
5.    endTime varchar(64)  
6.)  
7.BEGIN  
8.    /*定义变量天数*/  
9.  declare day_num int;  
10.  
11.  if searchType = 1 then   
12.  /*本周数据查询*/  
13.   select count(d.acct_id),d.acct_old_time from developer d where  1=1 and DATE_SUB(CURDATE(), INTERVAL 7 DAY) <= date(d.acct_old_time) GROUP BY d.acct_old_time;  
14.    end if;  
15.  if searchType = 2 then  
16.    /*本月数据查询*/  
17.        select count(d.acct_id),d.acct_old_time from developer d where  1=1 and DATE_SUB(CURDATE(), INTERVAL 30 DAY) <= date(d.acct_old_time) GROUP BY d.acct_old_time;  
18.  end if;  
19.  if searchType = 3 then  
20.    /*最近三个月数据查询*/  
21.        select count(d.acct_id), DATE_FORMAT(d.acct_old_time,'%x年-第%v周') as weeks from developer d where  1=1 and DATE_SUB(CURDATE(), INTERVAL 90 DAY) <= date(d.acct_old_time) GROUP BY weeks;  
22.  end if;  
23.  if searchType = 4 then  
24.    /*按月份进行数据统计*/  
25.        select datediff(startTime, endTime) into day_num;  
26.        if day_num <=7 then  
27.                select count(d.acct_id),d.acct_old_time from developer d where  1=1 and DATE_SUB(CURDATE(), INTERVAL day_num DAY) <= date(d.acct_old_time) GROUP BY d.acct_old_time;  
28.        end if;  
29.        if day_num >7  && day_num <= 30 then  
30.                select count(d.acct_id),d.acct_old_time from developer d where  1=1 and DATE_SUB(CURDATE(), INTERVAL day_num DAY) <= date(d.acct_old_time) GROUP BY d.acct_old_time;  
31.        end if;  
32.        if day_num >30 && day_num <= 90 then  
33.                select count(d.acct_id), DATE_FORMAT(d.acct_old_time,'%x年-第%v周') as weeks from developer d where  1=1 and DATE_SUB(CURDATE(), INTERVAL day_num DAY) <= date(d.acct_old_time) GROUP BY weeks;  
34.        end if;       
35.    end if;  
36.  
37.end;  
