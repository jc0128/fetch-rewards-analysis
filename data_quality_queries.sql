
------Testing Data Quality Issues:
------------------------------------
------------------------------------


-------------  DUPLICATION TESTING (Uniqueness)

-- Duplicated users in the USERS table (Have create distinct list)
select 
	"_id_oid" as user_id,
	count("_id_oid") as count_user_ids
	/*TO_TIMESTAMP(createddate_date /1000) as user_created_at_date,
	TO_TIMESTAMP(lastlogin_date/1000) as user_last_login_date,
	role as user_role,
	active as is_active,
	signupsource as signup_source,
	state*/
from users 
--where "_id_oid" = '54943462e4b07e684157a532'
group by user_id
having count("_id_oid")>1
order by count("_id_oid") desc

select 
	receipt_id,
	count(*)
from receipts
group by receipt_id 


select
	name, 
	count(*)
from brands
group by name
having count(*) > 1



--Testing  UNIQUENESS and creating a SKEY for the receipt_items_list table (No duplicates)

select
	receipt_id,
	"partnerItemId" 
from receipt_items_list 
order by receipt_id asc, "partnerItemId"  asc

select 
	distinct (concat("partnerItemId",receipt_id)) as list_id,
	count(concat("partnerItemId",receipt_id))
from receipt_items_list
group by 1
	

	

------------- TEST entries in fields in brands (name and brandcode) Mostly in Baking, Candy and Sweets 
-- There are also some numbers that look like barcodes that don't belong here
select 
	* 
from brands 
where name like '%test%' or brandcode like '%test%' or name is null


-------------  DATE Fields in all the tables are not in the timestamp formats (Have to convert):
select 
	userid,
	createdate_date,
	datescanned_date,
	finisheddate_date,
	modifydate_date,
	pointsawardeddate_date,
	purchasedate_date
from receipts 

select 
	"_id_oid" as user_id,
	createddate_date,
	lastlogin_date
from users 


------------- NULL Values in Fields:
select 
	*
from brands 
where length(category) = 0  or length(categorycode) = 0 or length(name) = 0 or length(brandcode) = 0

--- Having the barcode NULL or not match any of the barcodes from the Brands table is crucial to finding out the brandcode. This is a major data issue.
select 
	barcode,
	"brandCode",
	description,
	receipt_id
from receipt_items_list
where length(barcode) = 0 or length("brandCode") = 0


------------- JOIN TESTING

-- No matching barcodes
select 
	r.barcode,
	b.barcode,
	r."brandCode" 
from receipt_items_list r
left join brands b on r.barcode = b.barcode::varchar
where b.barcode is null

--- No matching brand codes
select  
	r."brandCode",
	b.brandcode,
	r.barcode,
	b.barcode 
from receipt_items_list r
left join brands b on r."brandCode"  = b.brandcode::varchar
where b.brandcode  is null


------------------ Testing transaction spending nuances
select 
	"finalPrice"
from receipt_items_list
where "finalPrice" <0 or "itemPrice" <0

select 
	*
from receipt_items_list
where "quantityPurchased"  <= 0


------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
---- EXTRA NOTES and TESTING:


select * from brands
where topbrand = true


from receipt_items_list 
where length(receipt_items_list."brandCode")!=0 and "brandCode" like '%7%'


select 
distinct REPLACE(UPPER(TRIM(receipt_items_list."brandCode" )), ' ', '')
from receipt_items_list 
where length(receipt_items_list."brandCode")!=0

select
	barcode,
	REPLACE(UPPER(TRIM(brandcode)), ' ', '')
from brands
where length(brandcode)!=0 and REPLACE(UPPER(TRIM(brandcode)), ' ', '') not like 'TEST%' 
and (barcode::varchar) != REPLACE(UPPER(TRIM(brandcode)), ' ', '')
--where topbrand = true --brandcode like '%7%'

-- REPLACE(UPPER(TRIM(t1.brand_name)), ' ', '')
select 
* 
from receipt_items_list left join brands on receipt_items_list.barcode= brands.barcode::varchar 
or ( length(receipt_items_list."brandCode")!=0  and 
REPLACE(UPPER(TRIM(receipt_items_list."brandCode" )), ' ', '') =  REPLACE(UPPER(TRIM(brands.brandcode)), ' ', ''))
--where brands.brandcode like '%7%'



--- Barcode of items in the last 3 months of March off of the receipt scanned date
B07BRRLSVC
B076FJ92M4
B076FJ92M4
B07BRRLSVC
B07BRRLSVC
B076FJ92M4
B076FJ92M4
B07BRRLSVC
B07BRRLSVC
B076FJ92M4
B076FJ92M4
B07BRRLSVC

-- RECEIPT IDS of items in the last 3 months of March off of the receipt scanned date
603d760e0a720fde1000048e
603d5d6c0a7217c72c000463
603d59e70a7217c72c00045f
603d40250a720fde10000459
603d30e60a7217c72c00043f
603d28b60a720fde10000445
603d0b710a720fde1000042a
603cf5290a720fde10000413
603cf2ce0a7217c72c000413
603ce7100a7217c72c000405
603cd57d0a7217c72c0003f6
603cd4570a7217c72c0003f5
603cc2bc0a720fde100003e9
603cc0630a720fde100003e6
603cbbb50a720fde100003e3
603cba880a7217c72c0003e0
603cadab0a720fde100003d6
603cac7d0a7217c72c0003d7
603ca44a0a720fde100003d0
603c9e6e0a720fde100003c7

----- EDA -----
select * from receipt_items_list where receipt_items_list.receipt_id  
in ('603d760e0a720fde1000048e','603d5d6c0a7217c72c000463','603d59e70a7217c72c00045f','603d40250a720fde10000459','603d30e60a7217c72c00043f',
'603d28b60a720fde10000445',
'603d0b710a720fde1000042a',
'603cf5290a720fde10000413'
,'603cf2ce0a7217c72c000413'
,'603ce7100a7217c72c000405'
,'603cd57d0a7217c72c0003f6'
,'603cd4570a7217c72c0003f5'
,'603cc2bc0a720fde100003e9'
,'603cc0630a720fde100003e6'
,'603cbbb50a720fde100003e3'
,'603cba880a7217c72c0003e0'
,'603cadab0a720fde100003d6'
,'603cac7d0a7217c72c0003d7'
,'603ca44a0a720fde100003d0'
,'603c9e6e0a720fde100003c7')