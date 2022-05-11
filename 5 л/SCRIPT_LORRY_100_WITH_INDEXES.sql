/*5 ЛР, те же 100 запросов, но с индексами к ним*/
/*10 из 13 таблиц заполняются через csv*/

/*1)Создаём БД без таблиц*/

create database lorry_100_ix;/*сама БД*/
use lorry_100_ix;/*использование БД*/
show databases;/*отображение всех БД*/
show create database lorry_100_ix;/*отображение созданной БД*/

/*2)Таблицы данных*/

/*Рабочий*/
CREATE TABLE worker (
    id_worker INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(45) NOT NULL,
    phone_number VARCHAR(12) NOT NULL
);

/*Город*/
CREATE TABLE city (
    id_city INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name_city VARCHAR(45) NOT NULL
);

/*Водитель*/
CREATE TABLE driver (
    id_driver INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    full_name_driver VARCHAR(45) NOT NULL
);

/*Тип груза*/    
CREATE TABLE type_cargo (
    id_type_cargo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name_type_cargo VARCHAR(45) NOT NULL,
    factor_cargo DOUBLE NOT NULL
);
 
/*Категория*/ 
CREATE TABLE category (
    id_category INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name_category VARCHAR(3) NOT NULL
);

/*Тип заказчика*/
CREATE TABLE type_customer (
    id_type_customer INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name_type VARCHAR(20) NOT NULL
);
   
/*многие ко многим для водителя и категории*/   
CREATE TABLE driver_to_category (
    fk_id_driver INT NOT NULL,
    fk_id_category INT NOT NULL,
    PRIMARY KEY (fk_id_driver , fk_id_category),
    FOREIGN KEY (fk_id_driver)
	REFERENCES driver (id_driver),
    FOREIGN KEY (fk_id_category)
	REFERENCES category (id_category)
);
 
/*Заказчик*/ 
CREATE TABLE customer (
    id_customer INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(45) NOT NULL,
    phone_number_c VARCHAR(12) NOT NULL,
    fk_id_type_customer INT NOT NULL,
    FOREIGN KEY (fk_id_type_customer)
	REFERENCES type_customer (id_type_customer)
);

/*комментарий заказчика*/
CREATE TABLE comment_c (
    id_comment INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    text_c TEXT NOT NULL,
    grade TINYINT NOT NULL,
    fk_id_customer INT NOT NULL,
    FOREIGN KEY (fk_id_customer)
	REFERENCES customer (id_customer)
);
 
 /*Грузовик*/
 CREATE TABLE truck (
    id_truck INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name_truck VARCHAR(30) NOT NULL,
    number_sign VARCHAR(10) NOT NULL,
    factor DOUBLE NOT NULL,
    volume DOUBLE NOT NULL,
    fk_id_category INT NOT NULL,
    FOREIGN KEY (fk_id_category)
	REFERENCES category (id_category)
);
   
/*Многие ко многим для грузовика и типа груза*/   
CREATE TABLE truck_to_type_cargo (
    fk_id_truck INT NOT NULL,
    fk_id_type_cargo INT NOT NULL,
    PRIMARY KEY (fk_id_truck , fk_id_type_cargo),
    FOREIGN KEY (fk_id_truck)
	REFERENCES truck (id_truck),
    FOREIGN KEY (fk_id_type_cargo)
	REFERENCES type_cargo (id_type_cargo)
);

/*Груз*/
CREATE TABLE cargo (
    id_cargo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    volume_cargo DOUBLE NOT NULL,
    weight INT NOT NULL,
    place_loading VARCHAR(45) NOT NULL,
    place_unloading VARCHAR(45) NOT NULL,
    fk_id_type_cargo INT NOT NULL,
    FOREIGN KEY (fk_id_type_cargo)
	REFERENCES type_cargo (id_type_cargo)
);    

/*Рейс*/
CREATE TABLE flight (
    id_flight INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    status_f VARCHAR(45) NOT NULL,
    director_full_name VARCHAR(45) NOT NULL,
    date_time_start DATETIME NOT NULL,
    date_time_end DATETIME NOT NULL,
    number_f INT NOT NULL,
    base_price INT NOT NULL,
    fk_id_truck INT NOT NULL,
    FOREIGN KEY (fk_id_truck)
	REFERENCES truck (id_truck),
    fk_id_worker INT NOT NULL,
    FOREIGN KEY (fk_id_worker)
	REFERENCES worker (id_worker),
    fk_id_city1 INT NOT NULL,
    FOREIGN KEY (fk_id_city1)
	REFERENCES city (id_city),
    fk_id_city2 INT NOT NULL,
    FOREIGN KEY (fk_id_city2)
	REFERENCES city (id_city),
    fk_id_driver1 INT NOT NULL,
    FOREIGN KEY (fk_id_driver1)
	REFERENCES driver (id_driver),
    fk_id_driver2 INT DEFAULT NULL,
    FOREIGN KEY (fk_id_driver2)
	REFERENCES driver (id_driver),
    fk_id_customer INT NOT NULL,
    FOREIGN KEY (fk_id_customer)
	REFERENCES customer (id_customer)
);

/*3)Добавление столбцов как внешних ключей*/

alter table comment_c
	add column fk_id_flight int not null,
	add foreign key (fk_id_flight) references flight (id_flight);
 
alter table cargo
	add column fk_id_flight int not null,
    add foreign key (fk_id_flight) references flight (id_flight);
    
/*4)Заполнение таблиц*/
 
SHOW VARIABLES LIKE "secure_file_priv";/*путь, куда надо скопировать csv файлы*/
 
/*добавлены 10000 городов V*/
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\cities.csv' INTO TABLE city FIELDS TERMINATED BY ',' IGNORE 1 LINES (name_city);

 
/*добавлены через csv 10000 рабочих V*/ 
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\workers.csv' INTO TABLE worker FIELDS TERMINATED BY ';' IGNORE 1 LINES (full_name, phone_number);
  
insert into type_cargo (factor_cargo, name_type_cargo)
values
(1.4, 'Стройматериалы (твёрдые)'),
(1.75, 'Наливной (топливо)'),
(1.34, 'Негабаритный груз (запчасти)'),
(1.27, 'Наливной (продукты)'),
(1.42, 'Насыпной'),
(1.88, 'Штучный');/*update ego v factore*/
 
 /*через csv 10000 водителей V*/
 
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\drivers.csv' INTO TABLE driver FIELDS TERMINATED BY ',' IGNORE 1 LINES (full_name_driver);

insert into category (name_category)
values
('С1E'),
('D1E'),
('DE'),
('C'),
('E');/*udalit etu categoriu*/
 
insert into type_customer (name_type)
values
('ИП'),
('Физ.лицо'),/*zdelat update*/
('Компания'),
('Несуществующий тип');/*udalit tip*/
 
/*csv 10000 цепочек водителя и категории V*/ 
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\DRIVER_TO_CATEGORY.csv' INTO TABLE driver_to_category FIELDS TERMINATED BY ',' IGNORE 1 LINES (fk_id_driver, fk_id_category);

/*добавили в customer 10000 строк csv V*/
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\customers.csv' INTO TABLE customer FIELDS TERMINATED BY ';' IGNORE 1 LINES (title, phone_number_c, fk_id_type_customer);
 
/*csv, 10000 грузовиков V*/
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\TRUCK.csv' INTO TABLE truck FIELDS TERMINATED BY ',' IGNORE 1 LINES (id_truck, name_truck, number_sign, factor, volume, fk_id_category);

/*многие ко многим 10000 строк грузовика и типа груза V*/
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\TRUCK_TO_TYPE_CARGO.csv' INTO TABLE truck_to_type_cargo FIELDS TERMINATED BY ',' IGNORE 1 LINES (fk_id_truck, fk_id_type_cargo);

/*в рейсы 10000 строк из csv V*/
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\flights_and_ids.csv' INTO TABLE flight FIELDS TERMINATED BY ',' IGNORE 1 LINES (id_flight, status_f, director_full_name, date_time_start, date_time_end, number_f, base_price, fk_id_truck, fk_id_worker, fk_id_city1, fk_id_city2,  fk_id_driver1, fk_id_driver2, fk_id_customer);

UPDATE flight /*УЖЕ НЕ НАДО*/
SET date_time_start=(@temp:=date_time_start), 
date_time_start = date_time_end, 
date_time_end = @temp 
where (id_flight and date_time_start > date_time_end);/*поменять даты местами, так как в генераторе нельзя задать их зависимость, не удалось поменять во всех, только в половине строчек V*/

/*добавлены 10000 строк грузов V*/
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\cargos.csv' INTO TABLE cargo FIELDS TERMINATED BY ';' IGNORE 1 LINES (volume_cargo, weight, place_loading, place_unloading, fk_id_type_cargo, fk_id_flight);
/*dobavit cargos*/

