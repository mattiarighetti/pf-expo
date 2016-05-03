ad_page_contract {
} {
    {persona_id ""}
}
if {$persona_id == ""} {
    set persona_id [db_string query "select persona_id from crm_persone where user_id = [ad_conn user_id]"]
}
db_dml query "update expo_iscrizioni set pagato = true where persona_id = :persona_id"
ad_returnredirect "programma?message=ok"
ad_script_abort
