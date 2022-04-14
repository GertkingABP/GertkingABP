/*1)Создаём БД без таблиц*/
create database testik;
use testik;
show databases;
show create database testik;

/*2)Создаём конкретные таблички*/

/*Группы студентов*/
create table groups_st (
	id_group int not null primary key auto_increment,
    title varchar(10) not null
);

/*Студенты, которые выполнили его*/
create table students (
	id_student int not null primary key auto_increment,
    full_name varchar(30) not null
);

/*Выполненные тесты*/
create table tests (
	id_test int not null primary key auto_increment,
	grade double not null,
    fk_id_student int not null,
    foreign key (fk_id_student) references students (id_student),
    fk_id_group int not null,
    foreign key (fk_id_group) references groups_st (id_group)
);

/*Многие ко многим про студента и группу*/
create table groups_st_to_students (
	fk_id_group int not null,
	fk_id_student int not null,
    primary key (fk_id_group, fk_id_student),
	foreign key (fk_id_group) references groups_st (id_group),
	foreign key (fk_id_student) references students (id_student)
);
	
 /*Многие ко многим для теста и студента*/   
create table students_to_tests(
	fk_id_student int not null,
    fk_id_test int not null,
    primary key (fk_id_student, fk_id_test),
    foreign key (fk_id_student) references students (id_student),
    foreign key (fk_id_test) references tests (id_test)
);

/*3)Добавление столбцов в таблицы и их заполнение*/

/*В tests*/
alter table tests
	add column date_start datetime not null,
    add column date_end datetime not null;
    
alter table students
	add column course tinyint not null;
    
alter table groups_st
	add column count_st tinyint not null;
    
/*4)Добавляем строки(кортежи) в таблицы*/
insert into students (full_name, course) 
values
('Иванов Иван Иванович', 2),
('Петров Иван Васильевич', 2),
('Козякин Андрей Дмитриевич', 2);

insert into groups_st (title, count_st) 
values
('ИВТ-263', 17),
('ПрИн-266', 19),
('ПрИн-267', 15);

insert into tests (grade, fk_id_student, fk_id_group, date_start, date_end) 
values
(3.97, 1, 1, '2022-01-15 15:32:03', '2022-01-15 15:53:52'),
(6.92, 2, 2, '2022-01-16 16:25:25', '2022-01-16 :16:32:06'),
(7.47, 3, 3, '2022-01-17 13:13:43', '2022-01-17 13:32:03');

insert into groups_st_to_students (fk_id_group, fk_id_student) 
values
(1, 1),
(2, 2),
(3, 3);

insert into students_to_tests (fk_id_test, fk_id_student) 
values
(1, 1),
(2, 2),
(3, 3);
