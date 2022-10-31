# Data ingestion and transformation using Synapse pipelines and data flows
## Description:
This lab gives an option to implement and execute Pipeline by typical data integration scenarios, where data flows in different stages.
A pipeline contains the logical flow for an execution of a set of activities. At first pipeline extracts  source data  from the raw landing zone, then  loads into a staging lake database (adworks).
Using dimensional and muli-dimensional pipelines data will be transformed into a target database (adworkstarget). 

## Prerequisites:
### Log-in to the Azure Portal
1. In a new window, sign in to the **Azure Portal** (<https://portal.azure.com>).

2.  In the **Resource groups** blade, navigate to created resource group and select the created  **Synampse Workspace**.

   ![The Synapse Workspace is highlighted](./assets/01_Synapse.JPG "Select the synapse workspace")  
   
3. In the  **_Overview_** section of synapseworkspace select **_Open_** to open synapse studio.

  ![ws](./assets/2_open_ws.jpg "open WS")

### Note : Synapse Administrator access is already provided and below two steps are only for the learning and knowledge purpose

1. If you dont have the Synapse Administrator access then synapse workspace will promt **Failed to load** message.

![views](./assets/01_failed.JPG "view WS")
    
2.	To provide Synapse Administrator access In Synapse Studio, under  **_Manage_** tab, select **_Access Control_** and add yourself as the **_Synapse Administrator_**

    ![Access](./assets/4_access.JPG "Access")
  
  ### Grant Storage Access
This lab automatically grant workspace identity data access to the workspace Data Lake Storage Gen2 account, using the Storage Blob Data Contributor role. 

## Brief description of the topics covered in lab exercise

### Linked Services
In Azure Synapse Analytics, a linked service is where you define your connection information to other services.
In this lab we are going to use Azure Data Lake Storage Gen2 (ADLS Gen2) linked services.

On the Synapse Studio home page, select the Manage tab in the left navigation
Under External connections, select Linked services.
![LinkedService](./assets/01_LinkedService.jpg "LinkedService")

### Pipeline
A pipeline contains the logical flow for an execution of a set of activities. In this lab you are going do an excersize, where it facilitates you to copy CSV files from raw datalake storage and stored into lake database (adworks)

### Dataflows
Data flows are visually designed data transformations in Azure Synapse Analytics. Data flows allow data engineers to develop data transformation logic without writing code. The resulting data flows are executed as activities within Azure Synapse Analytics pipelines that use scaled-out Apache Spark clusters.

### Dataset
Integration Dataset is a reference dataset to specify the location and structure of your data within a data store which can be used in your pipeline activities and dataflows.

## Source Data:

This Lab uses Retail database as source  to quickly implement dataflows, datasets and integrate pipelines and activities for creating Facts and  dimensional tables.

Retail includes the following technical assets

•	Adventure Works sample CSV source files

•	Integration pipelines, Dataflows and datasets.

•	Staging and multi-dimensional lake databases

## Exercise 1 : Create and run pipeline using the Data flow for loading the data to Lake database

In this section, you will use data flow for creating a pipeline for loading data into lake database.

## DataFlow

 ![LoadCSVDataFlow](./assets/01_LoadCSV.jpg "Load CSV to database")

## Step 1 : Creating Data set from ADLS Gen2 storage

In this section, you will use ADLS Gen2 Storage to create datasets. These datasets will be used further for creating the Data Flows.

### Step 1a : Steps to create Dataset - raw :

1.	Go to the *__Data__* -- > Select *__Linked__* -- > select "_+_" (plus icon)--> Select *__Integrated dataset__* . It will open New integration dataset.

    ![integratedDataset](./assets/07-raw-integrated-dataset.jpg "select integrated dataset")
    
1.	Select *__Azure Data Lake Storage Gen2__* --> *__Continue__* .

    ![rawdatastore](./assets/07-raw-data-store.jpg "raw data store")
    
1.	Select *__Delimited Text__* and press *__Continue__*.

    ![dataformat](./assets/07-raw-data-format.jpg "data format")

1.	Set properties by giving Name as **``raw``**  and select  *__azure raw data lake storage account__* as linked service.

1.	Set the  filepath to **``raw/SynapseRetailFiles``** and select **OK** .
    
    ![setProperties](./assets/07-raw-set-properties.jpg "set properties")

1.  **Clear** schema under section **_Schema_**.

    ![setProperties](./assets/07-adworks_raw_clear.jpg "set properties")   

1.	Select  **+** under Parameter section to create parameters.
    Create parameter with Name as *__folderPath__* with default value **``@dataset().folderPath``** 
    
    ![createParameter](./assets/07-raw-create-parameters.jpg "create parameter")
    
    
1. 	Under connections and under filepath set folder path with  parameter value **``@dataset().folderPath``** and set ``first row as Header`` as **True**.

    ![setConnections](./assets/07-raw-set-connections.jpg "set connections")


### Step 1b : Steps to Create Dataset - adworksraw :

1.	Go to *__Data__* -- > Select *__Linked__* -- >select "_+_" (plus icon)--> Select *__Integrated dataset__* . It will open New integration dataset.
    
    ![integratedDataset](./assets/07-adwork-integrated-dataset.jpg "select integrated dataset")

1.	Select *__Azure Data Lake Storage Gen2__* --> *__Continue__* .
    
    ![rawdatastore](./assets/07-adwork-data-store.jpg "raw data store")

1.	Select *__Delimited Text__* and press *__Continue__*.
    
    ![dataformat](./assets/07-adwork-data-format.jpg "data format")

1.	Set properties by giving Name as **``adworksraw``**  and select  *__azure raw data lake storage account__* as linked service.
    
     ![setProperties](./assets/07-adwork-set-properties.jpg "set properties")

1.	Set the  filepath to **``raw/SynapseRetailFiles``** and select **OK** .

1.  **Clear** schema under section **_Schema_**.

    ![setProperties](./assets/07-adworks_raw_clear.jpg "set properties")   

1.	Select **+** under Parameter section to create parameters
    Create below mentioned two parameter:
    
       i.	Name as **``fileName``** with default value **``@dataset().fileName``**
       
      ii.	Name as **``folderPath``** with default value **``@dataset().folderPath``**
    
    ![createParameter](./assets/07-adwork-create-parameters.jpg "create parameter")

1.  Under connections set folder path with  parameter value **``@dataset().folderPath``**
    set filename as **``@dataset().fileName``** and set first row as Header as **``True``**
    
    ![setConnections](./assets/07-adwork-set-connections.jpg "set connections")

## Step 2 : Create Dataflow using the integration datasets

In this section, you will use integration datasets for creating a dataflow for loading data into lake database.

### Steps to Create Dataflow – adworks_DF :

1.	Go to **_Develop_** tab from left menu, select  **+** (plus icon) and select option **_Dataflow_** and name it as **_``adworks_DF``_** under properties.

 ![Dataflow](./assets/df1.jpg "Create Dataflow")
 
 ![Dataflow](./assets/df2.jpg "Create Dataflow")
 
2.	Create new Parameter and name as **_``tableName``_** and leave **_Defaultvalue_** as empty.

 ![Dataflow](./assets/df3.jpg "Create Dataflow")
 
3.	In the data flow canvas, add a source by clicking on the **AddSource** box.

 ![Dataflow](./assets/df4.jpg "Create Dataflow")

4.	Under source settings give 

5.	Output stream name as **_``CSVSource``_**.

6.	Select sourcetype **_integration dataset_** .

7.	Select dataset  as **_adworksraw_**.

8.	Set below options as **true**.

   i.	 Allow schema drift
   
  ii.  Infer drifted column types

  ![Dataflow](./assets/df5.jpg "Create Dataflow")
  
9.	Next to your source **_CSVSource_** node on the data flow canvas, click on the (+) plus icon to add a new transformation and select **_Sink_** as source.

  ![Dataflow](./assets/df6.jpg "Create Dataflow")
  
10.	Set output stream name as **_``adworksSink``_**.

11.	Select incoming stream as **_CSVSource_**.

12.	Select Sinktype as **_WorkspaceDB_**.

13.	Select Database **_adworks_** 

  ![Dataflow](./assets/df7.jpg "Create Dataflow")

14.   Open expression builder and select Table as **_``$tableName``_**.

   ![Dataflow](./assets/exp.jpg "Create Dataflow")

15.	Select **_Recreate table_** as Table action under settings.

  ![Dataflow](./assets/df9.jpg "Create Dataflow")
 
16.	Select below checkboxes under **_Mapping_** section 
    
    i.	  Skip duplicate input column.
    
    ii.   Skip duplicate output column.
    
 ![Dataflow](./assets/df8.jpg "Create Dataflow")

17. Then click on **Validate** to validate created dataflow. Once dataflow has been validated publish it.
 
 ![Dataflowpublish](./assets/publishdf.jpg "Data flow publish")

### Step 3 : Steps to Create Pipeline :

  1. Go to the Integrate tab. Select the **+** plus icon next to the pipelines header and select Pipeline.
  2. In the Properties settings page of the pipeline, enter **_``Load_CSV_data_to_adworks``_** for Name.

 ![pipeline](./assets/pl1.png "Create pipeline")
 
Select Variable to create below pipeline variables 

  i.	Give name as **_``adworksSourceFolderPath``_** with default value **_SynapseRetailFiles_** (foldername where csv files are located)
  
 ii.	Create one more variable with name **_``tableName``_** with empty default value.
  
  ![pipeline](./assets/plvar.jpg "Create pipeline variable")
  
  2.	Go to pipeline Activities then select and drag **_GetMetadata_** under **General** section 
   
   ![pipeline](./assets/pl2.png "Create pipeline")
   
  3.	Click on **Get Metadata** to set below settings.
  
  4.	Select General section and give name as **_``Get File List``_**  and Timeout **_``7.00:00:00``_**
  
  ![pipeline](./assets/pl3.png "Create pipeline")
  
  5.	Select **Settings** and set dataset name as **_``raw``_**. 
  
  6.	After selecting dataset it will be populated with Dataset Properties.
  
  7.	Set folderPath to **_``@variables('adworksSourceFolderPath')``_**
  
  8.	Add FieldList by click on **+New** and select **ChildItem** from selection.
  
  ![pipeline](./assets/pl4.png "Create pipeline")
  
  9.	Add Output source as **Foreach** activity from Iteration & conditionals
  
  ![pipeline](./assets/pl5.png "Create pipeline")
     
  10.	Give name to **foreach** activity under section **General**. eg. **``foreachtable``**
   
  Select Settings and select Sequential as **True** and  mention Items as **_``@activity('Get File List').output.childItems``_**
       
  11.	Double click on **Foreach** activity  to add activities.
  
  12.	Drag **Set Variable** activity from General activities and name it as **_``Set tableName``_**
   
  ![pipeline](./assets/plfe.jpg "Create pipeline foreach")
   
  13.	Select Variables section and give Name as **_``tableName``_** and value as **_``@replace(item().name,'.csv','')``_**
   
  ![pipeline](./assets/pl6.png "Create pipeline")
      
  14.	Add output source to **set variable** by clicking on **-->** and 
       add **Dataflow** activity  and name it as **_``Load adworks``_** ,set Timeout to **_``1.00:00:00``_**
   
   ![pipeline](./assets/pl7.png "Create pipeline")
       
  15.	Select Section **Settings** and select dataflow as **adworks_DF**
   
  16.	Set CSVSourceParamters as below
        
        -Filename as **_``@item().name``_**
        
        -Folderpath as  **_``@variables('adworksSourceFolderPath')``_**
        
        ![pipeline](./assets/pl8.png "Create pipeline")
        
  17. Set parameter tableName as **Pipeline expression** and value as **_``@variables('tableName')``_**
    
        ![pipeline](./assets/pldf.jpg "Create pipeline DF")
        ![pipeline](./assets/pl9.png "Create pipeline")
   
  18. Then Validate pipeline by clicking **_Validate_** and **_Publish_** it.
  
   ![pipeline](./assets/plpublish.jpg "Create pipeline")
  
  19. To debug the pipeline, select Debug on the toolbar. You see the status of the pipeline run in the Output tab at the bottom of the window.
  
  ![pipeline](./assets/01_runpipeline.JPG "run pipeline")  
   
  20. To Trigger and monitor the pipeline, Select Add Trigger on the toolbar, and then select Trigger Now. On the Pipeline Run page, select OK.
  21. Go to the Monitor tab located in the left sidebar. You see a pipeline run that is triggered by a manual trigger.

  ![pipeline](./assets/01-Trigger.jpg "Trigger pipeline")  
  
  22. After successfull execution of pipeline, verify loaded data under Data--> Lake database (adworks) --> run select script with New SQL Script option.
  
   ![adworks script](./assets/01_LoadSQL.jpg "adworks script")    
  
  ## Exercise 2 : Run Pipelines for Loading IndependentDimensions and DependentDimensions tables

1. To run pipeline,  click on **_Debug_** or select **_Trigger Now_** option under **_Add Trigger_**

![RunPipelines](./assets/11-1_execute_pipelines.jpg "Run Pipelines")

Below are the main difference between debug run and Trigger run : 

**Debug run:**

-Debug run will execute pipeline with draft changes also, That means lets say you did some changes in pipeline and not published them yet. Still Debug run will execute pipeline by considering that changes as well.

-Debug Run cannot be scheduled. Its always manual run.

**Trigger run:**

-Trigger run will execute pipeline with published version only. Drafted changes made in the pipeline will not be considered in it.

-Trigger run can be scheduled.

2. Select **_Integrate_** and execute pipelines in below mentioned sequence.

- IndependentDimensions

## Step 1 : DataFlow to load IndependentDimensions
 ![pipeline](./assets/01_independent.jpg "IndependentDimensions pipeline")  

- DependentDimensions

## Step 2 : DataFlow to load DependentDimensions
 ![pipeline](./assets/01_dependent.jpg "dependentDimensions pipeline")  
 


## Exercise 3 : Create Dataflow – FactSales_DF

### Dataflow – FactSales_DF

![pipeline](./assets/01_FactSales.jpg "FactSales pipeline")  

## Step 1 : Steps to create Dataflow – FactSales_DF

1.	Open FactSales_DF under **_Develop -> DataFlows -> FactSales_DF_**

![developDataflows](./assets/10-01_develop_dataflows.jpg "develop dataflows")

2.  Select AddSource  and name it as **_SalesSource_**,  add   sourcetype **_adworks_** and select  table **_Sales_**.

![addSource](./assets/10-02_add_source.jpg "add source")

![sourceSetting](./assets/10-03_source_setting.jpg "source setting")

3.  Select **+** of SalesSource  to add dervived column under section **_schema modifier_** and name it as **_``SalesderivedColumn``_**.

![schemaModifier](./assets/10-04_schema_modifier.jpg "schema modifier")

4.  Add column with  name **_OrderDateId_** and expression **_toInteger(toString(OrderDate, "yyyyMMdd"))_**

![derivedColumnSettings](./assets/10-05_derived_column_settttings.jpg "derived column settings")

6.	Add source **_Filter_** to SalesderivedColumn and name it as **_``ResellerFilter``_**

![sourceFilter](./assets/10-06_source_filter.jpg "source filter")

6.	Add **_Filter on_** expression as **_``!isNull(CustomerId)``_**

![filterOn](./assets/10-07_filter_on.jpg "filter on")

7.	Add Lookup to **_ResellerFilter_** by selecting LookUp  and Name it as **_``ResellerKeyLookup``_**.

![lookup](./assets/10-08_lookup.jpg "lookup")

8.	Select  Lookup stream as **_``ResellerCustomerSelect``_** from dropdown and add lookup condition as **_``ResellerID == ResellerId_lookup``_**

![lookupStream](./assets/10-09_lookup_stream.jpg "lookup stream")

9.	Add Lookup  to ResellerKeyLookup and name it as **_``ProductKeyLookup``_** and select Lookup stream as **_``DimProductSelect``_** and add lookup condition as **_``ProductId==ProductId``_**

![lookupReseller](./assets/10-10_lookup_reseller.jpg "lookup reseller")

10.	Add Lookup  to ProductKeyLookup and name it as **_``DimDateKeyLookup``_** and select Lookup stream as **_``DimDateSelect``_** and add lookup condition as **_``OrderDateId==Date_lookup``_**

![lookupProduct](./assets/10-11_lookup_product.jpg "lookup product")

11.	Add source as **_``Select``_** to DimDateKeyLookup and name it as **_``FactSalesSelect``_**

12.	Select options **_Skip duplicate input columns_** and **_Skip duplicate output columns_**

13.	Set input columns as below

![selectInput](./assets/10-12_select_input.jpg "select input")

14.	Add source as **_``Sink``_** for destination to **_FactSalesSelect_** and name it as **_``FactSalesSink``_**

![sourceSink](./assets/10-13_source_sink.jpg "source sink")

15. Select **_Sink type_** as **_``WorkspaceDB``_**, Database **_adworkstarget_** from dropdown and mention Table as **_``FactSales``_**.

![sinkType](./assets/10-14_sink_type.jpg "sink type")

16. After successful creation of dataflow make sure you Validate by clicking on  **_Validate_** .

![validate](./assets/10-15_validate.jpg "validate")

17. Once dataflow has been validated **_Publish_** dataflow.

 ## Step 2 : Run Pipelines for Loading Fact tables

1. Select **_Integrate_** and execute pipeline - **_FactTables_** .
2.  After successfull execution of pipeline, verify loaded data under Data--> Lake database (adworkstarget)-->FactSales (Table) --> run select script with New SQL Script option.

## Exercise 4 : Relationship between dimension and fact tables

### Data Model

![DataModel](./assets/01_FactSales_datamodel.jpg "Fact sales Data Model")

### Steps to create relationships between tables :

1) User has to navigate to the synapse workspace.

