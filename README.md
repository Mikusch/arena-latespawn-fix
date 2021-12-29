# [TF2] Arena Latespawn Fix

This plugin fixes a 13-year-old bug that allows players to spawn during the round in arena mode.

Unlike [the other latespawn fix plugin](https://forums.alliedmods.net/showthread.php?t=316597), this one fixes the bug properly instead of simply slaying the player if they respawn mid-round.

See below for an in-depth explanation of the bug.

## Explanation

Team Fortress 2 allows players without a class to instantly respawn after joining one. That functionality has not been disabled in arena mode.

This bug can be triggered by joining a team during pre-round without joining a class, then joining the same class twice after the round has started and the minimum respawn time has passed. This will instantly respawn the player.

This could be fixed in game code by Valve adding a check for arena mode in `CTFPlayer::ShouldGainInstantSpawn`.