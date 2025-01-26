# 🚀 **DBS Project Work**

A step-by-step guide to set up and run your project.

---

## 📦 **Setup Instructions**

### Step 1: 🐳 Start Docker Containers
1. Run the following command to bring up the Docker containers:
   ```bash
   docker-compose up -d

### Step 2: ⚙️ Configure System Admin
1. Follow the instructions to set up the **system admin**.
2. Before starting each server node, execute the following commands:
   ```sql
   SELECT * FROM V$PARAMETER WHERE NAME = 'common_user_prefix';
   ALTER SYSTEM SET common_user_prefix = '' SCOPE = SPFILE;
3. Next we have to restart the rispectively container. 


### Step 3: 🎯 Set Up Initial Users
1. Execute the following SQL scripts **with the system admin profile**:
   - `ACTIVE_ORDBMS/LOGISTICS_USER.sql` to the **node**: `oracle-xe`
   - `DATA_WAREHOUSE/LOGISTICS_USER.sql` to the **node**: `oracle-dw`


### Step 4: 📊 Define Data Structures
1. Run the following SQL scripts:
   - `DATA_WAREHOUSE/LOGISTICS_DEFINITION.sql` **with user**: `LOGISTICS_DW` **to the node**: `oracle-dw`
   - `ACTIVE_ORDBMS/LOGISTICS_DEFINITION.sql` **with user**: `LOGISTICS` **to the node**: `oracle-xe`


### Step 5: 📥 Populate Data
1. Execute:
   - `ACTIVE_ORDBMS/LOGISTICS_POPULATION.sql` **with user**: `LOGISTICS` **to the node**: `oracle-xe`


### Step 6: ⚡ ETL Procedures
1. Run the ETL script:
   - `ACTIVE_ORDBMS/LOGISTICS_ETL.sql` **with user**: `LOGISTICS` **to the node**: `oracle-xe`


### Step 7: 🔄 Operational Procedures
1. Run these SQL scripts to handle system operations:
   - `ACTIVE_ORDBMS/LOGISTICS_OPS.sql` **with user**: `LOGISTICS` **to the node**: `oracle-xe`
   - `DATA_WAREHOUSE/LOGISTICS_OPS.sql` **with user**: `LOGISTICS_DW` **to the node**: `oracle-dw`


### Step 8: 🧪 Testing
1. Execute tests using:
   - `ACTIVE_ORDBMS/LOGISTICS_TEST.sql` **with user**: `LOGISTICS` **to the node**: `oracle-xe`