/*добавлены 10000 строк комментариев к рейсам V*/
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\comments.csv' INTO TABLE comment_c FIELDS TERMINATED BY ';' IGNORE 1 LINES (text_c, grade, fk_id_customer, fk_id_flight);
/*dodelat*/

/*udalim vse iz nee*/
CREATE TABLE bad (
    bad_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    bad_name VARCHAR(45) NOT NULL,
    bad_number TINYINT NOT NULL
);

/*udalit eti dannie a potom i vsu tablicu bad*/
insert into bad (bad_name, bad_number) 
values
('Bad Boy 1', 32),
('Lovin 241', 22),
('Fool', 19),
('redMAN', 31);

CREATE INDEX in_bad_id ON bad (bad_id);/*индекс обычный по id*/

alter table flight
add check (date_time_start < date_time_end);

/*Запросы (+индексы)*/

/*Блок с DELETE*/
/*удалить все данные с таблицы bad*/
DELETE FROM bad 
WHERE
(bad_id); 

/*удалить саму таблицу(она создана для примера)*/
drop table bad; 

/*удалить заказчика, у которого в номере есть 666 (не робит)*/
DELETE FROM customer 
WHERE
(id_customer
AND phone_number_c LIKE '%666%'); 

/*удалить категорию E (индекс не нужен)*/
DELETE FROM category 
WHERE
(id_category AND name_category = 'E'); 

/*удалить строку у городов, где начало на "Мух" (мало столбцов, индекс не уместен)*/
DELETE FROM city 
WHERE
(id_city AND name_city LIKE 'Мух%'); 

/*удалить строку данных среди типов заказчиков где название "Несуществующий тип" (малая таблица, без индексов)*/
DELETE FROM type_customer 
WHERE
(id_type_customer
AND name_type = 'Несуществующий тип'); 

/*Удалить строку грузовика, если его коэффициент более 1.5 (индексы не оптимальны для операций удаления, добавления или изменения данных)*/

DELETE FROM truck /*(не робит)*/
WHERE
(id_truck AND factor > 1.5);

/*Блок с UPDATE (индекс для update сделает хуже)*/
UPDATE city 
SET 
name_city = 'Волгоград'
WHERE
(id_city AND name_city = 'Волгорад');/*исправление ошибки в имени города*/

UPDATE worker 
SET 
full_name = 'Степанов Данила Валерьевич'
WHERE
(id_worker
AND full_name = 'Степанов Данил Валерьевич');/*исправление ошибки в фио у одного из работников*/

UPDATE type_cargo 
SET 
factor_cargo = 1.9
WHERE
((id_type_cargo) AND (factor_cargo > 1.8)
AND (factor_cargo < 1.9));/*повышение размера коэффициента типа груза*/

UPDATE type_customer 
SET 
name_type = 'Физическое лицо'
WHERE
((id_type_customer)
AND name_type LIKE 'Физ.%');/*обновление названия одного типа заказчика*/

UPDATE flight 
SET 
fk_id_truck = 3
WHERE
((number_f = 10) AND (fk_id_truck = 2));/*замена грузовика в 10 будущем рейсе*/

UPDATE customer 
SET 
title = 'Перевозчик (не Стетхем)'
WHERE
(id_customer AND title = 'Перевозчик');/*изменить название заказчика*/ 

/*Блок с SELECT INTO или INSERT SELECT (добавление данных, индекс не оптимален)*/
/*пробная таблица, в которую мы перекопируем данные из truck (не все)*/
CREATE TABLE clone_truck (
    name_tr VARCHAR(30) NOT NULL,
    number_tr VARCHAR(10) NOT NULL,
    factor_tr DOUBLE NOT NULL
);
 
/*перекопировали в клона 3 столбца из truck*/ 
insert into clone_truck (name_tr, number_tr, factor_tr) select name_truck, number_sign, factor from truck; 
drop table clone_truck;/*удаляем клона*/

/*клон рейсов (не полный)*/
CREATE TABLE clone_2 (
    id INT NOT NULL PRIMARY KEY,
    date_st DATETIME NOT NULL,
    date_end DATETIME NOT NULL
);

/*перекопировали в клона 3 столбца из flight*/
insert into clone_2 (id, date_st, date_end) select id_flight, date_time_start, date_time_end from flight; 
drop table clone_2;/*удалили таблицу клона рейсов*/

/*3 клон, совмещающий название и номер каждого заказчика*/
CREATE TABLE clone_cus (
    clone_title VARCHAR(45) NOT NULL,
    clone_phone_number_c VARCHAR(12) NOT NULL
);

insert into clone_cus (clone_title, clone_phone_number_c) 
select title, phone_number_c 
from customer;
drop table clone_cus;/*удалили таблицу клона заказчиков*/

/*Здесь уже применение индексов поможет*/

/*Блок с SELECT DISTINCT, WHERE, AND, OR, BETWEEN, IS NULL, AS*/
create index in_name_truck on truck (name_truck);/*время исполнения чуть меньше(разницы почти нет)*/
drop index in_name_truck on truck;

select distinct name_truck as 'Названия грузовика'
from truck;/*вывод всех имён без повторов*/

create index in_base_price on flight (base_price);/*случайным образом с индексом чуть дольше или быстрее(разница в тысяные и меньше)*/
drop index in_base_price on flight;

SELECT 
*
FROM
flight
WHERE
(base_price > 46000);/*вывести все рейсы (столбцы все), базовая стоимость которых больше 46000*/

create index in_dates_times on flight (date_time_start, date_time_end);
drop index in_dates_times on flight;

SELECT 
*
FROM
flight
WHERE
((date_time_start > '2022-01-28 15:02:42')
AND (date_time_start < '2022-03-31 13:13:32'));/*вывести строки рейсов, у которых дата начала больше 1 даты и меньше 2 даты (даты указаны)*/

/*продолжаем от сюда*/

SELECT DISTINCT
place_unloading
FROM
cargo;/*вывести все места прибытия груза без повторений*/

create index in_plun on cargo (place_unloading);/*индекс на место погрузки, на скорость особо не влияет*/
drop index in_plun on cargo;

SELECT 
*
FROM
flight
WHERE
(fk_id_driver2 IS NULL);/*вывести только те рейсы, где 1 водитель (2 null)*/

create index in_driver2 on flight (fk_id_driver2);
drop index in_driver2 on flight;

select base_price as 'Базовая стоимость',
date_time_start as 'Начало рейса', 
date_time_end as 'Конец рейса' 
from flight 
where (base_price between 33000 and 37000);/*вывести столбцы рейсов с датами и ценой, у которых цена от 33000 до 37000, могут быть рейсы, равные левой или правой границе*/

create index in_price_between on flight (base_price);/*индекс по 1 полю цены, первый индекс, где стоимость запроса заметно меньше в цифрах(на глаз неощутимо) и сканируется гораздо меньше строк*/
drop index in_price_between on flight;

SELECT 
*
FROM
flight
WHERE
(fk_id_driver1 IS NOT NULL
AND fk_id_driver2 IS NOT NULL);/*вывести рейсы, у которых оба водителя не null*/

create index in_2drivers on flight (fk_id_driver1, fk_id_driver2);
drop index in_2drivers on flight;

SELECT 
full_name, phone_number
FROM
worker
WHERE
(id_worker = 4);

create index in_w on worker (id_worker);/*индекс на id, не имеет смысла в оптимизации (нет большой разницы)*/
drop index in_w on worker;

SELECT DISTINCT
status_f AS 'Статус рейса'
FROM
flight
LIMIT 2;/*вывести статусы из всех рейсов (только 2 и без повторений)*/

create index in_status on flight (status_f);
drop index in_status on flight;

SELECT 
*
FROM
cargo
WHERE
((weight BETWEEN 5000 AND 6700)
OR (weight BETWEEN 7400 AND 9040));/*вывести строки с грузами, вес которых принадлежит одному из промежутков, индекс не помог*/

create index in_weight on cargo (weight);
drop index in_weight on cargo;

/*продолжение*/

SELECT 
id_customer, title
FROM
customer
WHERE
(fk_id_type_customer IN (1));/*вывод названия и id заказчиков, у которых id типа 1, можно через =*/

create index in_type_customer on customer (fk_id_type_customer);/*индекс по типу заказчика (не обязателен, т.к внешний ключ как бы уже индекс по дефолту)*/
drop index in_type_customer on customer;

SELECT 
number_f, fk_id_driver1, fk_id_driver2, status_f
FROM
flight
WHERE
(status_f IN ('In progress'));/*вывод столбцов строк рейсов, которые в процессе*/

create index in_st_inpr on flight (status_f);/*индекс только на статус, т.к выборка различна только в статусах, оптимизировали стоимость запроса с индексом*/
drop index in_st_inpr on flight;

SELECT 
phone_number AS 'Nomer telefona', full_name AS 'FIO'
FROM
worker;/*просто выводим работников с их телефонами и новыыми подписями колонок, индекс не нужен, это просто вывод всей таблицы*/

