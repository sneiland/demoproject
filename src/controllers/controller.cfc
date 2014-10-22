<cfcomponent displayname="Controller" output="false" hint="Contains common controller helper functions">

	<cffunction name="init" output="false">
		<cfargument name="fw">
		<cfset variables.fw = arguments.fw>
	</cffunction>


	<cffunction name="getService" access="private" output="false" returntype="any" hint="Convenience function for getting a service reference">
		<cfargument name="serviceName" required="true" type="string">

		<cfset var finalServiceName = arguments.ServiceName>

		<cfif NOT (arguments.serviceName contains "Service")>
			<cfset finalServiceName = arguments.ServiceName & "Service">
		</cfif>

		<cfreturn variables.fw.getBeanFactory().getBean(finalServiceName)>
	</cffunction>

</cfcomponent>