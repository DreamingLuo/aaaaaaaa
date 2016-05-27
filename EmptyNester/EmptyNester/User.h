//
//  User.h
//  
//
//  Created by shao on 16/5/27.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString *love;
@property (nonatomic, retain) NSNumber * telephone;

@end

NS_ASSUME_NONNULL_END

