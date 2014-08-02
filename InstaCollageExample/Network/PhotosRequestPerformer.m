//
//  PhotosRequestPerformer.m
//  InstaCollageExample
//
//  Created by Ivan Vavilov on 02/08/14.
//

#import "PhotosRequestPerformer.h"

//////////////////////////////////////////////////////////////////////////////

static NSString* const kDataKey = @"data";
static NSString* const kIdentifierKey = @"id";
static NSString* const kImagesKey = @"images";
static NSString* const kThumbnailKey = @"thumbnail";
static NSString* const kUrlKey = @"url";
static NSString* const kUsersUrl = @"https://api.instagram.com/v1/users/";
static NSString* const kSearchParameter = @"search?q=";
static NSString* const kClientIdKey = @"client_id=e6048deff0254329a2c0e09c4333f8b2";
static NSString* const kRecentKey = @"/media/recent/";

//////////////////////////////////////////////////////////////////////////////

@implementation PhotosRequestPerformer

+(id) sharedInstance
{
    static PhotosRequestPerformer *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

-(NSArray *) getImagesForUserName:(NSString *) username
{
    NSString *userIdentifier = [self getUserIdentifierForName:username];
    return userIdentifier ? [self fetchMediaForUser:userIdentifier] : nil;
}

-(NSString *) getUserIdentifierForName:(NSString *) username
{
    NSArray *urlComponents = [[NSArray alloc] initWithObjects:kUsersUrl, kSearchParameter, username, @"&", kClientIdKey, nil];
    NSString *urlForUsers = [urlComponents componentsJoinedByString:@""];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlForUsers]];
    [request setHTTPMethod:@"GET"];

    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;

    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&responseCode
                                                             error:&error];

    if (!error) {
        NSLog(@"%@, code:%@", error, responseCode);
        return nil;
    }

    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:0
                                                               error:nil];
    return response[kDataKey][0][kIdentifierKey];
}

-(NSArray *) fetchMediaForUser:(NSString *) userIdentifier
{
    NSArray *urlComponentsForRecentPhotos = [[NSArray alloc] initWithObjects:kUsersUrl, userIdentifier, kRecentKey, @"?", kClientIdKey, nil];
    NSString *urlForRecentPhotos = [urlComponentsForRecentPhotos componentsJoinedByString:@""];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlForRecentPhotos]];
    [request setHTTPMethod:@"GET"];

    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;

    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&responseCode
                                                             error:&error];
    if (!error) {
        NSLog(@"%@, code:%ld", error, (long)[responseCode statusCode]);
        return nil;
    }

    return [self getImagesFromResponse:responseData];
}

-(NSArray *) getImagesFromResponse:(NSData *) responseData
{
    NSMutableArray* images = [@[] mutableCopy];

    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:0
                                                               error:nil];
    NSArray*photoDataArray = response[kDataKey];

    for (NSDictionary* photoData in photoDataArray) {
        NSString* imageURL = photoData[kImagesKey][kThumbnailKey][kUrlKey];
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];

        [images addObject:image];
    }

    return images;
}

@end

//////////////////////////////////////////////////////////////////////////////