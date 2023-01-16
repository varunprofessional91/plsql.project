SELECT *
FROM (SELECT *
      FROM rawData
      WHERE (([Courier Partner] in ('Shadowfax Reverse', 'Delhivery Reverse','EcomExpress Reverse')) and
             (Format(rawData.[created at], "short date") = ([enterDate]) and
              (Format(rawData.[created at], "short time") < ('13:00'))) and
             ((Format(rawData.[pickup date], "short date") > 
               format((DateAdd('d', 4, ([enterDate]))),'dd-mm-yyyy')) and 
               (Format(rawData.[pickup date], "short date")) < (format((DateAdd('d', 20, ([enterDate]))),'dd-mm-yyyy'))
               ) AND
              (rawData.[pickup date] is not null))) AS col6AB;
