ssh itv002658@g01.itversity.com
itv002658
qo3pz5rpyl6zv4r6t1padw7jt1n5i43v

# Hive Default:
/user/hive/warehouse

# My local
/home/itv002658/hivedata
/home/itv002658/retail_db

# My HDFS
/user/itv002658/warehouse
/user/itv002658/hivetemp
/user/itv002658/trainings
/user/itv002658/retail_db

# Public local
/data/retail_db

# Public HDFS
/public/retail_db
/public/hr_db
/public/crime  


  hive.metastore.warehouse.dir=/user/itv002658/warehouse; 
SET hive.metastore.warehouse.dir;
set hiveconf:hive.cli.print.current.db=true;
set hive.cli.print.hearder = true;

set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mod=nonstrict;

set hive.enforce.bucketing = true;
set hive.exec.dynamic.partition.mode=nonstrict;

set hive.execution.engine = tez;

set hive.auto.convert.join=true
set hive.mapjoin.smalltable.filesize;

set hive.variable.substitute=true;



create database if not exists d1;

describe database d1;

create database if not exists d2 comment 'this is a database';

describe database extended d2;

create database if not existis d8 with dbproperties('creator'='vijay', 'date'='2022-05-12');

describe database extended d8;
 
show databases;
insert
---- Create Table external

-- Internal Table (use external when external)

  
  table if not exists table5 (col1 string, col2 array<string>, col3 string, col4 int) 
row format delimited 
fields terminated by ',' 
collection items terminated by ':' 
lines terminated by '\n' stored as textfile;

SET hive.metastore.warehouse.dir=/user/itv002658/warehouse; 

create table if not exists table6 (col1 string, col2 array<string>, col3 string, col4 int) 
row format delimited fields terminated by ',' 
collection items terminated by ';' 
lines terminated by '\n' 
stored as textfile location '/user/itv002658/hivetemp';

load data local inpath '/home/itv002658/hivedata/table6.txt' into table table6; -- 'into' will append if any data is there
or 
load data local inpath '/home/itv002658/hivedata/table6.txt' overwrite table table6; -- 'overwrite' will overwrite if there is any data

describe table6;
desc formatted table6;

>> hdfs dfs -cat /user/itv002658/hivetemp/table6.txt

======================Create table from other table===============

>> create table tab (col1 int, col2 string, col3 string) stored as text file;
>> insert into table tab select col1, col2, col3 from emp_tab;

-- 'into' command appends data, 'overwrite' command overwrites data, as delete and load

================================Multi insert statements====================================


-- that means inserting in to multiple table in one statement

create table developer_tab (id int,name string,desg string) stored as textfile;

create table manager_tab (id int,name string,desg string) stored as textfile;

from emp_tab insert into table developer_tab select col1,col2,col3 where col3 ='Developer' insert into table manager_tab select col1,col2,col3 where col3='Mgr';

=========================================== Miscilanious ================================================

create table if not exists table8 (col1 string, col2 array<string>, col3 string, col4 int) 
row format delimited 
fields terminated by ',' 
collection items terminated by ':' 
lines terminated by '\n' 
stored as textfile;

load data local inpath '/home/itv002658/hivedata/table6.txt' into table table8;

>> hdfs dfs -cat /user/itv002658/warehouse/d8.db/table9/table6.txt

create external table if not exists exttable9 (col1 string, col2 array<string>, col3 string, col4 int) 
row format delimited fields terminated by ',' collection items terminated by ':' lines terminated by '\n' stored as textfile;

load data local inpath '/home/itv002658/hivedata/table6.txt' into table exttable9;

---- Assignment

1. Study the structure of data then use create statement to create a table with necessary number of columns.

2. Load the data into table.

3. View data in tables after loading.

You can also create 1 more table and practice Insert command by loading data into it from previous table.

Questions for this assignment
Can I create a table with less number of columns than dataset?

-----Table Properties

create table tab1 (col1 int, col2 string, col3 string) stored as textfile tbleproperties("skip.header.line.count"="3");


==================================== Alter Table or Columns ==============================

alter table tab add columns(col4 string, col5 int);
alter table tab change column col1 col1 int after col3;
alter table tab change column col2 new_col2 string;

alter table tab rename to tab1;

alter table tab1 replace columns(id int, name string);

alter table tab1 set tblproperties('auto.purge'='true');
alter table tab1 set fileformat avro;

alter table tab1 enable no_drop; -- To enable no drop on table
drop table emp_tab;

alter table tab1 disable no_drop; -- To diable no drop 

alter table part_dept partition(deptname='HR') enable no_drop; -- To enable no drop on partitioin
alter table part_dept drop partition(deptname='HR'); -- test the drop parition

alter table part_dept partition(deptname='HR') disable no_drop; -- To diable drop partition 
alter table part_dept drop partition(deptname='HR'); -- test the drop parition

