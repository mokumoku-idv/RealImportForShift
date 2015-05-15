//
//  Area.h
//  RealmForShotAlert
//
//  Created by 平塚　俊輔 on 2/24/15.
//  Copyright (c) 2015 平塚　俊輔. All rights reserved.
//

#import <Realm/Realm.h>


//V1
@class Area;

@interface Pref : RLMObject
@property NSString   *PrefCode;
@property NSString   *PrefName;
@property Area   *area;
@property NSInteger  id;

@end

RLM_ARRAY_TYPE(Pref)

@interface Area : RLMObject
// Add properties here to define the model
@property NSString   *AreaCode;
@property NSString   *AreaName;
@property RLMArray<Pref> *prefs;
@property NSInteger  id;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<Person>
RLM_ARRAY_TYPE(Area)

