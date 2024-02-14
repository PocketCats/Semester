BEGIN;

ALTER TABLE "assistants" DROP CONSTRAINT "assistants_student_id_fkey";
ALTER TABLE "assistants" DROP CONSTRAINT "assistants_subject_id_fkey";
ALTER TABLE "participations" DROP CONSTRAINT "participations_student_id_fkey";
ALTER TABLE "participations" DROP CONSTRAINT "participations_subject_id_fkey";
ALTER TABLE "attachments" DROP CONSTRAINT "attachments_step_id_fkey";
ALTER TABLE "steps" DROP CONSTRAINT "steps_segment_id_fkey";
ALTER TABLE "segments" DROP CONSTRAINT "segments_subject_id_fkey";
ALTER TABLE "professors" DROP CONSTRAINT "professors_id_fkey";

DROP TABLE "attachments";
DROP TABLE "steps";
DROP TABLE "segments";
DROP TABLE "assistants";
DROP TABLE "participations";
DROP TABLE "students";
DROP TABLE "professors";
DROP TABLE "subjects";

COMMIT;
