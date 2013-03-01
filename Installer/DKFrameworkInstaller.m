//
//  DKInstaller.m
//  Dark
//
//  Created by Erwan Barrier on 8/11/12.
//  Copyright (c) 2012 Erwan Barrier. All rights reserved.
//

#import "DKFrameworkInstaller.h"
#include <syslog.h>


NSString *const DKFrameworkDstPath = @"/Library/Frameworks/mach_inject_bundle.framework";

@implementation DKFrameworkInstaller

@synthesize error = _error;

- (BOOL)installFramework:(NSString *)frameworkPath {
    // Disarm timer while installing framework
    //dispatch_source_set_timer(g_timer_source, DISPATCH_TIME_FOREVER, 0llu, 0llu);
    
    NSError *fileError;
    BOOL result = YES;
    
    syslog(LOG_NOTICE, "INSTALLING FRAMEWORK: from helper tool");
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:DKFrameworkDstPath] == YES) {
        result = [[NSFileManager defaultManager] removeItemAtPath:DKFrameworkDstPath error:&fileError];

        syslog(LOG_NOTICE, "INSTALLING FRAMEWORK: removing original framework");
    }
    
    if (result == YES) {
        result = [[NSFileManager defaultManager] copyItemAtPath:frameworkPath toPath:DKFrameworkDstPath error:&fileError];
        syslog(LOG_NOTICE, "INSTALLING FRAMEWORK: copyItemAtPath");
    }
    
    if (result == NO) {
        _error = fileError;
    }
    
    // Rearm timer
    //dispatch_time_t t0 = dispatch_time(DISPATCH_TIME_NOW, 5llu * NSEC_PER_SEC);
    //dispatch_source_set_timer(g_timer_source, t0, 0llu, 0llu);
    
    return result;
}

@end
