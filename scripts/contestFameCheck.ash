script "ContestfameCheck.ash"

/*******************************************************
*	ContestFameCheck
*
*	Checks the fame or fame taken of each team and adds
*	it up. Sorts output by the highest scoring teams.
*
*	Enter teams in "names" in the order:
*	member1, member2, member3, manager
*
*	Enter managers in "managers" in any order.
/*******************************************************/

int [string] data;	// Map for ids to be stored in
int id;				// Temporary placeholder
boolean[string] names = $strings[Margaret Houlihan, Nik, Marge, Honus Carbuncle, CherryJ, Phantax, GinoXYZ, Xairon, Mister Mickey, efot, Spice Trader, Nickles, Krymzin, ElectricBolter, skimoo, Loathmast, LadyJ, Julitewn, Txranger, Rabbit House, asmithsgirl, Miguelius, Mr McGibblets, jon diaz, Boesbert, Albert, laidak, Hugbert, tomkitty, Jizmak The Destroyer, scullyangel, eusst, Mystik Spiral, ChesterArthurXXI, CaptainUrsus, Shelldor, Gmorg, PandaPants, Sassy Staci, Dryhad, greycat, Aubra, BC_Goldman, PsyMar, Nienor, cowmanbob, Mana Yachanichu, Anchon, Somersaulter, Grushvak, Auriron, Chink];
boolean[string] managers = $strings[Honus Carbuncle, Xairon, Nickles, Loathmast, Rabbit House, jon diaz, Hugbert, eusst, Shelldor, Dryhad, PsyMar, Anchon, Chink];
string[string] output;

/*******************************************************
*					int fameTaken(string player)
*	Calculates the amount of fame taken by the target
*	player. Returns the highest value of HC or Normal.
/*******************************************************/
int fameTaken(string player)
{
	int largest;
	
	string page = visit_url("showplayer.php?who=" + data[player]);
	matcher fameTaken = create_matcher("([0-9,]+)(?= taken)",page);
	
	while (find(fameTaken))
	{
		if (largest < group(fameTaken).to_int())
			largest = group(fameTaken).to_int();
	}
	if (largest == 0)
		print(player + " has a score of 0", "red");
	return largest;
}

/*******************************************************
*					int fame(string player)
*	Calculates the amount of fame for the target
*	player. Returns the highest value of HC or Normal.
/*******************************************************/
int fame(string player)
{
	int largest;
 	
	string page = visit_url("showplayer.php?who=" + data[player]);
	// Need to split up into 2 matchers because runtime becomes too slow with optional check
	matcher fame = create_matcher("(?<=(Fame:</b></td><td>))([0-9,]+)(?!&nbsp)",page);
	matcher fameHC = create_matcher("(?<=(Fame( \\(Hardcore\\)):</b></td><td>))([0-9,]+)(?!&nbsp)",page);
	
	// Calculate which is larger, convert to int, return
	if (find(fame))
		if (group(fame).to_int() > largest)
			largest = group(fame).to_int();
	if (find(fameHC))
		if (group(fameHC).to_int() > largesT)
			largest = group(fameHC).to_int();
	if (largest == 0)
		print(player + " has a score of 0", "red");
	return largest;
}

void main()
{
	foreach name in names
	{
		id = get_player_id(name).to_int();
		data[name] = id;
	}
	data["Mystik Spiral"] = 2585449;
	int score;
	foreach name in names
	{
		if (managers contains(name))
		{
			score += fameTaken(name);
			output[name] = score;
			score = 0;
		}
		else
			score += fame(name);
	}
	print("--------------------------","green"); // Formating
	int largest; int times; string man;
	while (times < count(managers))
	{
		foreach name in managers
		{
			if (output[name].to_int() > largest)
			{
				largest = output[name].to_int();
				man = name;
			}
		}
		print("Team " + man + ": " + output[man]);
		output[man] = -1; largest = -1; times+=1;
	}
}