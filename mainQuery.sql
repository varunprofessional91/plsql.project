create or replace directory FILE_ADDRESS as 'C:\xampp\htdocs\my\oracleProject\';
grant read on directory FILE_ADDRESS to public;

declare
    startDate          string(10) := : startDate;
    endDate            string(10) := : endDate;
    dateDifference     number(3);
    total              number(3);
    sameDay            number(3);
    day1st             number(3);
    day1stA            number(3);
    day2nd             number(3);
    day2ndA            number(3);
    day3rd             number(3);
    day3rdA            number(3);
    day4th1            number(3);
    day4th2            number(3);
    day4thA1           number(3);
    day4thA2           number(3);
    PickupFailed       number(3);
    Cancelled          number(3);
    OutForPickup       number(3);
    OrderPlaced        number(3);
    PickupPending      number(3);
    inTransit          number(3);
    delivered          number(3);
    orderError         number(3);
    sameDayExpected    varchar(20);
    daySamePercent     float(10);
    day1stPercent      float(10);
    day2ndPercent      float(10);
    day3rdPercent      float(10);
    day4thPercent      float(10);
    shadowFaxReverse   number(3);
    ecomExpressReverse number(3);
    delhiVeryReverse   number(3);
    out_File           utl_file.file_type;

begin

    out_File := utl_file.fopen('FILE_ADDRESS', 'mainFile.csv', 'w');

    utl_file.put_line(
            out_file,
            'Dated' || ',' || 'TotalOrd' || ',' || 'SameDay' || ',' || '1stDay' || ',' || '2ndDay' || ',' || '3rdDay' ||
            ',' || '4thDay' || ',' || 'PickupFailed' || ',' || 'canceled' || ',' || 'OutForPickup' || ',' ||
            'OrderPlaced' || ',' || 'pickupending' || ',' || 'orderError' || ',' || 'sameDayExp' || ',' ||
            'intransit' || ',' || 'Delivered' || ',' || 'SameDay%' || ',' || '1stDay%' || ',' || '2ndDay%' || ',' ||
            '3rdDay%' || ',' || '4thDay%' || ',' || 'shadowFax' || ',' || 'ecomExpress' || ',' || 'delhiVery'
        );

    dbms_output.put_line(
                lpad('Dated', 10, ' ') || '|' || lpad('Total', 5, ' ') || '|' || lpad('SameDay', 7, ' ') || '|' ||
                lpad('1stDay', 6, ' ') || '|' || lpad('2ndDay', 6, ' ') || '|' || lpad('3rdDay', 6, ' ') || '|' ||
                lpad('4thDay', 6, ' ') || '|' || lpad('PickupFailed', 12, ' ') || '|' || lpad('Cancelled', 9, ' ') ||
                '|' || lpad('OutForPickup', 12, ' ') || '|' || lpad('OrderPlaced', 11, ' ') || '|' ||
                lpad('PickupPending', 13, ' ') || '|' || lpad('OrderError', 10, ' ') || '|' ||
                lpad('SameDayExpected', 15, ' ') || '|' || lpad('InTransit', 9, ' ') || '|' ||
                lpad('Delivered', 9, ' ') || '|' || lpad('1stDay%', 7, ' ') || '|' || lpad('2ndDay%', 7, ' ') || '|' ||
                lpad('3rdDay%', 7, ' ') || '|' || lpad('4thDay%', 7, ' ') || '|' || lpad('shadowFax', 9, ' ') || '|' ||
                lpad('ecomExpress', 11, ' ') || '|' || lpad('delhiVery', 9, ' ')
        );

    dateDifference := ((to_date(endDate, 'dd-mm-yyyy')) - (to_date(startDate, 'dd-mm-yyyy')));

    for i in 0..dateDifference
        loop
            --  Total  ----------------------------------------------------------------------------------
            select count(to_char("Courier Partner"))
            into total
            from "rawData"
            where (to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate)
              and (to_char("Courier Partner") in ('EcomExpress Reverse', 'Shadowfax Reverse', 'Delhivery Reverse'));

