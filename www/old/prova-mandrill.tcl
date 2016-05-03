ad_page_contract {}
with_catch errmsg {
    exec curl -H "Content-Type: application/json" -d '{"key": "qyiG4vN3tJvbxJIdN1DwBQ","message": {"text": "Prova","subject": "example subject","from_email": "webmaster@pfexpo.com","to":[{"email":"mattia.righetti@professionefinanza.com"}]}}' http://mandrillapp.com/api/1.0/messages/send
} {
    ns_log notice "ewer $errmsg"
}
ad_returnredirect index
ad_script_abort
