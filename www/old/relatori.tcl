ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Tuesday 26 May 2015
}
set page_title "Relatori"
set context [list $page_title]
set fe_html_menu [pf::fe_html_menu -id 3]
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where attivo is true"]
#Estrae docenti
set docenti "<div class=\"row\">"
db_foreach query "select d.docente_id, d.nome, d.cognome, d.immagine, d.permalink from docenti d, expo_eve_doc o, expo_eventi e, expo_edizioni z where z.attivo is true and z.expo_id = e.expo_id and e.evento_id = o.evento_id and d.docente_id = o.docente_id group by d.docente_id, d.nome, d.cognome, d.immagine, d.permalink order by d.cognome" {
    append permalink "?return_url=[ad_return_url -urlencode -qualified]"
    append docenti "<div class=\"col-lg-4\"><a href=\"http://docenti.professionefinanza.com/$permalink\"><img class=\"img-circle\" src=\"http://images.professionefinanza.com/docenti/$immagine\" alt=\"$nome $cognome\" width=\"140\" height=\"140\"><h2>$nome $cognome</h2></a></div><!-- /.col-lg-4 -->"
}
append docenti "</div>"
# Estrae relatori
set relatori "<div class=\"row\">"
db_foreach query "select r.relatore_id, r.nome, r.cognome, r.immagine, r.permalink from expo_relatori r, expo_eventi e, expo_edizioni d, expo_eve_rel l where d.attivo is true and d.expo_id = e.expo_id and e.evento_id = l.evento_id and l.relatore_id = r.relatore_id order by cognome" {
    append relatori "<div class=\"col-lg-4\"><a href=\"relatori/$permalink\"><img class=\"img-circle\" src=\"http://images.professionefinanza.com/pfexpo/relatori_portraits/$immagine\" alt=\"$nome $cognome\" width=\"140\" height=\"140\"><h2>$nome $cognome</h2></a></div><!-- /.col-lg-4 -->"
}
append relatori "</div>"
template::head::add_css -href "/expo_style.css" 
ad_return_template
