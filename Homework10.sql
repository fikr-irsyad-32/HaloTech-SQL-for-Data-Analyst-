-- Reorder Point (ROP) dapat digunakan sebagai actionable metrics untuk mencegah Stockout karena membantu 
-- mengidentifikasi titik stok minimum dimana perusahaan harus melakukan pengisian stok ulang

-- ROP = (Waktu yang dibutuhkan untuk mengisi ulang stok * avg barang yang terjual per hari) + stok cadangan

with tb_jumlah_terjual as(
select
	p.produk_id,
	p.nama_produk,
	p.hari_stok,
	p.cadangan,
	sum(o.qty) over (partition by p.produk_id) as jumlah_terjual
from table_produk p
join table_order o using (produk_id)
),

tb_avgjualperhari as (
select distinct
	produk_id,
	nama_produk,
	hari_stok,
	cadangan,
	(jumlah_terjual/8) as avgjualperhari
from tb_jumlah_terjual
)

select distinct
	produk_id,
	nama_produk,
	(hari_stok * avgjualperhari) + cadangan as Reorder_Point
from tb_avgjualperhari
	
	


-- Sell-Through Rate (STR) dapat digunakan sebagai actionable metrics untuk mencegah Overstocking 
-- karena memberikan sinyal awal mengenai barang yang penjualannya tidak optimal sehingga perusahaan 
-- bisa segera mengambil langkah strategis untuk menangani hal tersebut

-- STR = Jumlah barang terjual / jumlah stok x 100%

with tb_jumlah_terjual as (
select distinct
	p.produk_id,
	p.nama_produk,
	sum (o.qty) over (partition by p.produk_id) as jumlah_terjual,
	p.stok
from table_produk p
join table_order o using (produk_id)
)

select 
	produk_id,
	nama_produk,
	(jumlah_terjual:: numeric / stok:: numeric) * 100 as Sell_Through_Rate
from tb_jumlah_terjual



