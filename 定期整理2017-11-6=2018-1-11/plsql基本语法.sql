PLSQL基本语法



–使用plsql输出hello world

declare
  begin   
  dbms_output.put_line('Hello World');
 end;


–定义记录型变量

set serveroutput on;
declare
  --定义记录型变量
  emp_rec emp%rowtype;
  begin
    select * into emp_rec from emp where empno='7839';
    dbms_output.put_line(emp_rec.ename||'的职位是'||emp_rec.job);
  end;


–if语句:判断用户输入的数字

set serveroutput on;
  /**
    1.弹出提示信息
    2.num接收一个数据地址
  */
  accept num prompt '请输入一个数字';
  declare
    pnum number := &num;
  begin
    if pnum = 0 then
      dbms_output.put_line('您输入的数字是0');
    elsif pnum = 1 then
      dbms_output.put_line('您输入的数字是1');
    elsif pnum = 2 then
      dbms_output.put_line('您输入的数字是2');
    else
      dbms_output.put_line('您输入的是其他数字');
    end if;
  end;
  /


–循环：打印1~10

set serveroutput on;
declare
  pnum number := 1;
  begin
    loop
    --退出 满足条件退出
      exit when pnum >10;
      dbms_output.put_line(pnum);
      pnum :=pnum+1;
    end loop;
  end;1


–光标

光标的属性： 
 %isopen 是否被打开 
 %rowcount 行数 
 %notfound 是否有值

set serveroutput on
declare
  --光标
  cursor cemp is select ename,sal from emp;
  pename emp.ename%type;
  psal   emp.sal%type;
begin
  open cemp;
  loop
    --从集合中取值
    fetch cemp into pename,psal;
    --****
    exit when cemp%notfound;
    dbms_output.put_line(pename||'的薪水是'||psal);
  end loop;
  close cemp;
end;
/


带参数的光标

--带参数的光标：打印出某个部门的员工姓名
set serveroutput on;
declare 
  --带参数的光标
  cursor cemp(dpno number) is select ename from emp where deptno = dpno;
  --定义参数类型
  pename emp.ename%type;
  begin
    --打开光标
    open cemp(10);
    loop
      fetch cemp into pename;
      exit when cemp%notfound;
      dbms_output.put_line(pename);
    end loop;
    close cemp;
  end;1


光标练习 
 –光标练习:涨工资–>为persident涨1000,manager 涨800 其他员工涨600

--job在plsql中是关键字，因此给emp表中的job改名为 empjob
alter table emp rename column job to empjob;
declare
  --定义游标
  cursor cemp is select empno,empjob from emp;
  --定义变量名及类型
  pempno emp.empno%type;
  pempjob emp.empjob%type;
  begin
    open cemp;
      loop
        fetch cemp into pempno,pempjob;
        exit when cemp%notfound;
        if pempjob='PRESIDENT' then
          --执行update语句
          update emp set sal = sal+1000 where empno = pempno;
        elsif pempjob='MANAGER' then
          update emp set sal = sal+800 where empno = pempno;
        else
          update emp set sal = sal+600 where empno = pempno;
        end if;
      end loop;
    close cemp;
  end;1


统计1 
 –统计每年入职的员工人数。

/*
  可能用到的sql
  select to_char(hiredate,'yyyy') from emp;
*/
set serveroutput on;
declare
  cursor cemp is select to_char(hiredate,'yyyy'),ename from emp;
  phiredate varchar2(4);
  ptotal number;
  pename emp.ename%type;
  --计数器
  num80 number :=0;
  num81 number :=0;
  num82 number :=0;
  num87 number :=0;
  begin
    select count(*) into ptotal from emp;
    open cemp;
      loop
        fetch cemp into phiredate,pename;
        exit when cemp%notfound;
          if phiredate='1980' then num80 := num80+1;
            elsif phiredate='1981' then num81 := num81+1;
            elsif phiredate='1982' then num82 := num82+1;
            elsif phiredate='1987' then num87 := num87+1;
          end if;
      end loop;
        dbms_output.put_line('总共的员工有:'||ptotal);
        dbms_output.put_line('1980年入职的员工有:'||num80);
        dbms_output.put_line('1981年入职的员工有:'||num81);
        dbms_output.put_line('1982年入职的员工有:'||num82);
        dbms_output.put_line('1987年入职的员工有:'||num87);
    close cemp;
  end;1



