DROP TABLE IF EXISTS likes, dislikes, admins, sales, stores, products, subcategories, categories, users; 

CREATE OR REPLACE TABLE stores (
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    sale_exists SMALLINT UNSIGNED DEFAULT 0,
	lat FLOAT(9,7),
	lon FLOAT(9,7),
    name VARCHAR(40),
    PRIMARY KEY (id)
) ENGINE=INNODB ;

CREATE OR REPLACE TABLE categories (
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR (80),
    PRIMARY KEY ( id )
) ENGINE=INNODB ;

CREATE OR REPLACE TABLE subcategories (
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    categories_id TINYINT UNSIGNED,
    name VARCHAR (80),
    PRIMARY KEY ( id ),
    CONSTRAINT sub_in_categories FOREIGN KEY (categories_id) REFERENCES categories(id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=INNODB ;

CREATE OR REPLACE TABLE products (
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(100),
    subcategories_id TINYINT UNSIGNED DEFAULT 0,
    avgprice_yesterday FLOAT(4,2) UNSIGNED NOT NULL DEFAULT 0,
    avgprice_lastweek FLOAT(4,2) UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY ( id ),
    CONSTRAINT product_in_subcategory FOREIGN KEY ( subcategories_id ) REFERENCES subcategories(id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=INNODB ;

CREATE OR REPLACE TABLE users (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    username VARCHAR (25) NOT NULL, 
    passwd VARCHAR (250) NOT NULL,
    email VARCHAR (40) NOT NULL,
    sum_score INT NOT NULL DEFAULT 0,
    sum_tokens INT NOT NULL  DEFAULT 0,
    monthly_score INT NOT NULL DEFAULT 0,
    monthly_tokens INT NOT NULL DEFAULT 0,
    PRIMARY KEY ( id ),
    UNIQUE (email),
	UNIQUE (username)
) ENGINE=INNODB ;

CREATE OR REPLACE TABLE admins (
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    users_id INT UNSIGNED NOT NULL,
    PRIMARY KEY ( id ),
    CONSTRAINT user_for_admin FOREIGN KEY (users_id) REFERENCES users(id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=INNODB ;

CREATE OR REPLACE TABLE sales (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    store_id SMALLINT UNSIGNED NOT NULL,
    product_id SMALLINT UNSIGNED NOT NULL,
    price FLOAT(4,2) UNSIGNED NOT NULL DEFAULT 0,
    stock TINYINT(1) DEFAULT 1,
    active TINYINT(1) DEFAULT 0,
    date_created DATE NOT NULL,
    likes_num INT UNSIGNED NOT NULL,
    dislikes_num INT UNSIGNED NOT NULL,
    user_suggested INT UNSIGNED,
    criteria_ok TINYINT(1),
    PRIMARY KEY ( id ),
    CONSTRAINT sale_in_store FOREIGN KEY (store_id) REFERENCES stores(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT sale_for_product FOREIGN KEY (product_id) REFERENCES products(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT sale_upby FOREIGN KEY (user_suggested) REFERENCES users(id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=INNODB ;

CREATE OR REPLACE TABLE dislikes (
    id INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    sales_id INT UNSIGNED NOT NULL,
    user_disliked INT UNSIGNED,
    PRIMARY KEY(id),
    CONSTRAINT sales_id_for_dislike FOREIGN KEY (sales_id) REFERENCES sales(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT dislike_by FOREIGN KEY (user_disliked) REFERENCES users(id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=INNODB ;

CREATE OR REPLACE TABLE likes(
    id INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    sales_id INT UNSIGNED NOT NULL,
    user_liked INT UNSIGNED,
    PRIMARY KEY(id),
    CONSTRAINT sales_id_for_like FOREIGN KEY (sales_id) REFERENCES sales(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT like_by FOREIGN KEY (user_liked) REFERENCES users(id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=INNODB ;
