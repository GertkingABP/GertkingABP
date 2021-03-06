/*1)Создание БД*/
create database med_contract; /*создание БД*/
use med_contract;/*использование для заполнения этой БД*/
show databases;/*показ всех БД*/
show create database med_contract;/*отображение нашей БД*/

/*2)Таблицы create*/

create table Medicines (/*Препарат*/
/*dobavit pk kak idMedicines*/
Name_m varchar(30) not null,
Cost smallint not null,
constraint check (Cost > 1000),/*ubrat etot check i peremennuy*/
InstructionsForUse text(300) not null
);

create table ExaminationType (/*тип обследования*/
idExaminationType int not null auto_increment primary key,
Name_e varchar(30) not null
);

create table AnalysisType (/*тип анализа*/
idAnalysisType int not null auto_increment primary key,
Name_a varchar(30)
);

create table MedicalField (/*мед.область*/
idMedicalField int not null auto_increment primary key,
Name_mf varchar(30) not null/*zdelat rename*/
);

create table Doctor (/*врач, доктор*/
idDoctor int not null auto_increment primary key,
FullName varchar(50) not null,
fk_idMedicalField int not null,
foreign key (fk_idMedicalField) references MedicalField (idMedicalField),
DoctorField varchar(25) not null
/*dobavit cherez alter Contact i udalit DoctorField*/
);

create table Clinic (/*клиника*/
idClinic int not null auto_increment primary key,
Name_cl varchar(30) not null,
Phone_cl varchar(12) not null,
Address varchar(30) not null
);

create table Contract (/*контракт*/
idContract int not null auto_increment primary key,
Position varchar(30) not null,/*должность*/
fk_idClinic int not null,
foreign key (fk_idClinic) references Clinic (idClinic),
fk_idDoctor int not null/*potom dobavit*/
/*dobavit cherez alter fk_idDoctor*/
);

create table CreatureType (/*тип животного*/
idCreatureType int not null auto_increment primary key,
Name_cr varchar(30) not null/*zdelat rename i ostavit check*/
);
 
create table FamilyMember (/*член семьи*/
idFamilyMember int not null auto_increment primary key,
FullName varchar(30) not null,
DateOfBirth date not null,
fk_idCreatureType int not null,
foreign key (fk_idCreatureType) references CreatureType (idCreatureType),
fk_idContract int not null,
foreign key (fk_idContract) references Contract (idContract)
/*udalit stolbec i kluch ot kontrakta*/
);

create table VisitingMedicalFacility (/*посещение мед.учереждения*/
idVisit int not null auto_increment primary key,
DateAndTime datetime not null,
Summ int not null,
fk_idContract int not null,
foreign key (fk_idContract) references Contract (idContract)
/*dobavit alter`om kluch dlya chlena semiy*/
);

create table Analysis (/*анализы*/
idAnalysis int not null auto_increment primary key,
DateTakeTest datetime not null,
fk_idAnalysisType int not null,
foreign key (fk_idAnalysisType) references AnalysisType (idAnalysisType),
fk_idVisit int not null,
foreign key (fk_idVisit) references VisitingMedicalFacility (idVisit)
/*dobavit FileLink i HasDeviation kak atributy*/
);

create table MedicalReport (/*мед.заключение*/
idReport int not null auto_increment primary key,
Diagnosis varchar(150) not null,
FileLink varchar(100) not null,
fk_idExaminationType int not null,
foreign key (fk_idExaminationType) references ExaminationType (idExaminationType),
fk_idMedicalField int not null,
foreign key (fk_idMedicalField) references MedicalField (idMedicalField),
fk_idVisit int not null,
foreign key (fk_idVisit) references VisitingMedicalFacility (idVisit)
);

create table Prescription (/*рецепт*/
id_ int not null auto_increment primary key,/*udalit eto alter`ом*/
/*dobavit alter idPrescription*/
DurationOfAdmission tinyint not null,/*длительность приёма*/
AdmissionStartDate date not null,/*дата начала приёма лекарства*/
Dosage double not null unique/*udalit unique*/,
fk_idMedicines int not null,
/*dobavit fk_idMedicines*/
fk_idReport int not null,
foreign key (fk_idReport) references MedicalReport (idReport)
);

/*3)Добавление нужного через alter*/

alter table Medicines/*добавление первичного ключа*/
add column idMedicines int not null auto_increment primary key,
drop Cost,/*как бы удалили атрибут с чеком*/
add column Cost smallint not null;/*добавили его же, но без чека, то есть убрали в итоге чек*/

show create table Medicines;


