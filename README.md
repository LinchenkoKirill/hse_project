# hse_project
sql 

# Онлайн магазин всего и всякого

## Выполнили
* Линченко Кирилл
* Границын Михаил

## Схема бд
<img src="https://github.com/LinchenkoKirill/hse_project/raw/main/assets/category.png" width="700">


## Запросы
### 1) Самые популярные товары в ценовом диапазоне
```sql
SELECT p.id,
       p.name,
       p.price,
       (p.price * (100 - p.discount) / 100) as price_with_discount,
       count(o2p.product_id)                as buy_count
FROM orders2product o2p
         INNER JOIN product p on p.id = o2p.product_id
WHERE p.price > 5000
  AND p.price < 20000
GROUP BY p.id
ORDER BY buy_count DESC
LIMIT 5;
```
### Результат
|id |name                         |price|price_with_discount|buy_count|
|---|-----------------------------|-----|-------------------|---------|
|220|Pasta - Agnolotti - Butternut|17132|13362              |4        |
|177|The Pop Shoppe - Root Beer   |6327 |5377               |3        |
|87 |Bread - Roll, Italian        |13250|11130              |3        |
|107|Lychee - Canned              |10756|10756              |3        |
|242|Pepper - White, Whole        |9499 |8834               |3        |

### 2) Кто разово оставил наибольшую сумму
```sql
SELECT o.id,
       o.payment_time,
       u.name,
       u.address,
       sum(p.price)                            as sum_of_price,
       sum(p.price * (p.discount) / 100)       as sum_of_discount,
       sum(p.price * (100 - p.discount) / 100) as final_sum
FROM orders2product o2p
         INNER JOIN product p on p.id = o2p.product_id
         INNER JOIN orders o on o.id = o2p.order_id
         INNER JOIN users u on u.id = o.user_id
GROUP BY o.id, u.id
ORDER BY final_sum DESC
LIMIT 5;
```
### Результат
|id |payment_time                 |name |address|sum_of_price|sum_of_discount|final_sum|
|---|-----------------------------|-----|-------|------------|---------------|---------|
|13 |2022-06-04 10:24:26.000000   |Kattie Hammand|22431 Manitowish Place|547031      |54624          |492397   |
|19 |2022-01-19 22:22:19.000000   |Jameson Blackburne|84 Schlimgen Circle|494693      |61850          |432834   |
|1  |2022-09-28 22:55:36.000000   |Cad Ottewell|7279 Lotheville Park|467743      |48656          |419078   |
|36 |2022-03-13 13:57:33.000000   |Jedidiah Hosten|64 Ramsey Circle|477015      |62782          |414224   |
|46 |2022-07-14 16:17:06.000000   |Cornie Moyer|83 Mallory Hill|463602      |66563          |397031   |


### 3) Товары с самым большим описанием
```sql
SELECT p.id, p.name, m.count_of_photo, m.count_of_characteristic
FROM (SELECT p.id,
             (SELECT count(pp2p.photo_id)
              FROM product_photo2product pp2p
              WHERE pp2p.product_id = p.id)         as count_of_photo,
             (SELECT count(c2o.characteristic_id)
              FROM characteristic2product c2o
              WHERE c2o.product_id = p.id)  as count_of_characteristic
      FROM product p) as m
         INNER JOIN product p ON p.id = m.id
ORDER BY m.count_of_characteristic + m.count_of_photo DESC
LIMIT 5;
```
### Результат
|id |name                         |count_of_photo|count_of_characteristic|
|---|-----------------------------|--------------|-----------------------|
|57 |Soup - Campbells - Chicken Noodle|2             |6                      |
|43 |Juice - Orange, 341 Ml       |3             |5                      |
|254|Cheese - Parmesan Cubes      |0             |7                      |
|71 |Liners - Banana, Paper       |4             |3                      |
|96 |Cheese - Valancey            |3             |3                      |


### 4) Топ популярных товаров с названием похожим на _______
```sql
SELECT p.id, p.name, description, count, price, discount
FROM product p
         INNER JOIN orders2product o2p on p.id = o2p.product_id
WHERE p.name LIKE '%Mushroom%'
GROUP BY p.id
ORDER BY count(o2p.product_id)
LIMIT 5;
```
### Результат
|id |name                         |description|count|price|discount|
|---|-----------------------------|-----------|-----|-----|--------|
|111|Mushroom - Lg - Cello        |Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.  Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.|79   |12524|6       |
|144|Mushroom - Oyster, Fresh     |Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.  In congue. Etiam justo. Etiam pretium iaculis justo.|22   |49865|25      |
|235|Soup - Campbells Mushroom    |Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.|12   |48448|22      |
|97 |Mushroom - Enoki, Fresh      |Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.  In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.|34   |75734|5       |
|280|Mushroom - Chanterelle, Dry  |Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.  Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.|30   |28028|8       |


