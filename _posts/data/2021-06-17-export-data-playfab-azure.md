---
title: Export your Data from PlayFab to Azure
image: /assets/images/illustrations/data-management.jpeg
categories:
  - Data
tags:
  - Azure Blob
  - Azure Data Lake
  - Export
  - PlayFab
---
Event Export is the primary mechanism for exporting data from your Insights data cluster without querying. Event Export can be reached under the data section of PlayFab Game Manager. The amount of distinct export commands you can run is tied to your performance level.

When in Dev mode, PlayFab retention is limited to 30 days. This can be increased when you move to production and scale your performance. Sometimes, you may need to have ingestion into another data processing system or loading cleaned data models into machine learning systems, or into other data systems and visualization platforms that provide specialized use cases.

This is why you may need to export your data.

## Prerequisites

- Have an Azure Data Store setup

## Actions

Create a PlayFab data export

1. Login to PlayFab as an Admin
    
    Go to https://developer.playfab.com/ and login with your Azure AD account

2. Navigate to the Event Export page.

    Select the Title you want to extract your data from.

3. Select “New Event Export”.
    
    Fill out the required fields with your external storage account information.

## Details

### On your Azure Storage or Data Lake
- Create your Container in Azure Storage or Data Lake
  > For me, without creativity, this will be playfab

- Retrieve your Access Key
- Fill the PlayFab form
    - Select **Microsoft Azure Blob** (even if this is a Data Lake Gen2)
    - **Storage account** name is your resource name
    - **Container** name is the one create before
    - Prefix is the name of your folder within your container. I recommend using your title ID or name to locate all your title event at one place.
    - Compression is not needed, so avoid, this will be more easier later on to manipulate date.
    
> If the purpose is cold extraction or analytics, choose dailly frequency.