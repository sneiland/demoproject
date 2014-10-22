<cfcomponent displayname="Gateway" output="false">

	<cfset variables.dsn = "">

	<cffunction name="init" output="false">
		<cfargument name="dsn" required="true" type="string">

		<cfset setDSN(arguments.dsn)>

		<cfreturn this>
	</cffunction>


	<cffunction name="getDSN" access="public" output="false" returntype="string">
		<cfreturn variables.dsn>
	</cffunction>


	<cffunction name="setDSN" access="public" output="false" returntype="void">
		<cfargument name="dsn" required="true" type="string">
		<cfset variables.dsn = arguments.dsn>
	</cffunction>

</cfcomponent>