BEGIN
    BEGIN
        EXECUTE IMMEDIATE 'ADMINISTER KEY MANAGEMENT SET KEYSTORE CLOSE';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;
    BEGIN
        EXECUTE IMMEDIATE 'ADMINISTER KEY MANAGEMENT SET KEYSTORE CLOSE IDENTIFIED BY "$1"';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;
    EXECUTE IMMEDIATE 'ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN IDENTIFIED BY "$1"';
    EXECUTE IMMEDIATE 'CREATE PLUGGABLE DATABASE "$2"
        ADMIN USER "admin" IDENTIFIED BY "$1"
        STORAGE UNLIMITED
        TEMPFILE REUSE
        FILE_NAME_CONVERT=NONE';
END;
/
ALTER PLUGGABLE DATABASE "$2" OPEN READ WRITE
/
ALTER SESSION SET CONTAINER="$2"
/
BEGIN
    BEGIN
        EXECUTE IMMEDIATE 'ADMINISTER KEY MANAGEMENT SET KEYSTORE CLOSE';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;
    BEGIN
        EXECUTE IMMEDIATE 'ADMINISTER KEY MANAGEMENT SET KEYSTORE CLOSE IDENTIFIED BY "$1"';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;
    EXECUTE IMMEDIATE 'ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN IDENTIFIED BY "$1"';
    EXECUTE IMMEDIATE 'ADMINISTER KEY MANAGEMENT SET KEY IDENTIFIED BY "$1" WITH BACKUP';
END;
/
ALTER SESSION SET CONTAINER=CDB$ROOT
/
BEGIN
    BEGIN
        EXECUTE IMMEDIATE 'ADMINISTER KEY MANAGEMENT SET KEYSTORE CLOSE IDENTIFIED BY "$1" CONTAINER=ALL';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;
    BEGIN
        EXECUTE IMMEDIATE 'SELECT * FROM V$ENCRYPTION_WALLET';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;
END;
/

