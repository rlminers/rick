-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER dg_role_change AFTER DB_ROLE_CHANGE ON DATABASE DECLARE
    role   VARCHAR(30);
BEGIN
    SELECT
        database_role
    INTO
        role
    FROM
        v$database;

    IF role = 'PRIMARY' THEN
        dbms_scheduler.create_job(
            job_name => 'UPDATE_APP_SERVERS',
            job_type => 'executable',
            job_action => '/home/oracle/failover/scripts/update_app_servers.sh',
            enabled => true
        );

    END IF;

END;
/
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------

BEGIN
    dbms_scheduler.create_credential(
        credential_name => 'ORACLE_CRED',
        username => 'oracle',
        password => 'welcome1'
    );
END;
/

