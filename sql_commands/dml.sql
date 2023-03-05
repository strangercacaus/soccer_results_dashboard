-- Results table Set

CREATE TABLE public.results (
    id integer not null,
    "date" date not null,
    home_team varchar(50),
    away_team varchar(50), 
    home_score integer,
    away_score integer,
    tournment varchar,
    city varchar,
    country varchar(50),
    neutral boolean
);

-- Goalscorers table Set

CREATE TABLE public.goalscorers (
    id integer not null,
    "date" date not null,
    home_team varchar(50),
    away_team varchar(50), 
    team varchar(50),
    scorer varchar,
    minute numeric,
    own_goal boolean,
    penalty boolean
);


-- Shootouts table set

CREATE TABLE public.shootouts (
    id integer not null,
    "date" date not null,
    home_team varchar(50),
    away_team varchar(50), 
    winner varchar(50)
);