import requests,json
def feishu_note(func,argv,exp_id_key="--exp_id",webhook="",device="A6000"):
    exp_id = None
    if exp_id_key in argv:
        exp_id = argv[argv.index("--exp_id")+1]
        def wrapper(*args, **kwargs):
            try:
                result = func(*args, **kwargs)
                msg = f"实验名称: {exp_id}\n运行设备: {device}\n顺利完成!"
            except Exception as e:
                msg = f"实验名称: {exp_id}\n运行设备: {device}\n发生异常:{e}"
                result = None
            finally:
                headers = {
                "Content-Type": "application/json"
                }
                data = {
                    "msg_type": "text",
                    "content": {
                        "text": msg
                    }
                }
                requests.post(webhook, headers=headers, data=json.dumps(data))
            return result
        return wrapper
    else:
        return func
    
def main():
    print("hello,word!")
    # raise Exception("text error")

import sys
if __name__ == "__main__":
    print(sys.argv)
    main = feishu_note(main,sys.argv,exp_id_key="--exp_id")
    main()