
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