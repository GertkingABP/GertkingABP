/*4 ЛР 100 запросов, добавлены новые строки данных таблиц*/

/*1)Создаём БД без таблиц*/

create database lorry_100;/*сама БД*/
use lorry_100;/*использование БД*/
show databases;/*отображение всех БД*/
show create database lorry_100;/*отображение созданной БД*/

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
 
insert into city (name_city)
values
('Москва'),
('Волгорад'),/*update na pravilnoe*/
('Краснодар'),
('Ростов'),
('Брянск'),
('Волжский'),
('Кострома'),
('Нижний Новгород'),
('Санкт-Петербург'),
('Саратов'),
('Муха цикотуха'),/**udalit gorod*/
('Мухогород');/*ubrat ego*/
 
insert into worker (full_name, phone_number)
values
('Андреев Геннадий Степанович', 89613338345),
('Морозова Екатерина Ивановна', 89883454433),
('Степанов Данил Валерьевич', 89373332211),/*update imeny*/
('Иванова Нина Андреевна', 89889998899),
('Андреев Александр Степанович', 89112330347),
('Кузьмина Оксана Валерьевна', 89883454433);
 
insert into type_cargo (factor_cargo, name_type_cargo)
values
(1.4, 'Стройматериалы (твёрдые)'),
(1.75, 'Наливной (топливо)'),
(1.34, 'Негабаритный груз (запчасти)'),
(1.27, 'Наливной (продукты)'),
(1.42, 'Насыпной'),
(1.88, 'Штучный');/*update ego v factore*/
 
insert into driver (full_name_driver)
values
('Ванроев Иван Романович'),
('Леватов Николай Дмитриевич'),
('Костин Никита Степанович'),
('Петров Пётр Петрович');
 
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
 
insert into driver_to_category (fk_id_driver, fk_id_category)
values
(1, 1),
(1, 4),
(2, 2),
(2, 3),
(3, 3),
(4, 4);    

insert into customer (title, phone_number_c, fk_id_type_customer)
values
('ИП Богданова', 554433, 1),
('Романов Андрей Петрович', 89042223311, 2),
('ОРВС', 225511, 3),
('Ушаков Иван Григорьевич', 89888689977, 2),
('ИП Скорогруз', 561422, 1),
('Никелин Константин Анатольевич', 89882326301, 2),
('Перевозчик', 250516, 3),
('ПРЕДАТЕЛЬ', 666666, 2);/*udalit ego cherez delete*/

insert into truck (name_truck, number_sign, factor, volume, fk_id_category)
values
('Daf 105', 'О555ОО34', 1.4, 98.75, 1),
('Volvo 47', 'А751ОА134', 1.34, 107.25, 3),
('Daf 105', 'В100ЕК34', 1.24, 88.5, 1),
('Gazelle 3302', 'А962ОО34', 1.1, 46.7, 4),
('Da', 'А104ЕА134', 1.54, 48.6, 1),/*delete*/
('TRUCK', 'В100ЕК34', 1.84, 88.5, 1);/*delete*/

insert into truck_to_type_cargo (fk_id_truck, fk_id_type_cargo)
values
(1, 1),
(1, 2),
(1, 3),
(1, 6),
(2, 3),
(2, 4),
(3, 3),
(3, 4),
(3, 5),
(4, 1),
(4, 3),   
(4, 4);

insert into flight (status_f, director_full_name, date_time_start, date_time_end, number_f, base_price, fk_id_truck, fk_id_worker, fk_id_city1, fk_id_city2, fk_id_driver1, fk_id_driver2, fk_id_customer)
values
('Выполнен', 'Кормин Никита Сергеевич', '2022-01-23 10:01:47', '2022-01-28 15:02:42', 1, 37500, 1, 1, 1, 2, 1, 2, 1),
('Выполнен', 'Кормин Никита Сергеевич', '2022-02-03 15:23:34', '2022-02-11 15:02:42', 2, 39200, 2, 2, 2, 3, 1, null, 2),
('Выполнен', 'Кормин Никита Сергеевич', '2022-02-21 11:51:21', '2022-02-27 19:01:52', 3, 65000, 3, 3, 1, 3, 3, 4, 3),
('Выполнен', 'Кормин Никита Сергеевич', '2022-03-09 12:51:37', '2022-03-16 18:42:16', 4, 46000, 4, 4, 3, 4, 2, null, 4),
('Отменён', 'Кормин Никита Сергеевич', '2022-03-30 09:03:37', '2022-04-05 17:00:42', 5, 40500, 1, 5, 5, 2, 1, 2, 5),
('Выполнен', 'Кормин Никита Сергеевич', '2022-03-31 13:13:32', '2022-04-05 14:52:22', 6, 33000, 2, 6, 5, 3, 1, null, 6),
('Отменён', 'Кормин Никита Сергеевич', '2022-04-02 08:14:02', '2022-04-02 10:11:35', 7, 46000, 3, 3, 2, 2, 3, 4, 7),
('Выполнен', 'Кормин Никита Сергеевич', '2022-04-03 11:21:32', '2022-04-13 14:53:10', 8, 36000, 4, 4, 3, 4, 2, null, 3),
('В процессе', 'Кормин Никита Сергеевич', '2022-04-06 14:51:47', '2022-04-15 14:52:22', 9, 42540, 1, 5, 1, 2, 1, 2, 3),
('В процессе', 'Кормин Никита Сергеевич', '2022-04-27 10:10:10', '2022-05-02 10:10:10', 10, 33600, 2, 6, 2, 3, 1, null, 7);/*zdelat update truck*/
 
