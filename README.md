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
### Screenshot of the Data Model
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
     - Configured table visual, used Advanced filter option to display the top 20 customers, filtered by revenue. The table shows each customer's full name, revenue, and number of orders.
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

### Screenshot of the Customer Detail Report Page
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
     - Configured table visual, used Advanced filter option to display the top 10 products, filtered by revenue. The table shows each products name, category, total revenue, toral customers and number of orders.
     - Added conditional formatting to the revenue column, to display data bars for the revenue values.
### Screenshot of the Executive Summary Report Page
![Executive Summary](/executive_summary.png)

7. Updated Documentation
  - Updated the **README** file on the GitHub repository of the project.
  - Saved the latest version of the Power BI project file (**project.pbix**) and uploaded it to the Github repository.
  - Uploaded Power BI Screenshots to the Github repository.

### 7: Creating a Product Detail Page
The purpose of this page is to provide an in-depth look at which products within the inventory are performing well, with the option to filter by product category and country. As requested by the product team, the following visuals have been created for this report:

1. Gauge visuals to show how the selected category's revenue, profit, and number of orders are performing against a quarterly target.
  - Added a set of three gauges, showing the current-quarter performance of Orders, Revenue and Profit against a quarterly target (10% quarter-on-quarter growth in all three metrics).
    - Defined DAX measures in the measures table for the three metrics, and for the quarterly targets for each metric as follows:
    - **Quarterly Profit = CALCULATE([Total Profit], DATESQTD(Dates[Date]))**
    - **Quarterly Revenue = CALCULATE([Total Revenue], DATESQTD(Dates[Date]))**
    - **Quarterly Orders = CALCULATE([Total Orders], DATESQTD(Dates[Date]))**
    - **Target Quarterly Profit = CALCULATE([Total Profit], DATESQTD(DATEADD(Dates[Date], -1, QUARTER))) * 1.1**
    - **Target Quarterly Revenue = CALCULATE([Total Revenue], DATESQTD(DATEADD(Dates[Date], -1, QUARTER))) * 1.1**
    - **Target Quarterly Orders = CALCULATE([Total Orders], DATESQTD(DATEADD(Dates[Date], -1, QUARTER))) * 1.1**
    - Created three gauge filters, and assigned the created measures. In each case, the maximum value of the gauge was set to the target, so that the gauge shows as full when the target is met.
    - Applied conditional formatting to the callout value, so that it shows as red if the target is not yet met, and black otherwise. See formula below:
    - **Goal Profit Colour = IF('Measures Table'[Quarterly Profit] > 'Measures Table'[Target Quarterly Profit], "#1A1A1A", "#FF0000")**
    - **Goal Revenue Colour = IF('Measures Table'[Quarterly Revenue] > 'Measures Table'[Target Quarterly Revenue], "#1A1A1A", "#FF0000")**
    - **Goal Orders Colour = IF('Measures Table'[Quarterly Orders] > 'Measures Table'[Target Quarterly Orders], "#1A1A1A", "#FF0000")**

2. Card visuals showing which filters are currently selected
  - Add Filter State Cards:  
  - Created the measures for selected category and country and applied them to the filter state cards. See formila for measure below:
  - **Country Selection = SWITCH (TRUE(), SELECTEDVALUE(Stores[Country Code])="GB", "United Kingdom", SELECTEDVALUE(Stores[Country Code])="DE", "Germany", SELECTEDVALUE(Stores[Country Code])= "US", "United States")**
  - **Category Selection = SWITCH (TRUE(), SELECTEDVALUE(Products[Category])="diy", "diy",SELECTEDVALUE(Products[Category])="food-and-drink", "food-and-drink",SELECTEDVALUE(Products[Category])="health-and-beauty", "health-and-beauty",SELECTEDVALUE(Products[Category])="homeware", "homeware",SELECTEDVALUE(Products[Category])="pets", "pets",SELECTEDVALUE(Products[Category])="sports-and-leisure", "sports-and-leisure",SELECTEDVALUE(Products[Category])="toys-and-games", "toys-and-games")**

3. An area chart showing relative revenue performance of each category over time
 - Added a new area chart, and applied the following fields:
 - **X axis** value set to **Dates[Start of Quarter]**
 - **Y axis** value set to **Total Revenue**
 - **Legend** set to **Products[Category]**

