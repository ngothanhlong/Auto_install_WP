#! /bin/bash -ex

  source  config.cfg

echo "------Cap nhat he thong-------------"
      sudo apt-get update
echo "-------Cai dat server apache-------"
       sudo apt-get -y  install  apache2
 #Hien thi thong tin ip cua server

  echo "IP SERVER :"
                     ifconfig eth0 |grep 'inet addr'|cut -d ':' -f2| awk '{print $1}'
sleep 3
#-----------------------------------------------------------------------------------#
echo "-----Cai dat  database mysql-server----------------"
  #Bat dau thuc thi
        echo mysql-server mysql-server/root_password password $MYSQL_ADMIN_PASS | debconf-set-selections
        echo mysql-server mysql-server/root_password_again password $MYSQL_ADMIN_PASS |debconf-set-selections

  #Cai dat Mysql-server
     sudo apt-get install mysql-server php5-mysql mysql-client 

  #
     sudo mysql_install_db
  #Dieu chinh thong so cho mysql

  SECURE_MYSQL=$(expect -c "

  set timeout 10

  spawn mysql_secure_installation

  expect \"Enter current password for root (enter for none):\"
  send \"$MYSQL_ADMIN_PASS\r\"

  expect \"Change the root password?\"
  send \"n\r\"

  expect \"Remove anonymous users?\"
  send \"y\r\"

  expect \"Disallow root login remotely?\"
    expect \"Reload privilege tables now?\"
  send \"y\r\"

  expect EOF")

echo  $SECURE_MYSQL
#
    sudo  apt-get remove --purge -y expect
#khoi dong lai dich vu
   sudo service mysql restart
   sudo service apache2 restart
 
   sleep 3
#--------------------------------------------------------------------------------------------------------
echo " ----------------Cai dat php -------------------"
            sudo apt-get install  php5 libapache2-mod-php5 php5-mcrypt -y
echo " ----------Khoi dong laii dich vu----------"
         sudo service apache2 restart
sleep 3

#--------------------------------------------------------------------------------------------------------------
echo "######--Cai dat wordpress --#####"
 echo  "-------Tao Database,User trong Mysql"


cat << 'EOF' |mysql -uroot -p$MYSQL_PASS

  #xoa neu nhu dang ton tai database
    #DROP DATABASE IF EXISTS wordpress;
        ###
          CREATE DATABASE wordpress;
        #Xoa cac users cu neu co
          DROP USER 'wordpress_test'@'loalhost';
          ##tao users
          CREATE USER wordpress_test@localhost;
         # SET PASSWORD cho USER:
        SET PASSWORD FOR wordpress_test@localhost = PASSWORD('$MYSQL__PASS');

     #Dat quyen han cho users:
           #Dat quyen han cho users:
           GRANT ALL PRIVILEGES ON wordpress.* TO wordpress_test@localhost IDENTIFIED BY '$MYSQL_PASS';
          #
           FLUSH PRIVILEGES;
       exit

EOF

echo "--Tai goi cai dat wordpress tu trang chu--------------------"
   
   #Tai goi cai dat
    cd /var/www/html

          wget http://wordpress.org/latest.tar.gz
    #giai nen file latest.tar.gz

      sudo  tar -zxvf  latest.tar.gz

  #Xoa file tar.gz di:

    sudo rm -rf latest.tar.gz
  #Cai goi phu thuoc
  sudo apt-get install php5-gd libssh2-php php5-mysql -y
  #di chuyen vao file root
  cd /var/www/html/wordpress
  #copy file wp-config-sample.php -> wp-config.php

   sudo cp wp-sample-config.php  wp-config.php

       #sua cau hinh trong file wp-config.php vua cp sang
  echo " // ** MySQL settings - You can get this info from your web host ** //"
        echo " #/** The name of the database for WordPress */"
        echo " #define('DB_NAME', 'wordpress');"

        echo "#/** MySQL database username */"
        echo "#define('DB_USER', 'wordpress_test');"

        echo "#/** MySQL database password */"
        echo "#define('DB_PASSWORD', '$MYSQL_PASSS');" # mac dinh : password
        #### Hien thi thong so cua database
      

         #### Thuc hien thay doi file wp-config.php
         # ----- sed [tùy chọn]... {script-only-if-no-other-script} [input-file]...

          sleep 3
          cd /var/www/html/wordpress
          pwd
         sudo  sed -i "s/database_name_here/wordpress/g"      wp-config.php
         sudo  sed -i "s/username_here/wordpress_test/g"      wp-config.php
         sudo  sed  -i "s/password_here/password/g"           wp-config.php

  #phan quyen so huu cho user tren tat ca cac thu muc
     sudo chown -R $USER:www-data *
  #Tao file upload trong he thong wordpress
     sudo mkdir /var/www/html/wordpress/wp-content/uploads
   #cho phep cac webserver toan quyen su dung thu muc
     sudo chown -R :www-data /var/wwww/html/wordpress/wp-content/uploads



###########################################################################################
   echo " -----Cai dat he thong hoan tat-------"
   echo " Truy  cap vao dia chi:http://"
            ifconfig eth0 |grep 'inet addr'|cut -d ":" -f2| awk '{ print $1 }' 
					   echo " /wordpress/wp-login.php"
   ###########################################################################################
                                                                                                                                                                
