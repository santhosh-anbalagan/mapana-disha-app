#import <Foundation/Foundation.h>

/**
 Posted when `NBRouteController` receives a user location update representing movement along the expected route.
 
 The user info dictionary contains the keys `NBRouteControllerRouteProgressKey` and `NBRouteControllerLocationKey`.
 
 :nodoc:
 */
extern const NSNotificationName NBRouteControllerProgressDidChangeNotification;

/**
 Posted after the user diverges from the expected route, just before `NBRouteController` attempts to calculate a new route.
 
 The user info dictionary contains the key `NBRouteControllerLocationKey`.
 
 :nodoc:
 */
extern const NSNotificationName NBRouteControllerWillRerouteNotification;

/**
 Posted when `NBRouteController` obtains a new route in response to the user diverging from a previous route.
 
 The user info dictionary contains the keys `NBRouteControllerLocationKey` and `NBRouteControllerIsProactiveKey`.
 
 :nodoc:
 */
extern const NSNotificationName NBRouteControllerDidRerouteNotification;

/**
 Posted when `NBRouteController` fails to reroute the user after the user diverges from the expected route.
 
 The user info dictionary contains the key `NBRouteControllerRoutingErrorKey`.
 
 :nodoc:
 */
extern const NSNotificationName NBRouteControllerDidFailToRerouteNotification;

/**
 Posted when `NBRouteController` detects that the user has passed an ideal point for saying an instruction aloud.
 
 The user info dictionary contains the key `NBRouteControllerRouteProgressKey`.
 
 :nodoc:
 */
extern const NSNotificationName NBRouteControllerDidPassSpokenInstructionPointNotification;

extern const NSNotificationName NBRouteControllerDidPassVisualInstructionPointNotification;

/**
 Keys in the user info dictionaries of various notifications posted by instances of `NBRouteController`.
 
 :nodoc:
 */
typedef NSString *NBRouteControllerNotificationUserInfoKey NS_EXTENSIBLE_STRING_ENUM;

/**
 A key in the user info dictionary of a `Notification.Name.NBRouteControllerProgressDidChange` or `Notification.Name.RouteControllerDidPassSpokenInstructionPoint` notification. The corresponding value is a `RouteProgress` object representing the current route progress.
 */
extern const NBRouteControllerNotificationUserInfoKey NBRouteControllerRouteProgressKey;

/**
 A key in the user info dictionary of a `Notification.Name.NBRouteControllerProgressDidChange` or `Notification.Name.RouteControllerWillReroute` notification. The corresponding value is a `CLLocation` object representing the current idealized user location.
 */
extern const NBRouteControllerNotificationUserInfoKey NBRouteControllerLocationKey;

/**
 A key in the user info dictionary of a `Notification.Name.NBRouteControllerProgressDidChange` or `Notification.Name.RouteControllerWillReroute` notification. The corresponding value is a `CLLocation` object representing the current raw user location.
 */
extern const NBRouteControllerNotificationUserInfoKey NBRouteControllerRawLocationKey;

/**
 A key in the user info dictionary of a `Notification.Name.RouteControllerDidFailToReroute` notification. The corresponding value is an `NSError` object indicating why `RouteController` was unable to calculate a new route.
 */
extern const NBRouteControllerNotificationUserInfoKey NBRouteControllerRoutingErrorKey;

/**
 A key in the user info dictionary of a `Notification.Name.RouteControllerDidReroute` notification. The corresponding value is an `NSNumber` instance containing a Boolean value indicating whether `RouteController` proactively rerouted the user onto a faster route.
 */
extern const NBRouteControllerNotificationUserInfoKey NBRouteControllerIsProactiveKey;

/**
 A key in the user info dictionary of a `Notification.Name.routeControllerProgressDidChange` notification. The corresponding value is a `CLHeading` object representing the current user heading.
 */
extern const NBRouteControllerNotificationUserInfoKey NBRouteControllerHeadingKey;


@interface NSString (MD5)
- (NSString * _Nonnull)md5;
@end