1) On the left hand side of Synapse Workspace , locate and click on the **_Data_** tab . Under **workspace** section you will find the **Lake database**.You need to select the **_``adworkstarget``_** database to create the relationship.
 
    ![data_tab](./assets/12-Data_tab.jpg "data tab")

1) To open the **adworkstarget** lake database , right click on **adworkstarget** database and click on **_Open_**.
    
     ![lake_db](./assets/12-open_lakedb.jpg "datalake")

1) To view all the tables , expand the **_Others_** section under Tables.You can select **_FactSales_** table on the canvas. It opens the table properties pane with    3 tabs i.e General, Columns, and Relationships.
   
     ![factsales](./assets/12-tables_Factsales.jpg "factsales")

1) The Relationship tab lists the incoming and outgoing relationships of the table with other tables on the canvas.Now you need to map a column of one table to column    of another table.

1) Using the drop-down next to **+ Relationship** tab option , select **_from table_** option.
 
     ![relationships](./assets/12-relationship_tab.jpg "relationships")

1) For **_FactSales_** you need to create a relationship. Select a column **_``OrderDateKey``_** from **_FactSales_** tables(from table) and map it with **_``DateKey``_** column of **_DimTable_**( To Table) .

1) Repeat step 9 and 10 to create remaining relationships for **_FactSales_** table. Make sure you create all the 5 relationships same as mentioned in below snapshot.

    ![table_relationships](./assets/12-table_column_relations.jpg "table relationships")

