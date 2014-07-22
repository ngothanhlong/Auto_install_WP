#! /bin/bash

  echo "############### Hoan thien cai dat Joomla ######################"
  #Xoa thu muc installation trong thu muc Joomla

     sudo rm -rf  /var/www/Joomla/installation
  # cap quyen moi cho file configuration.php
     sudo chmod 755 /var/www/Joomla/configuration.php

  echo "Mo file configuration.php xem cac  lenh cau hinh da day su chua!"
  echo "#################KET THUC QUA TRINH CAI DAT##########################"      