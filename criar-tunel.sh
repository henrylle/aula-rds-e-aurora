#!/bin/bash

# Configurações
BASTION_ID="i-0399a77f5526849f5"
RDS_HOST="bia-rds.clgaiwq42b0j.us-east-2.rds.amazonaws.com"
AURORA_SINGLE_HOST="bia-aurora.cluster-clgaiwq42b0j.us-east-2.rds.amazonaws.com"
AURORA_MULTIAZ_WRITER_HOST="bia-aurora-multiaz.cluster-clgaiwq42b0j.us-east-2.rds.amazonaws.com"
AURORA_MULTIAZ_READER_HOST="bia-aurora-multiaz.cluster-ro-clgaiwq42b0j.us-east-2.rds.amazonaws.com"
REMOTE_PORT=5432

echo "Escolha o tipo de host:"
echo "1) RDS"
echo "2) Aurora Single"
echo "3) Aurora Cluster"
read -p "Opção: " opcao

case $opcao in
  1)
    HOST="$RDS_HOST"
    LOCAL_PORT=5444
    ;;
  2)
    HOST="$AURORA_SINGLE_HOST"
    LOCAL_PORT=5445
    ;;
  3)
    echo "  a) Writer (principal)"
    echo "  b) Reader (read-only)"
    read -p "Escolha: " tipo_cluster
    
    if [ "$tipo_cluster" = "a" ]; then
      HOST="$AURORA_MULTIAZ_WRITER_HOST"
    elif [ "$tipo_cluster" = "b" ]; then
      HOST="$AURORA_MULTIAZ_READER_HOST"
    else
      echo "Opção inválida"
      exit 1
    fi
    
    LOCAL_PORT=5446
    ;;
  *)
    echo "Opção inválida"
    exit 1
    ;;
esac

echo ""
echo "Conecte-se usando: localhost:$LOCAL_PORT"
echo ""
echo "Criando túnel SSM..."
aws ssm start-session \
  --target "$BASTION_ID" \
  --document-name AWS-StartPortForwardingSessionToRemoteHost \
  --parameters "{\"host\":[\"$HOST\"],\"portNumber\":[\"$REMOTE_PORT\"],\"localPortNumber\":[\"$LOCAL_PORT\"]}" \
  --profile aula-yt-rds-aurora --region us-east-2
