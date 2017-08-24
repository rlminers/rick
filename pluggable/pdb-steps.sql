
select status, wallet_type, con_id from gv$encryption_wallet;

select '!rm ' || wrl_parameter || 'cwallet.sso' from v$encryption_wallet;

administer key management set keystore close;
administer key management set keystore open identified by Enk1tec#_Aeg1 container=all;
administer key management set key identified by Enk1tec#_Aeg1 with backup container=all;
administer key management create auto_login keystore from keystore '/u02/app/oracle/admin/ORCL/tde_wallet/' identified by Enk1tec#_Aeg1 ;

select status, wallet_type, con_id from gv$encryption_wallet;


CREATE PLUGGABLE DATABASE pdb2 ADMIN USER pdbadm IDENTIFIED BY Enk1tec#_Aeg1;
alter pluggable database pdb2 open;

alter session set container=cdb$root;
ALTER PLUGGABLE DATABASE pdb2 close;
drop pluggable database pdb2 including datafiles;

