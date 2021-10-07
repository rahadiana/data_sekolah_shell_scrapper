
startup()
{
echo "startup start"
sudo mkdir -p data_sekolah
sudo mkdir -p cache/tmp/
wget  -q "https://dapo.kemdikbud.go.id/sp" -O cache/tmp/ tiktok.txt 
xmllint --noout --html -xpath '//*[@id="selectSemester"]/option[1]/@value'  2>/dev/null cache/tmp/ tiktok.txt | sed -e "s/ //; s/value=\"//; s/\"//;" > cache/tmp/ smstrnow.txt
bbb=$(cat cache/tmp/ smstrnow.txt )
sudo mkdir -p data_sekolah/all/province/$bbb
sudo mkdir -p data_sekolah/all/city/$bbb
sudo mkdir -p data_sekolah/all/region/$bbb
echo "startup end"
clear
}
startup
echo "finish"
exit 1
