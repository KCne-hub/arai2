cache="/mnt/data/ttnode"
case $1 in
    -c=*|--cache=*)
    cache="${1#*=}"
    ;;
    *)
    ;;
esac

apt-get update -y
apt-get install -y wget ca-certificates qrencode unzip tar
apt-get upgrade tar unzip

manager_x86="ttnode-manager-x86"
manager_arm32="ttnode-manager-arm32"
manager_arm64="ttnode-manager-arm64"
arm32_url="https://gitee.com/shenzhen-sweet-sugar/ttnode-auto-deploy/attach_files/1104920/download/ttnode-manager-arm32.tar.gz"
arm64_url="https://gitee.com/shenzhen-sweet-sugar/ttnode-auto-deploy/attach_files/1104919/download/ttnode-manager-arm64.tar.gz"
x86_url="https://gitee.com/shenzhen-sweet-sugar/ttnode-auto-deploy/attach_files/1104921/download/ttnode-manager-x86.tar.gz"
deploy_dir="/usr/node"
manager=manager_arm32

platform=$(uname -a)
case $platform in
    *x86*)
        url=$x86_url
        manager=$manager_x86
        ;;
    *amd64*)
        url=$x86_url
        manager=$manager_x86
        ;;
    *armv8*)
        url=$arm64_url
        manager=$manager_arm64
        ;;
    *arm64*)
        url=$arm64_url
        manager=$manager_arm64
        ;;
    *aarch64*)
        url=$arm64_url
        manager=$manager_arm64
        ;;
    *)
        url=$arm32_url
        manager=$manager_arm32
esac

echo $url
tar_manager="$manager.tar.gz"
mkdir -p /opt/app
mkdir -p $cache
rm -rf $deploy_dir
rm -rf /usr/$tar_manager

cd /usr

wget $url
tar -xvf $tar_manager

mv $manager node

cd /usr/node
echo $cache > config.txt
chmod +x ttnode_manager

# 开机启动设置
wget "https://gitee.com/shenzhen-sweet-sugar/ttnode-auto-deploy/raw/master/rc.local"
cp $deploy_dir/rc.local /etc/rc.local
chmod +x /etc/rc.local
systemctl daemon-reload

/etc/rc.local


