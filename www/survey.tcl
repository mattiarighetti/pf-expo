ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 03 Devember 2014
} {
    iscritto_id:naturalnum
}
set page_title "Survey - PF Expo 2015"
set package_id [ad_conn package_id]
ad_set_cookie iscritto_id $iscritto_id
set nominativo [db_string query "select nome||' '|| cognome from expo_iscritti where iscritto_id = :iscritto_id"]
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where attivo is true limit 1"]
template::add_footer -html "<script src=\"https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js\"></script>"
template::head::add_css -href "expo_style.css" 
set fe_html_menu [pf::fe_html_menu -id 1]
ad_return_template
