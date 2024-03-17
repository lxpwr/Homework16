echo "Конфигурируем сервер"
apt install borgbackup -y
useradd -m borg
mkdir /home/borg/.ssh
mkfs.ext4 /dev/sdb
mkdir /var/backup
mount /dev/sdb /var/backup
rm -R /var/backup/*
chown borg:borg /var/backup/
echo "Конфигурирование сервера стадия 1 завершена"