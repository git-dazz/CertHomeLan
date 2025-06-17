# CertHomeLan
家用内网自签证书   
certificate authority for home lan   

## 使用 | Usage

0. 下载 | download   
1. 修改 config.conf | edit config.conf   
2. 生成CA证书 | create a certificate authority   
  ./createCertAuth.sh --home "yourname" --lan "host"   
3. 查看CA证书目录 | show certificate authority List   
  ./showCAList.sh   
4. 生成应用证书 | create a web app certificate   
  ./createAppCert.sh --ca ./itemOfStep3  --app "appname"   


### 样例 | example

example.sh