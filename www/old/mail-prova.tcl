ad_page_contract {
}
set to_mail "mattiarighe@me.com"
set subject "Conferma iscrizione all'evento PFEXPO"
set body {<html><body><p>Prva</p></body></html>}
set text [open /tmp/mail-pfexpo.txt w]
puts $text $body
close $text
with_catch error_msg {
    exec curl --url "smtps://smtp.gmail.com:465" --ssl-reqd --mail-from "mattia.righetti@professionefinanza.com" --mail-rcpt "mattiarighe@me.com" --upload-file /tmp/mail-pfexpo.txt --user "mattia.righetti@professionefinanza.com:sheldoncooper" --insecure
} {
    #
}
ns_unlink /tmp/mail-pfexpo.txt
ad_returnredirect index
ad_script_abort
