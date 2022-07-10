
--STORED PROCEDURES

exec insertClient '4900-300', 'Leopardo', 'Jhonas', '1923-04-03', '964758274',23949294 ,'leopas@gmail.com';


drop procedure insertClient;

---STORED PROCEDURE THAT VALIDATES THE CLIENT EMAIL AND ZIP CODE WITH A TRANSACTION ON THE HEADSTART AND PRINTS ERROR IF NECESSARY TO THE SCREEN
GO
Create procedure insertClient(@client_zip_code varchar(10),@client_name varchar(100),@client_surename varchar(100),@client_birth_date date,@client_cell_number varchar(10),@client_TIN varchar(15),@client_email varchar(100))
AS
	begin
	
		if @client_zip_code not like '[0-9][0-9][0-9][0-9][-][0-9][0-9][0-9]' 
			begin
				print 'formato do codigo postal invalido'
				return;
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
