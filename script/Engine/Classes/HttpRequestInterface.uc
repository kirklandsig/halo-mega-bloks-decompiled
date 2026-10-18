class HttpRequestInterface extends HttpBaseInterface
	abstract
	native;

//var delegate<OnProcessRequestComplete> __OnProcessRequestComplete__Delegate;

// Export UHttpRequestInterface::execGetVerb(FFrame&, void* const)
native function string GetVerb();

// Export UHttpRequestInterface::execSetVerb(FFrame&, void* const)
native function HttpRequestInterface SetVerb(string Verb);

// Export UHttpRequestInterface::execSetURL(FFrame&, void* const)
native function HttpRequestInterface SetURL(string URL);

// Export UHttpRequestInterface::execSetContent(FFrame&, void* const)
native function HttpRequestInterface SetContent(const out array<byte> ContentPayload);

// Export UHttpRequestInterface::execSetContentAsString(FFrame&, void* const)
native function HttpRequestInterface SetContentAsString(string ContentString);

// Export UHttpRequestInterface::execSetHeader(FFrame&, void* const)
native function HttpRequestInterface SetHeader(string HeaderName, string HeaderValue);

// Export UHttpRequestInterface::execProcessRequest(FFrame&, void* const)
native function bool ProcessRequest();

delegate OnProcessRequestComplete(HttpRequestInterface OriginalRequest, HttpResponseInterface InHttpResponse, bool bDidSucceed)
{
	//return;	
}

function HttpRequestInterface SetProcessRequestCompleteDelegate(delegate<OnProcessRequestComplete> ProcessRequestCompleteDelegate)
{
	__OnProcessRequestComplete__Delegate = ProcessRequestCompleteDelegate;
	return self;
	//return ReturnValue;	
}
