# useful-script
These are some usefule script in my daliy.  
They can improve the efficiency on the linux server.
### bupt-net.sh
Login the netwotk gate in bupt.
Please modify **user** and **pass** before use.
```shell
./bupt-net.sh
```

### login.sh
Login linux server by ssh.  
Please modify port 、usename and hostname(ip address).
```shell
./login.sh
```
### send_rsa.sh
Send local public key to target server, and you can login without password after this.  
By default, the public key in *~/.ssh/id_rsa.pub* will be used.
```shell
./send_rsa.sh [port] usename@10.XXX.XX.XX
``` 
### wsl-proxy.sh
Use windows host as proxy server(if you have one) and implement http(sock) proxy for wsl(windows subsystem for linux).  
Please modify the port(here it is 7890) which can be set in your proxy software such as V2ray and Clash. 
You can enable the temporary porxy with the folliwing command. 
```shell
source ./proxy.sh
```
If you want to trun on proxy permanently, add this script context to your *.bashrc*.
### wsl-xming.sh
Since wsl is implemented by virtualizer, it has a separate ip address from the windows.  
 And wsl doesn't have a GUI. If you want to connect its windows host to display screen by xming, you need the ip address of host machine and configure it as a display devide.  
 You can achieve the above with rhe following command temporarily or adding this script context to your *.bashrc* permanently.
 ```shell
 source ./wsl-xming.sh
 ```
