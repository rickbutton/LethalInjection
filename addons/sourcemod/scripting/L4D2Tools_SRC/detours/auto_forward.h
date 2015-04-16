#ifndef _INCLUDE_SOURCEMOD_AUTO_FORWARD_H_
#define _INCLUDE_SOURCEMOD_AUTO_FORWARD_H_

/// Automatically release Forwards
class AutoForward
{
public:
	AutoForward(IForward *forward) : pForward(forward) { assert(forward); }

	~AutoForward() 
	{
		if(pForward != NULL)
		{
			forwards->ReleaseForward(pForward);
		}
	}

	IForward *GetForward() 
	{
		assert(pForward);
		return pForward;
	}

protected:
	IForward *pForward;

};

#endif
