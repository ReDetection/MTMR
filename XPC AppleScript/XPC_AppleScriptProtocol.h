//
//  XPC_AppleScriptProtocol.h
//  XPC AppleScript
//
//  Created by Serg Buglakov on 26/05/2018.
//  Copyright © 2018 Anton Palgunov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XPC_AppleScriptProtocol

- (void)runAppleScript:(nonnull NSString *)source withReply:(void (^ _Nullable)(NSString * _Nullable))reply;
    
@end

/*
 To use the service from an application or other process, use NSXPCConnection to establish a connection to the service by doing something like this:

     _connectionToService = [[NSXPCConnection alloc] initWithServiceName:@"Toxblh.MTMR.XPC-AppleScript"];
     _connectionToService.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(XPC_AppleScriptProtocol)];
     [_connectionToService resume];

Once you have a connection to the service, you can use it like this:

     [[_connectionToService remoteObjectProxy] upperCaseString:@"hello" withReply:^(NSString *aString) {
         // We have received a response. Update our text field, but do it on the main thread.
         NSLog(@"Result string was: %@", aString);
     }];

 And, when you are finished with the service, clean up the connection like this:

     [_connectionToService invalidate];
*/
