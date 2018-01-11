
//java日期转换
SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
Date date = simpleDateFormat.parse("2017-16-07 16:22:02");
String dt = simpleDateFormat.format(date);
System.out.println(dt);




sleep和wait的区别有： 
1，这两个方法来自不同的类分别是Thread和Object 
2，最主要是sleep方法没有释放锁，而wait方法释放了锁，使得敏感词线程可以使用同步控制块或者方法。 
3，wait，notify和notifyAll只能在同步控制方法或者同步控制块里面使用，而sleep可以在 任何地方使用 synchronized(x){ x.notify() //或者wait() } 
4,sleep必须捕获异常，而wait，notify和notifyAll不需要捕获异常


数据库隔离级别：
（一）可读取未确认（Read uncommitted）
写事务阻止其他写事务，避免了更新遗失。但是没有阻止其他读事务。 
存在的问题：脏读。即读取到不正确的数据，因为另一个事务可能还没提交最终数据，这个读事务就读取了中途的数据，这个数据可能是不正确的。 
解决办法就是下面的“可读取确认”。
（二）可读取确认（Read committed）
写事务会阻止其他读写事务。读事务不会阻止其他任何事务。 
存在的问题：不可重复读。即在一次事务之间，进行了两次读取，但是结果不一样，可能第一次id为1的人叫“李三”，第二次读id为1的人就叫了“李四”。因为读取操作不会阻止其他事务。 
解决办法就是下面的“可重复读”。
（三）可重复读（Repeatable read）
读事务会阻止其他写事务，但是不会阻止其他读事务。 
存在的问题：幻读。可重复读阻止的写事务包括update和delete（只给存在的表加上了锁），但是不包括insert（新行不存在，所以没有办法加锁），所以一个事务第一次读取可能读取到了10条记录，但是第二次可能读取到11条，这就是幻读。 
解决办法就是下面的“串行化”。
（四）可串行化（Serializable）
读加共享锁，写加排他锁。这样读取事务可以并发，但是读写，写写事务之间都是互斥的，基本上就是一个个执行事务，所以叫串行化


strtus2执行流程：
1、浏览器发送请求，经过一系列的过滤器后，到达核心过滤器(StrutsPrepareAndExecuteFilter).
2、StrutsPrepareAndExecuteFilter通过ActionMapper判断当前的请求是否需要某个Action处理,如果不需要，则走原来的流程。如果需要则把请求交给ActionProxy来处理
3、ActionProxy通过Configuration Manager询问框架的配置文件(Struts.xml)，找到需要调用的Action类；
4、创建一个ActionInvocation实例，来调用Action的对应方法来获取结果集的name,在调用前后会执行相关拦截器。
通过结果集的Name知道对应的结果集来对浏览器进行响应。




