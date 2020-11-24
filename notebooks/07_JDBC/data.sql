drop table if exists gtfs_agency cascade;
drop table if exists gtfs_stops cascade;
drop table if exists gtfs_routes cascade;
drop table if exists gtfs_calendar cascade;
drop table if exists gtfs_calendar_dates cascade;
drop table if exists gtfs_fare_attributes cascade;
drop table if exists gtfs_fare_rules cascade;
drop table if exists gtfs_shapes cascade;
drop table if exists gtfs_trips cascade;
drop table if exists gtfs_stop_times cascade;
drop table if exists gtfs_frequencies cascade;

drop table if exists gtfs_transfers cascade;
drop table if exists gtfs_feed_info cascade;

drop table if exists gtfs_route_types cascade;
drop table if exists gtfs_directions cascade;
drop table if exists gtfs_pickup_dropoff_types cascade;
drop table if exists gtfs_payment_methods cascade;

drop table if exists gtfs_location_types cascade;
drop table if exists gtfs_transfer_types cascade;

drop table if exists service_combo_ids cascade;
drop table if exists service_combinations cascade;

-- PRAGMA foreign_keys = OFF;

begin;

create table gtfs_agency (
  agency_id    int PRIMARY KEY,--PRIMARY KEY,
  agency_name  text NOT NULL,--NOT NULL,
  agency_url   text NOT NULL,--NOT NULL,
  agency_timezone    text NOT NULL,--NOT NULL,
  agency_lang  text,
  -- unofficial features
  agency_phone text
--, fare_url text
) AS SELECT * FROM CSVREAD('/notebooks/07_JDBC/data/agency.txt');

--unoffical table, related to gtfs_stops(location_type)
create table gtfs_location_types (
  location_type int PRIMARY KEY,
  description text
);

insert into gtfs_location_types(location_type, description) 
       values (0,'stop');
insert into gtfs_location_types(location_type, description) 
       values (1,'station');
insert into gtfs_location_types(location_type, description) 
       values (2,'station entrance');


create table gtfs_stops (
  stop_id    int PRIMARY KEY,--PRIMARY KEY,
  stop_code  text,
  stop_name  text NOT NULL, --NOT NULL,
  stop_lat   double precision,
  stop_lon   double precision,
  location_type int --FOREIGN KEY REFERENCES gtfs_location_types(location_type)
) AS SELECT * FROM CSVREAD('/notebooks/07_JDBC/data/stops.txt');

