<cfcomponent extends="controller" output="false">

	<cffunction name="default" access="public" output="false">
		<cfargument name="rc" required="true" type="struct">

		<cfparam name="rc.helpaction" default="">

		<cfset variables.fw.setLayout('none')>
	</cffunction>

</cfcomponent>