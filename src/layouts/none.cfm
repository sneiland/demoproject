<cfsetting enablecfoutputonly="true">
<cfsetting showdebugoutput="false">
<!--- Stop layout cascading to default --->
<cfset request.layout = false>
<cfoutput>#body#</cfoutput>