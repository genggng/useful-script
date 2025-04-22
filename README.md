# useful-script
These are some usefule script in my daliy.  
They can improve the efficiency on the linux server.

### auto_gpu_select.sh

This script provides an automated solution for allocating available GPUs based on memory usage thresholds. It implements a locking mechanism to prevent multiple processes from competing for the same GPU resources.

#### 0.Features

- **Automatic GPU detection**: Identifies available GPUs based on memory utilization
- **Configurable threshold**: Set your own threshold for considering a GPU "available"
- **Wait mode**: Option to wait until requested GPUs become available
- **Process-safe locking**: Prevents multiple processes from acquiring the same GPU
- **Clean exit handling**: Automatically releases GPU locks on script termination

#### 1.Configuration Variables

| Variable        | Description                                                                 | Default Value |
|-----------------|-----------------------------------------------------------------------------|---------------|
| `GPU_NUM`       | Number of GPUs required by your task                                        | 2             |
| `THRESHOLD`     | Memory usage threshold (0-1). GPUs below this are considered available.     | 0.05 (5%)     |
| `WAIT_MODE`     | `true`: Wait until GPUs are available. `false`: Exit if GPUs unavailable.   | true          |
| `WAIT_INTERVAL` | Seconds between checks in wait mode (only when `WAIT_MODE=true`)            | 30            |
| `LOCK_DIR`      | Directory for storing GPU lock files                                        | ~/tmp/gpu_locks |

#### 2.Usage

**Basic usage (wait mode)**:
```bash
# Copy the context in auto_gpu_select.sh to here

# Please write the program you expect to execute here.
```


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
