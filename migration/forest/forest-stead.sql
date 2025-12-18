-- Инструкция по удалению ДО ЛУ (аренда, бессрочное, безвозмездное, сервитуты)
-- 1.	Необходимо проверить привязаны ли к ДО ЛУ лесосеки. Для этого переходим в БД лесосек и запускаем скрипт:
-- Скрипт выводит номера РЛХ ДО, которые удалять нельзя, так как к ним привязаны лесосеки.
WITH pud_numbers_to_check AS (
    SELECT
        dpn.doc_pud_number_id,
        dpn.pud_number_no,
        dpncl.doc_pud_number_clearcut_link_id
    FROM
        doc_pud_number dpn
            LEFT JOIN
        doc_pud_number_clearcut_link dpncl ON dpn.doc_pud_number_id = dpncl.doc_pud_number_id
    WHERE
-- Тут указываем номера РЛХ из заявки
dpn.pud_number_no IN (
                      'РЛХ-20250120-2821961', 'РЛХ-20250212-5280793', 'РЛХ-20250214-5522009'
    )
)
SELECT
    p.pud_number_no AS "Номер РЛХ",
    p.doc_pud_number_id AS "ID документа",
    CASE
        WHEN p.doc_pud_number_clearcut_link_id IS NULL THEN 'Нет связи с лесосекой'
        ELSE 'Есть связь с лесосекой (ID: ' || p.doc_pud_number_clearcut_link_id || ')'
        END AS "Статус связи",
    CASE
        WHEN p.doc_pud_number_clearcut_link_id IS NULL THEN 'Можно удалить'
        ELSE 'Нельзя удалить - есть связь с лесосекой'
        END AS "Возможность удаления"
FROM
    pud_numbers_to_check p
ORDER BY
    p.pud_number_no;

-- Если скрипт выдал что есть связь с лесосеками, то не удаляем и пишем:

-- "РЛХ-xxxxxxx-xxxxxxx - Документ основания нельзя удалить из ГЛР, т.к. есть связь с лесосекой."

