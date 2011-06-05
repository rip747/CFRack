<cfcomponent output="false">

	<cffunction name="init">
		<cfargument name="app" type="any" required="true">
		<cfargument name="author" type="string" required="true">
		<cfargument name="poweredby" type="string" required="true">
		<cfset variables.app = arguments.app>
		<cfset variables.author = arguments.author>
		<cfset variables.poweredby = arguments.poweredby>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="call">
		<cfargument name="env" type="struct" required="true">
		<cfset var loc = {}>
		
		<cfset loc.start = GetTickCount()>

		<cfset loc.ret = variables.app.call(arguments.env)>
		
		<cfset loc.stop = GetTickCount() - loc.start>
		
		<cfset loc.ret[2]["Author"] = variables.author>
		<cfset loc.ret[2]["X-Powered-By"] = variables.poweredby>
		<cfset arrayAppend(loc.ret[3], "Time Stamp: #GetTickCount()#")>
		<cfset arrayAppend(loc.ret[3], "<p>Total request time: #loc.stop#</p>")>
		
		<cfreturn loc.ret>
	</cffunction>

</cfcomponent>