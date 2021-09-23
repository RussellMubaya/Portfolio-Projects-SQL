
--Cleaning Data in SQL Queries

Select *
From [Portfolio Project]..NashvilleHousing


--Standard Data Format( Removing the zeros at the end of the date)
--To see the zeroo, replace SaleDateConverted with SaleDate in the follwing Select instruction.

Select SaleDateConverted, CONVERT(Date,SaleDate)
From [Portfolio Project]..NashvilleHousing

Update NashvilleHousing
Set SaleDate = Convert(Date,SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = CONVERT(Date,SaleDate)



--Populate Property Address Data


Select *
From [Portfolio Project]..NashvilleHousing
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project]..NashvilleHousing a
Join [Portfolio Project]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project]..NashvilleHousing a
Join [Portfolio Project]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out Address into individual columns(address, city state)

Select PropertyAddress
From [Portfolio Project]..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address
From [Portfolio Project]..NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255)

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


Select *
From [Portfolio Project]..NashvilleHousing




--Separating the owner address without utilizing Substrings


Select OwnerAddress
From [Portfolio Project]..NashvilleHousing


Select 
PARSENAME(Replace(OwnerAddress, ',', '.') ,3)
,PARSENAME(Replace(OwnerAddress, ',', '.') ,2)
,PARSENAME(Replace(OwnerAddress, ',', '.') ,1)
From [Portfolio Project]..NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.') ,3)

Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255)

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.') ,2)

Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255)

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.') ,1)

Select *
From [Portfolio Project]..NashvilleHousing


--Changing Y and N to Yes and No in " Sold as Vacant" field

Select Distinct(SoldASVacant), Count(SoldAsVacant)
From [Portfolio Project]..NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, Case when SoldAsVacant = 'Y' Then 'Yes'
	   when SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End
From [Portfolio Project]..NashvilleHousing


Update NashvilleHousing
Set SoldAsVacant = Case when SoldAsVacant = 'Y' Then 'Yes'
	   when SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End


--Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() Over (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by 
					UniqueID
					) row_num
From [Portfolio Project]..NashvilleHousing
--order by ParcelID
)
Delete
From RowNumCTE
Where row_num > 1
--order by PropertyAddress




--Delete Unused Columns


Select*
From [Portfolio Project]..NashvilleHousing

Alter Table NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate



