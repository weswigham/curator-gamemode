RoundTimer = {}
RoundTimer.RoundTime = 600
RoundTimer.GraceTime = 30
RoundTimer.CurrentTime = 0
RoundTimer.RoundInProgress = false

function RoundTimer.Setup()
	RoundTimer.CurrentTime = RoundTimer.RoundTime
	RoundTimer.RoundInProgress = true
	timer.Create("RoundTimer", 1, 0, RoundTimer.SlowThink)
end
hook.Add("Initialize", "TimerSetup", RoundTimer.Setup)

function RoundTimer.StartRound()
	RoundTimer.CurrentTime = RoundTimer.RoundTime
	RoundTimer.RoundInProgress = true
	hook.Call("RoundStarted")
end

function RoundTimer.EndRound()
	RoundTimer.CurrentTime = RoundTimer.GraceTime
	RoundTimer.RoundInProgress = false
	hook.Call("GraceTime")
end

function RoundTimer.SlowThink()
	if RoundTimer.CurrentTime > 0 then
		RoundTimer.CurrentTime = CurrentTime - 1
		RoundTimer.InformClient()
	else
		if RoundTimer.RoundInProgress then
			RoundTimer.EndRound()
		else
			RoundTimer.StartRound()
		end
	end
end

function RoundTimer.InformClient() --This is better than just using a global variable which is just a wrapper for this and bugs out sometimes.
	umsg.Start("TimerUpdate", player.GetAll())
		umsg.Long(RoundTimer.CurrentTime)
	umsg.End()
end 