-- select AddGeometryColumn( 'gtfs_stops', 'location', #{WGS84_LATLONG_EPSG}, 'POINT', 2 );
-- CREATE INDEX gtfs_stops_location_ix ON gtfs_stops USING GIST ( location GIST_GEOMETRY_OPS );

create table gtfs_route_types (
  route_type int PRIMARY KEY,
  description text
);

insert into gtfs_route_types (route_type, description) values (0, 'Street Level Rail');
insert into gtfs_route_types (route_type, description) values (1, 'Underground Rail');
insert into gtfs_route_types (route_type, description) values (2, 'Intercity Rail');
insert into gtfs_route_types (route_type, description) values (3, 'Bus');
insert into gtfs_route_types (route_type, description) values (4, 'Ferry');
insert into gtfs_route_types (route_type, description) values (5, 'Cable Car');
insert into gtfs_route_types (route_type, description) values (6, 'Suspended Car');
insert into gtfs_route_types (route_type, description) values (7, 'Steep Incline Mode');


create table gtfs_routes (
  route_id    varchar PRIMARY KEY,--PRIMARY KEY,
  agency_id   int , --REFERENCES gtfs_agency(agency_id),
  route_short_name  text DEFAULT '',
  route_long_name   text DEFAULT '',
  route_type  int , --REFERENCES gtfs_route_types(route_type),
  FOREIGN KEY (agency_id) REFERENCES gtfs_agency(agency_id),
  FOREIGN KEY (route_type) REFERENCES gtfs_route_types(route_type)
)  AS SELECT * FROM CSVREAD('/notebooks/07_JDBC/data/routes.txt');

create table gtfs_directions (
  direction_id int PRIMARY KEY,
  description text
);

insert into gtfs_directions (direction_id, description) values (0,'This way');
insert into gtfs_directions (direction_id, description) values (1,'That way');


create table gtfs_pickup_dropoff_types (
  type_id int PRIMARY KEY,
  description text
);

insert into gtfs_pickup_dropoff_types (type_id, description) values (0,'Regularly Scheduled');
insert into gtfs_pickup_dropoff_types (type_id, description) values (1,'Not available');
insert into gtfs_pickup_dropoff_types (type_id, description) values (2,'Phone arrangement only');
insert into gtfs_pickup_dropoff_types (type_id, description) values (3,'Driver arrangement only');



-- CREATE INDEX gst_trip_id_stop_sequence ON gtfs_stop_times (trip_id, stop_sequence);

create table gtfs_calendar (
  service_id   varchar PRIMARY KEY,--PRIMARY KEY,
  monday int NOT NULL, --NOT NULL,
  tuesday int NOT NULL, --NOT NULL,
  wednesday    int NOT NULL, --NOT NULL,
  thursday     int NOT NULL, --NOT NULL,
  friday int NOT NULL, --NOT NULL,
  saturday     int NOT NULL, --NOT NULL,
  sunday int NOT NULL, --NOT NULL,
  start_date   date NOT NULL, --NOT NULL,
  end_date     date NOT NULL --NOT NULL
) AS SELECT * FROM CSVREAD('/notebooks/07_JDBC/data/calendar.txt');

create table gtfs_calendar_dates (
  service_id     varchar , --REFERENCES gtfs_calendar(service_id),
  date     date NOT NULL, --NOT NULL,
  exception_type int  NOT NULL--NOT NULL
  -- above reference not in makeindices.sql
);

-- The following two tables are not in the spec, but they make dealing with dates and services easier
create table service_combo_ids
(
combination_id serial --primary key
);
create table service_combinations
(
combination_id int , --references service_combo_ids(combination_id),
service_id int --references gtfs_calendar(service_id)
);


create table gtfs_payment_methods (
  payment_method int PRIMARY KEY,
  description text
);

insert into gtfs_payment_methods (payment_method, description) values (0,'On Board');
insert into gtfs_payment_methods (payment_method, description) values (1,'Prepay');


create table gtfs_fare_attributes (
  fare_id     int PRIMARY KEY,--PRIMARY KEY,
  price double precision NOT NULL, --NOT NULL,
  currency_type     text NOT NULL, --NOT NULL,
  payment_method    int , --REFERENCES gtfs_payment_methods,
  transfers   int,
  transfer_duration int,
  agency_id int,  --REFERENCES gtfs_agency(agency_id),
  FOREIGN KEY (payment_method) REFERENCES gtfs_payment_methods(payment_method),
  FOREIGN KEY (agency_id) REFERENCES gtfs_agency(agency_id)
);

create table gtfs_fare_rules (
  fare_id     int , --REFERENCES gtfs_fare_attributes(fare_id),
  route_id    int , --REFERENCES gtfs_routes(route_id),
  origin_id   int ,
  destination_id int ,
  contains_id int 
  -- unofficial features
  ,
  service_id int, -- REFERENCES gtfs_calendar(service_id) ?
  FOREIGN KEY (fare_id) REFERENCES gtfs_fare_attributes(fare_id),
  FOREIGN KEY (route_id) REFERENCES gtfs_routes(route_id)

);

create table gtfs_shapes (
  shape_id    int NOT NULL, --NOT NULL,
  shape_pt_lat double precision NOT NULL, --NOT NULL,
  shape_pt_lon double precision NOT NULL, --NOT NULL,
  shape_pt_sequence int NOT NULL, --NOT NULL,
  shape_dist_traveled double precision
);

create table gtfs_trips (
 route_id varchar , --REFERENCES gtfs_routes(route_id),
  service_id    varchar , --REFERENCES gtfs_calendar(service_id),
  trip_id int PRIMARY KEY,--PRIMARY KEY,
  trip_headsign text,
  direction_id  int NOT NULL, --NOT NULL --REFERENCES gtfs_directions(direction_id),
  shape_id int,
  block_id int,
  wheelchair_accessible int,
  bikes_allowed int ,
  FOREIGN KEY (route_id) REFERENCES gtfs_routes(route_id),
  FOREIGN KEY (direction_id) REFERENCES gtfs_directions(direction_id)
) AS SELECT * FROM CSVREAD('/notebooks/07_JDBC/data/trips.txt');

create table gtfs_stop_times (
    trip_id int , --REFERENCES gtfs_trips(trip_id),
  arrival_time text, -- CHECK (arrival_time LIKE '__:__:__'),
  departure_time text, -- CHECK (departure_time LIKE '__:__:__'),
  stop_id int , --REFERENCES gtfs_stops(stop_id),
  stop_sequence int NOT NULL, --NOT NULL,
  pickup_type   int , --REFERENCES gtfs_pickup_dropoff_types(type_id),
  drop_off_type int , --REFERENCES gtfs_pickup_dropoff_types(type_id),
  
  FOREIGN KEY (trip_id) REFERENCES gtfs_trips(trip_id),
  FOREIGN KEY (stop_id) REFERENCES gtfs_stops(stop_id),
  FOREIGN KEY (pickup_type) REFERENCES gtfs_pickup_dropoff_types(type_id),
  FOREIGN KEY (drop_off_type) REFERENCES gtfs_pickup_dropoff_types(type_id),
  CHECK (arrival_time LIKE '__:__:__'),
  CHECK (departure_time LIKE '__:__:__')
) AS SELECT * FROM CSVREAD('/notebooks/07_JDBC/data/stop_times.txt');

-- create index arr_time_index on gtfs_stop_times(arrival_time_seconds);
-- create index dep_time_index on gtfs_stop_times(departure_time_seconds);
create index stop_seq_index on gtfs_stop_times(trip_id,stop_sequence);

-- select AddGeometryColumn( 'gtfs_shapes', 'shape', #{WGS84_LATLONG_EPSG}, 'LINESTRING', 2 );

create table gtfs_frequencies (
  trip_id     int , --REFERENCES gtfs_trips(trip_id),
  start_time  text NOT NULL, --NOT NULL,
  end_time    text NOT NULL, --NOT NULL,
  headway_secs int NOT NULL, --NOT NULL
  start_time_seconds int,
  end_time_seconds int,
  FOREIGN KEY (trip_id) REFERENCES gtfs_trips(trip_id)
);





-- unofficial tables


create table gtfs_transfer_types (
  transfer_type int PRIMARY KEY,
  description text
);

insert into gtfs_transfer_types (transfer_type, description) 
       values (0,'Preferred transfer point');
insert into gtfs_transfer_types (transfer_type, description) 
       values (1,'Designated transfer point');
insert into gtfs_transfer_types (transfer_type, description) 
       values (2,'Transfer possible with min_transfer_time window');
insert into gtfs_transfer_types (transfer_type, description) 
       values (3,'Transfers forbidden');


create table gtfs_transfers (
  from_stop_id int, --REFERENCES gtfs_stops(stop_id)
  to_stop_id int, --REFERENCES gtfs_stops(stop_id)
  transfer_type int, --REFERENCES gtfs_transfer_types(transfer_type)
  min_transfer_time int,
  from_route_id int, --REFERENCES gtfs_routes(route_id)
  to_route_id int, --REFERENCES gtfs_routes(route_id)
  service_id int, --REFERENCES gtfs_calendar(service_id) ?
  FOREIGN KEY (from_stop_id) REFERENCES gtfs_stops(stop_id),

  FOREIGN KEY (to_stop_id) REFERENCES gtfs_stops(stop_id),
  FOREIGN KEY (transfer_type) REFERENCES gtfs_transfer_types(transfer_type),
  FOREIGN KEY (from_route_id) REFERENCES gtfs_routes(route_id),
  FOREIGN KEY (to_route_id) REFERENCES gtfs_routes(route_id)
);


create table gtfs_feed_info (
  feed_publisher_name text,
  feed_publisher_url text,
  feed_timezone text,
  feed_lang text,
  feed_version text
);



commit;
