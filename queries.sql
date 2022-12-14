-- Самые популярные товары в ценовом диапазоне
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

-- Самые дорогие закупки у клиентов
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

-- Товары с самым большим описанием
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

-- Топ популярных товаров с названием похожим на _______
SELECT p.id, p.name, description, count, price, discount
FROM product p
         INNER JOIN orders2product o2p on p.id = o2p.product_id
WHERE p.name LIKE '%Mushroom%'
GROUP BY p.id
ORDER BY count(o2p.product_id)
LIMIT 5;

-- Топ самых дорогих категорий
SELECT c.id, c.name, avg(p.price) as avg_price
FROM category2product c2p
         INNER JOIN category c on c.id = c2p.category_id
         INNER JOIN product p on p.id = c2p.product_id
GROUP BY c.id
ORDER BY avg_price
LIMIT 5;