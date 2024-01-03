# Data Analytics Power BI Report
## Project Description
This project is a part of the requirements for the Aicore data analytics certification. It was undertaken for a medium-sized international retailer who is keen on elevating their business intelligence practices.

My goal is to use Microsoft Power BI to design a comprehensive Quarterly report which involves extracting and transforming data from various origins, designing a robust data model rooted in a star-based schema, and then constructing a multi-page report.

The report will present a high-level business summary tailored for C-suite executives, and also give insights into their highest value customers segmented by sales region, provide a detailed analysis of top-performing products categorised by type against their sales targets, and a visually appealing map visual that spotlights the performance metrics of their retail outlets across different territories.

The project involved the following tasks:
1. Setting up the development environment
  - Github
  - Visual studio code

2. Importing data into Power BI:
    - Loaded and transformed the Orders Table: 
      - Connected to the Azure SQL Database and imported the orders_powerbi table using the clients's Database credentials.
      - Navigated to the Power Query Editor and deleted the column named [Card Number] to ensure data privacy.
      - Used the Split Column feature to separate the [Order Date] and [Shipping Date] columns into two distinct columns: [Order Date], [Order Time],[Shipping Date] and [Shipping Time]
      - Filtered out and removed any rows where the [Order Date] column has missing or null values to maintain data integrity.
      - Renamed the columns to align with Power BI naming conventions, to ensure consistency and clarity in the report.
      - Applied changes to the transformations and renamed the orders_powerbi table as Orders.

   - Imported and transformed the Products Dimension Table:  
      - Downloaded the Products.csv file via the URL provided by the client and then used Power BI's Get Data option to import the file into the project.
      - While in the Data View, used the Remove Duplicates function on the product_code column to ensure each product code is unique
      - While in Power Query editor, used the "Column From Examples" feature to generate a weight_value column from the weight column. Removed the units (kg, g, ml) using the Replace Values feature. Converted the data type to decimal number and replaced the error values with number 1.
      - Also used the "Custom Column" feature and "Text.Select" function to generate a weight_unit column based on the weight column.
      - Replaced any blank entries in the weight_unit column with kg
      - From the Data view, created a new calculated column (Weight), such that if the unit in the weight_unit column is not kg, the corresponding value in the weight_value column is divided by 1000 to convert it to kilograms.
      - Deleted columns that are no longer needed leaving product code, name, category, cost price, sale price, and weight.
      - Renamed the columns to align with Power BI naming conventions, to ensure consistency and clarity in the report.

   - Imported and transformed the Stores Dimension Table:
      - Used Power BI's Get Data option and client's credentials to connect to Azure Blob Storage and imported the Stores table into the project
      - Renamed the columns to align with Power BI naming conventions, to ensure consistency and clarity in the report.
      - Renamed the importated table as "Stores"

   - Imported and transformed the Customers Dimension Table:
      - Downloaded the Customers.zip file via the URL provided by the client and unzipped it on my local machine. The Customers folder has three CSV files with the same column format, one for each of the regions in which the company operates.
      - Used Power BI's Get Data option and Folder data connector to import the Customers folder into the project. Navigated to the Customers folder, and then selected Combine and Transform to import the data.
      - Created a Full Name column by combining the [First Name] and [Last Name] columns
      - Renamed the columns to align with Power BI naming conventions, to ensure consistency and clarity in the report.

   - Updated Documentation
      - Updated the README file on the GitHub repository of the project.
      - Saved the latest version of the project as project.pbix file and uploaded it to the Github repository.
  
3. Creation of the Data Model:
   - Created a Dates Table
     - Used DAX formula to create a Dates table running from the start of the year containing the earliest date in the Orders['Order Date'] column to the end of the year containing the latest date in the Orders['Shipping Date'] column. The Dates table to act as a basis for timr intelligence for the Data Model.  
     - Formula: Dates = CALENDAR(MIN(Orders[Order Date]), MAX(Orders[Shipping Date]))

     - Used DAX formulas to add the following columns to the Dates table:
       - Day of Week = FORMAT(Dates[Date], "dddd")
       - Month Number = MONTH(Dates[Date])
       - Month Name = FORMAT(Dates[Date], "mmmm")
       - Quarter = QUARTER(Dates[Date]) 
       - Start of Year = STARTOFYEAR(Dates[Date])
       - Start of Quarter = STARTOFQUARTER(Dates[Date]) 
       - Start of Month = STARTOFMONTH(Dates[Date])

   - Building of the Star Schema Data Model: 
     - Created relationships between the tables to form a star schema. The relationships should be as follows:
        - Orders[Product Code] to Products[Product Code]
        - Orders[Store Code] to Stores[Store Code]
        - Orders[User ID] to Customers[User ID]
        - Orders[Order Date] to Dates[Date]
        - Orders[Shipping Date] to Dates[Date]
     - Ensured that the relationship between Orders[Order Date] and Date[Date] is the active relationship, and that all relationships are one-to-many, with a single filter direction from the one side to the many side.
   ### Screeshot of the Data Model
   ![Data Model](/data_model.png)

   - Creation of a Measures Table: Created a Measures Table in the Model View with Power Query Editor. This makes the measures table visible in the Query Editor, which is useful for debugging and troubleshooting.
     - From the Model view, selected Enter Data from the Home tab of the ribbon
     - Named the new blank table "Measures" Table and then clicked Load.

   - Creation of Key Measures: Using DAX formulas, the following Key Measures were created:
     - Total Orders = COUNTROWS(Orders)
     - Total Revenue = SUMX(Orders, Orders[Product Quantity] * RELATED(Products[Sale Price]))
     - Total Profit = SUMX(Orders, Orders[Product Quantity] *(RELATED(Products[Cost Price]) - RELATED(Products[Sale Price])))
     - Total Customers = DISTINCTCOUNT(Orders[User ID])
     - Total Quantity = SUM(Orders[Product Quantity])
     - Profit YTD = TOTALYTD([Total Profit], Orders[Order Date])
     - Revenue YTD = TOTALYTD([Total Revenue], Orders[Order Date])

   - Creation of Date and Geography Hierrachies:
     - Created two hierarchies: one for dates, to facilitate drill-down in your line charts, and one for geography, to allow filtering of data by region, country and province/state.
     - Create a date hierarchy using the following levels:
       - Start of Year
       - Start of Quarter
       - Start of Month
       - Start of Week
       - Date
     - Created a new calculated column in the Stores table called Country that creates a full country name for each row, based on the Stores[Country Code] column, according to the following scheme:
       - GB : United Kingdom
       - US : United States
       - DE : Germany
       - Formula: Country = SWITCH(Stores[Country Code], "GB", "United Kingdom", "US", "United States", "DE", "Germany")
     - Created a new calculated column in the Stores table called "Geography", based on the Stores[Country Region], and Stores[Country] columns.
       - Formula: Geography = Stores[Country Region] & ", " & Stores[Country] 
     - Ensured that the following columns have the correct data category assigned, as follows:
       - World Region : Continent
       - Country : Country
       - Country Region : State or Province
     - Created a Geography hierarchy using the following levels:
       - World Region
       - Country
       - Country Region