<cfcomponent output="false">

	<cffunction name="init">
		<cfargument name="app" type="any" required="true">
		<cfset variables.app = arguments.app>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="call">
		<cfargument name="env" type="struct" required="true">
		<cfset var loc = {}>
		
		<cfset loc.start = GetTickCount()>

		<cfset loc.ret = variables.app.call(arguments.env)>
		
		<cfset loc.stop = GetTickCount() - loc.start>
		<cfset arrayAppend(loc.ret[3], "<!-- Total request time: #loc.stop#ms -->")>
		
		<cfreturn loc.ret>
	</cffunction>

</cfcomponent>