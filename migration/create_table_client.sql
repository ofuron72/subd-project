create sequence client_seq start 1 increment 1;

create table client
(
    client_id   bigint primary key default nextval('client_seq'::regclass),
    full_name   varchar(128)                     not null,
    birth_date  date                             not null,
    passport    varchar(10) unique               not null,
    phone       varchar(12),
    email       varchar(128),
    create_dttm timestamptz        default now() not null,
    modify_dttm timestamptz        default now() not null
);

comment on table client is 'Клиенты';

create sequence employee_seq start 1 increment 1;

create table employee
(
    employee_id bigint primary key default nextval('employee_seq'::regclass),
    full_name   varchar(128)                     not null,
    phone       varchar(12),
    email       varchar(128),
    hire_date   date                             not null,
    create_dttm timestamptz        default now() not null,
    modify_dttm timestamptz        default now() not null
);

comment on table employee is 'Сотрудники';

create sequence currency_seq start 1 increment 1;

create table currency
(
    currency_id bigint primary key default nextval('currency_seq'::regclass),
    code        char(3) unique                   not null,
    name        varchar(64)                      not null,
    updated_by  bigint,
    create_dttm timestamptz        default now() not null,
    modify_dttm timestamptz        default now() not null,
    foreign key (updated_by) references employee (employee_id)
);

comment on table currency is 'Валюты';

create sequence account_seq start 1 increment 1;

create table account
(
    account_id     bigint primary key default nextval('account_seq'::regclass),
    client_id      bigint                           not null,
    account_number varchar(20) unique               not null,
    account_type   varchar(20)                      not null,
    currency_id    int                              not null,
    balance        decimal(15, 2)     default 0,
    create_dttm    timestamptz        default now() not null,
    modify_dttm    timestamptz        default now() not null,
    foreign key (client_id) references client (client_id),
    foreign key (currency_id) references currency (currency_id)
);

comment on table account is 'Аккаунты';

create sequence transaction_seq start 1 increment 1;

create table transaction
(
    transaction_id   bigint primary key default nextval('transaction_seq'::regclass),
    account_id       bigint                           not null,
    currency_id      bigint                           not null,
    amount           decimal(15, 2)                   not null,
    transaction_type varchar(20)                      not null,
    description      varchar(255),
    create_dttm      timestamptz        default now() not null,
    modify_dttm      timestamptz        default now() not null,
    foreign key (account_id) references account (account_id),
    foreign key (currency_id) references currency (currency_id)
);

comment on table transaction is 'Транзакции';

create sequence transaction_audit_seq
    start 1
    increment 1;

create table transaction_audit
(
    audit_id         bigint primary key default nextval('transaction_audit_seq'::regclass),

    transaction_id   bigint          not null,
    amount           decimal(15, 2) not null,
    transaction_type varchar(20)    not null,

    created_dttm     timestamptz default now() not null,

    foreign key (transaction_id)
        references transaction (transaction_id)
);

comment on table transaction_audit is 'Аудит финансовых транзакций';

create sequence monthly_client_report_seq
    start 1
    increment 1;

create table monthly_client_report
(
    id                 bigint primary key default nextval('monthly_client_report_seq'::regclass),

    client_id          bigint           not null,

    period_from        date             not null,
    period_to          date             not null,

    total_income       decimal(15, 2) default 0 not null,
    total_expense      decimal(15, 2) default 0 not null,

    transaction_count  bigint default 0 not null,

    generated_at       timestamptz default now() not null,

    foreign key (client_id)
        references client (client_id)
);

comment on table monthly_client_report is 'Ежемесячные финансовые отчёты клиентов';