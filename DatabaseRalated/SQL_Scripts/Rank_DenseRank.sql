select p.payment_method_descrition,i.client_id,i.invoice_emission_date,iv.totalAmount,
rank() over (partition by payment_method_id order by payment_method_id asc) as [Rank],
DENSE_RANK() over (partition by payment_method_id order by  payment_method_id) AS DenseRank 
from  invoice i, invoice_lines iv ,payment_methods p where p.payment_method_id=i.payment_method and i.invoice_id=iv.invoice_id ;