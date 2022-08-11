use kelas_sql;

select * from pegawai;
select * from klien;
select * from cabang;
select * from pj_klien;
select * from supplier_cabang;

# no 1
use kelas_sql;
select id_pegawai, concat(nama_depan, ' ', nama_belakang) nama_pegawai,
	nama_cabang, sum(total_penjualan) total_sales
from pegawai
join pj_klien
using (id_pegawai)
join cabang
using (id_cabang)
group by id_pegawai
having total_sales > 10000000
order by total_sales asc;

# no 2
select id_mgr, nama_cabang, count(*) jumlah_pegawai
from pegawai
join cabang
using (id_cabang)
where id_mgr != id_pegawai
group by id_mgr;

# no 3
select nama_cabang,
	concat(nama_depan, ' ', nama_belakang) nama_pegawai,
	max(total_penjualan) maximum_sales
from cabang
join pegawai
using (id_cabang)
join pj_klien
using (id_pegawai)
group by nama_cabang;

use 3_odds;

select * from customers;
select * from employees;
select * from offices;
select * from orderdetails;
select * from orders;
select * from payments;
select * from productlines;
select * from products;

# no 4
use 3_odds;
select employeeNumber,
	concat(firstName, ' ', lastName) employeeName,
    count(customerName) countCustomer
from employees e
join customers c
on e.employeeNumber = c.salesRepEmployeeNumber
group by employeeName
having countCustomer > 7
order by countCustomer desc;

# no 5
with pegawai as (
	select employeeNumber, officeCode,
		concat(firstName, ' ', lastName) employeeName,
        country
    from employees
    join offices
    using (officeCode)
    )
select country, count(employeeNumber) numberOfEmployee
from pegawai
where country != 'USA'
group by country;

# no 6
select distinct country from customers;
select customerName, country,
	case country
		when 'South Africa' then 'Africa'
		when 'USA' then 'America'
		when 'Australia' then 'Australia' 
        when 'New Zealand' then 'Australia'
        when 'Singapore' then 'Asia'
        when 'Japan' then 'Asia'
        when 'Hong Kong' then 'Asia'
        when 'Philippines' then 'Asia'
        else 'Europe'
    end continent
from customers
order by continent;

# no 7
select productCode, avg(priceEach) avgPrice,
	case
		when avg(PriceEach) >= 100 then 'High Price'
        when avg(PriceEach) < 100 then 'Low Price'
	end category
from products
join orderdetails
using (productCode)
group by productCode
order by avgPrice;

# no 8
drop function customerSegmen;
delimiter $$
create function customerSegmen(creditLimit decimal(10,2))
returns varchar(50)
deterministic
begin
	case
		when creditLimit > 50000 then return 'PLATINUM';
        when creditLimit >= 10000 then return 'GOLD';
        else return 'SILVER';
	end case;
end $$
delimiter ;

select customerName, creditLimit, customerSegmen(creditLimit) customerSegmen
from customers
order by creditLimit;


