ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 03 Devember 2014
}
set page_title "PF Expo 2015"
set package_id [ad_conn package_id]
set parameters_url [export_vars -base "/shared/parameters" {package_id return_url} ]
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where attivo is true"]
template::add_footer -html "<script src=\"https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js\"></script>"
template::head::add_css -href "expo_style.css" 
set fe_html_menu [pf::fe_html_menu -id 4]
ad_return_template
