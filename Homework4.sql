select 
	productid,
	count(orderid) as Total_order,
	sum(qty) as qty,
	sum(totalsales) as total_sales
from order_detail
group by productid
order by total_sales desc;

select
	case 
		when qty <= 3 then 'Small Order'
		else 'Large Order'
	end as Kategori_Pesanan,
	avg(totalsales) as Ratarata_penjualan
from order_detail
group by Kategori_Pesanan;

select
	customerid as ID_Pelanggan,
	min(orderdate) as first_order_date,
	max(orderdate) as last_order_date,
	count(orderid) as Total_orders
from order_detail
group by ID_Pelanggan;

select 
	substring(productid, 1, (length (productid)-4)) as Kategori_product,
	sum(qty) as Total_order
from order_detail
group by Kategori_product;

select
	extract(month from orderdate) as month,
	sum (totalsales) as total_sales
from order_detail
where orderdate between '2022-12-31' and '2024-01-01' 
group by month
having sum (totalsales) > 1000000
order by month;
	
select
	concat(firstname,' ',lastname) as nama_pelanggan,
	cast(extract(year from orderdate) as text) as Tahun,
	count(orderid) as Jumlah_transaksi
from order_detail
group by tahun, nama_pelanggan
having count(orderid) > 500
order by tahun, nama_pelanggan;

select
	cast(extract(year from orderdate) as text) as Tahun_Transaksi,
	count(case when gender = 'Male' then gender end) as Male_customer,
	count(case when gender = 'Female' then gender end) as Female_customer
from order_detail
group by Tahun_Transaksi
order by Tahun_Transaksi;

select 
	city,
	sum(totalsales) as total_sales,
	count (distinct customerid) as Total_customer
from order_detail
where city is not null
group by city
order by total_sales desc;

select 
	substring(phone, 1, 4) as kode_provider,
	count(distinct customerid) as Jumlah_Pelanggan_unik,
	sum(totalsales) as Total_penjualan
from order_detail
group by kode_provider
having count(distinct customerid) < 3 and sum(totalsales) > 6000000000
order by Total_penjualan desc
limit 2;
	


















	


