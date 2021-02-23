/*Задание 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными.
 Заполните их текущими датой и временем.*/

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  created_at  date,
  updated_at date
) ;

INSERT INTO users (name) VALUES
  ('Геннадий'),
  ('Наталья');

update users set created_at=now() where created_at is null;
update users set updated_at=now() where updated_at is null;

/*Задание 2 Таблица users была неудачно спроектирована. 
Записи created_at и updated_at были заданы типом VARCHAR
и в них долгое время помещались значения в формате "20.10.2017 8:10". 
Необходимо преобразовать поля к типу DATETIME, 
сохранив введённые ранее значения.*/

DROP TABLE IF EXISTS users_2;
CREATE TABLE users_2 (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  created_at  varchar(20),
  updated_at varchar(20)
) ;

INSERT INTO users_2 (name, created_at, updated_at) VALUES
  ('Геннадий', '20.10.2018 8:10', '20.10.2018 8:10'),
  ('Наталья', '22.11.2017 10:10', '20.11.2019 12:10'),
  ('Александр', '14.05.2019 11:10', '20.10.2019 8:10');
  
  SELECT * FROM users_2;
  alter table users_2 add created_at_new datetime;
  SELECT DATE_FORMAT(STR_TO_DATE(created_at, "%d.%m.%Y %h:%i"), "%Y-%m-%d %h:%i:%s") FROM users_2;
  update users_2 set created_at = DATE_FORMAT(STR_TO_DATE(created_at, "%d.%m.%Y %h:%i"), "%Y-%m-%d %h:%i:%s");
  alter table users_2 modify created_at datetime;
  
  alter table users_2 add updated_at_new datetime;
  SELECT DATE_FORMAT(STR_TO_DATE(updated_at, "%d.%m.%Y %h:%i"), "%Y-%m-%d %h:%i:%s") FROM users_2;
  update users_2 set updated_at = DATE_FORMAT(STR_TO_DATE(updated_at, "%d.%m.%Y %h:%i"), "%Y-%m-%d %h:%i:%s");
  alter table users_2 modify updated_at datetime;
  
/*Задание 3. В таблице складских запасов storehouses_products в поле value могут встречаться 
самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. 
Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
Нулевые запасы должны выводиться в конце, после всех записей.*/   
 
 DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе'
) COMMENT = 'Запасы на складе';

INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES 
(1,2,0), (2,2,5), (5,4,7), (5,2,8), (7,1,10), (9,1,0), (3,9,0), (4,7,2);
SELECT id, storehouse_id, product_id, value FROM storehouses_products;
SELECT * FROM storehouses_products ORDER BY value = 0, value;

/*Задание 4. Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
Месяцы заданы в виде списка английских названий ('may', 'august')*/
DROP TABLE IF EXISTS users_3;
CREATE TABLE users_3 (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  birthday_at date
) ;
INSERT INTO users_3 (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');
  
  SELECT * FROM users_3;
  SELECT *, MONTHNAME(birthday_at) as monthname FROM users_3;
  SELECT *, MONTHNAME(birthday_at) as monthname FROM users_3 WHERE MONTHNAME(birthday_at) in ('may','august');

/*Задание 5. Из таблицы catalogs извлекаются записи при помощи запроса. 
SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.*/
DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела'
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs (name) VALUES
  ('Гарнитуры игровые'), ('Вебкамеры'), ('Клавиатуры'),
  ('Мыши игровые'), ('Сетевые фильтры'), ('Коммутаторы'),
  ('Картридеры'), ('Акустические колонки');
  
SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD (id, 5, 1, 2);



DROP TABLE IF EXISTS users_4;
CREATE TABLE users_4 (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  birthday_at date
) ;
INSERT INTO users_4 (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29'),
  ('Светлана', '1988-02-04'),
  ('Олег', '1998-03-20'),
  ('Юлия', '2006-07-12');
  
  /*Задание 6. Подсчитайте средний возраст пользователей в таблице users.*/.
  select avg(timestampdiff(year, birthday_at, curdate())) from users_4;
  
   /*Задание 7. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
   Следует учесть, что необходимы дни недели текущего года, а не года рождения. */
  select date_format(str_to_date(date_format(birthday_at, concat(date_format(curdate(),"%Y"),"-%m-%d")), "%Y-%m-%d"), "%W"), 
  count(*) from users_4
  group by date_format(str_to_date(date_format(birthday_at, concat(date_format(curdate(),"%Y"),"-%m-%d")), "%Y-%m-%d"), "%W");
  
  /* Задание 8. Подсчитайте произведение чисел в столбце таблицы*/
  select EXP(SUM(LOG(id)))  from users_4;
  
  
  DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела'
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (DEFAULT, 'Процессоры'),
  (DEFAULT, 'Мат.платы'),
  (DEFAULT, 'Видеокарты'),
  (DEFAULT, 'Жестк.диски'),
  (DEFAULT, 'Оперативн.память');
  
  SELECT * FROM catalogs;
  
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at date COMMENT 'Дата рождения'
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29'),
  ('Светлана', '1988-02-04'),
  ('Олег', '1998-03-20'),
  ('Юлия', '2006-07-12');
  
  SELECT * FROM users;
     
DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  description TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id(catalog_id)
) COMMENT = 'Товарные позиции';

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);
SELECT * FROM products;

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED
) COMMENT = 'Заказы';
SELECT * FROM orders;

