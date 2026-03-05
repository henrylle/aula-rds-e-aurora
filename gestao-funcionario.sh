#!/bin/bash

echo "Escolha o banco de dados:"
echo "1) RDS (localhost:5444)"
echo "2) Aurora Single (localhost:5445)"
echo "3) Aurora Multi-AZ Writer (localhost:5446)"
echo "4) Aurora Multi-AZ Reader (localhost:5446)"
read -p "Opção: " opcao_db

case $opcao_db in
  1) DB_PORT=5444 ;;
  2) DB_PORT=5445 ;;
  3) DB_PORT=5446 ;;
  4) DB_PORT=5446 ;;
  *)
    echo "Opção inválida"
    exit 1
    ;;
esac

DB_HOST="localhost"
DB_USER="postgres"
DB_NAME="formacao-aws"

read -sp "Senha do banco: " DB_PASSWORD
echo ""

export PGPASSWORD="$DB_PASSWORD"

while true; do
  echo ""
  echo "=== Gestão de Funcionários ==="
  echo "1) Criar banco"
  echo "2) Criar tabela"
  echo "3) Inserir funcionário"
  echo "4) Ler registros"
  echo "5) Sair"
  read -p "Opção: " opcao

  case $opcao in
    1)
      SQL="CREATE DATABASE \"$DB_NAME\";"
      echo "SQL: $SQL"
      echo ""
      psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d postgres -c "$SQL"
      echo ""
      ;;
    2)
      SQL="CREATE TABLE funcionario (id SERIAL PRIMARY KEY, nome VARCHAR(255) NOT NULL);"
      echo "SQL: $SQL"
      echo ""
      psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "$SQL"
      echo ""
      ;;
    3)
      read -p "Nome do funcionário: " nome
      SQL="INSERT INTO funcionario (nome) VALUES ('$nome') RETURNING *;"
      echo "SQL: $SQL"
      echo ""
      psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "$SQL"
      echo ""
      ;;
    4)
      SQL="SELECT * FROM funcionario;"
      echo "SQL: $SQL"
      echo ""
      psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "$SQL"
      echo ""
      ;;
    5)
      echo "Saindo..."
      exit 0
      ;;
    *)
      echo "Opção inválida"
      ;;
  esac
done
