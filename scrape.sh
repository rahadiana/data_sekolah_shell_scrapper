
startup()
{
echo "startup start"
mkdir -p data_sekolah
wget "https://dapo.kemdikbud.go.id/sp" -O cache/tmp/tiktok.txt 
xmllint --noout --html -xpath '//*[@id="selectSemester"]/option[1]/@value'  2>/dev/null cache/tmp/tiktok.txt | sed -e "s/ //; s/value=\"//; s/\"//;" > cache/tmp/smstrnow.txt
bbb=$(cat cache/tmp/smstrnow.txt )
mkdir -p data_sekolah/all/province/$bbb
mkdir -p data_sekolah/all/city/$bbb
mkdir -p data_sekolah/all/region/$bbb
echo "startup end"
clear
}
aabbcc() {
bbb=$(cat cache/tmp/smstrnow.txt )
echo "abc start"
wget "https://dapo.kemdikbud.go.id/rekap/dataSekolah?id_level_wilayah=0&kode_wilayah=000000&semester_id=$bbb" -O "data_sekolah/all/province/$bbb/$bbb.json"
cat data_sekolah/all/province/$bbb/$bbb.json | jq -r '.[].kode_wilayah' > cache/tmp/kodewilayah.txt
cat  cache/tmp/kodewilayah.txt | sed "s/^/mkdir -p data_sekolah\/province\/$bbb\//" | bash
mkdir -p data_sekolah/city/$bbb
cat cache/tmp/kodewilayah.txt|sed "s/ //g" | sed "s/^/wget -nc 'https:\/\/dapo.kemdikbud.go.id\/rekap\/dataSekolah?id_level_wilayah=1\&kode_wilayah=/; s/$/' -O data_sekolah\/province\/$bbb\//" > cache/tmp/city.txt
paste -d "" cache/tmp/city.txt cache/tmp/kodewilayah.txt cache/tmp/kodewilayah.txt | sed 's/$/.json/' | sed 's/  .json/.json/g; s/  /\//g' | bash
mkdir -p cache/tmp/data_sekolah
rm cache/tmp/data_sekolah/*.json
ls data_sekolah/province/$bbb/ | sed "s/^/cp data_sekolah\/province\/$bbb\//; s/$/\/*.json  cache\/tmp\/data_sekolah\//"  | bash
cat cache/tmp/data_sekolah/*.json | jq -s 'flatten' > cache/tmp/fin.json
echo "abc end"
clear
}

FindCity(){
echo "findCity start"
cat cache/tmp/fin.json | jq -r '.[].kode_wilayah' | sed "s/ //g; s/^/mkdir -p data_sekolah\/city\/$bbb\//" | bash
ls data_sekolah/city/$bbb |sed "s/ //g" > cache/tmp/data_sekolah/city.txt
cat cache/tmp/data_sekolah/city.txt | sed "s/^/timeout 10 wget -nc  'https:\/\/dapo.kemdikbud.go.id\/rekap\/dataSekolah?id_level_wilayah=2\&kode_wilayah=/; s/$/\&smester_id=$bbb' -O data_sekolah\/city\/$bbb/"  > cache/tmp/data_sekolah/city2.txt
paste -d "|" cache/tmp/data_sekolah/city2.txt cache/tmp/data_sekolah/city.txt cache/tmp/data_sekolah/city.txt | sed 's/$/.json \&/'  | sed 's/  .json/.json/g; s/|/\//g' | sed -e '0~10 s/$/\nwait/g;' | bash
echo "findCity end"
clear
}

FindDetail(){
echo "findDetail start"
find data_sekolah/city/$bbb -name '*.json' -exec cat {} \; | jq '.' > data_sekolah/all/city/$bbb/$bbb.json
cat data_sekolah/all/city/$bbb/$bbb.json | jq -r '.[].kode_wilayah' | sed 's/ //g' > cache/tmp/allkota.txt
cat cache/tmp/allkota.txt | sed "s/^/mkdir -p data_sekolah\/region\/$bbb\//g" | bash
cat cache/tmp/allkota.txt | sed "s/^/timeout 10 wget -nc 'https:\/\/dapo.kemdikbud.go.id\/rekap\/progresSP?id_level_wilayah=3\&kode_wilayah=/; s/$/\&smester_id=$bbb\&bentuk_pendidikan_id=' -O data_sekolah\/region\/$bbb/" > cache/tmp/data_sekolah/region.txt
paste -d "|" cache/tmp/data_sekolah/region.txt cache/tmp/allkota.txt cache/tmp/allkota.txt  | sed 's/$/.json \&/'  | sed 's/|/\//g;'  | sed -e '0~10 s/$/\nwait/g;' | bash
echo "findDetail end"
clear
}
#cat data_sekolah/all/city/$bbb/$bbb.json | jq '[try .[] | { nama_kabkot: .nama, kode_wilayah: .kode_wilayah, id_level_wilayah: .id_level_wilayah, mst_kode_wilayah: .mst_kode_wilayah, induk_provinsi: .induk_provinsi, kode_wilayah_induk_provinsi: .kode_wilayah_induk_provinsi, induk_kabupaten: .induk_kabupaten, kode_wilayah_induk_kabupaten: .kode_wilayah_induk_kabupaten }]'| jq -s 'flatten' | sed -e 's/  "/"/g;' | jq -s 'flatten' > tes.txt
#| jq '[try .[] | {id_origin_news: .nama_kabkot , sumber: "tirto.com"}]'
startup
aabbcc
#FindCity
#FindDetail
#echo "finish"
exit 1