# ###################################################################################################
# https://mikedietrichde.com/2016/01/28/tde-is-wonderful-journey-to-the-cloud-v/
# http://sethmiller.org/oracle-2/oracle-public-cloud-ora-28374-typed-master-key-not-found-in-wallet/
# ###################################################################################################

-- select status, wallet_type, con_id from gv$encryption_wallet;
-- 
-- create pluggable database pdbobiee admin user pdbadmin identified by pdbadmin;
-- create pluggable database pdbps admin user pdbadmin identified by pdbadmin;
--  
-- alter pluggable database pdbobiee open;
-- alter pluggable database pdbps open;
-- 
-- select '!rm ' || wrl_parameter || 'cwallet.sso' from v$encryption_wallet;
-- 
-- administer key management set keystore close;
-- 
-- administer key management set keystore open identified by Enk1tec#_Aeg1 container=all;
-- 
-- administer key management set key identified by Enk1tec#_Aeg1 with backup container=all;
-- 
-- administer key management create auto_login keystore from keystore '/opt/oracle/dcs/commonstore/wallets/tde/RICKDB_phx1ns/' identified by Enk1tec#_Aeg1 ;
-- administer key management create auto_login keystore from keystore '/u02/app/oracle/admin/EXACSDB/tde_wallet/' identified by Enk1tec#_Aeg1 ;


-- create pluggable database gecdwu admin user pdbadmin identified by pdbadmin;
-- alter pluggable database gecdwu open read write;
-- ALTER SESSION SET CONTAINER=gecdwu;
 administer key management set keystore close;
 administer key management set keystore close IDENTIFIED BY "Systemax#1_PcsDB2";
 ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN IDENTIFIED BY "Systemax#1_PcsDB2" container=all;
 administer key management set key identified by "Systemax#1_PcsDB2" with backup container=all;
 administer key management create auto_login keystore from keystore '/opt/oracle/dcs/commonstore/wallets/tde/pcsdb_iad1hh/' identified by Systemax#1_PcsDB2 ;

CREATE OR REPLACE TRIGGER open_pdbs
  AFTER STARTUP ON DATABASE
BEGIN
   EXECUTE IMMEDIATE 'ALTER PLUGGABLE DATABASE ALL OPEN';
END open_pdbs;
/

-- administer key management create auto_login keystore from keystore '/opt/oracle/dcs/commonstore/wallets/tde/pcsdb_iad1hh/' identified by Systemax#1_PcsDB2 ;

