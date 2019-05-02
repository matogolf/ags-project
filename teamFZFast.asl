{ include("astar.asl") }  
{ include("travelling.asl") }  


get_fast_name(aFast) :- friend(aFast).
get_fast_name(bFast) :- friend(bFast). 
get_middle_name(aMiddle) :- friend(aMiddle).
get_middle_name(bMiddle) :- friend(bMiddle).
get_slow_name(aSlow) :- friend(aSlow).
get_slow_name(bSlow) :- friend(bSlow). 



// get_first_position(X,Y) :- goto_plan([H|T]) & first(H, X) & second(H, Y).
get_XY(G,X,Y) :-  first(G, X) & second(G, Y).
// get_first_position(X,Y) :- ?goto_plan(G) & [] & .print(H) & .print(M) & .print(T).



// +step(Debug) <- do(skip); do(skip); do(skip). // shut down fast for debugging

+step(0)
<-  
	+empty; 
	?pos(X,Y);
	.print(X,",",Y);
    !map_undiscovered;
	// +reach_depot;
	// ?depot(DepotX,DepotY);
	// !define_goal(DepotX,DepotY);
	+scout_map_mode;
	// !define_goal(X,Y);
	!add_position_goal(X,Y);
	+go_there(X,Y);
    !do_step;
    !do_step;
	!do_step.

+step(I)
<- 
	if (have_shoes) {
		!do_step;
		!do_step;
		!do_step;
	}
 	!do_step;
    !do_step;
	!do_step;
.


/////////////////// KED SOM NA SHOES TILE TAK ICH VEZMEM DAVA BUGY NECHAPEM WWWWTFFF
// +!do_step : not(have_shoes) & pos(MyX,MyY) & shoes(MyX,MyY)
// <-

// 		.print("TU SU SHOES, BERIEM ICH ",MyX,",",MyY);
// 		?moves_left(MovesLeft);
// 		.print(MovesLeft);
// 		do(pick);

// 		-shoes_tile(MyX,MyY);
// 		+have_shoes;

// .

+!do_step : scout_map_mode
<-

	!search_for_gold;
	!search_for_wood;
	!search_for_stone;
	!search_for_water;
	!search_for_gloves;
	!search_for_shoes;
	!search_for_spectacles;
	!search_for_pergamen;

	!discover(1);
	?pos(MyX,MyY);
	+visited(MyX,MyY);


		.print("SCOUTING");
		?go_there(GX,GY);
		if (MyX==GX & MyY==GY) {
			-astar_active;
			// .print("Reached");

			if (not(blocked(MyX-1,MyY)) & not(visited(MyX-1,MyY)) & MyX-1 >= 0) {
				// .print("LEFT");
				!add_position_goal(MyX-1,MyY);
				-go_there(_,_);
				+go_there(MyX-1,MyY);
				!move;
			}
			elif (not(blocked(MyX,MyY-1)) & not(visited(MyX,MyY-1)) & MyY-1 >= 0) {
				// .print("UP");
				!add_position_goal(MyX,MyY-1);
				-go_there(_,_);
				+go_there(MyX,MyY-1);
				!move;
			}
			elif (not(blocked(MyX,MyY+1)) & not(visited(MyX,MyY+1)) & MyY+1 <= 54) {
				// .print("DOWN");
				!add_position_goal(MyX,MyY+1);
				-go_there(_,_);
				+go_there(MyX,MyY+1);
				!move;
			}
			elif (not(blocked(MyX+1,MyY)) & not(visited(MyX+1,MyY)) & MyX+1 <= 54) {
				// .print("RIGHT");
				!add_position_goal(MyX+1,MyY);
				-go_there(_,_);
				+go_there(MyX+1,MyY);
				!move;
			}
			else {
				.print("SOM SA ZASEKOL HLADAM SUSEDA POSLEDNEHO VHODNEHO");
				!find_last_neighbour;
			}
		} else {
			if (astar_active){
				!move_astar;
			}
			else {
				!move;
			}
		}
	// }
.



