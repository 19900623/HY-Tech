create trigger shippers_trigger
on shippers
for update,insert,delete
as
	declare @time datetime
	declare @Operation varchar(6)
	declare @DelShipperId int
	declare @DelCompany nvarchar(40)
	declare @DelPhone nvarchar(24)
	declare @InsShipperId int
	declare @InsCompany nvarchar(40)
	declare @InsPhone nvarchar(24)
	begin
	
	/*�s�W*/
	/*�Yinserted��d���ƥBdeleted�d�����ơA�h���s�W���ʧ@*/
	if (Select Count(*) From inserted) > 0 and (Select Count(*) From deleted) = 0
    begin
		set @time = sysdatetime()
		set @Operation = 'Insert'
		SELECT @InsShipperId=ShipperID,@InsCompany=CompanyName,@InsPhone=Phone FROM inserted;
		Insert Into ShippersLog(Time,Operation,InsShipperID,InsCompanyName,InsPhone) 
		values(@time,@Operation,@InsShipperId,@InsCompany,@InsPhone)
    end
	
	/*�R��*/
	/*�Ydeleted��d���ƥBinserted�d�����ơA�h���R�����ʧ@*/
	 if (Select Count(*) From inserted) = 0 and (Select Count(*) From deleted) > 0
    begin
		set @time = sysdatetime()
		set @Operation = 'Delete'
		SELECT @DelShipperId=ShipperID,@DelCompany=CompanyName,@DelPhone=Phone FROM deleted;
		Insert Into ShippersLog(Time,Operation,DelShipperID,DelCompanyName,DelPhone) 
		values(@time,@Operation,@DelShipperId,@DelCompany,@DelPhone)
    end
    /*�ק�*/
    /*�Yinserted��d���ƥBdeleted�]�d���ơA�h���ק諸�ʧ@*/
    if (Select Count(*) From inserted) > 0 and (Select Count(*) From deleted) > 0
    begin
		set @time = sysdatetime()
		set @Operation = 'Update'
		SELECT @DelShipperId=ShipperID,@DelCompany=CompanyName,@DelPhone=Phone FROM deleted;
		
		SELECT @InsShipperId=ShipperID,@InsCompany=CompanyName,@InsPhone=Phone FROM inserted;
		
		Insert Into ShippersLog(Time,Operation,DelShipperID,DelCompanyName,DelPhone,InsShipperID,InsCompanyName,InsPhone) 
		values(@time,@Operation,@DelShipperId,@DelCompany,@DelPhone,@InsShipperId,@InsCompany,@InsPhone)
	
    end
	
	end
	
	go
	
	
	
	
	/*
	drop trigger shippers_trigger
	
	insert into Shippers (CompanyName,Phone)values('�H123�B','0972217353')
	
	delete from Shippers where ShipperID = 8
	
	update Shippers set CompanyName='456' where ShipperID = 7
	
	truncate table shipperslog */