GPU_NUM=2    # 该任务需要的GPU个数
THRESHOLD=0.05   # 当GPU内存利用率低于THRESHOLD，视为该GPU为空闲
WAIT_MODE=true   # true：循环等待GPU满足。 false：GPU不满足直接退出 
WAIT_INTERVAL=30 # 循环等待间隔，单位为秒，只在WAIT_MODE=true时起效。

LOCK_DIR="~/tmp/gpu_locks"  # 锁文件目录

# 创建锁目录
mkdir -p "$LOCK_DIR"

# 清理函数（退出时删除自己的锁文件）
cleanup() {
    if [ -n "$ACQUIRED_GPUS" ]; then
        for gpu in $(echo "$ACQUIRED_GPUS" | tr ',' ' '); do
            rm -f "$LOCK_DIR/gpu_${gpu}.lock"
        done
    fi
    exit
}
trap cleanup EXIT INT TERM



# 检查nvidia-smi和bc
if ! command -v nvidia-smi &> /dev/null || ! command -v bc &> /dev/null; then
    echo "Error: Required commands (nvidia-smi/bc) not found."
    exit 1
fi

# 获取物理GPU内存使用情况
get_physical_gpu_memory() {
    nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null
}

# 尝试获取GPU锁
try_acquire_gpu_lock() {
    local gpu=$1
    local lockfile="$LOCK_DIR/gpu_${gpu}.lock"

    # 使用mkdir原子操作实现锁
    if mkdir "$lockfile.lock" 2>/dev/null; then
        # 检查GPU是否真的可用
        local used total usage
        read used total <<< $(get_physical_gpu_memory | sed -n "$((gpu+1))p" | awk -F',' '{print $1, $2}')
        usage=$(echo "scale=4; $used / $total" | bc)

        if [ $(echo "$usage < $THRESHOLD" | bc) -eq 1 ] && [ ! -f "$lockfile" ]; then
            touch "$lockfile"
            echo "$BASHPID" > "$lockfile"  # 写入当前进程ID
            rmdir "$lockfile.lock"
            return 0
        fi
        rmdir "$lockfile.lock"
    fi
    return 1
}

# 释放GPU锁
release_gpu_lock() {
    local gpu=$1
    rm -f "$LOCK_DIR/gpu_${gpu}.lock"
}

# 查找并锁定可用GPU
find_and_lock_gpus() {
    local needed=$1
    local acquired=()
    local gpu_info=$(get_physical_gpu_memory)
    local total_gpus=$(echo "$gpu_info" | wc -l)

    for ((i=0; i<total_gpus; i++)); do
        if try_acquire_gpu_lock $i; then
            acquired+=($i)
            if [ ${#acquired[@]} -eq $needed ]; then
                ACQUIRED_GPUS=$(IFS=','; echo "${acquired[*]}")
                return 0
            fi
        fi
    done

    # 释放已经获取的GPU锁
    for gpu in "${acquired[@]}"; do
        release_gpu_lock $gpu
    done

    return 1
}

# 主分配逻辑
if $WAIT_MODE; then
    # 等待模式
    while true; do
        if find_and_lock_gpus $GPU_NUM; then
            export CUDA_VISIBLE_DEVICES=$ACQUIRED_GPUS
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Acquired GPUs: $ACQUIRED_GPUS"
            break
        fi
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Waiting for $GPU_NUM GPUs (interval: ${WAIT_INTERVAL}s)..."
        sleep $WAIT_INTERVAL
    done
else
    # 非等待模式
    if find_and_lock_gpus $GPU_NUM; then
        export CUDA_VISIBLE_DEVICES=$ACQUIRED_GPUS
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Acquired GPUs: $ACQUIRED_GPUS"
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Failed to acquire $GPU_NUM GPUs"
        exit 1
    fi
fi