+!find_last_neighbour
<-
	?get_first_position(X,Y);
	// .print("SUSED JE OK? ",X,",",Y);
	if (not(blocked(X,Y)) & not(visited(X,Y))) {
		!empty_astar;
		.print("DOBRY SUSED - ",X,",",Y);
		!discover(1);
		!define_goal(X,Y);
		-go_there(_,_);
		+go_there(X,Y);
		+astar_active;
		!move_astar;
	}
	else {
		// .print("NAAH WRONG NEIGHBOUR");
		!pop_first_position;
		?goto_plan(E);
		if (.empty(E)) {
			.print("EEEEEEMPTYYYYYY");
			-go_there(_,_);
			-scout_map_mode;
			+harvest_mode;
			do(skip);
		} else {
			!find_last_neighbour;
		}
	}
.




// odstrani prvni prvek zo seznamu
+!pop_first_position
    <- ?goto_plan([H|T]);
	   -goto_plan(_);
	   +goto_plan(T).

+!search_for_gold
<- 
	.findall([X,Y], gold(X,Y), GoldHere);
		for ( .member(H,GoldHere) ) {
			?first(H,X); ?second(H,Y);
			if (not gold_tile(X,Y)) {
				.print(pos(X,Y)," - GOLD++");
				+gold_tile(X,Y);
				?get_slow_name(SlowName);
				?get_middle_name(MiddleName);
				// .send(SlowName, tell, gold_tile(X, Y));
				// .send(MiddleName, tell, gold_tile(X, Y));
			}
		}
.
+!search_for_wood
<- 
	.findall([X,Y], wood(X,Y), WoodHere);
		for ( .member(H,WoodHere) ) {
			?first(H,X); ?second(H,Y);
			if (not wood_tile(X,Y)) {
				.print(pos(X,Y)," - WOOD++");
				+wood_tile(X,Y);
				?get_slow_name(SlowName);
	   			?get_middle_name(MiddleName);
				// .send(SlowName, tell, wood_tile(X, Y));
				// .send(MiddleName, tell, wood_tile(X, Y));
			}
		}
.
+!search_for_stone
<- 
	.findall([X,Y], stone(X,Y), StoneHere);
		for ( .member(H,StoneHere) ) {
			?first(H,X); ?second(H,Y);
			if (not stone_tile(X,Y)) {
				.print(pos(X,Y)," - STONE++");
				+stone_tile(X,Y);
				?get_slow_name(SlowName);
	   			?get_middle_name(MiddleName);
				// .send(SlowName, tell, stone_tile(X, Y));
				// .send(MiddleName, tell, stone_tile(X, Y));
			}
		}
.
+!search_for_water
<- 
	.findall([X,Y], water(X,Y), WaterHere);
		for ( .member(H,WaterHere) ) {
			?first(H,X); ?second(H,Y);
			if (not water_tile(X,Y)) {
				.print(pos(X,Y)," - WATER++");
				+water_tile(X,Y);
				?get_slow_name(SlowName);
	   			?get_middle_name(MiddleName);
				// .send(SlowName, tell, water_tile(X, Y));
				// .send(MiddleName, tell, water_tile(X, Y));
			}
		}
.
+!search_for_gloves
<- 
	.findall([X,Y], gloves(X,Y), GlovesHere);
		for ( .member(H,GlovesHere) ) {
			?first(H,X); ?second(H,Y);
			if (not gloves_tile(X,Y)) {
				.print(pos(X,Y)," - GLOVES++");
				+gloves_tile(X,Y);
				?get_slow_name(SlowName);
	   			?get_middle_name(MiddleName);
				// .send(SlowName, tell, gloves_tile(X, Y));
				// .send(MiddleName, tell, gloves_tile(X, Y));
			}
		}
.
+!search_for_shoes
<- 
	.findall([X,Y], shoes(X,Y), ShoesHere);
		for ( .member(H,ShoesHere) ) {
			?first(H,X); ?second(H,Y);
			if (not shoes_tile(X,Y)) {
				.print(pos(X,Y)," - SHOES++");
				+shoes_tile(X,Y);
				?get_slow_name(SlowName);
	   			?get_middle_name(MiddleName);
				// .send(SlowName, tell, shoes_tile(X, Y));
				// .send(MiddleName, tell, shoes_tile(X, Y));
			}
		}
.
+!search_for_spectacles
<- 
	.findall([X,Y], spectacles(X,Y), SpectaclesHere);
		for ( .member(H,SpectaclesHere) ) {
			?first(H,X); ?second(H,Y);
			if (not spectacles_tile(X,Y)) {
				.print(pos(X,Y)," - SPECTACLES++");
				+spectacles_tile(X,Y);
				?get_slow_name(SlowName);
	   			?get_middle_name(MiddleName);
				// .send(SlowName, tell, spectacles_tile(X, Y));
				// .send(MiddleName, tell, spectacles_tile(X, Y));
			}
		}
.
+!search_for_pergamen
<- 
	.findall([X,Y], pergamen(X,Y), PergamenHere);
		for ( .member(H,PergamenHere) ) {
			?first(H,X); ?second(H,Y);
			if (not pergamen_tile(X,Y)) {
				.print(pos(X,Y)," - PERGAMEN++");
				+pergamen_tile(X,Y);
				?get_slow_name(SlowName);
	   			?get_middle_name(MiddleName);
				// .send(SlowName, tell, pergamen_tile(X, Y));
				// .send(MiddleName, tell, pergamen_tile(X, Y));
			}
		}
.


+!rm_resource_msg(R,MyX,MyY)
<-
	?get_slow_name(SlowName);
	?get_middle_name(MiddleName);
	.send(SlowName, achieve,remove_resource(R,MyX,MyY));
	.send(MiddleName, achieve,remove_resource(R,MyX,MyY));
	!remove_resource(R,MyX,MyY);
.

+!remove_resource(R,X,Y)
<-
	if (R == wood) {
		-wood_tile(X,Y)[source(_)];
	}
	elif (R == gold) {
		-gold_tile(X,Y)[source(_)];
	}
	elif (R == stone) {
		-stone_tile(X,Y)[source(_)];
	}
	elif (R == water) {
		-water_tile(X,Y)[source(_)];
	}
	elif (R == pergamen) {
		-pergamen_tile(X,Y)[source(_)];
	}
	elif (R == gloves) {
		-gloves_tile(X,Y)[source(_)];
	}
	elif (R == shoes) {
		-shoes_tile(X,Y)[source(_)];
	}
	elif (R == spectacles) {
		-spectacles_tile(X,Y)[source(_)];
	}
.




+!do_step : drop_bag
<-
	?bag(MYBAG);
	.nth(0,MYBAG,R0);
	.nth(1,MYBAG,R1);
	if   (R0 \== null) { drop(R0); }
	elif (R1 \== null) { drop(R1); }
	// else { .print("DROPPED EVERYTHING - BAG EMPTY"); -drop_bag; !do_skip_move; }
	else { .print("DROPPED EVERYTHING - BAG EMPTY"); -drop_bag; -bag_full; !check_if_available_resources; !do_skip_move; }

.

+!do_step : bag_full
<-
		!discover(1);
		?pos(MyX,MyY);
		?depot(DepotX,DepotY);
		!define_goal(DepotX,DepotY);
		if (MyX==DepotX & MyY==DepotY) {
			.print("DEPOT REACHED");
			+drop_bag;
			!do_skip_move;
		} else {
			!move_astar;
		}
.

+!do_step : harvest_mode
<-
	.print("HARVESTING");
	!discover(1);
	if (empty) {
		!check_if_available_resources;
		!do_skip_move;
	} else {
		if (no_goal) {
			!get_next_resource_to_collect;
			!do_skip_move;
		} 
		else {
			?pos(MyX,MyY);
			if (go_there(GX,GY)) {
				?go_there(GX,GY);
				if (MyX==GX & MyY==GY) {
					.print("MIDDLE REACHED DESTIANTION");
					!try_to_pick(MyX,MyY);
				}
				else {
					!move_astar;
				}
			}
		}
	}
.


