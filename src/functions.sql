create or replace function weapon_count(personage_id integer) returns integer as $$
declare
    res integer;
begin
    select count(id) into res from weapon where owner_id = personage_id;
    return res;
end;
$$ language plpgsql;

create or replace function clothing_count(personage_id integer) returns integer as $$
declare
res integer;
begin
select count(id) into res from clothing where owner_id = personage_id;
return res;
end;
$$ language plpgsql;

create or replace function prise_count(personage_id integer) returns integer as $$
declare
    res integer;
begin
    select count(id) into res from prise where owner_id = personage_id;
    return res;
end;
$$ language plpgsql;

create or replace function share_of_accepted_invitations(pid integer) returns real as $$
declare
    res real;
begin
    create temp table personage_confirmations on commit drop
    as select confirmation from invitation where personage_id = pid;
    select case when t.denom = 0 then 0 else t.num / t.denom end
    into res
    from (
         select (
                    select cast(count(*) as real)
                    from personage_confirmations
                    where confirmation = true
                ) as num,
                (
                    select cast(count(*) as real)
                    from personage_confirmations
                ) as denom
     ) as t;
    return res;
end;
$$ language plpgsql;