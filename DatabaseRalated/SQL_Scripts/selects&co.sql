--SELECT

--zip code
select *from zip_code;

--clients
select *from clients;

select *from clients where client_id=10001;

--selects the client data and the total spent amount on the logotipo service

select c.client_id,c.client_name,z.zip_code,z.locality,s.service_namee, sum(iv.totalAmount)  as total
from zip_code z,clients c, invoice i, 
invoice_lines iv, servicess s,payment_methods p where c.client_zip_code=z.zip_code and c.client_id=i.client_id and i.payment_method=p.payment_method_id and i.invoice_id=iv.invoice_id 
and iv.service_id=s.service_id and s.service_id=1  group by c.client_id, c.client_name,z.zip_code,z.locality,s.service_namee order by total desc 
GO 

--invoice lines
select *from invoice_lines i

--selects the payment method that was mostly used in the current year
select top 1 p.payment_method_descrition as 'Método de pagamento mais usado' ,i.invoice_emission_date as 'Ano',count(i.payment_method) as 'Número de usos' from payment_methods p,
invoice i where p.payment_method_id=i.payment_method group by p.payment_method_descrition,i.invoice_emission_date order by 'Número de usos'  desc ;

--invoice
select *from invoice;

select i.invoice_emission_date , sum(iv.totalAmount) as 'Valor anual'  
from invoice i, invoice_lines iv where i.invoice_id=iv.invoice_id group by i.invoice_emission_date 
order by i.invoice_emission_date asc;


select i.invoice_emission_date, s.service_namee, sum(iv.VAT_amount) as'Total iva pago' from  servicess s, invoice i, invoice_lines iv where s.service_id =iv.service_id and iv.invoice_id=i.invoice_id
group by i.invoice_emission_date,s.service_namee having sum(iv.VAT_amount) >10000 order by i.invoice_emission_date;

--payment methods
select *from payment_methods;

--services
select *from servicess;

--INSERTS

--clients
insert into clients (client_name,client_TIN,client_zip_code) values('Zawal',301010277,'4900-300');
insert into clients (client_name,client_TIN,client_zip_code) values('Nho',301010277,'4900-300');


--invoice
select *from invoice;

insert into   invoice (client_id,invoice_emission_date,payment_method) values(1001,'2021-05-31',1);
insert into   invoice (client_id,invoice_emission_date,payment_method) values(1,'2021-05-31',1);
insert into   invoice (client_id,invoice_emission_date,payment_method) values(1,'2021-05-31',1);
insert into   invoice (client_id,invoice_emission_date,payment_method) values(1001,'2021-05-31',1);


--invoice_lines

insert into invoice_lines(invoice_id,service_id,payed_amount,quantity) values(1002,2,500,7);
insert into invoice_lines(invoice_id,service_id,payed_amount,quantity) values(2,2,250,7);
insert into invoice_lines(invoice_id,service_id,payed_amount,quantity) values(3,2,250,7);
insert into invoice_lines(invoice_id,service_id,payed_amount,quantity) values(4,2,46,9);


--DELETES

begin tran deleteTrasaction;

--clients

delete from clients where client_id>=1;

--invoice
delete from invoice where invoice_id>=1;

--invoice lines
delete from invoice_lines where line_id >=1;

commit deleteTransaction;

--RESET IDENTITIES FOR PRIMARY KEY

DBCC CHECKIDENT ('invoice_lines', RESEED , 0)
DBCC CHECKIDENT ('invoice', RESEED , 0)
DBCC CHECKIDENT ('clients', RESEED , 0)
