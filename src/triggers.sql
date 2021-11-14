create function check_event_date() returns trigger as $$
begin
    if new.date_start > new.date_end then
        raise exception 'date_start cannot be later date_end';
    end if;
    return new;
end;
$$ language plpgsql;

create trigger check_event_date before insert or update on event
    for each row execute procedure check_event_date();


create function prevent_adding_control_after_invitation() returns trigger as $$
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