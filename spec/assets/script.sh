#!/bin/sh
CONTADOR=0
while [  $CONTADOR -lt 5 ]; do
  echo $PATH
  echo $SOURCE
  echo $MMDE
  sleep 3s
  echo  "!#OUTPUT $CONTADOR=$CONTADOR" 
  let CONTADOR=CONTADOR+1;   
done