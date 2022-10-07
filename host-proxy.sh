export windows_host=`./wsg_pc_ip/get_pc_ip.sh 1 | awk '{printf $2}'`
export ALL_PROXY=socks5://$windows_host:7890
export HTTP_PROXY=$ALL_PROXY
export http_proxy=$ALL_PROXY
export HTTPS_PROXY=$ALL_PROXY
export https_proxy=$ALL_PROXY

if [ "`git config --global --get proxy.https`" != "socks5://$windows_host:7890" ]; then
            git config --global proxy.https socks5://$windows_host:7890
fi
