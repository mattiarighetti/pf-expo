ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Tuesday 26 May 2015
}
set page_title "Partners"
set context [list $page_title]
set fe_html_menu [pf::fe_html_menu -id 6]
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where attivo is true"]
set html "<div class=\"row\">"
db_foreach query "select partner_id, denominazione, permalink, immagine from expo_partners where visibile is true order by denominazione" {
    append html "<div class=\"col-lg-4\"><center><a href=\"partners/$permalink\"><img class=\"center-block\" src=\"http://images.professionefinanza.com/pfexpo/partners_portraits/$immagine\" alt=\"$denominazione\" width=\"200px\" height=\"200px\"></a></center></div>"
}
append html "</div>"
template::head::add_css -href "/expo_style.css" 
ad_return_template
