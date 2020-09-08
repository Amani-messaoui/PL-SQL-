--1
DECLARE
v_customers Customer%rowtype;

BEGIN
SELECT *
  INTO v_customers
  FROM Customer
  dbms_output.put_line(v_customers.Customer_id |''| v_customers.customer_Name |''| v_customers.customer_Tel);
END;
/
--2
CREATE OR REPLACE PROCEDURE PS_Customer_Prodcuts (v_customer_id Orders.customer_id%type) IS
CURSOR cur(v_customer_id number) IS 
SELECT product_name FROM Orders  
   INNER JOIN (
        Product ON Product.Product_id = Orders.Product_id,
        Customer ON Customer.Customer_id = Orders.Customer_id
    );
BEGIN

FOR rec IN cur LOOP
 dbms_output.put_line("the name of the product :"||rec.product_name) ;
END LOOP;

 IF(NO_DATA_FOUND) THEN
     dbms_output.put_line("No products returned or customer not found")  ;  
 END IF;
END;
/
--3
CREATE OR REPLACE FUNCTION FN_Customer_Orders (v_customer_id Orders.customer_id%type) RETURN number IS
	nb_ord number:=0;
    BEGIN
	SELECT count(*) into nb_ord FROM Orders WHERE Orders.customer_id%=v_customer_id;
	RETURN nb_ord;
END;
/
--4
CREATE OR REPLACE TRIGGER TRIG_INS_ORDERS
BEFORE INSERT ON Orders FOR EACH ROW
BEGIN
 IF (:old.OrderDate >= SYSDATE) THEN
    dbms_output.put_line("Order Date must be greater than or equal to today's date");    
 END IF;
    
END;
/
