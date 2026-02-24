select * from transactions

-- 1. Sebuah perusahaan fintech menyadari bahwa sepertinya terdapat fraud pada transaksi pengguna, 
-- oleh karena itu anda sebagai Data Analyst diminta untuk menginvestigasi lalu mengindentifikasi 
-- kemungkinan fraud berdasarkan pola transaksi pengguna. 
-- pertama kita akan menentukan berdasarkan transaksi yang lebih dari 5 transaksi dalam 30 menit, 
-- maka transaksi tersebut di curigai sebagai abuse atau card testing. 
-- Buatlah query agar anda dapat menentukan transaksi yang mencurigai tersebut? 

with tb_transaksi_30minute as (
select
	*,
	count (transaction_id) over (partition by user_id order by transaction_time 
		range between interval '30 minutes' preceding and current row) as transaksi_30minute
from transactions
)
select 
	user_id,
	card_number,
	transaksi_30minute
from tb_transaksi_30minute
where transaksi_30minute > 5

-- 2. Selanjutnya kita akan Mendeteksi Transaksi di Lokasi Berbeda dalam Waktu Singkat.
-- Jika seorang pengguna melakukan transaksi di dua lokasi berbeda dalam waktu kurang dari 1 jam, 
-- kemungkinan kartunya dicuri atau digunakan oleh pihak lain. 
-- Buatlah query agar anda dapat menentukan transaksi yang mencurigai tersebut?

with tb_kota_1jam as(
select
    t1.*,
    count(distinct t2.location) as kota_1jam
from transactions t1
join lateral(
    select 
    	location
    from transactions t2
    WHERE t2.user_id = t1.user_id
      and t2.transaction_time between t1.transaction_time - interval '59  minutes' and t1.transaction_time
) t2 on true
group by t1.transaction_id, t1.user_id, t1.card_number, t1.transaction_amount, t1.transaction_time, t1.location
)
select distinct
	user_id,
	card_number,
	kota_1jam
from tb_kota_1jam
where kota_1jam > 1
	
-- 3. Rumah Sakit tempat anda bekerja mengalami lonjakan pasien pada waktu tertentu, menyebabkan keterlambatan pelayanan. 
-- Manajemen ingin memprediksi tingkat kepadatan pasien untuk mengalokasikan sumber daya dengan lebih baik.
-- Tentukan satu actionable metrics yang dapat membantu rumah sakit dalam menganalisis tren kepadatan pasien dan 
-- meningkatkan efisiensi layanan kesehatan.
-- Jelaskan bagaimana masing-masing metric dapat digunakan untuk optimalisasi pelayanan. Berikan rumus dan cara penerapannya.
-- Hints: Bed Occupancy Rate, Patient Flow Efficiency, Average Waiting Time

with tb_totalwaktu as(
select 	
	sum(menit_antri) as totalwaktu_antri,
	sum(menit_tindakan) as totalwaktu_tindakan,
	sum(menit_hasil) as totalwaktu_hasil
from table_pelayanan
)
select
	totalwaktu_tindakan :: numeric/(totalwaktu_antri + totalwaktu_tindakan + totalwaktu_hasil) as Patient_Flow_Efficiency
from tb_totalwaktu



