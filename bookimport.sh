#!/usr/bin/bash
DATABASE=$1
COLLECTION=$2
FILENAME=$3
mongoimport -d $DATABASE -c $COLLECTION --file $FILENAME --jsonArray
