
CREATE TABLE `doctypes`(
  id integer primary key,
  name text,
  num integer,
  item01 text,
  item02 text,
  item03 text,
  item04 text,
  item05 text,
  item06 text,
  item07 text,
  item08 text,
  item09 text,
  item10 text,
  item11 text,
  item12 text,
  item13 text,
  item14 text,
  item15 text,
  item16 text,
  item17 text,
  item18 text,
  item19 text,
  item20 text,
  note text
);

CREATE TABLE `docgroups`(
  id integer primary key,
  name text,
  docgroup_id integer,
  num integer,
  note text
);

CREATE TABLE `docdatas`(
  id integer primary key,
  title text,
  docgroup_id integer,
  num integer,
  item01 text,
  item02 text,
  item03 text,
  item04 text,
  item05 text,
  item06 text,
  item07 text,
  item08 text,
  item09 text,
  item10 text,
  item11 text,
  item12 text,
  item13 text,
  item14 text,
  item15 text,
  item16 text,
  item17 text,
  item18 text,
  item19 text,
  item20 text
);

