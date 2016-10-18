ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Tuesday 26 May 2015
} {
    {expo_id [pf::expo::id]}
}
set page_title "Partners"
set context [list $page_title]
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where attivo is true"]
set partners_list_html "<div class=\"container\"><div class=\"row\">"
db_foreach query "select categoria_id, descrizione as categoria from expo_par_cat order by item_order" {
    if {[db_0or1row query "select * from expo_partners p, expo_edizioni_partners e where e.partner_id = p.partner_id and e.expo_id = :expo_id and p.categoria_id = :categoria_id limit 1"]} {
	append partners_list_html "<center><h2>$categoria</h2></center><div class=\"row\">"
	db_foreach query "select p.partner_id, p.immagine, p.permalink from expo_partners p, expo_edizioni_partners e where p.categoria_id = :categoria_id and e.expo_id = :expo_id and e.partner_id = p.partner_id order by item_order, denominazione" {
	    append partners_list_html "<div class=\"text-center col-lg-4 col-md-4 col-sm-6 col-xs-12\">
<a target=\"\" href=\"http://pfexpo.professionefinanza.com/partners/$permalink\">
<img class=\"img-circle\" style=\"margin:25px;padding:10px;height:180px;\" src=\"http://images.professionefinanza.com/pfexpo/partners_portraits/$immagine\">
</a>
</div>"
	}
	append partners_list_html "</div><br>"
    }
}
append partners_list_html "</div></div>"
ad_return_template
