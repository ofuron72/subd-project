CREATE TABLE person_no_index (
                                 id BIGSERIAL PRIMARY KEY,
                                 name TEXT,
                                 salary INT,
                                 age INT,
                                 gender TEXT
);

CREATE TABLE person_with_index (
                                   id BIGSERIAL PRIMARY KEY,
                                   name TEXT,
                                   salary INT,
                                   age INT,
                                   gender TEXT
);