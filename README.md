# Data Analytics Power BI Report
## Project Description
This project is a part of the requirements for the Aicore data analytics certification. It was undertaken for a medium-sized international retailer who is keen on elevating their business intelligence practices.

My goal is to use Microsoft Power BI to design a comprehensive Quarterly report which involves extracting and transforming data from various origins, designing a robust data model rooted in a star-based schema, and then constructing a multi-page report.

The report will present a high-level business summary tailored for C-suite executives, and also give insights into their highest value customers segmented by sales region, provide a detailed analysis of top-performing products categorised by type against their sales targets, and a visually appealing map visual that spotlights the performance metrics of their retail outlets across different territories.

The project involved the following tasks:
### 1. Setting up the development environment
  - Github
  - Visual studio code
  - Power BI Desktop

### 2: Importing data into Power BI:
1. Loaded and transformed the **Orders** Table: 
  - Connected to the Azure SQL Database and imported the **orders_powerbi** table using the clients's Database credentials.
  - Navigated to the Power Query Editor and deleted the column named **[Card Number]** to ensure data privacy.
  - Used the Split Column feature to separate the **[Order Date]** and **[Shipping Date]** columns into two distinct columns: **[Order Date]**, **[Order Time]**, **[Shipping Date]** and **[Shipping Time]**.
  - Filtered out and removed any rows where the **[Order Date]** column has missing or null values to maintain data integrity.
  - Renamed the columns to align with Power BI naming conventions, to ensure consistency and clarity in the report.
  - Applied changes to the transformations and renamed the **orders_powerbi** table as **Orders**.

2. Imported and transformed the **Products** Dimension Table:  
  - Downloaded the **Products.csv** file via the URL provided by the client and then used Power BI's Get Data option to import the file into the project.
  - While in the Data View, used the **Remove Duplicates** function on the **product_code** column to ensure each product code is unique
  - While in Power Query editor, used the **Column From Examples** feature to generate a **weight_value** column from the **weight** column. Removed the units (**kg**, **g**, **ml**) using the Replace Values feature. Converted the data type to decimal number and replaced the error values with number **1**.
  - Also used the **Custom Column** feature and **Text.Select** function to generate a **weight_unit** column based on the **weight** column.
  - Replaced any blank entries in the **weight_unit** column with **kg**
  - From the Data view, created a new calculated column (Weight), such that if the unit in the **weight_unit** column is not **kg**, the corresponding value in the **weight_value** column is divided by 1000 to convert it to kilograms.
  - Deleted columns that are no longer needed leaving product code, name, category, cost price, sale price, and weight.
  - Renamed the columns to align with Power BI naming conventions, to ensure consistency and clarity in the report.

3. Imported and transformed the **Stores** Dimension Table:
  - Used Power BI's Get Data option and client's credentials to connect to Azure Blob Storage and imported the **Stores** table into the project
  - Renamed the columns to align with Power BI naming conventions, to ensure consistency and clarity in the report.
  - Renamed the importated table as **Stores**

4. Imported and transformed the **Customers** Dimension Table:
  - Downloaded the **Customers.zip** file via the URL provided by the client and unzipped it on my local machine. The Customers folder has three **CSV** files with the same column format, one for each of the regions in which the company operates.
  - Used Power BI's Get Data option and Folder data connector to import the Customers folder into the project. Navigated to the Customers folder, and then selected Combine and Transform to import the data.
  - Created a **Full Name** column by combining the **[First Name]** and **[Last Name]** columns
  - Renamed the columns to align with Power BI naming conventions, to ensure consistency and clarity in the report.

5. Updated Documentation
  - Updated the **README** file on the GitHub repository of the project.
  - Saved the latest version of the Power BI project file (**project.pbix**) and uploaded it to the Github repository.

### 3: Creating the Data Model
To start construction of the the data model for this Power BI project
1. Created a Dates Table:
  - Used DAX formula to create a Dates table running from the start of the year containing the earliest date in the Orders['Order Date'] column to the end of the year containing the latest date in the **Orders['Shipping Date']** column. The Dates table to act as a basis for time intelligence in the Data Model.  
  **Dates = CALENDAR(MIN(Orders[Order Date]), MAX(Orders[Shipping Date]))**

  - Used DAX formulas to add the following columns to the Dates table:
    - **Day of Week = FORMAT(Dates[Date], "dddd")**
    - **Month Number = MONTH(Dates[Date])**
    - **Month Name = FORMAT(Dates[Date], "mmmm")**
    - **Quarter = QUARTER(Dates[Date])** 
    - **Start of Year = STARTOFYEAR(Dates[Date])**
    - **Start of Quarter = STARTOFQUARTER(Dates[Date])** 
    - **Start of Month = STARTOFMONTH(Dates[Date])**

2. Built the Star Schema Data Model: 
- Created relationships between the tables to form a star schema as shown below:
  - **Orders[Product Code] to Products[Product Code]**
  - **Orders[Store Code] to Stores[Store Code]**
  - **Orders[User ID] to Customers[User ID]**
  - **Orders[Order Date] to Dates[Date]**
  - **Orders[Shipping Date] to Dates[Date]**
  - Ensured that the relationship between **Orders[Order Date]** and **Dates[Date]** is the active relationship, and that all relationships are one-to-many, with a single filter direction from the one side to the many side.