-- 2.	Далее необходимо запустить скрипт на удаление ДО в БД ЛУ.
-- В скрипте необходимо указать номера РЛХ, которые прошли проверку в п.1 с результатом «Можно удалить».
--
DO
$$
    DECLARE
        --Номера РЛХ для удаления
        doc_numbers TEXT[] := ARRAY['РЛХ-20250212-5280793', 'РЛХ-20250214-5522009'];
        doc_number TEXT;
        doc_record RECORD;
        related_doc_record RECORD;
        deleted_count INTEGER := 0;
        not_deleted_docs TEXT[] := '{}';
        temp_basis_doc_id BIGINT;
    BEGIN
        -- Создаем временную таблицу для хранения basis_doc_id, которые нельзя удалять
        CREATE TEMP TABLE restricted_docs (basis_doc_id BIGINT) ON COMMIT DROP;

        -- Находим документы, которые нельзя удалять (есть в project_info)
        INSERT INTO restricted_docs
        SELECT DISTINCT bd.basis_doc_id
        FROM basis_doc bd
                 JOIN project_info pi ON pi.basis_doc_id = bd.basis_doc_id
        WHERE bd.incoming_doc_cval = ANY(doc_numbers);

        -- Перебираем все входящие номера РЛХ
        FOREACH doc_number IN ARRAY doc_numbers LOOP
                -- Проверяем, есть ли документ в restricted_docs
                PERFORM 1 FROM basis_doc bd
                                   JOIN restricted_docs rd ON rd.basis_doc_id = bd.basis_doc_id
                WHERE bd.incoming_doc_cval = doc_number;

                IF FOUND THEN
                    -- Документ нельзя удалять, добавляем в список не удаленных
                    not_deleted_docs := not_deleted_docs || doc_number;
                    RAISE NOTICE 'Документ % нельзя удалить, так как он используется в project_info', doc_number;
                    CONTINUE;
                END IF;

                -- Находим основной документ для удаления
                FOR doc_record IN
                    SELECT basis_doc_id, forest_stead_right_id, forest_stead_right_restrict_id,
                           basis_doc_no, basis_doc_dt, region_code, create_dttm
                    FROM basis_doc
                    WHERE incoming_doc_cval = doc_number
                    LOOP
                        BEGIN
                            -- Начинаем транзакцию для каждого документа
                            BEGIN
                                -- Удаляем связанные записи в правильном порядке

                                -- 1. Сначала обновляем ссылки в basis_doc на forest_stead_right_restrict
                                UPDATE basis_doc
                                SET forest_stead_right_restrict_id = NULL
                                WHERE forest_stead_right_restrict_id = doc_record.forest_stead_right_restrict_id;

                                -- 2. Теперь можно удалять forest_stead_right_restrict
                                IF doc_record.forest_stead_right_restrict_id IS NOT NULL THEN
                                    DELETE FROM forest_stead_right_restrict
                                    WHERE forest_stead_right_restrict_id = doc_record.forest_stead_right_restrict_id;
                                END IF;

                                -- 3. Удаляем записи из таблиц, связанных с forest_stead_usage
                                DELETE FROM harvesting_year_volume
                                WHERE forest_stead_usage_id IN (
                                    SELECT forest_stead_usage_id FROM forest_stead_usage
                                    WHERE basis_doc_id = doc_record.basis_doc_id
                                );

                                DELETE FROM forest_usage_kind
                                WHERE forest_stead_usage_id IN (
                                    SELECT forest_stead_usage_id FROM forest_stead_usage
                                    WHERE basis_doc_id = doc_record.basis_doc_id
                                );

                                DELETE FROM forest_stead_usage
                                WHERE basis_doc_id = doc_record.basis_doc_id;

                                -- 4. Удаляем записи из таблиц, связанных с forest_facility
                                DELETE FROM quarter_taxation_forest_facility_link
                                WHERE forest_facility_id IN (
                                    SELECT forest_facility_id FROM forest_facility
                                    WHERE basis_doc_id = doc_record.basis_doc_id
                                );

                                DELETE FROM forest_facility
                                WHERE basis_doc_id = doc_record.basis_doc_id;

                                -- 5. Удаляем записи из таблиц, связанных с nonforest_facility
                                DELETE FROM quarter_taxation_nonforest_facility_link
                                WHERE nonforest_facility_id IN (
                                    SELECT nonforest_facility_id FROM nonforest_facility
                                    WHERE basis_doc_id = doc_record.basis_doc_id
                                );

                                DELETE FROM nonforest_facility
                                WHERE basis_doc_id = doc_record.basis_doc_id;

                                -- 6. Удаляем записи из таблиц, связанных с planting_characteristics
                                DELETE FROM quarter_taxation_planting_characteristics_link
                                WHERE planting_characteristics_id IN (
                                    SELECT planting_characteristics_id FROM planting_characteristics
                                    WHERE basis_doc_id = doc_record.basis_doc_id
                                );

                                DELETE FROM planting_characteristics
                                WHERE basis_doc_id = doc_record.basis_doc_id;

                                -- 7. Удаляем записи из таблиц, связанных с ozul
                                DELETE FROM quarter_taxation_ozul_link
                                WHERE ozul_id IN (
                                    SELECT ozul_id FROM ozul
                                    WHERE basis_doc_id = doc_record.basis_doc_id
                                );

                                DELETE FROM ozul
                                WHERE basis_doc_id = doc_record.basis_doc_id;

                                -- 8. Удаляем записи из других таблиц
                                DELETE FROM basis_doc_forest_stead_link
                                WHERE basis_doc_id = doc_record.basis_doc_id;

                                DELETE FROM basis_doc_info
                                WHERE basis_doc_id = doc_record.basis_doc_id;

                                DELETE FROM harvesting_volume_per_year
                                WHERE basis_doc_id = doc_record.basis_doc_id;

                                DELETE FROM responsibility_violation
                                WHERE basis_doc_id = doc_record.basis_doc_id;

                                DELETE FROM ozvl_volume_per_year
                                WHERE basis_doc_id = doc_record.basis_doc_id;

                                DELETE FROM reception_act_info
                                WHERE basis_doc_id = doc_record.basis_doc_id;

                                DELETE FROM profile_add_basis_doc
                                WHERE basis_doc_id = doc_record.basis_doc_id;

                                DELETE FROM average_taxation_indicator
                                WHERE basis_doc_id = doc_record.basis_doc_id;

                                DELETE FROM distribution_land
                                WHERE basis_doc_id = doc_record.basis_doc_id;

                                DELETE FROM not_harvesting_volume_per_year
                                WHERE basis_doc_id = doc_record.basis_doc_id;

                                DELETE FROM calendar_payment
                                WHERE basis_doc_id = doc_record.basis_doc_id;

		           DELETE FROM basic_doc_seller
                                WHERE basis_doc_id = doc_record.basis_doc_id;

                                       DELETE FROM doc_lease_payment
                                WHERE basis_doc_id = doc_record.basis_doc_id;

                                -- 9. Удаляем forest_stead_right (если есть)
                                IF doc_record.forest_stead_right_id IS NOT NULL THEN
                                    -- Сначала обновляем ссылки в basis_doc
                                    UPDATE basis_doc
                                    SET forest_stead_right_id = NULL
                                    WHERE forest_stead_right_id = doc_record.forest_stead_right_id;

                                    -- Затем удаляем сам forest_stead_right
                                    DELETE FROM forest_stead_right
                                    WHERE forest_stead_right_id = doc_record.forest_stead_right_id;
                                END IF;

                                -- 10. Удаляем основной документ
                                DELETE FROM basis_doc
                                WHERE basis_doc_id = doc_record.basis_doc_id;

                                -- Увеличиваем счетчик удаленных документов
                                deleted_count := deleted_count + 1;

                                -- Ищем связанные права с такими же данными
                                FOR related_doc_record IN
                                    SELECT basis_doc_id, forest_stead_right_id
                                    FROM basis_doc
                                    WHERE basis_doc_no = doc_record.basis_doc_no
                                      AND basis_doc_dt = doc_record.basis_doc_dt
                                      AND basis_doc_type_code = '001001000000'
                                      AND region_code = doc_record.region_code
                                      AND date_trunc('day', create_dttm) = date_trunc('day', doc_record.create_dttm)
                                      AND basis_doc_id != doc_record.basis_doc_id
                                    LOOP
                                        -- Удаляем связанные записи для прав
                                        DELETE FROM basis_doc_forest_stead_link
                                        WHERE basis_doc_id = related_doc_record.basis_doc_id;

                                        DELETE FROM profile_add_basis_doc
                                        WHERE basis_doc_id = related_doc_record.basis_doc_id;

                                        IF related_doc_record.forest_stead_right_id IS NOT NULL THEN
                                            -- Сначала обновляем ссылки в basis_doc
                                            UPDATE basis_doc
                                            SET forest_stead_right_id = NULL
                                            WHERE forest_stead_right_id = related_doc_record.forest_stead_right_id;

                                            -- Затем удаляем сам forest_stead_right
                                            DELETE FROM forest_stead_right
                                            WHERE forest_stead_right_id = related_doc_record.forest_stead_right_id;
                                        END IF;

                                        -- Удаляем само право
                                        DELETE FROM basis_doc
                                        WHERE basis_doc_id = related_doc_record.basis_doc_id;

                                        deleted_count := deleted_count + 1;
                                    END LOOP;

                                RAISE NOTICE 'Документ % успешно удален', doc_number;

                            EXCEPTION WHEN OTHERS THEN
                                -- В случае ошибки добавляем документ в список не удаленных
                                not_deleted_docs := not_deleted_docs || doc_number;
                                RAISE NOTICE 'Ошибка при удалении документа %: %', doc_number, SQLERRM;
                                CONTINUE;
                            END;
                        END;
                    END LOOP;
            END LOOP;

        -- Выводим результаты
        RAISE NOTICE 'Удалено документов: %', deleted_count;
        IF array_length(not_deleted_docs, 1) > 0 THEN
            RAISE NOTICE 'Не удалось удалить следующие документы: %', not_deleted_docs;
        END IF;
    END $$ language plpgsql;
-- 3.	После удаления документа в ПИЛ, необходимо также удалить документ в ПУД
--
-- - Удаляем в Swagger (нужен токен)  https://fgislk.gov.ru/rmdl/pud/registry-doc/swagger-ui/index.html?urls.primaryName=client#/API%20opensearch%20migration/deleteDocs


--Если ответ «200», то удалить в БД ПУД (doc_regisrty).
delete
from doc d
where d.doc_registry_key in ('РЛХ-20250506-4294504');

delete
from doc_file df
where df.doc_registry_key in ('РЛХ-20250506-4294504')

--     После выполнения запроса пишем ответ:
-- "Документ удален согласно обращению."