SELECT 
*
FROM
flight
WHERE
(base_price IN (46000));/*выводим только те рейсы, где базовая стоимость 46000*/

create index in_pr46 on flight (base_price);/*индекс на цену, обычный(очень большой выигрыш в стоимости запроса, но время не меняется почти)*/
drop index in_pr46 on flight;

/*Суперзапрос SELECT, DISTINCT, WHERE, AND/OR/NOT, IN, BETWEEN*/
select status_f as 'СТАТУС',
number_f as 'НОМЕР',
base_price as 'СТОИМОСТЬ БЕЗ КОЭФФИЦИЕНТОВ'
from flight 
where ((base_price between 39000 and 47000)
and ((date_time_start >= '2022-03-01 00:00'))
and (date_time_end <= '2022-05-25 23:00'))
order by base_price asc;/*вывести столбцы с номером, статусом и стоимостью рейсов, где ограничения стоимости и промежутки дат начала и конца*/

create index in_price_and_dates on flight (base_price);/*индекс на стоимость(составной в данном случае не нужен, если сделать составной и цену не на первое место, то стоимость только вырастет, а так снизится в 2 раза)*/
drop index in_price_and_dates on flight;

/*Блок с GROUP CONCAT*/
select group_concat('/',
name_category,
'/') 
from category;/*вывести в одну строку все категории, индекс не имеет смысла*/

select group_concat(volume_cargo,
'_') 
from cargo 
where (place_unloading like '%METRO%');/*вывести в строку объёмы грузов, у которых в месте погрузки есть вхождение METRO, запрос не оптимизируется индексом*/

/*далее смотрим*/

select group_concat(' ', 
title) 
from customer 
group by fk_id_type_customer;/*вывести заказчиков, объединив в строку по каждому id типа, индекс не нужен*/

select id_cargo, 
group_concat(volume_cargo,
 '/',
 weight,
 '/',
 place_loading,
 '/',
 place_unloading) 
 as 'Объём/вес/место погрузки/место выгрузки' 
 from cargo 
 group by id_cargo;/*вывести таблицу грузов с помощью group concat, индекс нет смысла использовать*/

/*Блок с WITH*/
with cte_1 as 
(select 
* 
from worker) 
select 
* 
from cte_1;/*как бы отобразить общее табличное выражение из всей таблицы работников (выдалась вся таблица, индекс не надо)*/

with cte_2 as 
(select name_truck,
number_sign 
from truck) 
select 
* 
from cte_2 
where (name_truck != 'Daf 105');/*как бы отобразить общее табличное выражение из таблицы грузовиков, в общее только название и номер и где не Daf 105*/

with cte_3 as (select flight.number_f, 
customer.title from flight 
join customer 
on (flight.fk_id_customer = customer.id_customer 
and ((customer.title = 'ОРВС') 
or (customer.title = 'Перевозчик'))) 
order by flight.number_f) select 
* 
from cte_3;/*сохранить в общее табличное выражение номер рейса(не id) и присоединённое поле заказчика, который ОРВС или Перевозчик, на with запросы не надо индексов*/

/*Блок с JOIN: INNER, OUTER (LEFT, RIGHT, FULL), CROSS, NATURAL(ИНДЕКС ПОМОЖЕТ ТОЛЬКО В JOIN`ах где есть where!!!)*/
SELECT 
driver.full_name_driver, worker.full_name
FROM
driver
CROSS JOIN
worker;/*перекрёсное соединение столбцов фио водителей с фио работников, если нет условия, то можно для перекреста обычный join, не надо индекс*/

SELECT 
c.title, t.name_type
FROM
customer c
JOIN
type_customer t ON (c.fk_id_type_customer = t.id_type_customer);/*соединить заказчиков к их типу, слева заказчик, справа их тип, все без id, where можно вместо on, не помог индекс*/

/*////////////////////////////////////////////ОТСЮДА ПРОДОЛЖАЕМ////////////////////////////////////////*/
/*INNER JOIN для временных таблиц*/
CREATE TABLE first_t (
    id_f INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title_f VARCHAR(15) NOT NULL,
    digit_f DOUBLE NOT NULL
);

CREATE TABLE second_t (
    id_s INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title_s VARCHAR(15) NOT NULL,
    digit_s DOUBLE NOT NULL
);

insert into first_t (title_f, digit_f) values
('Everyday', 12.5),
('Man', 16.15),
('g63', 121.41),
('user', 1.5);

insert into second_t (title_s, digit_s) values
('Everyday', 12.5),
('MGW', 1.15),
('g63', 121.41),
('us', 1.5);

SELECT 
f.title_f, f.digit_f, s.title_s, s.digit_s
FROM
first_t f
INNER JOIN
second_t s ON ((f.id_f = s.id_s)
AND (f.title_f = s.title_s
AND f.digit_f = s.digit_s));/*присоединить те строки, которые равны по содержанию и id, без индекса запрос и так лёгкий*/
drop table first_t;
drop table second_t;

/*Остальные JOIN*/
SELECT 
c.name_category, t.name_truck, t.number_sign
FROM
category c
LEFT JOIN
truck t ON (c.id_category = t.fk_id_category);/*соединение столбцов по равенству внешних ключей категории, у D1E нет грузовиков, поэтому null*/

SELECT 
t.name_truck, t.number_sign, c.name_type_cargo
FROM
truck t
CROSS JOIN
type_cargo c;/*случай, когда все бы грузовики смогли бы возить каждый из типов груза*/ 

SELECT 
f.number_f, f.base_price, t.number_sign, c.title
FROM
flight f
JOIN
truck t ON (f.fk_id_truck = t.id_truck)
JOIN
customer c ON (f.fk_id_customer = c.id_customer)
ORDER BY f.number_f;/*присоединить к 2 столбцам номера и стоимости рейса названия заказчиков и номер назначенного грузовика*/

SELECT 
m.fk_id_truck,
m.fk_id_type_cargo,
t.name_truck,
p.name_type_cargo
FROM
truck_to_type_cargo m
RIGHT JOIN
truck t ON (m.fk_id_truck = t.id_truck)
RIGHT JOIN
type_cargo p ON (m.fk_id_type_cargo = p.id_type_cargo);/*вывод id грузовика и его типов груза со значениями этих id*/

select flight.number_f as 'Номер рейса', 
flight.date_time_start as 'Дата начала', 
flight.date_time_end as 'Дата окончания', 
worker.full_name as 'ФИО работника', 
city.name_city as 'Город отправления', 
c.name_city as 'Город прибытия' 
from flight 
join worker 
on (worker.id_worker = flight.fk_id_worker) 
join city 
on (flight.fk_id_city1 = city.id_city) 
join city c 
on (flight.fk_id_city2 = c.id_city) 
order by flight.number_f;/*как бы новая таблица с номером и датами рейса, полными именами работника и 2 городами*/

select cargo.weight as 'Вес груза',
type_cargo.name_type_cargo as 'Тип груза', 
flight.base_price as 'Базовая стоимость всего рейса' 
from cargo 
join type_cargo 
on (cargo.fk_id_type_cargo = type_cargo.id_type_cargo) 
join flight 
on (cargo.fk_id_flight = flight.id_flight) 
order by type_cargo.name_type_cargo;/*вес груза с типом и стоимостью перевозки в рейсе, участвуют 3 таблицы*/

SELECT 
comment_c.grade, comment_c.text_c, customer.title
FROM
comment_c
JOIN
customer ON (comment_c.fk_id_customer = customer.id_customer)
ORDER BY comment_c.grade DESC;/*вывод коммента с оценкой и его автора(заказчика)*/

SELECT 
f.id_flight,
f.status_f,
f.director_full_name,
f.date_time_start,
f.date_time_end,
f.number_f,
f.base_price,
t.name_truck,
w.full_name,
y.name_city,
n.name_city,
i.full_name_driver,
v.full_name_driver,
c.title
FROM
flight f
LEFT JOIN
truck t ON (f.fk_id_truck = t.id_truck)
LEFT JOIN
worker w ON (f.fk_id_worker = w.id_worker)
LEFT JOIN
city y ON (f.fk_id_city1 = y.id_city)
LEFT JOIN
city n ON (f.fk_id_city2 = n.id_city)
LEFT JOIN
driver i ON (f.fk_id_driver1 = i.id_driver)
LEFT JOIN
driver v ON (f.fk_id_driver2 = v.id_driver)
LEFT JOIN
customer c ON (f.fk_id_customer = c.id_customer);/*вывести полностью таблицу рейсов, заменив внешние ключи конкретными соответствующими данными (не fk_id)*/

SELECT 
customer.title, customer.phone_number_c, n.name_type
FROM
customer
LEFT JOIN
type_customer n ON (customer.fk_id_type_customer = n.id_type_customer);

