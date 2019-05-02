// Agent aDruid in project jasonTeam.mas2j



/* Initial beliefs and rules */



/* Initial goals */

// STONE, WATER, WOOD, GOLD
// ST 	, WT   , WD  , GD
 
+step(0) <- !check_if_res_needed; !do_step.

+step(I) <- !do_step.

+!do_step : depot(stone,STONE) & depot(water,WATER) & depot(wood,WOOD) & depot(gold,GOLD) & depot(pergamen,PE)
<-
	+skip;
	.count(spell(_,_,_,_),SpelNum)
	.print("SPEL NUM - ",SpelNum);
	if (PE >= 3) {
		.print("MAME PERGAMNY");
		-skip;
		do(read,3);
		!check_if_res_needed;
	}
	else {

		// .print("STONE - ",ST,", WATER - ",WT,", WOOD - ",WD," GOLD - ",GD);
		for (spell(ST,WT,WD,GD)) {
			.print(ST,WT,WD,GD);
			if (STONE >= ST & WATER >= WT & WOOD >= WD & GOLD >= GD & skip) {
				.print("SPELL POSSIBLE - ",ST,WT,WD,GD);
				do(create,ST,WT,WD,GD);
				-skip;
			}
		}
	}		
	if (skip) {
		do(skip);
	}
.


+!do_step
<-
	do(skip);
.


+!check_if_res_needed
<-
	+stone_needed;
	+water_needed;
	for (spell(ST,WT,WD,GD)) {
		if (ST = 0 & WT = 0) {
			.print("WE JUST NEED GOLD OR WOOD");
			if (stone_needed) {
				-stone_needed;
			}
			if (water_needed) {
				-water_needed;
			}
		}
	}
	if (stone_needed) {
		.print("WELL WE NEED STONE");

	}
.
