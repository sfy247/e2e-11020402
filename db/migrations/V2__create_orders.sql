create table orders (
    id         bigint generated always as identity primary key,
    item_id    bigint      not null references items (id),
    quantity   integer     not null check (quantity > 0),
    status     text        not null default 'new',
    created_at timestamptz not null default now()
);
create index orders_item_id on orders (item_id);
