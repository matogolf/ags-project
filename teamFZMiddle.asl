{ include("astar.asl") }   

get_fast_name(aFast) :- friend(aFast).
get_fast_name(bFast) :- friend(bFast). 
get_middle_name(aMiddle) :- friend(aMiddle).
get_middle_name(bMiddle) :- friend(bMiddle).
get_slow_name(aSlow) :- friend(aSlow).
get_slow_name(bSlow) :- friend(bSlow). 


// +step(Debug) <- do(skip); do(skip). // shut down middle for debugging

+step(0) <- +empty; +no_goal; !do_step; !do_step.

+step(I) <-	!do_step; !do_step.

+!do_step : drop_bag
<-
	?bag(MYBAG);
	.nth(0,MYBAG,R0);
	.nth(1,MYBAG,R1);
	.nth(2,MYBAG,R2);
	.nth(3,MYBAG,R3);
	if   (R0 \== null) { drop(R0); }
	elif (R1 \== null) { drop(R1); }
	elif (R2 \== null) { drop(R2); }
	elif (R3 \== null) { drop(R3); }
	elif (have_gloves) {
		.nth(4,MYBAG,R4);
		.nth(5,MYBAG,R5);
		.nth(6,MYBAG,R6);
		.nth(7,MYBAG,R7);
		if   (R4 \== null) { drop(R4); }
		elif (R5 \== null) { drop(R5); }
		elif (R6 \== null) { drop(R6); }
		elif (R7 \== null) { drop(R7); }
			
		else { .print("DROPPED EVERYTHING - BAG EMPTY"); -drop_bag; !do_skip_move; }
	}
	else { .print("DROPPED EVERYTHING - BAG EMPTY"); -drop_bag; !do_skip_move; }
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



+!do_step
<-
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
					.print("888888888888888888");
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
	elif (R == gloves) {
		.print("GLOOOVES");
		if (gloves(MyX,MyY)) {
			.print("STILL TEHRE, PICKING UP");
			-go_there(MyX,MyY); 
			
			!rm_resource_msg(R,MyX,MyY);

			-resource_to_pick(_);
			+have_gloves;
			do(pick);
			!check_if_available_resources;
		} else {
			.print("NOT THERE ANYMORE");
			!rm_resource_msg(R,MyX,MyY);
			-go_there(GX,GY);
			!do_skip_move; // TODO este ked nenajde na policku uz dany resource tak vymaz ho zo zoznamu dosupnych
			!check_if_available_resources;
		}
	}
.

// dorobit aj pre stone water pergamen...
+!check_if_available_resources
<-	
	+empty; 

	?get_fast_name(FastName);
	.send(FastName, askOne, gloves_tile(X,Y));
	.send(FastName, askOne, wood_tile(X,Y));
	.send(FastName, askOne, gold_tile(X,Y));

	if(gold_tile(X,Y) | wood_tile(X,Y)) {
		.print("I HAVE SOMETHING TO DO");
		-empty; +no_goal;
		// !empty_astar;
		// !discover(1);
	}
	?bag(MYBAG);
	.print(MYBAG);
	// if (bag_full) {
	// 	.print("--**--**--**--**--**--**--**--**--");
	// 	// !empty_astar;
	// 	!do_skip_move;
	// 	?depot(DepotX,DepotY);
	// 	!define_goal(DepotX,DepotY);
	// 	.print("-*******-///////////////////////////******--");

	// }
.

+!get_next_resource_to_collect	// TODO lepsi vyber ktory resource zobrat lebo teraz len tak ktore je prve v zozname berie
<-
	if(not(have_gloves) & gloves_tile(Xdaco,Ydaco)) {
		.print("NEMAM RUKAVICE IDEM PO NICH - ",Xdaco,",",Ydaco);
		?gloves_tile(X,Y);
		+resource_to_pick(gloves);
		+go_there(X,Y);
		!define_goal(X,Y);
		-no_goal;
	}

	elif (wood_tile(Xdaco,Ydaco)) {
		.print("GO PICK AT - ",Xdaco,",",Ydaco," -","wood");
		?wood_tile(X,Y);
		+resource_to_pick(wood);
		+go_there(X,Y);
		!define_goal(X,Y);
		-no_goal;

	}
	elif(gold_tile(Xdaco,Ydaco)) {
		.print("GO PICK AT - ",Xdaco,",",Ydaco," -","gold");
		?gold_tile(X,Y);
		+resource_to_pick(gold);
		+go_there(X,Y);
		!define_goal(X,Y);
		-no_goal;


	} else {
		+empty;
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
	// .print(MovesLeft);
	if (MovesLeft > 0) {
		do(skip);
	}
.


+!rm_resource_msg(R,MyX,MyY)
<-
	?get_fast_name(FastName);
	?get_slow_name(SlowName);
	.send(SlowName, achieve,remove_resource(R,MyX,MyY));
	.send(FastName, achieve,remove_resource(R,MyX,MyY));
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