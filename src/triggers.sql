create or replace function check_event_date() returns trigger as $$
begin
    if new.date_start > new.date_end then
        raise exception 'date_start cannot be later date_end';
    end if;
    return new;
end;
$$ language plpgsql;

create trigger check_event_date before insert or update on event
    for each row execute procedure check_event_date();


create or replace function prevent_adding_control_after_invitation() returns trigger as $$
begin
    if exists(select 1 from invitation where event_id = new.event_id) then
        raise exception 'cannot add or change controls after sending invitations';
    end if;
    return new;
end;
$$ language plpgsql;

create trigger prevent_adding_control_after_invitation before insert or update on event_personage_type
    for each row execute procedure prevent_adding_control_after_invitation();
create trigger prevent_adding_control_after_invitation before insert or update on thing_control
    for each row execute procedure prevent_adding_control_after_invitation();


create or replace function check_invitation() returns trigger as $$
begin
    case tg_op
        when 'INSERT' then
            create temp table guests_types_ids on commit drop
                as select personage_type_id from event_personage_type where event_id = new.event_id;
            if exists(select 1 from guests_types_ids) and
                not ((select personage_type_id from personage where id = new.personage_id)
                in (select personage_type_id from guests_types_ids)) then
                raise exception 'this type of personage cannot be invited';
            end if;
            if new.confirmation is not null then
                raise exception 'the invitee must define the confirmation field himself';
            end if;
        when 'UPDATE' then
            create temp table personage_things on commit drop
                as select type from ((select type from weapon where owner_id = new.personage_id) union
                (select type from clothing where owner_id = new.personage_id)) pts;
            create temp table necessary_things on commit drop
                as select type from thing_control where event_id = new.event_id;
            if exists(select 1 from necessary_things n left join personage_things p
                using(type) where p.type is null) then
                raise exception 'there are no necessary things to visit';
            end if;
    end case;
    return new;
end;
$$ language plpgsql;

create trigger check_invitation before insert or update on invitation
    for each row execute procedure check_invitation();