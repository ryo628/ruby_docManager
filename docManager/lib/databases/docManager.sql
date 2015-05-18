
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
  note text,
  list_header text,
  list_row text,
  edit_form text,
  show_form text
);

ALTER TABLE doctypes ADD COLUMN list_header text;
ALTER TABLE doctypes ADD COLUMN list_row text;
ALTER TABLE doctypes ADD COLUMN edit_form text;
ALTER TABLE doctypes ADD COLUMN show_form text;

DROP TABLE `docgroups`;
CREATE TABLE `docgroups`(
  id integer primary key,
  doctype_id integer,
  docgroup_id integer,
  name text,
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

CREATE TABLE `docusers`(
  id integer primary key,
  name text,
  password text,
  auth_type text
);

INSERT INTO docusers (id,name,auth_type) VALUES (1,"admin","admin");
INSERT INTO docusers (id,name,auth_type) VALUES (2,"user","user");
INSERT INTO docusers (id,name,auth_type) VALUES (3,"guest","guest");

