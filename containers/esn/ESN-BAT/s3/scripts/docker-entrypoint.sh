#!/bin/bash

service crond start

cd /ericsson/s3/
unzip S3-*.zip
rm -rf S3-*.zip
cd S3-*

sed -i '/dest=/d' /ericsson/s3/S3-1.1.95/etc/IPFile.dat
echo "dest=str-1-msstr1,10101" >> /ericsson/s3/S3-1.1.95/etc/IPFile.dat
echo "dest=str-2-msstr1,10101" >> /ericsson/s3/S3-1.1.95/etc/IPFile.dat
sed -i 's/hour/#hour/' /ericsson/s3/S3-1.1.95/etc/S3.ini
sed -i '/^numCallsPerSec=.*/c\numCallsPerSec=750' /ericsson/s3/S3-1.1.95/etc/S3.ini


finish()
{
        exit
}
trap finish SIGINT

while :; do
        sleep 30
        /etc/init.d/crond status
        if [ $? -ne 0 ] ; then
                exit 1
        fi
done


