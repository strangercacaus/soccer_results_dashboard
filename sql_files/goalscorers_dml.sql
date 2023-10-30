CREATE TABLE public.goalscorers (
    id serial4,
    "date" date not null,
    home_team varchar(50),
    away_team varchar(50), 
    team varchar(50),
    scorer varchar,
    minute numeric,
    own_goal boolean,
    penalty boolean
);