1) After successful creation of relationships make sure you Validate by clicking on **_Validate all_**.

1) Once clicked on **_Publish all_** the workspace is saved and relationships between the fact and dim tables are seen on the Develop pane with lines attached between tables.
   
   ![publish](./assets/12-validate_publish.jpg "validate and publish")
   
   
   ![link tables](./assets/12-tables_link.jpg "tables linked")
   
 
## Exercise 5 : Report in Power BI

Reports are those elements of any BI and analytics tool that renders the very analytics characteristic to the tool. Power BI offers a convenient and effective methodology to build reports which can be used to drive excellent data analysis. The various functionalities provided by Power BI makes it one of the most favorite BI tools. Reports enable the stakeholders to dig deeper into data to reach the insights which help them in decision making.

### Download and install Power BI Desktop

For downloading Power BI Desktop click on below link and follow the instruction.

Download Power BI Desktop (https://powerbi.microsoft.com/en-us/downloads/)

Click on **_download_** will redirect to Microsoft Store where you can get the Power BI Desktop app.

![download](./assets/download.jpg "download")

### Load Data to Power BI from the Azure Synapse Analytics

1. Open Power BI Desktop from the start menu.

![open](./assets/openpbi.jpg "open")

2. Click on Get Data then select "Azure Synapse Analytics workspace (Beta)"

![getdata](./assets/getdata.jpg "get data")

3. Sign in using your account which you used for the Azure Synapse Analytics and connect.

![signin](./assets/signin.jpg "Sign IN")

4. Expand your workspace and select the tables as shown below (select FactSales first then others)

![ws](./assets/ws.jpg "ws")

5. Click on load. Power BI will now load data from the Azure Synapse Analytics to the Power BI Desktop

![Load](./assets/load.jpg "Load data")

### Manage Relationship

1. Click on **_Model_** in the left side navigation to see the data model then click on **_"Manage Relationship"_**

![model](./assets/datamodel.jpg "data model")

2. Click on new to create a new relationship.

![model](./assets/dm1.jpg "data model")

3. Select **_"FactSales"_** and **_"DimDate"_**. Then select **_OrderdateKey_** and **_DateKeyAltered_** as shown below. Click OK

![model](./assets/dm2.jpg "data model")

### Creating Analysis Report

1. Click on **_Report_** in the left side navigation to start 

![report](./assets/report.jpg "Report")

2. Drag **_SalesAmount_** from FactSales table to the center pane as shown below


![page1](./assets/p11.jpg "page1")

3. Drag **_Product_** from the DimProduct to the X-axis pane.

![page1](./assets/p12.jpg "page1")

4. Click on **_+_** button below for adding new page
5. Select **_Pie chart_** from the visualizations and Select **_SalesAmount_** from FactSales as Y axis and **_channel_** from DimChannel as x axis.
6. In the same page select **_stacked column chart_** and Select **_OrderQuantity_** from FactSales as Y axis and **_channel_** from DimChannel as x axis.

![page2](./assets/p2.jpg "page2")

7. In the new page select **_stacked bar chart_** and Select **_SalesAmount_** from FactSales as Y axis and **_Customer_** from DimCustomer as x axis.

![page3](./assets/p3.jpg "page3")

8. In the new page select **_stacked bar chart_** and Select **_SalesAmount_** from **_FactSales_** as Y axis and **_CountryRegion_** from DimGeoraphy as x axis and **_city_** as legend.

![page4](./assets/p4.jpg "page4")

9. In the new page select **_clustered column chart_** and Select **_SalesAmount_** from FactSales as Y axis and **_Date_** from DimDate as x axis.

![page5](./assets/p5.jpg "page5")

10. Goto File and **_save_** your work.
