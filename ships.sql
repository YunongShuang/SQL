/*
This is an example concerning World War II capital ships.
It involves the following relations:

Classes(class, type, country, numGuns, bore, displacement)
Ships(name, class, launched)  --launched is for year launched
Battles(name, date_fought)
Outcomes(ship, battle, result)

Ships are built in "classes" from the same design, and the class is usually
named for the first ship of that class.

Relation Classes records the name of the class,
the type (bb for battleship or bc for battlecruiser),
the country that built the ship, the number of main guns,
the bore (diameter of the gun barrel, in inches)
of the main guns, and the displacement (weight, in tons).

Relation Ships records the name of the ship, the name of its class,
and the year in which the ship was launched.

Relation Battles gives the name and date of battles involving these ships.

Relation Outcomes gives the result (sunk, damaged, or ok)
for each ship in each battle.
*/


/*
Part 1 -- Create Tables

1.	Create simple SQL statements to create the above relations
    (no constraints for initial creations).
2.	Insert the following data.

For Classes:
('Bismarck','bb','Germany',8,15,42000);
('Kongo','bc','Japan',8,14,32000);
('North Carolina','bb','USA',9,16,37000);
('Renown','bc','Gt. Britain',6,15,32000);
('Revenge','bb','Gt. Britain',8,15,29000);
('Tennessee','bb','USA',12,14,32000);
('Yamato','bb','Japan',9,18,65000);

For Ships
('California','Tennessee',1921);
('Haruna','Kongo',1915);
('Hiei','Kongo',1914);
('Iowa','Iowa',1943);
('Kirishima','Kongo',1914);
('Kongo','Kongo',1913);
('Missouri','Iowa',1944);
('Musashi','Yamato',1942);
('New Jersey','Iowa',1943);
('North Carolina','North Carolina',1941);
('Ramilles','Revenge',1917);
('Renown','Renown',1916);
('Repulse','Renown',1916);
('Resolution','Revenge',1916);
('Revenge','Revenge',1916);
('Royal Oak','Revenge',1916);
('Royal Sovereign','Revenge',1916);
('Tennessee','Tennessee',1920);
('Washington','North Carolina',1941);
('Wisconsin','Iowa',1944);
('Yamato','Yamato',1941);

For Battles
('North Atlantic','27-May-1941');
('Guadalcanal','15-Nov-1942');
('North Cape','26-Dec-1943');
('Surigao Strait','25-Oct-1944');

For Outcomes
('Bismarck','North Atlantic', 'sunk');
('California','Surigao Strait', 'ok');
('Duke of York','North Cape', 'ok');
('Fuso','Surigao Strait', 'sunk');
('Hood','North Atlantic', 'sunk');
('King George V','North Atlantic', 'ok');
('Kirishima','Guadalcanal', 'sunk');
('Prince of Wales','North Atlantic', 'damaged');
('Rodney','North Atlantic', 'ok');
('Scharnhorst','North Cape', 'sunk');
('South Dakota','Guadalcanal', 'ok');
('West Virginia','Surigao Strait', 'ok');
('Yamashiro','Surigao Strait', 'sunk');

*/

Create table Classes
(
    class varchar(20),
    type varchar(2),
    country varchar(20),
    numGun INT,
    bore INT,
    displacement INT
);

Create table Ships
(
  name varchar(20),
  class varchar(20),
  launched INT
);

Create table Battles
(
  name varchar(20),
  date_fought date
);

Create table Outcomes
(
  ship varchar(20),
  battle varchar(20),
  result varchar(10)
);

insert into Classes values ('Bismarck','bb','Germany',8,15,42000);
insert into Classes values('Kongo','bc','Japan',8,14,32000);
insert into Classes values('North Carolina','bb','USA',9,16,37000);
insert into Classes values('Renown','bc','Gt. Britain',6,15,32000);
insert into Classes values('Revenge','bb','Gt. Britain',8,15,29000);
insert into Classes values('Tennessee','bb','USA',12,14,32000);
insert into Classes values('Yamato','bb','Japan',9,18,65000);

insert into Ships values('California','Tennessee',1921);
insert into Ships values('Haruna','Kongo',1915);
insert into Ships values('Hiei','Kongo',1914);
insert into Ships values('Iowa','Iowa',1943);
insert into Ships values('Kirishima','Kongo',1914);
insert into Ships values('Kongo','Kongo',1913);
insert into Ships values('Missouri','Iowa',1944);
insert into Ships values('Musashi','Yamato',1942);
insert into Ships values('New Jersey','Iowa',1943);
insert into Ships values('North Carolina','North Carolina',1941);
insert into Ships values('Ramilles','Revenge',1917);
insert into Ships values('Renown','Renown',1916);
insert into Ships values('Repulse','Renown',1916);
insert into Ships values('Resolution','Revenge',1916);
insert into Ships values('Revenge','Revenge',1916);
insert into Ships values('Royal Oak','Revenge',1916);
insert into Ships values('Royal Sovereign','Revenge',1916);
insert into Ships values('Tennessee','Tennessee',1920);
insert into Ships values('Washington','North Carolina',1941);
insert into Ships values('Wisconsin','Iowa',1944);
insert into Ships values('Yamato','Yamato',1941);

