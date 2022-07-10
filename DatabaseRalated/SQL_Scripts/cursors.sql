
--CURSORS

--display the client data, he's locality, the consumed service and the amount that the client spent in total on the specific service



GO
DECLARE logotipo_cursor CURSOR for select c.client_id,c.client_name, c.client_surename,c.client_email,c.client_birth_date,z.zip_code,z.locality,s.service_namee, sum(iv.totalAmount)  as total
from zip_code z,clients c, invoice i, invoice_lines iv, servicess s,payment_methods p where c.client_zip_code=z.zip_code and c.client_id=i.client_id and i.payment_method=p.payment_method_id and i.invoice_id=iv.invoice_id 
and iv.service_id=s.service_id and s.service_id=1  group by c.client_id, c.client_name, c.client_surename,c.client_email,c.client_birth_date,z.zip_code,z.locality,s.service_namee order by total desc;
GO

GO
open logotipo_cursor;
GO

GO
DECLARE
@client_id int,@client_name varchar(max),@client_surename varchar(max),@client_email varchar(max),@client_birth_date date,@client_zip varchar(10),@client_locality varchar(max),@service_name varchar(max),@sum float;

fetch next from logotipo_cursor into @client_id,@client_name,@client_surename,@client_email,@client_birth_date,@client_zip,@client_locality,@service_name,@sum

while @@FETCH_STATUS=0
begin	
	print 'Id do cliente: ' +CAST( @client_id AS NVARCHAR(10)) + ' Nome do cliente: ' + @client_name + ' ' + @client_surename + 'Email: ' +@client_email + ' Data de nascimento: ' + CAST (@client_birth_date AS NVARCHAR(10)) 
	+ ' Codigo postal: ' +@client_zip + +'Localidade: '+ @client_locality + 'Serviço: ' + @service_name + ' Total gasto: ' + CAST( @sum AS NVARCHAR(10))

	fetch next from logotipo_cursor into  @client_id,@client_name,@client_surename,@client_email,@client_birth_date,@client_zip,@client_locality,@service_name,@sum
	end;
GO

GO
close logotipo_cursor;
GO

GO
deallocate  logotipo_cursor;
GO


/******************************************************************************************************************************************************************************************/
GO
DECLARE logo_cursor CURSOR for select c.client_id,c.client_name, c.client_surename,c.client_email,c.client_birth_date,z.zip_code,z.locality,s.service_namee, sum(iv.totalAmount)  as total
from zip_code z,clients c, invoice i, invoice_lines iv, servicess s,payment_methods p where c.client_zip_code=z.zip_code and c.client_id=i.client_id and i.payment_method=p.payment_method_id and i.invoice_id=iv.invoice_id 
and iv.service_id=s.service_id and s.service_id=2  group by c.client_id, c.client_name, c.client_surename,c.client_email,c.client_birth_date,z.zip_code,z.locality,s.service_namee order by total desc;
GO

GO
open logo_cursor;
GO

GO
DECLARE
@client_id int,@client_name varchar(max),@client_surename varchar(max),@client_email varchar(max),@client_birth_date date,@client_zip varchar(10),@client_locality varchar(max),@service_name varchar(max),@sum float;

fetch next from logo_cursor into @client_id,@client_name,@client_surename,@client_email,@client_birth_date,@client_zip,@client_locality,@service_name,@sum

while @@FETCH_STATUS=0
begin	
	print 'Id do cliente: ' +CAST( @client_id AS NVARCHAR(10)) + ' Nome do cliente: ' + @client_name + ' ' + @client_surename + 'Email: ' +@client_email + ' Data de nascimento: ' + CAST (@client_birth_date AS NVARCHAR(10)) 
	+ ' Codigo postal: ' +@client_zip + +'Localidade: '+ @client_locality + 'Serviço: ' + @service_name + ' Total gasto: ' + CAST( @sum AS NVARCHAR(10))

	fetch next from logo_cursor into  @client_id,@client_name,@client_surename,@client_email,@client_birth_date,@client_zip,@client_locality,@service_name,@sum
	end;
GO

GO
close logo_cursor;
GO

GO
deallocate  logo_cursor;
GO

