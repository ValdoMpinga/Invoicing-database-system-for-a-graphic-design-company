
--VIEWS
drop view Payment_Lines;

GO
CREATE VIEW Payment_Lines AS 
SELECT c.client_name as 'Nome do cliente', c.client_TIN 'Numero de contribuinte' ,s.service_namee as 'Nome do serviço' , il.quantity as ' Quantidade' 
,il.payed_amount as 'Valor pago' ,il.totalAmount as 'Total pago' ,il.VAT_amount as 'Valor do IVA' ,i.invoice_emission_date as 'Data de emissão'
FROM servicess s, invoice i, invoice_lines il, clients c
WHERE s.service_id=il.service_id and il.invoice_id=i.invoice_id and i.client_id=c.client_id;
GO

select *from invoice_lines order by totalAmount;


grant select on object:: Payment_Lines TO WebFatura;

select *from Payment_Lines  ;
