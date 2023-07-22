# GT.M-Docker
- note 
  1. Docker Version is `24.0.4`
    2. this Docker allows you to mount the .dat and routines from you local machine 
1. sudo docker build -t gtm-image .
2. sudo docker run -d -p 2022:22 --name gtm-container -v `(path to .dat file in local machien)`:`//home/vista/EHR/g` -v `(path to routine in local machien)`:`//home/vista/EHR/r` gtm-image
3. change ssh password : sudo docker exec -it gtm-container passwd
4. restart ssh : sudo docker exec -it gtm-container /etc/init.d/ssh restart
5. connect to Docker ssh root@172.17.0.2
6. link DB using these steps (from inside container):
- GDE
- change -segment DEFAULT -file=/home/vista/EHR/g/mumps.dat
- exit