insert into flight (status_f, director_full_name, date_time_start, date_time_end, number_f, base_price, fk_id_truck, fk_id_worker, fk_id_city1, fk_id_city2, fk_id_driver1, fk_id_driver2, fk_id_customer)
values
('В процессе', 'Кормин Никита Сергеевич', '2022-05-05 10:05:57', '2022-05-10 15:02:42', 11, 36541, 1, 1, 1, 2, 1, 2, 1),
('В процессе', 'Кормин Никита Сергеевич', '2022-05-12 15:13:34', '2022-05-17 15:02:42', 12, 39200, 2, 2, 2, 3, 1, null, 2),
('В процессе', 'Кормин Никита Сергеевич', '2022-05-21 11:51:21', '2022-05-27 19:01:52', 13, 65000, 3, 3, 1, 3, 3, 4, 3),
('В процессе', 'Кормин Никита Сергеевич', '2022-05-09 12:51:37', '2022-05-16 18:42:16', 14, 46000, 4, 4, 3, 4, 2, null, 4),
('Отменён', 'Кормин Никита Сергеевич', '2022-05-19 09:03:37', '2022-05-30 10:10:12', 15, 46572, 4, 5, 5, 2, 1, 2, 5),
('В процессе', 'Кормин Никита Сергеевич', '2022-05-31 13:13:32', '2022-06-06 14:52:22', 16, 31161, 3, 6, 5, 3, 1, null, 6);

insert into cargo (volume_cargo, weight, place_loading, place_unloading, fk_id_type_cargo, fk_id_flight)
values
(95.44, 5000, 'Завод НРП', 'Склад им. Васильева', 1, 1),
(105.27, 7530, 'База Газпром', 'КТК', 2, 2),
(84.64, 6543, 'Склад ОЛВР', 'Завод АЛПН', 3, 3),
(45.04, 3748, 'Региональный METRO', 'Магазин METRO', 4, 4),
(90.14, 4673, 'Склад МАВ35', 'Склад им. Васильева', 1, 5),
(102.2, 7201, 'База ВПК', 'КТК', 2, 6),
(80.24, 6145, 'База ООО Росток', 'База АПВ', 3, 7),
(43.01, 3208, 'Региональный METRO', 'Магазин METRO', 4, 8),
(70.14, 4300, 'Завод им. Аравова', 'Завод ПИНК', 1, 9),
(105.27, 7530, 'База Газпром', 'АЗС Газпром', 2, 10);/*update na zapravka*/

insert into cargo (volume_cargo, weight, place_loading, place_unloading, fk_id_type_cargo, fk_id_flight)
values
(93.44, 5000, 'Завод НРП', 'Склад им. Васева', 1, 11),
(103.2, 7530, 'База ГазЭнерго', 'КТГН', 1, 12),
(82.64, 6543, 'Склад ООО Пета', 'Завод АЛПН', 1, 13),
(42.14, 3748, 'Региональный METRO', 'Магазин METRO', 4, 14),
(89.14, 4673, 'Склад МАВ35', 'Склад им. Васильева', 6, 15),
(101.11, 7201, 'База ВПК', 'База КРВ', 5, 16);

insert into comment_c (text_c, grade, fk_id_customer, fk_id_flight)
values
('Всё вовремя, советую данную компанию по перевозкам!!!', 5, 1, 1),
('Хорошо, но задержка на 2 часа.', 4, 2, 2),
('Неудачный рейс! Задержка на 2 дня!', 3, 3, 3),
('Всё отлично, советую!', 5, 4, 4),
('Отлично!', 5, 5, 4),
('Всё отлично, советую!', 5, 6, 4),
('Неплохо, но я знаю, что они могут лучше', 4, 7, 4);

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

