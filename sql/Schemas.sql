-- Creating Tables

DROP TABLE IF EXISTS city;
Create Table city (
	city_id int PRIMARY KEY,
	city_name VARCHAR(15),
	population BIGINT,
	estimated_rent FLOAT,
	city_rank INT
);

DROP TABLE IF EXISTS customers;
Create Table customers(
	customer_id int PRIMARY KEY,
	customer_name VARCHAR(25),
	city_id INT,
	CONSTRAINT fk_city FOREIGN KEY (city_id) REFERENCES city(city_id)
);

DROP TABLE IF EXISTS products;
Create Table products(
	product_id int PRIMARY KEY,
	product_name VARCHAR(35),
	price float
);

DROP TABLE IF EXISTS sales;
Create Table sales(
	sale_id int primary key,
	sale_date date,
	product_id int,
	customer_id int,
	total float,
	rating int,
	CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES products(product_id),
	CONSTRAINT fk_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
	
);
	
