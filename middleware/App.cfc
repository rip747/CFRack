<cfcomponent output="false">

	<cffunction name="init">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="call">
		<cfargument name="env" type="struct" required="true">
		<cfset var loc = {}>
		
		<cfset loc.statusCode = 200>
		<cfset loc.headers["Content-Type"] = "text/html">
		<cfset loc.content = ["<p>Prepending content to the calling page</p>"]>

		<cfsavecontent variable="loc.body"><cfinclude template="#arguments.env.script_name#"></cfsavecontent>

		<cfset arrayAppend(loc.content, loc.body)>
		
		<cfset loc.ret = [loc.statusCode, loc.headers, loc.content]>
		<cfreturn loc.ret>
	</cffunction>

</cfcomponent>