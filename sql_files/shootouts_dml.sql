CREATE TABLE public.shootouts (
    id serial4,
    "date" date not null,
    home_team varchar(50),
    away_team varchar(50), 
    winner varchar(50),
    first_shooter varchar(50)
);