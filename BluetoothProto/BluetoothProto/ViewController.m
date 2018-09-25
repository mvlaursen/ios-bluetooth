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
    NSSet *discoveredPeripherals;
    NSString *discoveryReport;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO Consider setting the options on this call.
    centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    discoveredPeripherals = [NSSet set];
    discoveryReport = @"Discovered Peripherals\n";
}

// MARK: - CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    if (![discoveredPeripherals containsObject:peripheral]) {
        discoveredPeripherals = [discoveredPeripherals setByAddingObject:peripheral];
        
        NSString *peripheralAddress = [NSString stringWithFormat:@"%p", peripheral];

        NSString *peripheralName = @"Unnamed";
        if (peripheral.name != nil)
            peripheralName = peripheral.name;
    
        NSString *localName = @"No local name";
        NSObject *localNameValue = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
        if (localNameValue != nil)
            localName = (NSString *) localNameValue;
        
        discoveryReport = [discoveryReport stringByAppendingString:[NSString stringWithFormat:@"\n%@ %@ %@ %@", peripheralAddress, peripheralName, localName, RSSI]];
        [_textView setText:discoveryReport];
        
        [centralManager connectPeripheral:peripheral options:nil];
    }
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

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

// MARK :- CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    for (CBCharacteristic *characteristic in service.characteristics) {
        [peripheral readValueForCharacteristic:characteristic];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    discoveryReport = [discoveryReport stringByAppendingString:[NSString stringWithFormat:@"\n===> Perihperhal: %p ==> Characteristic: %@ ==> Value: %@", peripheral, characteristic, characteristic.value]];
}

@end
