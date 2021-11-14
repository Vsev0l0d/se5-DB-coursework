create function check_event_date() returns trigger as $check_event_date$
begin
    if new.date_start > new.date_end then
        raise exception 'date_start cannot be later date_end';
    end if;
    return new;
end;
$check_event_date$ language plpgsql;

create trigger check_event_date before insert or update on event
    for each row execute procedure check_event_date();


