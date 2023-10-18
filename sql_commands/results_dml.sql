CREATE TABLE public.results (
    id integer not null,
    "date" date not null,
    home_team varchar(50),
    away_team varchar(50), 
    home_score integer,
    away_score integer,
    tournament varchar,
    city varchar,
    country varchar(50),
    neutral boolean
);