/*не известно про join оптимизацию*/

/*Блок с GROUP BY, ORDER BY, COUNT, LIMIT и так далее*/
SELECT 
*
FROM
flight
ORDER BY date_time_start DESC
LIMIT 6;/*вывод 6 рейсов по дате начала по убыванию*/

SELECT 
*
FROM
comment_c
ORDER BY grade ASC;/*вывод всех отзывов по оценке по возрастанию*/

SELECT 
id_customer, title
FROM
customer
WHERE
(title LIKE CONCAT('%', 'ИП', '%'));/*вывести из заказчиков поля с id и названием только тех, у кого есть вхождение "ИП" в названии, index no*/

SELECT 
COUNT(1)
FROM
category;/*вывод числа категорий, лёгкий по нагрузке*/

SELECT 
SUM(base_price)
FROM
flight;/*вывод суммы всей выручки за всё время рейсов*/

SELECT 
AVG(base_price)
FROM
flight;/*вывод средней базовой стоимости рейса*/

SELECT 
AVG(weight)
FROM
cargo;/*вывод среднего веса среди всех грузов*/

create index in_w on cargo (weight);/*индекс ничего не поменял*/
drop index in_w on cargo;

SELECT 
MIN(volume)
FROM
truck;/*вывод наименьшего объёма у грузовиков*/

create index in_v on truck (volume);/*оптимизация появилась, но нельзя сказать по плану, насколько улучшилась (по времени в 10 раз)*/
drop index in_v on truck;

SELECT 
MIN(name_type_cargo)
FROM
type_cargo;/*вывод самого короткого названия типа груза, и без индекса быстро*/

SELECT 
COUNT(id_worker), full_name
FROM
worker
GROUP BY full_name
ORDER BY full_name DESC
LIMIT 3;/*вывод 2 столбцов (кол-ва id у работника с таким фио и его фио), группируя при этом по фио по убыванию алфавита? 3 работников, по идее ускорить нельзя*/

SELECT 
number_f, base_price
FROM
flight
GROUP BY number_f
HAVING (base_price >= 32000
AND base_price <= 45000)
ORDER BY base_price ASC;/*вывод рейсов(номера и базовой цены) по стоимости больше 32000 и меньше 45000 с сортировкой по возрастанию цены, не помог индекс*/

/*ещё наверх*/

SELECT 
*
FROM
category
HAVING (name_category LIKE CONCAT('%', 'E', '%'));/*вывести всю таблицу с категориями где есть буква E, то есть все кроме кратегории C, и так оптимизирован*/

SELECT 
full_name, phone_number
FROM
worker
WHERE
(full_name LIKE CONCAT('Андреев', '%'));/*вывести ФИО и номер телефона среди работников, у которых фамилия Андреев как вхождение, с like не работают индексы*/

SELECT 
COUNT(fk_id_truck), fk_id_truck
FROM
flight
WHERE
(status_f = 'Done')
GROUP BY fk_id_truck;/*вывод того, сколько каждый грузовик совершил рейсов, считаются только выполненные*/

create index in_stat on flight (status_f);/*спад скорости есть, но индексы не работают на запросах с like*/
drop index in_stat on flight;

SELECT 
*
FROM
type_cargo
WHERE
(name_type_cargo LIKE 'На%'
AND factor_cargo > 1.3);/*вывод всех строк типов груза, где начало на "На" и коэффициент типа более 1.3, наибольшее ускорение по дефолту*/

SELECT 
full_name
FROM
worker
WHERE
(full_name LIKE '%ич')
LIMIT 2;/*вывод фио работников, у которых конец на ич, то есть мужчин, также не всех, а только первых 2, без этого лимита 3, индекс не нужен для ускорения*/

select status_f as 'Статус',
count(*) as 'Раз' 
from flight 
group by status_f 
having count(*) = (select min(nor) 
from (select status_f, 
count(*) as nor 
from flight 
group by status_f) flight);/*вывести самый(самые) нераспространённые статусы рейсов, не индексируемый*/

SELECT 
grade AS 'Оценка', COUNT(*) AS 'Раз'
FROM
comment_c
GROUP BY grade
HAVING COUNT(*) = (SELECT 
MAX(nor)
FROM
(SELECT 
grade, COUNT(*) AS nor
FROM
comment_c
GROUP BY grade) comment_c);/*вывести самую частую оценку из всех комментариев, индекс не помогает здесь*/

/*Блок с UNION*/
SELECT 
full_name
FROM
worker 
UNION SELECT 
full_name_driver
FROM
driver
ORDER BY full_name;/*вывести в 1 столбец работников и водителей*/

SELECT 
phone_number_c
FROM
customer 
UNION SELECT 
phone_number
FROM
worker
ORDER BY phone_number_c;/*вывести в столбец все номера заказчиков и работников по возрастанию*/

/*1 пример на новых таблицах, их потом удаляем*/
CREATE TABLE t1 (
    id1 INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    n1 VARCHAR(10) NOT NULL,
    date1 DATE NOT NULL
);

CREATE TABLE t2 (
    id2 INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    n2 VARCHAR(10) NOT NULL,
    date2 DATE NOT NULL
);

insert into t1 (n1, date1) values
('sdf', '2022-12-13'),
('FWS', '2021-03-19'),
('D23', '2020-11-16');

insert into t2 (n2, date2) values
('sdf', '2022-12-13'),
('AF', '2020-02-04'),
('DDDDW', '2018-08-13');

SELECT 
*
FROM
t1 
UNION ALL SELECT 
*
FROM
t2
ORDER BY n1;/*вывести как бы 2 таблицы вертикально в одни столбцы (таблицы идентичные по колонкам), без all дубликаты не повторяются в выводе, по алфавиту названий n1 n2*/
drop table t1;
drop table t2;

select name_truck as 'Названия грузовиков и типов груза',
factor 
from truck 
union select name_type_cargo, factor_cargo 
from type_cargo;/*объединение 2 столбцов с коэффициентом и названием у truck и type_cargo, без order by*/

SELECT 
*
FROM
category 
UNION ALL SELECT 
*
FROM
city
ORDER BY id_category;/*просто объединить 2 таблицы категорий и городов, просто как пример, порядок по id*/

SELECT 
id_driver, full_name_driver
FROM
driver
WHERE
(id_driver = 1) 
UNION SELECT 
id_truck, name_truck
FROM
truck
WHERE
(id_truck = 15);/*объединить в колонки названия грузовиков и фио водителей с их id, где у каждого id = 1*/

SELECT 
title
FROM
customer 
UNION ALL SELECT 
full_name
FROM
worker
ORDER BY title; /*вывести в столбец заказчиков и работников*/

SELECT 
volume_cargo
FROM
cargo 
UNION ALL SELECT 
volume
FROM
truck
ORDER BY volume_cargo DESC;/*все объёмы грузов и грузовиков в 1 столбец*/

/*НАВЕРХ*/

/*Аналитические запросы:
1. Показать количество отмененных рейсов за последний месяц v
2. Показать общую выручку с рейсов за 1 год. v
3. Вычислить самый распространённый тип груза за последние 3 месяца.
4. Узнать среднюю конечную стоимость рейса за 1 месяц в течение года. v
5. Выяснить, какой город является самым посещаемым в качестве города загрузки груза за 3 года.
*/

select count(1) as 'Количество отменённых рейсов за апрель 2022 года'
from flight 
where ((status_f = 'Отменён') 
and (date_time_start >= '2022-04-01 00:00') 
and (date_time_end <= '2022-04-30 23:59'));/*1. Показать количество отмененных рейсов за последний месяц*/

create index in_c on flight (status_f);/*индекс на статус, только этот индекс оптимизирует запрос*/
drop index in_c on flight;

select sum(base_price) as 'Общая выручка с рейсов за 1 год'
from flight 
where ((date_time_start >= '2022-01-01 00:00') 
and (date_time_end <= '2022-12-31 23:59') 
and (status_f = 'Выполнен'));/*2. Показать общую выручку с рейсов за 1 год. Без учёта коэффициентов типов груза и грузовиков*/

create index in_sum on flight (status_f);/*индекс на статус, только этот индекс оптимизирует запрос*/
drop index in_sum on flight;

/*3. Вычислить ТОП3 типа груза за последние 3 месяца и их кол-во (1 - екпр 4 раза, 2 - Название типа  2 раза).*/

/*4. Узнать среднюю конечную стоимость рейса за 1 месяц в течение года. Условие, что смотрим на дату конца, которая в апреле 2022 и статус рейса не важен, индекс не помогает*/
select avg(base_price) as 'Средняя базовая стоимость рейса за апрель в течение 2022 года'
from flight
where ((date_time_end >= '2022-04-01 00:00')
and (date_time_end <= '2022-04-30 23:59')); 

/*5. Выяснить, какой город является самым посещаемым в качестве города загрузки груза за 3 года.*/

