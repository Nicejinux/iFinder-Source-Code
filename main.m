//
// MyFile & iFinder
//
// Created by Árpád Goretity, 2011.
// Improved by Itay.
//
#import "MFAppDelegate.h"

int main (int argc, char **argv) {

        //setgid(0);
        NSAutoreleasePool *mainPool = [[NSAutoreleasePool alloc] init];
        int exitCode = UIApplicationMain(argc, argv, nil, @"MFAppDelegate");
        [mainPool release];

        return exitCode;

}

