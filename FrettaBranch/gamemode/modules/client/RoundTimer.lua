RoundTimer = {}
RoundTimer.RoundTime = 8*60
RoundTimer.GraceTime = 15
RoundTimer.CurrentTime = 0

function RoundTimer.TimerUpdate(msg)
    RoundTimer.CurrentTime = msg:ReadLong()
	RoundTimer.LastMessage = CurTime()
end
usermessage.Hook("TimerUpdate", RoundTimer.TimerUpdate)

function RoundTimer.GetCurrentTime()
	return RoundTimer.CurrentTime -- (RoundTimer.LastMessage-CurTime())
end 