
{ include("travelling.asl") }   
// +step(0) <- !add_position_goal(50,50);
// 			.print("Going to 50,50");
// 			!move; !move; !move.
// +step(X) <- !move; !move; !move.

first([H|T], H).
second([H|T], HH) :- first(T, HH).

state(searching).

+!go_to_depot
<-
	?depot(X,Y); !add_position_goal(X,Y);
. 
// +step(0) <- !generate_unvisited; ?depot(X,Y); !add_position_goal(X,Y); !do_step; !do_step; !do_step.
+step(0) <- !generate_ottf; !go_to_depot; !do_step; !do_step; !do_step.
+step(X) <- !do_step; !do_step; !do_step.

+!generate_ottf
<-
	?depot(X,Y);
	+one(X-1,Y-1);
	+two(X+1,Y-1);
	+three(X+1,Y+1);
	+four(X-1,Y+1)
.

+!do_step : state(searching)
<-	
	!search_for_gold;
	!search_for_wood;
	!search_for_stone;
	!search_for_water;
	!search_for_gloves;
	!search_for_shoes;
	!search_for_spectacles;
	!search_for_pergamen;

	?depot(X,Y)
	if (pos(X,Y)) {
		.print("SOM V DEPOT");
	}

	!move
.

+!do_step.

// vygeneruje na zacatku vsechny nenavstivene body, ktere je nutne navstivit.
// pravdepodobne budem generovat 3x3 nebo 2x2 sit
+!generate_unvisited : grid_size(GX,GY)
    <- for ( .range(X,0,GX-1) ) {
	       if (((X mod 2) == 0) | (X == GX-1)) {
	           for ( .range(Y,0,GY-1) ) {
		           if (((Y mod 2) == 0) | (Y == GY-1)) { +unvisited(X,Y); }
		       }
		   }
       }.


+!search_for_gold
<- 
	.findall([X,Y], gold(X,Y), GoldHere);
		for ( .member(H,GoldHere) ) {
			?first(H,X); ?second(H,Y);
			if (not gold_tile(X,Y)) {
				.print(pos(X,Y)," - GOLD++");
				+gold_tile(X,Y)
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
				+wood_tile(X,Y)
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
				+stone_tile(X,Y)
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
				+water_tile(X,Y)
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
				+gloves_tile(X,Y)
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
				?shoes(XX,YY); !add_position_goal(XX,YY);
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
				+spectacles_tile(X,Y)
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
				+pergamen_tile(X,Y)
			}
		}
.
