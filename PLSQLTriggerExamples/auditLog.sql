create or replace trigger tripAuditLog
   after update or delete on TRIP
   for each row
DECLARE
   lTransaction varchar2(20);
begin
   lTransaction := case
	when updating then 'Update'
	when deleting then 'Delete'
   end;
   --
   -- Insert a row into the audit table
   insert into logs (tableName, transName, transDate, userName)
	values ('TRIP', lTransaction, SYSDATE, USER);
end;
/
show error

