//
//  RemoteServerInterface.h
//  Encoder Demo
//
//  Created by Matthew Hessing on 12/15/14.
//  Copyright (c) 2014 Geraint Davies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoteServerInterface : NSObject

// dispatcher
// connect
// dispatcher --> trigger
// {
//      frame: { data: byte[],
//               castId: number }
// }

+ (id)sharedInstance;
- (void)sendFrame:(NSArray *)frame pts:(double)pts;
- (void)triggerMessagesIndex;

@end