alter table dept enable offline; -- to enable offline feature
select * from dept -- you wil get an error

alter table dept enable offline; -- to disable offline feature
select * from dept -- you wil get an error


alter table part_dept partition(deptname='HR') enable offline; -- To enable offline on partitioin
select * from part_dept where deptname='HR' -- TO test the offline feature on HR department paritions

alter table part_dept partition(deptname='HR') disable offline; -- To enable offline on partitioin
select * from part_dept where deptname='HR' -- TO test the offline feature on HR department paritions

------------order by-----------------
select col2 from table5 order by col2 < limit 5 > ; -- this will use only one reducer and work efficiantly
------------sort by------------------
select col2 from table5 sort by col2 < limit 5 > ; -- this will use only multiple reduceser which is not good, also each reduces will produce its own output which is incorrent

----------distribute by -------------
--This used multiple reducers but combined with sort by produce incorrect sort result, it needs to be combined with alwasys order by
select col2 from table5 distribute by col2 sort by col2;
select col2 from table5 distribute by col2 order by  by col2; -- correct one

------------clustur by---------
--its a short form of 'distribute by + sort by' command, combination of distribute by and sort by 
select col2 from table5 cluster by col2;


---########################## Partitions #############################
/home/itv002658/hivedata
/home/itv002658/warehouse
SET hive.metastore.warehouse.dir=/user/itv002658/warehouse; 
SET hive.metastore.warehouse.dir;
set hiveconf:hive.cli.print.current.db=true;
set hive.cli.print.hearder = true;

--Non partitioned table
create table if not exists dept (col1 int,col2 string,col3 string,col4 int) row format delimited fields terminated by',' lines terminated by'\n'stored as textfile;
load data local inpath '/home/itv002658/hivedata/dept.txt' into table dept ;



--Partitioned table creation
create table if not exists part_dept (deptno int,empname string,sal int) partitioned by (deptname string) row format delimited fields terminated by',' lines terminated by'\n'stored as textfile;
insert into table part_dept partition (deptname = 'HR') select col1,col3,col4 from dept where col2 = 'HR'; 
   
--Static partitioning Loads two types
insert into table part_dept partition (deptname = 'HR') select col1,col3,col4 from dept where col2 = 'HR'; 
load data local inpath'/home/jivesh/act'into table part_tab partition( deptname ='XZ');

show partitions part_dept1

-----Dynamic partition

--Partitioned table creation, same as static partitioning
create table if not exists part_dynm_dept1 (deptno int,empname string,sal int) partitioned by (deptname string) 
row format delimited fields terminated by',' lines terminated by'\n'stored as textfile;

-- These parameters need to be set
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mod=nonstrict;

--Dynamic partitioning Load
load data local inpath '/home/itv002658/hivedata/dept.txt' into table part_dynm_dept1 partition( deptname);
insert into table part_dept1 partition (deptname) select col1,col3,col4,col2 from dept; 

show partitions part_dept1

----------Alter Partitions

--Drop partition
alter table part_dept1 drop partition (deptname = 'HR');

--Add partition
alter table part_dept1 add partition (deptname = 'Dev');
load data local inpath'/home/jivesh/dev'into table part_dept1 partition( deptname ='Dev');
show partitions part_dept1

--If you have added any new partition file at HDFS like "deptname='Prod'", then we have to refresh the hive metadata to include in partitions
msck repair table part_dept1;



---########################## Joins #############################

set hive.auto.convert.join=true
set hive.mapjoin.smalltable.filesize;

--Map Join (inner, left and right outer possible, but full outer is not possible, I mean deniately reducer will come in to picture for full outer)
select /*+ MAPJOIN (emp_tab) */ emp_tab.col1, emp_tab.col2, dept_tab.col2 from emp_tab join dept_tab on (emp_tab.col6=dept_tab.col1);

-- Bucketed MAP joins -----------
set hive.input.format=org.apache.hadoop.hive.ql.io.BucketizedHiveInputFormat;
set hive.optimize.bucketmapjoin=true;
set hive.auto.convert.sortmerge.join=true;
set hive.optimize.bucketmapjoin.sortedmerge=true;



-- ################ Hive queries in Linux vs Hive cli ##########

>> vi /home/itv002658/test.hql
select * from d8.dept limit 6;

-- From Linux CLI

hive -f /home/itv002658/test.hql
hive -e 'select * from d8.dept limit 10;'

hive --hiveconf deptno=20 -e 'select * from emp where dept_no=${hiveconf:deptno}
hive --hivevar deptno=10 --hiveconf tablename=emp_tab -e 'select * from ${hiveconf:tablename} where dept_no={deptno}
hive --hivevar empid=col1 --hiveconf tablename=emp_tab --hivevar deptno=10 -f /home/itv002658/jj.hql


hive -h --This is for help

--- From Hive CLI
source /home/itv002658/test.hql;