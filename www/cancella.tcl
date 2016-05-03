ad_page_contract {
} {
    user_id
}
sdjfj
set persona_id [db_string query "select persona_id from crm_persone where user_id = :user_id"]
db_dml query "delete from crm_indirizzi where persona_id = :persona_id"
db_dml query "delete from awards_iscritti where persona_id = :persona_id"
db_dml query "delete from crm_contatti where persona_id = :persona_id"
db_dml query "delete from expo_iscrizioni where persona_id = :persona_id"
db_dml query "delete from crm_persone where persona_id = :persona_id"
ad_returnredirect "index"
ad_script_abort
