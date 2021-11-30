use People;
# 1
create table People(pesel varchar(11),
                    name varchar(30),
                    surname varchar(30),
                    birth date,
                    sex enum('M', 'W'),
                    primary key (pesel));

create table Jobs(  job_id int unsigned auto_increment,
                    title varchar(30),
                    salaryMin float unsigned,
                    salaryMax float unsigned,
                    primary key (job_id));

create table Workers(   pesel varchar(11),
                        job_id int unsigned,
                        salary float unsigned,
                        foreign key (pesel) references People(pesel),
                        foreign key (job_id) references Jobs(job_id));

CREATE TRIGGER salaryCheck BEFORE INSERT ON Jobs
    FOR EACH ROW
    BEGIN IF salaryMin < 0 or salaryMax < 0 or salaryMin > salaryMax
        THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid state!';
    END IF;
END;

CREATE TRIGGER peselCheck BEFORE INSERT ON People
    FOR EACH ROW
    BEGIN IF new.pesel not REGEXP '^[0-9]*$'
        THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid state!';
    END IF;
END;

CREATE TRIGGER doctorsCheck BEFORE INSERT ON Workers
    FOR EACH ROW
    BEGIN IF new.job_id=3 and (select year(curdate()) - (select year(birth) from People join Workers W on People.pesel = W.pesel)) > if((select count(true) from People join Workers W on People.pesel = W.pesel where w.pesel='77011212345' and sex='W') > 0, 60, 65)
        THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid state!';
    END IF;
END;


insert into People(pesel, name, surname, birth, sex)
values
('10010112345', 'a', 'b', 20100101, 'W'),
('12010212345', 'qsda', 'sdas', 20120102, 'M'),
('11030312345', 'hfd', 'xcvvas', 20110303, 'W'),
('08050612345', 'jfg', 'asdq', 20080506, 'M'),
('09080712345', 'ty', 'asvsa', 20090807, 'W'),
    ('99080712345', 'nbfd', 'asfqwq', 19990807, 'W'),
    ('99100712345', 'vaacas', 'b', 19991007, 'W'),
    ('90122312345', 'nsfd', 'casca', 19901223, 'W'),
    ('90122512345', 'asdr', 'bacas', 19901225, 'W'),
    ('90011012345', 'hsd', 'wqr', 19900110, 'M'),
    ('83050112345', 'awfq', 'vbnse', 19830501, 'W'),
    ('83080512345', 'gasf', 'urwe', 19830805, 'M'),
    ('85111512345', 'hggf', 'ytu6', 19851115, 'M'),
    ('85101112345', 'lkujh', 'rtyey', 19851011, 'M'),
    ('80113012345', 'fdg', 'reyh', 19801130, 'M'),
    ('80012112345', 'kmk', 'hehge', 19800121, 'M'),
    ('80122212345', 'nf', 'twe', 19801222, 'W'),
    ('80031412345', 'afhd', 'g', 19800314, 'W'),
    ('80070112345', 'gfg', 'ewr', 19800701, 'W'),
    ('70070112345', 'asfa', 'gwqq', 19700701, 'M'),
    ('70110412345', 'asfa', 'rtwe', 19701104, 'M'),
    ('55121112345', 'asdfa', 'here', 19551211, 'W'),
    ('55111512345', 'ggbas', 'rtu', 19551115, 'W'),
    ('77121112345', 'gasw', 'ntyur', 19771211, 'M'),
    ('77041412345', 'asf', 'eryrey', 19791005, 'M'),
    ('89010412345', 'hbfd', 'wetewt', 19890104, 'M'),
    ('83022612345', 'dvskmn', 'ewtew', 19830226, 'M'),
    ('91040912345', 'hyka', 'qwee', 19910409, 'W'),
    ('95042612345', 'bva', 'erwtwe', 19950426, 'W'),
    ('93042712345', 'sdfafs', 'wgq', 19930427, 'W'),
    ('69021812345', 'sbas', 'gjwe', 19690218, 'W'),
    ('98031612345', 'hffgy', 'yeeww', 19980316, 'M'),
    ('88043012345', 'smnd', 'herye', 19880430, 'W'),
    ('87052312345', 'sgd', 'hr5yew', 19870523, 'W'),
    ('84062112345', 'sdgsd', 'sdtwe', 19840621, 'M'),
    ('85071112345', 'sdgs', 'tryr', 19850711, 'W'),
    ('82060112345', 'jfdr', 'erw4r', 19820601, 'W'),
    ('71112512345', 'dydf', 'vasda', 19711125, 'W'),
    ('77122412345', 'msdf', 'jrtyr', 19771224, 'W'),
    ('62101112345', 'hsd', 'ntye', 19621011, 'W'),
    ('63032312345', 'ndyhdf', 'rete', 19630323, 'M'),
    ('72012212345', 'hhsd', 'nwss', 19720122, 'W'),
    ('78083112345', 'art', 'awa', 19780831, 'W'),
    ('73013112345', 'bher', 'nd', 19730131, 'W'),
    ('74091112345', 'asfb', 'afew', 19740911, 'W'),
    ('71072112345', 'fasca', 'fbd', 19710721, 'W'),
    ('77011212345', 'asrw', 'asqwe', 19770112, 'M'),
        ('38083012345', 'dsf', 'awq', 19380830, 'M'),
        ('46042812345', 'asrw', 'eujo', 19460428, 'M'),
        ('47062512345', 'adassd', 'asda', 19470625, 'W'),
        ('37110312345', 'ada', 'asqcasdwe', 19371103, 'W'),
        ('51121612345', 'vsa', 'tyww', 19511216, 'M');


