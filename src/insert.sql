insert into personage_type(name, description)
values ('огр', 'безобразный злобный великан-людоед'),
       ('человек', ''),
       ('гном', 'карлик с бородой'),
       ('фея', 'человекоподобное существо с крылышками и волшебной палочкой'),
       ('говорящее животное', ''),
       ('дракон', 'огромное огнедышащее существо с крыльями');

insert into location(name, description, x, y)
values ('замок лорда Фаркуада', '', 0, 0),
       ('замок дракона', '', 1000, 700),
       ('болото', '', 300, 400);

insert into personage(name, personage_type_id)
values ('Шрек', 1),
       ('Лорд Фаркуад', 2),
       ('Фея крестная', 4),
       ('Осел', 5),
       ('Фиона', 2),
       ('Дракониха', 6);

insert into clothing(name, owner_id, type)
values ('свадебное платье', 5, 'праздничный наряд');

insert into weapon(name, damage, owner_id, type)
values ('огонь дракона', 90, 6, 'магическое оружие');

insert into fairy_personage(id, skill)
values (6, 'разрушающий все на своем пути огонь, съедение врагов');