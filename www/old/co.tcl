add_page_contract {
}
db_foreach query "select distinct(lower(email)) as email from expo_iscritti where expo_id = 2" {
    set max_id [db_string query "select iscritto_id from expo_iscritti where email ilike :email and expo_id = 2 order by iscritto_id desc, data desc limit 1"]
    db_foreach query "select iscritto_id from expo_iscritti where email ilike :email and iscritto_id < :max_id and expo_id = 2" {
	db_dml query "delete from expo_iscrizioni where iscritto_id = :iscritto_id"
	db_dml query "delete from expo_iscritti where iscritto_id = :iscritto_id"
    }
}
ad_returnredirect index
ad_script_abort
