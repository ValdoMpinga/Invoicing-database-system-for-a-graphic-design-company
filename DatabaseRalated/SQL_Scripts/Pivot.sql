--PIVOT DOS METODOS DE PAGAMENTO E O TOTAL ARRECADADO NOS MESMOS
select numerario,cartao,cheque,MBway 
from
(
	select p.payment_method_descrition,i.invoice_emission_date,iv.totalAmount
	from invoice i, invoice_lines iv, payment_methods p where i.invoice_id=iv.invoice_id and i.payment_method=p.payment_method_id
)	AS invoice_pivot_table 
pivot
(
	sum(totalAmount)  for payment_method_descrition in ([numerario],[cartao],[cheque],[MBway])
)as tabelaPivot


