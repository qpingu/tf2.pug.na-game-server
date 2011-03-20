#include <sourcemod>
#include <sdktools>

// Plugin Info
public Plugin:myinfo = {
  name = "tf2.pug.na - Tournament Info",
  author = "Luke Curley",
  description = "Add tournament_info command that returns various information.",
  version = SOURCEMOD_VERSION,
  url = "http://github.com/qpingu/tf2.pug.na-irc-bot"
};

// Variables
new Handle:hLive = INVALID_HANDLE;

// Code
public OnPluginStart() {
  hLive = FindConVar("soap_live");
  RegServerCmd("tournament_info", Command_TournamentInfo, "Gets the remaining time and score for the current match.");
}

public Action:Command_TournamentInfo(args) {
  if (hLive != INVALID_HANDLE && GetConVarInt(hLive) == 0) {
    PrintToServer("Tournament is not live");
    return Plugin_Handled;
  }

  new blueScore = GetTeamScore(3), redScore = GetTeamScore(2);
  new timeleft; 
  if (!GetMapTimeLeft(timeleft) || timeleft < 0) { timeleft = 0; } 
  new mins = timeleft / 60, secs = timeleft % 60;
  
  decl String:finalOutput[1024];
  finalOutput[0] = 0;
  
  FormatEx(finalOutput, sizeof(finalOutput), "Timeleft: \"%02d:%02d\", Score: \"%d:%d\"", mins, secs, blueScore, redScore);
  PrintToServer(finalOutput);
  
  return Plugin_Handled;
}
