/*!
 @header IDeviceManager.h
 @abstract DeviceManager各类协议的合集
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */
#import <Foundation/Foundation.h>
#import "IDeviceManagerProximitySensor.h"
#import "IDeviceManagerMedia.h"

/*!
 @protocol
 @brief DeviceManager各类协议的合集
 @discussion
 */
@protocol IDeviceManager <IDeviceManagerMedia,
                        IDeviceManagerProximitySensor>

@required

@end
