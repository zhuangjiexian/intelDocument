定义存储过程：

　　create proc usp_StudentByGenderAge

　　@gender nvarchar(10) [='男'],

　　@age int [=30]

　　as

　　select * from MyStudent where FGender=@gender and FAge=@age

 

　　执行存储过程：

　　Situation One(调用默认的参数):

　　exec usp_StudentByGenderAge

　　Situation Two(调用自己指定的参数):

　　exec usp_StudentByGenderAge '女',50

　　或者指定变量名        exec usp_StudentByGenderAge @age=50,@gender='女'

 

　　对存储过程进行修改

　　alter proc usp_StudentByGenderAge

　　@gender nvarchar(10) [='男'],

　　@age int [=30],

　　--加output表示该参数是需要在存储过程中赋值并返回的

　　@recorderCount int output 

　　as

　　select * from MyStudent where FGender=@gender and FAge=@age

　　set @recorderCount=(select count(*) from MyStudent where FGender=@gender and FAge=@age)

 

--output参数的目的，就是调用者需要传递一个变量进来，然后在存储过程中为该变量完成赋值工作，存储过程执行完成以后，将执行的对应结果返回给传递进来的变量。(与C#中的out原理一模一样)

 

调用(记住这里的语法！)因为该存储过程前面还有其他参数，所以要把 @recorderCount写上，该存储过程执行后，相当与完成了以上的查询工作，同时将查询结果得到的条数赋值给了@count变量。(@count是当做参数传给usp_StudentByGenderAge，当存储过程执行完毕以后，将得到的条数返回给@count)

　　declare @count int

　　exec usp_StudentByGenderAge @recorderCount=@count output

　　print @count

 

五、使用存储过程完成分页

1、存储过程代码

 　  create proc usp_page

　　@page int,          ---一页显示多少条记录

 　  @number int,   ---用户选择了第几页数据

      as

 　　begin

 　　select * from

 　　--小括号里面内容是专门得到排列好的序号

 　　(

 　　　　select  ROW_NUMBER() over(order by(Fid))  as number

 　　　　from MyStudent

 　　) as t

 　　where t.number>= (@number-1)*@page+1 and t.number<=@number*@page

　　 end
