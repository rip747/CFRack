<cfcomponent output="false">

	<cffunction name="init">
		<cfargument name="app" type="any" required="true">
		<cfset variables.app = arguments.app>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="call">
		<cfargument name="env" type="struct" required="true">
		<cfset var loc = {}>
	
		<cfset loc.ret = variables.app.call(arguments.env)>
		
		<cfset ArrayAppend(loc.ret[3], "<p>Appending content to the body of the calling page</p>")>

		<cfreturn loc.ret>
	</cffunction>

</cfcomponent>