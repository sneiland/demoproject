<cfswitch expression="#rc.helpaction#">
	<cfcase value="main.default">
		<cfinclude template="fragments/main_default.cfm">
	</cfcase>
	<cfcase value="main.server">
		<cfinclude template="fragments/main_server.cfm">
	</cfcase>
	<cfdefaultcase>
		No help file found
	</cfdefaultcase>
</cfswitch>