/*Справочные (оперативные запросы):
1.	Показать расписание на текущие сутки. v
2.	Показать расписание на ближайшие 3 дня. v
3. Отсортировать текущие рейсы за месяц по дате (от самой ближайшей). v 
4. Показать рейсы в город прибытия (один и тот же). v
5. Отсортировать отзывы по оценке (по возрастанию). v
*/

SELECT 
*
FROM
flight
WHERE
((date_time_start >= '2022-04-27 00:00')
AND (date_time_start <= '2022-04-27 23:59'));/*1.	Показать расписание на текущие сутки. (27.04.2022)*/

create index in_td on flight (date_time_start);
drop index in_td on flight;

SELECT 
*
FROM
flight
WHERE
((date_time_start >= '2022-04-01 00:00')
AND (date_time_start <= '2022-04-03 23:59'));/*2.	Показать расписание на ближайшие 3 дня.*/

create index in_1d on flight (date_time_start);/*уменьшение стоимости запроса*/
drop index in_1d on flight;

SELECT 
*
FROM
flight
WHERE
((date_time_start >= '2022-04-01 00:00')
AND (date_time_start <= '2022-04-30 23:59')
AND (date_time_end <= '2022-04-30 23:59'))
ORDER BY date_time_start;/*3. Отсортировать текущие рейсы за месяц по дате (от самой ближайшей).*/

create index in_1date on flight (date_time_start);/*улучшение по стоимости запроса*/
drop index in_1date on flight;

SELECT 
*
FROM
flight
WHERE
(fk_id_city2 = 1174);/*4. Показать рейсы в город прибытия(выгрузки)(один и тот же). Запрос и так нормальный по внешнему ключу как индексу*/

SELECT 
*
FROM
comment_c
ORDER BY grade ASC;/*5. Отсортировать отзывы по оценке (по возрастанию).Индекс не надо, все строки выводим*/


/*Вложенные SELECT с GROUP BY, ALL, ANY, EXISTS (3-5 шт.)*/
SELECT 
*
FROM
flight
WHERE
fk_id_city1 = (SELECT 
id_city
FROM
city
WHERE
name_city = 'Bost');/*вывести рейсы, у которых город загрузки груза Boston (нельзя несколько строк вернуть)*/

SELECT 
number_f, base_price, director_full_name
FROM
flight
WHERE
((fk_id_driver2 IS NULL)
AND (fk_id_customer = (SELECT 
id_customer
FROM
customer
WHERE
title = 'Joe'))
AND fk_id_worker = (SELECT 
id_worker
FROM
worker
WHERE
full_name = 'Rori'));/*рейсы, у которых 1 водитель, заказчик Joe и работник Rori (тоже самое, что и предыдущее)*/

SELECT 
*
FROM
flight
WHERE
EXISTS( SELECT 
*
FROM
city
WHERE
name_city IS NULL);/*вывести рейсы, у которых в городах нет имени, но есть id, такого нет, поэтому пустая таблица вывода, индекс не помог*/

SELECT 
*
FROM
flight
WHERE
fk_id_worker = ANY (SELECT 
id_worker
FROM
worker
WHERE
phone_number = '89613338345');/*вывести рейсы, у которых работник имеет указанный номер*/

create index in_pn on worker (phone_number);/*индекс очень сильно снизил стоимость, время в 2 раза меньше, но это доли секунды*/
drop index in_pn on worker;

SELECT 
name_truck, number_sign
FROM
truck
WHERE
fk_id_category = ALL (SELECT 
id_category
FROM
category
WHERE
name_category = 'С1E');/*искать номер и грузовик, у которого категория C1E*/ 

create index in_ncat on category (name_category);/*время и конечная стоимость не меняются, но есть различия в explain и стоимость подзапроса мала, но меньше чуть*/
drop index in_ncat on category;

/*Запросы со строковыми функциями СУБД, с функциями работы с датами временем (форматированием дат), с арифметическими функциями (5-7 шт.)*/
/*пример на новой таблице, на маленькие таблицы индексы не нужны*/
CREATE TABLE strings (
    id_s INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    s1 VARCHAR(15) NOT NULL,
    s2 VARCHAR(35) NOT NULL,
    s3 VARCHAR(50) NOT NULL
);

insert into strings (s1, s2, s3) values
('FFF', '3dg', '234fd'),
('32321', '   Rfag', '34fd  '),
(' tWdWf2 ', 'Name: ', 'John');

SELECT 
LENGTH(s1)
FROM
strings
WHERE
id_s = 1;/*длина строки колоночки*/

SELECT 
REVERSE(s1)
FROM
strings
WHERE
id_s = 3;/*перевернутый вывод строки*/

SELECT 
LOWER(s1)
FROM
strings
WHERE
id_s = 3;/*значение колонки в малом регистре*/

SELECT 
REPEAT(s2, 4)
FROM
strings
WHERE
id_s = 3;/*4 раза повторить Name*/

truncate table strings;/*очистить таблицу без её удаления*/

drop table strings;/*удалить таблицу (можно сразу с данными без truncate), все строки ищутся по id через =*/

/*Примеры с БД грузоперевозок*/
select name_truck as 'Название грузовика', 
length(name_truck) as 'Длина в символах' 
from truck 
where id_truck = 2;/*нашли длину названия грузовика с определённым id*, индекс не надо, т.к id это как бы уже индекс, стоимость запроса низкая*/

select full_name_driver, length(full_name_driver) from driver;/*индекс не надо, т.к вывод всей таблицы*/

/*вывод имени заказчиков в большом регистре и перевёрнутые номера* по алфавиту имени*/ 
select upper(title) as 'Название', 
concat('(', reverse(phone_number_c), ')') 
from customer 
order by title; /*индекс не надо, т.к вывод всей таблицы*/

SELECT 
*
FROM
driver
WHERE
(LOWER(full_name_driver) LIKE CONCAT('%Shel%'));/*вывести водителей, имеющих в полном имени "ва", в независимости от регистров*/

create index in_fndr on driver (full_name_driver);/*индекс не ускорил*/
drop index in_fndr on driver;

/*вывести оценку, текст коммента и название автора-заказчика с использованием строковых функций и условия, что длина названия заказчика от 5 до 10 символов, сортируем по убыванию оценки*/
SELECT 
m.grade, UPPER(m.text_c), CONCAT('|', customer.title, '|')
FROM
comment_c m
JOIN
customer ON (LENGTH(customer.title) BETWEEN 5 AND 20
AND (m.fk_id_customer = customer.id_customer))
ORDER BY grade DESC; 

create index in_title on customer (title);/*не ускорилось*/
drop index in_title on customer; 

/*Запрос на арифметику*/
/*сумма тех весов, где "База" есть в месте погрузки или выгрузки, а также столбцы с полным перечислением мест погрузки и выгрузки груза*/
SELECT 
SUM(cargo.weight) AS 'Сумма весов грузов, где фигурирует "База"',
GROUP_CONCAT('/', place_loading, '/'),
GROUP_CONCAT('/', place_unloading, '/')
FROM
cargo
WHERE
((LOWER(place_loading) LIKE CONCAT('%БАЗА%'))
OR (LOWER(place_unloading) LIKE CONCAT('%БАЗА%'))); 

create index in_2places on cargo (place_loading, place_unloading);/*индекс не помог*/
drop index in_2places on cargo;

/*///////////////////////////////////////////////////МОДИФИКАЦИЯ///////////////////////////////////////////////////*/
/*1) ТОП 3 типов груза за последние 3 месяца и их кол-во (1 - Насыпной (4 раза), 2 - Наливной (2 раза) -> пример.*/

/*запрос на всё, для проверок*/
SELECT 
*
FROM
flight
JOIN
cargo ON cargo.fk_id_flight = flight.id_flight
RIGHT JOIN
type_cargo ON cargo.fk_id_type_cargo = type_cargo.id_type_cargo;

/*Сам запрос*/
SELECT 
type_cargo.name_type_cargo, COUNT(fk_id_flight) AS raz
FROM
cargo
JOIN
flight ON cargo.fk_id_flight = flight.id_flight
RIGHT JOIN
type_cargo ON cargo.fk_id_type_cargo = type_cargo.id_type_cargo
WHERE
flight.date_time_start IS NULL
OR (flight.date_time_start >= '2020-03-01 00:00'
AND flight.date_time_end <= '2022-05-15 00:00')
GROUP BY cargo.fk_id_type_cargo
ORDER BY raz DESC 
limit 3;

create index in_dates on flight (date_time_start, date_time_end);
drop index in_dates on flight;

