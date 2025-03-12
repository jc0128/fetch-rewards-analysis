

---- Question Querrying ----


--- Answering SQL Questions:
--Which brand has the most spend among users who were created within the past 6 months?
--Which brand has the most transactions among users who were created within the past 6 months?
with users as (
	select 
		distinct
		"_id_oid" as user_id,
		TO_TIMESTAMP(createddate_date /1000) as user_created_at_date,
		TO_TIMESTAMP(lastlogin_date/1000) as user_last_login_date,
		role as user_role,
		active as is_active,
		signupsource as signup_source,
		state
	from users
),
brands as (
	select 
		_id_oid as brand_id,
		name as brand_name,
		barcode,
		cpg_id_oid as cpg_id,
		brandcode as brand_code,
		categorycode as category_code,
		category,
		topbrand as is_top_brand,
		cpg_ref
	from brands 
),
receipts as (
	select 								
		receipt_id,
		rewardsreceiptstatus as receipt_reward_status,
		bonuspointsearnedreason as bonus_points_earned_reason, 
		pointsearned as points_earned,
		bonuspointsearned as bonus_points_earned,
		purchaseditemcount as purchase_item_count, 
		totalspent as total_spent,
		TO_TIMESTAMP(createdate_date/1000) as receipt_created_at_date,
		TO_TIMESTAMP(datescanned_date/1000) as receipt_scanned_date,
		TO_TIMESTAMP(finisheddate_date/1000) as receipt_finished_date,
		TO_TIMESTAMP(modifydate_date/1000) as receipt_modify_date,
		TO_TIMESTAMP(pointsawardeddate_date/1000) as points_awarded_date,
		TO_TIMESTAMP(purchasedate_date/1000) as purchased_date,
		userid as user_id
	from receipts
),
receipt_items_list as (
	select 
		concat("partnerItemId",receipt_id) as list_id,
		receipt_id,
		barcode,
		"partnerItemId" as partner_item_id,
		"userFlaggedBarcode" as user_flagged_barcode,
		"itemNumber" as item_number,
		"pointsPayerId" as points_payer_id,
		"rewardsProductPartnerId" as rewards_product_partner_id,
		"originalMetaBriteBarcode" as original_meta_brite_barcode,
		description,
		"finalPrice" as final_price,
		"originalFinalPrice" as original_final_price,
		"itemPrice" as item_price,
		"discountedItemPrice" as discounted_item_price,
		"targetPrice" as target_price,
		"priceAfterCoupon" as price_after_coupon,
		"pointsEarned" as points_earned, 
		"needsFetchReview" as needs_fetch_review,
		"preventTargetGapPoints" as prevent_target_gap_points,
		"quantityPurchased" as quantity_purchased,
		"userFlaggedNewItem" as user_flagged_new_item,
		"userFlaggedPrice" as user_flagged_price,
		"userFlaggedQuantity" as user_flagged_quantity,
		"userFlaggedDescription" as user_flagged_description,
		"needsFetchReviewReason" as needs_fetch_review_reason,
		"pointsNotAwardedReason" as points_not_awarded_reason,
		"rewardsGroup" as rewards_group,
		"metabriteCampaignId" as meta_brite_campaign_id,
		"originalMetaBriteDescription" as original_meta_brite_description,
		"originalMetaBriteQuantityPurchased" as original_meta_brite_quantity_purchased,
		"originalMetaBriteItemPrice" as original_meta_brite_price,
		case 
			when length("brandCode") = 0 then null  -- Assigning empty values as nulls
			else "brandCode" 
		end as brand_code,
		"competitorRewardsGroup" as competitor_rewards_group,
		"originalReceiptItemText" as original_receipt_item_text,
		"competitiveProduct" as is_competitive_product,
		deleted
	from receipt_items_list
),
receipt_item_list_full as (
	select 
		irl.list_id, -- SKEY should be unique (A test so we do not get duplicated records)
		irl.receipt_id, -- FK
		coalesce(irl.brand_code,b.brand_name) as brand_code, -- Coalescing the Brancode and Brand name incase of NULL's
		r.receipt_scanned_date,
		irl.barcode,
		b.barcode,
		irl.final_price,
		irl.quantity_purchased,
		round(cast((irl.final_price * irl.quantity_purchased) as numeric),2) as total_final_price,
		u.user_id,
		u.user_created_at_date
	from receipt_items_list as irl 
	left join receipts as r on irl.receipt_id = r.receipt_id
	left join brands as b on irl.barcode = b.barcode::varchar -- Casting barcode from brands as Varchar for the join
	left join users as u on r.user_id = u.user_id
	--where u.user_created_at_date >= CURRENT_DATE - INTERVAL '6 months' THIS SHOWS NO RECORDS 
	where u.user_created_at_date >= '2021-03-01 16:17:34.000-07'::timestamp with time zone - INTERVAL '6 months' -- Hard Coded date assuming that the current month is March 2021 with Historical data
),
final as (
	select 
		brand_code as brand,
		sum(total_final_price) as total_spend,
		count(distinct receipt_id) as total_transactions -- each transaction is everytime a item is purchased on a receipt and has a reciept_id. 2 items purchesed on the same receipt are considerted 1 transaction.
	from receipt_item_list_full
	--where u.user_created_at_date >= CURRENT_DATE - INTERVAL '6 months' THIS SHOWS NO RECORDS 
	where user_created_at_date >= '2021-03-01 16:17:34.000-07'::timestamp with time zone - INTERVAL '6 months' -- Hard Coded date assuming that the current month is March 2021 with Historical data
	group by brand_code
	order by total_spend DESC
)
select * from final





