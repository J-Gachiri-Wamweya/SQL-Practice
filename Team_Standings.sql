-- TEAM STANDINGS

-- Write a query to return the scores of each team in the teams table after all matches displayed in the matches table. 
-- Points are awarded as follows: zero points for a loss, one point for a tie, and three points for a win. 
-- The result should include team name and points, and be ordered by decreasing points. In case of a tie, order by alphabetized team name.

create database if not exists practicedb;
use practicedb;

create table if not exists matches (
match_id integer not null, 
host_team integer, 
guest_team integer, 
host_goals integer,
guest_goals integer);

create table if not exists teams (
team_id integer not null, 
team_name varchar (40));

/*
insert into teams (team_id, team_name)
VALUES
(1, 'New York'),
(2, 'Atlanta'),
(3, 'Chicago'),
(4, 'Toronto'),
(5, 'Los Angeles'),
(6, 'Seattle');
insert into matches (match_id, host_team, guest_team, host_goals, guest_goals)
VALUES
(1, 1, 2, 3, 0),
(2, 2, 3, 2, 4),
(3, 3, 4, 4, 3),
(4, 4, 5, 1, 1),
(5, 5, 6, 2, 1),
(6, 6, 1, 1, 2);
*/
select * from teams;
select * from matches;

select *,
(case when host_goals > guest_goals then 3 when host_goals = guest_goals then 1 else 0 end) as host_points,
(case when guest_goals > host_goals then 3 when host_goals = guest_goals then 1 else 0 end) as guest_points 
from matches;

with t1 as (
select *,
(case when host_goals > guest_goals then 3 when host_goals = guest_goals then 1 else 0 end) as host_points,
(case when guest_goals > host_goals then 3 when host_goals = guest_goals then 1 else 0 end) as guest_points 
from matches
),
t2 as (
select host_team as team, host_points as points 
from t1
union all
select guest_team as team, guest_points as points 
from t1
)
select teams.team_name , sum(t2.points) as total_points 
from t2 
join teams on t2.team = teams.team_id
group by t2.team
order by total_points desc,teams.team_name;
