ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Tuesday 26 May 2015
} {
    partner_id:integer
    {expo_id [pf::expo::id]}
}
db_transaction {
    set intestazione [db_string query "select denominazione from expo_partners where partner_id = :partner_id"]
    set page_title $intestazione
    set context [list [list /relatori "Relatori"] $page_title]
    set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
    append logo_url [db_string query "select immagine from expo_edizioni where attivo is true limit 1"]
  #  set fe_html_menu [pf::fe_html_menu -id 3]
    set portrait [db_string query "select immagine from expo_partners where partner_id = :partner_id"]
    set descrizione_par [db_string query "select descrizione from expo_partners where partner_id = :partner_id"]
}
if {[db_0or1row query "select * from expo_eventi e, expo_eve_par r where r.partner_id = :partner_id and e.evento_id = r.evento_id and e.expo_id = :expo_id limit 1"]} {
    set events_table "<table class=\"table table-hover\"><tr><th>Evento</th><th>Ore</th><th>Sala</th><th>&nbsp;</th></tr>"
    db_foreach query "select e.evento_id, e.permalink, e.denominazione, to_char(e.start_time, 'HH24:MI') as start_time, s.denominazione as sala from expo_eventi e, expo_sale s, expo_eve_par r where r.partner_id = :partner_id and e.evento_id = r.evento_id and e.sala_id = s.sala_id and e.expo_id = :expo_id" {
	append events_table "<tr><td>$denominazione</td><td>$start_time</td><td>$sala</td><td><a class=\"btn btn-success\" href=\"http://pfexpo.professionefinanza.com/programma/$permalink\" role=\"button\">Dettagli</a></td></tr>"
    }
    append events_table "</table>"
} else {
    set events_table ""
}
ad_return_template
