
--TRIGGERS
drop trigger insert_VAT_value;

begin tran operationSubstitution;


begin tran changeInsertVatTrigger;

GO
create trigger insert_VAT_value on
invoice_lines after insert
AS
	BEGIN
		DECLARE @productQuantity float, @payed_amount float, @product_VAT float,@service_id_of_the_invoice_product int,@invoice_line_id int ;
		
		select @service_id_of_the_invoice_product= invoice_lines.service_id from invoice_lines;
		select @productQuantity= invoice_lines.quantity from invoice_lines;
		select @payed_amount=servicess.service_price from servicess where servicess.service_id= @service_id_of_the_invoice_product;
		select @product_VAT=servicess.service_vat from servicess where servicess.service_id=@service_id_of_the_invoice_product;
		select @invoice_line_id = invoice_lines.line_id from invoice_lines;



		update invoice_lines set payed_amount= @payed_amount where line_id=@invoice_line_id;
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
--desabled
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
		select  @postalCode= c.client_zip_code from clients c;
		exec dbo.check_zipCode @postalCode
	END



---------------------------------------------------------------------------------------------------------------