### Screeshot of the Data Model
![Data Model](/data_model.png)

3. Created a Measures Table: Created a Measures Table in the Model View with the Power Query Editor option. It makes the measures table visible in the Query Editor, which is useful for debugging and troubleshooting.
  - From the Model view, selected Enter Data from the Home tab of the ribbon
  - Named the new blank table **Measures Table** and then clicked Load.

4. Created Key Measures: Using DAX formulas, the following Key Measures were created:
  - **Total Orders = COUNTROWS(Orders)**
  - **Total Revenue = SUMX(Orders, Orders[Product Quantity] * RELATED(Products[Sale Price]))**
  - **Total Profit = SUMX(Orders, Orders[Product Quantity] *(RELATED(Products[Cost Price]) - RELATED(Products[Sale Price])))**
  - **Total Customers = DISTINCTCOUNT(Orders[User ID])**
  - **Total Quantity = SUM(Orders[Product Quantity])**
  - **Profit YTD = TOTALYTD([Total Profit], Orders[Order Date])**
  - **Revenue YTD = TOTALYTD([Total Revenue], Orders[Order Date])**

5. Creation of Date and Geography Hierrachies: to facilitate drill-down in your line charts, and one for geography, to allow filtering of data by region, country and province/state.
  - Created a date hierarchy using the following levels:
    - **Start of Year**
    - **Start of Quarter**
    - **Start of Month**
    - **Start of Week**
    - **Date**
  - Created a new calculated column in the **Stores** table called **Country** that creates a full country name for each row, based on the **Stores[Country Code]** column, according to the following scheme:
    - **GB : United Kingdom**
    - **US : United States**
    - **DE : Germany**
    - **Country = SWITCH(Stores[Country Code], "GB", "United Kingdom", "US", "United States", "DE", "Germany")**
  - Created a new calculated column in the **Stores** table called **Geography**, based on the **Stores[Country Region]**, and **Stores[Country]** columns.
    - **Geography = Stores[Country Region] & ", " & Stores[Country]**
  - Ensured that the following columns have the correct data category assigned, as follows:
    - **World Region : Continent**
    - **Country : Country**
    - **Country Region : State or Province**
  - Created a Geography hierarchy using the following levels:
    - **World Region**
    - **Country**
    - **Country Region**

6. Updated Documentation
  - Updated the **README** file on the GitHub repository of the project.
  - Saved the latest version of the Power BI project file (**project.pbix**) and uploaded it to the Github repository.

### 4: Setting up the Report
This report page focuses on customer-level analysis and will contain the following visuals:

1. Created four Report Pages named as follows:
   - **Executive Summary**
   - **Customer Detail**
   - **Product Detail**
   - **Stores Map**

2. Added a Navigation Sidebar
   - Inserted a rectangle shape covering a narrow strip on the left side of the **Executive Summary** page and set a fill colour.
   - Duplicated the rectangle shape on each of the other pages in the report.

### 5: Building the Customer Detail Page
This report page focuses on customer-level analysis and will contain the following visuals:

1. Card visuals for the total distinct customers and revenue per customer
  - Created Headline Card Visuals
     - Created two rectangles and arranged them in the top left corner of the page. These will serve as the backgrounds for the card visuals.
     - Added a card visual for the **[Total Customers]** measure we created earlier. Rename the field **Unique Customers**.
     - Created a new measure in the **Measures Table** defined as **[Revenue per Customer] = DIVIDE([Total Revenue],[Total Customers])**
     - Added a card visual for the **[Revenue per Customer]** measure 

2. A line chart of weekly distinct customers
  - Created the Line Chart
     - Added a Line Chart visual to the top of the page. It shows **[Total Customers]** on the Y axis, and uses the **Date Hierarchy** for the X axis. Users are allowed to drill down to the month level, but not to weeks or individual dates.
     - Added a trend line, and a forecast for the next 10 periods with a 95% confidence interval.

3. A table showing the top 20 customers by total revenue, showing the revenue per customer and the total orders for each customer
  - Created the Top 20 Customers Table
     - Created a new table, which displays the top 20 customers, filtered by revenue. The table shows each customer's full name, revenue, and number of orders. See table creation formular below:
     - **Top 20 Customers =
     CALCULATETABLE(
     TOPN(20, SUMMARIZECOLUMNS (
       Customers[Full Name],
       "Total Revenue", SUMX(Orders, Orders[Product Quantity] * RELATED(Products[Sale Price])),
       "Total Orders", (COUNTROWS('Orders'))
       ), [Total Revenue], DESC), Customers[Full Name] <> BLANK()
     )**
     - Added conditional formatting to the revenue column, to display data bars for the revenue values.

4. A Donut chart showing the number of customers by country, and a bar chart showing number of customers per product category
  - Created the Summary Charts
     - Added a Donut Chart visual showing the total customers for each country, using the **Customers[Country]** column to filter the [**Total Customers]** measure.
     - Added a Column Chart visual showing the number of customers who purchased each product category, using the **Products[Category]** column to filter the **[Total Customers]** measure.

