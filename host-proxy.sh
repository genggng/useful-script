export windows_host=`cat /etc/resolv.conf|grep nameserver|awk '{print $2}'`
export HTTP_PROXY=http://$windows_host:7890
export ALL_PROXY=socks5://$windows_host:7890
export http_proxy=$HTTP_PROXY
export HTTPS_PROXY=$HTTP_PROXY
export https_proxy=$HTTP_PROXY

if [ "`git config --global --get proxy.https`" != "socks5://$windows_host:7890" ]; then
            git config --global proxy.https socks5://$windows_host:7890
fi
