MySQL 触发器简单实例 

~~语法~~

CREATE TRIGGER <触发器名称>  --触发器必须有名字，最多64个字符，可能后面会附有分隔符.它和MySQL中其他对象的命名方式基本相象.
{ BEFORE | AFTER }  --触发器有执行的时间设置：可以设置为事件发生前或后。
{ INSERT | UPDATE | DELETE }  --同样也能设定触发的事件：它们可以在执行insert、update或delete的过程中触发。
ON <表名称>  --触发器是属于某一个表的:当在这个表上执行插入、 更新或删除操作的时候就导致触发器的激活. 我们不能给同一张表的同一个事件安排两个触发器。
FOR EACH ROW  --触发器的执行间隔：FOR EACH ROW子句通知触发器 每隔一行执行一次动作，而不是对整个表执行一次。
<触发器SQL语句>  --触发器包含所要触发的SQL语句：这里的语句可以是任何合法的语句， 包括复合语句，但是这里的语句受的限制和函数的一样。

--你必须拥有相当大的权限才能创建触发器（CREATE TRIGGER），如果你已经是Root用户，那么就足够了。这跟SQL的标准有所不同。
~~实例~~

example1:

创建表tab1


DROP TABLE IF EXISTS tab1;

CREATE TABLE tab1(

    tab1_id varchar(11)

); 


创建表tab2


DROP TABLE IF EXISTS tab2;

CREATE TABLE tab2(

    tab2_id varchar(11)

); 



创建触发器:t_afterinsert_on_tab1

作用：增加tab1表记录后自动将记录增加到tab2表中



DROP TRIGGER IF EXISTS t_afterinsert_on_tab1;

CREATE TRIGGER t_afterinsert_on_tab1 

AFTER INSERT ON tab1

FOR EACH ROW

BEGIN

     insert into tab2(tab2_id) values(new.tab1_id);

END; 


测试一下



INSERT INTO tab1(tab1_id) values('0001'); 


看看结果

SELECT * FROM tab1;

SELECT * FROM tab2; 


example2:

创建触发器:t_afterdelete_on_tab1

作用：删除tab1表记录后自动将tab2表中对应的记录删去


DROP TRIGGER IF EXISTS t_afterdelete_on_tab1;

CREATE TRIGGER t_afterdelete_on_tab1

AFTER DELETE ON tab1

FOR EACH ROW

BEGIN

      delete from tab2 where tab2_id=old.tab1_id;

END; 


测试一下

DELETE FROM tab1 WHERE tab1_id='0001'; 

看看结果

SELECT * FROM tab1;

SELECT * FROM tab2; 