alter table Prescription
add foreign key (fk_idMedicines) references Medicines (idMedicines),
add column idPrescription int not null auto_increment primary key,/*добавление первичного ключа*/
drop id_,/*удаление лишнего первичного ключа и столбца*/
drop index Dosage;/*удаление ограничения unique*/

alter table doctor
add column Contact varchar(11) not null,
drop DoctorField;

alter table Contract
add foreign key (fk_idDoctor) references Doctor (idDoctor);

alter table VisitingMedicalFacility
add column fk_idFamilyMember int not null,
add foreign key (fk_idFamilyMember) references FamilyMember (idFamilyMember);

alter table Analysis
add column HasDeviation varchar(4) not null,/*отклонение*/
add column FileLink varchar(100) not null;

/*Удаление внешнего ключа*/
alter table `med_contract`.`familymember`
drop foreign key `familymember_ibfk_2`;
alter table `med_contract`.`familymember`
drop index `fk_idContract`;
alter table FamilyMember
drop fk_idContract;

rename table CreatureType to Creature_type;/*переименовали назвние таблицы*/
alter table Creature_type
rename column Name_cr to Name_creature;

/*----------------------------------------Модификация----------------------------------------*/

/*1. У доктора должно быть много MedicalField`ов*/
alter table `med_contract`.`doctor` /*удаляем связь доктора и его области*/
drop foreign key `doctor_ibfk_1`;
alter table `med_contract`.`doctor` 
drop index `fk_idMedicalField`;
alter table Doctor
drop fk_idMedicalField;

create table Doctor_to_MedicalField (/*создание новой таблицы многие ко многим*/
fk_idDoctor int not null,
foreign key (fk_idDoctor) references Doctor (idDoctor),
fk_idMedicalField int not null,
foreign key (fk_idMedicalField) references MedicalField (idMedicalField),
primary key (fk_idDoctor, fk_idMedicalField)
);

/*2. Соединить контракт к MedicalField`у. 3. Добавить в contract 2 даты*/

alter table Contract
add column fk_idMedicalField int not null,
add foreign key (fk_idMedicalField) references MedicalField (idMedicalField),
add column date_start date not null,
add column date_end date not null,
add check (date_end > date_start);

/*------------------------------------------------------------------------------------------*/

/*4)Добавление данных по insert*/

insert into Creature_type (Name_creature) /*тип существа*/
values
('Человек'),
('Кот(кошка)'),
('Собака(пёс)'),
('Грызун'),
('Попугай'),
('Сова'),
('Животное для С/Х');

insert into FamilyMember (FullName, DateOfBirth, fk_idCreatureType) 
values
('Петров Андрей Фёдорович', '1994-02-21', 1),
('Дмитриев Фёдор Сергеевич', '1985-07-13', 1),
('Пуся', '2015-05-05', 2),
('Бобик', '2011-03-25', 3),
('Пушок', '2017-12-31', 2),
('Хома', '2021-08-14', 4),
('Степанова Оксана Валерьевна', '1976-08-31', 1),
('Ветров Николай Петрович', '1969-03-18', 1),
('Шарик', '2011-11-11', 3),
('Никитин Данила Андреевич', '2010-10-10', 1);

insert into MedicalField (Name_mf) /*мед.область*/
values
('Хирургия'),
('Педиатрия'),
('Массаж'),
('Стоматология'),
('Травматология'),
('Психиатрия'),
('Акушерство'),
('Терапия'),
('Ветеринарное дело'),
('Ортопедия');

insert into Doctor (FullName, Contact) /*мед.область*/
values
('Никитов Сергей Александрович', 89372342233),
('Харламова Анастасия Ивановна', 89612223311),
('Дикарёва Светлана Антоновна', 89042345678),
('Степанов Данил Сергеевич', 89572343731),
('Николаев Антон Степанович', 332211),
('Волкова Валентина Викторовна', 89662222222),
('Андреева Полина Геннадьевна', 89998887766),
('Лоранова Нина Сергеевна', 676434),
('Григорьев Николай Романович', 89661230099),
('Орлов Георгий Валерьевич', 236231);

insert into Clinic (Name_cl, Phone_cl, Address) 
values
('Здоровье+', 337521, 'Пр.Ленина, 64Б'),
('Панацея', 225411, 'Ул.Мерова, 32'),
('Зубик', 323232, 'Ул.Щербакова, 64/3'),
('Поликлиника №4', 664487, 'Пр.Романова, 6'),
('Вета', 131211, 'Ул им.Павлова, 15/2'),
('Больница у Волина', 666777, 'Ул Волина, 67'),
('Вет-клиника Друг', 656232, 'Ул.Кирова, 34'),
('Здоровая спина', 123456, 'Ул.Новикова, 3'),
('Центр Ортопедии', 101010, 'Пр.Стопина, 10Б'),
('Клиника №6', 677776, 'Пр.Овалова, 60');