alter table flight
add check (date_time_start < date_time_end);

/*Запросы*/

/*Блок с DELETE*/
/*удалить все данные с таблицы bad*/
DELETE FROM bad 
WHERE
(bad_id); 

/*удалить саму таблицу(она создана для примера)*/
drop table bad; 

/*удалить заказчика, у которого в номере есть 666*/
DELETE FROM customer 
WHERE
(id_customer
AND phone_number_c LIKE '%666%'); 

/*удалить категорию E*/
DELETE FROM category 
WHERE
(id_category AND name_category = 'E'); 

/*удалить строку у городов, где начало на "Мух"*/
DELETE FROM city 
WHERE
(id_city AND name_city LIKE 'Мух%'); 

/*удалить строку данных среди типов заказчиков где название "Несуществующий тип"*/
DELETE FROM type_customer 
WHERE
(id_type_customer
AND name_type = 'Несуществующий тип'); 

/*Удалить строку грузовика, если его коэффициент более 1.5*/
DELETE FROM truck 
WHERE
(id_truck AND factor > 1.5);

/*Блок с UPDATE*/
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

/*Блок с SELECT INTO или INSERT SELECT*/
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

/*Блок с SELECT DISTINCT, WHERE, AND, OR, BETWEEN, IS NULL, AS*/
select distinct name_truck as 'Названия грузовика'
from truck;/*вывод всех имён без повторов, daf 105 1 раз, хотя их 2 есть*/

SELECT 
*
FROM
flight
WHERE
(base_price > 46000);/*вывести все рейсы (столбцы все), базовая стоимость которых больше 46000, только 1 подходит*/

SELECT 
*
FROM
flight
WHERE
((date_time_start > '2022-01-28 15:02:42')
AND (date_time_start < '2022-03-31 13:13:32'));/*вывести строки рейсов, у которых дата начала больше 1 даты и меньше 2 даты (даты указаны)*/

SELECT DISTINCT
place_unloading
FROM
cargo;/*вывести все места прибытия груза без повторений, из 10 вывели меньше 10*/

SELECT 
*
FROM
flight
WHERE
(fk_id_driver2 IS NULL);/*вывести только те рейсы, где 1 водитель (2 null)*/

select base_price as 'Базовая стоимость',
date_time_start as 'Начало рейса', 
date_time_end as 'Конец рейса' 
from flight 
where (base_price between 33000 and 37000);/*вывести столбцы рейсов с датами и ценой, у которых цена от 33000 до 37000, могут быть рейсы, равные левой или правой границе*/

SELECT 
*
FROM
flight
WHERE
(fk_id_driver1 IS NOT NULL
AND fk_id_driver2 IS NOT NULL);/*вывести рейсы, у которых оба водителя не null*/

SELECT 
full_name, phone_number
FROM
worker
WHERE
(id_worker = 4);

SELECT DISTINCT
status_f AS 'Статус рейса'
FROM
flight
LIMIT 2;/*вывести статусы из всех рейсов (только 2 и без повторений)*/

SELECT 
*
FROM
cargo
WHERE
((weight BETWEEN 5000 AND 6700)
OR (weight BETWEEN 7400 AND 9040));/*вывести строки с грузами, вес которых принадлежит одному из промежутков*/

SELECT 
id_customer, title
FROM
customer
WHERE
(fk_id_type_customer IN (1));/*вывод названия и id заказчиков, у которых id типа 1, можно через =*/

SELECT 
number_f, fk_id_driver1, fk_id_driver2, status_f
FROM
flight
WHERE
(status_f IN ('В процессе'));/*вывод столбцов строк рейсов, которые в процессе*/

SELECT 
phone_number AS 'Nomer telefona', full_name AS 'FIO'
FROM
worker;/*просто выводим работников с их телефонами и новыыми подписями колонок*/

SELECT 
*
FROM
flight
WHERE
(base_price IN (46000));/*выводим только те рейсы, где базовая стоимость 46000*/

/*Суперзапрос SELECT, DISTINCT, WHERE, AND/OR/NOT, IN, BETWEEN*/
select status_f as 'СТАТУС',
number_f as 'НОМЕР',
base_price as 'СТОИМОСТЬ БЕЗ КОЭФФИЦИЕНТОВ'
from flight 
where ((base_price between 39000 and 47000)
and ((date_time_start >= '2022-03-01 00:00'))
and (date_time_end <= '2022-05-25 23:00'))
order by base_price asc;/*вывести столбцы с номером, статусом и стоимостью рейсов, где ограничения стоимости и промежутки дат начала и конца*/