5. A set of three card visuals showing the name, number of orders, and revenue for the top customer by revenue
  - Created the Top Customers Cards to display the top customer's name, the number of orders made by the customer, and the total revenue generated by the customer. See table creation formular below:
     - **Top Customer = 
     CALCULATETABLE(
     TOPN(20, SUMMARIZECOLUMNS (
       Customers[Full Name],
       "Total Revenue", SUMX(Orders, Orders[Product Quantity] * RELATED(Products[Sale Price])),
       "Total Orders", (COUNTROWS('Orders'))
       ), [Total Revenue], DESC), Customers[Full Name] <> BLANK()
     )**

6. A date slicer
  - Added A Date Slicer
     - Added a date slicer to allow users to filter the page by year, using the between slicer style. 

   ### Screeshot of the Customer Detail Report Page
   ![Customer Detail](/customer_detail.png)

7. Updated Documentation
  - Updated the **README** file on the GitHub repository of the project.
  - Saved the latest version of the Power BI project file (**project.pbix**) and uploaded it to the Github repository.
  - Uploaded Power BI Screenshots to the Github repository.

### 6: Creating an Executive Summary Page
This report page is for high-level executive summary. The purpose of this report is to give an overview of the company's performance as a whole, so that the C-suite executives can quickly get insights and check outcomes against key targets. As requested by the executives, the following visuals have been created for this report:

1. Card visuals showing Total Revenue, Total Profit and Total Orders
  - The following steps were followed to create the Card visuals:
    - Copied one of your grouped card visuals from the Customer Detail page and pasted it onto the Executive Summary page
    - Duplicated it two more times, and arranged the three cards so that they spanned about half of the width of the page
    - Assigned them to your **Total Revenue**, **Total Orders** and **Total Profit** measures
    - Used the **Format > Callout** Value pane to ensure no more than 2 decimal places in the case of the revenue and profit cards, and only 1 decimal place in the case of the Total Orders measure

2. A graph of revenue against time
  - The following steps were followed to add a Revenue Trending Line Chart:
    - Copied the line graph from the Customer Detail page, and changed it as follows:
    - Set X axis to the Date Hierarchy, with only the Start of Year, Start of Quarter and Start of Month levels displayed
    - Set Y-axis to Total Revenue
    - Position the line chart just below the cards

3. Donut charts showing orders and revenue by country
  - Added a pair of donut charts, showing Total Revenue broken down by **Store[Country]** and **Store[Store Type]** respectively. 
  - Positioned these to the right of the cards along the top of the page.

4. A bar chart of orders by category
  - Added a bar Chart of Orders by product category using the following steps:
    - Copied the **Total Customers by Product Category** donut chart from the **Customer Detail** page
    - In the on-object **Build a visual** pane, changed the visual type to **Clustered bar chart**
    - Changed the X axis field from **Total Customers** to **Total Orders**
    - With the Format pane open, clicked on one of the bars to bring up the **Colors** tab, and selected an appropriate colour for the theme.

5. KPIs for Quarterly revenue, Orders and Profit
  - The following steps were followed to add KPI Visuals:
  - Created three new measures (**Previous Quarter Profit**, **Previous Quarter Revenue**, **Previous Quarter Orders**) for the quarterly targets. Set Targets, equal to 5% growth in each measure compared to the previous quarter.
  - Added a new KPI for the revenue with the following settings:
    - The **Value** field is **Total Revenue**
    - The **Trend Axis&& is **Start of Quarter**
    - The **Target** is **Target Revenue**
  - In the Format pane, the **Trend Axis** was set to **On**, the associated tab expanded, and the values set as follows:
    - **Direction : High is Good**
    - **Bad Colour : red**
    - **Transparency : 15%**
  - Formated the Callout Value so that it only shows to 1 decimal place.
  - Duplicated the card two more times, and set the appropriate values for the Profit and Orders cards.
  - Arranged the three cards below the revenue line chart.

6. A table of the top 10 products
  - Created the Top 10 Products Table
     - Created a new table, which displays the top 10 products, filtered by revenue. The table shows each products name, category, total revenue, toral customers and number of orders. See table creation formular below:
     - Top 10 Products = 
       TOPN(10,  SUMMARIZECOLUMNS (
       Products[Name],
       Products[Category],
       "Total Revenue", SUMX(Orders, Orders[Product Quantity] * RELATED(Products[Sale Price])),
       "Total Customers", DISTINCTCOUNT(Orders[User ID]), 
       "Total Orders", (COUNTROWS('Orders'))
     ), [Total Revenue], DESC)
     - Added conditional formatting to the revenue column, to display data bars for the revenue values.
   ### Screeshot of the Executive Summary Report Page
   ![Executive Summary](/executive_summary.png)

7. Updated Documentation
  - Updated the **README** file on the GitHub repository of the project.
  - Saved the latest version of the Power BI project file (**project.pbix**) and uploaded it to the Github repository.
  - Uploaded Power BI Screenshots to the Github repository.

