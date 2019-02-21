# SoalShift_modul1_A02
1.	Anda diminta tolong oleh teman anda untuk mengembalikan filenya yang telah dienkripsi oleh seseorang menggunakan bash script, file yang dimaksud adalah nature.zip. Karena terlalu mudah kalian memberikan syarat akan membuka seluruh file tersebut jika pukul 14:14 pada tanggal 14 Februari atau hari tersebut adalah hari jumat pada bulan Februari.
Hint: Base64, Hexdump

Jawaban:

Arsip nature.zip tersebut berisi file .jpg yang tidak bisa buka sebagai gambar karena terenkripsi/ter-encode dengan Base64. Jika dibuka di suatu text editor akan terhilat seperti ini:

Untuk men-decode file tersebut kita perlu lakukan:
```bash
base64 -di inp.jpg > out.jpg   // -d untuk mendecode -i untuk mengabaikan karakter non-alfabet
```
Namun setelah di-decode file tersebut masih belum bisa dibuka sebagai gambar.Hal ini dikarenakan output program tersebut dalam bentuk hexdump yaitu representasi data dalam bentuk hexadecimal. Agar program image viewer bisa membaca file tersebut sebagai gambar, hexdump tersebut perlu diubah ke bentuk binary dengan reverse hexdump.

Reverse hexdump dapat dilakukan dengan suatu program hexdump yakni xxd. Untuk men-reverse hexdump file tersebut kita perlu lakukan:

	xxd  -r inp.jpg > out.jpg   // -r untuk reverse hexdump

Setelah reverse hexdump dilaksanakan file tersebut dapat dibuka sebagai gambar.


Bash script selengkapnya adalah sebagai berikut:
```bash
#!/bin/bash

if [[ -e  nature.zip ]]; then                               //jika nature.zip ada (pada tempat script), jalankan, jika error/tidak ada,            
                                                            // exit(-e) dari if
                                                            
  unzip nature.zip                                          // unzip nature
  mv nature temp                                            // ganti directory yg di-unzip menjadi temp
  mkdir nature                                              // buat directory baru bernama nature
  for file in $PWD/temp/*.jpg                               // untuk setiap file *.jpg di /temp
  do base64 -di $file | xxd -r > $PWD/nature/${file##*/}    //lakukan base64, kemudian reverse hex dump dan di-outputkan dengan nama yg sama
                                                            //di folder /nature   
  done                                                    
  rm -rf temp                                               // hapus directory temp
  rm nature.zip                                             // hapus nature.zip lama
  zip nature.zip nature  //zip /nature baru
  rm -rf nature  //hapus folder nature
fi
```

Agar skrip tersebut dijalankan pada pukul 14:14 pada tanggal 14 Februari atau hari tersebut adalah hari jumat pada bulan Februari, cronjob yang sesuai adalah sebagai berikut:

	14 14 14 2 * bash soal1.sh
	14 14 14 2 5 bash soal1.sh


2.	Anda merupakan pegawai magang pada sebuah perusahaan retail, dan anda diminta untuk memberikan laporan berdasarkan file WA_Sales_Products_2012-14.csv. Laporan yang diminta berupa:
a.	Tentukan negara dengan penjualan(quantity) terbanyak pada tahun 2012.
b.	Tentukan tiga product line yang memberikan penjualan(quantity) terbanyak pada soal poin a.
c.	Tentukan tiga product yang memberikan penjualan(quantity) terbanyak berdasarkan tiga product line yang didapatkan pada soal poin b.

3.	Buatlah sebuah script bash yang dapat menghasilkan password secara acak sebanyak 12 karakter yang terdapat huruf besar, huruf kecil, dan angka. Password acak tersebut disimpan pada file berekstensi .txt dengan ketentuan pemberian nama sebagai berikut:
a.	Jika tidak ditemukan file password1.txt maka password acak tersebut disimpan pada file bernama password1.txt
b.	Jika file password1.txt sudah ada maka password acak baru akan disimpan pada file bernama password2.txt dan begitu seterusnya.
c.	Urutan nama file tidak boleh ada yang terlewatkan meski filenya dihapus.
d.	Password yang dihasilkan tidak boleh sama.

Password dapat dihasilkan secara random dengan fungsi berikut:

	seed=$(date +%s%N)                                   //nanosecond sejak 1970-1-1 00:00:00 UTC
	pass=$(echo $seed | sha256sum | base64 | head -c 12) // $seed akan dimasukkan ke fungsi hash sha-256
                                                       //sha-256 menghasilkan string tanpa huruf kapital sehingga hasil dimasukkan ke base64 
                                                       // head berfungsi spt cat namun kita bisa mengatur berapa karakter yg muncul dengan -c

Password tersebut kemudian dicek jika memeuhi kriteria dengan regex berikut:

	if [[ $pass =~ ^.*[0-9]+.*$ && $pass =~ ^.*[A-Z]+.*$  && $pass =~ ^.*[a-z]+.*$ ]]; //password dicek dengan regex untuk mencek adanya huruf kecil, 
	                                                                                   //huruf kapital dan angka. 
Fungsi untuk menghasilkan password yang sesuai adalah sebagai berikut:

