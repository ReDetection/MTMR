//
//  XPC_AppleScript.h
//  XPC AppleScript
//
//  Created by Serg Buglakov on 26/05/2018.
//  Copyright © 2018 Anton Palgunov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XPC_AppleScriptProtocol.h"

// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
@interface XPC_AppleScript : NSObject <XPC_AppleScriptProtocol>
@end
