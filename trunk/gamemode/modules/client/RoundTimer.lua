RoundTimer = {}
RoundTimer.CurrentTime = 0

function RoundTimer.TimerUpdate(msg)
    RoundTimer.CurrentTime = msg:ReadLong()
end
usermessage.Hook("TimerUpdate", RoundTimer.TimerUpdate)

function RoundTimer.GetCurrentTime()
	return RoundTimer.CurrentTime
end 