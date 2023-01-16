SELECT ([Enter_Date]) AS Dated ,
         col1.Total AS Total ,
         col2.SameDay AS SameDay ,
         (col3.Day_1st + col3A.Day_1stA) AS Day1st ,
         (col4.Day_2nd + col4A.Day_2ndA) AS Day2nd ,
         (col5.Day_3rd + col5A.Day_3rdA) AS Day3rd ,
         (col6.Day_4th + col6A.Day_4thA + col6AA.Day_4thAA + col6AB.Day_4thAB) AS Day4th ,
         col7.PickUpFailed AS PickUpFailed ,
         col8.Cancelled AS Cancelled ,
         col9.OutForPickUp AS OutForPickUp ,
         col10.OrderPlaced AS OrderPlaced ,
         col11.PickUpPending AS PickUpPending ,
         (str(col3A.Day_1stA) + '|' + str(col4A.Day_2ndA) + '|' + str(col5A.Day_3rdA) + '|' + str(col6A.Day_4thA + col6AB.Day_4thAB)) AS SameDayExpected col12.INTransit AS COMMENT undefined ,
        SELECT COUNT(rawData.[Courier COMMENT undefined ,
        
WHERE (([Courier COMMENT undefinedSELECT COUNT(rawData.[Courier Partner]) AS Delivered
FROM rawData
WHERE (([Courier Partner] IN ('Shadowfax Reverse', 'Delhivery Reverse','EcomExpress Reverse'))
        AND (Format(rawData.[created at], "short date") = ([Enter_Date])
        AND (rawData.[Clickpost Unified Status]="Delivered")))) AS col13, 
    (SELECT COUNT(rawData.[Courier Partner]) AS Shadowfax
    FROM rawData
    WHERE ((Format(rawData.[created at], "short date") = ([Enter_Date])
            AND (rawData.[Courier Partner]="Shadowfax Reverse")))) AS col17, 
        (SELECT COUNT(rawData.[Courier Partner]) AS Delhivery
        FROM rawData
        WHERE ((Format(rawData.[created at], "short date") = ([Enter_Date])
                AND (rawData.[Courier Partner]="Delhivery Reverse")))) AS col18, 
            (SELECT COUNT(rawData.[Courier Partner]) AS EcomExpress
            FROM rawData
            WHERE ((Format(rawData.[created at], "short date") = ([Enter_Date])
                    AND (rawData.[Courier Partner]="EcomExpress Reverse")))) AS col19; 