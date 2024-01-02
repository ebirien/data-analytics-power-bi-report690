# Data Analytics Power BI Report
## Project Description
This project is a part of the requirements for the Aicore data analytics certification. It was undertaken for a medium-sized international retailer who is keen on elevating their business intelligence practices.

My goal is to use Microsoft Power BI to design a comprehensive Quarterly report which involves extracting and transforming data from various origins, designing a robust data model rooted in a star-based schema, and then constructing a multi-page report.

The report will present a high-level business summary tailored for C-suite executives, and also give insights into their highest value customers segmented by sales region, provide a detailed analysis of top-performing products categorised by type against their sales targets, and a visually appealing map visual that spotlights the performance metrics of their retail outlets across different territories.

The project involved the following tasks:
1. Setting up the development environment
  - Github
  - Visual studio code

2. Importing data into Power BI
  2.1 Loaded and transformed the Orders Table: 
    - Connected to the Azure SQL Database and imported the orders_powerbi table using the clients's Database credentials.
    - Navigated to the Power Query Editor and deleted the column named [Card Number] to ensure data privacy.
    - Used the Split Column feature to separate the [Order Date] and [Shipping Date] columns into two distinct columns: [Order Date], [Order Time],[Shipping Date] and [Shipping Time]
    - Filtered out and removed any rows where the [Order Date] column has missing or null values to maintain data integrity.
    - Renamed the columns to align with Power BI naming conventions, to ensure consistency and clarity in the report.
    - Applied changes to the transformations and renamed the orders_powerbi table as Orders.

  2.2 Imported and transformed the Products Dimension Table:  
    - Downloaded the Products.csv file via the URL provided by the client and then used Power BI's Get Data option to import the file into the project.
    - While in the Data View, used the Remove Duplicates function on the product_code column to ensure each product code is unique
    - While in Power Query editor, used the "Column From Examples" feature to generate a weight_value column from the weight column. Removed the units (kg, g, ml) using the Replace Values feature. Converted the data type to decimal number and replaced the error values with number 1.
    - Also used the "Custom Column" feature and "Text.Select" function to generate a weight_unit column based on the weight column.
    - Replaced any blank entries in the weight_unit column with kg
    - From the Data view, created a new calculated column (Weight), such that if the unit in the weight_unit column is not kg, the corresponding value in the weight_value column is divided by 1000 to convert it to kilograms.
    - Deleted columns that are no longer needed leaving product code, name, category, cost price, sale price, and weight.
    - Renamed the columns to align with Power BI naming conventions, to ensure consistency and clarity in the report.

  2.3 Imported and transformed the Stores Dimension Table:
    - Used Power BI's Get Data option and client's credentials to connect to Azure Blob Storage and imported the Stores table into the project
    - Renamed the columns to align with Power BI naming conventions, to ensure consistency and clarity in the report.
    - Renamed the importated table as "Stores"

  2.4 Imported and transformed the Customers Dimension Table:
  - Downloaded the Customers.zip file via the URL provided by the client and unzipped it on my local machine. The Customers folder has three CSV files with the same column format, one for each of the regions in which the company operates.
  - Used Power BI's Get Data option and Folder data connector to import the Customers folder into the project. Navigated to the Customers folder, and then selected Combine and Transform to import the data.
  - Created a Full Name column by combining the [First Name] and [Last Name] columns
  - Renamed the columns to align with Power BI naming conventions, to ensure consistency and clarity in the report.

  2.5 Updated Documentation
   - Updated the README file on the GitHub repository of the project.
   - Saved the latest version of the project as project.pbix file and uploaded it to the Github repository.