### 5) Топ самых дорогих категорий
```sql
SELECT c.id, c.name, avg(p.price) as avg_price
FROM category2product c2p
         INNER JOIN category c on c.id = c2p.category_id
         INNER JOIN product p on p.id = c2p.product_id
GROUP BY c.id
ORDER BY avg_price
LIMIT 5;
```
### Результат
|id |name                         |avg_price|
|---|-----------------------------|---------|
|52 |Retaining Wall and Brick Pavers|20828    |
|20 |Termite Control              |22689    |
|46 |Soft Flooring and Base       |22844    |
|70 |Casework                     |25511.5  |
|73 |Elevator                     |28559    |


### 6) Какую категорию товара чаще всего заказывают с 1 по 10 января
```sql
SELECT o2p.id,
       o.payment_time,
       o2p.amount,
       o2p.product_id
FROM orders2product o2p
    INNER JOIN orders o ON o.id = o2p.order_id
WHERE payment_time between '2022-01-01' AND '2022-01-10'
GROUP BY o2p.id, o.payment_time
ORDER BY max(amount)    DESC
LIMIT 5;
```
### Результат
|id |payment_time                 |amount   |product_id|
|---|-----------------------------|---------|----------|
|291|2022-01-04 00:53:39.000000   |5        |210       |
|9  |2022-01-04 00:53:39.000000   |5        |191       |
|381|2022-01-07 15:56:55.000000   |4        |158       |
|366|2022-01-04 00:53:39.000000   |4        |168       |
|395|2022-01-07 15:56:55.000000   |4        |65        |


### 7) В какое время чаще всего пользователи заказывают
```sql
SELECT count(payment_time) as cnt,
       CASE
           WHEN date_part('hour', payment_time::TIMESTAMP) >= 0 and date_part('hour', payment_time::TIMESTAMP) < 6 THEN 1
            WHEN date_part('hour', payment_time::TIMESTAMP) >= 6 and date_part('hour', payment_time::TIMESTAMP) < 12 THEN 2
            WHEN date_part('hour', payment_time::TIMESTAMP) >= 12 and date_part('hour', payment_time::TIMESTAMP) < 18 THEN 3
            WHEN date_part('hour', payment_time::TIMESTAMP) >= 18 and date_part('hour', payment_time::TIMESTAMP) <= 23 THEN 4
        END as quarter
FROM orders
GROUP BY quarter
ORDER BY cnt   DESC;
```
### Результат
|cnt|quarter|
|---|-------|
|19 |2      |
|17 |3      |
|14 |4      |
|10 |1      |


### 8) В какой месяц меньше всего регистраций
```sql
SELECT count(registration_time) as cnt_regist,
       CASE
           WHEN date_part('month', registration_time::TIMESTAMP) = 1 THEN 1
           WHEN date_part('month', registration_time::TIMESTAMP) = 2 THEN 2
           WHEN date_part('month', registration_time::TIMESTAMP) = 3 THEN 3
           WHEN date_part('month', registration_time::TIMESTAMP) = 4 THEN 4
           WHEN date_part('month', registration_time::TIMESTAMP) = 5 THEN 5
           WHEN date_part('month', registration_time::TIMESTAMP) = 6 THEN 6
           WHEN date_part('month', registration_time::TIMESTAMP) = 7 THEN 7
           WHEN date_part('month', registration_time::TIMESTAMP) = 8 THEN 8
           WHEN date_part('month', registration_time::TIMESTAMP) = 9 THEN 9
           WHEN date_part('month', registration_time::TIMESTAMP) = 10 THEN 10
           WHEN date_part('month', registration_time::TIMESTAMP) = 11 THEN 11
           WHEN date_part('month', registration_time::TIMESTAMP) = 12 THEN 12
        END as month
FROM users
GROUP BY month
ORDER BY cnt_regist
LIMIT 1 ;
```
### Результат
|cnt_regist|month|
|----------|-----|
|5         |6    |


