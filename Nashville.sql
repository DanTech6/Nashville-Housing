--open table
select *
from PortfolioProjects.dbo.nashvilleQueries

--standardise date format
select saledate,CONVERT(date,saledate)
from PortfolioProjects.dbo.nashvilleQueries


Alter table nashvillequeries
add salesdateconverted date;

update nashvillequeries
set salesdateconverted = CONVERT(date,saledate)

--populate property address
select *
from PortfolioProjects.dbo.nashvilleQueries
--where propertyaddress is null
order by parcelid

select fir.parcelid,fir.propertyaddress,sec.parcelid,sec.propertyaddress,ISNULL(fir.propertyaddress,sec.propertyaddress)
from PortfolioProjects.dbo.nashvilleQueries fir
join PortfolioProjects.dbo.nashvilleQueries sec
	on fir.parcelid = sec.parcelid 
	and fir.uniqueid <> sec.uniqueid
where fir.propertyaddress is null

update fir
set propertyaddress = ISNULL(fir.propertyaddress,sec.propertyaddress)
from PortfolioProjects.dbo.nashvilleQueries fir
join PortfolioProjects.dbo.nashvilleQueries sec
	on fir.parcelid = sec.parcelid 
	and fir.uniqueid <> sec.uniqueid
where fir.propertyaddress is null

--breaking address into individual columns
select propertyaddress
from PortfolioProjects.dbo.nashvilleQueries
--where propertyaddress is null
--order by parcelid
select 
SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1)as Address,
SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress))as city
from PortfolioProjects.dbo.nashvilleQueries

Alter table nashvillequeries
add propertysplitaddress nvarchar(255);

update nashvillequeries
set propertysplitaddress = SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1)

Alter table nashvillequeries
add propertysplitcity nvarchar(255);

update nashvillequeries
set propertysplitcity =SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress))

select *
from PortfolioProjects.dbo.nashvilleQueries

select owneraddress
from PortfolioProjects.dbo.nashvilleQueries

select
PARSENAME(replace(owneraddress,',','.'),3) Address
,PARSENAME(replace(owneraddress,',','.'),2) City
,PARSENAME(replace(owneraddress,',','.'),1) State
from PortfolioProjects.dbo.nashvilleQueries


Alter table nashvillequeries
add ownersplitadress nvarchar(255);

update nashvillequeries
set ownersplitadress =PARSENAME(replace(owneraddress,',','.'),3)

Alter table nashvillequeries
add ownersplitcity nvarchar(255);

update nashvillequeries
set ownersplitcity =PARSENAME(replace(owneraddress,',','.'),2)

Alter table nashvillequeries
add ownersplitstate nvarchar(255);

update nashvillequeries
set ownersplitstate =PARSENAME(replace(owneraddress,',','.'),1)


alter table PortfolioProjects.dbo.nashvilleQueries
drop column owneraddressstate

--change Y & N to Yes & No

select distinct(soldasvacant),COUNT(soldasvacant)
from PortfolioProjects.dbo.nashvilleQueries
group by soldasvacant
order by 2

select soldasvacant
, case when soldasvacant = 'Y' THEN 'Yes'
	 when soldasvacant = 'N' THEN 'No' 
	 ELSE soldasvacant
	 END
from PortfolioProjects.dbo.nashvilleQueries

Alter table nashvillequeries
add ownersplitstate nvarchar(255);

update nashvillequeries
set soldasvacant =case when soldasvacant = 'Y' THEN 'Yes'
	 when soldasvacant = 'N' THEN 'No' 
	 ELSE soldasvacant
	 END

select distinct(soldasvacant),COUNT(soldasvacant)
from PortfolioProjects.dbo.nashvilleQueries
group by soldasvacant
order by 2

select *
from PortfolioProjects.dbo.nashvilleQueries

--remove duplicates
with rownumcte as(
select *,
	row_number()over (
	partition by parcelid,
				propertyaddress,
				saleprice,
				saledate,
				legalreference
				order by
					uniqueid
					)row_num
			
from PortfolioProjects.dbo.nashvilleQueries
--order by parcelid
)
select *
from rownumcte
where row_num > 1
--order by propertyaddress

--delete unused columns



alter table PortfolioProjects.dbo.nashvilleQueries
drop column owneraddress, taxdistrict,propertyaddress

alter table PortfolioProjects.dbo.nashvilleQueries
drop column saledate

select *
from PortfolioProjects.dbo.nashvilleQueries