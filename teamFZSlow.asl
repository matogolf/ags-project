{ include("travelling.asl") }   

// +step(0) <- !add_position_goal(49,49);
// 			!move.
// +step(X) <- !move.

+step(X) <- do(skip).
