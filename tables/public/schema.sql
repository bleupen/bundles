CREATE OR REPLACE FUNCTION delete_schedule()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN DELETE FROM schedule WHERE id = OLD."scheduleId"; RETURN OLD; END; $function$
;
CREATE OR REPLACE FUNCTION delete_orphan_datasource()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN DELETE FROM datasource WHERE id = OLD."datasourceId" AND tenant = OLD.tenant AND embedded AND (select count(*) from dataset where "datasourceId" = OLD."datasourceId" and tenant = OLD.tenant) = 0; RETURN OLD; END; $function$
;
CREATE OR REPLACE FUNCTION delete_file_lob()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
BEGIN 
 PERFORM lo_unlink(lo.oid) FROM pg_largeobject_metadata lo WHERE lo.oid = OLD."lobId";
RETURN OLD; 
END; 
$function$
;
CREATE OR REPLACE FUNCTION update_principal_id()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN NEW.id = coalesce(NEW."userId", NEW."teamId"); RETURN NEW; END; $function$
;
CREATE OR REPLACE FUNCTION comment_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
                 DECLARE
                    etag bigint;
                BEGIN 
                    SELECT nextval('comment_etag') INTO etag; 
                    RETURN NEW; 
                END; $function$
;
CREATE OR REPLACE FUNCTION dataset_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
                 DECLARE
                    etag bigint;
                BEGIN 
                    SELECT nextval('dataset_etag') INTO etag; 
                    RETURN NEW; 
                END; $function$
;
CREATE OR REPLACE FUNCTION datasource_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
                 DECLARE
                    etag bigint;
                BEGIN 
                    SELECT nextval('datasource_etag') INTO etag; 
                    RETURN NEW; 
                END; $function$
;
CREATE OR REPLACE FUNCTION map_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
                 DECLARE
                    etag bigint;
                BEGIN 
                    SELECT nextval('map_etag') INTO etag; 
                    RETURN NEW; 
                END; $function$
;
CREATE OR REPLACE FUNCTION mapping_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
                 DECLARE
                    etag bigint;
                BEGIN 
                    SELECT nextval('mapping_etag') INTO etag; 
                    RETURN NEW; 
                END; $function$
;
CREATE OR REPLACE FUNCTION query_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
                 DECLARE
                    etag bigint;
                BEGIN 
                    SELECT nextval('query_etag') INTO etag; 
                    RETURN NEW; 
                END; $function$
;
CREATE OR REPLACE FUNCTION report_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
                 DECLARE
                    etag bigint;
                BEGIN 
                    SELECT nextval('report_etag') INTO etag; 
                    RETURN NEW; 
                END; $function$
;
CREATE OR REPLACE FUNCTION team_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
                 DECLARE
                    etag bigint;
                BEGIN 
                    SELECT nextval('team_etag') INTO etag; 
                    RETURN NEW; 
                END; $function$
;
CREATE OR REPLACE FUNCTION saved_query_filter_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
                 DECLARE
                    etag bigint;
                BEGIN 
                    SELECT nextval('saved_query_filter_etag') INTO etag; 
                    RETURN NEW; 
                END; $function$
;
CREATE OR REPLACE FUNCTION job_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
         DECLARE
            etag bigint;
        BEGIN 
            SELECT nextval('job_etag') INTO etag; 
            RETURN NEW; 
        END; $function$
;
CREATE OR REPLACE FUNCTION user_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
                 DECLARE
                    etag bigint;
                BEGIN 
                    SELECT nextval('user_etag') INTO etag; 
                    RETURN NEW; 
                END; $function$
;
CREATE OR REPLACE FUNCTION visual_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
                 DECLARE
                    etag bigint;
                BEGIN 
                    SELECT nextval('visual_etag') INTO etag; 
                    RETURN NEW; 
                END; $function$
;
CREATE OR REPLACE FUNCTION dataset_share_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
                 DECLARE
                    etag bigint;
                BEGIN 
                    SELECT nextval('dataset_etag') INTO etag; 
                    RETURN NEW; 
                END; $function$
;
CREATE OR REPLACE FUNCTION report_share_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
                 DECLARE
                    etag bigint;
                BEGIN 
                    SELECT nextval('report_etag') INTO etag; 
                    RETURN NEW; 
                END; $function$
;
CREATE OR REPLACE FUNCTION query_share_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
                 DECLARE
                    etag bigint;
                BEGIN 
                    SELECT nextval('query_etag') INTO etag; 
                    RETURN NEW; 
                END; $function$
;
CREATE OR REPLACE FUNCTION datasource_share_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
                 DECLARE
                    etag bigint;
                BEGIN 
                    SELECT nextval('datasource_etag') INTO etag; 
                    RETURN NEW; 
                END; $function$
;
CREATE OR REPLACE FUNCTION dataset_filter_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
                 DECLARE
                    etag bigint;
                BEGIN 
                    SELECT nextval('dataset_filter_etag') INTO etag; 
                    RETURN NEW; 
                END; $function$
;
CREATE OR REPLACE FUNCTION delete_expired_sessions()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN
                DELETE FROM session WHERE "expiresAt" is not null and "expiresAt" < now();
                RETURN NULL;
            END; $function$
;
CREATE OR REPLACE FUNCTION update_session_expiration()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN
                IF NEW."lastAccessedAt" > OLD."lastAccessedAt" AND NEW.ttl IS NOT NULL THEN
                   NEW."expiresAt" = NEW."lastAccessedAt" + NEW.ttl * interval '0.001' second;
                END IF;
                RETURN NEW;
            END; $function$
;
CREATE OR REPLACE FUNCTION admin_force_enabled()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN RAISE EXCEPTION 'Administrator cannot be disabled'; RETURN NEW; END; $function$
;
CREATE OR REPLACE FUNCTION tag_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
         DECLARE
            etag bigint;
        BEGIN 
            SELECT nextval('tag_etag') INTO etag; 
            RETURN NEW; 
        END; $function$
;
CREATE OR REPLACE FUNCTION tag_entity_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
         DECLARE
            etag bigint;
        BEGIN 
            SELECT nextval('dataset_etag'), nextval('report_etag'), nextval('query_etag') INTO etag; 
            RETURN NEW; 
        END; $function$
;
CREATE OR REPLACE FUNCTION color_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
         DECLARE
            etag bigint;
        BEGIN 
            SELECT nextval('color_etag') INTO etag; 
            RETURN NEW; 
        END; $function$
;
CREATE OR REPLACE FUNCTION job_history_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
         DECLARE
            etag bigint;
        BEGIN 
            SELECT nextval('job_etag') INTO etag; 
            RETURN NEW; 
        END; $function$
;
CREATE OR REPLACE FUNCTION records(name, name)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
            declare
	            records integer;
            BEGIN
                EXECUTE format('SELECT count(*) FROM %I.%I', $1, $2) INTO records;
                RETURN records;
            END;
            $function$
;
CREATE OR REPLACE FUNCTION team_member_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
                 DECLARE
                    etag bigint;
                BEGIN 
                    SELECT nextval('team_etag') INTO etag; 
                    RETURN NEW; 
                END; $function$
;
CREATE OR REPLACE FUNCTION link_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
                 DECLARE
                    etag bigint;
                BEGIN 
                    SELECT nextval('link_etag'), nextval('mapping_etag') INTO etag; 
                    RETURN NEW; 
                END; $function$
;
CREATE OR REPLACE FUNCTION field_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
                 DECLARE
                    etag bigint;
                BEGIN 
                    SELECT nextval('field_etag') INTO etag; 
                    RETURN NEW; 
                END; $function$
;
CREATE OR REPLACE FUNCTION folder_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
         DECLARE
            etag bigint;
        BEGIN 
            SELECT nextval('folder_etag') INTO etag; 
            RETURN NEW; 
        END; $function$
;
CREATE OR REPLACE FUNCTION update_tenant()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = quote_ident(NEW.id)) THEN
            EXECUTE 'CREATE USER ' || quote_ident(NEW.id) || ' IN ROLE tenant';
        END IF;
        EXECUTE 'REASSIGN OWNED BY ' || quote_ident(OLD.id) || ' TO ' || quote_ident(NEW.id);
        RETURN NEW;
    END;
$function$
;
CREATE OR REPLACE FUNCTION create_tenant()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN
        IF NOT EXISTS (
            SELECT                       -- SELECT list can stay empty for this
            FROM   pg_catalog.pg_user
            WHERE  usename = NEW.id)
         THEN
            EXECUTE 'CREATE USER ' || quote_ident(NEW.id) || ' IN ROLE tenant';
         END IF;
         
         INSERT INTO domain (id, tenant, type, "createdAt", "updatedAt") values ('local', NEW.id, 'local', now(), now()) on conflict on constraint domain_pkey do nothing;
            
         RETURN NEW;
    END; 
    $function$
;
CREATE OR REPLACE FUNCTION create_user_principal()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
        INSERT INTO principal (tenant, id, "userId") VALUES (NEW.tenant, NEW.username, NEW.username);
        RETURN NEW;
    END; 
    $function$
;
CREATE OR REPLACE FUNCTION create_team_principal()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
    BEGIN 
        INSERT INTO principal (tenant, id, "teamId") VALUES (NEW.tenant, NEW.id, NEW.id); RETURN NEW;
     END; 
     $function$
;
CREATE OR REPLACE FUNCTION slugify(value text, allow_unicode boolean)
 RETURNS text
 LANGUAGE sql
 IMMUTABLE STRICT
AS $function$

  WITH "normalized" AS (
    SELECT CASE
      WHEN "allow_unicode" THEN "value"
      ELSE unaccent("value")
    END AS "value"
  ),
  "remove_chars" AS (
    SELECT regexp_replace("value", E'[^\\w\\s-]', '', 'gi') AS "value"
    FROM "normalized"
  ),
  "lowercase" AS (
    SELECT lower("value") AS "value"
    FROM "remove_chars"
  ), 
  "trimmed" AS (
    SELECT trim("value") AS "value"
    FROM "lowercase"
  ),
  "hyphenated" AS (
    SELECT regexp_replace("value", E'[-\\s]+', '-', 'gi') AS "value"
    FROM "trimmed"
  )
  SELECT "value" FROM "hyphenated";

$function$
;
CREATE OR REPLACE FUNCTION fn_ranked_job_history(job_id uuid, new_id uuid DEFAULT gen_random_uuid())
 RETURNS TABLE(id uuid, rank bigint)
 LANGUAGE sql
AS $function$ SELECT h.id, row_number() OVER (PARTITION BY h."jobId" ORDER BY h."updatedAt" DESC) as "rank" FROM job_history h WHERE h.id <> new_id AND h."jobId" = job_id; $function$
;
CREATE OR REPLACE FUNCTION limit_job_history()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN DELETE FROM job_history jh WHERE jh.id IN ( SELECT rjh.id FROM fn_ranked_job_history(NEW."jobId", NEW.id) rjh WHERE rjh.rank >= (SELECT COALESCE(s."jobHistorySize", 200) FROM tenant s WHERE s.id = NEW.tenant) ); RETURN NEW; END; $function$
;
CREATE OR REPLACE FUNCTION prune_all_job_histories()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ DECLARE jh_record RECORD; BEGIN FOR jh_record IN SELECT "jobId", COUNT(*) FROM job_history GROUP BY "jobId" HAVING COUNT(*) > NEW."jobHistorySize" ORDER BY "jobId" LOOP DELETE FROM job_history jh WHERE jh.id IN ( SELECT rjh.id FROM fn_ranked_job_history(jh_record."jobId") rjh WHERE rjh.rank > COALESCE(NEW."jobHistorySize", 200) ); END LOOP; RETURN NEW; END; $function$
;
CREATE OR REPLACE FUNCTION drop_workspace_schema()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN
        EXECUTE 'DROP SCHEMA IF EXISTS "' || OLD.id || ':' || OLD.tenant || '" CASCADE';
        RETURN OLD;
    END;
$function$
;
CREATE OR REPLACE FUNCTION delete_datasource()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN
        DELETE FROM file WHERE id = OLD."fileId" AND embedded AND tenant = OLD.tenant;
        RETURN OLD;
    END;
$function$
;
CREATE OR REPLACE FUNCTION delete_orphan_query()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN DELETE FROM query WHERE id = OLD."queryId" AND tenant = OLD.tenant AND embedded; RETURN OLD; END; $function$
;
CREATE OR REPLACE FUNCTION delete_orphan_job_dataset()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN DELETE FROM dataset WHERE id = OLD."datasetId" AND tenant = OLD.tenant AND embedded AND (select count(*) from job_dataset where "datasetId" = OLD."datasetId" and tenant = OLD.tenant) = 0; RETURN OLD; END; $function$
;
CREATE OR REPLACE FUNCTION delete_orphan_job_file()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN DELETE FROM file WHERE id = OLD."fileId" AND tenant = OLD.tenant AND embedded AND (select count(*) from job_file where "fileId" = OLD."fileId" AND tenant = OLD.tenant) = 0; RETURN OLD; END; $function$
;
CREATE OR REPLACE FUNCTION insert_dataset_history()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN NEW._revision := (SELECT coalesce(max(_revision), 0) FROM dataset_history WHERE "_sourceId" = NEW."_sourceId" AND tenant = NEW.tenant) + 1; RETURN NEW; END; $function$
;
CREATE OR REPLACE FUNCTION insert_query_history()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN NEW._revision := (SELECT coalesce(max(_revision), 0) FROM query_history WHERE "_sourceId" = NEW."_sourceId" AND tenant = NEW.tenant) + 1; RETURN NEW; END; $function$
;
CREATE OR REPLACE FUNCTION insert_report_history()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN NEW._revision := (SELECT coalesce(max(_revision), 0) FROM report_history WHERE "_sourceId" = NEW."_sourceId" AND tenant = NEW.tenant) + 1; RETURN NEW; END; $function$
;
CREATE OR REPLACE FUNCTION update_datasource_owner()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN UPDATE datasource SET "ownerId" = NEW."ownerId" WHERE "id" = (SELECT "datasourceId" from query WHERE "id" = NEW."queryId" AND "tenant" = NEW."tenant" AND embedded) AND tenant = NEW.tenant AND embedded; RETURN OLD; END; $function$
;
CREATE OR REPLACE FUNCTION update_new_dataset_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN UPDATE dataset SET "updatedAt" = now() WHERE id = NEW."datasetId" AND tenant = NEW.tenant; RETURN NEW; END; $function$
;
CREATE OR REPLACE FUNCTION update_new_datasource_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN UPDATE datasource SET "updatedAt" = now() WHERE id = NEW."datasourceId" AND tenant = NEW.tenant; RETURN NEW; END; $function$
;
CREATE OR REPLACE FUNCTION update_new_query_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN UPDATE query SET "updatedAt" = now() WHERE id = NEW."queryId" AND tenant = NEW.tenant; RETURN NEW; END; $function$
;
CREATE OR REPLACE FUNCTION update_new_report_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN UPDATE report SET "updatedAt" = now() WHERE id = NEW."reportId" AND tenant = NEW.tenant; RETURN NEW; END; $function$
;
CREATE OR REPLACE FUNCTION update_old_dataset_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN UPDATE dataset SET "updatedAt" = now() WHERE id = OLD."datasetId" AND tenant = OLD.tenant; RETURN OLD; END; $function$
;
CREATE OR REPLACE FUNCTION update_old_datasource_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN UPDATE datasource SET "updatedAt" = now() WHERE id = OLD."datasourceId" AND tenant = OLD.tenant; RETURN OLD; END; $function$
;
CREATE OR REPLACE FUNCTION update_old_query_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN UPDATE query SET "updatedAt" = now() WHERE id = OLD."queryId" AND tenant = OLD.tenant; RETURN OLD; END; $function$
;
CREATE OR REPLACE FUNCTION update_old_report_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN UPDATE report SET "updatedAt" = now() WHERE id = OLD."reportId" AND tenant = OLD.tenant; RETURN OLD; END; $function$
;
CREATE OR REPLACE FUNCTION update_query_owner()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN UPDATE query SET "ownerId" = NEW."ownerId" WHERE "id" = OLD."queryId" AND tenant = OLD.tenant AND embedded; RETURN OLD; END; $function$
;
CREATE OR REPLACE FUNCTION update_tag_entity_add_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN
                UPDATE "dataset" SET "updatedAt" = now() WHERE tenant = NEW.tenant AND id = NEW."datasetId";
                UPDATE "report" SET "updatedAt" = now() WHERE tenant = NEW.tenant AND id = NEW."reportId";
                UPDATE "query" SET "updatedAt" = now() WHERE tenant = NEW.tenant AND id = NEW."queryId";
                RETURN NEW; END; $function$
