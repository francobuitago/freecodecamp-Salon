#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c "

echo -e "\n~~~~~~MY SALON~~~~~~\n\nWelcome to my salon\n\nHow can I help you?\n"


SHOW_SERVICES(){
     if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  SERVICES=$($PSQL "select service_id, name from services order by service_id")
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  read SERVICE_ID_SELECTED

  #Valida que el serivicio escogido sea el correcto
  SERVICE_AVAILABILITY=$($PSQL "select service_id from services where service_id='$SERVICE_ID_SELECTED'")
  #Muestra nuevamente el menú si escoge algo diferente
  if [[ -z $SERVICE_AVAILABILITY ]]
  then
    SHOW_SERVICES_AGAIN
  else
  SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
  fi
  echo "What's your phone number?"
  read CUSTOMER_PHONE

  #Validar que el usuario exista
  CONSULTA_USUARIO=$($PSQL "select * from customers where phone = '$CUSTOMER_PHONE'")
  if [[ -z $CONSULTA_USUARIO ]]
  #si el usuario no existe
  then
    echo "What's your name?"
    read CUSTOMER_NAME
    CREACION_USUARIO=$($PSQL "insert into customers (name, phone) values ('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  fi
  #conseguir id de usuario
  CONSULTA_USUARIO_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
  CONSULTA_USUARIO_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
  #agendar espacio
  echo "What time do you want your service?"
  read SERVICE_TIME
  AGENDAR_SERVICIO=$($PSQL "insert into appointments (customer_id, service_id, time) values ($CONSULTA_USUARIO_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  echo "I have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CONSULTA_USUARIO_NAME."


}

SHOW_SERVICES_AGAIN(){
  echo "I could not find that service. What would you like today?"
  SERVICES=$($PSQL "select service_id, name from services order by service_id")
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  read SERVICE_ID_SELECTED

  #Valida que el serivicio escogido sea el correcto
  SERVICE_AVAILABILITY=$($PSQL "select service_id from services where service_id='$SERVICE_ID_SELECTED'")
  #Muestra nuevamente el menú si escoge algo diferente
  if [[ -z $SERVICE_AVAILABILITY ]]
  then
    SHOW_SERVICES_AGAIN
  else
  SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
  fi
}

SHOW_SERVICES
