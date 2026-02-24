--1. Buatlah query SQL untuk menampilkan pesanan yang memiliki 
--jumlah produk terjual (totalsales) lebih tinggi 
--dari rata-rata keseluruhan jumlah produk yang terjual.

Step 1
Hitunglah rata-rata jumlah barang (qty) yang dipesan dalam semua pesanan.
with Tb_rata_qty as (
select
	avg(qty) as rata_qty
from table_detail 
)


Step 2
Tampilkan data yang mencakup orderid, customerid, productid, qty, dan totalsales 
untuk pesanan yang memiliki jumlah produk (qty) lebih besar dari rata-rata jumlah produk (dihitung pada langkah 1). 

with Tb_rata_qty as (
select
	avg(qty) as rata_qty
from table_detail 
)

select 
	orderid,
	customerid,
	productid,
	qty,
	totalsales
from table_detail
where qty > (
		select rata_qty
		from Tb_rata_qty);

--2. Buatlah query untuk menghitung rata-rata dari total penjualan per produk berdasarkan data penjualan yang tersedia.

Step 1
Hitunglah total penjualan (totalsales) untuk setiap produk (productid) berdasarkan data dalam tabel.

with tb_Total_jual as (
select
	productid,
	sum(Totalsales) as Total_jual
from table_detail
group by productid
)



Step 2
Hitunglah rata-rata total penjualan per product (dihitung pada langkah 1) berdasarkan data dalam table.

with tb_Total_jual as (
select
	productid,
	sum(Totalsales) as Total_jual
from table_detail
group by productid
)

select
	avg (total_jual)
from tb_Total_jual

--3. Mengetahui selisih harga setiap produk dibandingkan dengan harga rata-rata semua produk

Step 1
Hitunglah Harga Rata-Rata dari Semua Produk

with tb_rata_harga as (
select
	avg(price) as rata_harga
from table_detail
)

Step 2
Tampilkan data productid, productname, productcategory, price 
dan selisih_harga yang merupakan selisih antara harga product dengan rata-rata harga product secara keseluruhan.

with tb_rata_harga as (
select
	avg(price) as rata_harga
from table_detail
)

select
	productid,
	productname, 
	productcategory, 
	price,
	(price - (
		select rata_harga from tb_rata_harga)) as selisih_harga
	from table_detail
	
--4. Mengetahui pesanan yang memiliki penjualan di atas rata-data, 
--lalu menambahkan column dengan format yang ditampilkan khusus yang mencantumkan 
--ID pesanan serta bulan transaksi dalam satu kolom (Order-<orderid>-Month-<MM>) 
	
Step 1
Buatlah query untuk menampilkan kolom order_info yaitu gabungan antara 
orderid dan month pada orderdate dengan forma sebagai berikut "Order-<orderid>-Month-<MM>" 

with tb_order_info as (
select 
	concat('Order-',orderid,'-Month-',extract('Month' from orderdate)) as order_info
from table_detail
)

Step 2
Tampilkan data orderid, order_info, totalsales yang memiliki total penjualan (totalsales) di atas rata-rata, 
lalu di urutkan dari total penjualan (totalsales) terbesar. 

with tb_order_info as (
select 
	concat('Order-',orderid,'-Month-',extract(Month from orderdate)) as order_info
from table_detail
)

select
	orderid,
	concat('Order-',orderid,'-Month-',extract(Month from orderdate)) as order_info,
	totalsales
from table_detail
where totalsales > (select avg(totalsales) from table_detail)
order by totalsales desc

--5. Produk akan dikategorikan sebagai:
-- Above Average -->  jika total penjualan product tersebut lebih tinggi dari rata-rata total  penjualan per product.
-- Below Average -->  jika total penjualan product lebih rendah atau sama dengan dari rata-rata total penjualan per product.

Step 1
Hitung total nilai penjualan (totalsales) untuk setiap produk.
with tb_total_penjualan as (
select
	productid,
	sum (totalsales) as total_penjualan
from table_detail
group by productid
),

Step 2
Buatlah query untuk menghitung rata-rata dari total penjualan per produk berdasarkan data penjualan yang tersedia. 
tb_rata_penjualan as (
select
	avg(total_penjualan) as rata_penjualan
from tb_total_penjualan
)


Step 3
Buatlah query untuk menghitung total nilai penjualan (totalales) dan kategory penjualan (sales_category) per productnya. 
Dengan nilai sales_category sebagai berikut:
 
- Above Average -->  jika total penjualan product tersebut lebih tinggi dari rata-rata total  penjualan per product.
- Below Average -->  jika total penjualan product lebih rendah atau sama dengan dari rata-rata total penjualan per product.

tampilkan productid, totalsales, sales_category setiap productid nya lalu diurutkan berdasarkan nilai productid terkecil

with tb_total_penjualan as (
select
	productid,
	sum (totalsales) as total_penjualan
from table_detail
group by productid
),

tb_rata_penjualan as (
select
	avg(total_penjualan) as rata_penjualan
from tb_total_penjualan
)

select 
	productid, 
	sum (totalsales) as totalsales,
	case
		when sum (totalsales) > (select rata_penjualan from tb_rata_penjualan) then 'Above Average'
		else 'Below Average'
	end as sales_category
	from table_detail
	group by productid
	order by productid


	
	
	
	


	




