INSERT INTO orders
 (user_id) VALUES 
 (2), (4), (8), (7), (7),(2), (3), (5), (2);

/* Задание 9. Составьте список пользователей users, которые осуществили хотя бы один заказ (orders) в интернет-магазине*/
SELECT   u.name  
FROM   users AS u
RIGHT JOIN   orders AS o ON  u.id = o.user_id;
  
/* Задание 10 Выведите список товаров products и разделов catalogs, который соответствует товару*/
SELECT c.name, p.name
FROM catalogs AS c
INNER JOIN products AS p ON (p.catalog_id = c.id);


CREATE TABLE IF NOT EXISTS flights (
 	id SERIAL PRIMARY KEY,
 	`from` VARCHAR(50) NOT NULL COMMENT 'en', 
	`to` VARCHAR(50) NOT NULL COMMENT 'en'
);

 CREATE TABLE  IF NOT EXISTS cities (
 	label VARCHAR(50) PRIMARY KEY COMMENT 'en', 
	name VARCHAR(50) COMMENT 'ru'
 );

 INSERT INTO cities VALUES
	('Moscow', 'Москва'),
    ('Irkutsk', 'Иркутск'),
    ('Novgorod' ,'Новгород'),
    ('Kazan', 'Казань'),
    ('Omsk' ,'Омск');
    
 INSERT INTO flights VALUES
	(NULL, 'moscow', 'omsk'),
    (NULL, 'novgorod', 'kazan'),
    (NULL, 'irkutsk', 'moscow'),
    (NULL, 'omsk', 'irkutsk'),
    (NULL, 'moscow', 'kazan');
	
SELECT * FROM  flights;
SELECT * FROM cities;

/* Задание 11 Есть таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов (flights) с русскими названиями городов.*/
select f.id, cf.name, ct.name from flights f 
									 join cities cf on f.from = cf.label
								     join cities ct on f.to = ct.label;


/* Задание 12. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".*/
DROP FUNCTION IF EXISTS hello;
DELIMITER //
CREATE FUNCTION hello ()
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
  declare hour int;
  declare result VARCHAR(255);
  set hour =  date_format(now(),'%H');   
 IF (hour >= 0 and hour < 6) then set result = 'Доброй ночи';
	 ELSEIF (hour >= 6 and hour < 12) then set result = 'Доброе утро';
	 ELSEIF (hour >= 12 and hour < 18) then set result = 'Добрый день';
	 ELSEIF (hour >= 18 and hour < 24) then set result = 'Добрый вечер';
 END IF;
RETURN result;
END//

DELIMITER ;

select  now(), hello();

/* Задание 13. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо присутствие обоих полей или одно из них. 
Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию */
DROP TRIGGER IF EXISTS products_ins_before;
delimiter // 
create trigger products_ins_before before insert on products
for each row
begin
  if (new.description is null AND new.name is null) then
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Нужно заполнить name или description';
  end if;
end //
DELIMITER  ;

insert into products (name, description) values (null, 'Описание');
insert into products (name, description) values (null, null);
    

  
  
  