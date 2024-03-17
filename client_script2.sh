echo "Конфигурируем клиента стадия 2"
mkdir /root/.config
mkdir /root/.config/borg

cp /home/vagrant/borg-backup.service /etc/systemd/system/borg-backup.service
cp /home/vagrant/borg-backup.timer /etc/systemd/system/borg-backup.timer
cp /home/vagrant/borg_log.conf /root/.config/borg/borg_log.conf

export SSHPASS='vagrant'
ssh-keygen -f /root/.ssh/id_rsa -q -N ""
export PUB_KEY=$(cat /root/.ssh/id_rsa.pub | awk '{print$2}')
ssh -o StrictHostKeyChecking=no 192.168.56.160
sshpass -e ssh vagrant@192.168.56.160 'sudo chown -R vagrant:vagrant /home/borg'
sshpass -e ssh vagrant@192.168.56.160 'sudo echo command=\"/usr/bin/borg serve\" 'ssh-rsa $PUB_KEY' > /home/borg/.ssh/authorized_keys'
sshpass -e ssh vagrant@192.168.56.160 'sudo chown -R borg:borg /home/borg'
sshpass -e ssh vagrant@192.168.56.160 'sudo chmod 700 .ssh'
sshpass -e ssh vagrant@192.168.56.160 'sudo chmod 600 .ssh/authorized_keys'

export BORG_PASSPHRASE=borg
borg init --encryption=repokey borg@192.168.56.160:/var/backup/
systemctl daemon-reload
systemctl start borg-backup

systemctl enable borg-backup.timer 
systemctl start borg-backup.timer
echo "Конфигурирование клиента стадия 2 завершена"