CREATE TABLE public.shootouts (
    id integer not null,
    "date" date not null,
    home_team varchar(50),
    away_team varchar(50), 
    winner varchar(50)
);