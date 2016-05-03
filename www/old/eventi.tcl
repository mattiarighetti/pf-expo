ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Tuesday 26 May 2015
} 
set page_title "Eventi"
set context [list $page_title]
set fe_html_menu [pf::fe_html_menu -id 7]
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where attivo is true"]
template::head::add_css -href "timetable.css"
set message ""
set user_id [ad_conn user_id]
if {$user_id && ![db_0or1row query "select * from parties where party_id = :user_id and email like '%@professionefinanza.com' limit 1"]} {
    set persona_id [db_string query "select persona_id from crm_persone where user_id = :user_id"]
    if {[db_0or1row query "select * from expo_iscrizioni i, expo_eventi e where i.persona_id = :persona_id and e.prezzo > 0::money and e.expo_id = 2 limit 1"]} {
	set message "<div class=\"alert alert-danger\">Ti sei iscritto a corsi a pagamento. Per confermare la tua iscrizione, prego completare l'acquisto.</div>"
    }
}
#Comincia estrazione eventi per lista
set html ""
db_foreach query "select e.evento_id, e.denominazione, substring(e.descrizione, 1, 500) as descrizione, to_char(e.start_time, 'HH24:MI') as start_time, e.permalink as evento_link, to_char(e.end_time, 'HH24:MI') as end_time, case when e.prezzo = 0::text::money then 'Percorso gratuito' else 'Percorso a pagamento*' end as prezzo, p.hex_color, p.descrizione as percorso, s.denominazione as sala from expo_eventi e, expo_percorsi p, expo_sale s, expo_edizioni d where e.percorso_id = p.percorso_id and e.sala_id = s.sala_id and e.expo_id = d.expo_id and d.attivo is true order by e.start_time, e.sala_id" {
    set descrizione [string map {"<b>" "" "</b>" "" "<i>" "" "</i>" "" "<u>" "" "</u>" ""} $descrizione]
    append descrizione "..."
    #Prima e seconda colonna
    append html "<div class=\"row\"><div class=\"col-md-4\"><p style=\"text-align:center\"><font color=\"$hex_color\">$percorso</font></p><h3 class=\"text-center\">$denominazione</h3><p class=\"text-center\" style=\"color:gray\"><b>$start_time - $end_time</b> Sala $sala <br>$prezzo</p></div><div class=\"col-md-8\"><p><i>$descrizione</i></p>"
    if {[db_0or1row query "select * from expo_relatori r, expo_eve_rel e where r.relatore_id = e.relatore_id and e.evento_id = :evento_id limit 1"] || [db_0or1row query "select * from docenti d, expo_eve_doc e where d.docente_id = e.docente_id and e.evento_id = :evento_id limit 1"]} {
	append html "<br><div class=\"row\"><b>Speaker:</b><br>"
	# Estrae docenti legati all'evento
	db_foreach query "select d.nome, d.cognome, d.immagine, d.docente_id, d.permalink from docenti d, expo_eve_doc e where d.docente_id = e.docente_id and e.evento_id = :evento_id" {
            append html "<a href=\"http://docenti.professionefinanza.com/$permalink\"><img class=\"img-circle\" src=\"http://images.professionefinanza.com/docenti/$immagine\" title=\"$nome $cognome\" width=\"50\" height=\"50\"></a>"
	}
	# Estrae relatori legati all'evento
	db_foreach query "select r.nome, r.cognome, r.immagine, r.relatore_id, r.permalink from expo_relatori r, expo_eve_rel e where r.relatore_id = e.relatore_id and e.evento_id = :evento_id" {
	    append html "<a href=\"http://pfexpo.professionefinanza.com/relatori/$permalink\"><img class=\"img-circle\" src=\"http://images.professionefinanza.com/pfexpo/relatori_portraits/$immagine\" title=\"$nome $cognome\" width=\"50\" height=\"50\"></a>"
	}
	append html "</div><br>" 
    } 
    if {[db_0or1row query "select * from expo_partners p, expo_eve_par e where e.evento_id = :evento_id and e.partner_id = p.partner_id limit 1"]} {
	append html "<div class=\"row\"><b>Partner:</b><br>"
	#Estrae partners legati all'evento
	db_foreach query "select p.denominazione, p.partner_id, p.immagine, p.permalink from expo_partners p, expo_eve_par e where e.evento_id = :evento_id and e.partner_id = p.partner_id" {
	    append html "<a href=\"http://pfexpo.professionefinanza.com/partners/$permalink\"><img height=\"70px\" class=\"img-circle\" src=\"http://images.professionefinanza.com/pfexpo/partners_portraits/$immagine\" alt=\"$denominazione\" width=\"auto\" /></a>"
	}
	append html "</div>"
    }
    append html "<button type=\"button\" class=\"btn btn-default\" onclick=\"window.location.href='http://expo.professionefinanza.com/programma/$evento_link'\">Dettagli</button>"
    append html "</div></div><br>"
    append html "<hr style=\"width: 100%; color: black; height: 1px; background-color:lightgray;\" />"
}
template::head::add_css -href "expo_style.css" 
ad_return_template