/*2) Вывести все комментарии (все столбцы), в них ФИО пользователя, его тип, номер рейса и 2 водителей.*/
SELECT 
comment_c.id_comment,
comment_c.text_c,
comment_c.grade,
customer.title,
type_customer.name_type,
flight.number_f,
l.full_name_driver,
i.full_name_driver
FROM comment_c
LEFT JOIN
customer ON (comment_c.fk_id_customer = customer.id_customer)
LEFT JOIN
type_customer ON (customer.fk_id_type_customer = type_customer.id_type_customer)
LEFT JOIN
flight ON (comment_c.fk_id_flight = flight.id_flight)
LEFT JOIN
driver l ON (flight.fk_id_driver1 = l.id_driver)
LEFT JOIN
driver i ON (flight.fk_id_driver2 = i.id_driver);

/*3) Для каждого водителя вывести среднюю оценку из комментариев к рейсам, где они участвовали. Where нет, просто присоединение по ключам.*/
SELECT 
AVG(ROUND(comment_c.grade, 3)), d.full_name_driver
FROM comment_c
LEFT JOIN
flight ON (comment_c.fk_id_flight = flight.id_flight)
LEFT JOIN
driver d ON d.id_driver = flight.fk_id_driver1 OR d.id_driver = flight.fk_id_driver2
GROUP BY d.id_driver
ORDER BY d.full_name_driver;

/*--------------------------------------------------------------ОТОБРАННЫЕ ЗАПРОСЫ(Х14) ДЛЯ БУДУЩЕГО ТОПА 10--------------------------------------------------------------*/

/*#5*/
/*1 ДО ИНДЕКСА: ВРЕМЯ = 0:00:0.00398, СТОИМОСТЬ 1000.25*/
/*1 ПОСЛЕ ИНДЕКСА: ВРЕМЯ = 0:00:0.00164, СТОИМОСТЬ 249.11*/

select base_price as 'Базовая стоимость',
date_time_start as 'Начало рейса', 
date_time_end as 'Конец рейса' 
from flight 
where (base_price between 33000 and 37000);/*вывести столбцы рейсов с датами и ценой, у которых цена от 33000 до 37000, могут быть рейсы, равные левой или правой границе*/

create index in_price_between on flight (base_price);/*индекс по 1 полю цены, первый индекс, где стоимость запроса заметно меньше в цифрах(на глаз неощутимо) и сканируется гораздо меньше строк*/
drop index in_price_between on flight;


/*#6*/
/*2 ДО ИНДЕКСА: ВРЕМЯ = 0:00:0.00028040, СТОИМОСТЬ 1000.25*/
/*2 ПОСЛЕ ИНДЕКСА: ВРЕМЯ = 0:00:0.00033430, СТОИМОСТЬ 5.15*/

SELECT DISTINCT
status_f AS 'Статус рейса'
FROM
flight
LIMIT 2;/*вывести статусы из всех рейсов (только 2 и без повторений)*/

create index in_status on flight (status_f);/*индекс на статус (уменьшает стоимость запроса, в плане показано)*/
drop index in_status on flight;


/*#3*/
/*3 ДО ИНДЕКСА: ВРЕМЯ = 0:00:0.00645680, СТОИМОСТЬ 1000.25*/
/*3 ПОСЛЕ ИНДЕКСА: ВРЕМЯ = 0:00:0.00705830, СТОИМОСТЬ 407.95*/

SELECT 
number_f, fk_id_driver1, fk_id_driver2, status_f
FROM
flight
WHERE
(status_f IN ('In progress'));/*вывод столбцов строк рейсов, которые в процессе*/

create index in_status_in_progress_flights on flight (status_f);/*индекс только на статус, т.к выборка различна только в статусах, оптимизировали стоимость запроса с индексом*/
drop index in_status_in_progress_flights on flight;


/*#10*/
/*4 ДО ИНДЕКСА: ВРЕМЯ = 0:00:0.00565880, СТОИМОСТЬ 1000.25*/
/*4 ПОСЛЕ ИНДЕКСА: ВРЕМЯ = 0:00:0.00032190, СТОИМОСТЬ 0.35*/

SELECT 
*
FROM
flight
WHERE
(base_price IN (46000));/*выводим только те рейсы, где базовая стоимость 46000*/

create index in_price_46000 on flight (base_price);/*индекс на цену, обычный(очень большой выигрыш в стоимости запроса, но время не меняется почти)*/
drop index in_price_46000 on flight;

-- show indexes from flight;

/*#1*/
/*5 ДО ИНДЕКСА: ВРЕМЯ = 0:00:0.00506580, СТОИМОСТЬ 1120.71*/
/*5 ПОСЛЕ ИНДЕКСА: ВРЕМЯ = 0:00:0.00314000, СТОИМОСТЬ 540.71*/

/*Суперзапрос SELECT, DISTINCT, WHERE, AND/OR/NOT, IN, BETWEEN*/
select status_f as 'СТАТУС',
number_f as 'НОМЕР',
base_price as 'СТОИМОСТЬ БЕЗ КОЭФФИЦИЕНТОВ'
from flight 
where ((base_price between 39000 and 47000)
and ((date_time_start >= '2022-03-01 00:00'))
and (date_time_end <= '2022-05-25 23:00'))
order by base_price asc;/*вывести столбцы с номером, статусом и стоимостью рейсов, где ограничения стоимости и промежутки дат начала и конца*/

create index in_price_and_dates on flight (base_price);/*индекс на стоимость(составной в данном случае не нужен, если сделать составной и цену не на первое место, то стоимость только вырастет, а так снизится в 2 раза)*/
drop index in_price_and_dates on flight;


/*экстра1*/
/*6 ДО ИНДЕКСА: ВРЕМЯ = 0:00:0.03272300, СТОИМОСТЬ 1024.35(ИТОГОВАЯ), ПОДЗАПРОСА - 0.65*/
/*6 ПОСЛЕ ИНДЕКСА: ВРЕМЯ = 0:00:0.02559830, СТОИМОСТЬ 1024.35(ИТОГОВАЯ), ПОДЗАПРОСА - 0.35(НЕЗНАЧИТЕЛЬНО)*/

SELECT 
name_truck, number_sign
FROM
truck
WHERE
fk_id_category = ALL (SELECT 
id_category
FROM
category
WHERE
name_category = 'С1E');/*искать номер и грузовик, у которого категория C1E*/ 

create index in_name_category on category (name_category);/*время и конечная стоимость не меняются, но есть различия в explain и стоимость подзапроса мала, но меньше чуть*/
drop index in_name_category on category;


/*#7*/
/*7 ДО ИНДЕКСА: ВРЕМЯ = 0:00:0.00397680, СТОИМОСТЬ 1559.97*/
/*7 ПОСЛЕ ИНДЕКСА: ВРЕМЯ = 0:00:0.00190120, СТОИМОСТЬ 1.59*/

SELECT 
*
FROM
flight
WHERE
fk_id_worker = ANY (SELECT 
id_worker
FROM
worker
WHERE
phone_number = '89613338345');/*вывести рейсы, у которых работник имеет указанный номер*/

create index in_phone_number_worker on worker (phone_number);/*индекс очень сильно снизил стоимость, время в 2 раза меньше, но это доли секунды*/
drop index in_phone_number_worker on worker;


/*экстра3*/
/*8 ДО ИНДЕКСА: ВРЕМЯ = 0:00:0.01216680, СТОИМОСТЬ 1000.25*/
/*8 ПОСЛЕ ИНДЕКСА: ВРЕМЯ = 0:00:0.00908040, СТОИМОСТЬ 1028.06(СТОИМОСТЬ ЧУТЬ ВЫШЕ, НО ВРЕМЯ МЕНЬШЕ)*/

SELECT 
*
FROM
flight
WHERE
((date_time_start >= '2022-04-01 00:00')
AND (date_time_start <= '2022-04-03 23:59'));/*2.	Показать расписание на ближайшие 3 дня.*/

create index in_day_flight on flight (date_time_start);/*уменьшение стоимости запроса*/
drop index in_day_flight on flight;


/*#8*/
/*9 ДО ИНДЕКСА: ВРЕМЯ = 0:00:0.00574690, СТОИМОСТЬ 1000.25*/
/*9 ПОСЛЕ ИНДЕКСА: ВРЕМЯ = 0:00:0.00036030, СТОИМОСТЬ 0.71*/

SELECT 
*
FROM
flight
WHERE
((date_time_start >= '2022-04-27 00:00')
AND (date_time_start <= '2022-04-27 23:59'));/*1.	Показать расписание на текущие сутки. (27.04.2022)*/

create index in_1_day on flight (date_time_start);
drop index in_1_day on flight;


/*#9*/
/*10 ДО ИНДЕКСА: ВРЕМЯ = 0:00:0.00401060, СТОИМОСТЬ 1000.25*/
/*10 ПОСЛЕ ИНДЕКСА: ВРЕМЯ = 0:00:0.00036080, СТОИМОСТЬ 0.35*/

