1. -- Tampilkan pesanan yang memiliki jumlah produk terjual (totalsales) 
-- lebih tinggi dari rata-rata keseluruhan jumlah produk yang terjual

Step 1
Hitunglah rata-rata jumlah barang (qty) yang dipesan dalam semua pesanan.

select
	avg(qty)
from table_detail;


Step 2
Tampilkan data yang mencakup orderid, customerid, productid, qty, dan totalsales 
untuk pesanan yang memiliki jumlah produk (qty) lebih besar dari rata-rata jumlah produk (dihitung pada langkah 1). 
Note: gunakan subquery untuk menggabungkan dengan query pada langkah 1.

select
	orderid,
	customerid,
	qty,
	totalsales
from table_detail
where qty > (select
	avg(qty)
from table_detail);

2. -- Buatlah query untuk menghitung rata-rata dari total penjualan per produk berdasarkan data penjualan yang tersedia.

Step 1
Hitunglah total penjualan (totalsales) untuk setiap produk (productid) berdasarkan data dalam tabel.

select
	productid,
	sum(totalsales) as Penjualan_Perproduk
from table_detail
group by productid
	


Step 2
Hitunglah rata-rata total penjualan per product (dihitung pada langkah 1) berdasarkan data dalam table. 
Note: gunakan subquery untuk menggabungkan dengan query pada langkah 1.

select
	avg(Penjualan_Perproduk)
from (select
	productid,
	sum(totalsales) as Penjualan_Perproduk
from table_detail
group by productid);



3. --Mengetahui selisih harga setiap produk dibandingkan dengan harga rata-rata semua produk.

Step 1
Hitunglah Harga Rata-Rata dari Semua Produk

select
	avg(price)
from table_detail;


Step 2
Tampilkan data productid, productname, productcategory, 
price dan selisih_harga yang merupakan selisih antara harga product dengan rata-rata harga product secara keseluruhan.
Note: gunakan subquery untuk menggabungkan dengan query pada langkah 1.

select 	
	productid,
	productname,
	productcategory,
	price,
	(price-(select
	avg(price)
from table_detail)) as selisih_harga
from table_detail
group by productid, productname, productcategory, price;

	
4. --mengetahui pesanan yang memiliki penjualan di atas rata-data, 
--lalu menambahkan column dengan format yang ditampilkan khusus yang 
--mencantumkan ID pesanan serta bulan transaksi dalam satu kolom (Order-<orderid>-Month-<MM>) 

Step 1
Buatlah query untuk menampilkan kolom order_info yaitu 
gabungan antara orderid dan month pada orderdate dengan format sebagai berikut 
"Order-<orderid>-Month-<MM>" 

select
	concat ('Order-',orderid,'-Month-',(extract(month from orderdate))) as order_info
from table_detail


Step 2
Tampilkan data orderid, order_info, totalsales yang memiliki total penjualan (totalsales) di atas rata-rata, 
lalu di urutkan dari total penjualan (totalsales) terbesar. 
Note: gunakan subquery untuk menggabungkan dengan query pada langkah 1.

select 	
	orderid, 
	concat ('Order-',orderid,'-Month-',(extract(month from orderdate))) as order_info,
	totalsales
from table_detail
where totalsales > (select
	avg(totalsales)
from table_detail)
order by totalsales desc;


5. --Produk akan dikategorikan sebagai:
-- Above Average -->  jika total penjualan product tersebut lebih tinggi dari rata-rata total  penjualan per product.
-- Below Average -->  jika total penjualan product lebih rendah atau sama dengan dari rata-rata total penjualan per product.

Step1
Hitung total nilai penjualan (totalsales) untuk setiap produk.
select
	productid,
	sum(totalsales) as Jumlahtotal
from table_detail
group by productid



Step 2
Buatlah query untuk menghitung rata-rata dari total penjualan per produk berdasarkan data penjualan yang tersedia. 
select
	avg(Jumlahtotal)
from (select
	productid,
	sum(totalsales) as Jumlahtotal
from table_detail
group by productid)



Step 3
Buatlah query untuk menghitung total nilai penjualan (totalales) dan 
kategory penjualan (sales_category) per productnya. Dengan nilai sales_category sebagai berikut:
- Above Average -->  jika total penjualan product tersebut lebih tinggi dari rata-rata total  penjualan per product.
- Below Average -->  jika total penjualan product lebih rendah atau sama dengan dari rata-rata total penjualan per product.

tampilkan productid, totalsales, sales_category setiap productid nya lalu diurutkan berdasarkan nilai productid terkecil

noted: query pada step 1 dan step 2 dapat di gabungkan untuk menghasilkan 


select
	productid,
	sum(totalsales),
	case 
		when sum(totalsales) > 
		(select
	avg(Jumlahtotal)
from (select
	productid,
	sum(totalsales) as Jumlahtotal
from table_detail
group by productid) AS RataTotal)
	then 'Above Average'
	else 'Below Average'
	end	as sales_category
from table_detail
group by productid
order by productid;








