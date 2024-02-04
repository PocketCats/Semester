CREATE TABLE "subjects" (
  "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "title" varchar(100) NOT NULL,
  "start_date" timestamp,
  "finish_date" timestamp
);

CREATE TABLE "professors" (
  "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "subject_id" integer NOT NULL,
  "name" varchar(20) NOT NULL,
  "surname" varchar(20) NOT NULL,
  "middlename" varchar(20) DEFAULT null,
  "position" varchar(100) DEFAULT null
);

CREATE TABLE "students" (
  "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "name" varchar(20) NOT NULL,
  "surname" varchar(20) NOT NULL,
  "middlename" varchar(20) DEFAULT null
);

CREATE TABLE "participations" (
  "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "student_id" integer NOT NULL,
  "subject_id" integer NOT NULL
);

CREATE TABLE "assistants" (
  "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "student_id" integer NOT NULL,
  "subject_id" integer NOT NULL
);

CREATE TABLE "segments" (
  "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "subject_id" integer NOT NULL,
  "title" varchar(100) NOT NULL,
  "start_date" timestamp,
  "finish_date" timestamp
);

CREATE TABLE "steps" (
  "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "segment_id" integer NOT NULL,
  "body" text
);

CREATE TABLE "attachments" (
  "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "step_id" integer NOT NULL,
  "type" varchar NOT NULL,
  "link" varchar NOT NULL
);

ALTER TABLE "professors" ADD FOREIGN KEY ("id") REFERENCES "subjects" ("id");

ALTER TABLE "segments" ADD FOREIGN KEY ("subject_id") REFERENCES "subjects" ("id");

ALTER TABLE "steps" ADD FOREIGN KEY ("segment_id") REFERENCES "segments" ("id");

ALTER TABLE "attachments" ADD FOREIGN KEY ("step_id") REFERENCES "steps" ("id");

ALTER TABLE "participations" ADD FOREIGN KEY ("subject_id") REFERENCES "subjects" ("id");

ALTER TABLE "participations" ADD FOREIGN KEY ("student_id") REFERENCES "students" ("id");

ALTER TABLE "assistants" ADD FOREIGN KEY ("subject_id") REFERENCES "subjects" ("id");

ALTER TABLE "assistants" ADD FOREIGN KEY ("student_id") REFERENCES "students" ("id");
