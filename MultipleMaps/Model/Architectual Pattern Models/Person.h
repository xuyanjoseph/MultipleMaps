//
//  Person.h
//  MultipleMaps
//
//  Created by dev on 2018/8/17.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

- (void)initWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andBirthDate:(NSString *)birthDate;

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *birthDate;

@end