```bash
gen_pass() {                                            //fungsi untuk menghasilkan password
loop=1
pass=""                                                 //$pass menyimpan password
while [[  $loop == 1 ]]; 
 do
  seed=$(date +%s%N)  //nanosecond sejak 1970-1-1 00:00:00 UTC
  pass=$(echo $seed | sha256sum | base64 | head -c 12)                               //password dihasilkan
  if [[ $pass =~ ^.*[0-9]+.*$ && $pass =~ ^.*[A-Z]+.*$  && $pass =~ ^.*[a-z]+.*$ ]]; //password dicek dengan regex untuk mencek adanya huruf kecil,
     then loop=0                                                 // huruf kapital dan angka. Jika semua itu terpenuhi maka loop akan berhenti
  fi
done
echo $pass                                                      // return password yg dihasilkan
}
```
Script menghasilkan file dengan penamaan yang sesuai adalah sebagai berikut:

```bash
// bagian script ini digunakan untuk menghasilkan nama file yg sesuai
pass=$(gen_pass)  
name="password"
index=1  
if [[ -e $name$index.txt ]];          //jika password1.txt sudah ada (di folder script), jalankan, jika tidak (-e)exit
   then
   pass=$(check_pass $pass)           // panggil fungsi check_pass untuk mencek jika password yg dihasilkan sdh pernah dibuat
   while [[ -e $name$index.txt ]];    // while untuk mencari nama yg belum dipakai
      do
      let index++                     //jika nama sudah ada increment index
    done
fi
name=$name$index                      //simpan nama yg belum dipakai
echo $pass > $name.txt                //simpan password di file .txt dengan nama tersebut
```

Untuk mengecek password apakah password dibuat, kita mencetak semua password*.txt ke suatu file .txt sementara kemudian melakukan awk untuk membandingkan password yang sudah digunakan dengan yang baru dibuat. Fungsi untuk mengecek apakah password sudah dibuat adalah sebagai berikut:

```bash
check_pass() {                    // fungsi untuk mencek jika password sudah ada
pass=$1                           // masukkan password yg ada di argumen ke $pass
for i in $PWD/password*.txt       // cari semua file password.txt di folder script
 do cat $i >> temp.txt            // masukkan password yg ada di password*.txt ke temp.txt
done

loop=1
check=0
while [[  $loop == 1 ]]; 
 do
 check=$(awk -v curr="$pass" '$1 ~ curr {print 1}' temp.txt)  // cari dengan awk password (pada variable curr di awk) yg baru dihasilkan di file temp.txt yg berisi
                                                              //password yg sudah dihasilkan. Jika ditemukan password yg sama $check = 1
 if [[ $check != 1 ]];                                        //jika check != 1 / password yg sama tidak ditemukan, maka loop akan selesai
   then loop=0
   rm temp.txt  
   else  pass=$(gen_pass)                                     // jika ditemukan password yg sama maka buat password baru dan ulangi loop lagi
 fi
done

echo $pass   // return password yg dihasilkan
}

```


4.	Lakukan backup file syslog setiap jam dengan format nama file “jam:menit tanggal-bulan-tahun”. Isi dari file backup terenkripsi dengan konversi huruf (string manipulation) yang disesuaikan dengan jam dilakukannya backup misalkan sebagai berikut:
a.	Huruf b adalah alfabet kedua, sedangkan saat ini waktu menunjukkan pukul 12, sehingga huruf b diganti dengan huruf alfabet yang memiliki urutan ke 12+2 = 14.
b.	Hasilnya huruf b menjadi huruf n karena huruf n adalah huruf ke empat belas, dan seterusnya. 
c.	setelah huruf z akan kembali ke huruf a
d.	Backup file syslog setiap jam.
e.	dan buatkan juga bash script untuk dekripsinya.


5.	Buatlah sebuah script bash untuk menyimpan record dalam syslog yang memenuhi kriteria berikut:
a.	Tidak mengandung string “sudo”, tetapi mengandung string “cron”, serta buatlah pencarian stringnya tidak bersifat case sensitive, sehingga huruf kapital atau tidak, tidak menjadi masalah.
b.	Jumlah field (number of field) pada baris tersebut berjumlah kurang dari 13.
c.	Masukkan record tadi ke dalam file logs yang berada pada direktori /home/[user]/modul1.
d.	Jalankan script tadi setiap 6 menit dari menit ke 2 hingga 30, contoh 13:02, 13:08, 13:14, dst.

Kriteria yang diinginkan dapat dipenuhi dengan awk sebagai berikut:
```bash
awk 'tolower($0) ~ /cron/ && !/sudo/ && NF<13' /var/log/syslog >> $dir/log.txt // awk untuk mencari  field di syslog yg sesuai kriteria dan 
                                                                     //dioutputkan ke /home/[user]/modul1

                                                                    // tolower($0) ~ /cron/ - ubah semua field menjadi lower case dan 
                                                                    //bandingkan dengan cron
                                                                    //!/sudo/ - field tidak boleh mengandung sudo
                                                                    //NF<13 – jumlah field kurang dari 13
```

Bash script selengkapnya adalah sebagai berikut:
```bash
#!/bin/bash
dir="$HOME/modul1"
if [[  ! -d  "$HOME/modul1"  ]];  then  // jika  /home/[user]/modul1 belum ada maka buat folder tersebut
   mkdir $dir
fi

awk 'tolower($0) ~ /cron/ && !/sudo/ && NF<13' /var/log/syslog >> $dir/log.txt // awk untuk mencari  field di syslog yg sesuai kriteria dan 
                                                                     //dioutputkan ke /home/[user]/modul1

                                                                    // tolower($0) ~ /cron/ - ubah semua field menjadi lower case dan 
                                                                    //bandingkan dengan cron
                                                                    //!/sudo/ - field tidak boleh mengandung sudo
                                                                    //NF<13 – jumlah field kurang dari 13
```
Cronjob yang digunakan adalah sebagai berikut:

	2-30/6 * * * bash soal5.sh

 
