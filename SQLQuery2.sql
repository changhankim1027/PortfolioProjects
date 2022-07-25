/****** Script for SelectTopNRows command from SSMS  ******/

Select *
From PortfolioProject.dbo.NashvilleHousing


-- Standardize Date Format

Select SaleDate, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SaleDate = convert(date,SaleDate)

alter table NashvilleHousing
add SaleDateConverted date;

update NashvilleHousing
set SaleDateConverted = convert(date,Saledate)


Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing





-- Populate Property Address data

Select *
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
   on a.ParcelID = b.ParcelID
   and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
   on a.ParcelID = b.ParcelID
   and a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null





-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select 
substring(propertyaddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
substring(propertyaddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = substring(propertyaddress, 1, CHARINDEX(',', PropertyAddress) -1)

alter table NashvilleHousing
add PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitCity = substring(propertyaddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))


select *
From PortfolioProject.dbo.NashvilleHousing



select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

select
parsename(replace(OwnerAddress, ',', '.'), 3),
parsename(replace(OwnerAddress, ',', '.'), 2),
parsename(replace(OwnerAddress, ',', '.'), 1)
From PortfolioProject.dbo.NashvilleHousing


alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress = parsename(replace(OwnerAddress, ',', '.'), 3)

alter table NashvilleHousing
add OwnerSplitCity nvarchar(255);

update NashvilleHousing
set OwnerSplitCity = parsename(replace(OwnerAddress, ',', '.'), 2)

alter table NashvilleHousing
add OwnerSplitState nvarchar(255);

update NashvilleHousing
set OwnerSplitState = parsename(replace(OwnerAddress, ',', '.'), 1)

select *
From PortfolioProject.dbo.NashvilleHousing






-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant), count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
From PortfolioProject.dbo.NashvilleHousing


update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end


select distinct(SoldAsVacant), count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2






-- Remove Duplicates

with RowNumCTE as(
select *, 
	row_number() over (
	partition by parcelid,
			     propertyaddress,
				 saleprice,
				 saledate,
				 legalreference
				 order by 
				   uniqueid
				   ) row_num

From PortfolioProject.dbo.NashvilleHousing
)

select *
From RowNumCTE
where row_num > 1
order by PropertyAddress


with RowNumCTE as(
select *, 
	row_number() over (
	partition by parcelid,
			     propertyaddress,
				 saleprice,
				 saledate,
				 legalreference
				 order by 
				   uniqueid
				   ) row_num

From PortfolioProject.dbo.NashvilleHousing
)

DELETE
From RowNumCTE
where row_num > 1


select *
From PortfolioProject.dbo.NashvilleHousing





-- Delete Unused Columns


select *
From PortfolioProject.dbo.NashvilleHousing


alter table PortfolioProject.dbo.NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress, saledate



