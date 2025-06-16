#!/bin/bash

# Home="home"
# Lan="lan"
# algorithm="RSA" # or "EC"
# Dist="dist"

# SubjC="CN"
# SubjST="Beijing"
# SubjL="Beijing"

. config.conf

while [[ $# -gt 0 ]]; do
  case $1 in
  -h | --home)
    Home="$2"
    shift 2
    ;;
  -l | --lan)
    Lan="$2"
    shift 2
    ;;
  -a | --algorithm)
    algorithm="$2"
    shift 2
    ;;
  -d | --dist)
    CADist="$2"
    shift 2
    ;;

  *)
    echo "多余参数: $1"
    exit 1
    ;;
  esac
done

TargetName="${Home^}${Lan^}"
TargetDir="${CADist}/${TargetName}-${algorithm}"
TargetKey="$TargetDir/${TargetName}_${algorithm}.key"
TargetCrt="$TargetDir/${TargetName}_${algorithm}.crt"

ReqSubj="/C=$SubjC/ST=$SubjST/L=$SubjL/O=$TargetName/OU=${TargetName}CA/CN=${TargetName} Root CA"

mkdir -p $TargetDir

echo "[certificate authority openssl genpkey]"

if [ "${algorithm^^}" = "RSA" ]; then
  openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out "$TargetKey"
else
  openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:secp256k1 -out "$TargetKey"
fi

echo "[certificate authority openssl req]"
openssl req -key "$TargetKey" -new -x509 -sha256 -out "$TargetCrt" -days $Days -subj "$ReqSubj"

infoFile="${TargetDir}/${InfoName}"
Pre="CA_"
echo -e "#######" >$infoFile
echo -e "${Pre}Home='$Home'" >>$infoFile
echo -e "${Pre}Lan='$Lan'" >>$infoFile
echo -e "${Pre}Dist='$Dist'" >>$infoFile

echo -e "${Pre}SubjC='$SubjC'" >>$infoFile
echo -e "${Pre}SubjST='$SubjST'" >>$infoFile
echo -e "${Pre}SubjL='$SubjL'" >>$infoFile

echo -e "${Pre}TargetName='$TargetName'" >>$infoFile
echo -e "${Pre}Algorithm='$algorithm'" >>$infoFile
echo -e "${Pre}TargetKey='$TargetKey'" >>$infoFile
echo -e "${Pre}TargetCrt='$TargetCrt'" >>$infoFile