/*Блок с GROUP CONCAT*/
select group_concat('/',
name_category,
'/') 
from category;/*вывести в одну строку все категории*/

select group_concat(volume_cargo,
'_') 
from cargo 
where (place_unloading like '%METRO%');/*вывести в строку объёмы грузов, у которых в месте погрузки есть вхождение METRO*/

select group_concat(' ', 
title) 
from customer 
group by fk_id_type_customer;/*вывести заказчиков, объединив в строку по каждому id типа*/

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
 group by id_cargo;/*вывести таблицу грузов с помощью group concat*/

/*Блок с WITH*/
with cte_1 as 
(select 
* 
from worker) 
select 
* 
from cte_1;/*как бы отобразить общее табличное выражение из всей таблицы работников*/

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
from cte_3;/*сохранить в общее табличное выражение номер рейса(не id) и присоединённое поле заказчика, который ОРВС или Перевозчик*/

/*Блок с JOIN: INNER, OUTER (LEFT, RIGHT, FULL), CROSS, NATURAL*/
SELECT 
driver.full_name_driver, worker.full_name
FROM
driver
CROSS JOIN
worker;/*перекрёсное соединение столбцов фио водителей с фио работников, если нет условия, то можно для перекреста обычный join*/

SELECT 
c.title, t.name_type
FROM
customer c
JOIN
type_customer t ON (c.fk_id_type_customer = t.id_type_customer);/*соединить заказчиков к их типу, слева заказчик, справа их тип, все без id, where можно вместо on*/

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
AND f.digit_f = s.digit_s));/*присоединить те строки, которые равны по содержанию и id*/
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
(title LIKE CONCAT('%', 'ИП', '%'));/*вывести из заказчиков поля с id и названием только тех, у кого есть вхождение "ИП" в названии*/

SELECT 
COUNT(1)
FROM
category;/*вывод числа категорий*/

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

SELECT 
MIN(volume)
FROM
truck;/*вывод наименьшего объёма у грузовиков*/

SELECT 
MIN(name_type_cargo)
FROM
type_cargo;/*вывод самого короткого названия типа груза*/

SELECT 
COUNT(id_worker), full_name
FROM
worker
GROUP BY full_name
ORDER BY full_name DESC
LIMIT 3;/*вывод 2 столбцов (кол-ва id у работника с таким фио и его фио), группируя при этом по фио по убыванию алфавита? 3 работников*/

SELECT 
number_f, base_price
FROM
flight
GROUP BY number_f
HAVING (base_price >= 32000
AND base_price <= 45000)
ORDER BY base_price ASC;/*вывод рейсов(номера и базовой цены) по стоимости больше 32000 и меньше 45000 с сортировкой по возрастанию цены*/

SELECT 
*
FROM
category
HAVING (name_category LIKE CONCAT('%', 'E', '%'));/*вывести всю таблицу с категориями где есть буква E, то есть все кроме кратегории C*/

SELECT 
full_name, phone_number
FROM
worker
WHERE
(full_name LIKE CONCAT('Андреев', '%'));/*вывести ФИО и номер телефона среди работников, у которых фамилия Андреев как вхождение*/

SELECT 
COUNT(fk_id_truck), fk_id_truck
FROM
flight
WHERE
(status_f LIKE CONCAT('Выполнен'))
GROUP BY fk_id_truck;/*вывод того, сколько каждый грузовик совершил рейсов, считаются только выполненные*/

SELECT 
*
FROM
type_cargo
WHERE
(name_type_cargo LIKE 'На%'
AND factor_cargo > 1.3);/*вывод всех строк типов груза, где начало на "На" и коэффициент типа более 1.3*/

SELECT 
full_name
FROM
worker
WHERE
(full_name LIKE '%ич')
LIMIT 2;/*вывод фио работников, у которых конец на ич, то есть мужчин, также не всех, а только первых 2, без этого лимита 3*/

select status_f as 'Статус',
count(*) as 'Раз' 
from flight 
group by status_f 
having count(*) = (select min(nor) 
from (select status_f, 
count(*) as nor 
from flight 
group by status_f) flight);/*вывести самый(самые) нераспространённые статусы рейсов*/

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
GROUP BY grade) comment_c);/*вывести самую частую оценку из всех комментариев*/

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
(id_truck = 1);/*объединить в колонки названия грузовиков и фио водителей с их id, где у каждого id = 1*/

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

