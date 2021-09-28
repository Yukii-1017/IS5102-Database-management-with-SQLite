-- Following is task for IS5102
-- 200024763
-- 2020.11.4

-- The code can be divided into three parts: 
-- Firstly, create tables; 
-- then insert data; 
-- finally queries. 
PRAGMA foreign_keys = TRUE;

-- PART ONE: CREATE TABLES
-- table one: Customers
CREATE TABLE Customers (
    customer_id            VARCHAR(20), 
    customer_name          VARCHAR(70) NOT NULL,
    email                  VARCHAR(320),
    street_customer_addr   VARCHAR(100),
    city_customer_addr     VARCHAR(100),
    postcode_customer_addr VARCHAR(10),
    country_customer_addr  VARCHAR(60),
    PRIMARY KEY (customer_id)
    );

-- table two: Books
CREATE TABLE Books (
    book_id   VARCHAR(20),
    title     VARCHAR(100) NOT NULL,
    author    VARCHAR(100) NOT NULL,
    publisher VARCHAR(100) NOT NULL,
    PRIMARY KEY (book_id)
);

-- table three: Orders
CREATE TABLE Orders(
    order_id               VARCHAR(20),
    customer_id            VARCHAR(20),
    street_delivery_addr   VARCHAR(100) NOT NULL,
    city_delivery_addr     VARCHAR(100) NOT NULL,
    postcode_delivery_addr VARCHAR(10) NOT NULL,
    country_delivery_addr  VARCHAR(60) NOT NULL,
    date_ordered           TIMESTAMP,
    date_delivered         TIMESTAMP,
    PRIMARY KEY (order_id, customer_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- table four: Book_Editions
CREATE TABLE Book_Editions(
    book_id            VARCHAR(20),
    book_edition       VARCHAR(40),
    book_edition_type  VARCHAR(40) CHECK (book_edition_type = "Paperback" OR book_edition_type = "Audiobook" OR book_edition_type = "Hardcover") ,
    book_edition_price FLOAT(2) NOT NULL CHECK (book_edition_price >= 0) DEFAULT 0,
    quantity_in_stock  SMALLINT NOT NULL CHECK (quantity_in_stock >= 0)  DEFAULT 0, 
    PRIMARY KEY (book_id, book_edition, book_edition_type),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);
    -- not support by SQLite
        -- CREATE DOMAIN book_edition_type VARCHAR (40)
        -- CONSTRAINT book_edition_type_domain
        -- CHECK (VALUE IN ("Paperback", "Audiobook", "Hardcover"));

-- table five: Suppliers
CREATE TABLE Suppliers(
    supplier_id   VARCHAR(20),
    supplier_name VARCHAR(40) NOT NULL,
    account_no    INTEGER(5) UNIQUE CHECK (account_no > 0),
    PRIMARY KEY (supplier_id)
    );

-- table six: Customer_Book_Reviews
CREATE TABLE Customer_Book_Reviews(
    customer_id VARCHAR(20),
    book_id     VARCHAR(20),
    rating      VARCHAR(400),
    PRIMARY KEY (customer_id, book_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (book_id)     REFERENCES Books(book_id)
    ON DELETE CASCADE ON UPDATE CASCADE
    );

-- table seven: Order_Edition_Contains
CREATE TABLE Order_Edition_Contains (
    order_id          VARCHAR(20),
    customer_id       VARCHAR(20),
    book_id           VARCHAR(20),
    book_edition      VARCHAR(40),
    book_edition_type VARCHAR(40),
    PRIMARY KEY (order_id, customer_id, book_id, book_edition, book_edition_type), 
    FOREIGN KEY (order_id, customer_id)                    REFERENCES Orders(order_id, customer_id),
    FOREIGN KEY (book_edition, book_edition_type, book_id) REFERENCES Book_Editions(book_edition, book_edition_type, book_id)
    ON DELETE CASCADE ON UPDATE CASCADE
    );

-- table eight: Edition_Supplier_Supplies
CREATE TABLE Edition_Supplier_Supplies(
    supplier_id       VARCHAR(20),
    book_id           VARCHAR(20),
    book_edition      VARCHAR(40),
    book_edition_type VARCHAR(40) DEFAULT "Paperback",
    supply_price      FLOAT(2) NOT NULL CHECK (supply_price >= 0) DEFAULT 0,
    PRIMARY KEY (supplier_id, book_id, book_edition, book_edition_type),
    FOREIGN KEY (book_id, book_edition, book_edition_type) REFERENCES Book_Editions(book_id, book_edition, book_edition_type),
    FOREIGN KEY (supplier_id)                              REFERENCES Suppliers(supplier_id)
    ON DELETE CASCADE ON UPDATE CASCADE
    );

-- table nine: Customer_Phones
CREATE TABLE Customer_Phones (
    customer_id           VARCHAR(20),
    number_customer_phone VARCHAR(50), 
    -- the type_customer_phone idea is referenced from: https://ux.stackexchange.com/questions/86651/proper-term-for-phone-type
    type_customer_phone   VARCHAR(30),
    PRIMARY KEY (customer_id, number_customer_phone),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
    ON DELETE CASCADE ON UPDATE CASCADE
    );

-- table ten: Book_Genres
CREATE TABLE Book_Genres (
    book_id         VARCHAR(20),
    name_book_genre VARCHAR(40) NOT NULL,
    PRIMARY KEY (book_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
    ON DELETE CASCADE ON UPDATE CASCADE
    );

-- table eleven: Supplier_Phones
CREATE TABLE Supplier_Phones (
    supplier_id          VARCHAR(20),
    number_suplier_phone VARCHAR(50) NOT NULL,
    PRIMARY KEY (supplier_id),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
    ON DELETE CASCADE ON UPDATE CASCADE
    );



-- PART TWO: INSERT DATA
INSERT INTO Customers
VALUES ("customer 1", "Allen Wang", "aw1@fake.ac.uk", "Sough Bridge Walk", "Edinburgh", "EH14 3AW", "UK"),
       ("customer 2", "Bath Alexsander", "ba2@fake.uk", "N Haugh", "St Andrews", "EH8 9YL", "UK"),
       ("customer 3", "Liz Smith", "ls3@fake.uk", "Market Street", "St Andrews", "EH8 9YL", "UK"),
       ("customer 4", "Yukii Xuan", "yx4@fake.cn", "Xinjian North", "Yun City", "044000", "China"),
       ("customer 5", "Lewis Johnson", "lj5@fake.uk", "University Ave", "Glasgow", "G12 8QQ", "UK"),
       ("customer 6", "Fabian Williams", "fw6@fake.gm", "Grindelallee", "Hamburg", "999035", "Germany"),
       ("customer 7", "Gwen Jones", "gj7@fake.fc", "Route de Saclay", "Palaiseau", "91120", "France"),
       ("customer 8", "Keven Jefferson", "kj8@fake.uk", "The Avenue", "Edinburgh", "EH14 4AS", "UK"),
       ("customer 9", "Anna Brown", "ab9@fake.am", "Peabody Street", "Cambridge", "02138", "America"),
       ("customer 10", "Dave Charles", "dc10@fake.jp", "17 road", "Tokyo", "113-8657", "Japan");

    -- Name of books was generated at:  https://blog.reedsy.com/book-title-generator/fantasy/ (accessed: 2020.11.3)
INSERT INTO Books
VALUES ("book 1", "Made for Evil", "Jamie Hoover", "Star Publishing Company"),
       ("book 2", "Touch of Apollo", "Colleen Green", "Ultimate Books"),
       ("book 3", "The Guide of the Heir", "John Roth", "Time Publisher"),
       ("book 4", "Secret of the Hairless Stranger", "Veronica Stephens", "Ultimate Books"),
       ("book 5", "Court of the Rogue", "Sylvia Webber", "Nomorenames Press"),
       ("book 6", "Legacy Circling", "Tammara Day", "Ultimate Books"),
       ("book 7", "Behemoth Returning", "S.C. Collins", "Readingeveryday Publishing Company"),
       ("book 8", "Stroms of Capella", "Suzanne L. Armentrout", "Ultimate Books"),
       ("book 9", "The Horizon of Atlas", "Jennifer Glins", "Databaseishard Press"),
       ("book 10", "2938:Benediction", "Abbi Redmerski", "Ultimate Books");

INSERT INTO Orders
VALUES ("order 1", "customer 1", "Sough Bridge Walk", "Edinburgh", "EH14 3AW", "UK", "2016-01-01 00:02:03", "2016-01-03 00:03:04"),
       ("order 2", "customer 1", "Sough Bridge Walk", "Edinburgh", "EH14 3AW", "UK", "2015-12-30 00:01:13", "2016-01-01 00:05:07"),
       ("order 3", "customer 8", "The Avenue", "Edinburgh", "EH14 4AS", "UK", "2017-09-01 00:02:03", "2017-09-09 10:08:56"),
       ("order 4", "customer 8", "The Avenue", "Edinburgh", "EH14 4AS", "UK", "2016-011-12 00:12:34", "2016-12-04 02:32:33"),
       ("order 5", "customer 2", "N Haugh", "St Andrews", "EH8 9YL", "UK", "2014-05-03 00:02:03", "2014-05-06 00:23:34"),
       ("order 6", "customer 3", "Market Street", "St Andrews", "EH8 9YL", "UK", "2020-11-03 00:29:32", "2020-11-04 00:54:43"),
       ("order 7", "customer 4", "Xinjian North", "Yun City", "044000", "China", "2020-05-02 00:48:19", "2020-05-05 00:12:29"),
       ("order 8", "customer 5", "University Ave", "Glasgow", "G12 8QQ", "UK", "2019-10-8 00:02:20", "2019-10-11 00:13:03"),
       ("order 9", "customer 6", "Grindelallee", "Hamburg", "999035", "Germany", "2018-2-23 00:13:02", "2018-02-26 00:54:27"),
       ("order 10", "customer 7", "Route de Saclay", "Palaiseau", "91120", "France", "2015-03-27 00:45:20", "2016-03-30 00:45:26");

INSERT INTO Book_Editions
VALUES ("book 1", "The first edition", "Paperback", 99, 5),
       ("book 2", "The first edition", "Paperback", 60, 5),
       ("book 8", "The first edition", "Paperback", 50.5, 10),
       ("book 8", "The second edition","Audiobook", 20, 100),
       ("book 10", "The first edition","Hardcover", 100.5, 3),
       ("book 9", "The first edition","Paperback", 40.5, 7),
       ("book 10", "The second edition","Paperback", 49, 6),
       ("book 1", "The first edition", "Hardcover", 10, 1),
       ("book 2", "The first edition","Hardcover", 79, 3),
       ("book 4", "The first edition","Paperback", 45, 8);

INSERT INTO Suppliers
VALUES ("supplier 1", "Star Publishing Company Supplier", 01234),
       ("supplier 2", "Ultimate Books Supplier", 12345),
       ("supplier 3", "Time Publisher Supplier", 23456),
       ("supplier 4", "Nomorenames Press Supplier", 34567),
       ("supplier 5", "Readingeveryday Publishing Supplier", 45678),
       ("supplier 6", "Databaseishard Press", 56789),
       ("supplier 7", "Locol Supplier", 67890),
       ("supplier 8", "Harvard Supplier", 78901),
       ("supplier 9", "St Andrews Supplier", 89012),
       ("supplier 10", "Final Supplier", 90123);

INSERT INTO Customer_Book_Reviews
VALUES ("customer 1", "book 1", "It is a good book. "),
       ("customer 1", "book 2", "It is not a good book. "),
       ("customer 8", "book 3", "It is a good book."),
       ("customer 8", "book 4", "It is not a good book. "),
       ("customer 2", "book 5", "It is a good book. "),
       ("customer 3", "book 6", "It is not a good book. "),
       ("customer 4", "book 7", "It is a good book."),
       ("customer 5", "book 8", "It is not a good book. "),
       ("customer 6", "book 9", "It is a good book. "),
       ("customer 7", "book 10", "It is not a good book. ");

INSERT INTO Order_Edition_Contains
VALUES ("order 1", "customer 1", "book 1", "The first edition", "Paperback"),
       ("order 2", "customer 1", "book 2", "The first edition", "Paperback"),
       ("order 3", "customer 8", "book 8", "The first edition", "Paperback"),
       ("order 4", "customer 8", "book 8", "The second edition","Audiobook"),
       ("order 5", "customer 2", "book 10", "The first edition","Hardcover"),
       ("order 6", "customer 3", "book 9", "The first edition","Paperback"),
       ("order 7", "customer 4", "book 10", "The second edition","Paperback"),
       ("order 8", "customer 5", "book 1", "The first edition", "Hardcover"),
       ("order 9", "customer 6", "book 2", "The first edition","Hardcover"),
       ("order 10", "customer 7", "book 4", "The first edition","Paperback");

INSERT INTO Edition_Supplier_Supplies
VALUES ("supplier 1", "book 1", "The first edition", "Paperback", 10),
       ("supplier 1", "book 2", "The first edition", "Paperback", 20),
       ("supplier 1", "book 8", "The first edition", "Paperback", 500),
       ("supplier 1", "book 8", "The second edition", "Audiobook", 11),
       ("supplier 2", "book 10", "The first edition", "Hardcover", 12),
       ("supplier 3", "book 9", "The first edition", "Paperback", 13),
       ("supplier 2", "book 10", "The second edition", "Paperback", 600),
       ("supplier 2", "book 1", "The first edition", "Hardcover", 9.5),
       ("supplier 1", "book 2", "The first edition", "Hardcover", 8.5),
       ("supplier 3", "book 4", "The first edition", "Paperback", 7.5);

INSERT INTO Customer_Phones
VALUES ("customer 1", "+44 11111111111", "Preferred Phone Number"),
       ("customer 1", "(44)11111111112", "Alternate"),
       ("customer 2", "+44 22222222221", "Preferred Phone Number"),
       ("customer 2", "(44)22222222222", "Alternate"),
       ("customer 2", "+44 22222222223", "Alternate"),
       ("customer 3", "(44)33333333333", "Preferred Phone Number"),
       ("customer 4", "+44 44444444444", "Preferred Phone Number"),
       ("customer 5", "(44)55555555555", "Preferred Phone Number"),
       ("customer 6", "+44 66666666666", "Preferred Phone Number"),
       ("customer 7", "(44)66666666666", "Preferred Phone Number");

INSERT INTO Book_Genres
VALUES ("book 1", "Thriller"),
       ("book 2", "Romance"),
       ("book 3", "Mystrey"),
       ("book 4", "Mystrey"),
       ("book 5", "Romance"),
       ("book 6", "Science and Technology"),
       ("book 7", "Science and Technology"),
       ("book 8", "Science and Technology"),
       ("book 9", "Science and Technology"),
       ("book 10", "Science and Technology");

INSERT INTO Supplier_Phones
VALUES ("supplier 1", "+44 1111111"),
       ("supplier 2", "+44 2222222"),
       ("supplier 3", "+44 3333333"),
       ("supplier 4", "+44 4444444"),
       ("supplier 5", "+44 5555555"),
       ("supplier 6", "+44 6666666"),
       ("supplier 7", "+44 7777777"),
       ("supplier 8", "+44 8888888"),
       ("supplier 9", "+44 9999999"),
       ("supplier 10", "+44 0000000");


-- PART: THREE
-- 1
SELECT * 
  FROM Books
 WHERE publisher = "Ultimate Books";

-- 2
SELECT *
  FROM Orders
 WHERE city_delivery_addr = 'Edinburgh' AND date_ordered >= "2016-01-01 00:00:00"
 ORDER BY date_ordered DESC;

-- 3
 SELECT quantity_in_stock, book_edition, supplier_name, account_no, supply_price
   FROM Suppliers
NATURAL JOIN Edition_Supplier_Supplies
NATURAL JOIN Book_Editions 
  WHERE quantity_in_stock < 5; 


-- 1 new: select multi-version books
 SELECT book_id, COUNT(book_id)
   FROM Book_Editions 
NATURAL JOIN Books
  GROUP BY book_id
 HAVING COUNT(*) > 1;

-- 2 new: price not resonable
 SELECT Books.*, book_edition_price, supply_price
   FROM Books 
NATURAL JOIN Book_Editions 
NATURAL JOIN Edition_Supplier_Supplies
  WHERE book_edition_price < supply_price;

-- 3 new: profit of all orders
 SELECT SUM(book_edition_price-supply_price)
   FROM Edition_Supplier_Supplies 
NATURAL JOIN Order_Edition_Contains 
NATURAL JOIN Book_Editions;

-- 1 view
 CREATE VIEW Customer_View AS
 SELECT book_id, book_edition, book_edition_type, book_edition_price, quantity_in_stock 
   FROM Book_Editions 
NATURAL LEFT JOIN Books;

-- 2 view 
 CREATE VIEW Supplier_View AS
 SELECT *
   FROM Supplier_Phones 
NATURAL JOIN Edition_Supplier_Supplies;