/***********************************************************************************************************************************************************************************************************/

GO
DECLARE desenho_artistico_cursor CURSOR for select c.client_id,c.client_name, c.client_surename,c.client_email,c.client_birth_date,z.zip_code,z.locality,s.service_namee, sum(iv.totalAmount)  as total
from zip_code z,clients c, invoice i, invoice_lines iv, servicess s,payment_methods p where c.client_zip_code=z.zip_code and c.client_id=i.client_id and i.payment_method=p.payment_method_id and i.invoice_id=iv.invoice_id 
and iv.service_id=s.service_id and s.service_id=2  group by c.client_id, c.client_name, c.client_surename,c.client_email,c.client_birth_date,z.zip_code,z.locality,s.service_namee order by total desc;
GO

GO
open desenho_artistico_cursor;
GO

GO
DECLARE
@client_id int,@client_name varchar(max),@client_surename varchar(max),@client_email varchar(max),@client_birth_date date,@client_zip varchar(10),@client_locality varchar(max),@service_name varchar(max),@sum float;

fetch next from desenho_artistico_cursor into @client_id,@client_name,@client_surename,@client_email,@client_birth_date,@client_zip,@client_locality,@service_name,@sum

while @@FETCH_STATUS=0
begin	
	print 'Id do cliente: ' +CAST( @client_id AS NVARCHAR(10)) + ' Nome do cliente: ' + @client_name + ' ' + @client_surename + 'Email: ' +@client_email + ' Data de nascimento: ' + CAST (@client_birth_date AS NVARCHAR(10)) 
	+ ' Codigo postal: ' +@client_zip + +'Localidade: '+ @client_locality + 'Serviço: ' + @service_name + ' Total gasto: ' + CAST( @sum AS NVARCHAR(10))

	fetch next from desenho_artistico_cursor into  @client_id,@client_name,@client_surename,@client_email,@client_birth_date,@client_zip,@client_locality,@service_name,@sum
	end;
GO

GO
close desenho_artistico_cursor;
GO

GO
deallocate  desenho_artistico_cursor;
GO

/***********************************************************************************************************************************************************************************************************/


GO
DECLARE business_card_cursor CURSOR for select c.client_id,c.client_name, c.client_surename,c.client_email,c.client_birth_date,z.zip_code,z.locality,s.service_namee, sum(iv.totalAmount)  as total
from zip_code z,clients c, invoice i, invoice_lines iv, servicess s,payment_methods p where c.client_zip_code=z.zip_code and c.client_id=i.client_id and i.payment_method=p.payment_method_id and i.invoice_id=iv.invoice_id 
and iv.service_id=s.service_id and s.service_id=4  group by c.client_id, c.client_name, c.client_surename,c.client_email,c.client_birth_date,z.zip_code,z.locality,s.service_namee order by total desc;
GO

GO
open business_card_cursor;
GO

GO
DECLARE
@client_id int,@client_name varchar(max),@client_surename varchar(max),@client_email varchar(max),@client_birth_date date,@client_zip varchar(10),@client_locality varchar(max),@service_name varchar(max),@sum float;

fetch next from business_card_cursor into @client_id,@client_name,@client_surename,@client_email,@client_birth_date,@client_zip,@client_locality,@service_name,@sum

while @@FETCH_STATUS=0
begin	
	print 'Id do cliente: ' +CAST( @client_id AS NVARCHAR(10)) + ' Nome do cliente: ' + @client_name + ' ' + @client_surename + 'Email: ' +@client_email + ' Data de nascimento: ' + CAST (@client_birth_date AS NVARCHAR(10)) 
	+ ' Codigo postal: ' +@client_zip + +'Localidade: '+ @client_locality + 'Serviço: ' + @service_name + ' Total gasto: ' + CAST( @sum AS NVARCHAR(10))

	fetch next from business_card_cursor into  @client_id,@client_name,@client_surename,@client_email,@client_birth_date,@client_zip,@client_locality,@service_name,@sum
	end;
GO

GO
close business_card_cursor;
GO

GO
deallocate  business_card_cursor;
GO

/***********************************************************************************************************************************************************************************************************/


select *from servicess;