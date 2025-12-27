drop table if exists Books;

create table Books(
	Book_id serial primary key,
	title varchar(100) not null,
	author varchar(100),
	genre varchar(100),
	published_year date,
	price numeric(10,2),
	stock numeric(10,2)
);

select * from Books;

drop table if exists Customers;

create table Customers(
	Customer_id serial primary key,
	Name varchar(100) not null,
	Email varchar(100) not null,
	Phone varchar(15),
	City varchar(100),
	Country varchar(100)
);

select * from Customers;

drop table if exists Orders;

create table Orders(
	Order_id serial primary key,
	Customer_id int references Customers(Customer_id),
	Book_id int references Books(Book_id),
	Order_Date Date,
	Quantity int,
	Total_Amonut numeric(10,2)
);

select * from Orders;
----------------BASIC QUERIES-----------------
--1) Retreive all books in the 'Fiction' genre
select *
from Books
where genre='Fiction';

--2)Find books published after the year 1950
select * from Books
where published_year>1950;

--3)List all the Customers from Canada
select name from Customers
where country='Canada';

--4) Show orders placed in november 2023
select * from Orders 
where order_date>'2023-11-01' and order_date<'2023-11-30';

--5)Retrieve the total stocks of the book available
select sum(stock) as Total_Stock
from Books;

--6)Find the details of the most expensive book
select * from books
order by price desc 
limit 1;

--7)Show all the customers who order more then 1 quantity of a book
select customer_id, quantity
from orders 
where quantity>1;

--8)Retrieve all the orders where the total amount exceeds $20
select * from orders
where total_amonut>20;

--9)List all the genres available in the books table
select distinct genre from books;

--10)Find the book with the lowest stock
select * from books
order by stock asc 
limit 1;

--11)Calculate the total revenue generated from all the orders
select sum(Total_Amonut) as total_revenue
from orders;

----------------ADVANCE QUERIES-----------------

--1)Retreive the total number of books sold for each genre
select b.genre, sum(o.quantity) as total_books_sold
from orders o
join
books b 
on o.book_id=b.book_id
group by b.genre;

--2)Find the avg price of books in the 'Fantasy' genre
select avg(price) as avg_price_of_fantasy
from books
where genre='Fantasy';

--3)List customers who have placed atleast 2 ordes
select customer_id, count(order_id) as Order_Count
from orders 
group by customer_id
having count(order_id)>=2;

--OR--

select c.name, o.customer_id,
count(o.order_id) as Order_Count
from orders o
join 
customers c
on o.customer_id=c.customer_id
group by o.customer_id, c.name
having count(o.order_id)>=2;

--4)Find the most frequently ordered book
select book_id, count(order_id) order_count
from orders
group by book_id
order by order_count desc
limit 1;

select o.book_id, b.title, count(o.order_id) as order_count
from orders o
join
books b
on o.book_id=b.book_id
group by o.book_id, b.title
order by order_count desc
limit 1;

--5)Show the top 3 most expensive books of 'Fantasy' genre
select *
from books
where genre='Fantasy'
order by price desc
limit 3;

--4)Retrieve the total quantity of books sold by each author
select b.book_id, b.author, sum(o.quantity) as Total_Quantity
from orders o
join
books b
on b.book_id=o.book_id
group by b.book_id, b.author;

--7)List the cities where the customers have spent over $30 are located
select c.customer_id, c.city, o.total_quantity
from customers c
join
orders o
on c.customer_id=o.customer_id
where o.total_quantity>30;

SELECT  c.customer_id, c.city, o.Total_Amonut
FROM customers c
JOIN
orders o
ON c.customer_id = o.customer_id
WHERE o.Total_Amonut > 30
order by c.city asc;

--8)Find the customer who spent the most on orders
select c.customer_id, c.name, sum(o.Total_Amonut) as Total_Spent
from orders o
join
customers c 
on o.customer_id=c.customer_id
group by c.customer_id, c.name
order by Total_Spent desc limit 1;

--9)Calculate the stock remainning after fulfilling all orders
select b.book_id, b.title, b.stock, coalesce((sum(o.quantity),0)) as order_quantity,
b.stock - COALESCE(SUM(o.quantity), 0) as Remaining_Quantity
from books b
left join 
orders o
on b.book_id = o.book_id
group by b.book_id 
order by b.book_id;

--------------------------------------END OF PROJECT-----------------------------------