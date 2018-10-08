#!/bin/sh

IDEN_DOM=a4
ORACLE_SID=OPCDB
USER_NAME=user@email.com
USER_PASS=xxxxx
CONT=RMAN_BKP_CSDB

# ###########
# deprecated
# ###########
## -identityDomain ${IDEN_DOM} -serviceName ${ORACLE_SID} \

mkdir lib opc_wallet

java -jar opc_install.jar \
-host https://${IDEN_DOM}.storage.oraclecloud.com/v1/Storage-${IDEN_DOM} \
-opcId 'user@email.com' -opcPass 'xxx' \
-walletDir ~/rman_bkp/opc_wallet -configFile ~/rman_bkp/opc${ORACLE_SID}.ora \
-libDir ~/rman_bkp/lib -container 'RMAN_BKP_CSDB'

echo $?

exit 0

