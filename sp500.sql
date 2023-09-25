-- Create the tables for the S&P 500 database.
-- They contain information about the companies 
-- in the S&P 500 stock market index
-- during some interval of time in 2014-2015.
-- https://en.wikipedia.org/wiki/S%26P_500 

create table history
(
	symbol text,
	day date,
	open numeric,
	high numeric,
	low numeric,
	close numeric,
	volume integer,
	adjclose numeric
);

create table sp500
(
	symbol text,
	security text,
	sector text,
	subindustry text,
	address text,
	state text
);

-- Populate the tables
insert into history select * from bob.history;
insert into sp500 select * from bob.sp500;

-- Familiarize yourself with the tables.
select * from history;
select * from sp500;


-- Find the number of companies for each state, sort descending by the number.
select state, count(security)
from sp500
group by state
order by count(security) desc;

-- Find the number of companies for each sector, sort descending by the number.
select sector, count(security)
from sp500
group by sector
order by count(security) desc;

-- Order the days of the week by their average volatility.
-- Sort descending by the average volatility. 
-- Use 100*abs(high-low)/low to measure daily volatility.

select extract(dow from day), avg(100*abs(high-low)/low)
from history
group by extract(dow from day)
order by avg(100*abs(high-low)/low) desc;


-- Find for each symbol and day the pct change from the previous business day.
-- Order descending by pct change. Use adjclose.
select symbol, day, 100*(adjclose-prev)/prev as pct_change
from
    (select symbol, day, adjclose,lag(adjclose,1) over
        (partition by symbol order by day) as prev
    from history) X
where prev is not null
order by pct_change desc;


-- Many traders believe in buying stocks in uptrend
-- in order to maximize their chance of profit. 
-- Let us check this strategy.
-- Find for each symbol on Oct 1, 2015 
-- the pct change 20 trading days earlier and 20 trading days later.
-- Order descending by pct change with respect to 20 trading days earlier.
-- Use adjclose.
select symbol, 100*(adjclose-prev)/prev as prev_pct, 100*(next-adjclose)/adjclose as next_pct
from
    (select symbol, day, adjclose, lag(adjclose,20) over
        (partition by symbol order by day) as prev, lead(adjclose,20) over
        (partition by symbol order by day) as next
    from history) X
where day = 'Oct 1, 2015' and prev is not null and next is not null
order by prev_pct desc;



-- Find the top 10 symbols with respect to their average money volume AVG(volume*adjclose).
-- Use round(..., -8) on the average money volume.
-- Give three versions of query, using ROW_NUMBER(), RANK(), and DENSE_RANK().
select *
from(
    select symbol,day,round(avg(volume*adjclose),-8) as avg_money_vol, row_number() over
        (partition by symbol order by round(avg(volume*adjclose),-8) desc) as rank
    from history
    group by symbol,day) X
where rank<=10
order by symbol, rank;


select *
from(
    select symbol,day,round(avg(volume*adjclose),-8) as avg_money_vol, rank() over
        (partition by symbol order by round(avg(volume*adjclose),-8) desc) as rank
    from history
    group by symbol,day) X
where rank<=10
order by symbol,rank;


select *
from(
    select symbol,day,round(avg(volume*adjclose),-8) as avg_money_vol, dense_rank() over
        (partition by symbol order by round(avg(volume*adjclose),-8) desc) as rank
    from history
    group by symbol,day) X
where rank<=10
order by symbol,rank;