+!try_to_pick(MyX,MyY)
<-
	?resource_to_pick(R);
	if (R == wood) {
		.print("WOOOOOOD");
		if (wood(MyX,MyY)) {
			.print("STILL TEHRE, PICKING UP");
			-go_there(MyX,MyY); 

			!rm_resource_msg(R,MyX,MyY);

			-resource_to_pick(_);
			do(pick);
			!check_if_available_resources;
		} else {
			.print("NOT THERE ANYMORE");
			!rm_resource_msg(R,MyX,MyY);
			-go_there(GX,GY);
			!do_skip_move; // TODO este ked nenajde na policku uz dany resource tak vymaz ho zo zoznamu dosupnych
			!check_if_available_resources
		}
	}
	elif(R == gold) {
		.print("GOOOOOOLD");
		if (gold(MyX,MyY)) {
			.print("STILL TEHRE, PICKING UP");
			-go_there(MyX,MyY); 

			!rm_resource_msg(R,MyX,MyY);

			-resource_to_pick(_);
			do(pick);
			!check_if_available_resources;
		} else {
			.print("NOT THERE ANYMORE");
			!rm_resource_msg(R,MyX,MyY);
			-go_there(GX,GY);
			!do_skip_move; // TODO este ked nenajde na policku uz dany resource tak vymaz ho zo zoznamu dosupnych
			!check_if_available_resources
		}
	}
	elif (R == shoes) {
		.print("SHOES");
		if (shoes(MyX,MyY)) {
			.print("STILL TEHRE, PICKING UP");
			-go_there(MyX,MyY); 
			
			!rm_resource_msg(R,MyX,MyY);

			-resource_to_pick(_);
			+have_shoes;
			do(pick);
			!check_if_available_resources;
		} else {
			.print("NOT THERE ANYMORE");
			!rm_resource_msg(R,MyX,MyY);
			-go_there(GX,GY);
			!do_skip_move; // TODO este ked nenajde na policku uz dany resource tak vymaz ho zo zoznamu dosupnych
			!check_if_available_resources
		}
	}
.


+!check_if_available_resources
<-	
	+empty; 
	if(gold_tile(X,Y) | wood_tile(X,Y)) {
		.print("I HAVE SOMETHING TO DO");
		-empty; +no_goal;
	}
	?bag(MYBAG);
	.print(MYBAG);
	// if (bag_full) {
	// 	.print("--**--**--**--**--**--**--**--**--");
	// 	// !empty_astar;
	// 	!do_skip_move;
	// 	?depot(DepotX,DepotY);
	// 	!define_goal(DepotX,DepotY);

	// }
.

+!get_next_resource_to_collect	// TODO lepsi vyber ktory resource zobrat lebo teraz len tak ktore je prve v zozname berie
<-
	-no_goal;

	if(not(have_shoes) & shoes_tile(Xdaco,Ydaco)) {
		.print("NEMAM SHOES IDEM PO NICH - ",Xdaco,",",Ydaco);
		?shoes_tile(X,Y);
		+resource_to_pick(shoes);
		+go_there(X,Y);
		!define_goal(X,Y);
	}

	if(gold_tile(Xdaco,Ydaco)) {
		.print("GO PICK AT - ",Xdaco,",",Ydaco," -","gold");
		?gold_tile(X,Y);
		+resource_to_pick(gold);
		+go_there(X,Y);
		!define_goal(X,Y);
	}
	elif (wood_tile(Xdaco,Ydaco)) {
		.print("GO PICK AT - ",Xdaco,",",Ydaco," -","wood");
		?wood_tile(X,Y);
		+resource_to_pick(wood);
		+go_there(X,Y);
		!define_goal(X,Y);
	}
	!empty_astar;
	!discover(1);

	// aby vymazal ze tam je ten resource aby ostatni agenti uz ho nebrali do uvahy
	if (resource_to_pick(R) & go_there(Xthere,Ythere)) {
		// ?resource_to_pick(R);
		// ?go_there(Xthere,Ythere);
		!rm_resource_msg(R,Xthere,Ythere);
	}
.

+!do_skip_move
<- 
	?moves_left(MovesLeft);
	.print(MovesLeft);
	if (MovesLeft > 0) {
		do(skip);
	}
.


+!do_step
<- 
	!do_skip_move;
	!do_skip_move;
	!do_skip_move;
.