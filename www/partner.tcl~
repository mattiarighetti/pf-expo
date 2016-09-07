ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Tuesday 26 May 2015
} {
    relatore_id:integer
}
db_transaction {
    set intestazione [db_string query "select nome||' '||cognome from expo_relatori where relatore_id = :relatore_id"]
    set page_title $intestazione
    set context [list [list /relatori "Relatori"] $page_title]
    set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
    append logo_url [db_string query "select immagine from expo_edizioni where report is null limit 1"]
    set fe_html_menu [pf::fe_html_menu -id 3]
    set portrait [db_string query "select immagine from expo_relatori where relatore_id = :relatore_id"]
    set short_cv [db_string query "select short_cv from expo_relatori where relatore_id = :relatore_id"]
}
set events_table "<table class=\"table table-hover\"><tr><th>Evento</th><th>Ore</th><th>Sala</th><th>&nbsp;</th></tr>"
db_foreach query "select e.evento_id, e.permalink, e.denominazione, to_char(e.start_time, 'HH24:MI') as start_time, s.denominazione as sala, l.attivo from expo_eventi e, expo_sale s, expo_eve_rel r, expo_edizioni l where r.relatore_id = :relatore_id and e.evento_id = r.evento_id and e.sala_id = s.sala_id and l.attivo is true" {
    append events_table "<tr><td>$denominazione</td><td>$start_time</td><td>$sala</td><td><a class=\"btn btn-success\" href=\"http://pfexpo.professionefinanza.com/programma/$permalink\" role=\"button\">Dettagli</a></td></tr>"
}
append events_table "</table>"
template::head::add_css -href "/expo_style.css" 
ad_return_template
