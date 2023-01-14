//
//  Boundary.h
//  HereOk
//
//  Created by Matt Galloway on 4/14/12.
//  Copyright (c) 2012 Architactile LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#define BOUNDARY_TYPE_STATE_HOUSE @"State House District"
#define BOUNDARY_TYPE_STATE_SENATE  @"State Senate District"
#define BOUNDARY_TYPE_FEDERAL_HOUSE @"Congressional District"
#define BOUNDARY_TYPE_COOP @"Member System"


@interface Boundary : NSObject;

- (id)initWithPolygons:(NSArray *) polygons name:(NSString *)name type:(NSString *)type metadata:(NSDictionary *)metadata set:(NSString *)set;

+ (Boundary *)boundaryWithBoundaryServiceDictionary:(NSDictionary *)boundaryServiceDictionary;
+ (Boundary *)boundaryWithBoundaryServiceDictionaryQGISFormat:(NSDictionary *)boundaryServiceDictionary andDistrictType:(NSString *)districtType;
+ (NSDictionary *) buildBoundaryDictionaryWithJSONFile:(NSString *)jsonFilename;
+ (NSDictionary *) buildBoundaryDictionaryWithJSONFileFromQGISExport:(NSString *)jsonFilename andDistrictType:(NSString *)districtType;

-(void) addPolygons:(NSMutableArray *)polygons;
-(BOOL)pointInside:(CLLocationCoordinate2D )point;

@property (nonatomic, readonly) NSMutableArray *polygons;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) NSString *set;
@property (nonatomic, readonly) NSDictionary *metadata;
@property (nonatomic, strong) UIColor *color;

@end
