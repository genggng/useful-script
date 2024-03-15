import requests
import json

def send_feishu(webhook,msg):
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

if __name__ == "__main__":
    webhook = "" 
    msg = "hello world"
    send_feishu(webhook,msg)