select sum(base_price) as 'Общая выручка с рейсов за 1 год'
from flight 
where ((date_time_start >= '2022-01-01 00:00') 
and (date_time_end <= '2022-12-31 23:59') 
and (status_f = 'Выполнен'));/*2. Показать общую выручку с рейсов за 1 год. Без учёта коэффициентов типов груза и грузовиков*/

create index in_sum_done on flight (status_f);/*индекс на статус, только этот индекс оптимизирует запрос*/
drop index in_sum_done on flight;


/*#2*/
/*11 ДО ИНДЕКСА: ВРЕМЯ = 0:00:0.00510150, СТОИМОСТЬ 1000.25*/
/*11 ПОСЛЕ ИНДЕКСА: ВРЕМЯ = 0:00:0.00478700, СТОИМОСТЬ 414.25*/

select count(1) as 'Количество отменённых рейсов за апрель 2022 года'
from flight 
where ((status_f = 'Canceled') 
and (date_time_start >= '2022-04-01 00:00') 
and (date_time_end <= '2022-04-30 23:59'));/*1. Показать количество отмененных рейсов за последний месяц*/

create index in_canceled_flights on flight (status_f);/*индекс на статус, только этот индекс оптимизирует запрос*/
drop index in_canceled_flights on flight;


/*#4*/
/*12 ДО ИНДЕКСА: ВРЕМЯ = 0:00:0.01365150, СТОИМОСТЬ 1000.25*/
/*12 ПОСЛЕ ИНДЕКСА: ВРЕМЯ = 0:00:0.00684820, СТОИМОСТЬ 396.05*/

SELECT 
COUNT(fk_id_truck), fk_id_truck
FROM
flight
WHERE
(status_f = 'Done')
GROUP BY fk_id_truck;/*вывод того, сколько каждый грузовик совершил рейсов, считаются только выполненные*/

create index in_status_f on flight (status_f);/*спад скорости есть, но индексы не работают на запросах с like*/
drop index in_status_f on flight;


/*экстра2*/
/*13 ДО ИНДЕКСА: ВРЕМЯ = 0:00:0.01367010, СТОИМОСТЬ 1024.35*/
/*13 ПОСЛЕ ИНДЕКСА: ВРЕМЯ = 0:00:0.00022500, СТОИМОСТЬ -(ПИШЕТ, ЧТО ВЫБРАНЫ ОПТИМИЗИРОВАННЫЕ ТАБЛИЦЫ), ОЧЕНЬ ОПТИМИЗИРОВАНО*/

SELECT 
MIN(volume)
FROM
truck;/*вывод наименьшего объёма у грузовиков*/

create index in_volume_truck on truck (volume);/*оптимизация появилась, но нельзя сказать по плану, насколько улучшилась (по времени в 10 раз)*/
drop index in_volume_truck on truck;

/*--------------------------------------------------------ПРОЦЕДУРЫ, ФУНКЦИИ И ПРЕДСТАВЛЕНИЯ--------------------------------------------------------*/

/*--------------------------ПРОЦЕДУРЫ--------------------------*/

/*1. Процедура без параметров, просто вывести строки с именами работников на A*/
DELIMITER $$
CREATE PROCEDURE pr_all_workers_like_A ()/*нет параметров*/
BEGIN
    SELECT * FROM worker where full_name like 'A%';
END $$
DELIMITER ;

call pr_all_workers_like_A;
drop procedure pr_all_workers_like_A;

/*2. Процедура с 1 входным параметром in, вывести поля с id, директором и датами, где заданная в процедура стоимость рейса < базовой из таблицы*/
delimiter $$
create procedure pr_prices_more (in price int)/*1 параметр*/
begin
	select id_flight, director_full_name, date_time_start, date_time_end, base_price 
    from flight 
    where price < base_price 
    order by base_price asc;
end $$
delimiter ;

call pr_prices_more(58424);/*вывести рейсы, стоимость которых больше указанной*/
drop procedure pr_prices_more;

/*3. Процедура с несколькими(3) входными in, вывести строку груза, где вес меньше указанного и места погрузки и выгрузки равны заданным в процедуре*/
delimiter $$
create procedure pr_search_comment (in weight_pr int, in place1 varchar(50), in place2 varchar(50))/*3 параметра*/
begin
    select * from cargo
    where weight_pr > weight 
    and place1 = place_loading
    and place2 = place_unloading;
end $$
delimiter ;

call pr_search_comment(5000, 'LLk', 'VVyJwd');
drop procedure pr_search_comment;

select @tmp;
set @tmp := 1;/*для процедуры*/

/*4. Для каждого водителя вывести среднюю оценку из комментариев к рейсам, где они участвовали. Where нет, просто присоединение по ключам.Как процедура*/

delimiter $$
create procedure pr_avg_grade_drivers ()/*без параметров*/
begin
	SELECT 
	AVG(ROUND(comment_c.grade, 3)), d.full_name_driver
	FROM comment_c
	LEFT JOIN
	flight ON (comment_c.fk_id_flight = flight.id_flight)
	LEFT JOIN
	driver d ON d.id_driver = flight.fk_id_driver1 OR d.id_driver = flight.fk_id_driver2
	GROUP BY d.id_driver
	ORDER BY d.full_name_driver;

end $$
delimiter ;

call pr_avg_grade_drivers;
drop procedure pr_avg_grade_drivers;

/*5. Процедура на 4 параметра, вывести столбцы с номером, статусом и стоимостью рейсов, где ограничения стоимости и промежутки дат начала и конца*/

delimiter $$
create procedure pr_flights_With_4_properties (price1 int, price2 int, date_time1 datetime, date_time2 datetime)/*4 параметра как ограничения*/
begin
	select status_f as 'СТАТУС',
	number_f as 'НОМЕР',
	base_price as 'СТОИМОСТЬ БЕЗ КОЭФФИЦИЕНТОВ'
	from flight 
	where ((base_price between price1 and price2)
	and ((date_time_start >= date_time1))
	and (date_time_end <= date_time2))
	order by base_price asc;

end $$
delimiter ;

call pr_flights_With_4_properties(33520, 63040, '2022-03-01 00:00', '2022-05-25 23:00');
drop procedure pr_flights_With_4_properties;

/*6. */
delimiter $$
create procedure pr_statused_flights (in status_f_pr varchar(45), out outer_var int)/*1 вх, 1 вых*/
begin
	select count(1) as 'Количество отменённых рейсов за апрель 2022 года'
    into outer_var
	from flight 
	where ((status_f_pr = status_f) 
	and (date_time_start >= '2022-04-01 00:00') 
	and (date_time_end <= '2022-04-30 23:59'));/*1. Показать количество отмененных рейсов за последний месяц*/
    
end $$
delimiter ;

call pr_statused_flights ('In progress', @t1);/*результат в этой временной переменной*/
select @t1;/*вывод того, что получила процедура в данную переменную*/
drop procedure pr_statused_flights;
 
/*--------------------------ФУНКЦИИ--------------------------*/

/*1. Пробная функция*/
DELIMITER $$
 
CREATE FUNCTION FunctCalc (starting_value INT)
RETURNS INT
DETERMINISTIC
BEGIN
   DECLARE income INT;
   SET income = 0;
   label1: WHILE income <= 10 DO
   SET income = income + starting_value;
   END WHILE label1;
   RETURN income;
   
END $$
 
DELIMITER ;

SELECT FunctCalc (1);
drop function FunctCalc;/*в результате получим на 10 большее число, чем указанное в параметре*/

/*2.*/

delimiter $$
create function func_min_volume_truck (volume_func double)/*1 вх.параметр*/
returns double
deterministic
begin

	declare out_var double default 0; 
	SELECT 
	MIN(volume)
    into out_var
	FROM
	truck
    where volume_func < volume;/*вывод наименьшего объёма у грузовиков, начиная с указанного*/
	RETURN out_var;

end $$
delimiter ;

select func_min_volume_truck(60);
drop function func_min_volume_truck;

/*3.*/

delimiter $$
create function func_sum_prices (date1 datetime, date2 datetime, status_fl_func varchar(25))/*3 вх.параметра*/
returns int
deterministic
begin
	
    declare summ double default 0;
	select sum(base_price) as 'Общая выручка с рейсов за 1 год'
    into summ
	from flight 
	where ((date_time_start >= date1) 
	and (date_time_end <= date2) 
	and (status_f = status_fl_func));/*2. Показать общую выручку с рейсов за 1 год. Без учёта коэффициентов типов груза и грузовиков*/
	return summ;
    
end $$
delimiter ;

select func_sum_prices ('2022-01-01 00:00', '2022-12-31 23:59', 'Done');
drop function func_sum_prices;

/*4.*/

delimiter $$
create function func_flights_6_properties (st varchar(25), price1 int, price2 int, num int, date1 datetime, date2 datetime)/*6 вх.параметров*/
returns int
deterministic
begin

    declare count_flights double default 0;
	select count(*) 
    into count_flights
	from flight
	where status_f = st
	and base_price between price1 and price2
	and number_f > num
	and date_time_start > date1
	and date_time_end < date2;/*кол-во рейсов со определённым статусом, ценой, номером > указанного и датами начала и конца*/
	return count_flights;
    
