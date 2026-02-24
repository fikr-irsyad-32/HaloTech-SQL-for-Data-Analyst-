-- 1. Tampilkan orderid, ordderdate, customerid, totalsales, dan avg_sales 
serta urutkan dengan orderid dan orderdate ASC 

select
	orderid,
	orderdate,
	customerid,
	totalsales,
	avg(totalsales) over() as avg_sales
from table_detail
order by orderid, orderdate


--2. Tampilkan orderid, orderdate, customerid, totalsales, serta total penjualan kumulatif 
berdasarkan urutan orderdate dan orderid terkecil. 
Jangan lupa untuk diurutkan hasil akhirnya berdasarkan orderdate dan orderid.

select 	
	orderid,
	orderdate,
	customerid,
	totalsales,
	sum(totalsales) over(order by orderdate, orderid) as cumulative_sales
from table_detail
order by orderdate, orderid
	
--3. Tampilkan orderid, orderdate, customerid, productcategory, totalsales, 
serta total penjualan kumulatif dalam setiap kategori produk berdasarkan orderdate dan orderid. 
Jangan lupa hasil akhirnya diurutkan berdasarkan productcategory, orderdate dan orderid.

select
	orderid,
	orderdate,
	customerid,
	productcategory, 
	totalsales,
	sum(totalsales) over (partition by productcategory order by orderdate, orderid) as cumulative_sales_per_category
from table_detail
order by productcategory, orderdate, orderid

--4. Tampilkan productcategory, orderid, orderdate, customerid, totalsales, 
serta rata-rata total penjualan per-harinya dalam setiap kategori produk 
dan hasil akhirnya diurutkan berdasarkan productcategory, orderdate, dan orderid.

select 
	productcategory, 
	orderid, 
	orderdate, 
	customerid, 
	totalsales,
	avg(totalsales) over(partition by productcategory, orderdate) as rata_rata_sales_per_category_tiap_harinya
from table_detail
order by productcategory, orderdate, orderid

--5. Ketahui 3 pelanggan yang melakukan 3 transaksi pertama di setiap bulannya.
Tampilkan orderdate, orderid, fullname (firstname + lastname), productid, qty,  dan totalsales. 
Jangan lupa untuk diurutkan dari pemesanan dibulan terkahir (orderdate).

with tb_urutan_order as (
select
	orderdate,
	orderid,
	row_number() over (partition by date_trunc('Month', orderdate) 
		order by date_trunc('Month', orderdate) desc, orderdate) as urutan_order,
	concat(firstname,' ',lastname) as fullname,
	productid,
	qty,
	totalsales
from table_detail
)

select
	orderdate,
	orderid,
	urutan_order,
	fullname,
	productid,
	qty,
	totalsales
from tb_urutan_order
where urutan_order <= 3

--6. Simpan hanya satu transaksi unik berdasarkan customerid dan orderdate, sementara duplikasi lainnya harus dihapus.

Step 1
Tampilkan orderid, orderdate, customerid, totalsales, serta nomor urut transaksi (kolom nomor urut) 
berdasarkan kombinasi customerid dan orderdate menggunakan fungsi ROW_NUMBER().
select
	orderid,
	orderdate,
	customerid,
	totalsales,
	row_number() over(partition by customerid, orderdate) as nomor_urut
from table_detail

Step 2
Setelah mengidentifikasi transaksi duplikat, Hapus transaksi duplikat tersebut 
dan hanya menyisakan satu transaksi unik per kombinasi customerid dan orderdate.

Hapus transaksi yang memiliki nomor urut lebih dari 1, sehingga hanya satu transaksi unik yang tersisa 
untuk setiap pelanggan per tanggal transaksi.
Gunakan Delete dan fungsi CTE untuk mempermudah query


with tb_nomor_urut as (
select
	orderid,
	orderdate,
	customerid,
	totalsales,
	row_number() over(partition by customerid, orderdate) as nomor_urut
from table_detail
)

delete from table_detail
where orderid in (select orderid from tb_nomor_urut where nomor_urut > 1)

--7. Tampilkan productcategory, tahun_order, total_penjualan (seluruh total sales per produk per tahun) 
serta peringkat transaksi berdasarkan total_penjualan dalam setiap kategori produk per tahunnya 
menggunakan fungsi DENSE_RANK(). 
Dan diurutkan berdasarkan productcategory dan tahun_order

with tb_total_penjualan as (
select distinct
	productcategory, 
	to_char (orderdate, 'YYYY') as tahun_order,
	sum (totalsales) over(partition by productcategory, (extract (year from orderdate))) as total_penjualan
from table_detail
)

select
	productcategory,
	tahun_order,
	total_penjualan,
	dense_rank () over(partition by productcategory order by total_penjualan desc) as Sales_rank_produk_per_tahun
from tb_total_penjualan
order by productcategory, tahun_order

--8. Tampilkan orderid, orderdate, customerid, productcategory, totalsales, 
serta kuartil penjualan berdasarkan totalsales dalam setiap kategori produk, menggunakan fungsi NTILE(). 
Jangan lupa diurutkan dengan orderid dan orderdate ASC.

select 
	orderid, 
	orderdate, 
	customerid, 
	productcategory, 
	totalsales,
	ntile(4) over(partition by productcategory order by totalsales desc) as sales_quartile
from table_detail
order by orderid, orderdate

--9. Tampilkan orderid, orderdate, customerid, totalsales, 
serta next_totalsales yang menunjukkan total penjualan dari transaksi berikutnya untuk setiap pelanggan. 
Jangan lupa diurutkan dengan customerid dan orderdate ASC.

select
	orderid, 
	orderdate, 
	customerid, 
	totalsales,
	lead(totalsales) over(order by customerid, orderdate) as next_totalsales
from table_detail

--10. Tampilkan customerid, fullname, tahun_bulan_order, total_sales_per_bulan,  
previous_totalsales, dan percentage difference. 
Jangan lupa diurutkan berdasarkan customerid.
Hint: percentage difference = current_total_sales_per_bulan / previous_total_sales_per_bulan

with tb_total_sales_per_bulan as(
select distinct
	customerid,
	concat(firstname,' ',lastname) as fullname,
	to_char(orderdate, 'YYYY-MM') as tahun_bulan_order,
	sum(totalsales) over(partition by customerid, date_trunc('Month', orderdate)) as total_sales_per_bulan
from table_detail
order by customerid, tahun_bulan_order
),

tb_previous_totalsales as(
select
	customerid,
	fullname,
	tahun_bulan_order,
	cast(total_sales_per_bulan as float),
	lag(total_sales_per_bulan) over() as previous_totalsales
from tb_total_sales_per_bulan
order by customerid, tahun_bulan_order
)

select
	customerid,
	fullname,
	tahun_bulan_order,
	total_sales_per_bulan,
	previous_totalsales,
	round(total_sales_per_bulan / previous_totalsales * 100) as percentage_difference
from tb_previous_totalsales
order by customerid, tahun_bulan_order
	
	


	



	
	
	
