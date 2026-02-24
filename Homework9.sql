--1. manager ingin mengetahui jumlah pesanan dari setiap product tidak termasuk product yang tidak memiliki pesanan. 
-- Buatlah query SQL dari table_orders dan table_product untuk menampilkan productid, productname 
-- dan qty (jumlah pesanan/order) lalu urutkan dari jumlah pesanan terkecil hingga terbesar 

select distinct
	p.productid,
	p.productname,
	sum(o.qty) as qty
from table_product p 
inner join table_orders o on p.productid = o.productid
group by p.productid, p.productname
order by sum(o.qty)



--2. Manajemen ingin mengetahui daftar pelanggan yang telah melakukan transaksi  
-- beserta produk yang mereka beli, jumlah pesanan, dan total penjualannya.
-- Buatlah query SQL dari table_orders, table_customer dan table_product 
-- untuk menampilkan informasi pesanan yang mencakup nama lengkap pelanggan yang dipisahkan dengan spasi (customer_name),
-- nama produk yang dibeli (productname), jumlah pesanan (qty), dan total penjualan (totalsales). 
-- Urutkan hasil berdasarkan totalsales dari terbesar ke terkecil.

select distinct
	concat(c.firstname,' ',c.lastname) as customer_name,
	p.productname,
	sum(o.qty) as qty,
	sum(o.totalsales) as totalsales
from table_customer c
inner join table_orders o on c.customerid = o.customerid
inner join table_product p on o.productid = p.productid
group by customer_name, p.productname
order by sum(o.totalsales) desc
	
-- 3. Manajemen ingin mengetahui daftar pelanggan yang telah melakukan transaksi 
-- dalam kategori Fast-Moving Consumer Goods (FMCG) setelah 1 Januari 2023, dengan total penjualan lebih dari 1.000.000. 
-- Buatlah query SQL dari table_orders, table_customer dan table_product untuk menampilkan informasi pesanan yang mencakup 
-- nama pelanggan (custome_name), produk yang dibeli (prodcutname), jumlah pesanan (qty), dan total penjualan (totalsales). Hanya tampilkan pesanan yang memiliki data pelanggan yang valid dengan ketentuan sebagai berikut:
-- Pesanan dilakukan setelah tanggal (orderdate) 1 Januari 2023
-- Total penjualan lebih dari 1.000.000
-- Kategori produk adalah 'FMCG'
-- Urutkan hasil berdasarkan totalsales dari terbesar ke terkecil.
	
select distinct	
	concat(c.firstname,' ',c.lastname) as customer_name,
	p.productname,
	sum(o.qty) as qty,
	sum(o.totalsales) as totalsales
from table_customer c
inner join table_orders o on c.customerid = o.customerid
inner join table_product p on o.productid = p.productid
where o.orderdate > '2023-1-1' and p.productcategory = 'FMCG'
group by customer_name, p.productname
having sum(o.totalsales) > 1000000
order by sum(o.totalsales) desc

-- 4. Manajemen ingin mengetahui pelanggan yang memiliki total penjualan kurang dari 300.000.000 
-- atau belum pernah melakukan transaksi pada tahun 2024. 
-- Buatlah Query SQL dari table_orders dan table_customer untuk menampilkan daftar pelanggan yang mencakup 
-- customerid, Nama Pelanggan (customername), Kota (city), Total Jumlah Pesanan (total_qty), dan Total Penjualan (total_sales). 
-- Pastikan semua pelanggan tetap ditampilkan meskipun tidak memiliki pesanan, 
-- dan urutkan hasil berdasarkan total_sales dari yang terkecil ke terbesar.

select distinct	
	c.customerid,
	concat(c.firstname,' ',c.lastname) as customername,
	c.city,
	sum(o.qty) as total_qty,
	sum(o.totalsales) as total_sales
from table_customer c
left join table_orders o using (customerid)
where extract (year from o.orderdate) != '2024'
group by 1,2,3
having sum(o.totalsales) < 300000000
order by total_sales

-- 5. Manajemen ingin menganalisis peringkat penjualan setiap produk berdasarkan total penjualannya pada tahun 2024.
-- Buatlah query SQL dari table_orders dan table_product untuk menampilkan 
-- productid, productname, Total Penjualan (total_sales), dan Peringkat Penjualan (rank_sales). 
-- Gunakan fungsi jendela (window function) untuk menentukan peringkat (RANK()) berdasarkan total_sales secara descending. 
-- Pastikan hanya menampilkan produk yang memiliki transaksi pada tahun tersebut.

