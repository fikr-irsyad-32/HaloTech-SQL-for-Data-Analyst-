select * from table_orders
limit 15;


select 
	orderid, orderdate, customerid, productid, qty,
	floor(totalsales) SalesBulatBawah
from table_orders
order by SalesBulatBawah desc;


select
		orderid,
		cast(extract(day from orderdate) as int) Tanggal,
		cast(totalsales as integer) TotalSales
from table_orders
where orderdate between'2024-06-01' and '2024-06-30'
order by Tanggal;


select 
	cast(extract(week from orderdate) as int) week,
	qty,
	cast(totalsales as int)
from table_orders
where orderdate between '2024-01-01' and '2024-12-31'
order by week;



Sebagai seorang data analyst, anda memiliki Idea untuk menganalisis data berdasarkan total_sales, 
dengan cara mengkategorikan totalsales menjadi 3 level. 
Anda akan membuat column dengan nama "tingkat_penjualan", 
jika totalsales lebih dari atau sama dengan Rp.1.000.000 dikategorikan sebagai nilai "Tinggi", 
jika totalsales kurang dari Rp 1.000.000 dan lebih dari atau sama dengan Rp 500.000 dikategorikan sebagai nilai "Sedang", 
dan Jika totalsales kurang dari Rp.500.000 dikategorikan sebagai nilai "Rendah". 
Buatlah query untuk menampilkan data orderid, totalsales, dan juga "tingkat_penjualan" 


select 
	orderid,
	totalsales,
	case 
		when totalsales >999999 then 'Tinggi'
		when totalsales between 500000 and 999999 then 'Sedang'
		else 'Rendah' 
	end Tingkat_Penjualan
from table_orders;




