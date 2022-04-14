/*1)Создаём БД без таблиц*/

create database lorry_scr;/*сама БД*/
use lorry_scr;/*использование БД*/
show databases;/*отображение всех БД*/
show create database lorry_scr;/*отображение созданной БД*/

/*2)Таблицы данных*/

create table worker(/*работник*/
	id_worker int not null auto_increment primary key,
    full_name varchar(45) not null,
    phone_number varchar(12) not null
);

create table city(/*город*/
	id_city int not null auto_increment primary key,
    name_city varchar(45) not null
);

create table driver(/*водитель*/
	id_driver int not null auto_increment primary key,
    full_name_driver varchar(45) not null
    );
    
create table type_cargo(/*тип груза*/
	id_type_cargo int not null auto_increment primary key,
    name_type_cargo varchar(25) not null,
    factor_cargo double not null
    );
    
create table category(/*категория*/
	id_category int not null auto_increment primary key,
    name_category varchar(3) not null
    );

create table type_customer(/*тип заказчика*/
	id_type_customer int not null auto_increment primary key,
    name_type varchar(20) not null
    );
    
create table driver_to_category(/*многие ко многим для водителя и категории*/
	fk_id_driver int not null,
    fk_id_category int not null,
    primary key (fk_id_driver, fk_id_category),
    foreign key (fk_id_driver) references driver (id_driver),
    foreign key (fk_id_category) references category (id_category)
    );
    
create table customer(/*заказчик*/
	id_customer int not null auto_increment primary key,
    title varchar(45) not null,
    phone_number_c varchar(12) not null,
    fk_id_type_customer int not null,
    foreign key (fk_id_type_customer) references type_customer (id_type_customer)
    );

create table comment_c(/*комментарий заказчика*/
	id_comment int not null auto_increment primary key,
    text_c text not null,
    grade tinyint not null,
    fk_id_customer int not null,
    foreign key (fk_id_customer) references customer (id_customer)
    );
 
 create table truck(/*грузовик*/
	id_truck int not null auto_increment primary key,
    name_truck varchar(30) not null,
	number_sign varchar(10) not null,
    factor double not null,
    volume double not null,
    fk_id_category int not null,
    foreign key (fk_id_category) references category (id_category)
    );
    
create table truck_to_type_cargo(/*многие ко многим для грузовика и типа груза*/
	fk_id_truck int not null,
    fk_id_type_cargo int not null,
    primary key (fk_id_truck, fk_id_type_cargo),
    foreign key (fk_id_truck) references truck (id_truck),
    foreign key (fk_id_type_cargo) references type_cargo (id_type_cargo)
    );

create table cargo(/*груз*/
	id_cargo int not null auto_increment primary key,
    volume_cargo double not null,
    weight int not null,
    place_loading varchar(45) not null,
    place_unloading varchar(45) not null,
    fk_id_type_cargo int not null,
    foreign key (fk_id_type_cargo) references type_cargo (id_type_cargo)
    );    

create table flight(/*рейс*/
	id_flight int not null auto_increment primary key,
    status_f varchar(45) not null,
    director_full_name varchar(45) not null,
    date_time_start datetime not null,
    date_time_end datetime not null,
	number_f int not null,
    base_price int not null,
    fk_id_truck int not null,
    foreign key (fk_id_truck) references truck (id_truck),
    fk_id_worker int not null,
    foreign key (fk_id_worker) references worker (id_worker),
    fk_id_city1 int not null,
    foreign key (fk_id_city1) references city (id_city),
    fk_id_city2 int not null,
    foreign key (fk_id_city2) references city (id_city),
    fk_id_driver1 int not null,
    foreign key (fk_id_driver1) references driver (id_driver),
	fk_id_driver2 int default null,
    foreign key (fk_id_driver2) references driver (id_driver),
	fk_id_customer int not null,
    foreign key (fk_id_customer) references customer (id_customer)
);

/*3)Добавление столбцов как внешних ключей*/

alter table comment_c
	add column fk_id_flight int not null,
    add foreign key (fk_id_flight) references flight (id_flight);
 
