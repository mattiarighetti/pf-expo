ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Friday 03 Devember 2014
}
set page_title "PFEXPO - ProfessioneFinanza"
set package_id [ad_conn package_id]
set parameters_url [export_vars -base "/shared/parameters" {package_id return_url} ]
# Prepara Marquee
set marquee "<div style=\"display:inline-block\">"
db_foreach query "select citazione, relatore_id from expo_relatori where citazione is not null order by random()" {
    append marquee "<div class=\"row\"><div class=\"col-md-6\"><h1>&ldquo;</h1><p>$citazione</p><h1>&rdquo;</h1></div>"
    set nominativo [db_string query "select nome||' '||cognome from expo_relatori where relatore_id = :relatore_id"]
    set posizione [db_string query "select posizione from expo_relatori where relatore_id = :relatore_id"]
    append marquee "<div class=\"col-md-6\"><h4>$nominativo</h4><br><p>$posizione</p></div></div>"
}
append marquee "</div>"
set carousel_url "iscriviti"
#source seo.tcl
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where attivo is true"]
template::add_footer -html "<script src=\"https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js\"></script>"
template::head::add_css -href "expo_style.css" 
set fe_html_menu [pf::fe_html_menu -id 1]
set partners_html "<div class=\"container\"><div class=\"row\">"
db_foreach query "select categoria_id, descrizione as categoria from expo_par_cat order by item_order" {
    if {[db_0or1row query "select * from expo_partners where categoria_id = :categoria_id and visibile is true limit 1"]} {
	append partners_html "<div class=\"well well-sm\">$categoria</div><div style=\"overflow:hidden;display:block;position:relative;\"><ul style=\"display:block;list-style:none;margin:0;padding:0;\">"
	db_foreach query "select partner_id, immagine, permalink from expo_partners where categoria_id = :categoria_id and visibile is true order by item_order" {
	    append partners_html "<li rel=\"1\" style=\"position:relative;float:left;\"><a target=\"\" href=\"http://pfexpo.professionefinanza.com/partners/$permalink\"><img class=\"img-circle\" style=\"margin:25px;padding:10px;height:180px;\" src=\"http://images.professionefinanza.com/pfexpo/partners_portraits/$immagine\"></a></li>"
	}
	append partners_html "</ul></div><br>"
    }
}
append partners_html "</div></div>"
ad_return_template
