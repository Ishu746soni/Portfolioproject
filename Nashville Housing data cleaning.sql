select*from portfolioproject.dbo.NashvilleHousing

--standardised date format
select saledate, convert(date,SaleDate) as date from portfolioproject.dbo.NashvilleHousing

   --update portfolioproject.dbo.NashvilleHousing set saledate = convert(date,SaleDate)   (this doesnot work.so we use the below command)
   --select*from portfolioproject.dbo.NashvilleHousing

alter table portfolioproject.dbo.NashvilleHousing add saleconverteddate date
update portfolioproject.dbo.NashvilleHousing set saleconverteddate = convert(date,SaleDate)
select saleconverteddate from portfolioproject.dbo.NashvilleHousing


--populate property address data
select a.ParcelID,a.PropertyAddress, b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from portfolioproject.dbo.NashvilleHousing as a join portfolioproject.dbo.NashvilleHousing as b
on a.ParcelID = b.ParcelID and a.uniqueID != b.uniqueID
where a.PropertyAddress is null

update a set propertyaddress = isnull(a.PropertyAddress,b.PropertyAddress)
from portfolioproject.dbo.NashvilleHousing as a join portfolioproject.dbo.NashvilleHousing as b
on a.ParcelID = b.ParcelID and a.uniqueID != b.uniqueID
where a.PropertyAddress is null


--breaking out address into individuals
select substring(propertyaddress,1,charindex(',',propertyaddress) -1) as address,
       substring(propertyaddress,charindex(',',propertyaddress) +1,len(propertyaddress)) as address
from portfolioproject.dbo.NashvilleHousing
    
	--if we want to add these above colomns into the table then we the use the alter and the update command 
alter table portfolioproject.dbo.NashvilleHousing add propertysplitaddress varchar(255)

update portfolioproject.dbo.NashvilleHousing 
set propertysplitaddress = substring(propertyaddress,1,charindex(',',propertyaddress) -1) 

alter table portfolioproject.dbo.NashvilleHousing add propertysplitcity varchar(255)

update portfolioproject.dbo.NashvilleHousing 
set propertysplitcity = substring(propertyaddress,charindex(',',propertyaddress) +1,len(propertyaddress))
	

     --another method(parsename)
select
parsename(replace(owneraddress,',','.'),3),
parsename(replace(owneraddress,',','.'),2),
parsename(replace(owneraddress,',','.'),1)
from portfolioproject.dbo.NashvilleHousing

alter table portfolioproject.dbo.NashvilleHousing add ownersplitaddress varchar(255)

update portfolioproject.dbo.NashvilleHousing 
set ownersplitaddress = parsename(replace(owneraddress,',','.'),3)

alter table portfolioproject.dbo.NashvilleHousing add ownersplitcity varchar(255)

update portfolioproject.dbo.NashvilleHousing 
set ownersplitcity = parsename(replace(owneraddress,',','.'),2)

alter table portfolioproject.dbo.NashvilleHousing add ownersplitstate varchar(255)

update portfolioproject.dbo.NashvilleHousing 
set ownersplitstate = parsename(replace(owneraddress,',','.'),1)


--changing yes,no to y,n
select SoldAsVacant,count(SoldAsVacant) from portfolioproject.dbo.NashvilleHousing group by SoldAsVacant order by SoldAsVacant

select SoldAsVacant,
     case when SoldAsVacant='y' then 'yes'
	      when SoldAsVacant='n' then 'no'
		  else SoldAsVacant
		  end from portfolioproject.dbo.NashvilleHousing

update portfolioproject.dbo.NashvilleHousing 
set SoldAsVacant =
     case when SoldAsVacant='y' then 'yes'
	      when SoldAsVacant='n' then 'no'
		  else SoldAsVacant
		  end from portfolioproject.dbo.NashvilleHousing


--deleting coloumns
alter table portfolioproject.dbo.NashvilleHousing drop column owneraddress,taxdistrict,propertyaddress
