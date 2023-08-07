#import <Foundation/Foundation.h>

/**
 Each of these options specifies a maneuver direction for which a given lane can
 be used.
 
 A Lane object has zero or more indications that usually correspond to arrows on
 signs or pavement markings. If no options are specified, it may be the case
 that no maneuvers are indicated on signage or pavement markings for the lane.
 */
typedef NS_OPTIONS(NSUInteger, NBLaneIndication) {
    /// Indicates a sharp turn to the right.
    NBLaneIndicationSharpRight = (1 << 1),
    
    /// Indicates a turn to the right.
    NBLaneIndicationRight = (1 << 2),
    
    /// Indicates a turn to the right.
    NBLaneIndicationSlightRight = (1 << 3),
    
    /// Indicates no turn.
    NBLaneIndicationStraightAhead = (1 << 4),
    
    /// Indicates a slight turn to the left.
    NBLaneIndicationSlightLeft = (1 << 5),
    
    /// Indicates a turn to the left.
    NBLaneIndicationLeft = (1 << 6),
    
    /// Indicates a sharp turn to the left.
    NBLaneIndicationSharpLeft = (1 << 7),
    
    /// Indicates a U-turn.
    NBLaneIndicationUTurn = (1 << 8),
};
