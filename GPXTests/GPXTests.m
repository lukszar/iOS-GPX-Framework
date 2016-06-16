//
//  GPXTests.m
//  GPXTests
//
//  Created by 俊紀 渡辺 on 12/04/06.
//  Copyright (c) 2012年 _MyCompanyName_. All rights reserved.
//

#import "GPXTests.h"
#import "GPX.h"

@implementation GPXTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testGPX
{
    NSString *path = [[NSBundle bundleForClass:[GPXParser class]] pathForResource:@"mystic_basin_trail" ofType:@"gpx"];

    GPXRoot *root = [GPXParser parseGPXAtPath:path];
    
    // gpx
    XCTAssertNotNil(root);
    XCTAssertEqualObjects(root.creator, @"ExpertGPS 1.1b1 - http://www.topografix.com");

    // gpx > metadata
    GPXMetadata *metadata = root.metadata;
    XCTAssertNotNil(metadata);
    XCTAssertEqualObjects(metadata.name, @"Mystic River Basin Trails");
    XCTAssertEqualObjects(metadata.desc, @"Both banks of the lower Mystic River have paved trails, allowing for a short and a long loop along the water.  The short loop is a two mile trail with no road crossings.  The long loop adds side-trips out to Draw Seven Park and the MBTA yard at Wellington Station, but crosses the six lanes of Route 28 twice.");

    GPXAuthor *author = metadata.author;
    XCTAssertNotNil(author);
    XCTAssertEqualObjects(author.name, @"Dan Foster");
    GPXEmail *authorEmail = author.email;
    XCTAssertNotNil(authorEmail);
    XCTAssertEqualObjects(authorEmail.emailID, @"trails");
    XCTAssertEqualObjects(authorEmail.domain, @"topografix.com");
    GPXLink *authorLink = author.link;
    XCTAssertNotNil(authorLink);
    XCTAssertEqualObjects(authorLink.href, @"http://www.tufts.edu/mystic/amra/pamphlet.html");
    XCTAssertEqualObjects(authorLink.text, @"Lower Mystic Basin Trails");
    
    GPXCopyright *copyright = metadata.copyright;
    XCTAssertNotNil(copyright);
    XCTAssertEqualObjects(copyright.author, @"Dan Foster");
    XCTAssertEqualObjects(copyright.license, @"http://creativecommons.org/licenses/by/2.0/");
    
    GPXLink *link = metadata.link;
    XCTAssertNotNil(link);
    XCTAssertEqualObjects(link.href, @"http://www.topografix.com/gpx.asp");
    XCTAssertEqualObjects(link.text, @"GPX site");
    XCTAssertEqualObjects(link.mimetype, @"text/html");
    
    // gpx > wpt
    XCTAssertEqual((NSInteger)root.waypoints.count, (NSInteger)23);
    
    GPXWaypoint *waypoint;

    waypoint = [root.waypoints objectAtIndex:0];
    XCTAssertEqual((float)waypoint.latitude, 42.398167f);
    XCTAssertEqual((float)waypoint.longitude, -71.083339f);
    XCTAssertEqualObjects(waypoint.name, @"205A");
    XCTAssertEqualObjects(waypoint.desc, @"Concrete platform looking out onto the Mystic.\nWhile you take in the view, try not to think about the fact that you're standing on top of MWRA Wet Water Discharge Outflow #205A");

    waypoint = [root.waypoints objectAtIndex:2];
    XCTAssertEqual((float)waypoint.latitude, 42.398467f);
    XCTAssertEqual((float)waypoint.longitude, -71.090467f);
    XCTAssertEqualObjects(waypoint.name, @"BLESSING");
    XCTAssertEqualObjects(waypoint.desc, @"The Blessing of the Bay Boathouse, now run by the Somerville Boys and Girls Club.\nA dock with small boats for the children of Somerville.  Check out the Mystic River mural at the intersection of Shore Drive and Rt 16!");
    XCTAssertEqual((int)waypoint.links.count, (int)1);
    GPXLink *waypointLink = [waypoint.links objectAtIndex:0];
    XCTAssertEqualObjects(waypointLink.href, @"http://www.everydaydesign.com/ourtown/bay.html");
    XCTAssertEqualObjects(waypointLink.text, @"Boat-building on the Mystic River");

    waypoint = [root.waypoints objectAtIndex:22];
    XCTAssertEqual((float)waypoint.latitude, 42.395889f);
    XCTAssertEqual((float)waypoint.longitude, -71.077949f);
    XCTAssertEqualObjects(waypoint.name, @"YACHT CLUB");
    XCTAssertEqualObjects(waypoint.desc, @"Winter Hill Yacht Club");

    // gpx > rte
    XCTAssertEqual((NSInteger)root.routes.count, (NSInteger)2);

    GPXRoute *route;
    GPXRoutePoint *routepoint;
    
    route = [root.routes objectAtIndex:0];
    XCTAssertEqualObjects(route.name, @"LONG LOOP");
    XCTAssertEqualObjects(route.desc, @"The long loop around the Mystic River, with stops at Draw Seven Park and the MBTA yard at Wellington Station (Orange Line).  Crosses Route 28 twice");
    XCTAssertEqual((NSInteger)route.number, (NSInteger)1);
    XCTAssertEqual((NSInteger)route.routepoints.count, (NSInteger)18);

    routepoint = [route.routepoints objectAtIndex:0];
    XCTAssertEqual((float)routepoint.latitude, 42.405495f);
    XCTAssertEqual((float)routepoint.longitude, -71.098364f);
    XCTAssertEqualObjects(routepoint.name, @"LOOP");
    XCTAssertEqualObjects(routepoint.desc, @"Starting point for the Mystic River loop trails.");

    routepoint = [route.routepoints objectAtIndex:9];
    XCTAssertEqual((float)routepoint.latitude, 42.400554f);
    XCTAssertEqual((float)routepoint.longitude, -71.079901f);
    XCTAssertEqualObjects(routepoint.name, @"WELL YACHT");
    XCTAssertEqualObjects(routepoint.desc, @"Mystic Wellington Yacht Club");

    routepoint = [route.routepoints objectAtIndex:17];
    XCTAssertEqual((float)routepoint.latitude, 42.405495f);
    XCTAssertEqual((float)routepoint.longitude, -71.098364f);
    XCTAssertEqualObjects(routepoint.name, @"LOOP");
    XCTAssertEqualObjects(routepoint.desc, @"Starting point for the Mystic River loop trails.");
    
    route = [root.routes objectAtIndex:1];
    XCTAssertEqualObjects(route.name, @"SHORT LOOP");
    XCTAssertEqualObjects(route.desc, @"Short Mystic River loop.\nThis loop circles the portion of the Mystic River enclosed by Routes 93, 16, and 28.  It's short, but you can do the entire loop without crossing any roads.");
    XCTAssertEqual((NSInteger)route.number, (NSInteger)3);
    XCTAssertEqual((NSInteger)route.routepoints.count, (NSInteger)8);
    
    routepoint = [route.routepoints objectAtIndex:0];
    XCTAssertEqual((float)routepoint.latitude, 42.405495f);
    XCTAssertEqual((float)routepoint.longitude, -71.098364f);
    XCTAssertEqualObjects(routepoint.name, @"LOOP");
    XCTAssertEqualObjects(routepoint.desc, @"Starting point for the Mystic River loop trails.");

    routepoint = [route.routepoints objectAtIndex:3];
    XCTAssertEqual((float)routepoint.latitude, 42.399733f);
    XCTAssertEqual((float)routepoint.longitude, -71.083567f);
    XCTAssertEqualObjects(routepoint.name, @"RT 28");
    XCTAssertEqualObjects(routepoint.desc, @"Wellington Bridge\nRoute 28 crosses the Mystic River on this 6 lane bridge.  Pedestrian walkways on both sides.  Access to the Assembly Square mall is at the south end of the bridge.");

    routepoint = [route.routepoints objectAtIndex:7];
    XCTAssertEqual((float)routepoint.latitude, 42.405495f);
    XCTAssertEqual((float)routepoint.longitude, -71.098364f);
    XCTAssertEqualObjects(routepoint.name, @"LOOP");
    XCTAssertEqualObjects(routepoint.desc, @"Starting point for the Mystic River loop trails.");

    // gpx > trk
    XCTAssertEqual((NSInteger)root.tracks.count, (NSInteger)3);
    
    GPXTrack *track;
    GPXTrackSegment *tracksegment;
    GPXTrackPoint *trackpoint;
    
    track = [root.tracks objectAtIndex:0];
    XCTAssertEqualObjects(track.name, @"LONG TRACK");
    XCTAssertEqualObjects(track.desc, @"Tracklog from Long Loop");
    XCTAssertEqual((NSInteger)track.number, (NSInteger)2);
    XCTAssertEqual((NSInteger)track.tracksegments.count, (NSInteger)1);
    tracksegment = [track.tracksegments objectAtIndex:0];
    XCTAssertEqual((NSInteger)tracksegment.trackpoints.count, (NSInteger)166);
    trackpoint = [tracksegment.trackpoints objectAtIndex:0];
    XCTAssertEqual((float)trackpoint.latitude, 42.405488f);
    XCTAssertEqual((float)trackpoint.longitude, -71.098173f);
    trackpoint = [tracksegment.trackpoints objectAtIndex:82];
    XCTAssertEqual((float)trackpoint.latitude, 42.399266f);
    XCTAssertEqual((float)trackpoint.longitude, -71.083581f);
    trackpoint = [tracksegment.trackpoints objectAtIndex:165];
    XCTAssertEqual((float)trackpoint.latitude, 42.405703f);
    XCTAssertEqual((float)trackpoint.longitude, -71.098065f);

    track = [root.tracks objectAtIndex:1];
    XCTAssertEqualObjects(track.name, @"SHORT TRACK");
    XCTAssertEqualObjects(track.desc, @"Bike path along the Mystic River in Medford.\nThe trail runs along Interstate 93 to Shore Road.  It then crosses the Mystic on the Route 38 bridge near the Assembly Square mall.  After the bridge, the trail cuts through the high meadow grass behind the State Police barracks, and enters Torbert McDonald Park.  Leaving the park, the trail passes the Meadow Glen mall before crossing back over the Mystic on the Rt 16 bridge.");
    XCTAssertEqual((NSInteger)track.number, (NSInteger)4);
    XCTAssertEqual((NSInteger)track.tracksegments.count, (NSInteger)1);
    tracksegment = [track.tracksegments objectAtIndex:0];
    XCTAssertEqual((NSInteger)tracksegment.trackpoints.count, (NSInteger)95);
    trackpoint = [tracksegment.trackpoints objectAtIndex:0];
    XCTAssertEqual((float)trackpoint.latitude, 42.405381f);
    XCTAssertEqual((float)trackpoint.longitude, -71.098108f);
    trackpoint = [tracksegment.trackpoints objectAtIndex:48];
    XCTAssertEqual((float)trackpoint.latitude, 42.403944f);
    XCTAssertEqual((float)trackpoint.longitude, -71.085405f);
    trackpoint = [tracksegment.trackpoints objectAtIndex:94];
    XCTAssertEqual((float)trackpoint.latitude, 42.405660f);
    XCTAssertEqual((float)trackpoint.longitude, -71.098280f);


    track = [root.tracks objectAtIndex:2];
    XCTAssertEqualObjects(track.name, @"TUFTS CONNECT");
    XCTAssertEqualObjects(track.desc, @"Connecting route from Tufts Park to beginning of Mystic Basin loop trail.");
    XCTAssertEqual((NSInteger)track.number, (NSInteger)5);
    XCTAssertEqual((NSInteger)track.tracksegments.count, (NSInteger)1);
    tracksegment = [track.tracksegments objectAtIndex:0];
    XCTAssertEqual((NSInteger)tracksegment.trackpoints.count, (NSInteger)24);
    trackpoint = [tracksegment.trackpoints objectAtIndex:0];
    XCTAssertEqual((float)trackpoint.latitude, 42.402356f);
    XCTAssertEqual((float)trackpoint.longitude, -71.107807f);
    trackpoint = [tracksegment.trackpoints objectAtIndex:11];
    XCTAssertEqual((float)trackpoint.latitude, 42.405317f);
    XCTAssertEqual((float)trackpoint.longitude, -71.103923f);
    trackpoint = [tracksegment.trackpoints objectAtIndex:23];
    XCTAssertEqual((float)trackpoint.latitude, 42.405424f);
    XCTAssertEqual((float)trackpoint.longitude, -71.098173f);
}

@end