统计2 
 为员工涨工资。从最低工资调起每个人涨10%，但是工资总额不能超过5万元， 
 请计算涨工资的人数和涨工资后的工资总额，并输出涨工资人数和工资总额。 
 按工资升序排序 
 select empno,sal from emp order by sal; 
 涨工资后与5万元进行比较。

declare
  cursor cemp is select empno,sal from emp order by sal;
  pempno emp.empno%type;
  psal emp.sal%type;
  psum number;
  ppersonnum number :=0;
  begin
    select sum(sal) into psum from emp;
    open cemp;
      loop
        --金额大于50000时候结束
        exit when psum >50000;
        fetch cemp into pempno,psal;
        --查找不到下一个时候结束
        exit when cemp%notfound;
        --最后一个涨工资后超过5w结束
        exit when psum + psal*0.1>50000;
        --涨工资
        update emp set sal = sal+sal*0.1 where empno = pempno;
        --统计涨工资人数
        ppersonnum:= ppersonnum+1;
        --统计工资总额
        psum := psum + psal*0.1;
      end loop;
    close cemp;
    dbms_output.put_line('工资总额:'||psum);
    dbms_output.put_line('涨工资人数:'||ppersonnum);
  end;1


例外（异常） 
 –例外：roacle的异常处理

set serveroutput on;
declare 
  pnum number;
  begin
    pnum:=1/0;
    exception
      --除0例外
      when Zero_Divide then dbms_output.put_line('1:0不能做被除数');
      --参数错误
      when Value_error then dbms_output.put_line('算输错');
      when others then dbms_output.put_line('其他例外');
  end;1


自定义例外（异常） 
 –自定义例外:查询50员工部门的姓名。

set serveroutput on;
declare
  cursor cemp is select ename from emp where deptno=50;
  pename emp.ename%type;
  --定义异常
  No_Data exception;
  begin
    open cemp;
      fetch cemp into pename;
      if cemp%notfound then raise No_Data; 
      end if;
    close cemp;
    exception 
      when No_Data then 
        dbms_output.put_line('没有找到员工');
        --处理异常并关闭光标
        if cemp%isopen then 
        dbms_output.put_line('关闭光标');
        close cemp;
        end if;
      when others then dbms_output.put_line('其他例外');
  end;1


例子 
 用PLSQL语言比那些一程序，实现部门分段（6000以上、（6000,3000）、3000以下） 
 统计个工资端的员工人数、以及各部门的工资总额（不包括奖金） 
 员工人数、各部门工资总额 
 –部门号 
 select deptno from dept; 
 –工资 
 select sal from emp where deptno = dpno; 
 –各部门员工人数 
 select count(*) where deptno = dpno; 
 –查找相同部门号 
 – select deptno into empdeptno from emp; 
 –如果是相同部门，就去执行统计操作 
 –统计总金额 
 select sum(sal) into tsalsum from emp where deptno = dpno; 
 –统计总人数 
 select count(*) into tpersonsum from emp where deptno = dpno; 
 –统计6k以上人数 
 select count(*) into tpersonsum from emp where deptno = dpno;

--创建表
drop table emp_total;
create table emp_total(deptno number,sixkup number,tktsk number,tkdown number,salsum number,personnum number);
declare
  cursor cemp is select deptno from dept;
  cursor csal(dno number) is select sal from emp where deptno = dno;
  --部门号
  dpno DEPT.DEPTNO%type;
  tsalnum emp.sal%type;
  sknum number :=0;
  tknum number :=0;
  dknum number :=0;
  tpersonnum number:=0;
  totalsum number :=0;

  begin
  open cemp;
    loop
      fetch cemp into dpno;
      exit when cemp%notfound;
        open csal(dpno);
          loop
            fetch csal into tsalnum;
            exit when csal%notfound;
              totalsum := totalsum + tsalnum;
              tpersonnum := tpersonnum+1;
              if tsalnum >6000 then sknum := sknum+1;
              elsif tsalnum <3000 then dknum := dknum+1;
              else tknum := tknum+1;
              end if;
          end loop;
          insert  into emp_total(deptno,sixkup,tktsk,tkdown,salsum,personnum) values(dpno,sknum,tknum,dknum,totalsum,tpersonnum);
        close csal;
    end loop;
  close cemp;
  end;1


