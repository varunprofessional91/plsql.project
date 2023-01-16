SELECT ([Enter_Date])                                                        AS Dated,
       col1.Total                                                            AS Total,
       col2.SameDay                                                          AS SameDay,
       (col3.Day_1st + col3A.Day_1stA)                                       AS Day1st,
       (col4.Day_2nd + col4A.Day_2ndA)                                       AS Day2nd,
       (col5.Day_3rd + col5A.Day_3rdA)                                       AS Day3rd,
       (col6.Day_4th + col6A.Day_4thA + col6AA.Day_4thAA + col6AB.Day_4thAB) AS Day4th,
       col7.PickUpFailed                                                     AS PickUpFailed,
       col8.Cancelled                                                        AS Cancelled,
       col9.OutForPickUp                                                     AS OutForPickUp,
       col10.OrderPlaced                                                     AS OrderPlaced,
       col11.PickUpPending                                                   AS PickUpPending,
       (str(col3A.Day_1stA) + '|' +
        str(col4A.Day_2ndA) + '|' +
        str(col5A.Day_3rdA) + '|' +
        str(col6A.Day_4thA + col6AB.Day_4thAB))                              AS SameDayExpected,
       col12.Intransit                                                       AS Intransit,
       col13.Delivered                                                       AS Delivered,
       Round(((SameDay * 100) / Total), 2)                                   AS SameDayPer,
       Round(((Day1st * 100) / Total), 2)                                    AS Day1stPer,
       Round(((Day2nd * 100) / Total), 2)                                    AS Day2ndPer,
       Round(((Day3rd * 100) / Total), 2)                                    AS Day3rdPer,
       Round(((Day4th * 100) / Total), 2)                                    AS Day4thPlus,
       col17.Shadowfax                                                       AS Shadowfax,
       col18.Delhivery                                                       AS Delhivery,
       col19.EcomExpress                                                     AS Ecomexpress
