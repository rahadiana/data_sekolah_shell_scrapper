
startup()
{
echo "startup start"
mkdir -p data_sekolah
wget  -q "https://dapo.kemdikbud.go.id/sp" -O /tmp/tiktok.txt 
xmllint --noout --html -xpath '//*[@id="selectSemester"]/option[1]/@value'  2>/dev/null /tmp/tiktok.txt | sed -e "s/ //; s/value=\"//; s/\"//;" > /tmp/smstrnow.txt
bbb=$(cat /tmp/smstrnow.txt )
mkdir -p data_sekolah/all/province/$bbb
mkdir -p data_sekolah/all/city/$bbb
mkdir -p data_sekolah/all/region/$bbb
echo "startup end"
clear
}
bbb=$(cat /tmp/smstrnow.txt )
aabbcc() {
echo "abc start"
wget -q "https://dapo.kemdikbud.go.id/rekap/dataSekolah?id_level_wilayah=0&kode_wilayah=000000&semester_id=$bbb" -O "data_sekolah/all/province/$bbb/$bbb.json"
cat data_sekolah/all/province/$bbb/$bbb.json | jq -r '.[].kode_wilayah' > /tmp/kodewilayah.txt
cat  /tmp/kodewilayah.txt | sed "s/^/mkdir -p data_sekolah\/province\/$bbb\//" | bash
mkdir -p data_sekolah/city/$bbb
cat  /tmp/kodewilayah.txt|sed "s/ //g" | sed "s/^/wget -nc -q 'https:\/\/dapo.kemdikbud.go.id\/rekap\/dataSekolah?id_level_wilayah=1\&kode_wilayah=/; s/$/' -O data_sekolah\/province\/$bbb\//" > /tmp/city.txt
paste -d "" /tmp/city.txt  /tmp/kodewilayah.txt /tmp/kodewilayah.txt | sed 's/$/.json/' | sed 's/  .json/.json/g; s/  /\//g' | bash
mkdir -p /tmp/data_sekolah
rm /tmp/data_sekolah/*.json
ls data_sekolah/province/$bbb/ | sed "s/^/cp data_sekolah\/province\/$bbb\//; s/$/\/*.json  \/tmp\/data_sekolah\//"  | bash
cat /tmp/data_sekolah/*.json | jq -s 'flatten' > /tmp/fin.json
echo "abc end"
clear
}

FindCity(){
echo "findCity start"
cat /tmp/fin.json | jq -r '.[].kode_wilayah' | sed "s/ //g; s/^/mkdir -p data_sekolah\/city\/$bbb\//" | bash
ls data_sekolah/city/$bbb |sed "s/ //g" > /tmp/data_sekolah/city.txt
cat /tmp/data_sekolah/city.txt | sed "s/^/timeout 10 wget -nc -q 'https:\/\/dapo.kemdikbud.go.id\/rekap\/dataSekolah?id_level_wilayah=2\&kode_wilayah=/; s/$/\&smester_id=$bbb' -O data_sekolah\/city\/$bbb/"  > /tmp/data_sekolah/city2.txt
paste -d "|" /tmp/data_sekolah/city2.txt /tmp/data_sekolah/city.txt /tmp/data_sekolah/city.txt | sed 's/$/.json \&/'  | sed 's/  .json/.json/g; s/|/\//g' | sed -e '0~10 s/$/\nwait/g;' | bash
echo "findCity end"
clear
}

FindDetail(){
echo "findDetail start"
find data_sekolah/city/$bbb -name '*.json' -exec cat {} \; | jq '.' > data_sekolah/all/city/$bbb/$bbb.json
cat data_sekolah/all/city/$bbb/$bbb.json | jq -r '.[].kode_wilayah' | sed 's/ //g' > /tmp/allkota.txt
cat /tmp/allkota.txt | sed "s/^/mkdir -p data_sekolah\/region\/$bbb\//g" | bash
cat /tmp/allkota.txt | sed "s/^/timeout 10 wget -nc -q 'https:\/\/dapo.kemdikbud.go.id\/rekap\/progresSP?id_level_wilayah=3\&kode_wilayah=/; s/$/\&smester_id=$bbb\&bentuk_pendidikan_id=' -O data_sekolah\/region\/$bbb/" > /tmp/data_sekolah/region.txt
paste -d "|" /tmp/data_sekolah/region.txt /tmp/allkota.txt /tmp/allkota.txt  | sed 's/$/.json \&/'  | sed 's/|/\//g;'  | sed -e '0~10 s/$/\nwait/g;' | bash
echo "findDetail end"
clear
}
#cat data_sekolah/all/city/$bbb/$bbb.json | jq '[try .[] | { nama_kabkot: .nama, kode_wilayah: .kode_wilayah, id_level_wilayah: .id_level_wilayah, mst_kode_wilayah: .mst_kode_wilayah, induk_provinsi: .induk_provinsi, kode_wilayah_induk_provinsi: .kode_wilayah_induk_provinsi, induk_kabupaten: .induk_kabupaten, kode_wilayah_induk_kabupaten: .kode_wilayah_induk_kabupaten }]'| jq -s 'flatten' | sed -e 's/  "/"/g;' | jq -s 'flatten' > tes.txt
#| jq '[try .[] | {id_origin_news: .nama_kabkot , sumber: "tirto.com"}]'
startup
aabbcc
FindCity
FindDetail
echo "finish"
exit 1

#find data_sekolah/region/$bbb -name '*.json' -exec cat {} \; > data_sekolah/all/region/$bbb/$bbb.json

#cat data_sekolah/all/region/$bbb/$bbb.json | jq '[try .[] | {nama_sekolah: .nama, sekolah_id: .sekolah_id, npsn: .npsn, induk_kecamatan: .induk_kecamatan, kode_wilayah_induk_kecamatan: .kode_wilayah_induk_kecamatan, induk_kabupaten: .induk_kabupaten, kode_wilayah_induk_kabupaten: .kode_wilayah_induk_kabupaten, induk_provinsi: .induk_provinsi, kode_wilayah_induk_provinsi: .kode_wilayah_induk_provinsi, bentuk_pendidikan: .bentuk_pendidikan, status_sekolah: .status_sekolah, sekolah_id_enkrip: .sekolah_id_enkrip  }]' | sed 's/  "/"/g; s/                                                                              //g;' | jq -s 'flatten'  > kota.txt 
#cat kota.txt | jq '[try.[] | select(.induk_kabupaten=="Kota Bekasi")]'
#cat data_sekolah/all/region/$bbb/$bbb.json | jq '.[].bentuk_pendidikan' > ok.txt

#mkdir -p  /tmp/data_sekolah/region/$bbb
#mkdir -p /tmp/data_sekolah/region/cache
#ls data_sekolah/region/$bbb > /tmp/data_sekolah/region/reg_dmp.txt
#cat /tmp/data_sekolah/region/reg_dmp.txt | sed -e "s/^/cp data_sekolah\/region\/$bbb\//" > /tmp/data_sekolah/region/reg_dmp2.txt
#paste -d "/" /tmp/data_sekolah/region/reg_dmp2.txt /tmp/data_sekolah/region/reg_dmp.txt | sed 's/$/.json \/tmp\/data_sekolah\/region\/cache\//' > /tmp/data_sekolah/region/reg_dmp3.txt 
#paste -d "" /tmp/data_sekolah/region/reg_dmp3.txt /tmp/data_sekolah/region/reg_dmp.txt |sed 's/$/.json/' | bash



#05
#27
#cat  /tmp/data_sekolah/region/cache/0511*.json | jq '.'

#ls /tmp/data_sekolah/region/cache/05*.json | wc -l