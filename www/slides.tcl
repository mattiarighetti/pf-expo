ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 03 Devember 2014
} {
    {iscritto_id ""}
}
set page_title "Survey - PF Expo 2015"
if {$iscritto_id eq ""} {
    set cookie [ad_get_cookie iscritto_id]
    if {$cookie ne ""} {
	set iscritto_id [ad_get_cookie iscritto_id]
    } else {
	ad_script_abort
    }
}
set nominativo [db_string query "select nome||' '||cognome from expo_iscritti where iscritto_id = :iscritto_id"]
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where attivo is true"]
template::add_footer -html "<script src=\"https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js\"></script>"
template::head::add_css -href "expo_style.css" 
set table_html "<table class=\"table table-hover\">"
db_foreach query "select distinct(evento_id) from expo_presenze where iscritto_id = :iscritto_id" {
    set materiali [db_string query "select materiali from expo_eventi where evento_id = :evento_id"]
    set denominazione [db_string query "select denominazione from expo_eventi where evento_id = :evento_id"]
    if {$materiali == "#"} {
	append table_html "<tr><td>$denominazione</td><td>Lucidi non pervenuti.</td></tr>"
    } else {
	append table_html "<tr><td>$denominazione</td><td><a class=\"btn btn-primary\" href=\"$materiali\" target=\"_blank\"><span class=\"glyphicon glyphicon-download-alt\"> Scarica PDF</span></a></td></tr>"
    }
}
append table_html "</table>"
ad_return_template