insert into Jobs(title, salaryMin, salaryMax)
values
('Politician', 36000, 60000),
('Teacher', 11550, 43800),
('Doctor', 19590, 90000),
('Programmer', 12000, 44500);

insert into Workers(pesel, job_id, salary)
values
('77011212345', 1, 42000),
('63032312345', 1, 54000),
('71072112345', 2, 12000),
('74091112345', 2, 32000),
('73013112345', 3, 27000),
('78083112345', 3, 83100),
('72012212345', 4, 42000),
('62101112345', 4, 37000),
('77122412345', 1, 55000),
('71112512345', 1, 44000),
('82060112345', 1, 56000),
('85071112345', 2, 35000),
('84062112345', 2, 42000),
('87052312345', 2, 14000),
('88043012345', 2, 15000),
('98031612345', 2, 16000),
('69021812345', 2, 24000),
('93042712345', 2, 27000),
('95042612345', 2, 34000),
('91040912345', 2, 21000),
('83022612345', 3, 23000),
('89010412345', 3, 76000),
('77041412345', 3, 42000),
('55111512345', 3, 53000),
('55121112345', 3, 61000),
('70110412345', 3, 57000),
('70070112345', 3, 37000),
('80070112345', 3, 38000),
('80031412345', 3, 67000),
('80122212345', 3, 25000),
('80012112345', 4, 37000),
('80113012345', 4, 23000),
('85101112345', 4, 16000),
('85111512345', 4, 17000),
('83080512345', 4, 26000),
('83050112345', 4, 29000),
('90011012345', 4, 31000),
('90122512345', 4, 33000),
('90122312345', 4, 37000),
('99100712345', 4, 41000),
('99080712345', 4, 43000),
('38083012345', 1, 35000),
('46042812345', 1, 56000),
('47062512345', 2, 34000),
('37110312345', 2, 39013),
('51121612345', 4, 25000);

# 2
create index idxSex on People(sex);
create index idxName on People(name);
create index idxSalary on Workers(salary);

show indexes from People;
show indexes from Workers;

select name from People where name like 'a%' and sex='W';
select name from People where sex='W';
select name from People where name like 'k%';
select name from People inner join Workers W on People.pesel = W.pesel where salary/12 < 2000;
select name from People inner join Workers W on People.pesel = W.pesel where salary/12*4 > 10000 and W.job_id = (select job_id from Jobs where title='Programmer') and sex='M';


# 3
create procedure salaryRise(in jobTitle varchar(70))
begin
    declare cnt int unsigned default 0;
    declare salaryOfMember int;
    declare risedSalary int;
#     declare jobTitleId int;

    declare salaryCur cursor for (select salary from Workers where job_id=(select job_id from Jobs where title=jobTitle));
#     set jobTitleId = (select job_id from Jobs where title=jobTitle);
    open salaryCur;

    start transaction;
    while cnt < (select count(*) from Workers where job_id=(select job_id from Jobs where title=jobTitle)) do
        fetch salaryCur into salaryOfMember;
        set risedSalary = salaryOfMember * 1.05;
        if risedSalary > (select salaryMax from Jobs where job_id=(select job_id from Jobs where title=jobTitle)) then
            rollback;
            select 'The max salary is reached!';
        end if;
        update Workers
        set
            salary=risedSalary
        where salary = salaryOfMember and job_id=(select job_id from Jobs where title=jobTitle);
        set cnt = cnt + 1;
    end while;

    close salaryCur;
    COMMIT;
    select 'Salary rised!';
end;
drop procedure salaryRise;
call salaryRise('Doctor');
select * from Workers;
# 4
prepare st from 'select count(*) from People P join Workers W on P.pesel = W.pesel inner join Jobs J on W.job_id = J.job_id where sex="W" and W.job_id=(select job_id from Jobs where title=?)';

set @job='Programmer';
execute st using @job;
deallocate prepare st;

select count(*) from People P join Workers W on P.pesel = W.pesel inner join Jobs J on W.job_id = J.job_id where sex='W' and W.job_id=(select job_id from Jobs where title='Programmer')

# 5
sudo mysqldump -u push -p People > People.sql;
drop database People;
mysql -u push -p People < People.sql
