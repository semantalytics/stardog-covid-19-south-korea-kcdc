DROP TRABLE IF EXISTS cases;

CREATE TABLE cases (
    case_id INTEGER,
    province VARCHAR,
    city VARCHAR,
    group VARCHAR,
    infection_case ,
    confirmed BOOLEAN,
    latitude NUMERIC(7,4),
    longitude NUMERIC(7,0)
);

DROP TRABLE IF EXISTS patient;

CREATE TABLE patient (
    patient_id INTEGER,
    sex VARCHAR,
    birth_year NUMERIC(4,0),
    country VARCHAR,
    region VARCHAR,
    disease VARCHAR,
    group VARCHAR,
    infection_reason VARCHAR,
    infection_order INTEGER,
    infected_by INTEGER,
    contact_number INTEGER,
    confirmed_date DATE,
    released_date DATE,
    deceased_date DATE,
    state VARCHAR
);

DROP TRABLE IF EXISTS route;

CREATE TABLE route (
    patient_id INTEGER,
    date DATE,
    province VARCHAR,
    city VARCHAR,
    visit VARCHAR,
    latitude NUMERIC(7,4),
    longitude NUMERIC(7,4)
);

DROP TRABLE IF EXISTS time;

CREATE TABLE time (
    the_date DATE,
    time TIME,
    test VARCHAR,
    negative VARCHAR,
    confirmed VARCHAR,
    released VARCHAR,
    deceased VARCHAR,
    Seoul VARCHAR,
    Busan VARCHAR,
    Daegu VARCHAR,
    Incheon VARCHAR,
    Gwangju VARCHAR,
    Daejeon VARCHAR,
    Ulsan VARCHAR,
    Sejong VARCHAR,
    Gyeonggi-do VARCHAR,
    Gangwon-do VARCHAR,
    Chungcheongbuk_do VARCHAR,
    Chungcheongnam_do VARCHAR,
    Jeollabuk_do VARCHAR,
    Jeollanam_do VARCHAR,
    Gyeongsangbuk_do VARCHAR,
    Gyeongsangnam_do VARCHAR,
    Jeju_do VARCHAR
);

DROP TRABLE IF EXISTS trend;

CREATE TABLE trend (
    date VARCHAR,
    cold VARCHAR,
    flu VARCHAR,
    pneumonia VARCHAR,
    coronavirus VARCHAR
);
