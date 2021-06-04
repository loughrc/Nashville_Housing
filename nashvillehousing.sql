/*
Cleaning Data Using SQL

In this project, data cleaning is carried out on a dataset containing info on housing in Nashville.
This is done using Microsoft SQL Server.
The original file, which was originally in xlsx format, was converted into csv format using Excel, and the imported here as a flat file.
This differs from previous projects where we import data into MySQL (Workbench) where we would have to create our table and manually select our datatypes,
but Microsoft SQL Server does many of these steps for us, making importing of data much easier.
*/

Select *
From NashvilleHousing.dbo.nashville


--------------------------------------------------------------------------------------------------------------------------


-- Standardise Date Format
-- We have a time 00:00 at the end of every date; this information is not useful

ALTER TABLE NashvilleHousing.dbo.nashville
ADD SaleDateConverted Date;

UPDATE NashvilleHousing.dbo.nashville
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- Ensure our update worked by viewing the new column along with changes

SELECT saleDateConverted, CONVERT(Date,SaleDate)
FROM NashvilleHousing.dbo.nashville


--------------------------------------------------------------------------------------------------------------------------


-- Populate Property Address Data
-- Some rows in this dataset contain null values for PropertyAddress. 
-- We will try to address this issue by filling in these blank rows if we can.

SELECT PropertyAddress
FROM NashvilleHousing.dbo.nashville
WHERE PropertyAddress IS NULL

SELECT PropertyAddress, ParcelID
FROM NashvilleHousing.dbo.nashville
ORDER BY ParcelID

-- All property addresses that come up more than once have the same ParcelID.
-- Therefore, we can use ParcelID as a reference point to fill in blank values for PropertyAddress.

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing.dbo.nashville a
JOIN NashvilleHousing.dbo.nashville b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

-- The above query shows us what the addresses should be for the rows with null values for PropertyAddress
-- Now, we replace the null values with these addresses

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing.dbo.nashville a
JOIN NashvilleHousing.dbo.nashville b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

-- Now, run our original query again to see if our null values have been removed

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing.dbo.nashville a
JOIN NashvilleHousing.dbo.nashville b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL


--------------------------------------------------------------------------------------------------------------------------

-- Property address column contains the Address, City, and State of the property
-- We want to separate different elements of PropertyAddress into their own specific columns
-- First, look at the data

SELECT PropertyAddress
FROM NashvilleHousing.dbo.nashville

-- Separate whats before the comma (street address) and whats after the comma (city name)

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS City
FROM NashvilleHousing.dbo.nashville
-- Minus 1 (-1) means the query retrieves everything up to 1 character before the comma
-- Plus 1 (+1) means the query retrieves everything from 1 character after the comma

-- Now place these values into two new columns

ALTER TABLE NashvilleHousing.dbo.nashville
ADD PropertySplitAddress VARCHAR(255)

ALTER TABLE NashvilleHousing.dbo.nashville
ADD PropertySplitCity VARCHAR(255)

UPDATE NashvilleHousing.dbo.nashville
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

UPDATE NashvilleHousing.dbo.nashville
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


-- Now check if changes have been made

SELECT *
FROM NashvilleHousing.dbo.nashville


--------------------------------------------------------------------------------------------------------------------------


-- Now, do the same for the OwnerAddress column
-- This time, use PARSENAME instead of SUBSTRING

SELECT OwnerAddress
FROM NashvilleHousing.dbo.nashville

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM NashvilleHousing.dbo.nashville


ALTER TABLE NashvilleHousing.dbo.nashville
ADD OwnerSplitAddress VARCHAR(255)

ALTER TABLE NashvilleHousing.dbo.nashville
ADD OwnerSplitCity VARCHAR(255)

ALTER TABLE NashvilleHousing.dbo.nashville
ADD OwnerSplitState VARCHAR(255)

UPDATE NashvilleHousing.dbo.nashville
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

UPDATE NashvilleHousing.dbo.nashville
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

UPDATE NashvilleHousing.dbo.nashville
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


-- Now check to make sure changes have been made

SELECT *
FROM NashvilleHousing.dbo.nashville


--------------------------------------------------------------------------------------------------------------------------


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing.dbo.nashville
GROUP BY SoldAsVacant
ORDER BY 2


-- Change Y and N to Yes and No in SoldAsVacant column

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM NashvilleHousing.dbo.nashville

UPDATE NashvilleHousing.dbo.nashville
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant   
	END


-- Check to make sure Y and N no longer appear in column

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing.dbo.nashville
GROUP BY SoldAsVacant
ORDER BY 2


--------------------------------------------------------------------------------------------------------------------------


-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From NashvilleHousing.dbo.nashville
)
DELETE
FROM RowNumCTE
WHERE row_num > 1
-- ORDER BY PropertyAddress


-- Check our database to ensure duplicates have been removed

Select *
From NashvilleHousing.dbo.nashville


--------------------------------------------------------------------------------------------------------------------------


-- Delete Unused Columns

ALTER TABLE NashvilleHousing.dbo.nashville
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

SELECT *
FROM NashvilleHousing.dbo.nashville