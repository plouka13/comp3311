-- COMP3311 20T3 Assignment 1
-- Calendar schema
-- Written by Peter Louka, z5207453
-- Sept-Oct 2020

-- Types

create type Accessibility_Type as enum ('read-write','read-only','none');
create type Status_type as enum ('invited','accepted','declined');
create type Visibility_Type as enum ('public', 'private');
create type Day_of_Week_Type as enum ('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun');

-- Tables based on Entities

create table Users (
	id				serial,
	name			text not null,
	email			text not null unique,
	passwd			text not null,
	is_admin		boolean default false not null,

	primary key (id)
);

create table Groups (
	id				serial,
	name			text not null,
	owner			integer not null,

	foreign key (owner) references Users(id),
	primary key (id)
);

create table Calendars (
	id				serial,
	name			text not null,
	colour			text not null,
	default_access	Accessibility_Type default 'none' not null,
	owner			integer not null,

	foreign key (owner) references Users(id),
	primary key (id)
);

create table Events (
	id				serial,
	title			text not null,
	location		text, 
	visibility		Visibility_Type default 'private' not null,
	start_time		time,
	end_time		time,
	part_of			integer not null,
	created_by		integer not null,

	foreign key (part_of) references Calendars(id),
	foreign key (created_by) references Users(id),
	primary key (id)
);

create table One_Day_Events (
	date date 		not null,
	event_id 		integer not null,

	foreign key (event_id) references Events(id)
);

create table Spanning_Events (
	start_date 		date not null,
	end_date 		date not null,
	event_id 		integer not null,

	foreign key (event_id) references Events(id)
);

create table Recurring_Events (
	ntimes 			integer,
	start_date 		date not null,
	end_date 		date,
	event_id 		integer not null,

	foreign key (event_id) references Events(id)
);

create table Weekly_Events (
	day_of_week Day_of_Week_Type not null,
	frequency integer check (frequency > 0) not null,
	recurring_event_id integer not null,

	foreign key (recurring_event_id) references Events(id)
);

create table Monthly_By_Day_Events (
	day_of_week Day_of_Week_Type not null,
	week_in_month integer check (week_in_month >= 1 and week_in_month <= 5) not null,
	recurring_event_id integer not null,

	foreign key (recurring_event_id) references Events(id)
);

create table Monthly_By_Date_Events (
	date_in_month integer check (date_in_month >= 1 and date_in_month <= 31) not null,
	recurring_event_id integer not null,

	foreign key (recurring_event_id) references Events(id)
);

create table Annual_Events (
	date date not null,
	recurring_event_id integer not null,

	foreign key (recurring_event_id) references Events(id)
);

-- Tables based on relationships

create table Member (
	user_id		integer references Users(id),
	group_id	integer references Groups(id),
	
	primary key (user_id, group_id)
);

create table Subscribed (
	calendar_id integer references Calendars(id),
	user_id integer references Users(id),
	colour text,

	primary key (calendar_id, user_id)
);

create table Accessibility (
	calendar_id integer references Calendars(id),
	user_id integer references Users(id),
	access Accessibility_Type default 'none' not null,

	primary key (calendar_id, user_id)
);

create table Invited (
	event_id integer references Events(id),
	user_id integer references Users(id),
	status Status_type not null,

	primary key (event_id, user_id)
);

create table Alarms (
	event_id integer references Events(id),
	alarm integer not null,

	primary key (event_id, alarm)
);

