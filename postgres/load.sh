#!/bin/env bash

shopt -s extglob
set -x #echo on for debugging (comment to disable)

function main() {

    # the directory of the script
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    # the temp directory used, within $DIR
    # omit the -p parameter to create a temporal directory in the default location
    #WORK_DIR=`mktemp -d -p "$DIR"`
    mkdir data
    WORK_DIR=data

    # check if tmp dir was created
    if [[ ! "$WORK_DIR" || ! -d "$WORK_DIR" ]]; then
      echo "Could not create temp dir"
      exit 1
    fi

    # deletes the temp directory
    function cleanup {      
      rm -rf "$WORK_DIR"
      echo "Deleted temp working directory $WORK_DIR"
    }

    # register the cleanup function to be called on the EXIT signal
    trap cleanup EXIT

    # implementation of script starts here

    # Database and server information
    DBHOST="localhost"
    DBPORT="5432"
    DBUSER="postgres"
    DBNAME="covid19kr"

    BASE_DIR=$(dirname "${BASH_SOURCE[0]}")

    # Change these for your local system
    WGET="/bin/wget"
    PSQL="/bin/psql -q"
    UNZIP="/bin/unzip"
    SED="/bin/sed"
    OGR2OGR="/bin/ogr2ogr"

    $WGET -c -P $WORK_DIR https://raw.githubusercontent.com/jihoo-kim/Coronavirus-Dataset/master/case.csv
    $WGET -c -P $WORK_DIR https://raw.githubusercontent.com/jihoo-kim/Coronavirus-Dataset/master/patient.csv
    $WGET -c -P $WORK_DIR https://raw.githubusercontent.com/jihoo-kim/Coronavirus-Dataset/master/route.csv
    $WGET -c -P $WORK_DIR https://raw.githubusercontent.com/jihoo-kim/Coronavirus-Dataset/master/time.csv
    $WGET -c -P $WORK_DIR https://raw.githubusercontent.com/jihoo-kim/Coronavirus-Dataset/master/trend.csv

    # Make the tables
    $PSQL --host=$DBHOST --port=$DBPORT --username=$DBUSER --dbname=$DBNAME -f "$BASE_DIR/create_tables.sql"

    # case table
    $PSQL --host=$DBHOST --port=$DBPORT --username=$DBUSER --dbname=$DBNAME -c "\copy case FROM $WORK_DIR/case.csv NULL AS '';"
    $PSQL --host=$DBHOST --port=$DBPORT --username=$DBUSER --dbname=$DBNAME -c "ALTER TABLE case ADD PRIMARY KEY (case_id);"
    $PSQL --host=$DBHOST --port=$DBPORT --username=$DBUSER --dbname=$DBNAME -c "SELECT AddGeometryColumn( 'case', 'the_geom', 4326, 'POINT', 2);"
    $PSQL --host=$DBHOST --port=$DBPORT --username=$DBUSER --dbname=$DBNAME -c "UPDATE case SET the_geom = ST_PointFromText('POINT(' || longitude || ' ' || latitude || ')', 4326);"
    $PSQL --host=$DBHOST --port=$DBPORT --username=$DBUSER --dbname=$DBNAME -c "CREATE INDEX covid19kr_the_geom_gist_idx ON case using gist (the_geom);"
    $PSQL --host=$DBHOST --port=$DBPORT --username=$DBUSER --dbname=$DBNAME -c "VACUUM FULL case;"

    # patient table
    $PSQL --host=$DBHOST --port=$DBPORT --username=$DBUSER --dbname=$DBNAME -c "\copy patient from $WORK_DIR/patient.csv NULL as '';"
    $PSQL --host=$DBHOST --port=$DBPORT --username=$DBUSER --dbname=$DBNAME -c "ALTER TABLE patient ADD PRIMARY KEY (patient_id);"
    $PSQL --host=$DBHOST --port=$DBPORT --username=$DBUSER --dbname=$DBNAME -c "VACUUM FULL patient;"

    # route table
    $PSQL --host=$DBHOST --port=$DBPORT --username=$DBUSER --dbname=$DBNAME -c "\copy route from $WORK_DIR/route.csv NULL as '';"
    $PSQL --host=$DBHOST --port=$DBPORT --username=$DBUSER --dbname=$DBNAME -c "ALTER TABLE route ADD PRIMARY KEY (patient_id);"
    $PSQL --host=$DBHOST --port=$DBPORT --username=$DBUSER --dbname=$DBNAME -c "VACUUM FULL route;"


    # time table
    $PSQL --host=$DBHOST --port=$DBPORT --username=$DBUSER --dbname=$DBNAME -c "\copy time from $WORK_DIR/time.csv NULL as '';"
    $PSQL --host=$DBHOST --port=$DBPORT --username=$DBUSER --dbname=$DBNAME -c "ALTER TABLE time ADD PRIMARY KEY (patient_id);"
    $PSQL --host=$DBHOST --port=$DBPORT --username=$DBUSER --dbname=$DBNAME -c "VACUUM FULL time;"

    # trend table
    $PSQL --host=$DBHOST --port=$DBPORT --username=$DBUSER --dbname=$DBNAME -c "\copy trend from $WORK_DIR/trend.csv NULL as '';"
    $PSQL --host=$DBHOST --port=$DBPORT --username=$DBUSER --dbname=$DBNAME -c "ALTER TABLE patient ADD PRIMARY KEY (patient_id);"
    $PSQL --host=$DBHOST --port=$DBPORT --username=$DBUSER --dbname=$DBNAME -c "VACUUM FULL patient;"

    ##TODO add foreign keys
    #$PSQL --host=$DBHOST --port=$DBPORT --username=$DBUSER --dbname=$DBNAME -c "UPDATE geoname SET fclasscode = concat(fclass, '.', fcode);"
}

main $@

