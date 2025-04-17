-- Database Query --

-- Create new Database -- 
create database ecommerce;

-- Use database -- 
use ecommerce;

-- Creating new customers Table
create table customers(
id int  Not Null auto_increment primary key,
name varchar(20) not null,
email varchar (30) not null unique ,
address varchar(250) not null
);

-- Insert the Values into Customers Table

insert into customers(name,email,address)
values("Pradeep","pradeep1210@gamil.com","541 Anna Nagar, Chennai"),
("Thanvika", "thanvika6754@gmail.com","543 NW Street,Bentonville"),
("Magizhan","magizhan6745@gmail.com","341 Gandhi Street,Coimbatore"),
("Priya","priya2578@gmail.com","78 Nehru Street,Salem");

select * from customers;

-- Creating new table for orders
create table orders(
id int not null auto_increment primary key,
customer_id int not null,
order_date  date not null ,
total_amount int not null,
foreign key(customer_id) references customers (id)
);

-- Insert the Values into Orders Table
insert into orders (customer_id, order_date, total_amount)
values(1,"2025-03-15", 4000),
(2,"2025-03-20", 5000),
(3,"2025-03-26", 7000),
(4,"2025-04-15", 9000);

select * from orders;

-- Creating new table for products
create table products(
id int  auto_increment  not null primary key,
product_name varchar(245) not null, 
product_price int not null, 
product_description varchar(240) not null );

-- Insert the Values into Products Table
insert into products (product_name, product_price, product_description)
values("product A", 300,"The product A is less price"),
("product B", 400, "The product B is Medium price"),
("product C", 500, "The product C is High price");

select * from products;

-- Query

-- 1. Retrieve all customers who have placed an order in the last 30 days.
select a.order_date, b.name, b.email,  a.total_amount from orders a
left join customers b 
on a.customer_id = b.id
where a.order_date >= (curdate() - interval 1 month);

-- 2. Get the total amount of all orders placed by each customer.
select c.id, c.name ,sum(o.total_amount) as total_spent
from customers c
join orders o 
on c.id=o.customer_id
group by c.id,c.name;

-- 3. Update the price of Product C to 45.00.
SET SQL_SAFE_UPDATES = 0;
update products 
set product_price = 45 
where product_name  ="product C";

-- 4. Add a new column discount to the products table.
alter table products
add discount int not null;

-- 5. Retrieve the top 3 products with the highest price.
select * from products 
order by product_price desc
limit 3;

-- 6. Get the names of customers who have ordered Product A
select c.name from customers c
left join products p 
on c.id=p.id
where p.product_name = "product A";

-- 7. Join the orders and customers tables to retrieve the customer's name and order date for each order. 
select c.name, o.order_date, o.id as order_id, o.total_amount from customers c
join orders o
on  c.id = o.id;

-- 8. Retrieve the orders with a total amount greater than 150.00
select product_name ,product_price from products p
where product_price>150;

-- 9. Normalize the database by creating a separate table for order items and updating the orders table to reference the order_items table.
-- create order items table
create table order_items(
order_id int not null,
item_id int not null,
item_quantity int default 1,
primary key(order_id, item_id), -- Composite key for unique order-item combinations
foreign key(order_id) references orders (id), -- Foreign key to Orders table
foreign key(item_id) references products (id) -- Foreign key to Products table
);

-- delete total_amount column from orders table
alter table orders
drop column total_amount;


-- Insert the Values into Orders Table
insert into order_items (order_id, item_id,item_quantity )
values(1, 1, 6),
(1, 2, 3),
(1, 3, 2),
(2, 3, 10),
(3, 1, 10),
(3, 2, 10),
(4, 2, 10),
(4, 3, 10);


-- Calculate item price using product price and item quantity
select oi.order_id, oi.item_id, oi.item_quantity, p.product_price*oi.item_quantity as item_total_price
from order_items oi
left join products p
on oi.item_id = p.id;

-- 10. Retrieve the average total of all orders.
select oi.order_id, AVG(p.product_price * oi.item_quantity) as order_total_price
from order_items oi
join products p ON oi.item_id = p.id
group by oi.order_id;
