CREATE TABLE IF NOT EXISTS category
(
    id                 BIGSERIAL PRIMARY KEY,
    parent_category_id BIGINT REFERENCES category (id),
    name VARCHAR(200) NOT NULL,
    description               TEXT NOT NULL UNIQUE
);


CREATE TABLE IF NOT EXISTS product
(
    id          BIGSERIAL PRIMARY KEY,
    name        VARCHAR(200)  NOT NULL,
    description VARCHAR(1000) NOT NULL,
    count       INTEGER       NOT NULL DEFAULT 0,
    price       BIGINT        NOT NULL,
    discount    INT           NOT NULL DEFAULT 0
);


CREATE TABLE IF NOT EXISTS product_photo
(
    id   BIGSERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    path VARCHAR(200) NOT NULL
);

CREATE TABLE IF NOT EXISTS product_photo2product
(
    id         BIGSERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL REFERENCES product (id),
    photo_id   BIGINT NOT NULL REFERENCES product_photo (id)
);


CREATE TABLE IF NOT EXISTS characteristic
(
    id          BIGSERIAL PRIMARY KEY,
    name        VARCHAR(200)  NOT NULL,
    description VARCHAR(1000) NOT NULL
);

CREATE TABLE IF NOT EXISTS characteristic2product
(
    id                BIGSERIAL PRIMARY KEY,
    product_id        BIGINT NOT NULL REFERENCES product (id),
    characteristic_id BIGINT NOT NULL REFERENCES characteristic (id)
);

CREATE TABLE IF NOT EXISTS category2product
(
    id          BIGSERIAL PRIMARY KEY,
    product_id  BIGINT NOT NULL REFERENCES product (id),
    category_id BIGINT NOT NULL REFERENCES category (id)
);

CREATE TABLE IF NOT EXISTS users
(
    id       BIGSERIAL PRIMARY KEY,
    name     VARCHAR(255) NOT NULL,
    contact  VARCHAR(255) NOT NULL,
    address  VARCHAR(255) NOT NULL,
    registration_time TIMESTAMP    NOT NULL
);

CREATE TABLE IF NOT EXISTS orders
(
    id           BIGSERIAL PRIMARY KEY,
    user_id      BIGINT    NOT NULL REFERENCES users (id),
    payment_time TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS orders2product
(
    id         BIGSERIAL PRIMARY KEY,
    order_id    BIGINT  NOT NULL REFERENCES orders (id),
    amount     INTEGER NOT NULL,
    product_id BIGINT  NOT NULL REFERENCES product (id),
    CONSTRAINT unique_product UNIQUE (order_id, product_id)
);