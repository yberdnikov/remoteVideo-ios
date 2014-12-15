//
//  RemoteServerInterface.m
//  Encoder Demo
//
//  Created by Matthew Hessing on 12/15/14.
//  Copyright (c) 2014 Geraint Davies. All rights reserved.
//

#import "RemoteServerInterface.h"
#import "WebSocketRailsDispatcher.h"

#define PEERFUL_TEST_SERVER     @"ws://mobile-cast.herokuapp.com/websocket"
#define PEERFUL_TEST_ROOM_ID    @"5440667a3634660011000000"

@interface RemoteServerInterface()
@property (strong, nonatomic) WebSocketRailsDispatcher *mDispatcher;
@end

@implementation RemoteServerInterface

#pragma mark - Singleton Implementation

static id __instance = nil;
+ (id)sharedInstance
{
    if( !__instance ) {
        __instance = [[RemoteServerInterface alloc] init];
    }
    
    return __instance;
}

#pragma mark - Instantiation

- (id)init
{
    if( (self = [super init]) )
    {
        // JOSH
        self.mDispatcher = [[WebSocketRailsDispatcher alloc] initWithUrl:[NSURL URLWithString:PEERFUL_TEST_SERVER]];
        
        [self.mDispatcher bind:@"connection_opened" callback:^(id data) {
            NSLog(@"connection opened callback");
        }];
        
        [self.mDispatcher connect];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSLog(@"trigger");
//            [self triggerMessagesIndex];
//        });

    }
    
    return self;
}

#pragma mark - External Interface

- (void)sendFrame:(NSArray *)frame pts:(double)pts
{
    // dispatcher --> trigger
    // {
    //      frame: { data: byte[],
    //               castId: number }
    // }
    // JOSH
    NSDictionary *sendableDict = @{ @"frame" : @{ @"data" : frame,
                                                  @"cast_id" : PEERFUL_TEST_ROOM_ID }
                                  };

    [self.mDispatcher trigger:@"frames.create"
                         data:sendableDict
                      success:^(id data)
                      {
                        NSLog(@"send success!");
                      }
                      failure:^(id data)
                      {
                          NSLog(@"send fail!");
                      }];
}

- (void)triggerMessagesIndex
{
    // JOSH
    NSDictionary *sendableDict = @{ @"cast_id" : PEERFUL_TEST_ROOM_ID };
    [self.mDispatcher trigger:@"messages.index"
                         data:sendableDict
                      success:^(id data)
     {
         NSLog(@"send success!");
     }
                      failure:^(id data)
     {
         NSLog(@"send fail!");
     }];

}


@end
