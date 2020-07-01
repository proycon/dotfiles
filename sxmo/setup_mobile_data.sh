#!/bin/sh
mmcli -m 0 --create-bearer='apn=internet,user=KPN,password=GPRS,allowed-auth=chap,allow-roaming=no'
nmcli c add type gsm ifname cdc-wdm0 con-name SIMYO apn internet user KPN password GPRS
