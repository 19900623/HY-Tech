declare @mytable table(EmployeeID int,Salary int)  --�ŧi�@�ӼȦs���mytable 

--Part1 ��j�D�ު�EmployeeID�M���~�᪺�~���[�Jmytable 

insert into @mytable
-- �p�G���~���~��������~���h5000�H�W�A�̦h��5000�A�_�h�̷ӽ��~���~��
select e.EmployeeID, case when (big.newsal - e.salary) >= 5000 then e.salary+5000
							else  big.newsal end salary 
							
from Employees e, -- �p�G�B�z���Ƥ���50��99�����h���~1.05���A�p�G�B�z���Ƥj��100�h���~1.1��
				(select EmployeeID,case when bigmanager.ordercount between 50 and 99 then Salary *1.05
												when bigmanager.ordercount >=100 then Salary *1.10
												else Salary
												end newsal
				from Employees,   --�d�B�z�W�L50�����j�D�ު�id�M����
								(select e.EmployeeID as empid ,count(o.OrderID) as ordercount
								from Employees e ,Orders o
								where e.EmployeeID = o.EmployeeID and e.ManagerID is null
								group by e.EmployeeID
								having count(o.OrderID)>=50 
								) bigmanager    
				where Employees.EmployeeID = bigmanager.empid)big 
where e.EmployeeID = big.EmployeeID

-----�ק�Employees���j�D�ު��~��

update Employees set Salary = mytable.Salary
from Employees join @mytable mytable
on Employees .EmployeeID = mytable.EmployeeID
----------------------------------------------------------------------------------------------------------------------------------------------
-- Part2 ��p�D�ު�EmployeeID�M���~�᪺�~���[�Jmytable 
insert into @mytable
-- �p�G���~���~����j�D�ަh�h�~���̦h�զ���j�D�ޤ@��
select middle.EmployeeID,case when middlesal>big.Salary then big.Salary
							  else middlesal
							  end newmiddlesal 					
from Employees big,		-- �p�G���~���~��������~���h5000�H�W�A�̦h��5000�A�_�h�̷ӽ��~���~��
					(select e.EmployeeID, e.Salary , e.ManagerID,case when (middle.newsal- e.Salary)>=5000 then e.Salary+5000
														 else  middle.newsal
														 end middlesal	
					from Employees e,    -- �p�G�B�z���Ƥ���50��99�����h���~1.05���A�p�G�B�z���Ƥj��100�h���~1.1��	
									(select e1.EmployeeID ,salary ,case when middlemanager.ordercount between 50 and 99 then Salary *1.05
																	when middlemanager.ordercount >=100 then Salary *1.10
																	else Salary
																	end newsal
											
									from Employees e1, --�d�B�z�W�L50�����D�ު�id�M���ơA�B�L�D�ެO�j�D��
													(select e.EmployeeID empid ,count(o.OrderID)ordercount 
													from Employees e ,Orders o							  --�d�X�D��id�Onull���Ҧ����uid
													where e.EmployeeID = o.EmployeeID and e.EmployeeID in(select worker.EmployeeID
																										  from Employees worker ,Employees manager
																										  where worker.ManagerID = manager.EmployeeID and manager.ManagerID is null)
													group by e.EmployeeID
													having count(o.OrderID)>=50) middlemanager
									where e1.EmployeeID = middlemanager.empid) middle
					where e.EmployeeID = middle.EmployeeID) middle
where big.EmployeeID = middle.ManagerID


-----�ק�p�D���~��

update Employees set Salary = mytable.Salary
from Employees join @mytable mytable
on Employees .EmployeeID = mytable.EmployeeID
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--����u��EmployeeID�M���~�᪺�~���[�Jmytable 
insert into @mytable
--�p�G���~���~����p�D�ަh�h�~���̦h�զ���p�D�ޤ@��
select newemp.EmployeeID,case when empsal >e.Salary then e.Salary
			else empsal
			end empsal2	
from Employees e  -- �p�G���~���~��������~���h5000�H�W�A�̦h��5000�A�_�h�̷ӽ��~���~��		 
				,(select e.EmployeeID , e.Salary ,e.ManagerID, case when (newsal -e.Salary)>5000  then e.Salary+5000
															 else newsal
															 end empsal	
				from Employees e,  -- �p�G�B�z���Ƥ���50��99�����h���~1.05���A�p�G�B�z���Ƥj��100�h���~1.1��
								(select e.EmployeeID , e.Salary ,case when ordercount between 50 and 99 then e.Salary*1.05
																	 when ordercount >=100 then	e.Salary*1.1
																	 else e.Salary
																	 end newsal						
								from Employees e,
												(select e.EmployeeID,COUNT(o.OrderID) ordercount --�d�X�B�z�q��ƶq>=50�������u
												from Orders o , Employees e
												where o.EmployeeID  = e.EmployeeID and e.managerid in (select worker.EmployeeID     --�d�X�p�D��id
																									from Employees worker ,Employees manager
																									where worker.ManagerID = manager.EmployeeID and manager.ManagerID is null)																							
												group by  e.EmployeeID
												having COUNT(o.OrderID)>=50) empcount
								where e.EmployeeID = empcount.EmployeeID) emp
				where e.EmployeeID = emp.EmployeeID) newemp
where e.EmployeeID = newemp.ManagerID
-----�ק���u�~��
update Employees set Salary = mytable.Salary
from Employees join @mytable mytable
on Employees .EmployeeID = mytable.EmployeeID 