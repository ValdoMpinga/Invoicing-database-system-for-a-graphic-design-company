--ROW NUMBER 
select c.client_id,c.client_name,z.zip_code,z.locality,s.service_namee, sum(iv.totalAmount)  as total, ROW_NUMBER() OVER (PARTITION BY service_namee order by service_namee ) as ROWNUMBER
from zip_code z,clients c, invoice i, 
invoice_lines iv, servicess s,payment_methods p where c.client_zip_code=z.zip_code and c.client_id=i.client_id and i.payment_method=p.payment_method_id and i.invoice_id=iv.invoice_id 
and iv.service_id=s.service_id and s.service_id=2  group by c.client_id, c.client_name,z.zip_code,z.locality,s.service_namee order by total desc;