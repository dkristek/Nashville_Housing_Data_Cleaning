# Nashville_Housing_Data_Cleaning
## Overview
A dataset of Nashville housing information was collected from (link here) was cleaned in SQL to make it usable for data analysis.


### Cleaning
The cleaning started with filling in null property address values. Properties appear multiple times throughout the dataset. So the property address was taken from an entry where it was available and copied to entries with a null property address value. The code snippet below was used to accomplish this:
```
UPDATE "Nashville Housing" A
  SET propertyaddress = B.propertyaddress
FROM "Nashville Housing" B 
WHERE A.uniqueid <> B.uniqueid
  AND A.parcelid = B.parcelid
  AND A.propertyaddress IS NULL;
```

The next step in the cleaning was to separate each address (both the property and the owner) into its constituent parts; (street) address, city, and state
