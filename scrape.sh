

echo "startup start"
mkdir -p data_sekolah
wget  -q "https://dapo.kemdikbud.go.id/sp" -O /tmp/tiktok.txt 
xmllint --noout --html -xpath '//*[@id="selectSemester"]/option[1]/@value'  2>/dev/null /tmp/tiktok.txt | sed -e "s/ //; s/value=\"//; s/\"//;" > /tmp/smstrnow.txt
bbb=$(cat /tmp/smstrnow.txt )
mkdir -p data_sekolah/all/province/$bbb
mkdir -p data_sekolah/all/city/$bbb
mkdir -p data_sekolah/all/region/$bbb
echo "startup end"

echo "startup start"
sudo mkdir -p data_sekolah
sudo mkdir -p cache/tmp/
wget  -q "https://dapo.kemdikbud.go.id/sp" -O cache/tmp/tiktok.txt 
xmllint --noout --html -xpath '//*[@id="selectSemester"]/option[1]/@value'  2>/dev/null cache/tmp/tiktok.txt | sed -e "s/ //; s/value=\"//; s/\"//;" > cache/tmp/smstrnow.txt
bbb=$(cat cache/tmp/ smstrnow.txt )
sudo mkdir -p data_sekolah/all/province/$bbb
sudo mkdir -p data_sekolah/all/city/$bbb
sudo mkdir -p data_sekolah/all/region/$bbb
echo "startup end"

echo "finishs"
exit 1
