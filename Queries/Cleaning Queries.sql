--Checking if data imported correctly
SELECT *
FROM "Nashville Housing";

--Filling in null PropertyAddress values 
-- Property Address won't change overtime so will use ParcelID to grab address when it exists
-- and fill it in when its null
SELECT *
FROM "Nashville Housing"
ORDER BY parcelid;


SELECT a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, COALESCE(a.propertyaddress, b.propertyaddress)
FROM "Nashville Housing" a
JOIN "Nashville Housing" b 
	ON  a.parcelid=b.parcelid
	AND a.uniqueid <> b.uniqueid
WHERE a.propertyaddress IS NULL;


-- now updating the property address
UPDATE "Nashville Housing" A
  SET propertyaddress = B.propertyaddress
FROM "Nashville Housing" B 
WHERE A.uniqueid <> B.uniqueid
  AND A.parcelid = B.parcelid
  AND A.propertyaddress IS NULL;


--now that we've populated the null addresses
-- want to separate address into separate components (address city state)
SELECT propertyaddress
FROM "Nashville Housing";

SELECT 
SUBSTRING(PropertyAddress, 1, strpos(PropertyAddress, ',') -1 ) AS Address,
SUBSTRING(PropertyAddress, STRPOS(PropertyAddress, ',')+1, LENGTH(PropertyAddress) )AS City
FROM "Nashville Housing";


ALTER TABLE "Nashville Housing"
ADD PropertySplitAddress varchar(255);

UPDATE "Nashville Housing"
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, strpos(PropertyAddress, ',') -1 );


ALTER TABLE "Nashville Housing"
ADD PropertySplitCity varchar(255);

UPDATE "Nashville Housing"
SET PropertySplitCity = SUBSTRING(PropertyAddress, STRPOS(PropertyAddress, ',')+1, LENGTH(PropertyAddress) );

SELECT
SPLIT_PART(OwnerAddress, ',', 1),
SPLIT_PART(OwnerAddress, ',', 2),
SPLIT_PART(OwnerAddress, ',', 3)
FROM "Nashville Housing";

ALTER TABLE "Nashville Housing"
ADD OwnerSplitAddress varchar(255);

UPDATE "Nashville Housing"
SET OwnerSplitAddress = SPLIT_PART(OwnerAddress, ',', 1);



ALTER TABLE "Nashville Housing"
ADD OwnerSplitCity varchar(255);

UPDATE "Nashville Housing"
SET OwnerSplitCity = SPLIT_PART(OwnerAddress, ',', 2);



ALTER TABLE "Nashville Housing"
ADD OwnerSplitState varchar(255);

UPDATE"Nashville Housing"
SET OwnerSplitState = SPLIT_PART(OwnerAddress, ',', 3);

SELECT *
FROM "Nashville Housing";


--Change Y and N in soldasvacant column to yes and no
SELECT DISTINCT(soldasvacant), COUNT(soldasvacant)
FROM "Nashville Housing"
GROUP BY soldasvacant
ORDER BY count DESC;

SELECT soldasvacant,
CASE WHEN soldasvacant = 'Y' THEN 'Yes'
	 WHEN soldasvacant = 'N' THEN 'No'
	 ELSE soldasvacant
	 END
FROM "Nashville Housing";

UPDATE "Nashville Housing"
SET soldasvacant = CASE WHEN soldasvacant = 'Y' THEN 'Yes'
	 WHEN soldasvacant = 'N' THEN 'No'
	 ELSE soldasvacant
	 END;
	 
SELECT * 
FROM "Nashville Housing";

-- Remove Duplicates
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM "Nashville Housing"
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress;



SELECT *
FROM "Nashville Housing";

-- Dropping unused columns
SELECT *
FROM "Nashville Housing";


ALTER TABLE "Nashville Housing"
DROP COLUMN owneraddress,
DROP COLUMN taxdistrict, 
DROP COLUMN propertyaddress,
DROP COLUMN saledate;