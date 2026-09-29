version "5.0.3"

//$Category Monsters
class PelonMonster : Actor
{
	Default
	{
		Health 100;
		Speed 8;
		Radius 20;
		Height 56;
        Mass 50;
        PainChance 150;

        AttackSound "pelon/attack";
        PainSound "pelon/pain";
        SeeSound "pelon/see";
        DeathSound "pelon/death";

    
        Monster; 

	}

	States
	{
	Spawn:
		PELO A 10 A_Look;
		Loop;

	See:

		PELO AABB 4 A_Chase;
        
		Loop;

	Melee:
		PELO B 8 A_PlaySound("pelon/attack");
		PELO C 8 A_CustomMeleeAttack(5);
		Goto See;

	Pain:
		PELO D 10 A_Pain;
		Goto See;

	Death:
		PELO B 5;
		PELO A 5;
		PELO B 5 A_Scream;
        PELO C 5 A_NoBlocking;
        PELO D -1;
		Stop;
    }
}

class MarcoHUD : BaseStatusBar
{

    HUDFont myfont;
    HUDFont mybigfont;

    MarcoHandler handler;

    int kills;
    float timer;
    String killstext;
    String timertext;
    
    override void Init()
    {
        Super.Init();
        myfont = HUDFont.Create(smallfont);
        mybigfont = HUDFont.Create(bigfont);
        handler = MarcoHandler(EventHandler.Find("MarcoHandler"));

    }



	override void Draw(int state, double TicFrac)
	{
        
        
		Super.Draw(state, TicFrac);

		BeginHud();
        handler = MarcoHandler(EventHandler.Find("MarcoHandler"));
        PlayerPawn player = players[ConsolePlayer].mo;
        
        killstext = String.Format("\cgKills: \c- \cd %d\c-", handler.TotalKills);
        timertext = String.Format("\cgTime Spent Killing things: %.2f",handler.Timer);

		DrawString(myfont,"\cgTesting \c- \cdHUD \c-",(50, 50));
        DrawString(myfont,killstext,(50,60));
        DrawString(myfont,timertext,(50,70));
        DrawString(mybigfont,String.Format("Health: %d/\cC%d ",player.health,player.GetMaxHealth()),(50,80));
        
	}
}


class MarcoHandler : EventHandler 
{
    int TotalKills;
    float Timer;

    override void WorldThingDied(WorldEvent e)
    {
        if (e.thing.GetClass() != 'DoomPlayer')
        {
            TotalKills++;
        }
    }

    override void WorldTick()
    {
        Timer += 0.028;
        
    }

}