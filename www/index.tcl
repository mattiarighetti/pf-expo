ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 2015-11-16
    @cvs-id $Id$set oacs:msg
} {
    {expo_id [pf::expo::id]}
}
#Basic settings
set page_title [db_string query "select 'PFEXPO - '||c.denominazione||' '||to_char(e.data, 'YYYY') from expo_edizioni e, expo_luoghi l, comuni c where c.comune_id = l.comune_id and e.luogo_id = l.luogo_id and expo_id = :expo_id"]
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where expo_id = :expo_id"]
set pfexpo_data [db_string query "select to_char(e.data, 'dd/mm/yyyy')||' - '||c.denominazione from expo_edizioni e, expo_luoghi l, comuni c where c.comune_id = l.comune_id and l.luogo_id = e.luogo_id and e.expo_id = :expo_id"]
set pfexpo_luogo [db_string query "select l.denominazione from expo_luoghi l, expo_edizioni e where e.expo_id = :expo_id and l.luogo_id = e.luogo_id"]
set location [db_string query "select indirizzo||' - '||c.denominazione from expo_luoghi l, expo_edizioni e, comuni c where e.expo_id = :expo_id and l.luogo_id = e.luogo_id and l.comune_id = c.comune_id"]
#CREAZIONE TABELLA ORARIA
set orari [db_list query "select * from (select start_time as orari from expo_eventi where expo_id = :expo_id union select end_time as orari from expo_eventi where expo_id = :expo_id) t order by orari"]
set events_table "<table cellspacing=\"5\" cellpadding=\"5\" class=\"tbl\"><tbody><tr class=\"blue\"><td><img class=\"center-block\" height=\"auto\" width=\"120px\" src=\"http://images.professionefinanza.com/logos/pfexpo.png\"></td>"
#Estrazione sale
db_foreach query "select s.denominazione from expo_sale s, expo_luoghi l, expo_edizioni e where e.expo_id = :expo_id and e.luogo_id = l.luogo_id and s.luogo_id = l.luogo_id order by s.sala_id" {
    append events_table "<td>" $denominazione "<br></td>"
}
append events_table "</tr>"
foreach orario $orari {
    append events_table "<tr>\n<td class=\"blue\">" [db_string query "select to_char('$orario'::timestamp, 'HH24:MI')"] "</td>\n"
    db_foreach query "select e.evento_id, e.denominazione, e.percorso_id, e.soldout,case when e.prezzo > 0::money then 'p' else 'g' end as prezzo, c.hex_color, e.permalink, e.start_time, e.end_time from expo_eventi e, expo_percorsi c where e.start_time = :orario and c.percorso_id = e.percorso_id order by sala_id" {
	set rowspan [expr [lsearch $orari $end_time] - [lsearch $orari $start_time]]
	append events_table "<td rowspan=\"" $rowspan "\" bgcolor=\"" $hex_color "\"><a href=\"/programma/" $permalink "\">"
	if {$prezzo eq "p"} {
	    append events_table "<img height=\"30px\" width=\"auto\" src=\"http://images.professionefinanza.com/pfexpo/icons/moneta_bianca.png\" align=\"right\">"
	}
	append events_table $denominazione "<br><img height=\"\" width=\"auto\" src=\"" "\" align=\"right\"><br>"
    	if {[db_0or1row query "select * from expo_percorsi where percorso_id = :percorso_id and icon_white is not null"]} {
	    set icon_white [db_string query "select icon_white from expo_percorsi where percorso_id = :percorso_id"]
	    append events_table "<img align=\"right\" width=\"30px\" src=\"http://images.professionefinanza.com/categorie/white/$icon_white\" />"
	}
	append events_table "</a></td>\n"
    }
    append events_table "</tr>\n"
}
append events_table "</tbody></table>"



#DIVIDER: #PARTNERS
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

#DIVIDER: #EDIZIONI

#DIVIDER: #CONTATTI
set google_maps [db_string query "select l.google_maps from expo_luoghi l, expo_edizioni e where e.expo_id = :expo_id and e.luogo_id = l.luogo_id"]

ad_return_template
