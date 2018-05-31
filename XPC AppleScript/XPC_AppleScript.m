//
//  XPC_AppleScript.m
//  XPC AppleScript
//
//  Created by Serg Buglakov on 26/05/2018.
//  Copyright © 2018 Anton Palgunov. All rights reserved.
//

#import "XPC_AppleScript.h"

static dispatch_queue_t scriptQueue;

@interface XPC_AppleScript()
@property (nonatomic, nullable, strong) NSAppleScript *script;
@property (nonatomic, nullable, strong) NSString *lastSource;
@end

@implementation XPC_AppleScript

- (void)runAppleScript:(nonnull NSString *)source withReply:(void (^ _Nullable)(NSString * _Nullable))reply {
    NSLog(@"script %p, sourcehash %lu, source: %@", self, (unsigned long)source.hash, [source substringToIndex:50]);
    if (![self.lastSource isEqual:source]) {
        self.script = nil;
        self.lastSource = nil;
        NSLog(@"cache fail: %lu, %lu", self.lastSource.hash, (unsigned long)source.hash);
    }
    if (scriptQueue == nil) {
        scriptQueue = dispatch_queue_create("apple script queue", 0);
    }
    dispatch_async(scriptQueue, ^{
        NSDictionary<NSString *, id> *errorDict = nil;
        if (self.script == nil) {
            self.script = [[NSAppleScript alloc] initWithSource:source];
            [self.script compileAndReturnError:&errorDict];
            self.lastSource = source;
        }
        if (errorDict == nil) {
            NSAppleEventDescriptor *result = [self.script executeAndReturnError:&errorDict];
            reply(result.stringValue);
        } else {
            reply(nil);
        }
    });
}

@end