alter table cargo
	add column fk_id_flight int not null,
    add foreign key (fk_id_flight) references flight (id_flight);
    
/*4)Заполнение таблиц*/
 
insert into city (name_city)
values
('Москва'),
('Волгоград'),
('Краснодар'),
('Ростов');
 
insert into worker (full_name, phone_number)
values
('Андреев Геннадий Степанович', 89613338345),
('Морозова Екатерина Ивановна', 89883454433),
('Степанов Даниил Валерьевич', 89373332211),
('Иванова Нина Андреевна', 89889998899);
 
insert into type_cargo (factor_cargo, name_type_cargo)
values
(1.4, 'Стройматериалы'),
(1.75, 'Топливо'),
(1.34, 'Запчасти'),
(1.27, 'Продукты');
 
insert into driver (full_name_driver)
values
('Ванроев Иван Романович'),
('Леватов Николай Дмитриевич'),
('Костин Никита Степанович'),
('Петров Пётр Петрович');
 
insert into category (name_category)
values
('E'),
('D'),
('DE'),
('C');
 
insert into type_customer (name_type)
values
('ИП'),
('Физ.лицо'),
('Компания');
 
insert into driver_to_category (fk_id_driver, fk_id_category)
values
(1, 1),
(2, 2),
(3, 3),
(4, 4);    

insert into customer (title, phone_number_c, fk_id_type_customer)
values
('ИП Богданова', 554433, 1),
('Романов Андрей Петрович', 89042223311, 2),
('ОРВС', 225511, 3),
('Ушаков Иван Григорьевич', 89888689977, 2);

insert into truck (name_truck, number_sign, factor, volume, fk_id_category)
values
('Daf 105', 'О555ОО34', 1.4, 98.75, 1),
('Volvo XB32', 'А751ОА134', 1.34, 107.25, 2),
('Daf 105', 'В100ЕК34', 1.24, 88.5, 3),
('Gazelle', 'А962ОО34', 1.1, 46.7, 4);

insert into truck_to_type_cargo (fk_id_truck, fk_id_type_cargo)
values
(1, 1),
(2, 2),
(3, 3),
(4, 4);   

insert into flight (status_f, director_full_name, date_time_start, date_time_end, number_f, base_price, fk_id_truck, fk_id_worker, fk_id_city1, fk_id_city2, fk_id_driver1, fk_id_driver2, fk_id_customer)
values
('Выполнен', 'Кормин Никита Сергеевич', '2022-01-23 10:01:47', '2022-01-28 15:02:42', 1, 36000, 1, 1, 1, 2, 1, 2, 1),
('Выполнен', 'Кормин Никита Сергеевич', '2022-02-03 15:23:34', '2022-02-11 15:02:42', 1, 36000, 2, 2, 2, 3, 1, null, 2),
('Выполнен', 'Кормин Никита Сергеевич', '2022-02-21 11:51:21', '2022-02-27 19:01:52', 1, 36000, 3, 3, 1, 3, 3, 4, 3),
('Выполнен', 'Кормин Никита Сергеевич', '2022-03-09 12:51:37', '2022-03-16 18:42:16', 1, 36000, 4, 4, 3, 4, 2, null, 4);

insert into cargo (volume_cargo, weight, place_loading, place_unloading, fk_id_type_cargo, fk_id_flight)
values
(95.44, 5000, 'Завод НРП', 'Склад им. Васильева', 1, 1),
(105.27, 7530, 'База Газпром', 'КТК', 2, 2),
(84.64, 6543, 'Склад ОЛВР', 'Завод АЛПН', 3, 3),
(45.04, 3748, 'Региональный METRO', 'Магазин METRO', 4, 4);

insert into comment_c (text_c, grade, fk_id_customer, fk_id_flight)
values
('Всё вовремя, советую данную компанию по перевозкам!!!', 5, 1, 1),
('Хорошо, но задержка на 2 часа.', 4, 2, 2),
('Неудачный рейс! Задержка на 2 дня!', 3, 3, 3),
('Всё отлично, советую!', 5, 4, 4);