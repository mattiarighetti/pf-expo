
# 

ad_page_contract {
    
Form con registrazione newsletter per eventi futuri
    
    @author mattia (mattia.righetti@professionefinanza.com)
    @creation-date 2015-02-10
    @cvs-id $Id$
} {
    expo_id:naturalnum
    msg:optional
} -properties {
} -validate {
} -errors {
}
set page_title "PFEXPO - Iscriviti"
if {[info exists msg] && $msg eq "ok"} {
    set msg_html "<div class=\"alert alert-success alert-dismissible\" role=\"alert\"><button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button><strong>Grazie!</strong> Verrai notificato via email appena si apriranno le iscrizioni.</div>"
} else {
    set msg_html ""
}
set pfexpo [db_string query "select initcap(permalink) from expo_edizioni where expo_id = :expo_id"]
ad_form -name iscritto \
    -mode edit \
    -html "class grid-form" \
    -export {expo_id} \
    -form {
	iscritto_id:key
	{nominativo:text
	    {html {maxlength "100" size "50" placeholder "Nome e cognome"}}
	}
	{email:text
	    {label "Email"}
	    {html {maxlength "100" size "50" placeholder "email" style "text-transform:lowercase"}}
	}
	{cellulare:text
	    {label "Cellulare"}
	    {html {maxlength "100" size "50" placeholder "Cellulare"}}
	}
	{privacy:boolean(checkbox),optional
	    {label "Privacy"}
	    {options {{"Accetto" 1}}}
	    {html {size "1" style "width:50px"}}
	}
    } -after_submit {
	ad_returnredirect "newsletter?msg=ok&expo_id=$expo_id"
	ad_script_abort
    } -validate {
	{cellulare
	    {[string length $cellulare] > 8}
	    "Il cellulare dev'essere in formato: 340123456789"
	}
	{cellulare
	    {[string index $cellulare 0] eq "3"}
	    "Il numero non inizia con 3!"
	}
	{email
	    {[string match "*@*.*" $email] == 1}
	    "Indirizzo email non valido."
	}
    } -on_submit {
	db_dml query "insert into expo_newsletter (email, expo_id, nominativo, cellulare) values (:email, :expo_id, :nominativo, :cellulare)"
    }