;
CREATE OR REPLACE FUNCTION update_tag_entity_remove_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN
                UPDATE "dataset" SET "updatedAt" = now() WHERE tenant = OLD.tenant AND id = OLD."datasetId";
                UPDATE "report" SET "updatedAt" = now() WHERE tenant = OLD.tenant AND id = OLD."reportId";
                UPDATE "query" SET "updatedAt" = now() WHERE tenant = OLD.tenant AND id = OLD."queryId";
                RETURN OLD; END; $function$
;
CREATE OR REPLACE FUNCTION update_user_add_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN UPDATE "user" SET "updatedAt" = now() WHERE username = NEW."userId" AND tenant = NEW.tenant; RETURN NEW; END; $function$
;
CREATE OR REPLACE FUNCTION update_user_remove_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN UPDATE "user" SET "updatedAt" = now() WHERE username = OLD."userId" AND tenant = OLD.tenant; RETURN OLD; END; $function$
;
CREATE OR REPLACE FUNCTION tenant_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
         DECLARE
            etag bigint;
        BEGIN 
            SELECT nextval('tenant_etag') INTO etag; 
            RETURN NEW; 
        END; $function$
;
CREATE OR REPLACE FUNCTION update_suite_slug()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
        BEGIN
            NEW.slug = slugify(NEW.name, false);
            RETURN NEW;
        END;
    $function$
;
CREATE OR REPLACE FUNCTION suite_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
         DECLARE
            etag bigint;
        BEGIN 
            SELECT nextval('suite_etag') INTO etag; 
            RETURN NEW; 
        END; $function$
;
CREATE OR REPLACE FUNCTION ondelete_setnull_tenant_defaultdomainid_fkey()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
    BEGIN 
        UPDATE "tenant" SET "defaultDomainId" = NULL WHERE ("id", "defaultDomainId") IN (SELECT del."tenant", del."id" FROM "DELETED_domains" del);
        RETURN NULL;
    END; 
    $function$
;
CREATE OR REPLACE FUNCTION ondelete_setnull_tenant_defaultteamid_fkey()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
    BEGIN 
        UPDATE "tenant" SET "defaultTeamId" = NULL WHERE ("id", "defaultTeamId") IN (SELECT del."tenant", del."id" FROM "DELETED_teams" del);
        RETURN NULL;
    END; 
    $function$
;
CREATE OR REPLACE FUNCTION ondelete_setnull_dataset_field_fieldid_fkey()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
    BEGIN 
        UPDATE "dataset_field" SET "fieldId" = NULL WHERE ("tenant", "fieldId") IN (SELECT del."tenant", del."id" FROM "DELETED_fields" del);
        RETURN NULL;
    END; 
    $function$
;
CREATE OR REPLACE FUNCTION ondelete_setnull_dataset_folderid_fkey()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
    BEGIN 
        UPDATE "dataset" SET "folderId" = NULL WHERE ("tenant", "folderId") IN (SELECT del."tenant", del."id" FROM "DELETED_folders" del);
        RETURN NULL;
    END; 
    $function$
;
CREATE OR REPLACE FUNCTION ondelete_setnull_query_folderid_fkey()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
    BEGIN 
        UPDATE "query" SET "folderId" = NULL WHERE ("tenant", "folderId") IN (SELECT del."tenant", del."id" FROM "DELETED_folders" del);
        RETURN NULL;
    END; 
    $function$
;
CREATE OR REPLACE FUNCTION ondelete_setnull_report_folderid_fkey()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
    BEGIN 
        UPDATE "report" SET "folderId" = NULL WHERE ("tenant", "folderId") IN (SELECT del."tenant", del."id" FROM "DELETED_folders" del);
        RETURN NULL;
    END; 
    $function$
;
CREATE OR REPLACE FUNCTION ondelete_setnull_link_parentid_fkey()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
    BEGIN 
        UPDATE "link" SET "parentId" = NULL WHERE ("tenant", "parentId") IN (SELECT del."tenant", del."id" FROM "DELETED_links" del);
        RETURN NULL;
    END; 
    $function$
;
CREATE OR REPLACE FUNCTION ondelete_setnull_mapping_setid_fkey()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
    BEGIN 
        UPDATE "mapping" SET "setId" = NULL WHERE ("tenant", "setId") IN (SELECT del."tenant", del."id" FROM "DELETED_sets" del);
        RETURN NULL;
    END; 
    $function$
;
CREATE OR REPLACE FUNCTION ondelete_setnull_suite_default_partition()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
    BEGIN 
        UPDATE "suite" SET "defaultPartitionId" = NULL WHERE ("tenant", "defaultPartitionId") IN (SELECT del."tenant", del."id" FROM "DELETED_suite_partitions" del);
        RETURN NULL;
    END; 
    $function$
;
CREATE OR REPLACE FUNCTION ondelete_setnull_field_codeid_fkey()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
                BEGIN
                    UPDATE "field" SET "codeId" = NULL WHERE ("tenant", "codeId") IN (SELECT del."tenant", del."id" FROM "DELETED_codes" del);
                    RETURN NULL;
                END;
                $function$
;
CREATE OR REPLACE FUNCTION jsonb_deep_merge(original jsonb, current jsonb)
 RETURNS jsonb
 LANGUAGE sql
AS $function$
                SELECT
                jsonb_object_agg(
                    coalesce(oKey, cKey),
                    case
                        WHEN oValue isnull THEN cValue
                        WHEN cValue isnull THEN oValue
                        WHEN jsonb_typeof(oValue) <> 'object' or jsonb_typeof(cValue) <> 'object' THEN cValue
                        ELSE jsonb_deep_merge(oValue, cValue) END
                    )
                FROM jsonb_each(original) e1(oKey, oValue)
                FULL JOIN jsonb_each(current) e2(cKey, cValue) ON oKey = cKey
            $function$
;
CREATE OR REPLACE FUNCTION check_num_licensed_users()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ DECLARE _limit bigint; BEGIN SELECT INTO _limit cast(license ->> 'namedUsers' as bigint) FROM tenant WHERE id = NEW.tenant;  IF (((SELECT license ->> 'namedUsers' FROM tenant WHERE id = NEW.tenant) IS NULL) OR NOT NEW.enabled OR (TG_OP='UPDATE' AND OLD.enabled = NEW.enabled)) THEN RETURN NEW; END IF; IF (_limit <= (SELECT count(*) - 1 FROM "user" WHERE enabled = true AND tenant = NEW.tenant)) THEN RAISE EXCEPTION 'License allows only % users to be enabled', _limit; END IF; RETURN NEW; END; $function$
;
CREATE OR REPLACE FUNCTION clone_schema(source_schema text, dest_schema text, include_recs boolean)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

--  This function will clone all sequences, tables, data, views & functions from any existing schema to a new one
-- SAMPLE CALL:
-- SELECT clone_schema('public', 'new_schema', TRUE);

DECLARE
  src_oid          oid;
  tbl_oid          oid;
  func_oid         oid;
  object           text;
  buffer           text;
  srctbl           text;
  default_         text;
  column_          text;
  qry              text;
  dest_qry         text;
  v_def            text;
  seqval           bigint;
  sq_last_value    bigint;
  sq_max_value     bigint;
  sq_start_value   bigint;
  sq_increment_by  bigint;
  sq_min_value     bigint;
  sq_cache_value   bigint;
  sq_log_cnt       bigint;
  sq_is_called     boolean;
  sq_is_cycled     boolean;
  sq_cycled        char(10);

BEGIN

-- Check that source_schema exists
  SELECT oid INTO src_oid
    FROM pg_namespace
   WHERE nspname = quote_ident(source_schema);
  IF NOT FOUND
    THEN 
    RAISE NOTICE 'source schema % does not exist!', source_schema;
    RETURN ;
  END IF;

  -- Check that dest_schema does not yet exist
  PERFORM nspname 
    FROM pg_namespace
   WHERE nspname = quote_ident(dest_schema);
  IF FOUND
    THEN 
    RAISE NOTICE 'dest schema % already exists!', dest_schema;
    RETURN ;
  END IF;

  EXECUTE 'CREATE SCHEMA ' || quote_ident(dest_schema) ;

-- Create tables 
  FOR object IN
    SELECT TABLE_NAME::text 
      FROM information_schema.tables 
     WHERE table_schema = quote_ident(source_schema)
       AND table_type = 'BASE TABLE'

  LOOP
    buffer := quote_ident(dest_schema) || '.' || quote_ident(object);
    EXECUTE 'CREATE TABLE ' || buffer || ' (LIKE ' || quote_ident(source_schema) || '.' || quote_ident(object) 
        || ' INCLUDING ALL)';

    IF include_recs 
      THEN 
      -- Insert records from source table
      EXECUTE 'INSERT INTO ' || buffer || ' SELECT * FROM ' || quote_ident(source_schema) || '.' || quote_ident(object) || ';';
    END IF;
 
    FOR column_, default_ IN
      SELECT column_name::text, 
             REPLACE(column_default::text, quote_ident(source_schema) || '.', quote_ident(dest_schema || '.') )
        FROM information_schema.COLUMNS 
       WHERE table_schema = dest_schema 
         AND TABLE_NAME = object 
         AND column_default LIKE 'nextval(%' || quote_ident(source_schema) || '%::regclass)'
    LOOP
      EXECUTE 'ALTER TABLE ' || buffer || ' ALTER COLUMN ' || column_ || ' SET DEFAULT ' || default_;
    END LOOP;

  END LOOP;

--  add FK constraint
  FOR qry IN
    SELECT 'ALTER TABLE ' || quote_ident(dest_schema) || '.' || quote_ident(rn.relname) 
                          || ' ADD CONSTRAINT ' || quote_ident(ct.conname) || ' ' || REPLACE(pg_get_constraintdef(ct.oid), 'REFERENCES ', 'REFERENCES ' || quote_ident(dest_schema) || '.') || ';'
      FROM pg_constraint ct
      JOIN pg_class rn ON rn.oid = ct.conrelid
     WHERE connamespace = src_oid
       AND rn.relkind = 'r'
       AND ct.contype = 'f'
         
    LOOP
      EXECUTE qry;

    END LOOP;


-- Create views 
  FOR object IN
    SELECT table_name::text,
           view_definition 
      FROM information_schema.views
     WHERE table_schema = quote_ident(source_schema)

  LOOP
    buffer := quote_ident(dest_schema) || '.' || quote_ident(object);
    SELECT view_definition INTO v_def
      FROM information_schema.views
     WHERE table_schema = quote_ident(source_schema)
       AND table_name = quote_ident(object);
     
    EXECUTE 'CREATE OR REPLACE VIEW ' || buffer || ' AS ' || v_def || ';' ;

  END LOOP;

END;
 
$function$
;
CREATE OR REPLACE FUNCTION update_mapping_id()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN
  NEW.id=concat(NEW."datasourceId", ':', coalesce(NEW."schemaId" || '+' || NEW."mappingId", NEW."mappingId"));
  RETURN NEW; 
  
  END; 
  $function$
;
CREATE OR REPLACE FUNCTION update_field_id()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN
  NEW.id=concat(NEW."datasourceId", ':', coalesce(NEW."schemaId" || '+' || NEW."mappingId", NEW."mappingId"), ':', NEW."fieldId");
  RETURN NEW; 
  
  END; 
  $function$
;
CREATE OR REPLACE FUNCTION update_link_id()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN
  NEW.id=concat(NEW."fromId", ':', NEW."linkId");
  RETURN NEW; 
  
  END; 
  $function$
;
CREATE OR REPLACE FUNCTION update_query_datasource_idrefs()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN 
  UPDATE query SET payload=replace(payload::text, OLD.id::text, NEW.id::text)::jsonb;
  WITH patched_flows AS (SELECT id, array_agg(replace(step::text, OLD.id::text, NEW.id::text)::jsonb) AS flow FROM (SELECT id, unnest(flow) AS step FROM query) AS flows GROUP BY id)
  UPDATE query SET flow = patched_flows.flow FROM patched_flows WHERE query.id = patched_flows.id;
  RETURN NEW; 
  
  END; 
  $function$
