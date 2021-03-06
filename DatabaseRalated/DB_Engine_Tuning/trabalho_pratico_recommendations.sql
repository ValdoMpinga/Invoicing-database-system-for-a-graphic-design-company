use [trabalho_pratico]
go

CREATE NONCLUSTERED INDEX [_dta_index_invoice_9_1701581100__K1_K2_K3] ON [dbo].[invoice]
(
	[invoice_id] ASC,
	[payment_method] ASC,
	[client_id] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_1701581100_2_3_1] ON [dbo].[invoice]([payment_method], [client_id], [invoice_id])
go

SET ANSI_PADDING ON

go

CREATE NONCLUSTERED INDEX [_dta_index_clients_9_1589580701__K1_K2_3] ON [dbo].[clients]
(
	[client_id] ASC,
	[client_zip_code] ASC
)
INCLUDE([client_name]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_1589580701_2_1] ON [dbo].[clients]([client_zip_code], [client_id])
go

CREATE NONCLUSTERED INDEX [_dta_index_invoice_lines_9_1765581328__K3_2_7] ON [dbo].[invoice_lines]
(
	[service_id] ASC
)
INCLUDE([invoice_id],[totalAmount]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_1765581328_3_2] ON [dbo].[invoice_lines]([service_id], [invoice_id])
go