end $$
delimiter ;

select func_flights_6_properties ('Canceled', 66666, 100000, 8000, '2022-04-06 00:00', '2022-04-27 05:00');
drop function func_flights_6_properties;

/*5.*/

delimiter $$
create function func_avg_factor_truck_more (volume_func float, category tinyint)/*2 параметра*/
returns int
deterministic
begin
	
    declare answer double default 0;
	select avg(factor)
    into answer
	from truck
	where volume > volume_func
	and fk_id_category = category;/*средний коэффициент грузовика с объёмом более указанного и с определённой категорией*/
	return answer;
    
end $$
delimiter ;

select func_avg_factor_truck_more(50.00, 3);/*округляет до целого значения*/
drop function func_avg_factor_truck_more;

/*------------------------ПРЕДСТАВЛЕНИЯ (VIEW)------------------------*/

/*1. */

create view v_rating_drivers /*стоимость стала выше!*/
as 
/*3) Для каждого водителя вывести среднюю оценку из комментариев к рейсам, где они участвовали. Where нет, просто присоединение по ключам.*/
SELECT 
AVG(ROUND(comment_c.grade, 3)), d.full_name_driver
FROM comment_c
LEFT JOIN
flight ON (comment_c.fk_id_flight = flight.id_flight)
LEFT JOIN
driver d ON d.id_driver = flight.fk_id_driver1 OR d.id_driver = flight.fk_id_driver2
GROUP BY d.id_driver
ORDER BY d.full_name_driver;

select * from v_rating_drivers;
drop view v_rating_drivers;

/*2. */

create view v_sum_prices/*очень сильно снизилась стоимость запроса с 1000.25 до 1!!! По времени поменялось чуть-чуть*/
as
SELECT 
SUM(base_price)
FROM
flight;/*вывод суммы всей выручки за всё время рейсов*/

select * from v_sum_prices;
drop view v_sum_prices;

/*3. */

create view v_cargo_with_weight /*стоимость запроса осталась неизменной(на плане)*/
as
SELECT 
*
FROM
cargo
WHERE
((weight BETWEEN 5000 AND 6700)
OR (weight BETWEEN 7400 AND 9040));/*вывести строки с грузами, вес которых принадлежит одному из промежутков*/

select * from v_cargo_with_weight;
drop view v_cargo_with_weight;

/*4. */
create view v_top3_type_cargo
as
/*ТОП 3 типов груза за последние 3 месяца и их кол-во (1 - Насыпной (4 раза), 2 - Наливной (2 раза) -> пример.*/
SELECT 
type_cargo.name_type_cargo, COUNT(fk_id_flight) AS raz
FROM
cargo
JOIN
flight ON cargo.fk_id_flight = flight.id_flight
RIGHT JOIN
type_cargo ON cargo.fk_id_type_cargo = type_cargo.id_type_cargo
WHERE
flight.date_time_start IS NULL
OR (flight.date_time_start >= '2020-03-01 00:00'
AND flight.date_time_end <= '2022-05-15 00:00')
GROUP BY cargo.fk_id_type_cargo
ORDER BY raz DESC 
limit 3;

select * from v_top3_type_cargo;/*снова сильное снижение стоимости запроса через представление*/
drop view v_top3_type_cargo;

/*5. */

create view v_some_trucks/*представление не меняет стоимоть запроса(это делает только индекс)*/
as
select 
name_truck, 
number_sign
from truck
where factor > 1.89
and volume between 55 and 60;/*вывести номер и название грузовика, у которого опроеделённый объём и коэффициент*/

select * from v_some_trucks;
drop view v_some_trucks;

/*----------------------------------ТРИГГЕРЫ----------------------------------*/
/*1. Триггер на удаление строки города с названием менее 3 символов*/

DELIMITER $$
CREATE TRIGGER tr_on_delete_wrong_city
after insert
ON city
FOR EACH ROW
delete FROM city
WHERE length(name_city) < 3 $$
DELIMITER ;

drop trigger tr_on_delete_wrong_city;

/*2. Триггер на обновление строки грузовика с коэффициентом менее 1*/
DELIMITER $$
CREATE TRIGGER tr_on_update_wrong_trucks
after insert
ON truck
FOR EACH ROW
update truck set factor = 1.1
WHERE factor < 1 $$
DELIMITER ;

drop trigger tr_on_update_wrong_trucks;

/*-------------------------------------------------МОДИФИКАЦИЯ К ЛР5-------------------------------------------------*/

/*1) Запрос на 6 секунд и запрос где запрос на ТОП 3 типов груза – план (по возможности, оптимизировать)*/
/*6.362 sec -> 6.527 sec, запрос стал дольше*/

/*3) Для каждого водителя вывести среднюю оценку из комментариев к рейсам, где они участвовали. Where нет, просто присоединение по ключам.*/
SELECT 
AVG(ROUND(comment_c.grade, 3)), full_name_driver
FROM comment_c
LEFT JOIN
flight ON (comment_c.fk_id_flight = flight.id_flight)
LEFT JOIN
driver ON id_driver = flight.fk_id_driver1 OR id_driver = flight.fk_id_driver2
GROUP BY id_driver
ORDER BY full_name_driver;/*on ploxoi, uberi ego*/

create index in_full_name_driver on driver (full_name_driver);
drop index in_full_name_driver on driver;

select/*сам запрос модификации(вместо предыдущего) 0.098 сек(время)*/
avg(avg_rating), driver.full_name_driver
from
(
	select
	fk_id_driver1 as driver_id, ifnull(avg(comment_c.grade), 0) as avg_rating
	from flight
	left join comment_c on comment_c.fk_id_flight = flight.id_flight
	group by fk_id_driver1
    
	union all
    
	select
	fk_id_driver2, ifnull(avg(comment_c.grade), 0)
	from flight
	left join comment_c on comment_c.fk_id_flight = flight.id_flight
	group by fk_id_driver2
) 
as avg_ratings
join driver on driver_id = driver.id_driver
group by driver_id
order by avg(avg_rating) desc,  driver.full_name_driver asc;

/*2) Процедура из 4 частей: 
1. Получить id заказчика по входному параметру телефона заказчика процедуры;
2. Получить id рейса по входному параметру номера рейса процедуры;
3. Добавить комментарий по параметрам (предыдущие 2 id и текст с оценкой(inout) как конкретные значения процедуры); 
4. Вывести среднюю оценку рейса из всех его комментариев, т.е комментарий добавился и вывести обновлённое среднее из оценки.*/

delimiter $$
create procedure pr_from_four_parts (in number_phone varchar(12), in number_flight int, inout pr_grade tinyint, in txt text)
begin

declare var_id_c int default 0; 
declare var_id_f int default 0; 

/*1ч*/
select id_customer
into var_id_c 
from customer
where number_phone = phone_number_c;

/*2ч*/
select id_flight
into var_id_f
from flight
where number_flight = number_f;

/*3ч*/
insert into comment_c (text_c, grade, fk_id_customer, fk_id_flight) values
(txt, pr_grade, var_id_c, var_id_f);

/*4ч*/
select avg(grade)
into pr_grade
from comment_c
where fk_id_flight = var_id_f;

end $$
delimiter ;

set @grade = 103;

call pr_from_four_parts ('886838', 12, @grade, 'JNDSKkljdk skel  edklsd dfg43!!!');
drop procedure pr_from_four_parts;
select @grade;

select * from customer order by title asc;
select * from comment_c where fk_id_customer = 8;

/*3) Представление, в котором выводится вся информация о рейсе, но без id внешних ключей (полная таблица)*/
create view v_all_info_flight as
SELECT 
f.id_flight,
f.status_f,
f.director_full_name,
f.date_time_start,
f.date_time_end,
f.number_f,
f.base_price,
t.name_truck,
w.full_name,
y.name_city as first_city,
n.name_city as second_city,
i.full_name_driver as first_driver,
v.full_name_driver as second_driver,
c.title
FROM
flight f
LEFT JOIN
truck t ON (f.fk_id_truck = t.id_truck)
LEFT JOIN
worker w ON (f.fk_id_worker = w.id_worker)
LEFT JOIN
city y ON (f.fk_id_city1 = y.id_city)
LEFT JOIN
city n ON (f.fk_id_city2 = n.id_city)
LEFT JOIN
driver i ON (f.fk_id_driver1 = i.id_driver)
LEFT JOIN
driver v ON (f.fk_id_driver2 = v.id_driver)
LEFT JOIN
customer c ON (f.fk_id_customer = c.id_customer);/*вывести полностью таблицу рейсов, заменив внешние ключи конкретными соответствующими данными (не fk_id)*/

select * from v_all_info_flight;
drop view v_all_info_flight;