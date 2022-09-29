# 提取时间和WIFI IP地址^
cat_num=$1
if [ -z $cat_num ]
then
     echo "cat_num is empty, which is the num of the lastest records to show. Usage: ./get_pc_ip.sh cat_num"
else
    iconv -f gbk -t utf8 new-ip.txt | sed -e 's:^.*IPv4.*\(10\.128.*\)$:\1:g' | awk '/^[0-9]*[0-9]\/[0 9]*[0 9].*$/{date=$1};/^10\.128.*$/{printf"%s %s\n",date,$1}' | tail -$cat_num
fi