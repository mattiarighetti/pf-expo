  <master>
    <property name="page_title">@page_title;noquote@</property>
    <property name="context">@context;noquote@</property>
    
        <div class="container">
      @fe_html_menu;noquote@    
      <br>
      <div class="row">
        <div class="col-md-2">
      <a target="_blank" href="http://www.pfawards.it/"><img class="img-responsive" style="display:inline-block;" width="auto" src="http://images.professionefinanza.com/banners/pfawards16-short.gif" /></a>
  </div>
  <div class="col-md-8">
    <center>
    <img class="center-block" style="display:inline-block;" height="100px" width="auto" src="@logo_url;noquote@" />
  </center>
  </div>
  <div class="col-md-2">
      <a target="_blank" href="http://www.pfawards.it/"><img class="img-responsive" style="display:inline-block;" width="auto" src="http://images.professionefinanza.com/banners/pfawards16-short.gif" /></a>
    </div>
  </div>
      </br> 
      <if @ref;noquote@ eq "padova">
      <h1>Grazie per esserti registrato alle prossime edizioni</h1>
      <h4>Ti invieremo una mail di promemoria. Nel frattempo <a href="webcal://pfexpo.professionefinanza.com/padova.ics" class="btn btn-default"><span class="glyphicon glyphicon-calendar"> Segnatelo in agenda</span></a>.
	  </if>
      <if @ref;noquote@ eq "milano">
	<h1>Grazie per esserti registrato alle prossime edizioni</h1>
	<h4>Ti invieremo una mail di promemoria. Nel frattempo <a href="http://pfexpo.professionefinanza.com/milano.ics" class="btn btn-default"><span class="glyphicon glyphicon-calendar"> Segnatelo in agenda</span></a>.
      </if>
      <if @ref;noquote@ eq "">
	<formtemplate id="next_edition"></formtemplate>
      </if>
    </div>