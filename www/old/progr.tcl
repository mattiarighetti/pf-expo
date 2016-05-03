ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Tuesday 26 May 2015
} {
    {message ""}
}
set page_title "Programma"
set context [list $page_title]
set fe_html_menu [pf::fe_html_menu -id 3]
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where report is null limit 1"]
set message ""
set user_id [ad_conn user_id]
if {$user_id && ![db_0or1row query "select * from users where user_id = :user_id and username like '%@professionefinanza.com' limit 1"]} {
    set persona_id [db_string query "select persona_id from crm_persone where user_id = :user_id"]
    if {[db_0or1row query "select * from expo_iscrizioni i, expo_eventi e where i.persona_id = :persona_id and e.prezzo > 0::money limit 1"]} {
	set message "<div class=\"alert alert-danger\">Ti sei iscritto a corsi a pagamento. Per confermare la tua iscrizione, prego completare l'acquisto.<button type=\"button\" class=\"btn btn-info\">Paga con carta</button></div>"
    }
}
#Comincia estrazione eventi per lista
set html ""
db_foreach query "select e.evento_id, e.denominazione, substring(e.descrizione, 1, 300) as descrizione, to_char(e.start_time, 'HH24:MI') as start_time, e.permalink as evento_link, to_char(e.end_time, 'HH24:MI') as end_time, case when e.prezzo = 0::text::money then 'Percorso gratuito' else 'Percorso a pagamento*' end as prezzo, p.hex_color, p.descrizione as percorso, s.denominazione as sala from expo_eventi e, expo_percorsi p, expo_sale s where e.percorso_id = p.percorso_id and e.sala_id = s.sala_id order by e.start_time, e.sala_id" {
    set descrizione [string map {"<b>" "" "</b>" "" "<i>" "" "</i>" "" "<u>" "" "</u>" ""} $descrizione]
    append descrizione "..."
    #Prima e seconda colonna
    append html "<div class=\"row\"><div class=\"col-md-4\"><p style=\"text-align:center\"><font color=\"$hex_color\">$percorso</font></p><h3 class=\"text-center\">$denominazione</h3><p class=\"text-center\" style=\"color:gray\"><b>$start_time - $end_time</b> Sala $sala <br>$prezzo</p></div><div class=\"col-md-6\"><p><i>$descrizione</i></p><div class=\"row\">"
    #Estrae partners legati all'evento
    db_foreach query "select p.denominazione, p.partner_id, p.immagine, p.permalink from expo_partners p, expo_eve_par e where e.evento_id = :evento_id and e.partner_id = p.partner_id" {
	append html "<img height=\"70px\" class=\"img-circle\" src=\"http://images.professionefinanza.com/pfexpo/partners_portraits/$immagine\" alt=\"$denominazione\" width=\"auto\" />"
    }
    append html "</div></div><div class=\"col-md-2\"><center>"
    #Estrae relatori legati all'evento
    db_foreach query "select r.nome, r.cognome, r.immagine, r.relatore_id from expo_relatori r, expo_eve_rel e where r.relatore_id = e.relatore_id and e.evento_id = :evento_id" {
	    append html "<div><img class=\"img-circle img-responsive center-block\" src=\"http://images.professionefinanza.com/pfexpo/relatori_portraits/$immagine\" alt=\"$nome $cognome\" width=\"50\" height=\"50\"><p><b>$nome $cognome</b></p></div><br>"
    }
    append html "<button type=\"button\" class=\"btn btn-default\" onclick=\"window.location.href='http://expo.professionefinanza.com/programma/$evento_link'\">Dettagli</button>"
    if {![ad_conn user_id]} {
	append html "<button type=\"button\" class=\"btn btn-primary\" onclick=\"window.location.href='http://sso.professionefinanza.com/register/?return_url=[ad_return_url -qualified]'\">Iscriviti</button></center></div></div><br>"
    } else {
	if {![db_0or1row query "select persona_id from crm_persone where user_id = [ad_conn user_id]"]} {
	    break
	}
	set persona_id [db_string query "select persona_id from crm_persone where user_id = [ad_conn user_id]"]
	if {[db_0or1row query "select * from expo_iscrizioni where evento_id = :evento_id and persona_id = :persona_id limit 1"]} {
	    append html "<button data-toggle=\"modal\" class=\"btn btn-danger\" data-target=\"#myModal\">Cancella</button></center></div></div><br>"
	} else {
	append html "<button data-toggle=\"modal\" class=\"btn btn-success\" data-target=\"#myModal\">Partecipa</button></center></div></div><br>"
	}
    }
    append html "<br><hr></br>"
}
template::head::add_css -href "expo_style.css" 
ad_return_template
