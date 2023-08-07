#import <Foundation/Foundation.h>

#pragma mark - Specifying the Routing Profile

typedef NSString * NBNavigationMode NS_EXTENSIBLE_STRING_ENUM;

extern NBNavigationMode const NBNavigationModeCar;
extern NBNavigationMode const NBNavigationModeAuto;
extern NBNavigationMode const NBNavigationModeBike;
extern NBNavigationMode const NBNavigationModeEscooter;
extern NBNavigationMode const NBNavigationMode4W;
extern NBNavigationMode const NBNavigationMode2W;
extern NBNavigationMode const NBNavigationMode6W;


typedef NSString * NBMapOption NS_EXTENSIBLE_STRING_ENUM;

extern NBMapOption const NBMapOptionValhalla;
extern NBMapOption const NBMapOptionNone;
