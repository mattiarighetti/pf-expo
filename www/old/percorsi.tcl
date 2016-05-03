ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Tuesday 26 May 2015
}
set page_title "Percorsi"
set context [list $page_title]
set fe_html_menu [pf::fe_html_menu -id 7]
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where attivo is true"]
set expo_id [db_string query "select expo_id from expo_edizioni where attivo is true"]
set html "<div class=\"row \">"
db_foreach query "select percorso_id, descrizione, hex_color from expo_percorsi order by percorso_id" {
    append html "<div class=\"col-sm-12 col-md-12 col-lg-12\"><div class=\"panel\" style=\"border-color:$hex_color;\"><div class=\"panel-heading\" style=\"background-image:linear-gradient(to bottom, $hex_color 0%, $hex_color 100%);color:$hex_color;\"><center><h3 class=\"text-center\" style=\"color:#fff\">$descrizione</h3></center></div><!--<div class=\"panel-body text-center\"></div>--><ul class=\"list-group list-group-flush text-center\">"
    db_foreach query "select evento_id, denominazione, permalink from expo_eventi where percorso_id = :percorso_id and expo_id = :expo_id" {
      append html "<li class=\"list-group-item\"><a href=\"http://pfexpo.professionefinanza.com/programma/$permalink\"><i class=\"icon-ok text-danger\"></i>$denominazione</a></li>"
    }
    append html "</ul></div></div>"
  }
append html "</div>"
template::head::add_css -href "expo_style.css" 
ad_return_template
