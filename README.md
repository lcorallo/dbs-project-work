# dbs-project-work

1. Docker compose up -d
2. follow instructions to set system admin

3.a. execute ACTIVE_ORDBMS/LOGISTICS_USER.sql with system admin profile to the NODE: oracle-xe;
3.b. execute DATA_WAREHOUSE/LOGISTICS_USER.sql with system admin profile to the NODE: oracle-dw;

4. execute DATA_WAREHOUSE/LOGISTICS_DEFINITION.sql with user LOGISTICS_DW to the NODE: oracle-dw;
5. execute ACTIVE_ORDBMS/LOGISTICS_DEFINITION.sql with user LOGISTICS to the NODE: oracle-xe;
6. execute ACTIVE_ORDBMS/LOGISTICS_POPULATION.sql with user LOGISTICS to the NODE: oracle-xe;
7. execute ACTIVE_ORDBMS/LOGISTICS_OPS.sql with user LOGISTICS to the NODE: oracle-xe;
8. execute ACTIVE_ORDBMS/LOGISTICS_TEST.sql with user LOGISTICS to the NODE: oracle-xe;
9. execute ACTIVE_ORDBMS/LOGISTICS_ETL.sql with user LOGISTICS to the NODE: oracle-xe;

10. execute DATA_WAREHOUSE/LOGISTICS_OPS.sql with user LOGISTICS_DW to the NODE: oracle-dw;