create or replace trigger checkSalary
before update of salary on EMPLOYEE
for each row
begin
    if (:new.salary > 10000) then
	raise_application_error(-20001, 'New salary ' ||
        :new.salary || ' is greater than 10,000');
    end if;
    --
end;
/
show error