;
CREATE OR REPLACE FUNCTION mapping_id(datasource text, schema text, mapping text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN concat("datasource", ':',  coalesce("schema" || '+' || "mapping", "mapping"));
END
$function$
;
CREATE OR REPLACE FUNCTION field_id(datasource text, schema text, mapping text, field text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN concat(mapping_id(datasource, schema, mapping), ':', field);
END
$function$
;
CREATE OR REPLACE FUNCTION unique_owner_slug(schema_name text, source text, i_tenant text, i_id uuid, i_owner text, i_slug text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE retval RECORD;
BEGIN

EXECUTE FORMAT('
    WITH RECURSIVE input AS (SELECT %1$L AS tenant, %2$L::UUID AS id, %3$L AS "ownerId", %4$L AS slug),
    cte AS (
        SELECT  i.tenant, i.id, i."ownerId", i.slug || ''-'' AS slug, 1 as suffix
        FROM    %5$I.%6$I s
        JOIN    input i ON i.id <> s.id AND i.tenant = s.tenant AND i."ownerId" = s."ownerId" AND i.slug = s.slug
        
        UNION ALL
        SELECT  c.tenant, c.id, c."ownerId", c.slug, c.suffix + 1
        FROM    cte c
        JOIN    %5$I.%6$I a ON a.id <> c.id AND a.tenant = c.tenant AND a."ownerId" = c."ownerId" AND a.slug = c.slug || c.suffix
    )
    (
        SELECT slug || suffix AS slug
        FROM  cte
        ORDER BY suffix DESC
        LIMIT  1
    )
    UNION  ALL 
    SELECT slug FROM input
    LIMIT  1    
', i_tenant, i_id, i_owner, i_slug, schema_name, source) INTO retval;
RETURN retval.slug;
END
$function$
;
CREATE OR REPLACE FUNCTION unique_slug(schema_name text, source text, i_tenant text, i_id uuid, i_slug text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE retval RECORD;
BEGIN

EXECUTE FORMAT('
    WITH RECURSIVE input AS (SELECT %1$L AS tenant, %2$L::uuid AS id, %3$L AS slug),
    cte AS (
        SELECT i.tenant, i.id, i.slug || ''-'' AS slug, 1 as suffix  
        FROM   %4$I.%5$I s
        JOIN   input i ON i.id <> s.id AND i.tenant = s.tenant AND i.slug = s.slug

        UNION ALL
        SELECT c.tenant, c.id, c.slug, c.suffix + 1
        FROM   cte c
        JOIN   %4$I.%5$I  a ON a.slug = c.slug || c.suffix
    )
    (
        SELECT slug || suffix AS slug
        FROM  cte
        ORDER  BY suffix DESC
        LIMIT  1
    )
    UNION  ALL 
    SELECT slug FROM input
    LIMIT  1
', i_tenant, i_id, i_slug, schema_name, source) INTO retval;
RETURN retval.slug;
END
$function$
;
CREATE OR REPLACE FUNCTION ensure_unique_owner_slug()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.slug = unique_owner_slug(TG_TABLE_SCHEMA, TG_TABLE_NAME, NEW.tenant, NEW.id, NEW."ownerId", slugify(NEW.name, false));
    RETURN NEW;
END
$function$
;
CREATE OR REPLACE FUNCTION ensure_unique_slug()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.slug = unique_slug(TG_TABLE_SCHEMA, TG_TABLE_NAME, NEW.tenant, NEW.id, slugify(NEW.name, false));
    RETURN NEW;
END
$function$
;
CREATE OR REPLACE FUNCTION delete_user_field_data()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
                BEGIN
                    UPDATE "user" SET "userFields" = "userFields" - OLD.name WHERE "userFields" ? OLD.name AND tenant = OLD.tenant;
                    RETURN OLD;
                END;
            $function$
;
CREATE OR REPLACE FUNCTION delete_embedded_datasource()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN DELETE FROM datasource where id=OLD."datasourceId" AND tenant=OLD.tenant AND embedded=true; RETURN OLD; END; $function$
;
CREATE OR REPLACE FUNCTION dataset_field_update_etag()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
         DECLARE
            etag bigint;
        BEGIN 
            SELECT nextval('dataset_etag'), nextval('dataset_field_etag') INTO etag; 
            RETURN NEW; 
        END; $function$
;
CREATE OR REPLACE FUNCTION add_tenant_role()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
            BEGIN
            EXECUTE 'GRANT "' || NEW.id || '" TO current_user';
            RETURN NEW;
            END;
            $function$
;
CREATE OR REPLACE FUNCTION update_tenant_role()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
            BEGIN
                IF EXISTS (select 1 from pg_roles where rolname = '|| OLD.id ||') THEN
                EXECUTE 'REVOKE "' || OLD.id || '" FROM current_user';
			    END IF;
            EXECUTE 'GRANT "' || NEW.id || '" TO current_user';
            RETURN NEW;
            END;
            $function$
;
CREATE OR REPLACE FUNCTION unique_dataset_es_index_name(schema_name text, i_tenant text, i_id uuid, i_index_name text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE retval RECORD;
BEGIN

EXECUTE FORMAT('
    WITH RECURSIVE input AS (SELECT %1$L AS tenant, %2$L::uuid AS id, %3$L AS index_name),
    cte AS (
        SELECT i.tenant, i.id, i.index_name || ''-'' AS index_name, 1 as suffix
        FROM   %4$I.dataset s
        JOIN   input i ON i.id <> s.id AND i.tenant = s.tenant AND i.index_name = s."esIndexName"

        UNION ALL
        SELECT c.tenant, c.id, c.index_name, c.suffix + 1
        FROM   cte c
        JOIN   %4$I.dataset a ON a."esIndexName" = c.index_name || c.suffix
    )
    (
        SELECT index_name || suffix AS index_name
        FROM  cte
        ORDER  BY suffix DESC
        LIMIT  1
    )
    UNION  ALL
    SELECT index_name FROM input
    LIMIT  1
', i_tenant, i_id, i_index_name, schema_name) INTO retval;
RETURN retval.index_name;
END
$function$
;
CREATE OR REPLACE FUNCTION ensure_unique_es_index_name()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW."esIndexName" = unique_dataset_es_index_name(TG_TABLE_SCHEMA, NEW.tenant, NEW.id, COALESCE(NEW."esIndexName", NEW.slug, NEW.id::text));
    RETURN NEW;
END
$function$
;
CREATE TABLE "migrations" ( "migration" character varying(255)  NOT NULL );
CREATE TABLE "activity" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "sha" character varying(255)  , "actor" jsonb  , "verb" character varying(255)  , "object" jsonb  , "target" jsonb  , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "_altid" integer  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "avatar" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "userId" character varying(255)  , "original" bytea  , "cropped" bytea  , "contentType" character varying(255)  , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "_altid" integer  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "comment" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "message" text  , "public" boolean DEFAULT false , "userId" character varying(255)  NOT NULL, "teamId" character varying(255)  , "mentions" character varying(255)[]  , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "_altid" integer  , "datasetId" uuid  , "datasourceId" uuid  , "reportId" uuid  , "queryId" uuid  , "jobId" uuid  , "parentId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "dataset" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "ownerId" character varying(255)  , "slug" character varying(255)  , "name" character varying(255)  , "description" character varying(255)  , "embedded" boolean DEFAULT false NOT NULL, "esIndex" character varying(255)  , "esType" character varying(255) DEFAULT 'data'::character varying , "records" integer  , "size" bigint  , "source" character varying(255)  , "sourceId" jsonb  , "params" jsonb DEFAULT '{}'::jsonb , "dataUpdatedAt" timestamp with time zone  , "append" boolean DEFAULT false , "shared" boolean DEFAULT false , "timestampField" jsonb  , "lastDurationMillis" bigint DEFAULT 0 , "windowSize" integer DEFAULT 500 , "flow" jsonb[] DEFAULT '{}'::jsonb[] , "settings" jsonb DEFAULT '{}'::jsonb , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "ttl" integer  , "dataExpiresAt" timestamp with time zone  , "_altid" integer  , "datasourceId" uuid  , "reportId" uuid  , "queryId" uuid  , "editingId" uuid  , "folderId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL, "esId" text  , "esWorkers" integer DEFAULT 1 , "lastQueriedAt" timestamp with time zone  , "esIndexName" text  NOT NULL );
CREATE TABLE "dataset_field" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "name" character varying(255)  NOT NULL, "position" integer  , "label" character varying(255)  , "dataType" character varying(255)  , "formatOptions" jsonb  , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "_changes" jsonb  , "fieldId" character varying(255)  , "typeMapping" jsonb  , "_altid" integer  , "datasetId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL, "script" jsonb   );
CREATE TABLE "dataset_filter" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "name" character varying(255)  , "useDefaultName" boolean  , "filter" jsonb  , "filterConfig" jsonb  , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "ownerId" character varying(255)  , "_altid" integer  , "datasetId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL, "public" boolean DEFAULT false  );
CREATE TABLE "dataset_history" ( "name" character varying(255)  , "slug" character varying(255)  , "description" character varying(255)  , "query" jsonb  , "settings" jsonb DEFAULT '{}'::jsonb , "windowSize" integer DEFAULT 500 , "append" boolean DEFAULT false , "_id" uuid DEFAULT gen_random_uuid() NOT NULL, "_revision" integer  , "_user" character varying(255)  , "_date" timestamp with time zone  , "_changes" character varying(255)[]  , "_altid" integer  , "_sourceId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "dataset_share" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "principalId" character varying(255)  NOT NULL, "accessLevel" integer DEFAULT 1 NOT NULL, "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "_altid" integer  , "datasetId" uuid  , "datasetFilterId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "datasource" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "ownerId" character varying(255)  , "slug" character varying(255)  , "name" character varying(255)  , "description" character varying(255)  , "embedded" boolean DEFAULT false NOT NULL, "type" character varying(255)  NOT NULL, "connection" jsonb  , "scannedAt" timestamp with time zone  , "schemaUpdatedAt" timestamp with time zone DEFAULT '2016-10-17 17:03:51.452+00'::timestamp with time zone NOT NULL, "rescanRequired" boolean DEFAULT false NOT NULL, "shared" boolean DEFAULT false , "schemas" jsonb  , "settings" jsonb DEFAULT '{}'::jsonb , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "fileId" uuid  , "source" character varying(255)  , "sourceId" jsonb  , "_altid" integer  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "datasource_feature" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "featureId" character varying(255)  NOT NULL, "version" character varying(255)  , "data" jsonb  , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "_altid" integer  , "datasourceId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "datasource_share" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "principalId" character varying(255)  NOT NULL, "accessLevel" integer DEFAULT 1 NOT NULL, "customAccess" jsonb DEFAULT '{}'::jsonb , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "_altid" integer  , "datasourceId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "export_template" ( "id" uuid  NOT NULL, "template_name" character varying(255)  , "engine" character varying(255)  , "embedded" boolean DEFAULT false NOT NULL, "content" text  , "options" jsonb  , "lobId" bigint  , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "ownerId" character varying(255)  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "feed" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "type" character varying(255)  NOT NULL, "message" character varying(255)  , "teamId" character varying(255)  , "userId" character varying(255)  , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "_altid" integer  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "field" ( "id" character varying(255)  NOT NULL, "schemaId" character varying(255)  , "mappingId" character varying(255)  NOT NULL, "fieldId" character varying(255)  NOT NULL, "source" character varying(255)  , "sourceId" jsonb  , "mappingPath" character varying(255)  , "name" character varying(255)  , "hidden" boolean DEFAULT false NOT NULL, "data" jsonb  , "description" text  , "rawType" character varying(255)  , "dataType" character varying(255)  , "formatOptions" jsonb DEFAULT '{}'::jsonb , "ordinalPosition" bigint  , "isPk" boolean DEFAULT false NOT NULL, "pkSeqNum" integer  , "isFk" boolean DEFAULT false NOT NULL, "restricted" boolean DEFAULT false , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "_changes" jsonb  , "expression" text  , "datasourceId" uuid  , "_altid" text  , "tenant" text DEFAULT CURRENT_USER NOT NULL, "codeId" uuid   );
CREATE TABLE "file" ( "id" uuid  NOT NULL, "filename" character varying(255)  , "embedded" boolean DEFAULT false NOT NULL, "contentType" character varying(255)  , "lobId" bigint  , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "ownerId" character varying(255)  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "link" ( "id" character varying(255)  NOT NULL, "linkId" character varying(255)  , "fromId" character varying(255)  , "toId" character varying(255)  , "source" character varying(255)  , "sourceId" jsonb  , "name" character varying(255)  , "type" character varying(255)  NOT NULL, "defn" jsonb  , "embedded" boolean DEFAULT false NOT NULL, "embeddedPrefix" character varying(255)  , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "_changes" jsonb  , "parentId" character varying(255)  , "_altid" text  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "map" ( "id" character varying(255)  NOT NULL, "source" character varying(255)  , "title" character varying(255)  NOT NULL, "type" character varying(255)  NOT NULL, "properties" jsonb  , "group" character varying(255)  NOT NULL, "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "deletedAt" timestamp with time zone  , "data" jsonb  , "sourceId" jsonb  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "mapping" ( "id" character varying(255)  NOT NULL, "schemaId" character varying(255)  , "mappingId" character varying(255)  , "source" character varying(255)  , "sourceId" jsonb  , "name" character varying(255)  , "hidden" boolean DEFAULT false NOT NULL, "records" integer  , "size" bigint  , "data" jsonb  , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "_changes" jsonb  , "setId" character varying(255)  , "description" text  , "datasourceId" uuid  , "_altid" text  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "principal" ( "id" character varying(255)  NOT NULL, "userId" character varying(255)  , "teamId" character varying(255)  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "principal_activity" ( "principalId" character varying(255)  NOT NULL, "actorId" character varying(255)  , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "activityId" uuid  , "tenant" text DEFAULT CURRENT_USER  );
CREATE TABLE "report" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "type" character varying(255)  NOT NULL, "name" character varying(255)  , "ownerId" character varying(255)  NOT NULL, "slug" character varying(255)  , "description" character varying(255)  , "defn" jsonb DEFAULT '{}'::jsonb , "settings" jsonb DEFAULT '{}'::jsonb , "shared" boolean DEFAULT false , "defnUpdatedAt" timestamp with time zone  , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "source" character varying(255)  , "sourceId" jsonb  , "_altid" integer  , "editingId" uuid  , "datasourceId" uuid  , "folderId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "report_history" ( "name" character varying(255)  , "slug" character varying(255)  , "description" character varying(255)  , "datasets" jsonb DEFAULT '{}'::jsonb , "defn" jsonb DEFAULT '{}'::jsonb , "settings" jsonb DEFAULT '{}'::jsonb , "_id" uuid DEFAULT gen_random_uuid() NOT NULL, "_revision" integer  , "_user" character varying(255)  , "_date" timestamp with time zone  , "_changes" character varying(255)[]  , "_altid" integer  , "_sourceId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "report_share" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "principalId" character varying(255)  NOT NULL, "accessLevel" integer DEFAULT 1 NOT NULL, "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "_altid" integer  , "reportId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "saved_query_filter" ( "id" character varying(255)  NOT NULL, "name" character varying(255)  NOT NULL, "description" character varying(255)  , "mappingId" character varying(255)  NOT NULL, "sourceId" jsonb  , "filter" jsonb DEFAULT '{}'::jsonb , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "ownerId" character varying(255)  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "set" ( "id" character varying(255)  NOT NULL, "name" character varying(255)  NOT NULL, "icon" character varying(255)  , "color" character varying(255)  , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "system_feature" ( "id" character varying(255)  NOT NULL, "version" character varying(255)  , "data" jsonb  , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "team" ( "id" character varying(255)  NOT NULL, "name" character varying(255)  , "description" character varying(255)  , "icon" character varying(255)  , "materialIcon" character varying(255)  , "color" character varying(255)  , "defaultRole" character varying(255)  , "source" character varying(255)  , "sourceId" jsonb  , "lastViewedFeed" timestamp with time zone  , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "domain" character varying(255) DEFAULT 'local'::character varying , "data" jsonb  , "_changes" jsonb  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "team_member" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "userId" character varying(255)  NOT NULL, "teamId" character varying(255)  NOT NULL, "accessLevel" integer DEFAULT 0 NOT NULL, "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "_altid" integer  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "upload" ( "id" uuid  NOT NULL, "filename" character varying(255)  NOT NULL, "dateUploaded" timestamp with time zone  NOT NULL, "size" integer  , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "ownerId" character varying(255)  , "datasetId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "user" ( "domain" character varying(255) DEFAULT 'local'::character varying NOT NULL, "username" character varying(255)  NOT NULL, "password" character varying(255)  , "displayName" character varying(255)  , "familyName" character varying(255)  , "givenName" character varying(255)  , "middleName" character varying(255)  , "email" character varying(255)  , "data" jsonb  , "superuser" boolean DEFAULT false NOT NULL, "settings" jsonb DEFAULT '{"log": {"log": false, "info": false, "warn": false, "debug": false, "error": true, "remote": false}}'::jsonb , "source" character varying(255)  , "sourceId" jsonb  , "lastViewedFeed" timestamp with time zone  , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "_changes" jsonb  , "enabled" boolean DEFAULT false NOT NULL, "tenant" text DEFAULT CURRENT_USER NOT NULL, "globalPermissions" jsonb DEFAULT '{"jobCreation": false, "painlessScriptCreation": false}'::jsonb , "userFields" jsonb DEFAULT '{}'::jsonb , "timezone" text DEFAULT 'America/New_York'::text  );
CREATE TABLE "user_settings" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "userId" character varying(255)  NOT NULL, "settings" jsonb DEFAULT '{}'::jsonb , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "_altid" integer  , "datasetId" uuid  , "reportId" uuid  , "queryId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "visual" ( "id" uuid  NOT NULL, "type" character varying(255)  NOT NULL, "source" character varying(255)  , "name" character varying(255)  , "description" character varying(255)  , "defaultName" character varying(255)  , "defaultDescription" character varying(255)  , "config" jsonb DEFAULT '{}'::jsonb , "embedded" boolean DEFAULT false NOT NULL, "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "ownerId" character varying(255)  , "pinned" boolean DEFAULT false NOT NULL, "layoutData" jsonb DEFAULT '{}'::jsonb , "datasetId" uuid  , "datasourceId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL, "reportId" uuid   );
CREATE TABLE "query" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "ownerId" character varying(255)  , "slug" character varying(255)  , "name" character varying(255)  , "description" character varying(255)  , "shared" boolean DEFAULT false , "embedded" boolean DEFAULT false NOT NULL, "source" character varying(255)  , "sourceId" jsonb  , "settings" jsonb DEFAULT '{}'::jsonb , "inputs" jsonb  , "language" character varying(255)  , "flow" jsonb[]  , "payload" jsonb  , "defnUpdatedAt" timestamp with time zone  , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "fields" jsonb  , "_altid" integer  , "datasourceId" uuid  , "editingId" uuid  , "folderId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL, "limit" integer DEFAULT '-1'::integer  );
CREATE TABLE "query_history" ( "name" character varying(255)  , "slug" character varying(255)  , "description" character varying(255)  , "inputs" jsonb  , "payload" jsonb  , "flow" jsonb[]  , "settings" jsonb DEFAULT '{}'::jsonb , "_id" uuid DEFAULT gen_random_uuid() NOT NULL, "_revision" integer  , "_user" character varying(255)  , "_date" timestamp with time zone  , "_changes" character varying(255)[]  , "_altid" integer  , "_sourceId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "query_share" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "principalId" character varying(255)  NOT NULL, "accessLevel" integer DEFAULT 1 NOT NULL, "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "_altid" integer  , "queryId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "dataset_exceptions" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "data" jsonb  , "addedAt" timestamp with time zone  , "createdAt" timestamp with time zone  , "updatedAt" timestamp with time zone  , "_altid" integer  , "datasetId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "domain" ( "id" character varying(255)  NOT NULL, "name" character varying(255)  , "description" character varying(255)  , "type" character varying(255)  NOT NULL, "config" jsonb  , "scannedAt" timestamp with time zone  , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "public" jsonb DEFAULT '{}'::jsonb , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "session" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "ttl" integer  , "host" character varying(255)  , "ip" character varying(255)  , "deviceType" character varying(255)  , "deviceVendor" character varying(255)  , "deviceModel" character varying(255)  , "osName" character varying(255)  , "osVersion" character varying(255)  , "browserName" character varying(255)  , "browserVersion" character varying(255)  , "requests" integer DEFAULT 0 , "lastAccessedAt" timestamp with time zone  , "expiresAt" timestamp with time zone  , "username" character varying(255)  NOT NULL, "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "_altid" integer  , "parent" uuid  , "tenant" text DEFAULT CURRENT_USER , "data" jsonb   );
CREATE TABLE "token" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "type" character varying(255) DEFAULT 'global'::character varying NOT NULL, "readOnly" boolean DEFAULT false NOT NULL, "notes" text  , "restrict" enum_token_restrict  , "host" character varying(255)  , "cidr" character varying(255)  , "data" jsonb  , "requests" integer DEFAULT 0 , "blocked" integer DEFAULT 0 , "lastAccessedAt" timestamp with time zone  , "username" character varying(255)  NOT NULL, "visualId" uuid  , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "_altid" integer  , "reportId" uuid  , "queryId" uuid  , "datasourceId" uuid  , "datasetId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "job" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "type" character varying(255)  NOT NULL, "slug" character varying(255)  , "name" character varying(255)  , "description" character varying(255)  , "priority" integer  , "nextRunAt" timestamp with time zone  , "createdAt" timestamp with time zone  , "updatedAt" timestamp with time zone  , "lockedAt" timestamp with time zone  , "enabled" boolean DEFAULT true , "data" jsonb DEFAULT '{}'::jsonb , "interval" character varying(255)  , "startOn" timestamp with time zone  , "intervalType" character varying(255)  , "endOn" timestamp with time zone  , "notes" text  , "ownerId" character varying(255)  NOT NULL, "source" character varying(255)  , "sourceId" jsonb  , "timezone" character varying  , "_altid" integer  , "datasetId" uuid  , "reportId" uuid  , "queryId" uuid  , "datasourceId" uuid  , "editingId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "job_history" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "data" jsonb  , "duration" tstzrange  , "ownerId" character varying(255)  NOT NULL, "createdAt" timestamp with time zone  , "updatedAt" timestamp with time zone  , "success" boolean  , "warnings" boolean  , "progress" jsonb  , "_altid" integer  , "jobId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "job_dataset" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "alias" character varying(255)  NOT NULL, "index" integer  , "parallel" boolean DEFAULT false , "refresh" boolean DEFAULT false , "filter" jsonb DEFAULT '{}'::jsonb , "createdAt" timestamp with time zone  , "updatedAt" timestamp with time zone  , "settings" jsonb DEFAULT '{}'::jsonb , "_altid" integer  , "jobId" uuid  , "datasetId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "job_file" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "fileId" uuid  , "createdAt" timestamp with time zone  , "updatedAt" timestamp with time zone  , "_altid" integer  , "jobId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "function" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "namespace" character varying(255)  NOT NULL, "name" character varying(255)  NOT NULL, "description" character varying(255)  , "script" text  , "params" jsonb[]  , "createdAt" timestamp with time zone  , "updatedAt" timestamp with time zone  , "source" character varying  , "sourceId" character varying  , "_altid" integer  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "folder" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "name" character varying(255)  NOT NULL, "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "_altid" integer  , "parentId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "tag" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "name" character varying(255)  NOT NULL, "color" character varying(255)  , "createdAt" timestamp with time zone  , "updatedAt" timestamp with time zone  , "_altid" integer  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "tag_entity" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "createdAt" timestamp with time zone  , "updatedAt" timestamp with time zone  , "_altid" integer  , "tagId" uuid  , "datasetId" uuid  , "reportId" uuid  , "queryId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "color" ( "key" text  NOT NULL, "color" character varying(255)  , "createdAt" timestamp with time zone  , "updatedAt" timestamp with time zone  , "source" character varying(255)  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "dataset_visual" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "visualId" uuid  , "data" jsonb DEFAULT '{}'::jsonb , "createdAt" timestamp with time zone  , "updatedAt" timestamp with time zone  , "_altid" integer  , "datasetId" uuid  , "tenant" text DEFAULT CURRENT_USER NOT NULL );
CREATE TABLE "tenant" ( "id" text  NOT NULL, "name" text  NOT NULL, "defaultTeamId" character varying(255)  , "systemId" uuid  , "licenseToken" text  , "createdAt" timestamp with time zone DEFAULT now() NOT NULL, "updatedAt" timestamp with time zone DEFAULT now() NOT NULL, "publicKey" text DEFAULT '-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuPmZ+N2sKdhl+Z7g+Vq2
KgG+W+vuFk5SvC7xQIUc+y8T5AN050uPGveareipZgTfUTz6k5b0TrxUdJShx6Ux
qllIRifl7t1pyzNH1+MbQ8ilQVaxis2K8pgn1or2lPJ385XZ/DP0iCUBlODJPYRF
KY1kwNfjjo5gET+ekZNbYtKJkYHQx0gPh1H/EpN9wdCRly0oz0EHlP4bU0s1VD2n
UKU+um+alIVivL1V94B8lWxB+w/qIQY5cHQPXzK0twibavSi1cWPP6d6q9/D4MNm
PI/Eu3u8VW61yfKuq93zoRsPOYiWjfpSWfpqNzgLAS8cpRePQMn9s9LeRYTPRvDE
QQIDAQAB
-----END PUBLIC KEY-----
'::text NOT NULL, "license" jsonb  , "dbLogEnabled" boolean DEFAULT false , "queryLogEnabled" boolean DEFAULT false , "maxConcurrentJobs" integer DEFAULT 5 NOT NULL, "mail" jsonb DEFAULT '{}'::jsonb , "helpUrl" text DEFAULT 'https://informer5.zendesk.com/hc/en-us'::text NOT NULL, "helpEmail" text DEFAULT ''::text , "passwordStrength" "enum_system_settings_passwordStrength" DEFAULT 'Weak'::"enum_system_settings_passwordStrength" NOT NULL, "defaultDomainId" character varying(255)  , "queryDatasetTTL" integer DEFAULT 60 NOT NULL, "jobHistorySize" integer DEFAULT 200 NOT NULL, "requestLog" jsonb DEFAULT '{"api": true, "viz": true, "errors": true, "content": false, "warnings": true, "successes": true}'::jsonb , "esLogEnabled" boolean DEFAULT false , "u2BufferLogging" boolean DEFAULT false , "sanitizeDataHtml" boolean DEFAULT true , "jobsEnabled" boolean DEFAULT true  );
CREATE TABLE "suite" ( "tenant" text DEFAULT CURRENT_USER NOT NULL, "id" uuid DEFAULT gen_random_uuid() NOT NULL, "datasourceId" uuid  NOT NULL, "name" text  NOT NULL, "slug" text  NOT NULL, "description" text  , "label" text  , "createdAt" timestamp with time zone DEFAULT now() NOT NULL, "updatedAt" timestamp with time zone DEFAULT now() NOT NULL, "defaultPartitionId" uuid   );
CREATE TABLE "suite_partition" ( "tenant" text DEFAULT CURRENT_USER NOT NULL, "id" uuid DEFAULT gen_random_uuid() NOT NULL, "name" text  NOT NULL, "suiteId" uuid  NOT NULL, "createdAt" timestamp with time zone DEFAULT now() NOT NULL, "updatedAt" timestamp with time zone DEFAULT now() NOT NULL );
CREATE TABLE "suite_mapping" ( "tenant" text DEFAULT CURRENT_USER NOT NULL, "suiteId" uuid  NOT NULL, "id" uuid DEFAULT gen_random_uuid() NOT NULL, "mappingId" text  NOT NULL, "pattern" text  , "substitutions" jsonb  , "createdAt" timestamp with time zone DEFAULT now() NOT NULL, "updatedAt" timestamp with time zone DEFAULT now() NOT NULL );
CREATE TABLE "suite_entry" ( "tenant" text DEFAULT CURRENT_USER NOT NULL, "id" uuid DEFAULT gen_random_uuid() NOT NULL, "suiteId" uuid  NOT NULL, "partitionId" uuid  NOT NULL, "mappingId" uuid  NOT NULL, "createdAt" timestamp with time zone DEFAULT now() NOT NULL, "updatedAt" timestamp with time zone DEFAULT now() NOT NULL, "tableName" text  NOT NULL, "substitutions" jsonb   );
CREATE TABLE "code" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "type" character varying(255)  , "name" character varying(255)  , "description" character varying(255)  , "defn" jsonb DEFAULT '{}'::jsonb , "tenant" text DEFAULT CURRENT_USER NOT NULL, "datasourceId" uuid  , "datasetId" uuid  , "mappingId" character varying(255)  , "valueFieldId" character varying(255)  , "descriptionFieldId" character varying(255)  , "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "source" character varying  , "sourceId" jsonb   );
CREATE TABLE "bundle" ( "tenant" text DEFAULT CURRENT_USER NOT NULL, "id" uuid DEFAULT gen_random_uuid() NOT NULL, "name" text  NOT NULL, "slug" text  NOT NULL, "description" text  , "createdAt" timestamp with time zone DEFAULT now() NOT NULL, "updatedAt" timestamp with time zone DEFAULT now() NOT NULL );
CREATE TABLE "bundle_entry" ( "tenant" text DEFAULT CURRENT_USER NOT NULL, "id" uuid DEFAULT gen_random_uuid() NOT NULL, "bundleId" uuid  NOT NULL, "type" text  NOT NULL, "data" jsonb DEFAULT '{}'::jsonb , "datasourceId" uuid  , "queryId" uuid  , "datasetId" uuid  , "reportId" uuid  , "tagId" uuid  , "username" text  , "teamId" text  , "jobId" uuid  , "createdAt" timestamp with time zone DEFAULT now() NOT NULL, "updatedAt" timestamp with time zone DEFAULT now() NOT NULL );
CREATE TABLE "user_field" ( "tenant" text DEFAULT CURRENT_USER NOT NULL, "id" uuid DEFAULT gen_random_uuid() NOT NULL, "name" text  NOT NULL, "label" text  NOT NULL, "description" text  , "defaultValue" text DEFAULT ''::text , "type" text  NOT NULL, "createdAt" timestamp with time zone DEFAULT now() NOT NULL, "updatedAt" timestamp with time zone DEFAULT now() NOT NULL );
CREATE TABLE "report_dataset" ( "id" uuid DEFAULT gen_random_uuid() NOT NULL, "filter" jsonb  , "chips" jsonb  , "alias" text  NOT NULL, "label" text  NOT NULL, "reportId" uuid  NOT NULL, "datasetId" uuid  NOT NULL, "createdAt" timestamp with time zone  NOT NULL, "updatedAt" timestamp with time zone  NOT NULL, "tenant" text DEFAULT CURRENT_USER NOT NULL );
ALTER TABLE "migrations" ADD CONSTRAINT "migrations_pkey" PRIMARY KEY (migration);
ALTER TABLE "activity" ADD CONSTRAINT "activity_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "activity" ADD CONSTRAINT "activity_sha_key" UNIQUE (tenant, sha);
CREATE INDEX activity_tenant ON activity USING btree (tenant);
CREATE INDEX activity_tenant__altid_idx ON activity USING btree (tenant, _altid);
ALTER TABLE "avatar" ADD CONSTRAINT "avatar_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX avatar_tenant ON avatar USING btree (tenant);
CREATE INDEX avatar_tenant__altid_idx ON avatar USING btree (tenant, _altid);
CREATE INDEX "avatar_tenant_userId_idx" ON avatar USING btree (tenant, "userId");
ALTER TABLE "comment" ADD CONSTRAINT "comment_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX comment_tenant ON comment USING btree (tenant);
CREATE INDEX comment_tenant__altid_idx ON comment USING btree (tenant, _altid);
CREATE INDEX "comment_tenant_userId_idx" ON comment USING btree (tenant, "userId");
ALTER TABLE "dataset" ADD CONSTRAINT "dataset_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "dataset" ADD CONSTRAINT "dataset_tenant_ownerId_slug_key" UNIQUE (tenant, "ownerId", slug);
ALTER TABLE "dataset" ADD CONSTRAINT "tenant_esIndexName_key" UNIQUE (tenant, "esIndexName");
CREATE INDEX "dataset_lastQueriedAt" ON dataset USING btree (tenant, "lastQueriedAt");
CREATE INDEX dataset_tenant ON dataset USING btree (tenant);
CREATE INDEX dataset_tenant__altid_idx ON dataset USING btree (tenant, _altid);
CREATE INDEX dataset_tenant_shared_idx ON dataset USING btree (tenant, shared);
CREATE INDEX "dataset_tenant_source_sourceId_idx" ON dataset USING btree (tenant, source, "sourceId");
ALTER TABLE "dataset_field" ADD CONSTRAINT "dataset_field_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "dataset_field" ADD CONSTRAINT "dataset_field_tenant_name_datasetId_key" UNIQUE (tenant, name, "datasetId");
CREATE INDEX dataset_field_tenant ON dataset_field USING btree (tenant);
CREATE INDEX dataset_field_tenant__altid_idx ON dataset_field USING btree (tenant, _altid);
ALTER TABLE "dataset_filter" ADD CONSTRAINT "dataset_filter_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX dataset_filter_tenant ON dataset_filter USING btree (tenant);
CREATE INDEX dataset_filter_tenant__altid_idx ON dataset_filter USING btree (tenant, _altid);
ALTER TABLE "dataset_history" ADD CONSTRAINT "dataset_history_pkey" PRIMARY KEY (tenant, _id);
CREATE INDEX dataset_history_tenant ON dataset_history USING btree (tenant);
CREATE INDEX dataset_history_tenant__altid_idx ON dataset_history USING btree (tenant, _altid);
ALTER TABLE "dataset_share" ADD CONSTRAINT "dataset_share_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "dataset_share" ADD CONSTRAINT "dataset_share_tenant_datasetId_principalId_key" UNIQUE (tenant, "datasetId", "principalId");
CREATE INDEX dataset_share_tenant ON dataset_share USING btree (tenant);
CREATE INDEX dataset_share_tenant__altid_idx ON dataset_share USING btree (tenant, _altid);
CREATE INDEX "dataset_share_tenant_accessLevel_idx" ON dataset_share USING btree (tenant, "accessLevel");
CREATE INDEX "dataset_share_tenant_principalId_idx" ON dataset_share USING btree (tenant, "principalId");
ALTER TABLE "datasource" ADD CONSTRAINT "datasource_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "datasource" ADD CONSTRAINT "datasource_tenant_ownerId_slug_key" UNIQUE (tenant, "ownerId", slug);
CREATE INDEX datasource_tenant ON datasource USING btree (tenant);
CREATE INDEX datasource_tenant__altid_idx ON datasource USING btree (tenant, _altid);
ALTER TABLE "datasource_feature" ADD CONSTRAINT "datasource_feature_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "datasource_feature" ADD CONSTRAINT "datasource_feature_tenant_datasourceId_featureId_key" UNIQUE (tenant, "datasourceId", "featureId");
CREATE INDEX datasource_feature_tenant ON datasource_feature USING btree (tenant);
CREATE INDEX datasource_feature_tenant__altid_idx ON datasource_feature USING btree (tenant, _altid);
ALTER TABLE "datasource_share" ADD CONSTRAINT "datasource_share_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "datasource_share" ADD CONSTRAINT "datasource_share_tenant_datasourceId_principalId_key" UNIQUE (tenant, "datasourceId", "principalId");
CREATE INDEX datasource_share_tenant ON datasource_share USING btree (tenant);
CREATE INDEX datasource_share_tenant__altid_idx ON datasource_share USING btree (tenant, _altid);
CREATE INDEX "datasource_share_tenant_accessLevel_idx" ON datasource_share USING btree (tenant, "accessLevel");
CREATE INDEX "datasource_share_tenant_principalId_idx" ON datasource_share USING btree (tenant, "principalId");
ALTER TABLE "export_template" ADD CONSTRAINT "export_template_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX export_template_tenant ON export_template USING btree (tenant);
ALTER TABLE "feed" ADD CONSTRAINT "feed_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX feed_tenant ON feed USING btree (tenant);
CREATE INDEX feed_tenant__altid_idx ON feed USING btree (tenant, _altid);
ALTER TABLE "field" ADD CONSTRAINT "field_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "field" ADD CONSTRAINT "field_tenant_altid" UNIQUE (tenant, _altid);
CREATE INDEX field_tenant ON field USING btree (tenant);
CREATE INDEX "field_tenant_fieldId_idx" ON field USING btree (tenant, "fieldId");
CREATE INDEX "field_tenant_mappingPath_idx" ON field USING btree (tenant, "mappingPath");
CREATE INDEX field_tenant_name_idx ON field USING btree (tenant, name);
CREATE INDEX field_tenant_restricted_idx ON field USING btree (tenant, restricted);
CREATE INDEX "field_tenant_source_sourceId_idx" ON field USING btree (tenant, source, "sourceId");
ALTER TABLE "file" ADD CONSTRAINT "file_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX file_tenant ON file USING btree (tenant);
ALTER TABLE "link" ADD CONSTRAINT "link_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "link" ADD CONSTRAINT "link_tenant_altid" UNIQUE (tenant, _altid);
ALTER TABLE "link" ADD CONSTRAINT "link_tenant_linkId_fromId_key" UNIQUE (tenant, "linkId", "fromId");
CREATE INDEX link_tenant ON link USING btree (tenant);
CREATE INDEX "link_tenant_fromId_idx" ON link USING btree (tenant, "fromId");
CREATE INDEX "link_tenant_source_sourceId_idx" ON link USING btree (tenant, source, "sourceId");
CREATE INDEX "link_tenant_toId_idx" ON link USING btree (tenant, "toId");
ALTER TABLE "map" ADD CONSTRAINT "map_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX map_tenant ON map USING btree (tenant);
CREATE INDEX "map_tenant_source_sourceId_idx" ON map USING btree (tenant, source, "sourceId");
ALTER TABLE "mapping" ADD CONSTRAINT "mapping_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "mapping" ADD CONSTRAINT "mapping_tenant_altid" UNIQUE (tenant, _altid);
CREATE INDEX mapping_tenant ON mapping USING btree (tenant);
CREATE INDEX "mapping_tenant_mappingId_idx" ON mapping USING btree (tenant, "mappingId");
CREATE INDEX mapping_tenant_name_idx ON mapping USING btree (tenant, name);
CREATE INDEX "mapping_tenant_schemaId_idx" ON mapping USING btree (tenant, "schemaId");
CREATE INDEX "mapping_tenant_schemaId_mappingId_idx" ON mapping USING btree (tenant, "schemaId", "mappingId");
CREATE INDEX "mapping_tenant_source_sourceId_idx" ON mapping USING btree (tenant, source, "sourceId");
ALTER TABLE "principal" ADD CONSTRAINT "principal_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX principal_tenant ON principal USING btree (tenant);
CREATE INDEX principal_activity_tenant ON principal_activity USING btree (tenant);
CREATE INDEX "principal_activity_tenant_actorId_idx" ON principal_activity USING btree (tenant, "actorId");
CREATE INDEX "principal_activity_tenant_createdAt_idx" ON principal_activity USING btree (tenant, "createdAt");
ALTER TABLE "report" ADD CONSTRAINT "report_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "report" ADD CONSTRAINT "report_tenant_ownerId_slug_key" UNIQUE (tenant, "ownerId", slug);
CREATE INDEX report_tenant ON report USING btree (tenant);
CREATE INDEX report_tenant__altid_idx ON report USING btree (tenant, _altid);
ALTER TABLE "report_history" ADD CONSTRAINT "report_history_pkey" PRIMARY KEY (tenant, _id);
CREATE INDEX report_history_tenant ON report_history USING btree (tenant);
CREATE INDEX report_history_tenant__altid_idx ON report_history USING btree (tenant, _altid);
ALTER TABLE "report_share" ADD CONSTRAINT "report_share_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "report_share" ADD CONSTRAINT "report_share_tenant_reportId_principalId_key" UNIQUE (tenant, "reportId", "principalId");
CREATE INDEX report_share_tenant ON report_share USING btree (tenant);
CREATE INDEX report_share_tenant__altid_idx ON report_share USING btree (tenant, _altid);
CREATE INDEX "report_share_tenant_accessLevel_idx" ON report_share USING btree (tenant, "accessLevel");
CREATE INDEX "report_share_tenant_principalId_idx" ON report_share USING btree (tenant, "principalId");
ALTER TABLE "saved_query_filter" ADD CONSTRAINT "saved_query_filter_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX saved_query_filter_tenant ON saved_query_filter USING btree (tenant);
ALTER TABLE "set" ADD CONSTRAINT "set_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX set_tenant ON set USING btree (tenant);
ALTER TABLE "system_feature" ADD CONSTRAINT "system_feature_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX system_feature_tenant ON system_feature USING btree (tenant);
ALTER TABLE "team" ADD CONSTRAINT "team_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX team_tenant ON team USING btree (tenant);
CREATE INDEX "team_tenant_source_sourceId_idx" ON team USING btree (tenant, source, "sourceId");
ALTER TABLE "team_member" ADD CONSTRAINT "team_member_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "team_member" ADD CONSTRAINT "team_member_tenant_userId_teamId_key" UNIQUE (tenant, "userId", "teamId");
CREATE INDEX team_member_tenant ON team_member USING btree (tenant);
CREATE INDEX team_member_tenant__altid_idx ON team_member USING btree (tenant, _altid);
ALTER TABLE "upload" ADD CONSTRAINT "upload_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX upload_tenant ON upload USING btree (tenant);
ALTER TABLE "user" ADD CONSTRAINT "user_pkey" PRIMARY KEY (tenant, username);
CREATE INDEX user_tenant ON "user" USING btree (tenant);
CREATE INDEX "user_tenant_source_sourceId_idx" ON "user" USING btree (tenant, source, "sourceId");
ALTER TABLE "user_settings" ADD CONSTRAINT "user_settings_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX user_settings_tenant ON user_settings USING btree (tenant);
CREATE INDEX user_settings_tenant__altid_idx ON user_settings USING btree (tenant, _altid);
ALTER TABLE "visual" ADD CONSTRAINT "visual_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX visual_tenant ON visual USING btree (tenant);
ALTER TABLE "query" ADD CONSTRAINT "query_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "query" ADD CONSTRAINT "query_tenant_ownerId_slug_key" UNIQUE (tenant, "ownerId", slug);
CREATE INDEX query_tenant ON query USING btree (tenant);
CREATE INDEX query_tenant__altid_idx ON query USING btree (tenant, _altid);
CREATE INDEX query_tenant_shared_idx ON query USING btree (tenant, shared);
CREATE INDEX "query_tenant_source_sourceId_idx" ON query USING btree (tenant, source, "sourceId");
ALTER TABLE "query_history" ADD CONSTRAINT "query_history_pkey" PRIMARY KEY (tenant, _id);
CREATE INDEX query_history_tenant ON query_history USING btree (tenant);
CREATE INDEX query_history_tenant__altid_idx ON query_history USING btree (tenant, _altid);
ALTER TABLE "query_share" ADD CONSTRAINT "query_share_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "query_share" ADD CONSTRAINT "query_share_tenant_queryId_principalId_key" UNIQUE (tenant, "queryId", "principalId");
CREATE INDEX query_share_tenant ON query_share USING btree (tenant);
CREATE INDEX query_share_tenant__altid_idx ON query_share USING btree (tenant, _altid);
CREATE INDEX "query_share_tenant_accessLevel_idx" ON query_share USING btree (tenant, "accessLevel");
CREATE INDEX "query_share_tenant_principalId_idx" ON query_share USING btree (tenant, "principalId");
ALTER TABLE "dataset_exceptions" ADD CONSTRAINT "dataset_exceptions_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX dataset_exceptions_tenant ON dataset_exceptions USING btree (tenant);
CREATE INDEX dataset_exceptions_tenant__altid_idx ON dataset_exceptions USING btree (tenant, _altid);
ALTER TABLE "domain" ADD CONSTRAINT "domain_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX domain_tenant ON domain USING btree (tenant);
ALTER TABLE "session" ADD CONSTRAINT "session_pkey" PRIMARY KEY (id);
CREATE INDEX session_altid ON session USING btree (_altid);
CREATE INDEX "session_expiresAt_idx" ON session USING btree ("expiresAt");
CREATE INDEX session_tenant ON session USING btree (tenant);
CREATE INDEX session_username_idx ON session USING btree (username);
ALTER TABLE "token" ADD CONSTRAINT "token_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX token_tenant ON token USING btree (tenant);
CREATE INDEX token_tenant__altid_idx ON token USING btree (tenant, _altid);
CREATE INDEX token_tenant_username_idx ON token USING btree (tenant, username);
CREATE INDEX "token_tenant_visualId_idx" ON token USING btree (tenant, "visualId");
ALTER TABLE "job" ADD CONSTRAINT "job_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "job" ADD CONSTRAINT "job_tenant_ownerId_slug_key" UNIQUE (tenant, "ownerId", slug);
CREATE INDEX job_tenant ON job USING btree (tenant);
CREATE INDEX job_tenant__altid_idx ON job USING btree (tenant, _altid);
CREATE INDEX "job_tenant_lockedAt_idx" ON job USING btree (tenant, "lockedAt");
CREATE INDEX "job_tenant_nextRunAt_idx" ON job USING btree (tenant, "nextRunAt");
CREATE INDEX "job_tenant_source_sourceId_idx" ON job USING btree (tenant, source, "sourceId");
ALTER TABLE "job_history" ADD CONSTRAINT "job_history_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX job_history_tenant ON job_history USING btree (tenant);
CREATE INDEX job_history_tenant__altid_idx ON job_history USING btree (tenant, _altid);
CREATE INDEX "job_history_tenant_ownerId_idx" ON job_history USING btree (tenant, "ownerId");
ALTER TABLE "job_dataset" ADD CONSTRAINT "job_dataset_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX job_dataset_tenant ON job_dataset USING btree (tenant);
CREATE INDEX job_dataset_tenant__altid_idx ON job_dataset USING btree (tenant, _altid);
ALTER TABLE "job_file" ADD CONSTRAINT "job_file_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX job_file_tenant ON job_file USING btree (tenant);
CREATE INDEX job_file_tenant__altid_idx ON job_file USING btree (tenant, _altid);
ALTER TABLE "function" ADD CONSTRAINT "function_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "function" ADD CONSTRAINT "function_tenant_namespace_name_key" UNIQUE (tenant, namespace, name);
CREATE INDEX function_tenant ON function USING btree (tenant);
CREATE INDEX function_tenant__altid_idx ON function USING btree (tenant, _altid);
CREATE INDEX "function_tenant_source_sourceId_idx" ON function USING btree (tenant, source, "sourceId");
ALTER TABLE "folder" ADD CONSTRAINT "folder_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX folder_tenant ON folder USING btree (tenant);
CREATE INDEX folder_tenant__altid_idx ON folder USING btree (tenant, _altid);
ALTER TABLE "tag" ADD CONSTRAINT "tag_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "tag" ADD CONSTRAINT "tag_tenant_name_key" UNIQUE (tenant, name);
CREATE INDEX tag_tenant ON tag USING btree (tenant);
CREATE INDEX tag_tenant__altid_idx ON tag USING btree (tenant, _altid);
ALTER TABLE "tag_entity" ADD CONSTRAINT "tag_entity_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "tag_entity" ADD CONSTRAINT "tag_entity_tenant_tagId_datasetId_key" UNIQUE (tenant, "tagId", "datasetId");
ALTER TABLE "tag_entity" ADD CONSTRAINT "tag_entity_tenant_tagId_queryId_key" UNIQUE (tenant, "tagId", "queryId");
ALTER TABLE "tag_entity" ADD CONSTRAINT "tag_entity_tenant_tagId_reportId_key" UNIQUE (tenant, "tagId", "reportId");
CREATE INDEX tag_entity_tenant ON tag_entity USING btree (tenant);
CREATE INDEX tag_entity_tenant__altid_idx ON tag_entity USING btree (tenant, _altid);
ALTER TABLE "color" ADD CONSTRAINT "color_pkey" PRIMARY KEY (tenant, key);
CREATE INDEX color_tenant ON color USING btree (tenant);
ALTER TABLE "dataset_visual" ADD CONSTRAINT "dataset_visual_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX dataset_visual_tenant ON dataset_visual USING btree (tenant);
CREATE INDEX dataset_visual_tenant__altid_idx ON dataset_visual USING btree (tenant, _altid);
ALTER TABLE "tenant" ADD CONSTRAINT "tenant_pkey" PRIMARY KEY (id);
ALTER TABLE "tenant" ADD CONSTRAINT "tenant_licenseToken_key" UNIQUE ("licenseToken");
ALTER TABLE "tenant" ADD CONSTRAINT "tenant_systemId_key" UNIQUE ("systemId");
ALTER TABLE "suite" ADD CONSTRAINT "suite_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "suite" ADD CONSTRAINT "suite_tenant_datasourceId_slug_key" UNIQUE (tenant, "datasourceId", slug);
CREATE INDEX suite_tenant ON suite USING btree (tenant);
ALTER TABLE "suite_partition" ADD CONSTRAINT "suite_partition_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "suite_partition" ADD CONSTRAINT "suite_partition_tenant_suiteId_name_key" UNIQUE (tenant, "suiteId", name);
CREATE INDEX suite_partition_tenant ON suite_partition USING btree (tenant);
CREATE INDEX "suite_partition_tenant_suiteId_idx" ON suite_partition USING btree (tenant, "suiteId");
CREATE INDEX "suite_partition_tenant_suiteId_name_idx" ON suite_partition USING btree (tenant, "suiteId", name);
ALTER TABLE "suite_mapping" ADD CONSTRAINT "suite_mapping_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "suite_mapping" ADD CONSTRAINT "suite_mapping_tenant_suiteId_mappingId_key" UNIQUE (tenant, "suiteId", "mappingId");
CREATE INDEX suite_mapping_tenant ON suite_mapping USING btree (tenant);
CREATE INDEX "suite_mapping_tenant_suiteId_idx" ON suite_mapping USING btree (tenant, "suiteId");
CREATE INDEX "suite_mapping_tenant_suiteId_mappingId_idx" ON suite_mapping USING btree (tenant, "suiteId", "mappingId");
ALTER TABLE "suite_entry" ADD CONSTRAINT "suite_entry_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "suite_entry" ADD CONSTRAINT "suite_entry_tenant_suiteId_mappingId_partitionId_key" UNIQUE (tenant, "suiteId", "mappingId", "partitionId");
CREATE INDEX suite_entry_tenant ON suite_entry USING btree (tenant);
CREATE INDEX "suite_entry_tenant_suiteId_idx" ON suite_entry USING btree (tenant, "suiteId");
CREATE INDEX "suite_entry_tenant_suiteId_mappingId_partitionId_idx" ON suite_entry USING btree (tenant, "suiteId", "mappingId", "partitionId");
ALTER TABLE "code" ADD CONSTRAINT "code_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX "code_tenant_datasetId_idx" ON code USING btree (tenant, "datasetId");
CREATE INDEX "code_tenant_datasourceId_idx" ON code USING btree (tenant, "datasourceId");
CREATE INDEX "code_tenant_descriptionFieldId_idx" ON code USING btree (tenant, "descriptionFieldId");
CREATE INDEX "code_tenant_mappingId_idx" ON code USING btree (tenant, "mappingId");
CREATE INDEX "code_tenant_valueFieldId_idx" ON code USING btree (tenant, "valueFieldId");
ALTER TABLE "bundle" ADD CONSTRAINT "bundle_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "bundle" ADD CONSTRAINT "bundle_tenant_slug_key" UNIQUE (tenant, slug);
ALTER TABLE "bundle_entry" ADD CONSTRAINT "bundle_entry_pkey" PRIMARY KEY (tenant, id);
CREATE INDEX "bundle_entry_tenant_bundleId_idx" ON bundle_entry USING btree (tenant, "bundleId");
ALTER TABLE "user_field" ADD CONSTRAINT "user_field_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "user_field" ADD CONSTRAINT "user_field_tenant_name_key" UNIQUE (tenant, name);
ALTER TABLE "report_dataset" ADD CONSTRAINT "report_dataset_pkey" PRIMARY KEY (tenant, id);
ALTER TABLE "report_dataset" ADD CONSTRAINT "report_dataset_tenant_alias_label_reportId_key" UNIQUE (tenant, alias, label, "reportId");
ALTER TABLE "report_dataset" ADD CONSTRAINT "report_dataset_tenant_reportId_alias_key" UNIQUE (tenant, "reportId", alias);
ALTER TABLE "report_dataset" ADD CONSTRAINT "report_dataset_tenant_reportId_label_key" UNIQUE (tenant, "reportId", label);
ALTER TABLE "activity" ADD CONSTRAINT "activity_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "avatar" ADD CONSTRAINT "avatar_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "avatar" ADD CONSTRAINT "owner" FOREIGN KEY (tenant, "userId") REFERENCES "user"(tenant, username) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "comment" ADD CONSTRAINT "comment_datasetId_fkey" FOREIGN KEY (tenant, "datasetId") REFERENCES dataset(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "comment" ADD CONSTRAINT "comment_datasourceId_fkey" FOREIGN KEY (tenant, "datasourceId") REFERENCES datasource(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "comment" ADD CONSTRAINT "comment_jobId_fkey" FOREIGN KEY (tenant, "jobId") REFERENCES job(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "comment" ADD CONSTRAINT "comment_parentId_fkey" FOREIGN KEY (tenant, "parentId") REFERENCES comment(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "comment" ADD CONSTRAINT "comment_queryId_fkey" FOREIGN KEY (tenant, "queryId") REFERENCES query(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "comment" ADD CONSTRAINT "comment_reportId_fkey" FOREIGN KEY (tenant, "reportId") REFERENCES report(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "comment" ADD CONSTRAINT "comment_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "comment" ADD CONSTRAINT "owner" FOREIGN KEY (tenant, "userId") REFERENCES "user"(tenant, username) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "dataset" ADD CONSTRAINT "dataset_datasourceId_fkey" FOREIGN KEY (tenant, "datasourceId") REFERENCES datasource(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "dataset" ADD CONSTRAINT "dataset_editingId_fkey" FOREIGN KEY (tenant, "editingId") REFERENCES dataset(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "dataset" ADD CONSTRAINT "dataset_folderId_fkey" FOREIGN KEY (tenant, "folderId") REFERENCES folder(tenant, id) ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "dataset" ADD CONSTRAINT "dataset_queryId_fkey" FOREIGN KEY (tenant, "queryId") REFERENCES query(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "dataset" ADD CONSTRAINT "dataset_reportId_fkey" FOREIGN KEY (tenant, "reportId") REFERENCES report(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "dataset" ADD CONSTRAINT "dataset_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "dataset" ADD CONSTRAINT "owner" FOREIGN KEY (tenant, "ownerId") REFERENCES principal(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "dataset_field" ADD CONSTRAINT "dataset_field_datasetId_fkey" FOREIGN KEY (tenant, "datasetId") REFERENCES dataset(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "dataset_field" ADD CONSTRAINT "dataset_field_fieldId_fkey" FOREIGN KEY (tenant, "fieldId") REFERENCES field(tenant, id) ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "dataset_field" ADD CONSTRAINT "dataset_field_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "dataset_filter" ADD CONSTRAINT "dataset_filter_datasetId_fkey" FOREIGN KEY (tenant, "datasetId") REFERENCES dataset(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "dataset_filter" ADD CONSTRAINT "dataset_filter_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "dataset_filter" ADD CONSTRAINT "owner" FOREIGN KEY (tenant, "ownerId") REFERENCES principal(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "dataset_history" ADD CONSTRAINT "dataset_history__sourceId_fkey" FOREIGN KEY (tenant, "_sourceId") REFERENCES dataset(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "dataset_history" ADD CONSTRAINT "dataset_history_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "dataset_share" ADD CONSTRAINT "dataset_share_datasetFilterId_fkey" FOREIGN KEY (tenant, "datasetFilterId") REFERENCES dataset_filter(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "dataset_share" ADD CONSTRAINT "dataset_share_datasetId_fkey" FOREIGN KEY (tenant, "datasetId") REFERENCES dataset(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "dataset_share" ADD CONSTRAINT "dataset_share_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "dataset_share" ADD CONSTRAINT "shared_to" FOREIGN KEY (tenant, "principalId") REFERENCES principal(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "datasource" ADD CONSTRAINT "datasource_fileId_fkey" FOREIGN KEY (tenant, "fileId") REFERENCES file(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "datasource" ADD CONSTRAINT "datasource_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "datasource" ADD CONSTRAINT "owner" FOREIGN KEY (tenant, "ownerId") REFERENCES principal(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "datasource_feature" ADD CONSTRAINT "datasource_feature_datasourceId_fkey" FOREIGN KEY (tenant, "datasourceId") REFERENCES datasource(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "datasource_feature" ADD CONSTRAINT "datasource_feature_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "datasource_share" ADD CONSTRAINT "datasource_share_datasourceId_fkey" FOREIGN KEY (tenant, "datasourceId") REFERENCES datasource(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "datasource_share" ADD CONSTRAINT "datasource_share_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "datasource_share" ADD CONSTRAINT "shared_to" FOREIGN KEY (tenant, "principalId") REFERENCES principal(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "export_template" ADD CONSTRAINT "export_template_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "export_template" ADD CONSTRAINT "owner" FOREIGN KEY (tenant, "ownerId") REFERENCES "user"(tenant, username) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "feed" ADD CONSTRAINT "feed_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "feed" ADD CONSTRAINT "owner" FOREIGN KEY (tenant, "userId") REFERENCES "user"(tenant, username) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "feed" ADD CONSTRAINT "team" FOREIGN KEY (tenant, "teamId") REFERENCES team(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "field" ADD CONSTRAINT "code_fk" FOREIGN KEY (tenant, "codeId") REFERENCES code(tenant, id) ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "field" ADD CONSTRAINT "field_datasourceId_fkey" FOREIGN KEY (tenant, "datasourceId") REFERENCES datasource(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "field" ADD CONSTRAINT "field_mappingPath_fkey" FOREIGN KEY (tenant, "mappingPath") REFERENCES mapping(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "field" ADD CONSTRAINT "field_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "file" ADD CONSTRAINT "file_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "file" ADD CONSTRAINT "owner" FOREIGN KEY (tenant, "ownerId") REFERENCES principal(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "link" ADD CONSTRAINT "link_fromId_fkey" FOREIGN KEY (tenant, "fromId") REFERENCES mapping(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "link" ADD CONSTRAINT "link_parentId_fkey" FOREIGN KEY (tenant, "parentId") REFERENCES link(tenant, id) ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "link" ADD CONSTRAINT "link_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "link" ADD CONSTRAINT "link_toId_fkey" FOREIGN KEY (tenant, "toId") REFERENCES mapping(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "map" ADD CONSTRAINT "map_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "mapping" ADD CONSTRAINT "mapping_datasourceId_fkey" FOREIGN KEY (tenant, "datasourceId") REFERENCES datasource(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "mapping" ADD CONSTRAINT "mapping_setId_fkey" FOREIGN KEY (tenant, "setId") REFERENCES set(tenant, id) ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "mapping" ADD CONSTRAINT "mapping_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "principal" ADD CONSTRAINT "principal_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "principal" ADD CONSTRAINT "team" FOREIGN KEY (tenant, "teamId") REFERENCES team(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "principal" ADD CONSTRAINT "user" FOREIGN KEY (tenant, "userId") REFERENCES "user"(tenant, username) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "principal_activity" ADD CONSTRAINT "principal_activity_activityId_fkey" FOREIGN KEY (tenant, "activityId") REFERENCES activity(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "principal_activity" ADD CONSTRAINT "principal_activity_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "report" ADD CONSTRAINT "owner" FOREIGN KEY (tenant, "ownerId") REFERENCES principal(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "report" ADD CONSTRAINT "report_datasourceId_fkey" FOREIGN KEY (tenant, "datasourceId") REFERENCES datasource(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "report" ADD CONSTRAINT "report_editingId_fkey" FOREIGN KEY (tenant, "editingId") REFERENCES report(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "report" ADD CONSTRAINT "report_folderId_fkey" FOREIGN KEY (tenant, "folderId") REFERENCES folder(tenant, id) ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "report" ADD CONSTRAINT "report_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "report_history" ADD CONSTRAINT "report_history__sourceId_fkey" FOREIGN KEY (tenant, "_sourceId") REFERENCES report(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "report_history" ADD CONSTRAINT "report_history_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "report_share" ADD CONSTRAINT "report_share_reportId_fkey" FOREIGN KEY (tenant, "reportId") REFERENCES report(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "report_share" ADD CONSTRAINT "report_share_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "report_share" ADD CONSTRAINT "shared_to" FOREIGN KEY (tenant, "principalId") REFERENCES principal(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "saved_query_filter" ADD CONSTRAINT "owner" FOREIGN KEY (tenant, "ownerId") REFERENCES "user"(tenant, username) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "saved_query_filter" ADD CONSTRAINT "saved_query_filter_mappingId_fkey" FOREIGN KEY (tenant, "mappingId") REFERENCES mapping(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "saved_query_filter" ADD CONSTRAINT "saved_query_filter_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "set" ADD CONSTRAINT "set_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "system_feature" ADD CONSTRAINT "system_feature_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "team" ADD CONSTRAINT "domain" FOREIGN KEY (tenant, domain) REFERENCES domain(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "team" ADD CONSTRAINT "team_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "team_member" ADD CONSTRAINT "team" FOREIGN KEY (tenant, "teamId") REFERENCES team(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "team_member" ADD CONSTRAINT "team_member_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "team_member" ADD CONSTRAINT "user" FOREIGN KEY (tenant, "userId") REFERENCES "user"(tenant, username) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "upload" ADD CONSTRAINT "owner" FOREIGN KEY (tenant, "ownerId") REFERENCES "user"(tenant, username) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "upload" ADD CONSTRAINT "upload_datasetId_fkey" FOREIGN KEY (tenant, "datasetId") REFERENCES dataset(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "upload" ADD CONSTRAINT "upload_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "user" ADD CONSTRAINT "domain" FOREIGN KEY (tenant, domain) REFERENCES domain(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "user" ADD CONSTRAINT "user_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "user_settings" ADD CONSTRAINT "user_settings_datasetId_fkey" FOREIGN KEY (tenant, "datasetId") REFERENCES dataset(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "user_settings" ADD CONSTRAINT "user_settings_queryId_fkey" FOREIGN KEY (tenant, "queryId") REFERENCES query(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "user_settings" ADD CONSTRAINT "user_settings_reportId_fkey" FOREIGN KEY (tenant, "reportId") REFERENCES report(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "user_settings" ADD CONSTRAINT "user_settings_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "visual" ADD CONSTRAINT "owner" FOREIGN KEY (tenant, "ownerId") REFERENCES principal(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "visual" ADD CONSTRAINT "report_fk" FOREIGN KEY ("reportId", tenant) REFERENCES report(id, tenant) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "visual" ADD CONSTRAINT "visual_datasetId_fkey" FOREIGN KEY (tenant, "datasetId") REFERENCES dataset(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "visual" ADD CONSTRAINT "visual_datasourceId_fkey" FOREIGN KEY (tenant, "datasourceId") REFERENCES datasource(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "visual" ADD CONSTRAINT "visual_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "query" ADD CONSTRAINT "owner" FOREIGN KEY (tenant, "ownerId") REFERENCES principal(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "query" ADD CONSTRAINT "query_datasourceId_fkey" FOREIGN KEY (tenant, "datasourceId") REFERENCES datasource(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "query" ADD CONSTRAINT "query_editingId_fkey" FOREIGN KEY (tenant, "editingId") REFERENCES query(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "query" ADD CONSTRAINT "query_folderId_fkey" FOREIGN KEY (tenant, "folderId") REFERENCES folder(tenant, id) ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "query" ADD CONSTRAINT "query_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "query_history" ADD CONSTRAINT "query_history__sourceId_fkey" FOREIGN KEY (tenant, "_sourceId") REFERENCES query(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "query_history" ADD CONSTRAINT "query_history_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "query_share" ADD CONSTRAINT "query_share_queryId_fkey" FOREIGN KEY (tenant, "queryId") REFERENCES query(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "query_share" ADD CONSTRAINT "query_share_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "query_share" ADD CONSTRAINT "shared_to" FOREIGN KEY (tenant, "principalId") REFERENCES principal(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "dataset_exceptions" ADD CONSTRAINT "dataset_exceptions_datasetId_fkey" FOREIGN KEY (tenant, "datasetId") REFERENCES dataset(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "dataset_exceptions" ADD CONSTRAINT "dataset_exceptions_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "domain" ADD CONSTRAINT "domain_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "session" ADD CONSTRAINT "session_parent_fkey" FOREIGN KEY (parent) REFERENCES session(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "session" ADD CONSTRAINT "session_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "session" ADD CONSTRAINT "user" FOREIGN KEY (tenant, username) REFERENCES "user"(tenant, username) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "token" ADD CONSTRAINT "token_datasetId_fkey" FOREIGN KEY (tenant, "datasetId") REFERENCES dataset(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "token" ADD CONSTRAINT "token_datasourceId_fkey" FOREIGN KEY (tenant, "datasourceId") REFERENCES datasource(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "token" ADD CONSTRAINT "token_queryId_fkey" FOREIGN KEY (tenant, "queryId") REFERENCES query(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "token" ADD CONSTRAINT "token_reportId_fkey" FOREIGN KEY (tenant, "reportId") REFERENCES report(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "token" ADD CONSTRAINT "token_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "token" ADD CONSTRAINT "token_visualId_fkey" FOREIGN KEY (tenant, "visualId") REFERENCES visual(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "token" ADD CONSTRAINT "user" FOREIGN KEY (tenant, username) REFERENCES "user"(tenant, username) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "job" ADD CONSTRAINT "job_datasetId_fkey" FOREIGN KEY (tenant, "datasetId") REFERENCES dataset(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "job" ADD CONSTRAINT "job_datasourceId_fkey" FOREIGN KEY (tenant, "datasourceId") REFERENCES datasource(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "job" ADD CONSTRAINT "job_editingId_fkey" FOREIGN KEY (tenant, "editingId") REFERENCES job(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "job" ADD CONSTRAINT "job_queryId_fkey" FOREIGN KEY (tenant, "queryId") REFERENCES query(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "job" ADD CONSTRAINT "job_reportId_fkey" FOREIGN KEY (tenant, "reportId") REFERENCES report(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "job" ADD CONSTRAINT "job_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "job" ADD CONSTRAINT "owner" FOREIGN KEY (tenant, "ownerId") REFERENCES principal(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "job_history" ADD CONSTRAINT "job_history_jobId_fkey" FOREIGN KEY (tenant, "jobId") REFERENCES job(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "job_history" ADD CONSTRAINT "job_history_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "job_history" ADD CONSTRAINT "owner" FOREIGN KEY (tenant, "ownerId") REFERENCES principal(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "job_dataset" ADD CONSTRAINT "job_dataset_datasetId_fkey" FOREIGN KEY (tenant, "datasetId") REFERENCES dataset(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "job_dataset" ADD CONSTRAINT "job_dataset_jobId_fkey" FOREIGN KEY (tenant, "jobId") REFERENCES job(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "job_dataset" ADD CONSTRAINT "job_dataset_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "job_file" ADD CONSTRAINT "job_data_file_fkey" FOREIGN KEY (tenant, "fileId") REFERENCES file(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "job_file" ADD CONSTRAINT "job_file_jobId_fkey" FOREIGN KEY (tenant, "jobId") REFERENCES job(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "job_file" ADD CONSTRAINT "job_file_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "function" ADD CONSTRAINT "function_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "folder" ADD CONSTRAINT "folder_parentId_fkey" FOREIGN KEY (tenant, "parentId") REFERENCES folder(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "folder" ADD CONSTRAINT "folder_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "tag" ADD CONSTRAINT "tag_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "tag_entity" ADD CONSTRAINT "tag_entity_datasetId_fkey" FOREIGN KEY (tenant, "datasetId") REFERENCES dataset(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "tag_entity" ADD CONSTRAINT "tag_entity_queryId_fkey" FOREIGN KEY (tenant, "queryId") REFERENCES query(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "tag_entity" ADD CONSTRAINT "tag_entity_reportId_fkey" FOREIGN KEY (tenant, "reportId") REFERENCES report(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "tag_entity" ADD CONSTRAINT "tag_entity_tagId_fkey" FOREIGN KEY (tenant, "tagId") REFERENCES tag(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "tag_entity" ADD CONSTRAINT "tag_entity_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "color" ADD CONSTRAINT "color_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "dataset_visual" ADD CONSTRAINT "dataset_visual_datasetId_fkey" FOREIGN KEY (tenant, "datasetId") REFERENCES dataset(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "dataset_visual" ADD CONSTRAINT "dataset_visual_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "dataset_visual" ADD CONSTRAINT "dataset_visual_visual" FOREIGN KEY (tenant, "visualId") REFERENCES visual(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "tenant" ADD CONSTRAINT "tenant_defaultDomainId_fkey" FOREIGN KEY (id, "defaultDomainId") REFERENCES domain(tenant, id) ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "tenant" ADD CONSTRAINT "tenant_defaultTeamId_fkey" FOREIGN KEY (id, "defaultTeamId") REFERENCES team(tenant, id) ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "suite" ADD CONSTRAINT "datasource_fkey" FOREIGN KEY (tenant, "datasourceId") REFERENCES datasource(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "suite" ADD CONSTRAINT "default_partition" FOREIGN KEY (tenant, "defaultPartitionId") REFERENCES suite_partition(tenant, id) ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "suite" ADD CONSTRAINT "suite_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "suite_partition" ADD CONSTRAINT "suite_fkey" FOREIGN KEY (tenant, "suiteId") REFERENCES suite(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "suite_partition" ADD CONSTRAINT "suite_partition_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "suite_mapping" ADD CONSTRAINT "mapping_fkey" FOREIGN KEY (tenant, "mappingId") REFERENCES mapping(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "suite_mapping" ADD CONSTRAINT "suite_fkey" FOREIGN KEY (tenant, "suiteId") REFERENCES suite(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "suite_mapping" ADD CONSTRAINT "suite_mapping_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "suite_entry" ADD CONSTRAINT "mapping_fkey" FOREIGN KEY (tenant, "mappingId") REFERENCES suite_mapping(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "suite_entry" ADD CONSTRAINT "partition_fkey" FOREIGN KEY (tenant, "partitionId") REFERENCES suite_partition(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "suite_entry" ADD CONSTRAINT "suite_entry_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "suite_entry" ADD CONSTRAINT "suite_fkey" FOREIGN KEY (tenant, "suiteId") REFERENCES suite(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "code" ADD CONSTRAINT "code_tenant_fk" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "code" ADD CONSTRAINT "dataset_fk" FOREIGN KEY ("datasetId", tenant) REFERENCES dataset(id, tenant) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "code" ADD CONSTRAINT "datasource_fk" FOREIGN KEY ("datasourceId", tenant) REFERENCES datasource(id, tenant) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "code" ADD CONSTRAINT "descriptionfield_fk" FOREIGN KEY ("descriptionFieldId", tenant) REFERENCES field(id, tenant) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "code" ADD CONSTRAINT "mapping_fk" FOREIGN KEY ("mappingId", tenant) REFERENCES mapping(id, tenant) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "code" ADD CONSTRAINT "valuefield_fk" FOREIGN KEY ("valueFieldId", tenant) REFERENCES field(id, tenant) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "bundle" ADD CONSTRAINT "bundle_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "bundle_entry" ADD CONSTRAINT "bundle_entry_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "bundle_entry" ADD CONSTRAINT "bundle_fkey" FOREIGN KEY (tenant, "bundleId") REFERENCES bundle(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "bundle_entry" ADD CONSTRAINT "dataset_fkey" FOREIGN KEY (tenant, "datasetId") REFERENCES dataset(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "bundle_entry" ADD CONSTRAINT "datasource_fkey" FOREIGN KEY (tenant, "datasourceId") REFERENCES datasource(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "bundle_entry" ADD CONSTRAINT "job_fkey" FOREIGN KEY (tenant, "jobId") REFERENCES job(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "bundle_entry" ADD CONSTRAINT "query_fkey" FOREIGN KEY (tenant, "queryId") REFERENCES query(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "bundle_entry" ADD CONSTRAINT "report_fkey" FOREIGN KEY (tenant, "reportId") REFERENCES report(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "bundle_entry" ADD CONSTRAINT "tag_fkey" FOREIGN KEY (tenant, "tagId") REFERENCES tag(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "bundle_entry" ADD CONSTRAINT "team_fkey" FOREIGN KEY (tenant, "teamId") REFERENCES team(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "bundle_entry" ADD CONSTRAINT "user_fkey" FOREIGN KEY (tenant, username) REFERENCES "user"(tenant, username) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "user_field" ADD CONSTRAINT "user_field_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "report_dataset" ADD CONSTRAINT "report_dataset_datasetId_fkey" FOREIGN KEY (tenant, "datasetId") REFERENCES dataset(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "report_dataset" ADD CONSTRAINT "report_dataset_reportId_fkey" FOREIGN KEY (tenant, "reportId") REFERENCES report(tenant, id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
ALTER TABLE "report_dataset" ADD CONSTRAINT "report_dataset_tenant_fkey" FOREIGN KEY (tenant) REFERENCES tenant(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON comment FOR EACH ROW EXECUTE FUNCTION comment_update_etag();
CREATE TRIGGER change_query_owner AFTER UPDATE ON dataset FOR EACH ROW WHEN (old."ownerId"::text IS DISTINCT FROM new."ownerId"::text) EXECUTE FUNCTION update_query_owner();
CREATE TRIGGER delete_dataset AFTER DELETE ON dataset FOR EACH ROW EXECUTE FUNCTION delete_orphan_datasource();
CREATE TRIGGER delete_query AFTER DELETE ON dataset FOR EACH ROW EXECUTE FUNCTION delete_orphan_query();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON dataset FOR EACH ROW EXECUTE FUNCTION dataset_update_etag();
CREATE TRIGGER insert_unique_slug BEFORE INSERT ON dataset FOR EACH ROW WHEN (new.name IS NOT NULL) EXECUTE FUNCTION ensure_unique_owner_slug();
CREATE TRIGGER update_unique_slug BEFORE UPDATE ON dataset FOR EACH ROW WHEN (new.name IS NOT NULL AND (new."ownerId"::text <> old."ownerId"::text OR new.name::text <> old.name::text)) EXECUTE FUNCTION ensure_unique_owner_slug();
CREATE TRIGGER zz_insert_unique_es_index_name BEFORE INSERT ON dataset FOR EACH ROW EXECUTE FUNCTION ensure_unique_es_index_name();
CREATE TRIGGER zz_update_unique_es_index_name BEFORE UPDATE ON dataset FOR EACH ROW WHEN (old."esIndexName" IS NULL OR new."esIndexName" <> old."esIndexName" OR new.tenant <> old.tenant) EXECUTE FUNCTION ensure_unique_es_index_name();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON dataset_field FOR EACH ROW EXECUTE FUNCTION dataset_field_update_etag();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON dataset_filter FOR EACH ROW EXECUTE FUNCTION dataset_filter_update_etag();
CREATE TRIGGER insert_dataset_history BEFORE INSERT ON dataset_history FOR EACH ROW EXECUTE FUNCTION insert_dataset_history();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON dataset_share FOR EACH ROW EXECUTE FUNCTION dataset_share_update_etag();
CREATE TRIGGER update_dataset_timestamp_on_share AFTER INSERT OR UPDATE ON dataset_share FOR EACH ROW EXECUTE FUNCTION update_new_dataset_timestamp();
CREATE TRIGGER update_dataset_timestamp_on_unshare AFTER DELETE OR UPDATE ON dataset_share FOR EACH ROW EXECUTE FUNCTION update_old_dataset_timestamp();
CREATE TRIGGER delete_datasource AFTER DELETE ON datasource FOR EACH ROW EXECUTE FUNCTION delete_datasource();
CREATE TRIGGER drop_workspace_schema AFTER DELETE ON datasource FOR EACH ROW WHEN (old.type::text = 'workspace'::text) EXECUTE FUNCTION drop_workspace_schema();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON datasource FOR EACH ROW EXECUTE FUNCTION datasource_update_etag();
CREATE TRIGGER insert_unique_slug BEFORE INSERT ON datasource FOR EACH ROW WHEN (new.name IS NOT NULL) EXECUTE FUNCTION ensure_unique_owner_slug();
CREATE TRIGGER update_embedded_datasource_idrefs AFTER UPDATE ON datasource FOR EACH ROW WHEN (old.id <> new.id) EXECUTE FUNCTION update_query_datasource_idrefs();
CREATE TRIGGER update_unique_slug BEFORE UPDATE ON datasource FOR EACH ROW WHEN (new.name IS NOT NULL AND (new."ownerId"::text <> old."ownerId"::text OR new.name::text <> old.name::text)) EXECUTE FUNCTION ensure_unique_owner_slug();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON datasource_share FOR EACH ROW EXECUTE FUNCTION datasource_share_update_etag();
CREATE TRIGGER update_datasource_timestamp_on_share AFTER INSERT OR UPDATE ON datasource_share FOR EACH ROW EXECUTE FUNCTION update_new_datasource_timestamp();
CREATE TRIGGER update_datasource_timestamp_on_unshare AFTER DELETE OR UPDATE ON datasource_share FOR EACH ROW EXECUTE FUNCTION update_old_datasource_timestamp();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON field FOR EACH ROW EXECUTE FUNCTION field_update_etag();
CREATE TRIGGER "setnull_dataset_field_fieldId_fkey" AFTER DELETE ON field REFERENCING OLD TABLE AS "DELETED_fields" FOR EACH STATEMENT EXECUTE FUNCTION ondelete_setnull_dataset_field_fieldid_fkey();
CREATE TRIGGER update_field_id BEFORE UPDATE ON field FOR EACH ROW WHEN (old."datasourceId" <> new."datasourceId") EXECUTE FUNCTION update_field_id();
CREATE TRIGGER delete_file_lob AFTER DELETE ON file FOR EACH ROW EXECUTE FUNCTION delete_file_lob();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON link FOR EACH ROW EXECUTE FUNCTION link_update_etag();
CREATE TRIGGER "setnull_link_parentId_fkey" AFTER DELETE ON link REFERENCING OLD TABLE AS "DELETED_links" FOR EACH STATEMENT EXECUTE FUNCTION ondelete_setnull_link_parentid_fkey();
CREATE TRIGGER update_link_id BEFORE UPDATE ON link FOR EACH ROW WHEN (old."fromId"::text <> new."fromId"::text) EXECUTE FUNCTION update_link_id();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON map FOR EACH ROW EXECUTE FUNCTION map_update_etag();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON mapping FOR EACH ROW EXECUTE FUNCTION mapping_update_etag();
CREATE TRIGGER update_mapping_id BEFORE UPDATE ON mapping FOR EACH ROW WHEN (old."datasourceId" <> new."datasourceId") EXECUTE FUNCTION update_mapping_id();
CREATE TRIGGER update_principal_id BEFORE UPDATE ON principal FOR EACH ROW EXECUTE FUNCTION update_principal_id();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON report FOR EACH ROW EXECUTE FUNCTION report_update_etag();
CREATE TRIGGER insert_unique_slug BEFORE INSERT ON report FOR EACH ROW WHEN (new.name IS NOT NULL) EXECUTE FUNCTION ensure_unique_owner_slug();
CREATE TRIGGER update_unique_slug BEFORE UPDATE ON report FOR EACH ROW WHEN (new.name IS NOT NULL AND (new."ownerId"::text <> old."ownerId"::text OR new.name::text <> old.name::text)) EXECUTE FUNCTION ensure_unique_owner_slug();
CREATE TRIGGER insert_report_history BEFORE INSERT ON report_history FOR EACH ROW EXECUTE FUNCTION insert_report_history();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON report_share FOR EACH ROW EXECUTE FUNCTION report_share_update_etag();
CREATE TRIGGER update_report_timestamp_on_share AFTER INSERT OR UPDATE ON report_share FOR EACH ROW EXECUTE FUNCTION update_new_report_timestamp();
CREATE TRIGGER update_report_timestamp_on_unshare AFTER DELETE OR UPDATE ON report_share FOR EACH ROW EXECUTE FUNCTION update_old_report_timestamp();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON saved_query_filter FOR EACH ROW EXECUTE FUNCTION saved_query_filter_update_etag();
CREATE TRIGGER "setnull_mapping_setId_fkey" AFTER DELETE ON set REFERENCING OLD TABLE AS "DELETED_sets" FOR EACH STATEMENT EXECUTE FUNCTION ondelete_setnull_mapping_setid_fkey();
CREATE TRIGGER create_principal AFTER INSERT ON team FOR EACH ROW EXECUTE FUNCTION create_team_principal();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON team FOR EACH ROW EXECUTE FUNCTION team_update_etag();
CREATE TRIGGER "setnull_tenant_defaultTeamId_fkey" AFTER DELETE ON team REFERENCING OLD TABLE AS "DELETED_teams" FOR EACH STATEMENT EXECUTE FUNCTION ondelete_setnull_tenant_defaultteamid_fkey();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON team_member FOR EACH ROW EXECUTE FUNCTION team_member_update_etag();
CREATE TRIGGER update_user_timestamp_on_member_add AFTER INSERT OR UPDATE ON team_member FOR EACH ROW EXECUTE FUNCTION update_user_add_timestamp();
CREATE TRIGGER update_user_timestamp_on_member_remove AFTER DELETE OR UPDATE ON team_member FOR EACH ROW EXECUTE FUNCTION update_user_remove_timestamp();
CREATE TRIGGER admin_force_enabled BEFORE UPDATE OF enabled ON "user" FOR EACH ROW WHEN (new.username::text = 'admin'::text AND new.enabled IS FALSE) EXECUTE FUNCTION admin_force_enabled();
CREATE TRIGGER check_num_licensed_users BEFORE INSERT OR UPDATE ON "user" FOR EACH ROW EXECUTE FUNCTION check_num_licensed_users();
CREATE TRIGGER create_principal AFTER INSERT ON "user" FOR EACH ROW EXECUTE FUNCTION create_user_principal();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON "user" FOR EACH ROW EXECUTE FUNCTION user_update_etag();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON visual FOR EACH ROW EXECUTE FUNCTION visual_update_etag();
CREATE TRIGGER delete_embedded_datasource AFTER DELETE ON query FOR EACH ROW WHEN (old."editingId" IS NULL) EXECUTE FUNCTION delete_embedded_datasource();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON query FOR EACH ROW EXECUTE FUNCTION query_update_etag();
CREATE TRIGGER insert_unique_slug BEFORE INSERT ON query FOR EACH ROW WHEN (new.name IS NOT NULL) EXECUTE FUNCTION ensure_unique_owner_slug();
CREATE TRIGGER update_unique_slug BEFORE UPDATE ON query FOR EACH ROW WHEN (new.name IS NOT NULL AND (new."ownerId"::text <> old."ownerId"::text OR new.name::text <> old.name::text)) EXECUTE FUNCTION ensure_unique_owner_slug();
CREATE TRIGGER insert_query_history BEFORE INSERT ON query_history FOR EACH ROW EXECUTE FUNCTION insert_query_history();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON query_share FOR EACH ROW EXECUTE FUNCTION query_share_update_etag();
CREATE TRIGGER update_query_timestamp_on_share AFTER INSERT OR UPDATE ON query_share FOR EACH ROW EXECUTE FUNCTION update_new_query_timestamp();
CREATE TRIGGER update_query_timestamp_on_unshare AFTER DELETE OR UPDATE ON query_share FOR EACH ROW EXECUTE FUNCTION update_old_query_timestamp();
CREATE TRIGGER "setnull_tenant_defaultDomainId_fkey" AFTER DELETE ON domain REFERENCING OLD TABLE AS "DELETED_domains" FOR EACH STATEMENT EXECUTE FUNCTION ondelete_setnull_tenant_defaultdomainid_fkey();
CREATE TRIGGER delete_expired_sessions AFTER INSERT OR UPDATE ON session FOR EACH STATEMENT EXECUTE FUNCTION delete_expired_sessions();
CREATE TRIGGER update_session_expiration BEFORE UPDATE ON session FOR EACH ROW EXECUTE FUNCTION update_session_expiration();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON job FOR EACH ROW EXECUTE FUNCTION job_update_etag();
CREATE TRIGGER insert_unique_slug BEFORE INSERT ON job FOR EACH ROW WHEN (new.name IS NOT NULL) EXECUTE FUNCTION ensure_unique_owner_slug();
CREATE TRIGGER update_unique_slug BEFORE UPDATE ON job FOR EACH ROW WHEN (new.name IS NOT NULL AND (new."ownerId"::text <> old."ownerId"::text OR new.name::text <> old.name::text)) EXECUTE FUNCTION ensure_unique_owner_slug();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON job_history FOR EACH ROW EXECUTE FUNCTION job_history_update_etag();
CREATE TRIGGER limit_job_history_on_insert AFTER INSERT ON job_history FOR EACH ROW EXECUTE FUNCTION limit_job_history();
CREATE TRIGGER delete_job_dataset AFTER DELETE ON job_dataset FOR EACH ROW EXECUTE FUNCTION delete_orphan_job_dataset();
CREATE TRIGGER delete_job_file AFTER DELETE ON job_file FOR EACH ROW EXECUTE FUNCTION delete_orphan_job_file();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON folder FOR EACH ROW EXECUTE FUNCTION folder_update_etag();
CREATE TRIGGER "setnull_dataset_folderId_fkey" AFTER DELETE ON folder REFERENCING OLD TABLE AS "DELETED_folders" FOR EACH STATEMENT EXECUTE FUNCTION ondelete_setnull_dataset_folderid_fkey();
CREATE TRIGGER "setnull_query_folderId_fkey" AFTER DELETE ON folder REFERENCING OLD TABLE AS "DELETED_folders" FOR EACH STATEMENT EXECUTE FUNCTION ondelete_setnull_query_folderid_fkey();
CREATE TRIGGER "setnull_report_folderId_fkey" AFTER DELETE ON folder REFERENCING OLD TABLE AS "DELETED_folders" FOR EACH STATEMENT EXECUTE FUNCTION ondelete_setnull_report_folderid_fkey();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON tag FOR EACH ROW EXECUTE FUNCTION tag_update_etag();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON tag_entity FOR EACH ROW EXECUTE FUNCTION tag_entity_update_etag();
CREATE TRIGGER update_entity_timestamp_on_tag_add AFTER INSERT OR UPDATE ON tag_entity FOR EACH ROW EXECUTE FUNCTION update_tag_entity_add_timestamp();
CREATE TRIGGER update_entity_timestamp_on_tag_remove AFTER DELETE OR UPDATE ON tag_entity FOR EACH ROW EXECUTE FUNCTION update_tag_entity_remove_timestamp();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON color FOR EACH ROW EXECUTE FUNCTION color_update_etag();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON tenant FOR EACH ROW EXECUTE FUNCTION tenant_update_etag();
CREATE TRIGGER prune_job_histories_on_update AFTER UPDATE ON tenant FOR EACH ROW WHEN (new."jobHistorySize" < old."jobHistorySize" AND new."jobHistorySize" > 0) EXECUTE FUNCTION prune_all_job_histories();
CREATE TRIGGER z_add_tenant_role AFTER INSERT ON tenant FOR EACH ROW EXECUTE FUNCTION add_tenant_role();
CREATE TRIGGER z_update_tenant_role AFTER UPDATE OF id ON tenant FOR EACH ROW EXECUTE FUNCTION update_tenant_role();
CREATE TRIGGER etag_update AFTER INSERT OR DELETE OR UPDATE ON suite FOR EACH ROW EXECUTE FUNCTION suite_update_etag();
CREATE TRIGGER insert_unique_slug BEFORE INSERT ON suite FOR EACH ROW WHEN (new.name IS NOT NULL) EXECUTE FUNCTION ensure_unique_slug();
CREATE TRIGGER update_suite_slug BEFORE INSERT OR UPDATE ON suite FOR EACH ROW EXECUTE FUNCTION update_suite_slug();
CREATE TRIGGER update_unique_slug BEFORE UPDATE ON suite FOR EACH ROW WHEN (new.name IS NOT NULL AND new.name <> old.name) EXECUTE FUNCTION ensure_unique_slug();
CREATE TRIGGER setnull_suite_default_partition AFTER DELETE ON suite_partition REFERENCING OLD TABLE AS "DELETED_suite_partitions" FOR EACH STATEMENT EXECUTE FUNCTION ondelete_setnull_suite_default_partition();
CREATE TRIGGER "setnull_field_codeId_fkey" AFTER DELETE ON code REFERENCING OLD TABLE AS "DELETED_codes" FOR EACH STATEMENT EXECUTE FUNCTION ondelete_setnull_field_codeid_fkey();
CREATE TRIGGER insert_unique_slug BEFORE INSERT ON bundle FOR EACH ROW WHEN (new.name IS NOT NULL) EXECUTE FUNCTION ensure_unique_slug();
CREATE TRIGGER update_unique_slug BEFORE UPDATE ON bundle FOR EACH ROW WHEN (new.name IS NOT NULL AND new.name <> old.name) EXECUTE FUNCTION ensure_unique_slug();
CREATE TRIGGER delete_user_field_value BEFORE DELETE ON user_field FOR EACH ROW EXECUTE FUNCTION delete_user_field_data();
CREATE TRIGGER update_user_field_type AFTER UPDATE ON user_field FOR EACH ROW WHEN (old.type <> new.type) EXECUTE FUNCTION delete_user_field_data();