select distinct	
	p.productid,
	p.productname,
	sum(o.totalsales) as total_sales,
	rank() over(order by sum(o.totalsales) desc) as rank_sales
from table_product p
inner join table_orders o using (productid)
where extract (year from o.orderdate) = 2024
group by p.productid, p.productname
order by rank_sales


-- 6. Manajemen ingin mengetahui perubahan total penjualan untuk setiap produk antara bulan Januari dan Februari 2024. 
-- Tampilkan hanya produk yang memiliki transaksi di kedua bulan tersebut dan urutkan berdasarkan selisih total penjualan
-- (total_sales_feb - total_sales_jan) dari terbesar ke terkecil. 
-- Buatlah query SQL dari table_orders dan table_product untuk menampilkan informasi productid, 
-- nama produk (productname), total_sales_jan, total_sales_feb, selisih total penjualan (sales_different) 
-- dan urutkan hasil berdasarkan sales_different dari terkecil ke terbesar

with tb_Order_Jan as (
select
	productid,
	sum(totalsales) as Order_Jan
from table_orders
where date_trunc('month', orderdate) = '2024-01-01'
group by productid, date_trunc('month', orderdate)
),
tb_Order_Feb as (
select
	productid,
	sum(totalsales) as Order_Feb
from table_orders
where date_trunc('month', orderdate) = '2024-02-01'
group by productid, date_trunc('month', orderdate)
)
select distinct
	p.productid,
	p.productname,
	round (oja.Order_Jan) as total_sales_jan,
	round (ofe.Order_Feb) as total_sales_feb,
	round (ofe.Order_Feb - oja.Order_Jan) as sales_different
from table_product p
inner join tb_Order_Jan oja using (productid)
inner join tb_Order_Feb ofe using (productid)
order by 5;

-- 7. Tim manajemen ingin menganalisis total penjualan produk pada tahun 2023 dan 2024 secara terpisah 
-- Buatlah query SQL yang menampilkan tahun penjualan (sales_year), productid, productname, dan Total Penjualan (total_sales) 
-- dari setiap produk dalam masing-masing tahun.
-- Gabungkan data penjualan dari kedua tahun tersebut menggunakan metode yang tidak menghapus duplikasi, 
-- dan urutkan hasil berdasarkan tahun secara ascending serta total_sales dalam setiap tahun secara descending.

select 
	extract(year from o.orderdate) as sales_year,
	o.productid,
	p.productname,
	round(sum(o.totalsales)) as total_sales
from table_orders o
inner join table_product p using (productid)
where extract(year from o.orderdate) = '2023' or extract(year from o.orderdate) = '2024'
group by sales_year, o.productid, p.productname
order by sales_year, total_sales desc

-- 8. Seorang manager penjualan ingin mengetahui performa setiap pelanggan 
-- dalam hal jumlah pesanan dan total penjualan yang mereka hasilkan. 
-- Namun, ada beberapa pelanggan yang belum pernah melakukan pesanan. 
-- Manager ingin tetap melihat seluruh daftar pelanggan, dengan total pesanan dan total penjualan mereka. 
-- Jika pelanggan belum pernah melakukan pesanan, data mereka tetap ditampilkan dengan jumlah pesanan 0 
-- dan total penjualan 0.

-- Buatlah query SQL dari table_customer dan table_order untuk menampilkan customerid, customer_name, 
-- city beserta total jumlah pesanan (total_orders) dan total penjualan mereka (total_sales) 
-- Jika pelanggan belum pernah melakukan pesanan, tampilkan jumlah order dan total sales sebagai 0 
--dan urutkan dari pelanggan dengan urutan terendah hingga terbesar. 

select 
	c.customerid,
	concat(c.firstname,' ',c.lastname) as customer_name,
	c.city,
	round(coalesce(sum(o.qty), 0)) as total_orders,
	round(coalesce(sum(o.totalsales), 0)) as total_sales
from table_customer c
left join table_orders o using (customerid)
group by c.customerid, customer_name, c.city
order by total_orders, total_sales