4. A table showing the top 10 products by revenue in the selected context
  - Created the Top 10 Products Table
     - Configured table visual, used Advanced filter option to display the top 10 products, filtered by revenue. The table shows each **products name**, **category**, **total revenue**, **total customers** and **number of orders**.

5. A scatter graph of quantity ordered against profit per item for products in the current context. This visual allows the products team to quickly see which product ranges are both top-selling items and also profitable.
  - Created a new calculated column called **[Profit per Item]** in the **Products** table, using a DAX formula to work out the profit per item.
  - Added a new Scatter chart to the page, and configure it as follows:
  - Values set to **Products[Description]**
  - X-Axis set to **Products[Profit per Item]**
  - Y-Axis set to **Products[Total Quantity]**
  - Legend set to **Products[Category]**

6. Created a Slicer Toolbar
  - Added a new blank button to the top of the navigation bar, set the icon type to Custom in the Format pane, and chose a filter image icon. Also set the tooltip text to **Open Slicer Panel**.
  - Added a new rectangle shape with the same colour as the navigation bar (dimensions: height - the page height, width - about 5X the width of the navigation bar). Opened the Selection pane and brought it to the top of the stacking order.
  - Added two new slicers. One set to **Products[Category]**, and the other to **Stores[Country]**. Changed the titles to Category Selection and Country Selection respectively.
    - Selected **Vertical List** slicer style for both slicers
    - Selected multiple items option in the Product Category slicer, but single option in the Country slicer
    - Grouped the slicers with the slicer toolbar shape in the **Selection** pane.
  - Add a **Back** button so that the slicer toolbar can be hidden when it's not in use. Dragged the back button into the group with the slicers and toolbar shape in the **Selection** pane.
  - Opened the **Bookmarks** pane and added two new bookmarks: one with the toolbar group hidden in the Selection pane, and one with it visible. Named them **Slicer Bar Closed** and **Slicer Bar Open**. To prevent the bookmarks from altering the slicer state when we open and close the toolbar, right-clicked each bookmark in turn, and ensured that **Data** is unchecked.
  - Set the **Type** for each button to **Bookmark** and selected the appropriate bookmark. Tested button working OK.

### Screenshot of the Product Detail Report Page
![Product Detail](/product_detail.png)

### Screenshot of the Product Detail Report Page Showing Slicer Panel
![Product Detail Open Slicer Panel](/product_detail_filter.png)

7. Updated Documentation
  - Updated the **README** file on the GitHub repository of the project.
  - Saved the latest version of the Power BI project file (**project.pbix**) and uploaded it to the Github repository.
  - Uploaded Power BI Screenshots to the Github repository.

### 8: Creating a Stores Map Page
The purpose of this page is to allow the regional managers to easily check on the stores under their control, showing them which of the stores are most profitable, as well as which are on track to reach their yearly profit and revenue targets. The following visuals have been created for this report:

1. Added a Map visual and turned on **Show Lables** option.
  - Set the controls of the map as follows:
    - **Auto-Zoom**: On
    - **Zoom buttons**: Off
    - **Lasso button**: Off
  - Assigned the Geography hierarchy to the **Location** field, and **Profit YTD** to the **Bubble size** field.

2. Country Slicer: Added a slicer above the map, set the slicer field to **Stores[Country]**, and in the Format section set the slicer style as **Tile** and the **Selection** settings to **Multi-select with Ctrl/Cmd** and **Show "Select All"** as options in the slicer.

  ### Screenshot of Stores Map Report Page
  ![Stores Map](/stores_map.png)

3. Stores Drillthrough Page that summarises each store's performance
  - Created a new page named **Stores Drillthrough**. Set the **Page type** to **Drillthrough** and set **Drill through from** to **Country Region**. Set **Drill through when** to **Used as category**.
  - Added visuals to the drillthrough page:
  - Gauges for **Profit YTD** and **Revenue YTD** against a target of 20% year-on-year growth vs. the same period in the previous year. Set the target to use the **Target** field, as the target will change as we move through the year. Created the target measures as follows:
    - **Profit Goal = CALCULATE([Profit YTD], DATESYTD(DATEADD(Dates[Date], -1, YEAR))) * 1.2**
    - **Revenue Goal = CALCULATE([Revenue YTD], DATESYTD(DATEADD(Dates[Date], -1, YEAR))) * 1.2**
  - Added a column chart showing **Total Orders** by product **Category** for the store
  - Added a table showing the top 5 products, with columns: **Description**, **Profit YTD**, **Total Orders**, **Total Revenue**
  - Added a Card visual showing the currently selected store.

  ### Screenshot of Stores drillthrough Page
  ![Stores Drillthrough](/stores_drillthrough.png)

