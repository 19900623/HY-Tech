/* Question1 */
select CustomerID from Customers where City = '�x�_��'

/* Question2 �Ĥ@�ؼg�k*/

select sum(UnitsInStock) from Products where ProductName = '�J�ԯ�' or ProductName = '���A��' or ProductName = '���ԯ�'

/* Question2 �ĤG�ؼg�k*/

select sum(UnitsInStock) from Products where ProductName in('�J�ԯ�','���A��','���ԯ�')

/* Question3 */
select EmployeeName from Employees where Title = '�~��' and TitleOfCourtesy = '�p�j' order by EmployeeName

/* Question4 */
select distinct EmployeeID from Orders where YEAR(OrderDate)=2004

/* Question5 */
select Top(10) EmployeeID from Orders where YEAR(OrderDate)=2003 order by OrderDate

/* Question6 */
select SupplierID from Suppliers where SupplierID in (select SupplierID from Products group by SupplierID having COUNT(SupplierID)>=3) and region = '�̪F'

/* Question7 */
/*�Ĥ@�ؼg�k*/
select COUNT(EmployeeID) from Employees where SUBSTRING(EmployeeName,1,1)='�L'
/*�ĤG�ؼg�k*/
select COUNT(EmployeeID) from Employees where EmployeeName like '�L%'

/* Question8 */
select CompanyName 
from Suppliers 
where SupplierID not in (select p.SupplierID from products as p ,Categories as c where p.CategoryID = c.CategoryID and c.CategoryName IN('��/�a�V','���A')) order by CompanyName

/* Question9 */
  select c.CategoryName, COUNT(ProductID)
  from Categories c , Products p  
  where c.CategoryID = p.CategoryID
  group by c.CategoryName,c.CategoryID
  order by c.CategoryID

/* Question10 */
/*��Orders, OrderDetails, Products join ����]�~����2004, �L�oCategoryID�ACategoryID�h�����Ы�p�⦸��, ���ƭn����Categories����Ƶ���*/
select CustomerID
from Orders join OrderDetails
on Orders.OrderID = OrderDetails.OrderID
join Products
on OrderDetails.ProductID = Products.ProductID
where YEAR(Orders.OrderDate)=2004
group by Orders. CustomerID
having count(distinct Products.CategoryID) = (select count(CategoryID)
from Categories)

/* Question11 */
select so.Year,so.Count,op.Sum,round(op.Sum/so.Count,2) Average
from
--�d�X�Ӧ~�q���`��--
(select Year,sum(countOrder.oneOrder) Count
from
(select year(OrderDate) Year,count(OrderID) oneOrder
from Orders
group by year(OrderDate),OrderID) countOrder
group by Year) so ,
--�d�X�Ӧ~�q���`���B--
(select year(OrderDate) Year,round(sum(od.UnitPrice*od.Quantity*(1-od.Discount)),2) Sum
from OrderDetails od join Orders
on od.orderid = Orders.OrderID
group by year(OrderDate)) op
where so.Year = op.Year
order by op.Sum desc


/* Question12 */
select EmployeeID
from Orders
where year(OrderDate)=2002
group by EmployeeID
having count(EmployeeID)>=20

/* Question13 */
select y.Years,shipcount.shipvia Shipvia 
from 
--�d�X�Ӧ~���A�U�f�B�覡�����ơA�f�B�覡�s��
	(select count(shipvia) countship,shipvia
	from Orders
	group by year(OrderDate),shipvia
	) as shipcount
join
--�d�X�Ӧ~���A�f�B�覡���Ƴ̤j��
	(select Years, MAX(countship) maxship
	from
--�d�X�Ӧ~���A�U�f�B�覡������
	(select year(OrderDate)Years,count(shipvia) countship,shipvia
	from Orders
	group by year(OrderDate),shipvia) as everyYearship
	group by Years) as y
on y.maxship = shipcount.countship
order by y.Years

/* Question14 */
select EmployeeID,EmployeeName
from Employees
where EmployeeID in (select o.EmployeeID --�d�B�z�L�͸۰���U�ݤ��q��EmployeeID
					from Orders o,Customers c
					where o.CustomerID = c.CustomerID and c.CompanyName = '�͸۰���U�ݤ��q'
					)
intersect
select EmployeeID,EmployeeName
from Employees
where EmployeeID in (select o.EmployeeID --�d�B�z�L�v�j�T����EmployeeID
					from Orders o,Customers c
					where o.CustomerID = c.CustomerID and c.CompanyName = '�v�j�T��')


/* Question15 */
select employeename from employees 
where month(birthdate)=6 
order by employeename   
 
/* Question16 */
select OrderID, DATEDIFF(DAY ,RequiredDate,ShippedDate) as DelayDays
from Orders
where RequiredDate < ShippedDate
order by OrderID

/* Question17 */
select manager.EmployeeID,manager.EmployeeName,manager.Salary,count(worker.EmployeeID)as SubCount,avg(worker.Salary) as SubAverageSalary
from Employees worker join Employees manager
on worker.ManagerID =  manager.EmployeeID
group by manager.EmployeeID,manager.EmployeeName,manager.Salary

/* Question18 */
select ProductID,ProductName,UnitsInStock,UnitsOnOrder,ReorderLevel,
case when UnitsInStock>=ReorderLevel then 'safe'
		when UnitsInStock<ReorderLevel and (UnitsOnOrder + UnitsInStock)>=ReorderLevel then 'reordering'
		else 'unsafe'
		end Status
from Products

/* Question19*/
select top(5) EmployeeID,sum(OrderDetails.UnitPrice*OrderDetails.Quantity*(1-OrderDetails.Discount)) TotalPrice
from orders,OrderDetails
where orders.OrderID = OrderDetails.OrderID and year(OrderDate)=2004 and MONTH(OrderDate)=3
group by EmployeeID
order by TotalPrice desc

/* Question20*/

---�Ĥ@�ؼg�k
select COUNT(OrderID)/12 as AvgOrderCnt
from Orders
where YEAR(OrderDate)=2003

---�ĤG�ؼg�k
select AVG(ordermonth)
from --��2003�~�C�Ӥ몺�q�榸�Ƭd�X�Ӧb�h��AVG
	(select COUNT(OrderID) ordermonth
	from Orders
	where YEAR(OrderDate)=2003
	group by MONTH(OrderDate)) countorder


/* Question21*/
select orders.ShipCity,Products.CategoryID,count(Products.CategoryID) Cnt
from Orders,OrderDetails,Products
where Orders.OrderID = OrderDetails.OrderID
and OrderDetails.ProductID = Products.ProductID
group by orders.ShipCity,Products.CategoryID
order by orders.ShipCity,Products.CategoryID

/*Question24*/
ALTER TABLE employees ADD Seniority int
go
update employees set Seniority = DATEDIFF(MONTH,HireDate,'2004-12-31')
go

/*Question25*/
delete from Products
where Discontinued = 1


