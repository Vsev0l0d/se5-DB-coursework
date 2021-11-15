create index invitation_index on invitation (id);
create index event_index on event (id);
create index location_index on location using hash (id);