
SHOW PARAMETER NLS_LANGUAGE
SHOW PARAMETER NLS_TERRITORY
SHOW PARAMETER NLS_LENGTH_SEMANTICS

col name format a20
col value format a20

SELECT name
, value$
from SYS.PROPS$
WHERE name = 'NLS_CHARACTERSET'
/

select d.platform_name
, endian_format
from v$transportable_platform tp
, v$database d
where tp.platform_name = d.platform_name
/

SELECT *
FROM NLS_DATABASE_PARAMETERS
where parameter in ( 'NLS_LANGUAGE','NLS_TERRITORY','NLS_CHARACTERSET' )
/

