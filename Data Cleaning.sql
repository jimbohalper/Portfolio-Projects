select *
from PortfolioProject..Housing

-- Standardize Date Format
Select SaleDateConverted
from PortfolioProject..Housing

update Housing
set SaleDate = Convert(Date, SaleDate)

alter table Housing
Add SaleDateConverted Date;

update Housing
set SaleDateConverted = Convert(Date, SaleDate)

--Populate Property Address Data
select *
from PortfolioProject..Housing
--where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..Housing a
join PortfolioProject..Housing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..Housing a
join PortfolioProject..Housing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null



-- Breaking out Address into individual columns (address, city, state)
select PropertyAddress
from PortfolioProject..Housing

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as Address
from PortfolioProject..Housing


alter table Housing
Add PropertySplitAddress nvarchar(255);

update Housing
set PropertySplitAddress  = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


alter table Housing
Add PropertySplitCity nvarchar(255);

update Housing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))

select PropertySplitCity, PropertySplitAddress  
from PortfolioProject..Housing



-- An Alternative to using the Substring Function is the Parsename function

select OwnerAddress
from PortfolioProject..Housing


select
Parsename(replace(OwnerAddress, ',','.'), 1)
,Parsename(replace(OwnerAddress, ',','.'), 2)
,Parsename(replace(OwnerAddress, ',','.'), 3)
from PortfolioProject..Housing


alter table Housing
Add OwnerSplitState nvarchar(255);

update Housing
set OwnerSplitState  = Parsename(replace(OwnerAddress, ',','.'), 1)


alter table Housing
Add OwnerSplitCity nvarchar(255); 


update Housing
set OwnerSplitCity = parsename(replace(OwnerAddress, ',','.'), 2)


alter table Housing
Add OwnerSplitAddress nvarchar(255); 


update Housing
set OwnerSplitAddress = parsename(replace(OwnerAddress, ',','.'), 3)



-- Changing Y or N in the SoldAsVacant column to Yes and No

select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..Housing
group by SoldAsVacant
order by 2



select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
end
from PortfolioProject..Housing


update Housing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
end



-- Removing Duplicates

With RowNumCTE AS(
Select *,
	ROW_NUMBER() over (
	partition by ParcelId,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order By
					UniqueID
					) row_num
from PortfolioProject..Housing
)

Select *
from RowNumCTE
where row_num > 1
--order by PropertyAddress