4. Stores Tooltip Page
  - Created a custom tooltip page, and copy over the profit gauge and the selected store card visuals
  - Set the tooltip of the map visual to the tooltip page.

  ### Screenshot of Stores tooltip Page
  ![Stores Tooltip](/stores_tooltip.png)

5. Updated Documentation
  - Updated the **README** file on the GitHub repository of the project.
  - Saved the latest version of the Power BI project file (**project.pbix**) and uploaded it to the Github repository.
  - Uploaded Power BI Screenshots to the Github repository.

### 9: Cross-Filtering and Navigation

1. Fixed the cross-filtering - From the Edit Interactions view in the Format tab of the ribbon, set the following interactions: 

  - **Executive Summary Page**
    - **Product Category** bar chart and **Top 10 Products** table will not filter the card visuals or KPIs

  - **Customer Detail Page**
    - **Top 20 Customers** table will not filter any of the other visuals 
    - **Total Customers by Product** Column Chart will not affect the **Customers** line graph 
    - **Total Customers by Country** donut chart will cross-filter **Total Customers by Product** Column Chart.

  - **Product Detail Page**
    - **Orders vs. Profitability** scatter graph will not affect any other visuals 
    - **Top 10 Products** table will not affect any other visuals

2. Finished the Navigation Bar: Add navigation buttons to the individual report pages.
  - In the sidebar of the Executive Summary page, added four new blank buttons, and in the **Format > Button Style** pane, ensured that the **Apply settings** to field is set to **Default**, and set each button icon to the relevant white png in the Icon tab.
  - Set the **Format > Button Style > Apply settings** to **On Hover**, for each button, and then selected the alternative colour of the relevant button icon under the Icon tab.
  - Turned on the **Action** format option, for each button and selected the type as **Page navigation**, and correct page under **Destination**
  - Finally, grouped the buttons together, and copied them across to the other pages.

    ### Screenshot of Executive Summary Page with Navigation Buttons
    ![Executive Summary](/executive_summary_nav.png)

3. Updated Documentation
  - Updated the **README** file on the GitHub repository of the project.
  - Saved the latest version of the Power BI project file (**project.pbix**) and uploaded it to the Github repository.
  - Uploaded Power BI Screenshots to the Github repository.

### 10: Creating Metrics for Users Outside the Company Using SQL 
This is to demonstrate the extraction and dissemination of key data insights for a borader audience who do not have access to specialised visualisation tools like Power BI. 

1. Connected to a Postgres database server hosted on Microsoft Azure from VSCode SQLTools extention with client's credentials. 

2. Checked the Tables and Column Names in the database.
  - Printed a list of the tables in the database and saved the result to a csv file called **order-db_tables.csv** for reference.
  - Printed a list of the columns in the orders table and saved the result to a csv file called **orders_columns.csv**
  - Repeated the same process for each other table in the database, saving the results to a csv file with the same name as the table

3. Queried the Database to answer the following questions. In each case, the query result is exported to a csv file, along with the query itself as a .sql file.
  - How many staff are there in all of the UK stores?
    - Answer (Refer to:  **question_1.csv** and **question_1.sql**)
  - Which month in 2022 has had the highest revenue?
    - Answer (Refer to:  **question_2.csv** and **question_2.sql**)
  - Which German store type had the highest revenue for 2022?
    - Answer (Refer to:  **question_3.csv** and **question_3.sql**)
  - Create a view where the rows are the store types and the columns are the total sales, percentage of total sales and the count of orders
    - Answer (Refer to:  **question_4.csv** and **question_4.sql**)
  - Which product category generated the most profit for the "Wiltshire, UK" region in 2021?
    - Answer (Refer to:  **question_5.csv** and **question_5.sql**)

4. Updated Documentation
  - Updated the **README** file on the GitHub repository of the project.
  - Uploaded SQL queries and results the Github repository.