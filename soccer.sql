/*Soccer analytics using SQL.
The data is in tables England, France, Germany, and Italy.
These tables contain more than 100 years of soccer game statistics.
*/

/*Create the tables.*/

create table england as select * from bob.england;
create table france as select * from bob.france;
create table germany as select * from bob.germany;
create table italy as select * from bob.italy;

/*Familiarize with the tables.*/
SELECT * FROM england;
SELECT * FROM germany;
SELECT * FROM france;
SELECT * FROM italy;

/*
Find all the games in England between seasons 1920 and 1999 such that the total goals are at least 13.
Order by total goals descending.*/

SELECT "Date", season, home, visitor, hgoal, vgoal, tier, totgoal, goaldif, result
FROM england
WHERE totgoal>13 AND season>1920 AND season<1999
ORDER BY totgoal DESC;


/*
For each total goal result, find how many games had that result.
Use the england table and consider only the seasons since 1980.
Order by total goal.*/

SELECT totgoal, COUNT(totgoal)
FROM england
WHERE season>=1980
GROUP BY totgoal
ORDER BY totgoal;


/*
Find for each team in England in tier 1 the total number of games played since 1980.
Report only teams with at least 300 games.
*/

SELECT team, SUM(gnum)
FROM(
    SELECT home AS team, COUNT(*) AS gnum
    FROM england
    WHERE season>=1980 AND tier =1
    GROUP BY home
    UNION
    SELECT visitor AS team, COUNT(*) AS gnum
    FROM england
    WHERE season>=1980 AND tier = 1
    GROUP BY visitor) Z
GROUP BY team
HAVING SUM(gnum)>=300
ORDER BY SUM(gnum) DESC;


/*
For each pair team1, team2 in England, in tier 1,
find the number of home-wins since 1980 of team1 versus team2.
Order the results by the number of home-wins in descending order.
*/

SELECT home, visitor, COUNT(result='H')
FROM england
WHERE tier=1 AND season>=1980 AND result='H'
GROUP BY home, visitor
ORDER BY COUNT(result='H') DESC;

/*
For each pair team1, team2 in England in tier 1
find the number of away-wins since 1980 of team1 versus team2.
Order the results by the number of away-wins in descending order.*/

SELECT visitor, home, COUNT(result='A')
FROM england
WHERE tier=1 AND season>=1980 AND result='A'
GROUP BY visitor, home
ORDER BY COUNT(result='A') DESC;


/*
For each pair team1, team2 in England in tier 1 report the number of home-wins and away-wins
since 1980 of team1 versus team2.
Order the results by the number of away-wins in descending order.
*/

SELECT X.home, X.visitor, hwins, awins
FROM
    (SELECT home, visitor, COUNT(*) as hwins
    FROM england
    WHERE tier=1 AND season>=1980 AND goaldif>0
    GROUP BY visitor, home) X JOIN
    (SELECT home, visitor, COUNT(*) as awins
    FROM england
    WHERE tier=1 AND season>=1980 AND goaldif<0
    GROUP BY home, visitor) Y ON (X.visitor=Y.home AND X.home=Y.visitor)
ORDER BY awins DESC;

--Create a view, called Wins, with the query for the previous question.
CREATE VIEW Wins AS
    SELECT X.home, X.visitor, hwins, awins
    FROM
        (SELECT home, visitor, COUNT(*) as hwins
        FROM england
        WHERE tier=1 AND season>=1980 AND goaldif>0
        GROUP BY visitor, home) X JOIN
        (SELECT home, visitor, COUNT(*) as awins
        FROM england
        WHERE tier=1 AND season>=1980 AND goaldif<0
        GROUP BY home, visitor) Y ON (X.visitor=Y.home AND X.home=Y.visitor)
    ORDER BY awins DESC;

/*
For each pair ('Arsenal', team2), report the number of home-wins and away-wins
of Arsenal versus team2 and the number of home-wins and away-wins of team2 versus Arsenal
(all since 1980).
Order the results by the second number of away-wins in descending order.
Use view W1.*/

SELECT X.home, X.visitor, X.hwins, X.awins, T2hwins, T2awins
FROM Wins X JOIN
    (SELECT home, visitor, hwins AS T2hwins, awins AS T2awins
    FROM Wins
    WHERE visitor = 'Arsenal') Y ON (X.home = Y.visitor AND X.visitor = Y.home)
WHERE X.home = 'Arsenal'
ORDER BY T2awins DESC;

/*Drop view Wins.*/
DROP VIEW Wins;

/*
Winning at home is easier than winning as visitor.
Nevertheless, some teams have won more games as a visitor than when at home.
Find the team in Germany that has more away-wins than home-wins in total.
Print the team name, number of home-wins, and number of away-wins.*/

SELECT X.visitor, hwins, awins
FROM
    (SELECT visitor, COUNT(*) AS awins
    FROM germany
    WHERE hgoal<vgoal
    GROUP BY visitor) X JOIN
    (SELECT home, COUNT(*) AS hwins
    FROM germany
    WHERE hgoal>vgoal
    GROUP BY home) Y ON (X.visitor=Y.home)
WHERE awins>hwins;

/*
One of the beliefs many people have about Italian soccer teams is that they play much more defense than offense.
Catenaccio or The Chain is a tactical system in football with a strong emphasis on defence.
In Italian, catenaccio means "door-bolt", which implies a highly organised and effective backline defence
focused on nullifying opponents' attacks and preventing goal-scoring opportunities.
In this question we would like to see whether the number of goals in Italy is on average smaller than in England.

Find the average total goals per season in England and Italy since the 1970 season.
The results should be (season, england_avg, italy_avg) triples, ordered by season.
*/

SELECT season, england_avg,Italy_avg
FROM
    (SELECT season, AVG(totgoal) AS england_avg
    FROM england
    WHERE season>=1970
    GROUP BY season) X JOIN
    (SELECT season, AVG(hgoal+vgoal) AS Italy_avg
    FROM italy
    WHERE season>=1970
    GROUP BY season) Y USING (season)
ORDER BY season;


/*
Find the number of games in France and England in tier 1 for each goal difference.
Return (goaldif, france_games, eng_games) triples, ordered by the goal difference.
Normalize the number of games returned dividing by the total number of games for the country in tier 1,
*/

SELECT goaldif, france_games, eng_games
FROM
    (SELECT goaldif, 1.0*COUNT(*)/(select count(*) from france where tier=1) AS france_games
    FROM france
    WHERE tier=1
    GROUP BY goaldif) X JOIN
    (SELECT goaldif,1.0*COUNT(*)/(select count(*) from england where tier=1) AS eng_games
    FROM england
    WHERE tier=1
    GROUP BY goaldif) Y USING (goaldif)
ORDER BY goaldif;

/*
Find all the seasons when England had higher average total goals than France.
Consider only tier 1 for both countries.
Return (season,england_avg,france_avg) triples.
Order by season.*/

SELECT season, england_avg, france_avg
FROM
    (SELECT season, AVG(totgoal) AS england_avg
    FROM england
    WHERE tier=1
    GROUP BY season) X JOIN
    (SELECT season,AVG(totgoal) AS france_avg
    FROM france
    WHERE tier=1
    GROUP BY season) Y USING (season)
WHERE england_avg>france_avg
ORDER BY season;