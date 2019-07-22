#!/bin/bash
echo
echo "*Swap一键添加脚本"
echo "*  By Moecola.com"
echo
function main(){
totalswap=`free -m| grep "Swap:"| awk '{print $2}'`
echo "当前SWAP：$totalswap MB"
echo "1、添加SWAP"
echo "2、SWAP参数优化"
echo "3、退出"
echo -n "请输入："
read -e choice
case $choice in
1)
add;;
2)
modi;;
3)
exit;;
*)
echo "输入错误，请重新输入"
main;;
esac
}
function add(){
echo "请输入添加Swap大小(例如1G)"
read -e swap
file="1"
de $file
main
}
function de(){
cd /
file=$1
if [ -f "$file" ]
then
	file1=`echo "$1+1"|bc`
        de $file1
else
	sudo fallocate -l $swap $1
	sudo chmod 600 $1
	sudo mkswap $1
	sudo swapon $1
	sudo cp /etc/fstab /etc/fstab.bak
	echo -e "/$1 none swap sw 0 0" | sudo tee -a /etc/fstab
fi
}
function modi(){
echo "正在优化..."
echo
cat /proc/sys/vm/swappiness
sudo sysctl vm.swappiness=10
cat /proc/sys/vm/vfs_cache_pressure
sudo sysctl vm.vfs_cache_pressure=50
cp /etc/sysctl.conf /etc/sysctl.conf.bak
echo >> /etc/sysctl.conf
echo "vm.swappiness=10" >> /etc/sysctl.conf
echo >> /etc/sysctl.conf
echo "vm.vfs_cache_pressure = 50" >> /etc/sysctl.conf
echo "优化完成"
main
}
function check(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	fi
	case $release in
	ubuntu|debian)
	if ! [ -x "$(command -v bc)" ]; then
  	apt -y install bc
	fi;;
	centos)
	if ! [ -x "$(command -v bc)" ]; then
  	yum -y install bc
	fi;;
	esac
}
check
main
