#!/bin/bash

. config.conf

CaDir=""
app="www"
# exit 0;
while [[ $# -gt 0 ]]; do
  case $1 in
  --app)
    app="$2"
    shift 2
    ;;
  -h | --home)
    Home="$2"
    shift 2
    ;;
  -l | --lan)
    Lan="$2"
    shift 2
    ;;
  -a | --algorithm)
    algorithm="${2,,}"
    shift 2
    ;;
  -d | --dist)
    AppDist="$2"
    shift 2
    ;;
  -ca | --ca)
    CaDir="${2%/}"
    shift 2
    ;;

  *)
    echo "多余参数: $1"
    exit 1
    ;;
  esac
done

if [[ $CaDir = "" ]]; then
  echo "must input '--ca  Path_Of_CA';"
  ./showCAList.sh
  exit 1
fi
. $CaDir/ca.conf

site_name="$app.$Home.$Lan"

Server_dir="${AppDist}/${site_name}/${algorithm}-[${CA_TargetName}-${CA_Algorithm}]"
Server_key="$Server_dir/key.pem"
Server_csr="$Server_dir/csr.pem"
Server_crt="$Server_dir/cert.pem"
SUBJ_server="/C=$SubjC/ST=$SubjST/L=$SubjL/O=${site_name}/OU=${site_name} network/CN=$site_name"

# . ./config.sh --site-name "$1" --ca-name "$CA_NAME" web

mkdir -p $Server_dir
CNF="${Server_dir}/server_cert.cnf"
cat << EOF > $CNF
[ server_cert ]
basicConstraints = CA:FALSE
nsCertType = server
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = DNS:${site_name}
EOF

echo "[web app openssl genpkey]"
if [ "${algorithm,,}" = "rsa" ]; then
  openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out "$Server_key"
else
  openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:secp256k1 -out "$Server_key"
fi

echo "[web app openssl req]"

openssl req -key "$Server_key" -new -out "$Server_csr" -subj "$SUBJ_server"  -config $CNF

echo "[web app openssl x509]"
openssl x509 -req \
  -CA "${CA_TargetCrt}" -CAkey "${CA_TargetKey}" -CAcreateserial -in "$Server_csr" \
  -extfile $CNF -extensions server_cert \
  -out "$Server_crt" -days $Days