FROM (SELECT Count(rawData.[Courier Partner]) AS Total
      FROM rawData
      WHERE (([Courier Partner] in ('Shadowfax Reverse', 'Delhivery Reverse','EcomExpress Reverse')) and
             (Format(rawData.[created at], 'short date') = ([Enter_Date])))) AS col1,
     (SELECT Count(rawData.[Courier Partner]) AS SameDay
      FROM rawData
      WHERE (([Courier Partner] in ('Shadowfax Reverse', 'Delhivery Reverse','EcomExpress Reverse')) and
             (rawData.[Clickpost Unified Status] not in ('cancelled', 'pickupFailed', 'pickupPending', 'outForPickup', 'orderplaced')) and
             (Format(rawData.[created at], 'short date') = ([Enter_Date]) and
              Format(rawData.[pickup date], 'short date') = ([Enter_Date])) and
             (Format(rawData.[created at], 'short time') < ('13:00') and
              Format(rawData.[pickup date], 'short time') < ('13:00')))) AS col2,
     (SELECT Count(rawData.[Courier Partner]) AS Day_1st
      FROM rawData
      WHERE (([Courier Partner] in ('Shadowfax Reverse', 'Delhivery Reverse','EcomExpress Reverse')) and
             (rawData.[Clickpost Unified Status] not in ('cancelled', 'pickupFailed', 'pickupPending', 'outForPickup', 'orderplaced')) and
             (Format(rawData.[created at], 'short date') = ([Enter_Date]) and
              Format(rawData.[created at], 'short time') > ('12:59')) and
             ((Format(rawData.[pickup date], 'short date') = ([Enter_Date]) and
               Format(rawData.[created at], 'short time') > ('12:59')) or
              (Format(rawData.[pickup date], 'short date') = (DateAdd('d', 1, ([Enter_Date]))) and
               Format(rawData.[pickup date], 'short time') < ('13:00'))))) AS col3,
     (SELECT Count(rawData.[Courier Partner]) AS Day_1stA
      FROM rawData
      WHERE (([Courier Partner] in ('Shadowfax Reverse', 'Delhivery Reverse','EcomExpress Reverse')) and
             (rawData.[Clickpost Unified Status] not in ('cancelled', 'pickupFailed', 'pickupPending', 'outForPickup', 'orderplaced')) and
             (Format(rawData.[created at], 'short date') = ([Enter_Date]) and
              (Format(rawData.[created at], 'short time') < ('12:59'))) and
             ((Format(rawData.[pickup date], 'short date') = ([Enter_Date]) and
               Format(rawData.[pickup date], 'short time') > ('12:59')) or
              (Format(rawData.[pickup date], 'short date') = (DateAdd('d', 1, ([Enter_Date]))) and
               Format(rawData.[pickup date], 'short time') < ('13:00'))))) AS col3A,
     (SELECT Count(rawData.[Courier Partner]) AS Day_2nd
      FROM rawData
      WHERE (([Courier Partner] in ('Shadowfax Reverse', 'Delhivery Reverse','EcomExpress Reverse')) and
             (rawData.[Clickpost Unified Status] not in ('cancelled', 'pickupFailed', 'pickupPending', 'outForPickup', 'orderplaced')) and
             (Format(rawData.[created at], 'short date') = ([Enter_Date]) and
              (Format(rawData.[created at], 'short time') > ('12:59'))) and
             ((Format(rawData.[pickup date], 'short date') = (DateAdd('d', 1, ([Enter_Date]))) and
               Format(rawData.[pickup date], 'short time') > ('12:59')) or
              (Format(rawData.[pickup date], 'short date') = (DateAdd('d', 2, ([Enter_Date]))) and
               Format(rawData.[pickup date], 'short time') < ('13:00'))))) AS col4,
     (SELECT Count(rawData.[Courier Partner]) AS Day_2ndA
      FROM rawData
      WHERE (([Courier Partner] in ('Shadowfax Reverse', 'Delhivery Reverse','EcomExpress Reverse')) and
             (rawData.[Clickpost Unified Status] not in ('cancelled', 'pickupFailed', 'pickupPending', 'outForPickup', 'orderplaced')) and
             (Format(rawData.[created at], 'short date') = ([Enter_Date]) and
              (Format(rawData.[created at], 'short time') < ('12:59'))) and
             ((Format(rawData.[pickup date], 'short date') = (DateAdd('d', 1, ([Enter_Date]))) and
               Format(rawData.[pickup date], 'short time') > ('12:59')) or
              (Format(rawData.[pickup date], 'short date') = (DateAdd('d', 2, ([Enter_Date]))) and
               Format(rawData.[pickup date], 'short time') < ('13:00'))))) AS col4A,
     (SELECT Count(rawData.[Courier Partner]) AS Day_3rd
      FROM rawData
      WHERE (([Courier Partner] in ('Shadowfax Reverse', 'Delhivery Reverse','EcomExpress Reverse')) and
             (rawData.[Clickpost Unified Status] not in ('cancelled', 'pickupFailed', 'pickupPending', 'outForPickup', 'orderplaced')) and
             (Format(rawData.[created at], 'short date') = ([Enter_Date]) and
              (Format(rawData.[created at], 'short time') > ('12:59'))) and
             ((Format(rawData.[pickup date], 'short date') = (DateAdd('d', 2, ([Enter_Date]))) and
               Format(rawData.[pickup date], 'short time') > ('12:59')) or
              (Format(rawData.[pickup date], 'short date') = (DateAdd('d', 3, ([Enter_Date]))) and
               Format(rawData.[pickup date], 'short time') < ('13:00'))))) AS col5,
     (SELECT Count(rawData.[Courier Partner]) AS Day_3rdA
      FROM rawData
      WHERE (([Courier Partner] in ('Shadowfax Reverse', 'Delhivery Reverse','EcomExpress Reverse')) and
             (rawData.[Clickpost Unified Status] not in ('cancelled', 'pickupFailed', 'pickupPending', 'outForPickup', 'orderplaced')) and
             (Format(rawData.[created at], 'short date') = ([Enter_Date]) and
              (Format(rawData.[created at], 'short time') < ('12:59'))) and
             ((Format(rawData.[pickup date], 'short date') = (DateAdd('d', 2, ([Enter_Date]))) and
               Format(rawData.[pickup date], 'short time') > ('12:59')) or
              (Format(rawData.[pickup date], 'short date') = (DateAdd('d', 3, ([Enter_Date]))) and
               Format(rawData.[pickup date], 'short time') < ('13:00'))))) AS col5A,
     (SELECT Count(rawData.[Courier Partner]) AS Day_4th
      FROM rawData
      WHERE (([Courier Partner] in ('Shadowfax Reverse', 'Delhivery Reverse','EcomExpress Reverse')) and
             (rawData.[Clickpost Unified Status] not in ('cancelled', 'pickupFailed', 'pickupPending', 'outForPickup', 'orderplaced')) and
             (Format(rawData.[created at], 'short date') = ([Enter_Date]) and
              (Format(rawData.[created at], 'short time') > ('12:59'))) and
             (Format(rawData.[pickup date], 'short date') = (DateAdd('d', 3, ([Enter_Date]))) and
              Format(rawData.[pickup date], 'short time') > ('12:59') and
              (rawData.[pickup date] is not null)))) AS col6,
     (SELECT Count(rawData.[Courier Partner]) AS Day_4thA
      FROM rawData
      WHERE (([Courier Partner] in ('Shadowfax Reverse', 'Delhivery Reverse','EcomExpress Reverse')) and
             (rawData.[Clickpost Unified Status] not in ('cancelled', 'pickupFailed', 'pickupPending', 'outForPickup', 'orderplaced')) and
             (Format(rawData.[created at], 'short date') = ([Enter_Date]) and
              (Format(rawData.[created at], 'short time') < ('13:00'))) and
             (Format(rawData.[pickup date], 'short date') = (DateAdd('d', 3, ([Enter_Date]))) and
              (Format(rawData.[pickup date], 'short time') > ('12:59')) and
              (rawData.[pickup date] is not null)))) AS col6A,
     (SELECT Count(rawData.[Courier Partner]) AS Day_4thAA
      FROM rawData
      WHERE (([Courier Partner] in ('Shadowfax Reverse', 'Delhivery Reverse','EcomExpress Reverse')) and
             (rawData.[Clickpost Unified Status] not in ('cancelled', 'pickupFailed', 'pickupPending', 'outForPickup', 'orderplaced')) and
             (Format(rawData.[created at], 'short date') = ([Enter_Date]) and
              (Format(rawData.[created at], 'short time') > ('12:59'))) and
             (Format(rawData.[pickup date], 'short date') >= (DateAdd('d', 4, ([Enter_Date]))) and
              Format(rawData.[pickup date], 'short date') < (DateAdd('d', 45, ([Enter_Date]))) and
              (rawData.[pickup date] is not null)))) AS col6AA,
     (SELECT Count(rawData.[Courier Partner]) AS Day_4thAB
      FROM rawData
      WHERE (([Courier Partner] in ('Shadowfax Reverse', 'Delhivery Reverse','EcomExpress Reverse')) and
             (rawData.[Clickpost Unified Status] not in ('cancelled', 'pickupFailed', 'pickupPending', 'outForPickup', 'orderplaced')) and
             (Format(rawData.[created at], 'short date') = ([Enter_Date]) and
              (Format(rawData.[created at], 'short time') < ('13:00'))) and
             (Format(rawData.[pickup date], 'short date') >= (DateAdd('d', 4, ([Enter_Date]))) and
              Format(rawData.[pickup date], 'short date') < (DateAdd('d', 45, ([Enter_Date]))) and
              (rawData.[pickup date] is not null)))) AS col6AB,
     (SELECT Count(rawData.[Courier Partner]) AS PickUpFailed
      FROM rawData
      WHERE (([Courier Partner] in ('Shadowfax Reverse', 'Delhivery Reverse','EcomExpress Reverse')) and
             (Format(rawData.[created at], 'short date') = ([Enter_Date]) and
              (rawData.[Clickpost Unified Status]='PickupFailed')))) AS col7,
     (SELECT Count(rawData.[Courier Partner]) AS Cancelled
      FROM rawData
      WHERE (([Courier Partner] in ('Shadowfax Reverse', 'Delhivery Reverse','EcomExpress Reverse')) and
             (Format(rawData.[created at], 'short date') = ([Enter_Date]) and
              (rawData.[Clickpost Unified Status]='Cancelled')))) AS col8,
     (SELECT Count(rawData.[Courier Partner]) AS OutForPickUp
      FROM rawData
      WHERE (([Courier Partner] in ('Shadowfax Reverse', 'Delhivery Reverse','EcomExpress Reverse')) and
             (Format(rawData.[created at], 'short date') = ([Enter_Date]) and
              (rawData.[Clickpost Unified Status]='OutForPickUp')))) AS col9,
     (SELECT Count(rawData.[Courier Partner]) AS OrderPlaced
      FROM rawData
      WHERE (([Courier Partner] in ('Shadowfax Reverse', 'Delhivery Reverse','EcomExpress Reverse')) and
             (Format(rawData.[created at], 'short date') = ([Enter_Date]) and
              (rawData.[Clickpost Unified Status]='OrderPlaced')))) AS col10,
     (SELECT Count(rawData.[Courier Partner]) AS PickUpPending
      FROM rawData
      WHERE (([Courier Partner] in ('Shadowfax Reverse', 'Delhivery Reverse','EcomExpress Reverse')) and
             (Format(rawData.[created at], 'short date') = ([Enter_Date]) and
              (rawData.[Clickpost Unified Status]='PickUpPending')))) AS col11,
     (SELECT Count(rawData.[Courier Partner]) AS Intransit
      FROM rawData
      WHERE (([Courier Partner] in ('Shadowfax Reverse', 'Delhivery Reverse','EcomExpress Reverse')) and
             (Format(rawData.[created at], 'short date') = ([Enter_Date]) and
              (rawData.[Clickpost Unified Status]='Intransit')))) AS col12,
     (SELECT Count(rawData.[Courier Partner]) AS Delivered
      FROM rawData
      WHERE (([Courier Partner] in ('Shadowfax Reverse', 'Delhivery Reverse','EcomExpress Reverse')) and
             (Format(rawData.[created at], 'short date') = ([Enter_Date]) and
              (rawData.[Clickpost Unified Status]='Delivered')))) AS col13,
     (SELECT Count(rawData.[Courier Partner]) AS Shadowfax
      FROM rawData
      WHERE ((Format(rawData.[created at], 'short date') = ([Enter_Date]) and
              (rawData.[Courier Partner]='Shadowfax Reverse')))) AS col17,
     (SELECT Count(rawData.[Courier Partner]) AS Delhivery
      FROM rawData
      WHERE ((Format(rawData.[created at], 'short date') = ([Enter_Date]) and
              (rawData.[Courier Partner]='Delhivery Reverse')))) AS col18,
     (SELECT Count(rawData.[Courier Partner]) AS EcomExpress
      FROM rawData
      WHERE ((Format(rawData.[created at], 'short date') = ([Enter_Date]) and
              (rawData.[Courier Partner]='EcomExpress Reverse')))) AS col19;
