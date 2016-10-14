ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 2015-11-16
    @cvs-id $Id$set oacs:msg
} {
    {expo_id [pf::expo::id]}
}
#Basic settings
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where expo_id = :expo_id"]
#Comincia estrazione eventi per lista
set eventlist_html ""
db_foreach query "select e.evento_id, e.denominazione, substring(e.descrizione, 1, 500) as descrizione, to_char(e.start_time, 'HH24:MI') as start_time, e.permalink as evento_link, to_char(e.end_time, 'HH24:MI') as end_time, case when e.prezzo = 0::text::money then 'Percorso gratuito' else 'Percorso a pagamento*' end as prezzo, p.hex_color, p.descrizione as percorso, s.denominazione as sala from expo_eventi e, expo_percorsi p, expo_sale s where e.percorso_id = p.percorso_id and e.sala_id = s.sala_id and e.expo_id = :expo_id order by e.start_time, e.sala_id" {
    set descrizione [string map {"<b>" "" "</b>" "" "<i>" "" "</i>" "" "<u>" "" "</u>" ""} $descrizione]
    append descrizione "..."
    #Prima e seconda colonna
    append eventlist_html "<div class=\"row\" style=\"background: -webkit-linear-gradient(white, $hex_color);background: -o-linear-gradient(white, $hex_color);background: -moz-linear-gradient(white, $hex_color);background: linear-gradient(white, $hex_color);\"><div class=\"col-md-4\"><p style=\"text-align:center\"><font color=\"$hex_color\">$percorso</font></p><h3 class=\"text-center\">$denominazione</h3><p class=\"text-center\" style=\"color:gray\"><b>$start_time - $end_time</b> Sala $sala <br>$prezzo</p></div><div class=\"col-md-8\"><p><i>$descrizione</i></p>"
    if {[db_0or1row query "select * from expo_speakers r, expo_eventi_speakers e where r.speaker_id = e.speaker_id and e.evento_id = :evento_id limit 1"] || [db_0or1row query "select * from docenti d, expo_eve_doc e where d.docente_id = e.docente_id and e.evento_id = :evento_id limit 1"]} {
	append eventlist_html "<br><div class=\"row\"><b>Speaker:</b><br>"
	set return_url [ns_urlencode http://pfexpo.professionefinanza.com/#programma]
	# Estrae docenti legati all'evento
	db_foreach query "select d.nome, d.cognome, d.immagine, d.docente_id, d.permalink from docenti d, expo_eve_doc e where d.docente_id = e.docente_id and e.evento_id = :evento_id" {
	    set permalink [export_vars -base $permalink {return_url}]
            append eventlist_html "<a href=\"http://docenti.professionefinanza.com/$permalink\"><img class=\"img-circle\" src=\"http://images.professionefinanza.com/docenti/$immagine\" title=\"$nome $cognome\" width=\"50\" height=\"50\"></a>"
	}
	# Estrae speaker legati all'evento
	db_foreach query "select r.nome, r.cognome, r.immagine, r.speaker_id, r.permalink from expo_speakers r, expo_eventi_speakers e where r.speaker_id = e.speaker_id and e.evento_id = :evento_id" {
	    append eventlist_html "<a href=\"http://pfexpo.professionefinanza.com/speakers/$permalink\"><img class=\"img-circle\" src=\"http://images.professionefinanza.com/pfexpo/speakers_portraits/$immagine\" title=\"$nome $cognome\" width=\"50\" height=\"50\"></a>"
	}
	append eventlist_html "</div><br>" 
    } 
    if {[db_0or1row query "select * from expo_partners p, expo_eve_par e where e.evento_id = :evento_id and e.partner_id = p.partner_id limit 1"]} {
	append eventlist_html "<div class=\"row\"><b>Partner:</b><br>"
	#Estrae partners legati all'evento
	db_foreach query "select p.denominazione, p.partner_id, p.immagine, p.permalink from expo_partners p, expo_eve_par e where e.evento_id = :evento_id and e.partner_id = p.partner_id" {
	    append eventlist_html "<a href=\"http://pfexpo.professionefinanza.com/partners/$permalink\"><img height=\"70px\" class=\"img-circle\" src=\"http://images.professionefinanza.com/pfexpo/partners_portraits/$immagine\" alt=\"$denominazione\" width=\"auto\" /></a>"
	}
	append eventlist_html "</div>"
    }
    append eventlist_html "<button type=\"button\" class=\"btn btn-default\" onclick=\"window.location.href='http://pfexpo.professionefinanza.com/programma/$evento_link'\">Dettagli</button></div></div><br>"
}
ad_return_template
