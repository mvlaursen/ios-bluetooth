//
//  ViewController.m
//  BluetoothProto
//
//  Created by Mike Laursen on 9/19/18.
//  Copyright © 2018 Appamajigger. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController {
    CBCentralManager *centralManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO Consider setting the options in this call.
    centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
}

// MARK: - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
    switch (central.state) {
        case CBManagerStatePoweredOn:
            [centralManager scanForPeripheralsWithServices:nil options:nil];
            break;
        case CBManagerStateUnsupported:
            printf("Bluetooth is unsupported.");
            break;
        default:
            break;
    }
}

@end
