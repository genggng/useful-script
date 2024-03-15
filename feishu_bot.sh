exp_id="osdt-bbox_uavdt"
device="cad02"
CUDA_VISIBLE_DEVICES=2,3 ./tools/dist_train.sh configs/osdt/osdt-dcn-p3-uavdt-use_bbox_mutil_step.py 2


if [ $? -eq 0 ]
then
    msg="实验"${exp_id}" 成功跑完了,请到"${device}"上检查结果"
else
    msg="实验"${exp_id}" 异常退出！,请到"${device}"上检查结果"
fi
webhook="" # webhook 
content='{"msg_type": "text","content": {"text":"'$msg'"}}'
echo $content
curl $webhook -H 'Content-Type: application/json' -d "$content"