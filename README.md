**As of the 08/07/2022 TF2 update, this repository has been archived. The fixes were properly implemented into the game at my request.**

# [TF2] Arena Late Spawn Fix

This plugin fixes an ancient bug that allows players to spawn during a running round in arena mode. It also prevents players from joining a class before joining a team first.

Unlike the [Anti-Arena Latespawn plugin by Batfoxkid](https://forums.alliedmods.net/showthread.php?t=316597), this one fixes the bug properly instead of simply slaying the player if they respawn mid-round.

See below for an in-depth explanation of the bug.

## Explanation

The game allows players without a class to instantly respawn after joining one. That functionality has not been disabled in arena mode.

The instant respawn can be triggered by joining a team during pre-round without joining a class, then joining the same class twice after the round has started and the minimum respawn time has passed. This will instantly respawn the player.

This could be fixed in game code by Valve adding a check for arena mode in `CTFPlayer::ShouldGainInstantSpawn`.
