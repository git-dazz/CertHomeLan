#!/bin/bash

echo "================== certificate authority ====================="
# --home:  your name or network name or your dog name,for example:john, newton, trump, leo‌;
# --home:  你的名字 或 网络名字 或 你养的宠物狗的名字,如:libai, dufu, sangbiao, wangcai;
# --lan:  Custom top-level domain name: lan, local, host, localhost
# --lan:  自定义的顶级域名: lan, local, host, localhost
./createCertAuth.sh -a "rsa" --home "john" --lan "local"
./createCertAuth.sh -a "ec"  --home "libai" --lan "host"

echo "================== certificate authority List ====================="
# The list of certificates generated in step [createCertAuth.sh]
# 步骤 [createCertAuth.sh] 生成的证书列表

. ./showCAList.sh  --select


echo "================== web app ====================="
# create web app certificate
# 创建web应用证书
# --ca: [showCAList.sh] 中的任一一项
# --ca: Any one of the items in [showCAList.sh]
# --app: app name
# --app: app应用名称
./createAppCert.sh --ca "$SelectCaItem" --app xx-note --home "libai" --lan "host" 
