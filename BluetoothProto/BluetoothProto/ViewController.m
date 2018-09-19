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
    
    // TODO Consider setting the options on this call.
    centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
}

// MARK: - CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSString *name = @"Unnamed";
    if (peripheral.name != nil)
        name = peripheral.name;
    
    NSLog(@"Discovered %@", name);
}

- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
    switch (central.state) {
        case CBManagerStateUnsupported:
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Bluetooth Not Supported" message:@"Bluetooth is not supported on this device." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *acknowledgeAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:acknowledgeAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            break;
        case CBManagerStatePoweredOn:
            // TODO Consider setting the options on this call.
            // TODO Should I do this in this switch statement, or it best to do it somewhere else?
            [centralManager scanForPeripheralsWithServices:nil options:nil];
            break;
        default:
            break;
    }
}

@end
