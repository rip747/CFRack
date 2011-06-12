<!--- 
Demostrates combining the form and url scopes into a single params scope.
This example was copied from CFWheels.
 --->
<cfcomponent output="false">

	<cffunction name="init">
		<cfargument name="app" type="any" required="true">
		<cfset variables.app = arguments.app>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="call">
		<cfargument name="env" type="struct" required="true">
		<cfset var loc = {}>

		<cfset arguments.env["request.params"] = paramsScope(arguments.env)>

		<cfset loc.ret = variables.app.call(arguments.env)>
		
		<cfreturn loc.ret>
	</cffunction>
	
	<cffunction name="paramsScope" access="private">
		<cfargument name="env" type="struct" required="true">
		<cfscript>
			var loc = {};
			
			loc.params = {};
			structAppend(loc.params, env["request.post"], true);
			structAppend(loc.params, env["request.get"], true);
			StructDelete(loc.params, "fieldnames", false);

			for (loc.key in loc.params)
			{
				if (Find("[", loc.key) && Right(loc.key, 1) == "]")
				{
					// object form field
					loc.name = SpanExcluding(loc.key, "[");
					
					// we split the key into an array so the developer can have unlimited levels of params passed in
					loc.nested = ListToArray(ReplaceList(loc.key, loc.name & "[,]", ""), "[", true);
					if (!StructKeyExists(loc.params, loc.name))
					{
						loc.params[loc.name] = {};
					}
					
					loc.struct = loc.params[loc.name]; // we need a reference to the struct so we can nest other structs if needed
					loc.iEnd = ArrayLen(loc.nested);
					for (loc.i = 1; loc.i lte loc.iEnd; loc.i++) // looping over the array allows for infinite nesting
					{
						loc.item = loc.nested[loc.i];
						if (!StructKeyExists(loc.struct, loc.item))
						{
							loc.struct[loc.item] = {};
						}
						if (loc.i != loc.iEnd)
						{
							loc.struct = loc.struct[loc.item]; // pass the new reference (structs pass a reference instead of a copy) to the next iteration
						}
						else
						{
							loc.struct[loc.item] = loc.params[loc.key];
						}
					}
					// delete the original key so it doesn't show up in the params
					StructDelete(loc.params, loc.key, false);
				}
			}
		</cfscript>
		<cfreturn loc.params />
	</cffunction>

</cfcomponent>