--  SameDay ----------------------------------------------------------------------------------
            select count(to_char("Courier Partner"))
            into sameDay
            from "rawData"
            where (to_char("Courier Partner") in ('EcomExpress Reverse', 'Shadowfax Reverse', 'Delhivery Reverse'))
              and (to_char("Clickpost Unified Status") not in
                   ('Cancelled', 'PickupFailed', 'PickupPending', 'OutForPickup', 'OrderPlaced'))
              and ((to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate) and
                   (to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') < ('13:00')))
              and ((to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate) and
                   (to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') < ('13:00')));

--  1stDay ----------------------------------------------------------------------------------
            select count(to_char("Courier Partner"))
            into day1st
            from "rawData"
            where (to_char("Courier Partner") in ('EcomExpress Reverse', 'Shadowfax Reverse', 'Delhivery Reverse'))
              and (to_char("Clickpost Unified Status") not in
                   ('Cancelled', 'PickupFailed', 'PickupPending', 'OutForPickup', 'OrderPlaced'))
              and ((to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate) and
                   (to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') > ('12:59')))
              and (((to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate) and
                    (to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') > ('12:59'))) OR
                   ((to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yy') =
                     (to_char(to_date(startDate, 'dd-mm-yy') + (1)))) and
                    (to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') < ('13:00'))));

            select count(to_char("Courier Partner"))
            into day1stA
            from "rawData"
            where (to_char("Courier Partner") in ('EcomExpress Reverse', 'Shadowfax Reverse', 'Delhivery Reverse'))
              and (to_char("Clickpost Unified Status") not in
                   ('Cancelled', 'PickupFailed', 'PickupPending', 'OutForPickup', 'OrderPlaced'))
              and ((to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate) and
                   (to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') < ('13:00')))
              and (((to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate) and
                    (to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') > ('12:59'))) or
                   ((to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yy') =
                     (to_char(to_date(startDate, 'dd-mm-yy') + (1)))) and
                    (to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') < ('13:00'))));

--  2ndDay ----------------------------------------------------------------------------------
            select count(to_char("Courier Partner"))
            into day2nd
            from "rawData"
            where (to_char("Courier Partner") in ('EcomExpress Reverse', 'Shadowfax Reverse', 'Delhivery Reverse'))
              and (to_char("Clickpost Unified Status") not in
                   ('Cancelled', 'PickupFailed', 'PickupPending', 'OutForPickup', 'OrderPlaced'))
              and ((to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate) and
                   (to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') > ('12:59')))
              and (((to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yy') =
                     (to_char(to_date(startDate, 'dd-mm-yy') + (1)))) and
                    (to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') > ('12:59'))) or
                   ((to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yy') =
                     (to_char(to_date(startDate, 'dd-mm-yy') + (2)))) and
                    (to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') < ('13:00'))));

            select count(to_char("Courier Partner"))
            into day2ndA
            from "rawData"
            where (to_char("Courier Partner") in ('EcomExpress Reverse', 'Shadowfax Reverse', 'Delhivery Reverse'))
              and (to_char("Clickpost Unified Status") not in
                   ('Cancelled', 'PickupFailed', 'PickupPending', 'OutForPickup', 'OrderPlaced'))
              and ((to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate) and
                   (to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') < ('13:00')))
              and (((to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yy') =
                     (to_char(to_date(startDate, 'dd-mm-yy') + (1)))) and
                    (to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') > ('12:59')))
                or ((to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yy') =
                     (to_char(to_date(startDate, 'dd-mm-yy') + (2)))) and
                    (to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') < ('13:00'))));

--  3rdDay ----------------------------------------------------------------------------------
            select count(to_char("Courier Partner"))
            into day3rd
            from "rawData"
            where (to_char("Courier Partner") in ('EcomExpress Reverse', 'Shadowfax Reverse', 'Delhivery Reverse'))
              and (to_char("Clickpost Unified Status") not in
                   ('Cancelled', 'PickupFailed', 'PickupPending', 'OutForPickup', 'OrderPlaced'))
              and ((to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate) and
                   (to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') > ('12:59')))
              and (((to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yy') =
                     (to_char(to_date(startDate, 'dd-mm-yy') + (2)))) and
                    (to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') > ('12:59'))) or
                   ((to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yy') =
                     (to_char(to_date(startDate, 'dd-mm-yy') + (3)))) and
                    (to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') < ('13:00'))));

            select count(to_char("Courier Partner"))
            into day3rdA
            from "rawData"
            where (to_char("Courier Partner") in ('EcomExpress Reverse', 'Shadowfax Reverse', 'Delhivery Reverse'))
              and (to_char("Clickpost Unified Status") not in
                   ('Cancelled', 'PickupFailed', 'PickupPending', 'OutForPickup', 'OrderPlaced'))
              and ((to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate) and
                   (to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') < ('12:59')))
              and (((to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yy') =
                     (to_char(to_date(startDate, 'dd-mm-yy') + (2)))) and
                    (to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') > ('12:59'))) or
                   ((to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yy') =
                     (to_char(to_date(startDate, 'dd-mm-yy') + (3)))) and
                    (to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') < ('13:00'))));

--  4thDay ----------------------------------------------------------------------------------
            select count(to_char("Courier Partner"))
            into day4th1
            from "rawData"
            where (to_char("Courier Partner") in ('EcomExpress Reverse', 'Shadowfax Reverse', 'Delhivery Reverse'))
              and (to_char("Clickpost Unified Status") not in
                   ('Cancelled', 'PickupFailed', 'PickupPending', 'OutForPickup', 'OrderPlaced'))
              and ((to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate) and
                   (to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') > ('12:59')))
              and (to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yy') in
                   (
                    (to_char(to_date(startDate, 'dd-mm-yy') + (4))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (5))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (6))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (7))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (8))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (9))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (10))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (11))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (12))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (13))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (14))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (15))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (16))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (17))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (18))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (19))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (20))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (21))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (22))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (23))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (24))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (25))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (26))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (27))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (28))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (29))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (30))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (31)))
                       ));

            select count(to_char("Courier Partner"))
            into day4thA1
            from "rawData"
            where (to_char("Courier Partner") in ('EcomExpress Reverse', 'Shadowfax Reverse', 'Delhivery Reverse'))
              and (to_char("Clickpost Unified Status") not in
                   ('Cancelled', 'PickupFailed', 'PickupPending', 'OutForPickup', 'OrderPlaced'))
              and ((to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate) and
                   (to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') < ('13:00')))
              and (to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yy') in
                   (
                    (to_char(to_date(startDate, 'dd-mm-yy') + (4))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (5))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (6))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (7))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (8))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (9))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (10))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (11))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (12))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (13))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (14))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (15))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (16))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (17))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (18))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (19))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (20))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (21))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (22))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (23))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (24))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (25))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (26))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (27))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (28))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (29))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (30))),
                    (to_char(to_date(startDate, 'dd-mm-yy') + (31)))
                       ));

            select count(to_char("Courier Partner"))
            into day4th2
            from "rawData"
            where (to_char("Courier Partner") in ('EcomExpress Reverse', 'Shadowfax Reverse', 'Delhivery Reverse'))
              and (to_char("Clickpost Unified Status") not in
                   ('Cancelled', 'PickupFailed', 'PickupPending', 'OutForPickup', 'OrderPlaced'))
              and ((to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate) and
                   (to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') > ('12:59')))
              and (((to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yy') =
                     (to_char(to_date(startDate, 'dd-mm-yy') + (3)))) and
                    (to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') > ('12:59'))));

            select count(to_char("Courier Partner"))
            into day4thA2
            from "rawData"
            where (to_char("Courier Partner") in ('EcomExpress Reverse', 'Shadowfax Reverse', 'Delhivery Reverse'))
              and (to_char("Clickpost Unified Status") not in
                   ('Cancelled', 'PickupFailed', 'PickupPending', 'OutForPickup', 'OrderPlaced'))
              and ((to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate) and
                   (to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') < ('13:00')))
              and (((to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yy') =
                     (to_char(to_date(startDate, 'dd-mm-yy') + (3)))) and
                    (to_char(to_date("Pickup Date", 'dd-mm-yyyy HH24:mi'), 'HH24:mi') > ('12:59'))));

--  PickupFailed ----------------------------------------------------------------------------------
            select count(to_char("Courier Partner"))
            into PickupFailed
            from "rawData"
            where (to_char("Courier Partner") in ('EcomExpress Reverse', 'Shadowfax Reverse', 'Delhivery Reverse'))
              and (to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate)
              and (to_char("Clickpost Unified Status") = 'PickupFailed');

--  Cancelled ----------------------------------------------------------------------------------
            select count(to_char("Courier Partner"))
            into Cancelled
            from "rawData"
            where (to_char("Courier Partner") in ('EcomExpress Reverse', 'Shadowfax Reverse', 'Delhivery Reverse'))
              and (to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate)
              and (to_char("Clickpost Unified Status") = 'Cancelled');

--  OutForPickup ----------------------------------------------------------------------------------
            select count(to_char("Courier Partner"))
            into OutForPickup
            from "rawData"
            where (to_char("Courier Partner") in ('EcomExpress Reverse', 'Shadowfax Reverse', 'Delhivery Reverse'))
              and (to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate)
              and (to_char("Clickpost Unified Status") = 'OutForPickup');

--  OrderPlaced ----------------------------------------------------------------------------------
            select count(to_char("Courier Partner"))
            into OrderPlaced
            from "rawData"
            where (to_char("Courier Partner") in ('EcomExpress Reverse', 'Shadowfax Reverse', 'Delhivery Reverse'))
              and (to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate)
              and (to_char("Clickpost Unified Status") = 'OrderPlaced');

--  PickupPending ----------------------------------------------------------------------------------
            select count(to_char("Courier Partner"))
            into PickupPending
            from "rawData"
            where (to_char("Courier Partner") in ('EcomExpress Reverse', 'Shadowfax Reverse', 'Delhivery Reverse'))
              and (to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate)
              and (to_char("Clickpost Unified Status") = 'PickupPending');

--  SameDayExpected ----------------------------------------------------------------------------------
            sameDayExpected := (day1stA || '-' || day2ndA || '-' || day3rdA || '-' || (day4thA1 + day4thA2));

--  InTransit ----------------------------------------------------------------------------------
            select count(to_char("Courier Partner"))
            into inTransit
            from "rawData"
            where (to_char("Courier Partner") in ('EcomExpress Reverse', 'Shadowfax Reverse', 'Delhivery Reverse'))
              and (to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate)
              and (to_char("Clickpost Unified Status") = 'InTransit');

--  Delivered ----------------------------------------------------------------------------------
            select count(to_char("Courier Partner"))
            into delivered
            from "rawData"
            where (to_char("Courier Partner") in ('EcomExpress Reverse', 'Shadowfax Reverse', 'Delhivery Reverse'))
              and (to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate)
              and (to_char("Clickpost Unified Status") = 'Delivered');

--  ShadowFax total ----------------------------------------------------------------------------------
            select count(to_char("Courier Partner"))
            into shadowfaxReverse
            from "rawData"
            where (to_char("Courier Partner") = 'Shadowfax Reverse')
              and (to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate);

--  EcomExpressReverse ----------------------------------------------------------------------------------
            select count(to_char("Courier Partner"))
            into ecomExpressReverse
            from "rawData"
            where (to_char("Courier Partner") = 'EcomExpress Reverse')
              and (to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate);

-- DeliveryReverse ----------------------------------------------------------------------------------
            select count(to_char("Courier Partner"))
            into delhiVeryReverse
            from "rawData"
            where (to_char("Courier Partner") = 'Delhivery Reverse')
              and (to_char(to_date("Created at", 'dd-mm-yyyy HH24:mi'), 'dd-mm-yyyy') = startDate);

--  1st To 4th+ Day Percentage ----------------------------------------------------------------------------------
            if total = 0 then
                startDate := to_char(to_date(startDate, 'dd-mm-yyyy') + 1, 'dd-mm-yyyy');
                continue;
            else
                daySamePercent := Round(((SameDay * 100) / Total), 2);
                day1stPercent := Round((((day1st + day1stA) * 100) / Total), 2);
                day2ndPercent := Round((((day2nd + day2ndA) * 100) / Total), 2);
                day3rdPercent := Round((((day3rd + day3rdA) * 100) / Total), 2);
                day4thPercent := Round((((day4th1 + day4thA1 + day4th2 + day4thA2) * 100) / Total), 2);

--  OrderError ----------------------------------------------------------------------------------
                orderError := (
                        total - (
                            sameDay + day1st + day1stA + day2nd + day2ndA + day3rd + day3rdA + day4th1 + day4thA1 +
                            day4th2 + day4thA2 + PickupFailed + PickupPending + Cancelled + OutForPickup + OrderPlaced
                        ));
            end if;

--  Export Output to Excel File---------------------------------------------------------------------------------
            utl_file.put_line(
                    out_file,
                    startDate || ',' || Total || ',' || sameDay || ',' || (day1st + day1stA) || ',' ||
                    (day2nd + day2ndA) ||
                    ',' || (day3rd + day3rdA) || ',' || (day4th1 + day4thA1 + day4th2 + day4thA2) || ',' ||
                    PickupFailed || ',' || Cancelled || ',' || OutForPickup || ',' || OrderPlaced || ',' ||
                    PickupPending || ',' || orderError || ',' || sameDayExpected || ',' || InTransit || ',' ||
                    Delivered || ',' || daySamePercent || ',' || day1stPercent || ',' || day2ndPercent || ',' ||
                    day3rdPercent || ',' || day4thPercent || ',' || shadowfaxReverse || ',' || ecomExpressReverse ||
                    ',' || delhiVeryReverse
                );
            dbms_output.put_line(
                        lpad(startDate, 10, ' ') || '|' || lpad(total, 5, ' ') || '|' || lpad(sameDay, 7, ' ') || '|' ||
                        lpad((day1st + day1stA), 6, ' ') || '|' || lpad((day2nd + day2ndA), 6, ' ') || '|' ||
                        lpad((day3rd + day3rdA), 6, ' ') || '|' ||
                        lpad((day4th1 + day4thA1 + day4th2 + day4thA2), 6, ' ') || '|' || lpad(PickupFailed, 12, ' ') ||
                        '|' || lpad(Cancelled, 9, ' ') || '|' || lpad(OutForPickup, 12, ' ') || '|' ||
                        lpad(OrderPlaced, 11, ' ') || '|' || lpad(PickupPending, 13, ' ') || '|' ||
                        lpad(orderError, 10, ' ') || '|' || lpad(sameDayExpected, 15, ' ') || '|' ||
                        lpad(InTransit, 9, ' ') || '|' || lpad(delivered, 9, ' ') || '|' ||
                        lpad(daySamePercent, 7, ' ') || '|' || lpad(day2ndPercent, 7, ' ') || '|' ||
                        lpad(day3rdPercent, 7, ' ') || '|' || lpad(day4thPercent, 7, ' ') || '|' ||
                        lpad(shadowfaxReverse, 9, ' ') || '|' || lpad(ecomExpressReverse, 11, ' ') || '|' ||
                        lpad(delhiVeryReverse, 9, ' ')
                );

            startDate := to_char(to_date(startDate, 'dd-mm-yyyy') + 1, 'dd-mm-yyyy');

        end loop;

    utl_file.fclose(out_file);
end;