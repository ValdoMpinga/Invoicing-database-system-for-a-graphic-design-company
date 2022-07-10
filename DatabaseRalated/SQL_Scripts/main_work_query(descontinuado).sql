------------------------------------------------------------------------	 MAIN WORKSHEET		-----------------------------------------------------------------------

--STORED PROCEDURES

/**
*
*
*/
drop procedure check_zipCode;

GO
Create procedure check_zipCode(@postalCode varchar(15)) 
AS
	begin
		if((select  count(*)  from zip_code where zip_code.zip_code = @postalCode)<1)
			print('Localidade inexistente!');
	end
GO

--FUNCTIONS

/**
*Returns the VAT paying amount
*@return VAT_value
*
*/
drop function calculate_VAT_value;

GO
CREATE FUNCTION calculate_VAT_value (@productQuantity int , @payed_amount float,@product_VAT float)
returns float
AS
	BEGIN
		declare @VAT_value FLOAT;
		SELECT @VAT_value =((@productQuantity * @payed_amount) * @product_VAT);
		return @VAT_value;
	END
GO

/***********************************************************************************************************************************************************/-----------------------------------------------------------------------------------------------------------------------------

drop function calculate_totalAmount;

/**
*Returns the total amount
*@return totalAmount
*
*/
GO
CREATE FUNCTION calculate_totalAmount (@productQuantity int , @payed_amount float)
returns float
AS
	BEGIN
		declare @totalAmount FLOAT;
		SELECT @totalAmount =(@productQuantity * @payed_amount);
		return @totalAmount;
	END
GO

/*********************************************************************************************************************************************************/


drop function default_salesman_name;

/**
*Returns a salesman name
*@return salesmanName
*
*/

GO
CREATE FUNCTION default_salesman_name ()
returns varchar(50)
AS
	BEGIN
		DECLARE @salesman varchar(50);

		SELECT @salesman= 'James Guevara';

		return @salesman;
	END
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

--TRIGGERS
drop trigger insert_VAT_value;

GO
create trigger insert_VAT_value on
invoice_lines after insert
AS
	BEGIN
		DECLARE @productQuantity int, @payed_amount float, @product_VAT float,@service_id_of_the_invoice_product int,@invoice_line_id int ;

		select @service_id_of_the_invoice_product= invoice_lines.service_id from invoice_lines;
		select @productQuantity= invoice_lines.quantity from invoice_lines;
		select @payed_amount=invoice_lines.payed_amount from invoice_lines;
		select @product_VAT=servicess.service_vat from servicess where servicess.service_id=@service_id_of_the_invoice_product;
		select @invoice_line_id = invoice_lines.line_id from invoice_lines;

		update invoice_lines set VAT_amount=  dbo.calculate_VAT_value(@productQuantity,@payed_amount,@product_VAT) where line_id=@invoice_line_id;
		update invoice_lines set totalAmount= dbo.calculate_totalAmount(@productQuantity,@payed_amount) where line_id=@invoice_line_id;
	END
GO

/***********************************************************************************************************************************************************/

drop trigger insert_salesman_name;

/**
*Insert default salesman name to the invoice
*
*/
GO
create trigger insert_salesman_name on
invoice after insert
AS
	BEGIN
		DECLARE @salesman varchar(50), @invoice_id int;
		SELECT @salesman=invoice.salesman_name from invoice;
		SELECT @invoice_id=invoice.invoice_id from invoice

		if(@salesman is null) 
			select @salesman= dbo.default_salesman_name();
			
		update invoice set salesman_name= @salesman where invoice_id=@invoice_id;
	END
GO

/***********************************************************************************************************************************************************/

drop trigger client_insertion;

/**
*Insert default salesman name to the invoice
*
*/

GO
create trigger client_insertion on
clients after insert
AS
	BEGIN
		DECLARE @postalCode varchar(15);
		select @postalCode= clients.client_zip_code from clients;
		exec check_zipCode(select @postalCode);

	END
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------

--UNIQUE

ALTER TABLE Clients
ADD	CONSTRAINT unique_VAT UNIQUE (Client_VAT);

--SELECT
select *from clients;

select COUNT(c.client_id) as total, c.client_id, c.client_name, c.client_surename,z.zip_code, z.locality
from  clients c,zip_code z,invoice i where c.client_id=i.client_id and c.client_zip_code=z.zip_code ;

--invoice lines

select *from invoice_lines where invoice_id=1004;

--invoice
select *from invoice;
/*****************************************************************************************************************/

--payment methods

/*****************************************************************************************************************/


select *from payment_methods;

--INSERT

--Invoice lines
insert into invoice_lines (invoice_id,service_id,payed_amount,quantity) values(1006,2,999,4);

--Invoice 

insert into invoice (client_id,invoice_emission_date,payment_method) values(2020,'2015/03/12',1);

--UPDATE

--VIEWS
drop view Payment_Lines;

GO
CREATE VIEW Payment_Lines AS 
SELECT c.client_name as 'Nome do cliente', c.client_TIN 'Numero de contribuinte' ,s.service_namee as 'Nome do serviço' , il.quantity as ' Quantidade' 
,il.payed_amount as 'Valor pago' ,il.totalAmount as 'Total pago' ,il.VAT_amount as 'Valor do IVA' ,i.invoice_emission_date as 'Data de emissão'
FROM servicess s, invoice i, invoice_lines il, clients c
WHERE s.service_id=il.service_id and il.invoice_id=i.invoice_id and i.client_id=c.client_id;
GO

select *from Payment_Lines  ;

--TRANSACTIONS

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--CURSORS

--display the client data, he's locality, the consumed service and the amount that the client spent in total on the specific service

select c.client_name, c.client_surename,c.client_email,c.client_birth_date,z.zip_code,z.locality,s.service_namee,sum(iv.totalAmount) as total from zip_code z,clients c, invoice i, 
invoice_lines iv, servicess s,payment_methods p where c.client_zip_code=z.zip_code and c.client_id=i.client_id and i.payment_method=p.payment_method_id and i.invoice_id=iv.invoice_id 
and iv.service_id=s.service_id and s.service_id=3 group by c.client_name, c.client_surename,c.client_email,c.client_birth_date,z.zip_code,z.locality,s.service_namee order by total;

/*select c.client_name,z.locality,s.service_namee,sum(iv.totalAmount) as total from zip_code z,clients c, invoice i, 
invoice_lines iv, servicess s,payment_methods p where c.client_zip_code=z.zip_code and c.client_id=i.client_id and i.payment_method=p.payment_method_id and i.invoice_id=iv.invoice_id 
and iv.service_id=s.service_id and s.service_id=1 group by c.client_name; */

/*******************************************************************************************************************************************************************/
/*******************************************************************************************************************************************************************/
/*******************************************************************************************************************************************************************/
/*******************************************************************************************************************************************************************/

alter table clients add constraint fk_client_zip_code foreign key (client_zip_code) references zip_code(zip_code);
select *from invoice_lines order by totalAmount;