insert into Contract (fk_idClinic, fk_idDoctor, Position, fk_idMedicalField, date_start, date_end)/*position*/ 
values
(1, 5, 'Хирург', 1, '2022-01-21', '2022-02-01'),
(6, 3, 'Врач-акушер', 7, '2022-01-22', '2022-01-24'),
(7, 1, 'Ветеринар', 9, '2022-01-22', '2022-01-25'),
(9, 9, 'Ортопед', 10, '2022-01-23', '2022-01-26'),
(10, 8, 'Педиатр', 2, '2022-01-23', '2022-01-24'),
(4, 7, 'Врач-психолог', 6, '2022-01-25', '2022-01-26'),
(5, 2, 'Ветеринар', 9, '2022-01-26', '2022-01-28'),
(2, 10, 'Врач-педиатр', 2, '2022-01-27', '2022-01-28'),
(3, 6, 'Стоматолог', 4, '2022-01-28', '2022-01-30'),
(8, 4, 'Массажист', 3, '2022-01-29', '2022-02-01');

insert into VisitingMedicalFacility (fk_idContract, DateAndTime, Summ, fk_idFamilyMember)
values
(1, '2022-01-21 14:00:00', 50000, 1),
(2, '2022-01-22 15:30:00', 36600, 7),
(3, '2022-01-22 15:45:00', 1500, 3),
(4, '2022-01-23 12:15:00', 2500, 8),
(5, '2022-01-23 16:40:00', 2000, 10),
(6, '2022-01-25 11:00:00', 3000, 10),
(7, '2022-01-26 12:00:00', 50000, 4),
(8, '2022-01-27 13:00:00', 1200, 10),
(9, '2022-01-28 14:00:00', 5000, 1),
(10, '2022-01-29 17:00:00', 50000, 8);

insert into AnalysisType (Name_a)
value
('Общий анализ крови'),
('Анализ на Covid-19'),
('Антиоксидантный анализ'),
('Тестостерон'),
('Т3'),
('Альбумин'),
('Кальций'),
('Сахар'),
('Протеин С'),
('Мазок');

insert into ExaminationType (Name_e)
value
('Осмотр'),
('Беседа'),
('Консультация'),
('Перед операцией'),
('Перед родами');
 
insert into Medicines (Name_m, Cost, InstructionsForUse)
value
('Витамины Сева', 1300, 'Для собак. Давать до еды 2 раза в день. Смотреть возможные побочные эффекты'),
('Мазь Пепи+', 300, 'Для детей и взрослых'),
('Успокоительное', 3200, 'НЕ ПРИНИМАТЬ БОЛЕЕ 2 РАЗ В ДЕНЬ!'),
('Доктор Мом', 600, 'Для детей старше 3 лет'),
('Витамины Компливит', 720, 'Для нормализации в крови витаминов D и C'),
('Зубная паста Colgate', 500, 'От кариеса, смотреть состав химических препаратов!'),
('Димедрол', 494, 'От аллергии кошкам смотреть инструкцию!!!');

insert into Analysis (DateTakeTest, HasDeviation, FileLink, fk_idAnalysisType, fk_idVisit)
values
('2022-01-21 14:10:00', 'Нет', '%%r34%fdg000121@@1link//3', 9, 1),
('2022-01-22 15:42:00', 'Нет', '%%r341we@1link//3', 10, 2),
('2022-01-22 15:50:00', 'Да', '%1@@///1link//', 3, 3),
('2022-01-23 12:45:00', 'Нет', '%%r34%f///enk//3', 4, 4),
('2022-01-23 16:55:00', 'Нет', '%%r%%%34%f/dlink@%%//3', 5, 5),
('2022-01-25 11:11:00', 'Да', '%%r34%f5ffgfdfsdffd/fdsds121k/3', 6, 6);

insert into MedicalReport (Diagnosis, FileLink, fk_idExaminationType, fk_idMedicalField, fk_idVisit)
values
('Операция с минимальным риском', '3453//%%34$$red34', 5, 1, 1),
('Беременна', '3453//%%3%%$@$%4$$r4link///e5t43terterregtd34', 4, 7, 2),
('Помехи дыхательных путей', '3453//%\222133link//2link//%3$r33erwee', 1, 9, 3);

insert into Prescription (DurationOfAdmission, AdmissionStartDate, Dosage, fk_idMedicines, fk_idReport)
values
(4, '2022-01-21', 100, 3, 1),
(3, '2022-01-22', 300, 5, 2),
(5, '2022-01-22', 200, 1, 3);
 

 