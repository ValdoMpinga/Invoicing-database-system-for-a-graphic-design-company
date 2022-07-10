/******** DMA Schema Migration Deployment Script      Script Date: 06/06/2021 14:57:02 ********/
-- 2 object(s) with recommendations identified during assessment. Please review these objects before deploying.

/****** Object:  Table [dbo].[zip_code]    Script Date: 06/06/2021 14:57:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[zip_code]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[zip_code](
	[zip_code] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[locality] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK__zip_code__FA8EDA7580992F60] PRIMARY KEY CLUSTERED 
(
	[zip_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
/****** Object:  StoredProcedure [dbo].[check_zipCode]    Script Date: 06/06/2021 14:57:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[check_zipCode]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[check_zipCode] AS' 
END
GO
ALTER procedure [dbo].[check_zipCode](@postalCode varchar(15)) 
AS
	begin
		if((select  count(*)  from zip_code where zip_code.zip_code = @postalCode)<1)
			print 'Loclidade inexistente!'
	end;

GO
/****** Object:  Table [dbo].[clients]    Script Date: 06/06/2021 14:57:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[clients]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[clients](
	[client_id] [int] IDENTITY(1,1) NOT NULL,
	[client_zip_code] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[client_name] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[client_surename] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[client_birth_date] [date] NULL,
	[client_cell_number] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[client_TIN] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[client_email] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK__clients__BF21A424BCBCC9A6] PRIMARY KEY CLUSTERED 
(
	[client_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
SET ANSI_PADDING ON

GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[clients]') AND name = N'_dta_index_clients_9_1589580701__K1_K2_3')
CREATE NONCLUSTERED INDEX [_dta_index_clients_9_1589580701__K1_K2_3] ON [dbo].[clients]
(
	[client_id] ASC,
	[client_zip_code] ASC
)
INCLUDE ( 	[client_name]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[client_insertion]'))
EXEC dbo.sp_executesql @statement = N'create trigger client_insertion on
clients after insert
AS
	BEGIN
		DECLARE @postalCode varchar(15);
		select  @postalCode= c.client_zip_code from clients c;
		print ''Code_:'' + @postalCode;
		exec dbo.check_zipCode @postalCode
	END' 
GO
ALTER TABLE [dbo].[clients] ENABLE TRIGGER [client_insertion]
GO
if not exists (select * from sys.stats where name = N'_dta_stat_1589580701_2_1' and object_id = object_id(N'[dbo].[clients]'))
CREATE STATISTICS [_dta_stat_1589580701_2_1] ON [dbo].[clients]([client_zip_code], [client_id])
GO
/****** Object:  StoredProcedure [dbo].[insertClient]    Script Date: 06/06/2021 14:57:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[insertClient]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[insertClient] AS' 
END
GO
ALTER procedure [dbo].[insertClient](@client_zip_code varchar(10),@client_name varchar(100),@client_surename varchar(100),@client_birth_date date,@client_cell_number varchar(10),@client_TIN varchar(15),@client_email varchar(100))
AS
	begin
	
		if @client_zip_code not like '[0-9][0-9][0-9][0-9][-][0-9][0-9][0-9]' 
			begin
				print 'formato do codigo postal invalido'
				return;
					--	if @client_email not like '\w[a-z 0-9]+@\w[a-z]+[.]+\w{2,3}%' 
			end
			
			
		if @client_email not like '%[A-Z0-9][@][A-Z0-9]%[.][A-Z0-9]%' 
		begin
			print 'email invalido'
			return;
		end

		if @client_birth_date > GETDATE()
		begin
			print 'Data de nascimento não pode ser futuristica!'
			rollback;
			return;
		end

		begin try
			begin tran clientInsertion

			insert into clients(client_zip_code,client_name,client_surename,client_birth_date,client_cell_number,client_TIN,client_email)
			values(@client_zip_code,@client_name,@client_surename,@client_birth_date,@client_cell_number,@client_TIN,@client_email);

			commit tran clientInsertion
		end try

		begin catch
			if @@ERROR !=0
				print 'Erro ao inserir cliente!'
				rollback tran
		end catch
	end;

GO
/****** Object:  Table [dbo].[client_images]    Script Date: 06/06/2021 14:57:02 ******/
/**
Assessment issue: [71627] Table with FILSTREAM column not supported in Azure SQL Database
Categories: Compatibility, MigrationBlocker
Applicable compatibility levels: CompatLevel150
Impact: The FILSTREAM column, which allows you to store unstructured data such as text documents, images, and videos in NTFS file system, is not supported in Azure SQL Database.
Impact details: The element Column: [dbo].[client_images].[client_image] has property IsFileStream set to a value that is not supported in Microsoft Azure SQL Database v12.
Recommendation: Upload the unstructured files to Azure Blob storage and store metadata related to these files (name, type, URL location, storage key etc.) in Azure SQL Database.
 You may have re-engineer your application to enable streaming blobs to and from Azure SQL Database.
More information: Streaming Blobs To and From SQL Azure (https://go.microsoft.com/fwlink/?linkid=838302)
 **/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[client_images]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[client_images](
	[client_id] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[picture_description] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[client_image] [varbinary](max) FILESTREAM  NULL,
 CONSTRAINT [UQ__client_i__BF21A425B79DF934] UNIQUE NONCLUSTERED 
(
	[client_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
) FILESTREAM_ON [FILESTREAM]
END
GO
/****** Object:  Table [dbo].[servicess]    Script Date: 06/06/2021 14:57:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[servicess]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[servicess](
	[service_id] [int] IDENTITY(1,1) NOT NULL,
	[service_namee] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[service_vat] [float] NULL,
	[service_description] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[service_price] [float] NULL,
 CONSTRAINT [PK__services__3E0DB8AFC9DF6AC6] PRIMARY KEY CLUSTERED 
(
	[service_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
/****** Object:  Table [dbo].[payment_methods]    Script Date: 06/06/2021 14:57:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[payment_methods]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[payment_methods](
	[payment_method_id] [int] IDENTITY(1,1) NOT NULL,
	[payment_method_descrition] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[payment_method_activity_state] [bit] NULL,
 CONSTRAINT [PK__payment___8A3EA9EB059BB0B5] PRIMARY KEY CLUSTERED 
(
	[payment_method_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
/****** Object:  UserDefinedFunction [dbo].[default_salesman_name]    Script Date: 06/06/2021 14:57:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[default_salesman_name]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION default_salesman_name ()
returns varchar(50)
AS
	BEGIN
		DECLARE @salesman varchar(50);

		SELECT @salesman= ''James Guevara'';

		return @salesman;
	END
' 
END

GO
/****** Object:  Table [dbo].[invoice]    Script Date: 06/06/2021 14:57:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[invoice]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[invoice](
	[invoice_id] [int] IDENTITY(1,1) NOT NULL,
	[payment_method] [int] NULL,
	[client_id] [int] NULL,
	[salesman_name] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[invoice_emission_date] [date] NULL,
 CONSTRAINT [PK__invoice__F58DFD494EDEE5DB] PRIMARY KEY CLUSTERED 
(
	[invoice_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[invoice]') AND name = N'_dta_index_invoice_9_1701581100__K1_K2_K3')
CREATE NONCLUSTERED INDEX [_dta_index_invoice_9_1701581100__K1_K2_K3] ON [dbo].[invoice]
(
	[invoice_id] ASC,
	[payment_method] ASC,
	[client_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[insert_salesman_name]'))
EXEC dbo.sp_executesql @statement = N'create trigger insert_salesman_name on
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
' 
GO
ALTER TABLE [dbo].[invoice] ENABLE TRIGGER [insert_salesman_name]
GO
if not exists (select * from sys.stats where name = N'_dta_stat_1701581100_2_3_1' and object_id = object_id(N'[dbo].[invoice]'))
CREATE STATISTICS [_dta_stat_1701581100_2_3_1] ON [dbo].[invoice]([payment_method], [client_id], [invoice_id])
GO
/****** Object:  UserDefinedFunction [dbo].[calculate_totalAmount]    Script Date: 06/06/2021 14:57:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[calculate_totalAmount]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION calculate_totalAmount (@productQuantity int , @payed_amount float)
returns float
AS
	BEGIN
		declare @totalAmount FLOAT;
		SELECT @totalAmount =(@productQuantity * @payed_amount);
		return @totalAmount;
	END
' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[calculate_VAT_value]    Script Date: 06/06/2021 14:57:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[calculate_VAT_value]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION calculate_VAT_value (@productQuantity int , @payed_amount float,@product_VAT float)
returns float
AS
	BEGIN
		declare @VAT_value FLOAT;
		SELECT @VAT_value =((@productQuantity * @payed_amount) * @product_VAT);
		return @VAT_value;
	END
' 
END

GO
/****** Object:  Table [dbo].[invoice_lines]    Script Date: 06/06/2021 14:57:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[invoice_lines]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[invoice_lines](
	[line_id] [int] IDENTITY(1,1) NOT NULL,
	[invoice_id] [int] NULL,
	[service_id] [int] NULL,
	[payed_amount] [float] NULL,
	[quantity] [int] NULL,
	[VAT_amount] [float] NULL,
	[totalAmount] [float] NULL,
 CONSTRAINT [PK_invoice_lines] PRIMARY KEY CLUSTERED 
(
	[line_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[invoice_lines]') AND name = N'_dta_index_invoice_lines_9_1765581328__K3_2_7')
CREATE NONCLUSTERED INDEX [_dta_index_invoice_lines_9_1765581328__K3_2_7] ON [dbo].[invoice_lines]
(
	[service_id] ASC
)
INCLUDE ( 	[invoice_id],
	[totalAmount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[insert_VAT_value]'))
EXEC dbo.sp_executesql @statement = N'create trigger insert_VAT_value on
invoice_lines after insert
AS
	BEGIN
		DECLARE @productQuantity float, @payed_amount float, @product_VAT float,@service_id_of_the_invoice_product int,@invoice_line_id int ;
		
		select @service_id_of_the_invoice_product= invoice_lines.service_id from invoice_lines;
		select @productQuantity= invoice_lines.quantity from invoice_lines;

		select @payed_amount=servicess.service_price from servicess where servicess.service_id= @service_id_of_the_invoice_product;
		select @payed_amount=servicess.service_price from servicess where servicess.service_id= @service_id_of_the_invoice_product;
		select @payed_amount=servicess.service_price from servicess where servicess.service_id= @service_id_of_the_invoice_product;

		select @product_VAT=servicess.service_vat from servicess where servicess.service_id=@service_id_of_the_invoice_product;
		select @invoice_line_id = invoice_lines.line_id from invoice_lines;

				print ''Product of  id: '' + CAST( @invoice_line_id AS NVARCHAR(10))+'' '' + CAST( @service_id_of_the_invoice_product AS NVARCHAR(10));


		update invoice_lines set payed_amount= @payed_amount where line_id=@invoice_line_id;
		update invoice_lines set VAT_amount=  dbo.calculate_VAT_value(@productQuantity,@payed_amount,@product_VAT) where line_id=@invoice_line_id;
		update invoice_lines set totalAmount= dbo.calculate_totalAmount(@productQuantity,@payed_amount) where line_id=@invoice_line_id;
	END
' 
GO
ALTER TABLE [dbo].[invoice_lines] ENABLE TRIGGER [insert_VAT_value]
GO
if not exists (select * from sys.stats where name = N'_dta_stat_1765581328_3_2' and object_id = object_id(N'[dbo].[invoice_lines]'))
CREATE STATISTICS [_dta_stat_1765581328_3_2] ON [dbo].[invoice_lines]([service_id], [invoice_id])
GO
/****** Object:  View [dbo].[Payment_Lines]    Script Date: 06/06/2021 14:57:02 ******/
/**
Assessment issue: Unqualified Join(s) detected
Categories: Compatibility, BehaviorChange
Applicable compatibility levels: CompatLevel150
Impact: Starting with database compatibility level 90 and higher, in rare occasions, the 'unqualified join' syntax can cause 'missing join predicate' warnings, leading to long running queries.
Impact details: Object [dbo].[Payment_Lines] uses the old style join syntax which can have poor performance at database compatibility level 90 and higher. For more details, please see: Line 4, Column 1.
Recommendation: An example of "Unqualified join" is
 
select * from table1, table2
where table1.col1 = table2.col1

 Use  explicit JOIN syntax in all cases. SQL Server supports the below explicit joins:
 - LEFT OUTER JOIN or LEFT JOIN
- RIGHT OUTER JOIN or RIGHT JOIN
- FULL OUTER JOIN or FULL JOIN
- INNER JOIN
More information: - Missing join Predicate Event Class (https://go.microsoft.com/fwlink/?LinkId=798567)
- Deprecation of "Old Style" JOIN Syntax: Only A Partial Thing (https://go.microsoft.com/fwlink/?LinkId=798568)
- DOC : Please strive to use ANSI-style joins instead of deprecated syntax  (https://go.microsoft.com/fwlink/?LinkId=798569)
- Missing join predicate icon should be red (https://go.microsoft.com/fwlink/?LinkId=798570)
 **/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Payment_Lines]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW Payment_Lines AS 
SELECT c.client_name as ''Nome do cliente'', c.client_TIN ''Numero de contribuinte'' ,s.service_namee as ''Nome do serviço'' , il.quantity as '' Quantidade'' 
,il.payed_amount as ''Valor pago'' ,il.totalAmount as ''Total pago'' ,il.VAT_amount as ''Valor do IVA'' ,i.invoice_emission_date as ''Data de emissão''
FROM servicess s, invoice i, invoice_lines il, clients c
WHERE s.service_id=il.service_id and il.invoice_id=i.invoice_id and i.client_id=c.client_id;
' 
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_client_zip_code]') AND parent_object_id = OBJECT_ID(N'[dbo].[clients]'))
ALTER TABLE [dbo].[clients]  WITH CHECK ADD  CONSTRAINT [fk_client_zip_code] FOREIGN KEY([client_zip_code])
REFERENCES [dbo].[zip_code] ([zip_code])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_client_zip_code]') AND parent_object_id = OBJECT_ID(N'[dbo].[clients]'))
ALTER TABLE [dbo].[clients] CHECK CONSTRAINT [fk_client_zip_code]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_client_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[invoice]'))
ALTER TABLE [dbo].[invoice]  WITH CHECK ADD  CONSTRAINT [fk_client_id] FOREIGN KEY([client_id])
REFERENCES [dbo].[clients] ([client_id])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_client_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[invoice]'))
ALTER TABLE [dbo].[invoice] CHECK CONSTRAINT [fk_client_id]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_payment_method]') AND parent_object_id = OBJECT_ID(N'[dbo].[invoice]'))
ALTER TABLE [dbo].[invoice]  WITH CHECK ADD  CONSTRAINT [fk_payment_method] FOREIGN KEY([payment_method])
REFERENCES [dbo].[payment_methods] ([payment_method_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_payment_method]') AND parent_object_id = OBJECT_ID(N'[dbo].[invoice]'))
ALTER TABLE [dbo].[invoice] CHECK CONSTRAINT [fk_payment_method]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_invoice_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[invoice_lines]'))
ALTER TABLE [dbo].[invoice_lines]  WITH CHECK ADD  CONSTRAINT [fk_invoice_id] FOREIGN KEY([invoice_id])
REFERENCES [dbo].[invoice] ([invoice_id])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_invoice_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[invoice_lines]'))
ALTER TABLE [dbo].[invoice_lines] CHECK CONSTRAINT [fk_invoice_id]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_service_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[invoice_lines]'))
ALTER TABLE [dbo].[invoice_lines]  WITH CHECK ADD  CONSTRAINT [fk_service_id] FOREIGN KEY([service_id])
REFERENCES [dbo].[servicess] ([service_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_service_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[invoice_lines]'))
ALTER TABLE [dbo].[invoice_lines] CHECK CONSTRAINT [fk_service_id]
GO

