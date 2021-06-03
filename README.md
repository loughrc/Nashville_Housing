## Nashville Housing: Data Cleaning with SQL

### Introduction:
This is another MySQL focussed project, which is based on data cleaning as opposed to data exploration. We also carry out some exploration using Microsoft Excel. We use these tools to clean and explore a dataset with information about houses sold in Nashville, Tennessee (USA).

## The Data:
The data used for this project is a modified version of the dataset at the following link https://www.kaggle.com/tmthyjames/nashville-housing-data-1; the modified version simply contains fewer columns than the original. It gives us a wide variety of features of houses that were sold in the Nashville area from the years 2013-2016, ranging from the general area/address of the house (like suburbs such as Antioch, Madison and Hermitage) and the price it was sold for, to more general attributes of the house such as number of bedrooms, number of bathrooms etc.. This task involves cleaning down this data and making it easier to work with, so that we can then extract knowledge and identify trends in the data that will be visualised using Microsoft Excel.

## Project Overview:
The data was loaded as a single table into Microsoft SQL Server where it was analysed to find out what cleaning had to be done for the data. The cleaning process involves the usual tasks of dropping duplicate rows and removing columns, but also involves splitting particular columns into multiple columns; for example, the OwnerAddress column contains the street address, city and home state of the original owner of the house, and these three pieces of information are separated into three columns to make this data easier to use.

In Excel, a small number of further changes were made to the data, which involved further splitting of columns in order to make the data easier to visualise. Finally, a number of pivot tables were created which give an overview of the average housing prices in different areas of Nashville, as well as identifying trends in the pricing of housing from 2013 to 2016.

## Motivation:
The motivation for this project was to show that SQL can be used for data cleaning as well as simply exploring data. It was also to show how SQL and Microsoft Excel can be used in conjunction with one another to clean and visualise data without the need to delve deeper into programming languages like Python and R when they are not required. It was also interesting to use Microsoft SQL Server, which makes the importing of data a much easier process than with MySQL Workbench.

## Technologies Used:
Microsoft Office Excel, Microsoft SQL Server.

## Summary:
- Imported data for cleaning into Microsoft SQL Server
- Carried out basic data exploration before cleaning data
- Cleaned data using a wide variety of SQL Operations (joins, CTEs, case functions etc.)
- Used Microsoft Excel to create pivot tables and visualisations of different trends found in the data
