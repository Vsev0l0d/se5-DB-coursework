create type thing_type as enum ('обмундирование', 'праздничный наряд',
  'магическое оружие', 'оружие', 'пижама');
create type prise_type as enum ('сертификат I степени', 'сертификат II степени',
  'сертификат III степени', 'сертификат участника', 'кубок', 'медаль');
create type block_type as enum ('отказ от всех приглашений', 'отказ от рассылок');

create table personage_type
(
    id          serial primary key,
    name        varchar(255),
    description text not null
);

create table location
(
    id          serial primary key,
    name        varchar(255),
    description text,
    x           integer not null,
    y           integer not null
);

create table personage
(
    id                serial primary key,
    name              varchar(255),
    personage_type_id integer not null references personage_type (id) on delete restrict
);

create table event
(
    id          serial primary key,
    name        varchar(255),
    date_start  timestamp not null,
    date_end    timestamp not null,
    location_id integer   not null references location (id) on delete restrict,
    description text      not null,
    owner_id    integer   references personage (id) on delete set null,
    visibility  bool      not null
);

create table event_personage_type
(
    personage_type_id integer references personage_type (id) on delete cascade,
    event_id          integer references event (id) on delete cascade,
    primary key (personage_type_id, event_id)
);

create table clothing
(
    id       serial primary key,
    name     varchar(255),
    owner_id integer    references personage (id) on delete set null,
    type     thing_type not null
);

create table weapon
(
    id       serial primary key,
    name     varchar(255),
    damage   integer    not null,
    owner_id integer    references personage (id) on delete set null,
    type     thing_type not null
);

create table thing_control
(
    type     thing_type,
    event_id integer references event (id) on delete cascade,
    primary key (type, event_id)
);

create table fairy_personage
(
    id    integer primary key references personage (id) on delete cascade,
    skill text not null
);

create table block_list
(
    blocking integer references personage (id) on delete cascade,
    blocked  integer references personage (id) on delete cascade,
    type     block_type,
    primary key (blocking, blocked)
);

create table invitation
(
    id           serial primary key,
    event_id     integer not null references event (id) on delete cascade,
    personage_id integer not null references personage (id) on delete cascade,
    confirmation bool
);

create table prise
(
    id       serial primary key,
    type     prise_type not null,
    owner_id integer    references personage (id) on delete set null,
    event_id integer    not null references event (id) on delete restrict
);