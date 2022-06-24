---
title: Manage Data from PlayFab in Azure
image: /assets/images/illustrations/data-visualization.jpeg
categories:
  - Data
tags:
  - Azure Blob
  - Azure Data Lake
  - Azure Files
  - Azure Table
  - Non-Structured Data
  - Structured Data
  - PlayFab
---
In Game Industry, like in many others, data engineers must solve complex data problems to provide business value through data. 

This morning, your Executives asked you to provide a dashboard to identify your Title's trends and now, you understand that it's time to dig into the streams? Let's move together but first, let's review some basics

## Data in Azure

### Data types

Azure provides many data platform technologies to meet the needs of common data varieties. It's worth reminding ourselves of the two broad types of data: structured data and non-structured data.

#### Structured Data

In relational database systems like Microsoft SQL Server, Azure SQL Database, and Azure SQL Data Warehouse, data structure (the relational model, table structure, column width, and data types) is defined at design time. This means it's designed before any information is loaded into the system. 

#### Non-Structured Data

Non-Structured data is stored in nonrelational systems, commonly called unstructured or NoSQL systems. Data structure isn't defined at design time, and data is typically loaded in its raw format. The data structure is defined only when the data is read. The difference in the definition point gives you flexibility to use the same source data for different outputs.

### Data Storage

> To avoid being boring and also, because we won't use them in this post, I won't cover all storage system (like Cosmos and SQL)
>
> If you want to cover more, go to https://docs.microsoft.com/en-us/learn/modules/survey-the-azure-data-platform

#### Storage Account

Azure Storage accounts are the base storage type within Azure. This offers a very scalable object store for data objects and file system services in the cloud. It can also provide a messaging store for reliable messaging, or it can act as a NoSQL store. Azure Storage offers four configuration options:

- **Azure Blob**: A scalable object store for text and binary data (the cheapest way to store data in Azure)
- **Azure Files**: Managed file shares for cloud or on-premises deployments
- **Azure Queue**: A messaging store for reliable messaging between application components
- **Azure Table**: A NoSQL store for no-schema storage of structured data

#### Data Lake

Azure Data Lake Storage is a Hadoop-compatible data repository that can store any size or type of data. Data Lake (Gen2) offer the advantage of Azure Blob storage, a hierarchical file system, and performance tuning that helps them process big-data analytics solutions. It can also act as a storage layer for a wide range of compute platforms, including Azure Databricks, Hadoop, and Azure HDInsight, but data doesn't need to be loaded into the platforms.

### Data Management

#### Data Factory

Data Factory is a cloud-integration service. It orchestrates the movement of data between various data stores. Data Factory processes and transforms data by using compute services such as Azure HDInsight, Hadoop, Spark, and Azure Machine Learning. Publish output data to data stores such as Azure Synapse Analytics so that business intelligence applications can consume the data. Ultimately, you use Data Factory to organize raw data into meaningful data stores and data lakes so your organization can make better business decisions.

#### Data Catalog

Analysts, data scientists, developers, and others use Data Catalog to discover, understand, and consume data sources. Data Catalog features a crowdsourcing model of metadata and annotations. In this central location, an organization's users contribute their knowledge to build a community of data sources that are owned by the organization.

## How to Proceed?

Basically you have to address 3 steps before being able to answer your boss :

  * Perform an Extract, Transform, and Load (ETL) process
      * [Export your Data from PlayFab to Azure](2021-06-17-export-data-playfab-azure.md)
      * Import your Data from PlayFab with Azure Data Factory
  * Query Data
  * Render Data