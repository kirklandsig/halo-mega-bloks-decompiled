class GripBTScriptNodeCache extends Object
	native;

var array<GripBTScriptNode> ScriptNodes;

event InitializeAllNodes()
{
	local GripBTScriptNode Node;

	// End:0x37
	foreach ScriptNodes(Node)
	{
		Node.Initialize();		
	}	
	//return;	
}

event SurveyUsedBBMembers(GripBlackboard Blackboard)
{
	local GripBTScriptNode Node;

	// End:0x40
	foreach ScriptNodes(Node)
	{
		Node.FlagUsedBBMembers(Blackboard);		
	}	
	//return;	
}

event CacheAllConditions(GripBTInterface BTInterface)
{
	local GripBTScriptNode Node;

	// End:0x60
	foreach ScriptNodes(Node)
	{
		Node.ConditionCache = Node.ComputeCondition(BTInterface);		
	}	
	//return;	
}