insert into Battles values('North Atlantic','27-May-1941');
insert into Battles values('Guadalcanal','15-Nov-1942');
insert into Battles values('North Cape','26-Dec-1943');
insert into Battles values('Surigao Strait','25-Oct-1944');

insert into Outcomes values('Bismarck','North Atlantic', 'sunk');
insert into Outcomes values('California','Surigao Strait', 'ok');
insert into Outcomes values('Duke of York','North Cape', 'ok');
insert into Outcomes values('Fuso','Surigao Strait', 'sunk');
insert into Outcomes values('Hood','North Atlantic', 'sunk');
insert into Outcomes values('King George V','North Atlantic', 'ok');
insert into Outcomes values('Kirishima','Guadalcanal', 'sunk');
insert into Outcomes values('Prince of Wales','North Atlantic', 'damaged');
insert into Outcomes values('Rodney','North Atlantic', 'ok');
insert into Outcomes values('Scharnhorst','North Cape', 'sunk');
insert into Outcomes values('South Dakota','Guadalcanal', 'ok');
insert into Outcomes values('West Virginia','Surigao Strait', 'ok');
insert into Outcomes values('Yamashiro','Surigao Strait', 'sunk');

DROP table Outcomes;
DROP table Battles;
DROP table Ships;
DROP table Classes;

-- Part 2
-- List the name, displacement, and number of guns of the ships engaged in the battle of Guadalcanal.

select ship, displacement, numGun
from (Ships join Classes using (class)) X right outer join Outcomes on (ship = X.name)
where battle = 'Guadalcanal';


-- Find the names of the ships whose number of guns was the largest for those ships of the same bore.

select Y.name
from
    (select bore, max(numGun)
    from Classes join Ships using (class)
    group by bore) X join
    (select name, bore, numGun
    from Classes join Ships using (class)) Y on (X.bore=Y.bore and X.max=Y.numGun);

--Find for each class with at least three ships the number of ships of that class sunk in battle.

select class, count(result='sunk') as sunk_ships
from
    (select name,class
    from Ships) X left join
    (select ship, result
    from Outcomes) Y on (X.name = Y.ship)
group by class
having count(name)>=3;

-- Part 3
-- Write the following modifications.

-- Two of the three battleships of the Italian Vittorio Veneto class –
-- Vittorio Veneto and Italia – were launched in 1940;
-- the third ship of that class, Roma, was launched in 1942.
-- Each had 15-inch guns and a displacement of 41,000 tons.
-- Insert these facts into the database.
insert into Classes values ('Vittorio Veneto', NULL, 'Italy', NULL, 15, 41000);
insert into Ships values('Vittorio Veneto', 'Vittorio Veneto', 1940);
insert into Ships values('Italia', 'Vittorio Veneto', 1940);
insert into Ships values('Roma', 'Vittorio Veneto', 1942);

-- Delete all classes with fewer than three ships.
delete from Classes
where class in
      (select class
      from ships
      group by class
      having count(name)<3);

-- Modify the Classes relation so that gun bores are measured in centimeters
-- (one inch = 2.5 cm) and displacements are measured in metric tons (one metric ton = 1.1 ton).

update Classes
SET bore = bore*2.5;

update Classes
SET displacement = displacement/1.1;


-- Add the following constraints using views with check option.

-- No ship can be in battle before it is launched.
create view OutcomesView as
select ship, battle, result
from Outcomes O
where not exists (
    select *
    from Ships S, Battles B
    where S.name=O.ship and O.battle=B.name and
    S.launched > extract(year from B.date_fought)
)
with check option;

-- Now we can try some insertion on this view.
INSERT INTO OutcomesView (ship, battle, result)
VALUES('Musashi', 'North Atlantic','ok');
-- This insertion, as expected, should fail since Musashi is launched in 1942,
-- while the North Atlantic battle took place on 27-MAY-41.


-- No ship can be launched before
-- the ship that bears the name of the first ship’s class.
create view ShipsV as
select name, class, launched
from Ships X
where not exists(
    select *
    from Ships Y
    where X.name <> Y.name and Y.class = Y.class and Y.launched>X.launched
)
with check option;

-- Now we can try some insertion on this view.
INSERT INTO ShipsV(name, class, launched)
VALUES ('AAA','Kongo',1912);
-- This insertion, as expected, should fail since ship Kongo (first ship of class Kongo) is launched in 1913.


-- No ship fought in a battle that was at a later date than another battle in which that ship was sunk.
create view OutcomesV as
    select ship,battle,result
    from Outcomes X
    where not exists(
        select *
        from Battles Y, Battles Z, Outcomes O
        where Y.name = X.battle and Z.name=O.battle and O.battle<>X.battle and Z.date_fought>Y.date_fought
          and O.result = 'sunk'
        )
    with check option;

-- Now we can try some insertion on this view.
INSERT INTO OutcomesV(ship, battle, result)
VALUES('Bismarck', 'Guadalcanal', 'ok');
-- This insertion, as expected, should fail since 'Bismarck' was sunk in
-- the battle of North Atlantic, in 1941, whereas the battle of Guadalcanal happened in 1942.