select sum(base_price) as 'Общая выручка с рейсов за 1 год'
from flight 
where ((date_time_start >= '2022-01-01 00:00') 
and (date_time_end <= '2022-12-31 23:59') 
and (status_f = 'Выполнен'));/*2. Показать общую выручку с рейсов за 1 год. Без учёта коэффициентов типов груза и грузовиков*/

/*3. Вычислить ТОП3 типа груза за последние 3 месяца и их кол-во (1 - екпр 4 раза, 2 - Название типа  2 раза).*/

/*4. Узнать среднюю конечную стоимость рейса за 1 месяц в течение года. Условие, что смотрим на дату конца, которая в апреле 2022 и статус рейса не важен*/
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

SELECT 
*
FROM
flight
WHERE
((date_time_start >= '2022-04-01 00:00')
AND (date_time_start <= '2022-04-03 23:59'));/*2.	Показать расписание на ближайшие 3 дня.*/

SELECT 
*
FROM
flight
WHERE
((date_time_start >= '2022-04-01 00:00')
AND (date_time_start <= '2022-04-30 23:59')
AND (date_time_end <= '2022-04-30 23:59'))
ORDER BY date_time_start;/*3. Отсортировать текущие рейсы за месяц по дате (от самой ближайшей).*/

SELECT 
*
FROM
flight
WHERE
(fk_id_city1 = 2);/*4. Показать рейсы в город прибытия(выгрузки) (один и тот же).*/

SELECT 
*
FROM
comment_c
ORDER BY grade ASC;/*5. Отсортировать отзывы по оценке (по возрастанию).*/

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
name_city = 'Краснодар');/*вывести рейсы, у которых город загрузки груза Краснодар*/

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
title = 'Перевозчик'))
AND fk_id_worker = (SELECT 
id_worker
FROM
worker
WHERE
full_name = 'Кузьмина Оксана Валерьевна'));/*рейсы, у которых 1 водитель, заказчик Перевозчик и работник Кузьмина Оксана Валерьевна*/

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
name_city IS NULL);/*вывести рейсы, у которых в городах нет имени, но есть id, такого нет, поэтому пустая таблица вывода*/

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

/*Запросы со строковыми функциями СУБД, с функциями работы с датами временем (форматированием дат), с арифметическими функциями (5-7 шт.)*/
/*пример на новой таблице*/
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
where id_truck = 2;/*нашли длину названия грузовика с определённым id*/

select full_name_driver, length(full_name_driver) from driver;

/*вывод имени заказчиков в большом регистре и перевёрнутые номера* по алфавиту имени*/ 
select upper(title) as 'Название', 
concat('(', reverse(phone_number_c), ')') 
from customer 
order by title; 

SELECT 
*
FROM
driver
WHERE
(LOWER(full_name_driver) LIKE CONCAT('%вА%'));/*вывести водителей, имеющих в полном имени "ва", в независимости от регистров*/

/*вывести оценку, текст коммента и название автора-заказчика с использованием строковых функций и условия, что длина названия заказчика от 5 до 10 символов, сортируем по убыванию оценки*/
SELECT 
m.grade, UPPER(m.text_c), CONCAT('|', customer.title, '|')
FROM
comment_c m
JOIN
customer ON (LENGTH(customer.title) BETWEEN 5 AND 20
AND (m.fk_id_customer = customer.id_customer))
ORDER BY grade DESC; 

/*Запрос на арифметику*/
/*сумма тех весов, где "База" есть в месте погрузки или выгрузки, а также столбцы с полным перечислением мест погрузки и выгрузки груза*/
SELECT 
SUM(cargo.weight) AS 'Сумма весов грузов, где фигурирует "База"',
GROUP_CONCAT('/', cargo.place_loading, '/'),
GROUP_CONCAT('/', cargo.place_unloading, '/')
FROM
cargo
WHERE
((LOWER(cargo.place_loading) LIKE CONCAT('%БАЗА%'))
OR (LOWER(cargo.place_loading) LIKE CONCAT('%БАЗА%'))); 

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

/*3) Для каждого водителя вывести среднюю оценку из комментариев к рейсам, где они участвовали.*/
SELECT 
AVG(ROUND(comment_c.grade, 3)), d.full_name_driver
FROM comment_c
LEFT JOIN
flight ON (comment_c.fk_id_flight = flight.id_flight)
LEFT JOIN
driver d ON d.id_driver = flight.fk_id_driver1 OR d.id_driver = flight.fk_id_driver2
GROUP BY d.id_driver
ORDER BY d.full_name_driver;

