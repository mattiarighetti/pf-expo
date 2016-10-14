# 

ad_page_contract {
    
    Form di iscrizione per i visitatori.
    
    @author mattia (mattia.righetti@professionefinanza.com)
    @creation-date 2015-11-27
    @cvs-id $Id$
} {
    
} -properties {
} -validate {
} -errors {
}
set page_title "PFEXPO - Iscriviti"
set session_id [ad_get_cookie session_id]
set expo_id [db_string query "select expo_id from expo_edizioni where attivo is true"]
set event_list_html "<ul class=\"list-group\">"
db_foreach query "select e.denominazione, to_char(e.start_time, 'HH24:MI') as start_time, s.denominazione as sala, case when e.prezzo > 0::money then ', a pagamento' else '' end as pagamento from expo_eventi e, expo_sale s, expo_tmp t where t.evento_id = e.evento_id and t.session_id = :session_id and e.sala_id = s.sala_id order by e.evento_id" {
    append event_list_html "<li>$denominazione <small>(Sala $sala, $start_time$pagamento)</small></li>"
}
append event_list_html "</ul>"
ad_form -name iscritto \
    -mode edit \
    -html "class grid-form" \
    -form {
	iscritto_id:key
