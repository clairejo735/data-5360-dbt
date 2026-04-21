# Eco Essentials Analytics

## Overview
Eco Essentials is an eco-fieldly cookware company seeking to optimize data infastructure to gain deeper insights into its operations and customer behavior. This project contains a full analytics pipeline starting with source extraction and ending with a stakeholder-ready dashboard.

This README summarizes the business case as well as the data architecture, modeling, transformation, testing, scheduling, and visualization.

**Business case:** Eco Essentials wants to focus on the following business processes:
* Eco Essentials Sales → Report on sales and trends as to how sales perform over time.
* Marketing Email Conversion (Salesforce Marketing Cloud) → Report on email events and conversion to purchasing products online.

**Data Sources:**
* Online Purchasing Transactions (Amazon RDS Postgres Database)
* Salesforce Marketing Cloud Email Events (Location: AWS S3 Bucket)

  
## Project Steps

### Part 1 - Enterprise Data Warehouse Design
**Deliverable:** A clean, structured star schema that facilitates efficient data analysis while supporting *both* business processes.

**BUS Matrix:**
<img width="809" height="192" alt="Screenshot 2026-04-15 121336" src="https://github.com/user-attachments/assets/0b4ec7a4-8c7e-44e9-9ee1-03e9d1f86288" />

**Business Processes:**
* Sales Process
  * Grain: Quantity of one product bought by a customer at a specific time at a specific price that is determined by the existence of a discount.
  * Dimensions
    * Product
    * Campaign*
    * Date*
    * Customer*
  * Facts
    * Orderline
      * Quantity
      * Discount
      * Price
      * Price after discount
* Marketing Email Conversion Process
  * Grain: Each individual interaction (event) a subscriber has with an individual campaign email at a point in time.
  * Dimensions
    * Email
    * Campaign*
    * Customer*
    * Action (event)
    * Timestamp
    * Date*
  * Facts → *factless*, captures events without additional numeric values

NOTE: * = Conformed dimensions between both business processes
#### Completed Entity Relationship Diagram:
<img width="1358" height="851" alt="Screenshot 2026-04-20 142020" src="https://github.com/user-attachments/assets/876ca9ab-256f-4593-8b74-6448eae50938" />

### Part 2 - ELT Transformation, Fivetran, and Snowflake Integration

**Deliverable and Overview:** ETL workflow that seamlessly transitiona data from 3rd party sources (above) to the Snowflake enterprise data warehouse using dbt. 

#### Pipeline Steps:
1. Extract and Load
    1. Using Fivetran, we extracted data from the above datasources and placed the data in Snowflake landing tables within our personal databases
2. Transform
    1. Dbt was implemented to create and populate our dimensional models. Each dimension tables’ primary key was created using the dbt_utils.generate_surrogate_key functionality.
    2. All changes and additions to the dimensional model were updated using GitHub version control.

##### Modeling and Code References:
[Ecoessentials Main Folder](https://github.com/clairejo735/data-5360-dbt/tree/main/models/ecoessentials)

**Key Files:**
* [Eco Essentials Schema](https://github.com/clairejo735/data-5360-dbt/blob/main/models/ecoessentials/_schema_ecoessentials.yml)
* [Eco Essentials Source](https://github.com/clairejo735/data-5360-dbt/blob/main/models/ecoessentials/_src_ecoessentials.yml)
* [Campaign Dimension](https://github.com/clairejo735/data-5360-dbt/blob/main/models/ecoessentials/eco_dim_campaign.sql)
* [Customer Dimension](https://github.com/clairejo735/data-5360-dbt/blob/main/models/ecoessentials/eco_dim_customer.sql)
* [Date Dimensions](https://github.com/clairejo735/data-5360-dbt/blob/main/models/ecoessentials/eco_dim_date.sql)
* [Product Dimension](https://github.com/clairejo735/data-5360-dbt/blob/main/models/ecoessentials/eco_dim_product.sql)
* [Event Dimension](https://github.com/clairejo735/data-5360-dbt/blob/main/models/ecoessentials/eco_dim_event.sql)
* [Email Dimension](https://github.com/clairejo735/data-5360-dbt/blob/main/models/ecoessentials/eco_dim_email.sql)
* [Timestamp Dimension](https://github.com/clairejo735/data-5360-dbt/blob/main/models/ecoessentials/eco_dim_timestamp.sql)
* [Marketing Email Conversion Fact](https://github.com/clairejo735/data-5360-dbt/blob/main/models/ecoessentials/fact_marketing_email_conversion.sql)
* [Order Line Fact](https://github.com/clairejo735/data-5360-dbt/blob/main/models/ecoessentials/fact_order_line.sql)

Final results were tested by running various queries and checking table structure in Snowflake.

### Part 3 - Scheduling and Testing
**Deliverable:** A validated warehouse with quality checks like unique, not_null, accepted_values, and relationships testing where appropriate and a fresh and timely warehouse.
**Tests Implemented:**
1. Dim_campaign → unique campaign name
2. Dim_customer → unique customer email address
3. Dim_date → date value not null
4. Dim_email → unique campaign email name
5. Dim_event → only accepts 'SENT', 'OPEN', 'CLICK' as valid email event types
6. Dim_product → unique product name
7. Dim_timestamp → timestamp value not null
8. Fact_order_line → relationships to all associated dimension tables except campaign (not all orders stemmed from a campaign promotion)
9. fact_marketing_email)conversion → relationships to all associated dimension tables

**Scheduling:**
* Fivetran connectors set to sync every 24 hours
* dbt transformations run with this schedule

### Part 4 - Visualization and Communication
**Deliverable:** A dashboard allowing easily consumable insights and visuals from the data warehouse connected live to Snowflake.

#### Tableau Dashboard (Interactive):
<img width="3000" height="1998" alt="EE dashboard, everything" src="https://github.com/user-attachments/assets/d02d0c63-2a55-4e12-a891-fa0c222e94a1" />


  
## Key Takeaways
* Built a **scalable warehouse** using ETL tools like Snowflake, dbt, and Fivetran
* Designed a **conformed dimension model** supporting multiple processes
* Implemented **dbt** transformations and testing
* Automated the process using **Fivetran** and **Snowflake**
* Delivered a **dashboard** for easy insights
